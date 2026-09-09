# RFC‑2362 Companion — Exploits, Tools, Schemas to Craft

Internal design reference. No in-universe voice, no institutional stamps — this is the
game-design and implementation translation layer for RFC‑2362 (Trust Domains and
Authority Policy), matching the format already established for the RFC‑2352 and
RFC‑2353 companion docs. Everything below is fictional, non-actionable, and grounded in
RFC‑2362's actual mechanics (the four root attestation models, TrustTag registry,
PolicyRecord/CrossCertRecord non-transitive trust, and the local-root-vs-domain-root
distinction that's the RFC's real spine).

---

# I. Exploit Classes (Fictional, RFC‑2362‑Aligned)

RFC‑2362's entire design fights one specific failure mode — unearned trust moving
somewhere it was never actually granted, whether sideways (transitivity) or upward
(local root escalating to domain root). Every exploit below is either a way to force
that movement anyway, or a way to abuse the review/dispute process built to catch it.

## 1. Local-Root-to-Domain-Root Escalation

The RFC's own marquee failure mode (Section 2.4): convincing a consuming system that
winning local root on one console — one Scrapshell station's dockworker vote, one
Mars relay's fob — implies standing across the whole trust domain. A sloppy or
legacy implementation that never got the Section 2.4 memo is the actual attack surface,
not the RFC's own logic.

**Player gains:** domain-wide credibility from a single, cheap, local compromise —
the biggest payoff-to-effort ratio in this whole exploit list, and exactly why Section
2.4 exists.

## 2. Unintended Transitivity

Domain B trusts Domain A; Domain A trusts Domain C; a buggy implementation lets that
chain imply B trusts C, with no PolicyRecord anywhere saying so. This is the exact
historical failure pattern Appendix A cites as the reason PolicyRecord exists at all —
which means it's also the first thing worth testing when sizing up an unfamiliar
domain's actual conformance.

**Player gains:** access to a domain that never agreed to trust you, laundered through
one hop you legitimately do have standing with.

## 3. Root Attestation Model Mismatch (Malformed TrustDomain Exploitation)

Section 2.3 requires a TrustDomain's declared model to match what its
authority_reference actually resolves to. A relay that skips this validation will
accept a `CHAIN_OF_CUSTODY` claim backed by a `WitnessQuorumRecord`, or vice versa —
letting an attacker borrow whichever model's failure mode is currently easiest to
exploit while presenting whichever model looks most trustworthy on paper.

**Player gains:** the credibility of one root attestation model with the actual
compromise surface of a different, weaker one.

## 4. CrossCertRecord Forgery

A CrossCertRecord is supposed to document that a PolicyRecord decision already
happened — Section 4 is explicit that the record doesn't create trust, only records
it. A forged CrossCertRecord with no underlying PolicyRecord exploits any consumer
that checks for the record's *existence* rather than verifying the PolicyRecord it
claims to document.

**Player gains:** apparent cross-domain recognition that no domain ever actually
decided to grant.

## 5. Sybil Quorum (QUORUM_WITNESS Model)

A WitnessQuorumRecord requires N co-signatures from the domain's *recognized*
representative body — not just any N signatures. Stack enough fake or compromised
"recognized representative" identities into that body (or exploit a sloppy domain
that never carefully curated who counts) and a Sybil quorum produces a technically
valid-looking domain-anchor claim event.

**Player gains:** a fraudulent but structurally correct domain-level root claim for a
`QUORUM_WITNESS` domain — the Belt-model equivalent of stealing a signing key.

## 6. Commissioning Ceremony Compromise (CAPABILITY_TOKEN Model)

Section 6.2 draws the line explicitly: stealing individual fobs is a local incident;
compromising the ceremony that mints them is the domain-root event. The exploit is
getting a domain to misjudge which one just happened — either downplaying a real
ceremony compromise as "just some stolen fobs," or panicking a domain into an
unnecessary, disruptive Section 6.2 emergency unbind over what was actually a
contained local theft.

