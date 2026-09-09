# RFC‑2362 — Trust Domains and Authority Policy

*SolNet Standards Corpus — multi-institutional authorship*

**Status:** Normative — Standards Track. A styled HTML rendering of this
document for human readers is maintained at
`docs/rfc-html/RFC-2362-Trust-Domains-and-Authority-Policy.html`.

---

### 0. Document Preface

*SolNet Standards Working Group*

There is no global certificate authority anyone actually trusts. There was, once, on paper. Then the founding-era chain fragmented across the UN, the Belt, Mars, and the corporate leases — not to mention Ganymede and the system's other shared outposts, which had the misfortune of not fitting cleanly under any of the four and have been arguing about it ever since — and every one of those four kept a working root of authority while agreeing on almost nothing about what a root of authority is supposed to look like.

This RFC exists because "trust must be explicit and auditable" is a nice sentence to put in a charter, and somebody eventually has to write down what it actually means when the four parties in the room don't even agree on whether "authority" implies a key, a vote, a token, or a paid-up account.

This document does not pick a winner. It defines **TrustDomain**: a named, policy-bearing boundary that declares, honestly, which of a small number of root attestation models it actually runs on — and it stops there. What happens inside that boundary is the domain's own business, the same way this Working Group has never told the UN how to run its cert chain internally or Mars how to mint a fob. What happens at the boundary, when one domain has to decide whether to believe another, is this RFC's actual subject.

A brief technical note for readers who've been tracking the corpus's own open questions: RFC‑2302's `AnchorRecord`[^1] assumes a persistent Anchor Key (AK)[^2], because it was drafted against Earthstock's model without anyone stopping to ask whether every lineage has one. Not every lineage does. Section 2 fixes that — not by replacing `AnchorRecord`, which stays exactly right for the case it was built for, but by refusing to pretend it was ever meant to be the only case.

This Working Group has reviewed the alternative — generalizing `AnchorRecord` until it's flexible enough to fake having a key it doesn't have — and found it unpersuasive, for the same reason a field that can mean anything ends up meaning nothing in particular.

---

### 1. Purpose and Scope

*SolNet Standards Working Group*

RFC‑2352 already coined the term this RFC formalizes: "Trust Domain — a logical grouping of devices under shared policy." That definition stands. This RFC doesn't replace it, extend it into something incompatible, or discover it needs correcting — it's the RFC that was always supposed to exist underneath it, giving that grouping an actual record shape, an actual registry entry, and actual rules for what happens when two of them have to deal with each other.

The alternative was leaving "shared policy" to mean whatever each implementer felt like that week. This Working Group has reviewed how that went. It went the way these things go.

This RFC defines:

- The **TrustDomain** record and its declared **root attestation model**[^3] (Section 2) — the fix for the AnchorRecord-assumes-an-AK problem.
- The canonical meaning of **TrustTag**[^4] values 0–15 (Section 3), which RFC‑2350 §5.5 reserved for this document by name and has been sitting unassigned since.
- Cross-cert chain construction and scoped delegation between domains (Section 4).
- Where trust-domain policy actually gets consulted elsewhere in the stack — L1 admission, DRE trust decisions, ServicePlane session establishment (Section 5) — without this RFC itself defining new wire fields at those layers.
- Cross-domain revocation and emergency unbinding propagation (Section 6).
- The dispute and liability process for when two domains disagree about whether a boundary crossing was handled correctly (Section 7).

This RFC does not define: how any single domain governs itself internally (the UN's institutional CA process, the Belt union's own quorum bylaws, Mars's capability-minting ceremony, a corporation's leasing contract terms) — those stay exactly as politically diverged as they've always been, and nothing here is a backdoor attempt to standardize them into looking the same.

This Working Group has no plans to start caring how Mars runs its minting ceremony, and no plans to pretend otherwise for the sake of a tidier document.

---

### 2. The Root Attestation Model

*SolNet Standards Working Group + Canonical Address Registrar*

A **TrustDomain** record declares four things: a `domain_id`, a `TrustTag` (Section 3), a **root attestation model**, and an `authority_reference` pointing to whatever construct actually functions as the root within that model. The root attestation model is the field this corpus has been missing.

It is one of exactly four values, not five, and not a spectrum in between — a jury-rigged Belter skiff, a Martian orbital array, and an Earth-side system waiting on its third approval signature do not share a root of authority, and no number of optional fields on `AnchorRecord` was ever going to make that true:

