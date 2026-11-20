# RFC‑2363 — Directory and Routing Endpoints (DRE)

*SolNet Standards Working Group — Directory & Reachability Working Group (SSWG‑DIR‑WG)*

**Status:** Normative — Standards Track. A styled HTML rendering of this
document for human readers is maintained at
`docs/rfc-html/RFC-2363-Directory-and-Routing-Endpoints.html`.

---

### 0. Preface

*SolNet Standards Working Group — Directory & Reachability Working Group*

RFC‑2350 has cited this document by number in its own canonical binary format since before this document existed, on the theory that a schema someone will eventually write is still a schema. RFC‑2303 and RFC‑2308 did the same, independently, without checking with each other first. This Working Group appreciates the confidence and would like it on record that citing a document into existence is not the same as drafting it.

What those three documents agree on, it turns out, is correct: a **Directory & Routing Endpoint (DRE)** publishes advisory, replicated, occasionally-wrong information about how to find things — domains, roles, contact paths, coarse ephemeris — without ever being asked to authenticate anyone, forward a single packet, or decide who gets to see what. Those are, respectively, RFC‑2362's job, RFC‑2365's job, and RFC‑2308's job. A DRE that tries to do any of them has exceeded its charter, however helpful the attempt.

A DRE is a bulletin board, not a notary. It says what it last heard, and when it heard it. It does not vouch.

#### 0.1 Terminology Reconciliation Note

RFC‑2300 §5.3, introducing the Location Plane, names this layer "Directory & **Reachability** Endpoints." RFC‑2303, RFC‑2308, RFC‑2350, and this document's own working title all independently say "Directory and **Routing** Endpoints" instead. Both phrases abbreviate to the same acronym and refer to the same layer; neither predates the other by enough to settle this on priority alone.

This Working Group resolves it as follows, and asks that the resolution stick: **"Directory and Routing Endpoints" is the canonical expansion of DRE**, matching majority usage and this document's own registry entry. RFC‑2300's "Reachability" phrasing is retained as an acceptable synonym in casual or legacy reference — it is, after all, not wrong — but MUST NOT be used in new normative text. Implementers should note that the "Routing" in the name refers to the routing *information* a DRE publishes (role aliases, reachability advisories, ephemeris hints), not to the packet-forwarding mechanics RFC‑2365 (DTN Routing Policy) actually performs. A DRE does not move traffic. It answers questions about where traffic should go, badly, on a good day, and somewhat better than nothing on all the others.

---

### 1. Scope

RFC‑2363 defines:

- the Directory & Routing Endpoint (DRE) and its function within the L3 Location Plane (RFC‑2300 §5.3);
- the `DREInfoRecord` schema and the well-known publication paths `//info`, `//contact`, and `//beacon`;
- the `ProvenanceRecord` schema — the record type RFC‑2350's `ProvenancePointer`[^1] (§4.7, §5.8, §6) has referenced since that document's own publication;
- the `ProfileRegistryEntry` schema and the domain-privacy-profile lookup path;
- DREID assignment and RecordIndex addressing (Section 3.3);
- replication rules, indexer behavior, and disagreement handling for advisory data propagated through the DTN mesh;
- the DRE Resolution step of RFC‑2350's resolution precedence (§7.8), including its integration point with role-based addressing and namespace escalation (RFC‑2390+);
- the points in this document's own procedures where RFC‑2362 (trust consultation) and RFC‑2308 (exposure decisions) MUST be consulted, without this document itself defining new fields at those layers.

RFC‑2363 does **not** define:

- packet-level routing, store-and-forward semantics, or ship-as-router mobility (RFC‑2365, RFC‑2366);
- local namespace or in-domain service resolution (RFC‑2390, RFC‑2391);
- the exposure-decision procedure a DRE runs before answering a query (RFC‑2308) — this document defines the records that procedure operates over, not the procedure itself;
- cross-domain trust recognition rules (RFC‑2362) — this document defines only where a DRE consults them;
- session establishment or continuity once a contact path has been resolved (RFC‑2392);
- ephemeris hint block internals (RFC‑2364) — a DRE republishes and ages these; it does not compute them.

These remain the responsibility of their respective working groups, which this Working Group has no intention of relieving of that responsibility.