**Player gains:** either continued undetected minting authority (if the real
compromise gets dismissed), or a costly, reputation-damaging false-alarm domain unbind
inflicted on a rival (if a local incident gets deliberately misreported upward).

## 7. Clock-Rollback Grant Extension (LEASED_ENTITLEMENT Model)

Already named as a known, undocumented-as-a-bug pattern in Section 6.1: a device
rolls its own local clock back to keep a lapsed EntitlementGrantRecord's cached grant
looking unexpired. This RFC doesn't pretend the flaw doesn't exist — which means it's
fair game as a documented, expected exploit rather than a secret one.

**Player gains:** continued access under a technically-expired grant, for as long as
the device stays disconnected from the licensing server long enough for nobody to
notice the clock is wrong.

## 8. TrustTag Squatting

Values 6–15 are reserved for sub-domain allocation via registration (Section 3), but
nothing stops a device from presenting an unregistered value in that range before
anyone's checked. A conforming implementation is required to treat it as "inheriting
the parent lineage's tag pending registration" rather than rejecting it outright —
which is itself the exploitable gap: squat a sub-domain tag, get parent-lineage trust
by default, and never actually complete the registration that was supposed to give
you narrower, more scrutinized standing instead.

**Player gains:** parent-lineage trust benefits without ever going through the
sub-domain registration process that was supposed to be the actual gate.

## 9. Liability Gaming (Social/Political, UN‑IG Process)

Section 7.1 assigns fault based on which domain's PolicyRecord governed the acceptance
decision, not on which domain's technical claim was correct. That's exploitable
politically: deliberately accept a borderline-scoped credential, then argue after the
fact that the *other* domain's root attestation model was inherently misleading —
trying to shift a finding of "insufficient consideration of cross-domain scope" onto
the other party even when the accepting domain's own PolicyRecord was the actual gap.

**Player gains:** no technical access at all — this is a pure diplomacy/dispute-arena
play, useful for offloading liability rather than gaining a credential.

## 10. Domain-Level Emergency Unbind as Denial-of-Service

Section 6.2 makes a domain-wide unbind deliberately hard to invoke precisely because
of how disruptive it is — which makes *falsely triggering one* an attack in its own
right. Convince UN-IG's D.4 concurrence process that a domain's root is compromised
at scale when it isn't, and every credential that domain has ever issued goes suspect
pending re-issuance, all at once.

**Player gains:** system-wide disruption of a target domain's entire operational
capacity, without compromising a single actual credential.

---

# II. Mission / Storyline Hooks

## 1. "The Console That Thought It Was a Nation"

A single Scrapshell station's dockworker election gets treated, by a badly-written
relay firmware, as domain-wide Belt authority. Someone's already exploiting it quietly
— find out how far the false standing has spread before a real audit catches it.

## 2. "Ratified By Nobody"

A WitnessQuorumRecord surfaces claiming a fresh Belt domain anchor, co-signed by a
"recognized representative body" nobody can quite account for. Trace the Sybil
roster back to whoever assembled it — a rival faction, or the Belt's own recognized
representatives quietly padding their own numbers.

## 3. "The Ceremony Everyone Forgot to Guard"

A Mars fleet office's commissioning ceremony was compromised weeks ago. So far it's
only ever been reported as "a batch of stolen fobs" — a much smaller, much less
alarming story. Figure out which version is true before someone mints an
unauthorized fob using the real, still-open ceremony access.

## 4. "Clockwork Alibi"

A Corporate device has been running on a rolled-back clock for months, quietly
treating a lapsed entitlement as current. It's not sophisticated. It's not even
hidden. Decide whether to report it, exploit it further yourself, or find out who's
been letting it slide and why.

## 5. "Whose Fault, Exactly"

A cross-domain credential dispute lands in UN-IG's queue. Both domains did everything
their own policy required. Player has to build (or dismantle) the liability case per
Section 7.1's actual fault-assignment logic — a pure argument, no technical exploit
required, decided entirely on whose PolicyRecord governed the acceptance.

## 6. "The Tag Nobody Registered"