| Model | Root of authority is… | Record shape the authority_reference points to | Canonical example |
|---|---|---|---|
| `CHAIN_OF_CUSTODY` | A persistent Anchor Key, bound via NetworkCert[^5] (RFC‑2301) | `AnchorRecord` (RFC‑2302, unchanged) | Earthstock |
| `QUORUM_WITNESS` | N co-signatures from a defined member set, no persistent key implied | `WitnessQuorumRecord` (new, this RFC) | Scrapshell / Belt union stations |
| `CAPABILITY_TOKEN` | Physical possession of an unforgeable, minting-time-issued token | `CapabilityMintRecord` (new, this RFC) | Mars capability-fork |
| `LEASED_ENTITLEMENT` | A revocable grant from a remote licensing authority, cached locally | `EntitlementGrantRecord` (new, this RFC) | Corporate leased-compute |

This is not a fifth model waiting to be invented for symmetry's sake. It is the four root models each lineage already runs under separately, named here so the rest of the corpus has a field to point at instead of re-deriving them per RFC.

A domain declares exactly one model. A domain that declares more than one has not discovered a hybrid architecture. It has discovered a bug, and this Working Group would prefer to hear about it from the domain rather than from whoever gets burned by it first. A domain is not required to explain its internal governance beyond that declaration — a receiving domain needs to know it's dealing with a quorum-witness domain to reason about it correctly; it does not need Scrapshell's union bylaws.

#### 2.1 AnchorRecord Is Not Deprecated, It Is Scoped

`AnchorRecord` (RFC‑2302) remains the correct, unmodified record type for any `CHAIN_OF_CUSTODY` domain. Nothing about this section asks Earthstock-model deployments to change anything. What changes is that `AnchorRecord` stops being asked, implicitly, to also describe domains it was never built to describe.

A `QUORUM_WITNESS` domain populating an `AnchorRecord`'s AK field with a placeholder value to satisfy a schema that assumes one exists is not compliance. It's a domain lying about having a root it doesn't have, which is precisely the failure mode this section exists to close. One early submission handled this by writing in a placeholder key and calling it "good enough for now." It was not good enough for now, and this Working Group has since made a point of checking for exactly that pattern.

> A domain that has a key can prove it. A domain that doesn't shouldn't have to pretend.

#### 2.2 WitnessQuorumRecord, CapabilityMintRecord, EntitlementGrantRecord

Full field-level encoding for these three new record types is deferred to an errata pass once a schema owner is assigned — this draft fixes their *existence* and their *minimum semantic content*, not their wire format:

- **WitnessQuorumRecord** — member set reference (the trust domain's own recognized representative body, not any single station's logged-in crew), quorum threshold N, the N actual co-signatures for a specific domain-anchor claim event, and a TTL. Carries no persistent authority key. Same shape, same math, as the local `claim root --union-vote` mechanic any given Scrapshell station already runs on its own — this RFC does not touch that mechanic at all. It gives the domain-scale version of the same idea its own name and its own record, precisely so the two are never mistaken for each other.
- **CapabilityMintRecord** — token identity, the minting event's own authority reference (the lineage's actual commissioning authority — a fleet office or shipyard running the ceremony, not any single relay's own fob), and scope. No revocation-by-signature; a capability token is revoked by physical recovery or destruction, which Section 6 addresses. A single relay's fob authorizes actions on that relay. It says nothing whatsoever about the domain as a whole, and this record type does not pretend otherwise.
- **EntitlementGrantRecord** — grantor reference, entitlement scope, expiry, and an explicit field for the cached-grant fallback behavior (what a device does when it can't reach the licensing server) rather than leaving that behavior undocumented and vendor-specific. Corporate is the one lineage where this record barely needs the distinction drawn in Section 2.4 below: every device already requests its entitlement from the same central licensing authority, so there was never a separate local root available to mistakenly promote into a domain anchor in the first place.

#### 2.3 Cross-Model Consistency Requirement

A TrustDomain record's declared root attestation model MUST match the record type its `authority_reference` actually resolves to. A domain claiming `CHAIN_OF_CUSTODY` whose reference resolves to a `WitnessQuorumRecord` has produced a malformed TrustDomain record, not an unusual implementation of chain-of-custody trust, and MUST be treated as such by any consuming policy engine. This Working Group has already fielded the question of whether such a record could instead be read as "an innovative hybrid approach." It could not.

#### 2.4 Local Root Is Not Domain Root

A device's local root — whoever currently controls a specific console, relay, or terminal under that lineage's own admission mechanic — is not this document's subject, and does not, by itself, establish or elevate that device's standing within its lineage's trust domain. Winning a dockworker's vote at one Belt station proves who's in charge of that station. It proves nothing whatsoever about how the UN, Mars, or any other domain ought to weigh a credential claiming to speak for the Belt as a whole, and this Working Group has no interest in a record type that would let it.

The distinction matters because the two failure surfaces are wildly different sizes. A compromised local root is bad for one device and the people relying on it. A compromised domain root is bad for every device, relay, and credential that domain has ever vouched for — which is exactly why Section 6.2 makes a domain-wide emergency unbind deliberately hard to invoke, and that difficulty would mean nothing if a single station's routine local election could reach it by accident.

> Holding root on one machine is not a promotion. It's still just the one machine.

This holds for all four models, with one structural exception noted above: Corporate's `LEASED_ENTITLEMENT` was never decentralized to begin with, so there is no local root event on that side to mistakenly aggregate. The other three all have a real local mechanic (Section 3 of the lineage's own governing practice) that this RFC leaves entirely untouched, precisely by never letting it feed this record.