---

### 2. Terminology

The following terms are used normatively throughout this document. All terms inherit their global definitions from RFC‑2300 unless explicitly refined here.

**L1** — the Data‑Link layer (RFC‑2300 §5.2), fully specified by RFC‑2350: canonical addressing, the LocationChain/ServiceChain split, and the AddressRecord format this document's own `ProvenancePointer` binding (Section 5.3) resolves against.

**L2** — Identity Resolution (RFC‑2300 §5.3): UUID‑S7, NetworkKeys, NetworkCerts, and LedgerAnchors — where an identifier stops being a local opinion and starts being a ledger fact. A TrustDomain's[^2] root attestation credential (RFC‑2362 §2) lives here.

**L3** — Directory & Routing Endpoints, this document's own layer (RFC‑2300 §5.3; see Section 0.1 for the Reachability/Routing naming reconciliation): publishes advisory, replicated directory data — `DREInfoRecord`, `ProvenanceRecord`, `ProfileRegistryEntry` — without authenticating anyone, moving a single packet, or deciding who gets to see what.

**DRE** — Directory & Routing Endpoint; an L3 node publishing and replicating advisory directory data.

**DREID** — a deterministically-derived identifier for a DRE (Section 3.3).

**RecordIndex** — a monotonically-assigned identifier for a record within one DRE's own publication history.

**DREInfoRecord** — a DRE's self-description and role-alias directory (Section 4).

**ProvenanceRecord** — the authoritative-origin record RFC‑2350's `ProvenancePointer` resolves to (Section 5).

**ProfileRegistryEntry** — a domain's published Domain Privacy Profile[^3] declaration (Section 9).

**Role Alias** — a published mapping from a functional role name to a current ServiceChain path (Section 4.3).

**Correlator** — an opaque, session-scoped substitute for an internal ServiceChain, published in place of it (Section 4.4).

**Indexer** — the local component of a DRE responsible for merging replicated records and resolving disagreement between sources (Section 6.2).

---

### 3. The Directory & Routing Endpoint

#### 3.1 Function

A DRE is any L3 node that publishes `DREInfoRecord`, `ProvenanceRecord`, and/or `ProfileRegistryEntry` data at the well-known paths defined in this document, and that participates in replicating such records for other DREs. A device does not need to be a dedicated server to be a DRE; a relay, a station's traffic-control system, or a ship's own comms suite MAY all serve this role simultaneously alongside their other functions, subject to whatever local resource constraints apply.

A DRE MUST NOT be assumed to be continuously reachable, authoritative, or current. Clients consulting a DRE are consulting a cache of what that DRE last heard, filtered through however long its own replication backlog happens to be that day.

#### 3.2 Advisory, Not Authoritative

RFC‑2300 §5.3 already says it: DRE data is "advisory, replicated, and occasionally wrong." This document does not soften that. Nothing a DRE publishes MUST be treated as ground truth by a receiving implementation. Where a DRE's advisory data conflicts with an authoritative source — a directly-verified `ProvenanceRecord`, a live local resolution — the authoritative source prevails, always, without exception logged as noteworthy.

> A DRE is a witness, not a notary. It saw something, once, and is telling you about it.

The Working Group notes that at least one early implementation treated the absence of a record at a queried DRE as equivalent to revocation. It is not. Absence means the DRE has not heard of the record, has not replicated it yet, or has expired it locally under its own retention policy — any of which is a routine operating condition, not a finding.

#### 3.3 DREID Assignment

Unlike TLV keys, which the Canonical Address Registrar (CAR) allocates centrally under RFC‑2350, a DREID is **not** centrally issued. Round-trip registration is not viable at DTN light-lag scale, and a DRE serving a single station or ship cannot wait on an Earth-side authority to confirm it may exist.

A DREID MUST be derived deterministically from the operating domain's own Trust Domain record (RFC‑2362): specifically, a truncated cryptographic hash (RFC‑2301 §algorithm registry) of that record's canonical serialized form. A domain that re-roots — revokes and replaces its own domain-root record under RFC‑2362 §6 — MUST therefore expect its DREID to change. This is deliberate: a domain-root change is a significant, auditable event, and a DRE quietly keeping its old identity across one would misrepresent continuity that did not occur.