A sub-domain has been operating under a squatted TrustTag in the 6–15 range for
months, inheriting parent-lineage trust it was never formally granted. The Trust
Domain Registrar role from Appendix E is still "proposed but not yet formally
constituted" — which means there's currently nobody whose actual job it is to notice.

## 7. "The False Alarm"

Someone triggers UN-IG's D.4 emergency-unbind concurrence process against a rival
domain that was never actually compromised. Every credential that domain has issued
goes suspect overnight. Find out who filed the false report before the affected
domain's entire operational capacity finishes collapsing.

---

# III. Game Structures (How RFC‑2362 Becomes Gameplay)

## 1. TrustDomain Inspector

Validates that a TrustDomain record's declared root attestation model actually
matches what its authority_reference resolves to (Section 2.3). The primary tool for
catching Exploit #3 — flags a `CHAIN_OF_CUSTODY` claim backed by a WitnessQuorumRecord
as malformed on sight, rather than needing a human to notice the mismatch.

## 2. Local/Domain Root Discriminator

Purpose-built around Section 2.4: given a claimed root event, determines whether it's
a local-scope action (one console, one relay, one fob) or a genuine domain-scale
anchor claim. Directly targets Exploit #1 — the tool a careful domain runs on every
incoming credential specifically to prevent local root from being mistaken for
domain root.

## 3. PolicyRecord / CrossCertRecord Cross-Checker

Given a CrossCertRecord, verifies an actual underlying PolicyRecord exists and
matches — catching Exploit #4 (forged CrossCertRecords with no real acceptance
behind them) and Exploit #2 (unintended transitivity, by refusing to treat any
implied chain as equivalent to an explicit record).

## 4. Quorum Roster Auditor