---

### 3. TrustTag Registry (Values 0–15)

*SolNet Standards Working Group*

RFC‑2350 §5.5 reserved TrustTag values 0–15 for Trust Domains defined here, and left values 16–255 to the Canonical Address Registrar's general allocation. This section is this RFC discharging that reservation. It is this document's own registry, not delegated to CAR — CAR's jurisdiction begins at 16. These sixteen values are fixed by this table. They are not a starting point for further creativity.

| TrustTag | Assignment | Root Model |
|---|---|---|
| 0 | Unassigned / self-asserted, no domain claimed | — |
| 1 | Earthstock primary trust domain | `CHAIN_OF_CUSTODY` |
| 2 | Belt / Scrapshell union trust domain | `QUORUM_WITNESS` |
| 3 | Mars capability-fork trust domain | `CAPABILITY_TOKEN` |
| 4 | Corporate leased-compute trust domain | `LEASED_ENTITLEMENT` |
| 5 | UN / neutral-territory trust domain (DRE-hosted neutral zones, shared backbone infrastructure) | Reserved — model TBD pending a UN-hosted deployment actually needing one |
| 6–9 | Reserved for lineage-internal sub-domains (e.g. a specific Earthstock jurisdiction, a specific Belt union local) requesting their own tag rather than inheriting their parent lineage's | Inherits parent unless separately declared |
| 10–15 | Reserved, unallocated | — |

TrustTag value 0 is not a null value in the sense of "error" or "absent." A node presenting TrustTag 0 has made an honest claim: it belongs to no declared trust domain. Consuming policy is free to treat that as maximally untrusted, but it MUST NOT be treated as malformed — a self-asserted, undeclared node is a real and legitimate category, not a parsing failure.

Implementers who find that unsatisfying are welcome to propose a fifth category. This Working Group will file the proposal next to the others it has already declined.

Allocation of values 6–15 to a specific sub-domain follows the same registration process CAR already runs for values 16–255 (RFC‑2350 §5.5), administered jointly with this RFC's custodian pending a formal Trust Domain Registrar role being assigned (see Appendix E).

This Working Group expects, based on registry experience elsewhere in this corpus, that at least one deployment will request a reserved value before finishing this section. That request will be handled in the order received, same as anyone else's.

---

### 4. Cross-Cert Chains and Delegation

*SolNet Standards Working Group*

Trust is not transitive by default, and this section is where that stops being a slogan and starts being a rule. Domain B recognizing that Domain A runs a `CHAIN_OF_CUSTODY` model does not mean Domain B recognizes any specific cert Domain A issues. Recognition requires Domain B to hold its own `PolicyRecord`[^6] (RFC‑2302) naming Domain A, or a specific cert chain from Domain A, as accepted — and that PolicyRecord is Domain B's decision to make and Domain B's decision to revoke, on its own timeline, for its own reasons.

Domains that have skipped this step did so out of convenience, said so afterward in the incident report, and were not, on review, found convincing.