DREID collision (two domains independently deriving the same value) is vanishingly unlikely by construction and is treated as a named failure mode in Section 10, not designed around further.

---

### 4. DREInfoRecord

#### 4.1 Structure

A `DREInfoRecord` MUST contain:

- **DREID** — this DRE's derived identifier (Section 3.3);
- **OperatingDomain** — a reference to the RFC‑2362 TrustDomain this DRE publishes on behalf of;
- **PublishedPaths** — which of `//info`, `//contact`, `//beacon` this DRE actually serves (a DRE is not required to serve all three);
- **ReplicationPeers** — an advisory list of other DREIDs this DRE has recently exchanged records with, for indexer disagreement-tracing purposes (Section 6.2);
- **SupportedPointerTypes** — which RFC‑2350 §6.2 PointerType values this DRE can resolve on request;
- **FreshnessTag**[^4] — per RFC‑2350 §5.7, MUST NOT be stripped or fabricated by any relay carrying this record;
- **RoleAliasTable** — OPTIONAL, per Section 4.3;
- **Signature** — signed by the publishing DRE's own operational key, distinct from and not a substitute for the domain-root credential the OperatingDomain reference points to.

#### 4.2 Publication at `//info`

A DRE's own `DREInfoRecord` MUST be published at its `//info` path. Clients and other DREs discovering a domain for the first time consult `//info` before anything else this document defines; every other record type is reached, directly or indirectly, by first knowing which DRE to ask.

#### 4.3 Role-Alias Directory Extension

A DRE's `RoleAliasTable`, where present, maps a functional role name (e.g. `actual`, `captain`, `duty-tech`) to the ServiceChain currently staffing it, updated by the operating domain as staffing changes and replicated opportunistically like any other DRE data.

Resolution of a role-addressed message proceeds in two stages:

1. **Fast path.** The sender consults its own cached copy of the destination domain's `RoleAliasTable`, however stale, and addresses the message to whatever ServiceChain it currently names for that role.
2. **Local fallback.** If the cached table is missing the role entirely, or the sender has no cached table for that domain at all, the destination domain's own local S3 service discovery (RFC‑2391) resolves the role live, *after physical arrival* — entirely local, and therefore unaffected by however many DTN hops the message took to get there.

This makes role-based addressing inherently stale-tolerant: if the role's occupant changes between when the sender's table was cached and when the message arrives, local resolution at the destination still reaches whoever currently holds it. A message is never delivered to a role that has since changed hands, because the final handoff is never trusted to the cache.

A domain publishing no `RoleAliasTable` at all cannot be role-addressed by a sender with no other prior contact. This is a limit of first contact, not a defect; RFC‑2300 §5.1 already establishes that L0 is unreliable by default and optimistic assumptions become incident reports. A sender with no cached directory and no out-of-band bootstrap needs a specific known ServiceChain, the same as it always has.

#### 4.4 `//contact` and Session-Scoped Correlators

A domain's `//contact` publication tells an outside sender how to reach it. A naive publication exposes the domain's real internal ServiceChain verbatim — department, section, role, person — to every DRE that replicates it and every party that ever queries it.

A `//contact` record SHOULD publish an opaque, session-scoped **Correlator** in place of the real internal ServiceChain, using the Session Key[^5] mechanism RFC‑2300 §6.1 already defines for exactly this purpose ("answer whether a specific interaction is current and authorized"). The publishing domain's own gateway maintains the correlator-to-real-identity mapping locally; a reply addressed to the correlator is reversed and delivered internally, and the correlator is never resolvable by anyone outside the gateway that issued it. This is not a new record type — it is Session Keys, applied to an outbound field that has, until now, gone without them.

Publishing a raw internal ServiceChain at `//contact` where a Correlator was called for is a named failure mode, **Correlator Bypass**, defined in Section 10. It is not a wire-format violation — the record is perfectly well-formed — and for that reason it is exactly the kind of failure a syntax check will never catch. See Appendix B for a worked incident.

#### 4.5 `//beacon` and Ephemeris Hints