For `QUORUM_WITNESS` domains: cross-references a WitnessQuorumRecord's co-signers
against the domain's actual recognized-representative body, flagging Sybil-stacked
rosters (Exploit #5) that technically hit quorum threshold N without being N
*legitimate* signers.

## 5. Ceremony/Theft Classifier

For `CAPABILITY_TOKEN` domains: given a capability-token incident report, helps
determine whether it's a contained local theft or a commissioning-ceremony-level
compromise (Section 6.2's own distinction) — directly relevant to Exploit #6 and
Mission Hook #3.

## 6. Liability Case Builder

UN-IG's own tool, mechanized: assembles a Section 7.1 fault-assignment argument from
a dispute's actual PolicyRecord trail, rather than from which domain's technical claim
was correct. Used both to build and to contest Exploit #9's liability-gaming plays.

## 7. Domain-Root Compromise Simulator

Models the blast radius of a suspected domain-wide root compromise before actually
declaring a Section 6.2 emergency unbind — lets a domain (or UN-IG, per Appendix D.4)
weigh the disruption of unbinding everything against the risk of leaving a genuine
compromise unaddressed, without needing to trigger the real, deliberately-hard-to-
invoke mechanism just to find out.

---

# IV. Software Tools (Technical + Social)

## A. Earth/UN Tools (Formal, Bureaucratic, Heavy)

**domainCheck‑CAR** — Canonical Address Registrar's own TrustDomain record
validator. Checks model/authority_reference consistency (Section 2.3) and TrustTag
range legitimacy. Features: registry-grade accuracy, batch validation across an
entire deployment, auto-flags Exploit #3 and #8 patterns.

**policyTrace‑SSWG** — Walks a claimed cross-domain recognition back to its actual
PolicyRecord, refusing to accept a CrossCertRecord on its own say-so. Features:
full chain-of-custody-style audit trail, flags Exploit #2 (unintended transitivity)
and Exploit #4 (CrossCertRecord forgery) with equal rigor.

**caseFile‑UNIG** — UN Trust & Interoperability Governance Council's own dispute
case-builder. Features: guided PolicyRecord-trail assembly matching Section 7.1's
actual fault-assignment logic, D.4 emergency-unbind concurrence workflow, official
seals nobody finds reassuring.

**registrarQueue** — Bureaucratic TrustTag sub-domain allocation tracker for values
6–15. Features: strict order-received processing (per Section 3's own promise),
painfully slow, exactly accurate.

## B. Mars Tools (Efficient, Militaristic)

**ceremonyWatch** — Monitors a fleet commissioning office's own minting ceremony for
signs of compromise, distinct from routine individual-fob loss reports. Features:
ceremony-access audit logging, real-time alert on any minting event outside scheduled
windows, directly targets Exploit #6.

**fobSweep** — Rapid mass-revalidation of every capability token issued under a
domain, run the moment a ceremony compromise is confirmed. Features: bulk
recovery/destruction tracking, distinguishes cleanly-revoked fobs from ones that
never get accounted for.

**quorumBreaker** — Aggressive Sybil-detection tool repurposed from Mars's own
distrust of the Belt's quorum model: stress-tests a WitnessQuorumRecord's co-signer
roster against known-legitimate representative lists. Features: fast, blunt, not
always welcome when run on someone else's domain.

## C. Belt Tools (Improvised, Clever, Chaotic)

**whodat** — Cheap, everywhere, passive local/domain root discriminator — the Belt's
own answer to Exploit #1, built out of necessity after one too many stations got
their local dockworker vote mistaken for Belt-wide standing. Features: no UI to
speak of, just a yes/no on "is this claim actually domain-scale."

**rosterjank** — Chaotic quorum-roster patch tool, used both to legitimately update
a station's recognized-representative list and, less legitimately, to pad it.
Features: fast, messy, the same tool serves both Structure #4's defensive use and
Exploit #5's offensive one depending on who's holding it.

**clockback** — The tool behind Exploit #7, openly circulated rather than hidden,
since the RFC itself already admits the flaw exists. Features: local clock
manipulation, cached-grant revalidation trigger, absolutely no subtlety.

**fauxquorum** — Social-engineering prompt-crafter tuned for convincing a handful of
station reps to co-sign a claim event they haven't actually vetted — the human side
of Exploit #5, for when technical Sybil identities aren't available.

## D. Universal / Canonical Tools (Definitive Versions)

**Canonical Trust Domain Validator (CTDV)** — The gold-standard version of
domainCheck‑CAR: registry-recognized, admissible-without-corroboration validation of
any TrustDomain record against all four root attestation models at once.

**Transitivity Firewall (TF)** — Definitive implementation of "trust is not
transitive by default." Refuses to propagate any inferred trust relationship that
doesn't have its own explicit PolicyRecord, full stop — the tool every domain
*should* be running, per Appendix A's own rationale, whether or not they actually do.

**Domain Root Ledger (DRL)** — Canonical, cross-model registry of confirmed
domain-root events (AnchorRecord signings, WitnessQuorumRecord anchors,
CapabilityMintRecord ceremonies, EntitlementGrantRecord issuances) — the single
source of truth Exploit #1 and #3 both try to route around.

**Fault Ledger (FL)** — UN-IG's own definitive, non-gameable version of
caseFile‑UNIG: assigns Section 7.1 liability purely from the recorded PolicyRecord
trail, immune to Exploit #9's after-the-fact reframing because it never considers
anything except what was actually on record at the time of acceptance.

---

# V. Suites (Grouped Tools)

### 1. Consistency Suite
- TrustDomain Inspector (structure) / Canonical Trust Domain Validator (definitive)
- domainCheck‑CAR (faction variant)

### 2. Escalation Suite
- Local/Domain Root Discriminator (structure), no faction-neutral definitive tool yet
  — Appendix E's own open item (domain-root body composition still unnamed) blocks a
  truly universal version
- whodat (Belt variant)

### 3. Transitivity Suite
- PolicyRecord / CrossCertRecord Cross-Checker (structure) / Transitivity Firewall
  (definitive)
- policyTrace‑SSWG (faction variant)

### 4. Quorum Suite
- Quorum Roster Auditor (structure) / Domain Root Ledger (definitive, cross-model)
- quorumBreaker, rosterjank, fauxquorum (faction variants — attack and defense share
  the same tool family, per Exploit #5's own dual-use nature)

### 5. Ceremony Suite
- Ceremony/Theft Classifier (structure)
- ceremonyWatch, fobSweep (Mars variants)

### 6. Liability Suite
- Liability Case Builder (structure) / Fault Ledger (definitive)
- caseFile‑UNIG (faction variant)

---

# VI. Schemas to Craft (`db/` Implementation Work)

RFC‑2362 is drafted but, per `db/CORPUS-STATUS.md`, not yet converted to `db/`
schema — and it leans hard on RFC‑2302 ledger record types (AnchorRecord,
PolicyRecord, CrossCertRecord, RevocationRecord) that **also** aren't schematized
yet. That's a real prerequisite gap, not just a nice-to-have: several of the schemas
below can't be fully specified until RFC‑2302's own conversion pass happens, since
they extend or reference its record shapes directly.

## New schemas RFC‑2362 requires

- **`db/trust/rfc2362-trust-domain.json`** — the TrustDomain record itself:
  `domain_id`, `trust_tag` (0–15 reserved range per Section 3), `root_attestation_model`
  (enum: `CHAIN_OF_CUSTODY` / `QUORUM_WITNESS` / `CAPABILITY_TOKEN` /
  `LEASED_ENTITLEMENT`), `authority_reference` (a pointer whose target type MUST match
  the declared model, per Section 2.3 — the schema should enforce this at the type
  level, not leave it to runtime validation alone).
- **`db/trust/rfc2362-witness-quorum-record.json`** — member set reference, quorum
  threshold N, N co-signatures, TTL (Section 2.2). No persistent-key field at all —
  its absence is the point, don't schema in a nullable AK field "just in case."
- **`db/trust/rfc2362-capability-mint-record.json`** — token identity, minting-event
  authority reference, scope (Section 2.2).
- **`db/trust/rfc2362-entitlement-grant-record.json`** — grantor reference,
  entitlement scope, expiry, and an explicit cached-grant-fallback-behavior field
  (Section 2.2) — this field existing at all is what makes Exploit #7 a documented,
  expected weakness rather than an undefined-behavior bug; don't schema it away.
- **`db/trust/rfc2362-trusttag-registry.json`** — the fixed 0–15 assignment table
  from Section 3, as data rather than hardcoded logic, so a future Trust Domain
  Registrar role (Appendix E, not yet constituted) has an actual file to write to.

## Existing schema this RFC extends (already built)

- **`db/trust/rfc2301-key-hierarchy.json`** — already covers the AK/DK/SK/session-key
  hierarchy RFC‑2362 depends on directly (Section 2's `CHAIN_OF_CUSTODY` model, the AK
  footnote). No changes needed here; RFC‑2362 only adds a consumer, not a new field.

## Blocked on RFC‑2302's own conversion pass (not yet started)

- **`db/trust/rfc2302-anchor-record.json`** (would be) — RFC‑2362 §2.1 depends on
  this existing and staying exactly as-is for `CHAIN_OF_CUSTODY` domains.
- **`db/trust/rfc2302-policy-record.json`** (would be) — load-bearing for RFC‑2362 §4's
  entire non-transitivity rule; without a real schema, "PolicyRecord" is currently
  only a name any implementation can interpret however it likes, which is exactly
  the kind of gap Exploit #2 and #4 live in.
- **`db/trust/rfc2302-cross-cert-record.json`** (would be) — same dependency, for
  cross-domain acceptance logging specifically.
- **`db/trust/rfc2302-revocation-record.json`** (would be) — needed for RFC‑2362 §6.1's
  `CHAIN_OF_CUSTODY` revocation case.

**Recommendation:** schema RFC‑2302's four record types first, or at minimum stub
them with the exact field sets RFC‑2362 §2.1/§4/§6.1 already specify — several of
the exploit-detection tools in Section III/IV above (PolicyRecord/CrossCertRecord
Cross-Checker, Transitivity Firewall, Fault Ledger) can't be implemented for real
until PolicyRecord and CrossCertRecord exist as actual, checkable schema rather than
prose description.