A **CrossCertRecord**[^7] (RFC‑2302 §9) linking a credential from one domain to recognition in another is how that acceptance gets recorded once granted. It is not how trust gets created — the PolicyRecord decision comes first; the CrossCertRecord documents that the decision was made, by whom, and when, the same way any other ledger entry in this corpus documents an event rather than causing one.

#### 4.1 Scoped Delegation

A domain MAY delegate trust for a narrower scope than full cross-domain recognition — a single transaction, a single session, a single named credential — without that delegation implying anything about the domain's general posture toward the other. A Scrapshell station accepting one specific UN-issued cert for one specific docking negotiation, without thereby recognizing the UN's chain-of-custody model in general, is the ordinary case this RFC expects, not an edge case requiring special handling.

#### 4.2 Conflict Resolution

Where two TrustDomain-scoped claims conflict — two domains each claiming authority over the same UUID‑S7, or a cross-cert chain that resolves inconsistently depending on which domain's ledger is consulted — resolution follows RFC‑2302 §5's existing CONFLICT-state rules unchanged. This RFC adds no new conflict-resolution mechanism; it adds the vocabulary (root attestation model, TrustTag) that makes it possible to say precisely what kind of domains are in conflict, which is most of what makes a conflict resolvable at all rather than merely observed.

A conflict that can be named precisely gets resolved. A conflict that can only be gestured at gets a meeting, and this Working Group has attended enough of those already.

---

### 5. Policy Enforcement Points

*SolNet Standards Working Group*

This RFC defines the record types. It does not define new wire fields at other layers to carry them — those layers already have the hooks, and this section is where the seams get named rather than reinvented.

- **L1 admission (RFC‑2353).** AdmissionPolicyHint's coarse A0–A3 classes are, per the shared corpus glossary's own "Authority" entry, set by whichever institution or process constitutes "the Authority" for that deployment's trust domain — a question that entry explicitly deferred to this RFC. The answer: it's whatever `authority_reference` the deployment's TrustDomain record resolves to. RFC‑2353 itself is unchanged; this section is the promised resolution of a hook it deliberately left open. It took an entire separate RFC to answer a question the glossary posed in one sentence. This Working Group is aware of the irony and has elected not to dwell on it.
- **DRE trust decisions (RFC‑2363, pending).** A Directory and Routing Endpoint deciding whether to publish or serve a record on a requester's behalf consults the requester's TrustDomain the same way; full integration is RFC‑2363's job once drafted, not retroactively added here. This Working Group will not be issuing an interim workaround in the meantime, on the theory that an undrafted RFC is not improved by being drafted twice, badly, by two different documents.
- **ServicePlane session establishment.** Session-layer trust decisions (RFC‑2301 §5's session key negotiation) may consult a peer's TrustDomain as one input, same as any other policy input — this RFC does not make trust-domain membership a mandatory session precondition, only an available one.

---

### 6. Cross-Domain Revocation and Emergency Unbinding

*SolNet Standards Working Group*

There is no global CRL, so there is no such thing as a revocation that automatically propagates everywhere. A revocation inside Domain A propagates to Domain B only through whatever cross-cert or delegation relationship (Section 4) already connects them — and Domain B is responsible for its own revocation-checking cadence against that relationship, per RFC‑2301 §9's existing propagation and cache-invalidation requirements. This RFC does not weaken that; it clarifies that the relationship a revocation propagates *along* is now a named, recorded thing (a CrossCertRecord or a scoped delegation) rather than an implicit assumption.

A revocation that reaches nobody because nobody bothered to record the relationship it should have traveled along is not a mystery. It is exactly what was specified.

#### 6.1 Model-Specific Revocation

Revocation looks different per root attestation model, and this RFC does not force them to look the same:

- `CHAIN_OF_CUSTODY` — a signed RevocationRecord[^8] (RFC‑2302), unchanged.
- `QUORUM_WITNESS` — a fresh quorum vote to revoke a prior WitnessQuorumRecord's standing; there is no single key to revoke because there was never a single key.
- `CAPABILITY_TOKEN` — physical recovery or destruction of the specific token in question. Revoking one relay's fob says nothing about any other relay's fob, and nothing at all about the domain's own commissioning ceremony — those are separate compromises with separate remedies (Section 6.2). A capability domain's "revocation record" is, honestly, an after-the-fact log entry describing a physical event that already happened, not a mechanism that caused anything.
- `LEASED_ENTITLEMENT` — grantor-issued withdrawal, propagated whenever connectivity allows, falling back to local-clock-checked cached-grant expiry when it can't (the same honest, exploitable fallback already characteristic of this lineage's leasing model). A domain rolling its own clock back to keep a lapsed grant alive is not a bug this Working Group intends to fix. It is Corporate's model working exactly as specified, which is the most damning thing this Working Group has to say about it.