A DRE MAY republish coarse ephemeris and beacon hints at `//beacon`, aged and re-aggregated from whatever RFC‑2304 alignment data and RFC‑2364 ephemeris hint blocks it has locally received. A DRE does not compute ephemeris; it forwards and ages what it is given, attaching its own FreshnessTag to reflect when *it* last heard the value, not when the value was originally computed. Conflating the two is a Section 10 failure mode.

---

### 5. ProvenanceRecord

#### 5.1 Purpose

RFC‑2350 has required, since its own publication, that every `ProvenancePointer` resolve to "a valid ProvenanceRecord (RFC‑2363)." No document has, until now, said what that record actually contains. Implementers requiring a schema before this document's publication were, at least, asking the correct question of the wrong document.

A `ProvenanceRecord` answers one question: *who asserts that this Address is currently valid, and on what basis?* It is not a timestamp, not an address hash by itself, and not a routing hint — RFC‑2350 §6 already rules those readings out, and this document does not reopen them.

#### 5.2 Structure

A `ProvenanceRecord` MUST contain:

- **RecordHash** — the canonical hash of this record's own serialized form, computed after every other field is set;
- **IssuingTrustDomain** — a reference to the RFC‑2362 TrustDomain asserting this record;
- **Assertion** — the specific claim being made (e.g. "this LocationChain currently resolves under the issuing domain's declared root attestation model");
- **IssuedAt / FreshnessTag** — per RFC‑2350 §5.7;
- **HashAlgorithm** — per RFC‑2301's algorithm registry;
- **SequenceNumber** — a varint, strictly increasing per IssuingTrustDomain, signed as part of this record; the first `ProvenanceRecord` a domain ever issues MUST use 0 (Section 5.5);
- **PriorRecordHash** — the RecordHash of this domain's immediately preceding `ProvenanceRecord` (the one at SequenceNumber − 1); REQUIRED whenever SequenceNumber > 0, absent only at SequenceNumber 0 (Section 5.5);
- **Signature** — bound to whichever credential the issuing domain's declared root attestation model actually produces (an Anchor Key signature for `CHAIN_OF_CUSTODY`, a quorum co-signature set for `QUORUM_WITNESS`, and so on per RFC‑2362 §2) — this document does not require a persistent key where the issuing domain's own model does not have one; covers SequenceNumber and PriorRecordHash along with every other field;
- **LedgerEntryRef**[^6] — OPTIONAL, present when this record is also anchored in a ledger per RFC‑2302. An external anchor, not a substitute for the chain in Section 5.5 — a domain with no ledger still sequences.

#### 5.3 Binding to PointerType

RFC‑2350 §6.2 defines three `ProvenancePointer` PointerTypes, each of which resolves to a `ProvenanceRecord` by a different path:

- **DirectRecordHash (0x01)** — the pointer's HashBytes MUST match this record's own RecordHash exactly;
- **LedgerEntryRef (0x02)** — the referenced ledger entry's payload MUST be a canonically-serialized `ProvenanceRecord`;
- **DRERecordRef (0x03)** — the record is hosted and served by a DRE, addressed by `DREID || RecordIndex` (RFC‑2350 §6.5); the DRE serving it is subject to Section 5.4 and Section 8 of this document before it answers.

All three resolve to the identical record shape defined in Section 5.2. The PointerType says where to look, not what you will find when you get there.

#### 5.4 Trust Consultation (Deferred to RFC‑2362)

RFC‑2362 §5 defers its own DRE trust-decision integration to this document, "once drafted, not retroactively added." This is the point at which it is added: before a DRE publishes or serves a `ProvenanceRecord`, `DREInfoRecord`, or `ProfileRegistryEntry` on a requester's behalf, it MUST consult the requester's TrustDomain per RFC‑2362, and apply whatever cross-domain PolicyRecord (RFC‑2362 §4, RFC‑2302) its own operating domain has on file for that requester's domain. This document defines the point in the pipeline where that consultation happens; RFC‑2362 defines what happens as a result of it.

This Working Group notes, for the record and not with any particular satisfaction, that this is now the second RFC-defined record named `PolicyRecord` in the corpus — RFC‑2308 §3 defines an unrelated exposure-classification schema under the same name. The two are not interchangeable and this document does not attempt to reconcile the collision; it is flagged here so nobody spends an afternoon debugging why a trust decision and an exposure decision keep reading each other's fields.

#### 5.5 Self-Signed Sequencing (Replay and Rollback Detection)

A `ProvenanceRecord` may travel through DREs with no relationship to the domain that issued it, no obligation to have heard of it before, and no way for the receiver to know how many hops it took to get there. Section 3.2 already establishes that none of those DREs are trusted to vouch for the record's content. They are equally not trusted to vouch for its *freshness* — a relay asked to attest "this is current" is a notary, and this Working Group has already ruled that role out.

SequenceNumber and PriorRecordHash (Section 5.2) exist to make freshness self-verifying instead. Each domain's own signature extends a chain only that domain can extend: record N's PriorRecordHash MUST equal the RecordHash of that domain's record N−1. A receiver holding any prior record from a domain can verify that a newly-arrived one either continues the chain correctly or does not — and can do this against a record that arrived by any path whatsoever, through any number of relays, none of which were asked to certify anything. The verification is between the receiver and the domain's own signature. No DRE in between is a party to it.

This closes a specific attack Section 3.2 and Section 6 (on their own) do not: a validly-signed, authentic, unmodified `ProvenanceRecord` that is simply **old**, reintroduced to make stale state look current. FreshnessTag alone does not catch this if the replayed copy's own timestamp is left untouched — the record is telling the truth about when it was issued, it is lying about being the domain's latest word. SequenceNumber does catch it: a receiver who has already seen N+3 and is handed N again knows immediately, without consulting anyone, that N is behind.