#### 6.2 Domain-Level Emergency Unbinding

RFC‑2301 §9 defines emergency unbind at the individual-AK level. This RFC extends the concept one level up: a domain-wide emergency unbind, for the case where an entire domain's root of authority is suspected compromised at scale — a UN CA breach, Mars's fleet commissioning ceremony itself compromised (not a stolen fob or two, which is a local incident each fob's own owner deals with, but the authority that mints fobs in the first place), or the Belt trust domain's own recognized-representative roster infiltrated wholesale (not any single station's crew list, which per Section 2.4 is a local matter and stays one). A domain-level unbind marks every credential issued under that domain's authority_reference as suspect pending re-issuance, rather than requiring each one to be individually flagged.

This is a heavier, rarer, more disruptive action than a single-credential revocation, and this RFC intentionally does not make it easy to invoke — the procedural threshold for declaring one is a cross-domain governance question, addressed in Appendix D, not a technical one this section resolves alone.

---

### 7. Cross-Domain Dispute and Liability

*UN Trust & Interoperability Governance Council*

This Council exists for the specific case where Domain A and Domain B each did what their own trust-domain policy required, and the outcome was still bad for someone. Sections 4 through 6 already establish what correct behavior looks like at a boundary crossing. This section is not about correct behavior. It is about what happens once both parties can plausibly claim they exhibited it.

Where a cross-domain credential is later found deficient — expired, improperly scoped, issued under a root attestation model the receiving domain misunderstood — responsibility is not assigned by this Council on the basis of which domain's technical claim was correct. It is assigned on the basis of which domain's PolicyRecord (Section 4) governed the acceptance decision at the time. A domain that accepted a credential it had no PolicyRecord basis for accepting bears the resulting liability, in full, regardless of whether the credential itself later proved valid.

This Council has reviewed enough incidents where a valid credential was accepted through an undocumented shortcut to consider "it worked out fine" an irrelevant defense.

#### 7.1 On the Question of Fault

This Council does not, as a rule, find that a domain's root attestation model was itself defective. Each of the four models in Section 2 is doctrinally sound within the conditions it was designed for; incidents arising from a domain's ordinary operation under its own declared model are, in this Council's language, **outcomes attributable to insufficient consideration of cross-domain scope** at the receiving domain, not defects in the originating domain's model. This distinction has occasionally proven difficult for an aggrieved party to accept in the moment. It has not, on further review, proven difficult for this Council to maintain.

#### 7.2 Referral

Where a dispute concerns the technical correctness of a cross-cert chain rather than the liability arising from it, this Council refers the technical question to the Canonical Behavior Registry or the relevant domain's own standards body, as such determinations fall outside this Council's purview. This Council's own findings address responsibility and remedy only, and are not a substitute for a technical conformance review conducted by a body actually equipped to perform one.

---

### 8. Doctrinal Alignment

*Doctrinal Integrity Council*

This document does not introduce a competing definition of Trust Domain. RFC‑2352 §41 already states the operative constraint this Council requires held: *"Trust‑domain membership SHALL NOT be inferable at Layer 1."* Nothing in Sections 2 through 7 touches Layer 1 wire behavior. TrustDomain records, root attestation models, and cross-cert chains live and are consulted at the Authority Plane; where their conclusions reach Layer 1 at all, they arrive only as the same coarse, non-exposing hints RFC‑2353 already governs (Section 5 above), never as a directly observable trust-domain identifier. A reader looking for a contradiction between this RFC and RFC‑2352 will not find one, because there was never a decision here for RFC‑2352 to conflict with in the first place.

This Council further notes that Section 2's core resolution — four named root attestation models rather than one assumed universal model — is itself an application of the invariance doctrine, not an exception to it. Invariance requires that protocol behavior not silently vary with unstated conditions. A corpus that let `AnchorRecord` stand in for every lineage's root of authority, while three of four lineages don't actually have the Anchor Key it assumes, was the unstated variation. Naming the four models is what invariance looks like once the thing varying is finally written down instead of pretended away.

---

### 9. Test Vectors

*SolNet Standards Working Group*

#### 9.1 TrustDomain Record Validation

A conforming implementation MUST be tested against, at minimum: (a) a TrustDomain record whose declared root attestation model matches its authority_reference's actual record type — MUST validate; (b) a mismatch between declared model and resolved record type (Section 2.3) — MUST be rejected as malformed; (c) TrustTag 0 presented with no authority_reference at all — MUST be accepted as a legitimate self-asserted/undeclared claim, not rejected as incomplete; (d) a TrustTag value in the 6–15 range with no registered sub-domain allocation — MUST be treated as inheriting the parent lineage's tag pending registration, not treated as invalid.

#### 9.2 Cross-Cert and Delegation Tests

A conforming implementation MUST be tested against: a cross-domain credential presented with no corresponding PolicyRecord at the receiving domain (MUST NOT be accepted, regardless of the credential's own validity); a scoped delegation correctly limited to its declared transaction (MUST NOT be treated as general cross-domain recognition); and a conflicting dual-domain claim over the same UUID‑S7, resolved per RFC‑2302 §5's existing precedence rules.

#### 9.3 Revocation Propagation Tests

Each of the four model-specific revocation shapes (Section 6.1) MUST be independently tested for correct propagation along an existing cross-cert relationship, and MUST be tested for the correct *absence* of propagation where no such relationship exists — a revocation in a domain a receiving party has no PolicyRecord basis for trusting in the first place is not an event that party needs to react to at all.

---

## Appendices

### Appendix A — Rationale

*SolNet Standards Working Group*

The obvious alternative to four named models was one generalized model flexible enough to describe all four. This Working Group considered it and rejected it, for the same reason RAP (RFC‑2353) rejected finer-grained advertisement fields: a construct flexible enough to describe anything ends up describing nothing precisely, and a receiving domain reasoning about a peer's trust posture needs to know which of a small, closed set of shapes it's actually looking at. Four named models, each internally rigid, is more useful to an implementer than one model with enough optional fields to fake being all four badly.

The obvious alternative to trust-not-transitive-by-default was transitive trust with an override. This Working Group rejected that too. A domain that trusts Domain A and is trusted by Domain B has, under transitive-by-default trust, implicitly extended something to Domain B it never actually agreed to extend.

Every incident this Working Group has reviewed involving cross-domain credential misuse involved exactly this kind of unintended transitivity. Requiring an explicit PolicyRecord for every acceptance is more paperwork. It has also, so far, been the only thing that's actually worked.

This Working Group is aware that "more paperwork" is not a popular conclusion. It remains the correct one. Section 2.4's separation of local device root from domain root is the identical principle applied one layer down: holding root on a machine is not a form of trust that transits upward to the domain it happens to sit inside, any more than trusting Domain A transits sideways into trusting whoever Domain A trusts.

### Appendix B — Worked Examples Per Lineage

*SolNet Standards Working Group*

This appendix closes the open question left for this RFC to answer directly: does the root attestation model actually fit each of the four lineages' known designs? Worked briefly, per lineage — and per Section 2.4, each entry below separates the lineage's ordinary *local* root mechanic (unchanged, untouched, this RFC's business with it ends at "acknowledged") from the *domain* root this RFC actually defines.

**Earthstock.** TrustTag 1, `CHAIN_OF_CUSTODY`. ("Earthstock" names the OS lineage and its technical model; the political body actually operating it is the UN — this appendix uses the former where it means the model, the latter everywhere else in this document where it means the institution.) `elevate --cert=<chain> --witness=<tech-id>` is local root: proof that one specific action, on one specific device, was authorized by whoever witnessed it.

It resolves to a link in an AK-signed AuthorityChain, but the AK itself — the domain root — is held and protected well above any single elevate event. No number of local elevations hands anyone the key. `AnchorRecord` (RFC‑2302) was always describing the domain root, not the local action, which is why this is the one lineage RFC‑2302 already fit correctly without this RFC's help.

**Scrapshell.** TrustTag 2, `QUORUM_WITNESS`. Local root on any one station is still exactly `claim root --union-vote`'s multisig ledger entry (N co-signatures, TTL, no persistent AK), completely unchanged by this RFC — winning that vote makes you root on that station and nothing else.

The Belt trust domain's own WitnessQuorumRecord is the identical shape one level up: a quorum of recognized union locals, not any single station's logged-in crew, co-signing the domain's own anchor. Same culture, same math, different scale, different event — a compromised station vote reaches exactly as far as that station, never the whole domain. The solo-claim fallback (a personal device with no one to second it), logged as `SOLO — unwitnessed`, is a local-root degenerate case only; it has no domain-root equivalent, because a domain doesn't get to be "solo."

**Mars.** TrustTag 3, `CAPABILITY_TOKEN`. `invoke cap://relay-7/buffer.write --token=fob.7A3` is local root: a fob authorizes actions on the specific object it was minted for, and nothing else.

The domain root is the fleet commissioning office running the minting ceremony itself; a hundred stolen fobs are a hundred local incidents, not a domain compromise, until someone reaches the ceremony that mints them (Section 6.2). Recompilation-from-source-plus-fresh-minting-ceremony is this model's version of key rotation — expensive on purpose, and not incidentally the domain root's own security boundary, which is exactly the thing worth making expensive to touch.

**Corporate.** TrustTag 4, `LEASED_ENTITLEMENT`. `request-entitlement admin.relay` is the one case in this appendix where local and domain root were never actually separate to begin with — every device asks the identical central licensing authority, so there is no local event to mistakenly promote.

The grantor reference is the domain root, on every device, every time. The fallback to a locally-cached grant checked against the station's own clock when the server is unreachable, and its documented, honest weakness (roll the clock back, the cached grant "hasn't expired yet"), is not this RFC's to patch — patching it would mean pretending the lineage's actual design flaw doesn't exist rather than naming it accurately.

### Appendix C — Historical Context

*SolNet Standards Working Group*

Every lineage in Appendix B kept a working notion of "who's in charge here" through the post-founding fragmentation. None of them kept the same one. That's not four independent failures to converge on a correct answer — there wasn't a correct answer available to converge on, because a shared CA needs shared institutions behind it, and the institutions were exactly what fragmented first.

The UN kept the paperwork because the UN kept enough bureaucracy to keep paperwork. The Belt kept a vote because a union was the coordination structure it already had lying around. Mars kept a key in a box because Mars had the up-front engineering discipline to build the box and nothing to spare for maintaining a directory. Corporate kept a phone line to a server because Corporate never stopped being, structurally, a company with customers.

This RFC is not the document that fixes that divergence. It was never going to be. It is the document that stops pretending the divergence isn't real, which is a smaller, more achievable, and considerably more honest goal.

This Working Group would like some credit for that. It does not expect to get any.

### Appendix D — Dispute Procedure Detail

*UN Trust & Interoperability Governance Council*

**D.1 Composition.** This Council convenes a Chair, a Recording Secretary, and a rotating panel drawn from whichever domains are not party to the dispute under review — a domain is never asked to judge its own case, which this Council considers less a fairness safeguard than an efficiency one, since a domain judging its own case has never once, in this Council's institutional memory, found itself at fault.

**D.2 Initiation.** A dispute may be raised by either party to a cross-domain credential dispute, or by a third domain affected by the outcome. This Council does not require both parties' agreement to open a review, though it notes that reviews opened by only one party do tend to take longer, for reasons this Council has not found it necessary to formally document.

**D.3 Findings.** This Council's findings assign responsibility per Section 7.1 and, where a remedy is warranted, recommend one to the affected domains' own governing processes. This Council does not itself have enforcement authority over any domain's internal decisions — a finding is a recommendation, forwarded accordingly, and this Council considers its responsibility discharged upon forwarding.

**D.4 Domain-Level Emergency Unbind Threshold.** A domain-wide emergency unbind (Section 6.2) requires this Council's concurrence before a cross-domain announcement of the unbind is issued, though a domain retains the unilateral right to unbind its own credentials internally without waiting on this Council — the concurrence requirement governs only the cross-domain announcement, not the domain's own internal emergency response, a distinction this Council has found itself explaining more often than it would like.

**D.5 On Timeliness.** This Council aims to issue findings within a timeframe appropriate to the severity of the dispute. Disputes involving an active domain-level emergency unbind are prioritized. Disputes involving a disagreement over historical liability for an incident with no ongoing operational impact are handled in the order received, which has, on occasion, been characterized by affected parties as slower than the situation warranted. This Council notes the characterization for the record and proceeds at its established pace regardless.

### Appendix E — Authorship

**E.1 Editorial Authority.** Prepared under the same multi-institutional authorship model established for RFC‑2352 and RFC‑2353.

**E.2 Primary Authors.**

- **SolNet Standards Working Group (SSWG)** — TrustDomain record definition, root attestation models, TrustTag registry, cross-cert and delegation rules, revocation propagation.
- **UN Trust & Interoperability Governance Council (UN-IG)** — cross-domain dispute and liability process. A distinct body from RFC‑2353 Appendix F's United Nations Infrastructure Directorate, which handles physical-layer liability referral; this Council's jurisdiction is identity and trust-domain disputes specifically.
- **Doctrinal Integrity Council (DIC)** — invariance doctrine alignment, reconciliation against RFC‑2352's existing Trust Domain definition.

**E.3 Contributing Bodies.**

- **Canonical Address Registrar (CAR)** — TrustTag 0–15 registry structure, consistent with CAR's existing custodianship of TrustTag 16–255 under RFC‑2350.

**E.4 Open Items for a Future Revision.** Full wire-level encoding for WitnessQuorumRecord, CapabilityMintRecord, and EntitlementGrantRecord (Section 2.2) is deferred pending a schema owner. A permanent Trust Domain Registrar role for TrustTag values 6–15 (Section 3) is proposed but not yet formally constituted.

This RFC establishes, per Section 2.4, that each lineage's domain root must be a distinct body from any single device's local root — it does not yet name what specifically constitutes that body (the Belt's recognized-representative roster, Mars's fleet commissioning office, the arm of the UN actually holding this lineage's AK). That composition is left for a future revision or a companion governance document, not invented here.

---

#### Editorial Notes *(non-normative)*

[^1]: **AnchorRecord** — the ledger record type (RFC‑2302) binding `UUID-S7 ↔ AuthorityChain ↔ AK.public`, signed by the Anchor Key it describes. Remains the correct, unmodified record for any `CHAIN_OF_CUSTODY` trust domain (Section 2.1); no longer assumed to describe the other three root attestation models.
[^2]: **Anchor Key (AK)** — the long-lived keypair RFC‑2301 §4 defines as the second tier of the SolNet key hierarchy, bound to a UUID‑S7 via NetworkCert and used to sign ledger transactions. The root of authority `AnchorRecord` assumes every trust domain has — which, per this RFC, not every trust domain does.
[^3]: **Root Attestation Model** — this RFC's own central term (Section 2): the declared basis for a trust domain's root of authority, one of exactly four values (`CHAIN_OF_CUSTODY`, `QUORUM_WITNESS`, `CAPABILITY_TOKEN`, `LEASED_ENTITLEMENT`), never a fifth or a spectrum between them.
[^4]: **TrustTag** — a 1-byte unsigned integer field in the canonical address (RFC‑2350 §5.5). Values 0–15 are reserved for Trust Domains and assigned by this RFC (Section 3); values 16–255 remain the Canonical Address Registrar's general allocation.
[^5]: **NetworkCert** — the Anchor Key's own signed certificate, binding `AuthorityChain → UUID-S7 → AK.public` (RFC‑2301 §5). The canonical identity assertion a `CHAIN_OF_CUSTODY` domain's AnchorRecord ultimately rests on.
[^6]: **PolicyRecord** — a domain's own ledger statement (RFC‑2302) of which other domains, or specific credentials, it accepts and on what terms. Load-bearing for this RFC's "trust is not transitive by default" rule (Section 4): recognizing a peer's root attestation model is not the same as recognizing any credential that peer issues.
[^7]: **CrossCertRecord** — records that a PolicyRecord-based acceptance was granted: which domain, which credential, by whom, and when (RFC‑2302 §9). Documents a trust decision after the fact; it does not create one.
[^8]: **RevocationRecord** — marks a prior AnchorRecord (or, per Section 6.1, an equivalent domain-root record under another attestation model) as revoked, signed by the revoking authority. Propagates only along an existing CrossCertRecord or delegation relationship (RFC‑2301 §9), never globally.

*For terms shared across multiple SolNet RFCs (TrustTag, Trust Domain, Root Attestation Model, AnchorRecord, PolicyRecord, CrossCertRecord, RevocationRecord, NetworkCert, WitnessQuorumRecord, CapabilityMintRecord, EntitlementGrantRecord, referenced RFC numbers), see the shared corpus glossary (`solnet-glossary.md`).*