LedgerEntryRef (Section 5.2), where present, anchors this same sequence externally per RFC‑2302 — useful corroboration, never a requirement. A domain under a root attestation model with no persistent ledger (Section 5.2's Signature note) still sequences its own records; the chain lives in the records themselves, signed, not in infrastructure a `QUORUM_WITNESS` or `CAPABILITY_TOKEN` domain may not run.

> A relay can lose a record, duplicate it, or sit on it for a year. It cannot make the chain say something its own signature didn't put there.

---

### 6. Replication, Indexing, and Sequence Verification

#### 6.1 Opportunistic Replication

DRE records propagate through the same store-and-forward DTN mesh as everything else at this scale (RFC‑2300 §5.3, RFC‑2365) — opportunistically, whenever two DREs happen to have a link, never as a scheduled live synchronization a sender can depend on arriving by a given time.

A stale `//info` record from a jury-rigged Ceres traffic-control node, a properly-maintained Martian orbital defense DRE, and a UN-chartered backbone relay's own DRE are, for resolution purposes, three equally advisory sources that happen to disagree — institutional pedigree buys a source no extra trust here, only ever a FreshnessTag comparison and, per RFC‑2300 §5.3, a wider error bound.

#### 6.2 Local Indexer Behavior

Each DRE's indexer MUST key incoming records by `(DREID, RecordIndex)` for DRE-hosted records, or by RecordHash for directly-verified ones, and MUST resolve conflicting copies of the same key by FreshnessTag — newest wins locally. Where two copies carry indistinguishable freshness, the indexer MUST retain both and report the disagreement to any client that asks, rather than silently preferring one. RFC‑2300 §5.3's instruction to "consult multiple sources" presumes the indexer has not already thrown the losing source away.

#### 6.3 Replication Failure Modes

An indexer detecting a record that has been replicated back to it having passed through an implausible number of intermediate DREs (a replication loop) MUST drop it and MUST log the event; it MUST NOT simply keep forwarding a record indefinitely on the theory that more copies means more truth. Records propagated through this mesh MUST carry a hop or TTL bound sufficient to make this detectable.

The hop or TTL count is carried in the replication envelope, not inside the signed record, and it is not a trust mechanism: a relay that decrements it dishonestly can make loop detection slower, nothing else. It cannot forge a record, alter its freshness, or vouch for its path — those properties come from Section 5.5's signature chain, which no relay's envelope behavior can touch. A hop count asks a relay to count. Section 5.5 does not ask a relay anything.

#### 6.4 Sequence Verification and Replay Rejection

On receiving a `ProvenanceRecord`, an indexer that already holds a record from the same IssuingTrustDomain MUST compare SequenceNumbers before accepting the new one:

- if the new SequenceNumber is higher, and its PriorRecordHash matches the RecordHash of the highest record the indexer already holds (or of the intervening record it can independently verify), the chain is intact and the indexer MUST accept it as the domain's current word;
- if the new SequenceNumber is lower than or equal to one the indexer already holds, the record MUST be treated as a replay (Section 10) regardless of how current its FreshnessTag claims to be, and MUST NOT silently overwrite the newer one the indexer already has;
- if the new SequenceNumber is higher but PriorRecordHash does not match, the chain is broken — the indexer MUST flag this for the same manual reconciliation Section 10 requires for a DREID collision, and MUST NOT guess which of the two disagreeing histories is correct.

None of this asks a relay to participate. The indexer is checking the domain's own signature against the domain's own prior signature, which it may have received from a completely different relay, hours or months apart. That is the entire point.

---

### 7. Resolution Integration (RFC‑2350 §7.8)

RFC‑2350 §7.8 defines DRE Resolution as Step 7 of its resolution precedence: it MAY occur after `ProvenancePointer` dereference (Step 6) and before namespace escalation (Step 8, RFC‑2390+), MUST NOT reorder chain interpretation, MUST NOT infer missing fields, and MUST NOT modify the Address under resolution. This document does not relax any of those constraints; it specifies what a DRE actually does within them.

A DRE Resolution query submits the resolved LocationChain and, where present, the dereferenced `ProvenanceRecord`, to a DRE believed to serve the destination domain. The DRE MAY answer with: a matching `ProvenanceRecord` or `DREInfoRecord`; a role-alias hit per Section 4.3; or nothing, if it has no cached data for the query. An empty answer is not an error and MUST NOT halt resolution — per RFC‑2350 §7.8, it simply proceeds to namespace escalation.

Appendix A works this procedure through the scenario that originally motivated Section 4.3: a sender with no live round-trip budget, addressing a role rather than a known path.

---

### 8. Exposure Decisions (Deferred to RFC‑2308)

RFC‑2308 §1.2 already describes a DRE as the "sole arbiter of metadata visibility" in regulated environments and specifies the state machine that decision runs on: `INIT → VERIFY → EVALUATE → (EXPOSE | SUPPRESS) → AUDIT`, with `FAILSAFE` as the universal fallback from any failure state. This document does not redefine that procedure. It specifies that a DRE receiving a query for any record type this document defines MUST run that query through RFC‑2308's state machine before responding, using the exposure PolicyRecord (RFC‑2308 §3, expressly not the trust PolicyRecord of Section 5.4) and the requester's Domain Privacy Profile (Section 9) as inputs.

The division of labor, stated once and plainly so nobody has to reconstruct it later: this document defines the records. RFC‑2362 decides whether the requester is trusted at all. RFC‑2308 decides how much of the record that requester is actually shown. No single one of these three RFCs performs a query alone, and none of them should be made to.

---

### 9. ProfileRegistryEntry

#### 9.1 Purpose

A `ProfileRegistryEntry` lets a domain publish which Domain Privacy Profile (RFC‑2308 §4: UN, MDR, OPA, Belter, or Non-Compliant) it operates under, so another domain's DRE can look up what it will actually be shown before spending a query on finding out the hard way.

#### 9.2 Structure

A `ProfileRegistryEntry` MUST contain: **TrustDomain** (the declaring domain, RFC‑2362), **DeclaredProfile** (one of RFC‑2308 §4's named profiles), **EffectiveSince** and **FreshnessTag**, and a **Signature** from the declaring domain's own root attestation credential.

#### 9.3 Registry Query Path

A domain's `ProfileRegistryEntry`, where published, MUST be retrievable at `//profile`. A DRE MAY fold this into its `//info` response instead of serving it separately, provided the FreshnessTag and Signature remain intact either way.

#### 9.4 Non-Compliant Domains

A DRE MUST NOT fabricate a `ProfileRegistryEntry` on behalf of a domain that has not published one, and MUST NOT assume a missing entry defaults to the most permissive profile. Absence of a declared profile is itself information — consistent with RFC‑2308 §4.7's treatment of non-compliant domains — and a receiving DRE SHOULD treat an undeclared domain at least as conservatively as RFC‑2308's Non-Compliant category, not more generously.

---

### 10. Invalid Forms and Failure Modes

The following are invalid or non-compliant and MUST be treated as failures, not edge cases to be silently handled:

- **Correlator Bypass** (Section 4.4) — a `//contact` record publishing a raw internal ServiceChain where a session-scoped Correlator was required. Well-formed, non-compliant, and probe-detectable: any internal ServiceChain segment appearing verbatim in a `//contact` record is sufficient evidence on its own.
- **Fabricated ProfileRegistryEntry** (Section 9.4) — a DRE inventing or defaulting a profile declaration a domain never published.
- **DREID collision** (Section 3.3) — two domains independently deriving the same DREID. An indexer detecting this MUST NOT silently merge the two domains' records; it MUST flag both for manual reconciliation and, in the interim, treat first-seen-by-that-indexer as authoritative locally only, not network-wide.
- **Replication loop** (Section 6.3) — a record circulating among DREs past its TTL/hop bound.
- **Sequence rollback / replay** (Section 6.4) — a validly-signed `ProvenanceRecord` presented with a SequenceNumber at or behind one the receiver already holds for that domain. Authentic and well-formed; stale masquerading as current. A FreshnessTag check alone will not catch this if the replayed copy's own timestamp was never altered — the SequenceNumber comparison is the one that does.
- **Broken sequence chain** (Section 6.4) — a higher SequenceNumber whose PriorRecordHash does not match the receiver's own highest-held record for that domain. Treated the same as a DREID collision: flagged for reconciliation, never silently resolved in either direction.
- **Ephemeris/beacon age conflation** (Section 4.5) — a republished hint carrying a FreshnessTag reflecting original computation time rather than last-heard time.
- **Stale record served as current** — any record forwarded, cached, or served with its FreshnessTag stripped, altered, or omitted.
- **Absence-as-revocation** (Section 3.2) — treating a DRE's lack of a record as equivalent to that record having been revoked.

The Working Group declines to enumerate every conceivable variant of the above, as implementers have, in every prior document this Working Group has published, demonstrated unlimited creativity in producing them.

---

## Appendices

### Appendix A — Worked Example: Role Directory Resolution

*Free Mesh Consortium — field notes*

A Martian tech needs to reach whoever currently holds "Blackbeard actual" — the fleet commander's role, not a specific known ServiceChain, and not something worth a query-then-reply round trip measured in hours at this range.

The tech's own cache holds a `RoleAliasTable` entry for Blackbeard's domain from six days prior, naming `ENGINEERING:CMD:ACTUAL` as `actual`. The message is addressed to that path and transmitted. Three days into transit, Blackbeard's fleet commander changes — a routine rotation, not an emergency. The sending tech has no way to know this and no way to find out before the message arrives.

On arrival, Blackbeard's own domain resolves `ENGINEERING:CMD:ACTUAL` via local S3 (RFC‑2391) against its *current* staffing, not the tech's three-day-stale cache. The message reaches the new commander without anyone re-transmitting anything or the tech ever learning their directory was out of date. This is Section 4.3's fast-path-plus-local-fallback working exactly as specified: the cache only ever had to get the message pointed in the right direction, not get the answer right.

### Appendix B — Worked Example: Correlator Bypass

*Independent Auditors — incident excerpt*

A newly-commissioned Belt station publishes its `//contact` record using default gateway settings, which, on this particular vendor's hardware, ship with Session Key correlation disabled unless explicitly configured. The record propagates through the DTN mesh for eleven days before anyone notices, reaching an estimated forty-one DREs, each of which faithfully replicates the station's full internal ServiceChain — department, section, and the names of three individual duty techs — to whoever queries it.

Nothing here is a wire-format violation. The record is syntactically perfect. It is also a Correlator Bypass (Section 4.4/10): the station published an internal identity chain where a Correlator was called for, and did so correctly, repeatedly, for eleven days, because correctness was never the thing missing.

The failure is caught by a routine probe checking published `//contact` records against known internal ServiceChain naming conventions, not by anything in this document's own validation rules — which is the point of naming Correlator Bypass explicitly rather than leaving it as an unlabeled configuration mistake. A named failure mode is something a probe can be written against. An unlabeled one is something somebody notices eventually, or doesn't.

### Appendix C — Record Field Reference

Non-normative summary; Sections 4, 5, and 9 remain authoritative.

| Record | Key Fields | Published At |
|---|---|---|
| `DREInfoRecord` | DREID, OperatingDomain, PublishedPaths, ReplicationPeers, SupportedPointerTypes, RoleAliasTable?, FreshnessTag, Signature | `//info` |
| `ProvenanceRecord` | RecordHash, IssuingTrustDomain, Assertion, IssuedAt/FreshnessTag, HashAlgorithm, SequenceNumber, PriorRecordHash?, Signature, LedgerEntryRef? | via ProvenancePointer (RFC‑2350) |
| `ProfileRegistryEntry` | TrustDomain, DeclaredProfile, EffectiveSince, FreshnessTag, Signature | `//profile` (or folded into `//info`) |

### Appendix D — Authorship

**D.1 Editorial Authority.** Prepared under the multi-institutional authorship model established for RFC‑2352 and applied to this corpus's other graduated documents. Unlike RFC‑2362 or RFC‑2353, this document has a single primary author; no institutional dispute attaches to a directory bulletin board.

**D.2 Primary Author.**

- **SolNet Standards Working Group (SSWG)** — full document. DRE function, DREInfoRecord, ProvenanceRecord, ProfileRegistryEntry, replication and indexing rules, resolution integration, and the deferral points to RFC‑2362 and RFC‑2308.

**D.3 Custodian of Record.** The Directory Registry Authority (DRA), a standing SSWG sub-body, maintains record-type versioning and reserved field allocations for this document, distinct from and not overlapping the Canonical Address Registrar's (CAR) TLV-key custodianship under RFC‑2350. The DRA does not allocate DREIDs; Section 3.3 explains why none exist to allocate.

**D.4 Open Items for a Future Revision.** This document flags, without resolving, the `PolicyRecord` naming collision between this document's Section 5.4/RFC‑2362 usage and RFC‑2308 §3's usage (Section 5.4). A disambiguating rename of one or both is recommended to whichever registrar eventually owns that decision. Full wire-level encoding for `DREInfoRecord`, `ProvenanceRecord`, and `ProfileRegistryEntry` (binary TLV form, matching RFC‑2350 §5–6's conventions) is deferred pending implementation priority; this revision specifies logical structure only.

#### Editorial Notes *(non-normative)*

[^1]: **ProvenancePointer** — the canonical reference to an Address's authoritative origin (RFC‑2350 §4.7, §5.8, §6), optional but, when present, MUST resolve to a valid ProvenanceRecord. Not a timestamp, an address hash, or a routing hint.
[^2]: **TrustDomain** — a named, policy-bearing boundary declaring one of four root attestation models (RFC‑2362 §2). The entity a ProvenanceRecord's IssuingTrustDomain field, and a DREInfoRecord's OperatingDomain field, both point to.
[^3]: **Domain Privacy Profile** — a domain's declared maximum permissible metadata visibility (RFC‑2308 §4: UN, MDR, OPA, Belter, or Non-Compliant). What a ProfileRegistryEntry publishes and what a DRE's exposure decision (Section 8) is measured against.
[^4]: **FreshnessTag** — a varint field (RFC‑2350 §5.7) expressing temporal freshness. Every record type this document defines carries one; none of them may have it stripped in transit.
[^5]: **Session Keys** — the RFC‑2300 §6.1 identity-chain layer answering whether a specific interaction is current and authorized. The mechanism this document reuses, rather than inventing a new record type, for `//contact` correlation (Section 4.4).
[^6]: **AnchorRecord / LedgerAnchor** — the RFC‑2302 ledger mechanism a ProvenanceRecord's optional LedgerEntryRef field points into, when a domain chooses to anchor its provenance assertions in a ledger rather than (or in addition to) direct DRE hosting.

*For terms shared across multiple SolNet RFCs (DRE, DREID, RecordIndex, ProvenanceRecord, DREInfoRecord, ProfileRegistryEntry, TrustDomain, FreshnessTag, Session Keys, Domain Privacy Profile, referenced RFC numbers), see the shared corpus glossary (`solnet-glossary.md`).*
