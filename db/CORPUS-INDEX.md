# SolNet RFC Corpus — AI-Friendly Index

Status: built 2026-09-05, full read-through of `docs/vault/New RFCs/`,
`docs/vault/RFCs/` (superseded), and `docs/vault/RFC Companion/`. Purpose:
let Gary and Sid answer "what does RFC-XXXX actually say about Y" from
this file first, without re-reading the source RFC (some of which run
5,000-9,000 lines), only falling back to the full text when a design
decision genuinely needs the exact wording.

This is a reference, not a replacement for `db/CORPUS-STATUS.md` (which
tracks conversion status to `db/` schemas) — this index is about *what
the RFCs say*; CORPUS-STATUS.md is about *what's been turned into
game content*. Read both when doing corpus work.

Building incrementally below as the read-through proceeds.

---

## RFC-2300 — SolNet Terms and Concepts (2480 lines)

**Status:** ✅ §1-7 converted to `db/vocabulary.json`. §8-15 + Appendices
A-E are a real, confirmed problem — see finding below.

**§1-7 (the actually-foundational part, ~410 lines):** defines UUID-S7
(opaque, time-sortable canonical identity anchor, deliberately carries
no location/authority — that's LocationChain's job), LocationChain/
ServiceChain (`<LocationChain> // <ServiceChain>`, `//` mandatory
exactly once), the L-stack/S-stack (Location Plane = who/where,
Service Plane = what/how, legacy aliases Authority Plane/Namespace
Plane), the L0/L1 physical+data-link split (L1-L vs L1-S header
regions), Role Weight, PNI (personal device identity, doesn't need
full Location anchoring), LedgerAnchor. §5's layer model: L0 physical
substrate, L1 data-link split, L2-L5 Location Plane (Identity
Resolution, Directory/Reachability via DREs' `//info`/`//beacon`,
Routing/Mobility, Trust/Policy), S2-S5 Service Plane (Local Service
Resolution, Local Directory/Discovery, Session layer, Local Security/
ACLs). §6 device identity hierarchy (hardware roots → DeviceKeys →
Session Keys → PNIs → delegated credentials) and registration/binding
tiers (unanchored/partially/fully anchored). §7 security principles
(minimize L1-L exposure for personal devices, ServiceChain MUST NOT
imply global identity).

**§8-15 + Appendices A-E (~2070 lines, the majority of the document)
— CONFIRMED problem, not just suspected.** `CORPUS-STATUS.md` already
flagged §§8-15 as "likely" misplaced content that belongs in RFC-2350
instead. Full read-through confirms this concretely: this whole back
half is a TLV registry (§8), error handling (§9), security (§10),
interoperability (§11), operational behavior (§12), conformance
requirements (§13), document maintenance/revision process (§14),
registry/allocation procedures (§15), plus five appendices — i.e., a
second, nearly-complete Canonical Addressing Standard, sitting in the
wrong RFC, largely duplicating what RFC-2350 already covers.

**New, more serious finding from this read-through:** it doesn't just
duplicate RFC-2350 — **it actively contradicts both RFC-2350 and
RFC-2300's own earlier §§1-7**, in Appendix B's ABNF specifically
(declared "normative" in its own text):
```
AddressRecord     = LocationChain [ServiceChain] [ProvenancePointer]
LocationChain     = 1*(BareToken / TLV) ProvenancePointer
ServiceChain      = 1*(BareToken / TLV)
BareToken         = 1*(ALPHA / DIGIT / "-" / "_")          ; no dot
TLVChar           = ALPHA / DIGIT / "-" / "_" / "." / "/"   ; includes /
```
Three concrete problems with this, independent of the separator issue
already in `rfc-proposals/rfc2350-addressing-grammar.md`:
1. **No `//` at all.** LocationChain and ServiceChain are just
   concatenated with no delimiter token in this grammar, directly
   contradicting §4.3's own prose two sections earlier ("The `//`
   boundary is mandatory. Parsers MUST enforce a single `//`.").
2. **ProvenancePointer is mandatory here**, appended to every
   LocationChain — but RFC-2300's own worked examples elsewhere in the
   same document (`MCRC:ALPHAFLEET:DONNAGER`) have no ProvenancePointer
   at all, and RFC-2350's version makes it explicitly optional. Taken
   literally, this grammar makes RFC-2300's own examples non-compliant.
3. **`TLVChar` permits a literal `/`** inside a TLV value — a real risk
   given `/` is the exact character used for the `//` boundary and (per
   RFC-2350) element separation; embedding a raw `/` inside a TLV value
   creates real ambiguity with boundary detection that nothing in
   either document addresses.

**Recommendation:** this is the single highest-value cleanup target in
the whole corpus — not a new RFC to draft, but resolving an existing,
now-confirmed self-contradiction. See "Priority RFC work" section at
the end of this index.

**Cross-references:** RFC-2362 (Trust Domains, not yet drafted) is
where L5's cross-domain trust/policy rules need to actually land.
RFC-2360/2481 (formal L1 encodings, minimal DTN profile) listed as
next steps in §14, neither exists yet under those numbers in
`New RFCs/` — worth checking if they were ever started under the old
numbering scheme in `RFCs/` (they weren't — see that section below).

---

## RFC-2301 — Cryptographic Primitives (138 lines)

**Status:** ✅ converted, `db/trust/rfc2301-key-hierarchy.json`.

Short, clean, no internal issues found. Defines the key hierarchy:
Hardware Root (HR) → Anchor Key (AK, long-lived, binds
`AuthorityChain ↔ UUID-S7 ↔ AK.public` via NetworkCert, signs ledger
transactions) → Device Key (DK) → Service Key (SK, signs `//info`/
`//contact` DRE registrations) → Session Keys (ephemeral,
forward-secret) → one-time/emergency tokens. Property-based algorithm
requirements (not naming specific algorithms — that's deferred to
RFC-2452), post-quantum hybrid posture, key lifetimes (AK:
years-decades, DK: months-years, SK: days-months, session: per-session),
revocation via LedgerAnchor + emergency unbind.

**Confirms two things already used in game design:** Session Keys are
real and exactly as described ("short-lived... derived or negotiated
per session") — solid grounding for
`rfc-proposals/rfc2300-2302-reply-path-privacy.md`'s correlator
proposal. AK is treated here as *the* identity anchor mechanism
throughout, with no discussion of how Mars's capability-fob or
Scrapshell's quorum model would substitute for it — this is the same
root cause as the already-flagged `CORPUS-STATUS.md` concern about
RFC-2302's `AnchorRecord` assuming AK universally; it starts here, in
the crypto-primitives layer itself, not just in the ledger spec.

**Numbering inconsistency found:** §16 says "RFC-2360 (Layer Model)
will reference this RFC." But RFC-2300 §14 separately calls RFC-2360
"formal L1 header encodings" — a different topic. And the actual Layer
Model content lives at **RFC-2361** in the old numbering
(`docs/vault/RFCs/RFC 2361 - SolNet Layer Model.md`), while the old
folder's own RFC-2360 is titled "Error Codes" — a third, unrelated
topic. So "RFC-2360" is used with at least two different intended
meanings across New RFCs/ documents, and matches neither its own old
number's real topic. Likely a simple off-by-one (2360 vs 2361) in
RFC-2301's text. Referenced-but-undrafted in New RFCs/: RFC-2451
(hardware root requirements), RFC-2452 (concrete algorithm/timeline
choices).

---

## RFC-2302 — SolNet Ledger Specification (201 lines)

**Status:** 📝 not yet converted to `db/`, but already has real
mechanical game-design use — see `os-lineages.md` §3's quorum-multisig
design and `rfc-proposals/rfc2300-2302-reply-path-privacy.md`.

Defines LedgerAnchor: a replicated, append-only, signed log. Record
types: **AnchorRecord** (binds UUID-S7 ↔ AuthorityChain ↔ AK.public,
signed by AK), **RevocationRecord**, **CrossCertRecord** (cross-
signatures between anchors, "signed by both parties" — the closest
existing precedent to a multisig-style record), **AuditEvent**,
**PolicyRecord** (trust-domain policy statements), **IndexRecord**
(non-authoritative). Canonical conflict resolution order (§5): find
AnchorRecords → validate signatures → check revocations → prefer
earliest-anchored/trust-authority-signed on conflict → expose
resolution metadata, never silently accept a conflict. §6 replication:
eventual, tolerates long partitions, **local caching with required TTL/
freshness metadata** — this is the exact mechanism cited for
`claim`'s degradation-timeframe design. §9 deployment models:
permissioned federation, permissionless append-only (community/
reputation-based — the closest existing fit for a union-run local
ledger), hybrid, **local ledgers** (small domains, "may run local
ledgers for internal anchors," the deployment mode the quorum-multisig
design uses).

**Confirmed compatibility check (already done, recorded in
`CORPUS-STATUS.md`):** the quorum-multisig game design deliberately
avoids `AnchorRecord` for the same reason CORPUS-STATUS.md already
flags it (assumes persistent AK as universal root authority,
specifically Earthstock's model) — a quorum-vote record needs its own
shape (N signatures + TTL, no AK implied), not a formal type in the
RFC text yet. Worth drafting that record type explicitly if this ever
gets converted to `db/`.

**Cross-references:** §16 next steps list RFC-2361 (Layer Model —
correct number this time, matches the old-folder title) referencing
ledger semantics for A-stack, and **RFC-2363 (Identity Resolution)**
— neither drafted in New RFCs/ yet.

---

## RFC-2302A — Ledger Deployment Models (230 lines)

**Status:** 📝 not converted, companion to RFC-2302. No internal
inconsistencies found — well-organized, practical.

Two concrete deployment families for RFC-2302's abstract LedgerAnchor
semantics: **Permissioned Federation** (bounded trusted-operator
replica set, BFT consensus, near-instant deterministic finality, good
privacy, explicit governance — fleets/governments/corps) and **Hybrid
Blockchain** (permissioned core + optional public-chain anchoring via
CrossCertRecord for global tamper evidence/discoverability, at the
cost of fees/slower finality/metadata leakage). §13 recommends a
**hybrid default**: permissioned federation for high-trust anchors,
optional public anchoring for select records. §8's partition handling
directly matches what game design already needs: local append allowed
during a partition (`LOCAL_ORIGIN`/`PROVISIONAL` flags), grace windows
before unresolved conflicts escalate to CONFLICT state (24-72 hours
suggested), reconciliation on rejoin per RFC-2302 §5's rules.

**Directly relevant to Scrapshell's local ledger use (already applied
in game design):** §12 explicitly names "small operators... rely on
cross-certs from trusted operators rather than public chain fees" and
personal devices avoiding direct public anchoring — both consistent
with treating a Scrapshell union's local ledger as a **local,
permissionless, reputation-based deployment** (matches RFC-2302 §9's
own category) rather than needing federation-grade infrastructure.

**No drafting gaps of its own** — §14's next steps (Permissioned
Federation Implementation Guide, Hybrid Bridge Spec, light-client API
formats, partition/reorg test suites) are all implementation-detail
follow-ons, not blocking conceptual work.

---

## RFC-2303 — Physical Media and Propagation (318 lines)

**Status:** 📝 not converted. Well-organized, thorough, no major
internal contradictions found.

Defines the store-and-forward propagation model directly underlying
`ARCHITECTURE.md` §2's bundle/DTN transport primitive: link types and
required metadata (terrestrial/optical/deep-space-radio/couriered-
storage/constrained-local, each publishing latency/bandwidth/
reliability/schedule), the **PROVISIONAL → CONFIRMED** state machine
(local append = provisional, promoted once replication criteria met —
quorum, cross-signatures, or public-chain inclusion), receipts at
every hop (local origin → relay acceptance → core replication →
inclusion proof), courier/manifest semantics (signed manifests,
chunked resumable transfer, custody AuditEvents), constrained-device/
light-client handling (compact proofs from ≥2 independent relays,
"never trust one relay," DRE confirmation required for
high-consequence actions). §Appendix is worth quoting directly for
game design: freshness metadata (timestamps/sequence numbers) is
**never trusted on its own** — a record with fresh timestamps but no
confirmation is still provisional; a record with old timestamps but
confirmed status is authoritative. Attackers can fake freshness, not
confirmation.

**Numbering inconsistency found:** §19 lists "RFC-2304: Relay and
Courier Operations" as a next step — but the actual RFC-2304 in
New RFCs/ is **"Antenna Geometry and Alignment,"** an unrelated topic.
Same class of error as RFC-2301's RFC-2360 mismatch: a next-steps
reference pointing at a number that got used for something else. §19
also references RFC-2363 (Identity Resolution, still undrafted
anywhere) consistently with RFC-2302's own next-steps section.

---

## RFC-2304 — Antenna Geometry and Alignment (637 lines)

**Status:** 📝 not converted (Companion doc exists, see below). Solid,
no internal contradictions found, and it correctly cross-references
RFC-2303 by its real title (the reverse direction of RFC-2303's own
wrong reference to this RFC).

Reference frames (Platform-Fixed, Local Horizon, Inertial — via
FrameDefinitionRecord), record types (AntennaGeometryRecord,
AlignmentStateRecord — pointing/error/confidence/mode: idle/
acquisition/tracking/re-acquisition, EphemerisRecord, BeaconRecord,
AlignmentPolicyRecord, AlignmentEventRecord). Consistent "surface
uncertainty, don't hide it" doctrine throughout — same one already
cited for `bat`'s design (RFC-2304 phrasing: "a platform that admits
'this ephemeris is approximate and old' is still better than one that
pretends to be precise"). §15's four worked workflows (initial
acquisition, tracking during relative motion, re-acquisition after
loss of lock, constrained-device participation) are genuinely detailed
and could ground a real relay-alignment minigame/puzzle if this ever
gets picked up as content. AntennaGeometryRecord and
AlignmentStateRecord are exactly the two record types
`ARCHITECTURE.md` §7's open question #7 already lists as
referenced-but-not-yet-modeled.

**References RFC-23xx "Link Budget and Modulation Profiles (future)"**
honestly as an unassigned placeholder number — not an inconsistency,
just flagging it's genuinely not drafted anywhere.

---

## RFC-2305 — Power and Duty Cycle Constraints (663 lines)

**Status:** ✅ converted — `db/protocols/rfc2305-duty-reservation.json`,
`db/hardware/relay-courier-rig-class-c.json`. Already resolved: the
HANDWAVE_TX/confirmed-reservation split (`CORPUS-STATUS.md`). No new
internal contradictions found beyond what's already tracked.

Policy (PowerPolicyRecord, DutyCycleRecord) vs. state
(PowerStateRecord, DutyScheduleRecord) split. Power classes A
(continuous high) through D ("Point and pray" — constrained/battery/
unstable). Reservation model: a `DutyScheduleRecord` is advisory until
a relay signs a `ReservationReceipt`; §16.1's stress behavior is the
line already quoted in `os-lineages.md` §6 ("Blindly transmitting...
without a confirmed reservation is a policy violation"). Emergency
overrides require two-party confirmation (operator + domain authority
signature — "SolNet's equivalent of a two-key launch system") and
devices retain unoverridable local safety cutoffs. Explicit inline
digression defining what "signature" means throughout the corpus
(always a real cryptographic signature, never a rubber-stamp/verbal
OK) — worth treating as the canonical definition to cite anywhere else
"signed"/"signature" comes up loosely.

**New reference found, not yet drafted anywhere:** the signature
digression cites "RFC-2361, RFC-2362, RFC-2368" as the identity/
authority layers publishing verification keys. RFC-2361 exists (old
folder, Layer Model). RFC-2362 doesn't exist yet (Trust Domains,
already the tracked blocker in `CORPUS-STATUS.md`). **RFC-2368 is a
new number, referenced here for the first time in this read-through,
not drafted anywhere** — worth finding out what it's meant to cover
before RFC-2362 gets drafted, in case it's a real dependency.

---

## RFC-2306 — Tightbeam Laser Subprofile (1496 lines)

**Status:** 📝 not converted (Companion doc exists). Distinctive voice
(Dr. Selene Vargo, MIAP Optical Systems Group — stern, condescending,
"the physics doesn't negotiate, operators do not reliably detect their
own errors") layered on top of otherwise-standard SSWG structure. No
internal contradictions found; unusually self-contained (doesn't lean
on other undrafted RFCs the way most of this corpus does).

Canonical beam lifecycle, a genuine finite state machine: **Reservation
→ Acquisition → Maintenance → Occlusion → Release** (occlusion must
re-enter Acquisition, never jump straight back to Maintenance). Record
types: BeamProfileRecord, ReservationReceipt, **AcquisitionReceipt**
(bilateral — both endpoints must countersign, unilateral acquisition
claims are explicitly invalid), TrackingHeartbeat, OcclusionEvent,
ReservationRef (compact pointer for constrained nodes). Three-step
adjudication (Record Validation → State Reconstruction → Outcome
Determination) resolves conflicts entirely from provenance, never
operator testimony — "the beam carries photons; the records carry
truth." Threat model (Appendix G) is worth reusing as a template for
other subprofiles: explicit adversary capability list (can spoof/
replay/induce-occlusion; cannot forge provenance or violate physics)
and five named attack classes (G1 Spoofed Acquisition through G5
Authority Injection).

**Best game-design fit of any RFC read so far** for a real puzzle: §9's
seven worked examples (correct acquisition under motion, an incorrect
unilateral claim correctly rejected, occlusion handled correctly vs.
misattributed as environmental, an anchor node prematurely asserting
TRUSTED state) are essentially pre-written puzzle scenarios — a
misconfigured/malicious anchor asserting TRUSTED without sufficient
ephemeris accuracy (§9.5) is a clean, self-contained vulnerability
already fully specified.

---

## RFC-2353 — L1 Relay Advertisement Protocol (24 lines)

**Status:** confirmed stub, matches `CORPUS-STATUS.md`'s suspicion.
Only an Abstract and a Purpose section — the abstract promises a
`RelayAdvertisement` record with capability masks, scheduling capacity
fields, and admission policy hooks, but none of that is actually
defined anywhere in the file. Nothing to extract yet; flag as
low-hanging fruit if a future drafting pass wants a quick, well-scoped
win — real content already outlines exactly what's needed.

---

## RFC-2350 — SolNet Canonical Addressing Standard (873 lines)

**Status:** 📝 not converted, high priority per `CORPUS-STATUS.md`.
Read in full — the §4 grammar issues are already captured in
`rfc-proposals/rfc2350-addressing-grammar.md`; new findings below go
beyond that, into cross-reference consistency across the whole corpus.
**This document has more internal/cross-document inconsistencies than
any other RFC read so far** — reinforces its existing high-priority
flag.

**New structural content not yet in the rfc-proposals doc:** the
canonical **AddressRecord** binary structure (§5) — seven fields in
fixed order: LocationChain, ServiceChain, TrustTag, QoSClass,
FreshnessTag, ProvenancePointer (optional), TLVContainer. The
**8-step resolution precedence pipeline** (§7): syntactic validation →
ordering verification → LocationChain eval → ServiceChain eval → TLV
interpretation → ProvenancePointer dereference → **DRE resolution** →
namespace escalation. This DRE-as-step-7 placement is good confirming
support for `rfc-proposals/rfc2300-dre-role-directory.md`'s design —
DRE lookup is explicitly the fallback *after* direct chain resolution
fails, not a first resort, matching the fast-path/fallback-path
sequencing already proposed there.

**Real findings, three separate categories:**

1. **RFC-2361 topic conflict.** §1 calls RFC-2361 "identity semantics."
   Every other document read so far (RFC-2300, 2301, 2302, 2303, 2304,
   2305) calls it "Layer Model," matching the actual old-folder
   document `RFC 2361 - SolNet Layer Model.md`. RFC-2350 is the
   outlier here, not the majority.
2. **RFC-2363 scope inconsistency, partly self-contradictory.** §1
   calls RFC-2363 "routing behavior" (declared out of scope). But
   §4.7, §5.8, and §6 all cite RFC-2363 for **ProvenanceRecord**
   definitions, and §6.5/§7.8/§7.9 cite it for the **Directory &
   Routing Endpoint (DRE)** — those two are at least internally
   consistent with each other (a DRE/routing RFC plausibly also
   defines provenance records), but RFC-2302 and RFC-2303 both
   separately call RFC-2363 **"Identity Resolution."** So across the
   corpus, RFC-2363 has been informally assigned at least three
   overlapping-but-not-identical scopes (identity resolution /
   provenance records+DRE / routing behavior) by different documents
   that were clearly never reconciled with each other.
3. **A real factual citation error, not just a topic label mismatch.**
   §5.2: "All AddressRecords MUST use the canonical varint-prefixed
   binary encoding defined in RFC-2301 and RFC-2302." Both RFC-2301
   (Crypto Primitives) and RFC-2302 (Ledger Specification) were read
   in full for this index — **neither document defines a varint
   encoding scheme anywhere.** This is the most concrete, checkable
   inconsistency found in the corpus so far: a specific technical claim
   ("this encoding is defined over there") that doesn't hold up when
   the cited documents are actually checked.
4. **A terminology conflation worth flagging even though it's minor:**
   §0.1 says "Authority Plane" (legacy) is now "LocationChain."
   RFC-2300 §5.3/§40 says "Authority Plane" (legacy) is now "**Location
   Plane**" — a whole architectural plane (L2-L5), not the LocationChain
   field specifically. LocationChain is one field *within* the Location
   Plane's data model, not a renaming of the plane itself. Minor, but
   a reader cross-referencing both documents would reasonably get
   confused about whether "Authority Plane" maps to an architectural
   layer grouping or a specific address substring.

**Confirmed, not contradicted:** RFC-2362 (Trust Domains) is a real,
concrete dependency — TrustTag values 0-15 are explicitly reserved for
it (§5.5), consistent with the existing `CORPUS-STATUS.md` blocker.
QoSClass values 0-7 are attributed to RFC-2351 (§5.6) — **confirmed
accurate**: RFC-2351 §17 defines exactly QoSClass values 0-7, see that
entry below.

---

## RFC-2307 — RF Propagation Subprofile (5519 lines)

**Status:** 📝 not converted. Extremely long, extremely repetitive by
design — read via headers + representative sampling of every major
section rather than word-for-word (the repetition is the point: a
"Contamination Boundary" subsection closes almost every one of its 21
main sections, restating the same discipline-over-improvisation theme
applied to a different domain each time). RF counterpart to RFC-2306,
distinctive voice again (Dr. Arjun Kade, who name-drops and
collaborates with RFC-2306's Dr. Vargo — a nice small continuity
detail between two otherwise-independent subprofile documents).

Record types: **RFChannelProfileRecord** (frequency range, bandwidth,
modulation, noise floor, interference class, beaconing/scheduled-band/
FHSS eligibility — four canonical profiles: Default, Scheduled-Band,
FHSS/LPI, High-Interference), **RFReservationReceipt**,
**RFInterferenceEvent**, **RFLinkQualityRecord**, DRE **RFChannel**
records, and an **RFChannelHint TLV** for L1. §13's security taxonomy
is genuinely reusable for game design: spoofed beacons, malicious
interference, provenance tampering, FHSS desynchronization attacks,
scheduled-band abuse, and — explicitly named as the single greatest
risk — **human factors** (operators who believe they understand RF
better than the system does, producing "temporary" overrides and
folklore-based troubleshooting that the document treats as
indistinguishable from an actual attack). Appendix D adds a formal
security state machine with prohibited transitions and a threat
matrix (Appendix G) with severity levels.

**Real structural defect found:** the document has no §3 at all — it
jumps from "§2 Scope" directly to "§4 Canonical RF Channel Profiles."
Combined with §1's own heading literally reading "Purpose (Rewritten
in Correct Kade Voice)" (an editorial artifact left in the shipped
text), this document shows visible signs of an incomplete revision
pass rather than a deliberate numbering choice.

**Worth noting as flavor, not a defect:** Appendix F is titled
"Abstract" and sits near the very end of the document rather than at
the top where an abstract would normally go — reads as a deliberate
rhetorical choice (a manifesto-style closing restating the thesis)
given the document's own closing lines lean hard into that register,
not a misplaced-content problem like RFC-2300's §§8-15.

---

## RFC-2308 — Media Privacy and Exposure Policy (2849 lines)

**Status:** 📝 not converted (Companion doc exists). Distinctive voice
again (Dr. Mara Ellison, SPEWG chair). Read via headers + full read of
the two most content-dense appendices (D "Private Notes (Classified)",
E "DRE State Machine excerpt from RFC-2363").

**Resolves the RFC-2363 confusion from the RFC-2350 entry above, with
real supporting evidence.** Appendix E is explicitly cross-referenced
as "**RFC-2363 — Directory & Routing Endpoints (DRE Layer)**," and
§1.1 independently says the same thing ("RFC-2363 (Directory and
Routing Endpoints)"). Combined with RFC-2350's own heavy DRE-related
citations of RFC-2363, that's now three independent documents agreeing
RFC-2363 is about **Directory & Routing Endpoints** — RFC-2302 and
RFC-2303's "Identity Resolution" label for the same number looks like
the actual outlier now, not an equally-weighted alternative.

**Separate, cleaner terminology drift found: "Reachability" vs.
"Routing."** RFC-2300 §5.3 — the *foundational terminology RFC*,
whose whole stated purpose is "give every subsequent RFC a common
foundation so implementers do not have to guess" — calls the concept
"Directory & **Reachability** Endpoints." RFC-2303, RFC-2308, and
RFC-2350 (three separate documents) all independently say "Directory &
**Routing** Endpoints" instead. The term-defining document is the
actual minority usage here, not the rest of the corpus.

**Real content, reusable for game design almost as-is:**
PolicyRecord schema (§3) and Domain Privacy Profiles per faction —
**UN (high regulation), MCRN (military regulation), OPA (mixed
compliance), Belter (low regulation)** — a real, already-drafted
four-way regulatory split that's a natural narrative complement to
this project's own four *OS-lineage* root models (different axis:
this is about metadata-exposure policy per political faction, not
authentication/authorization per OS lineage, but the factions line up
suggestively — UN≈Earthstock, MCRN≈Mars, Belter≈Scrapshell, OPA/
Corporate less directly mapped). A compliant **DRE state machine**
(Appendix E): INIT → VERIFY → EVALUATE → (EXPOSE | SUPPRESS) → AUDIT,
with FAILSAFE as the universal fallback from any failure and SUPPRESS
as evaluate's default path. Appendix D's "Private Notes (Classified)"
is genuinely quotable flavor with real design-doctrine value: **"the
most common phrase preceding an exposure cascade is 'It's just for a
moment,'"** and **"diagnostic bundles are the most common source of
catastrophic exposure"** — both excellent, mundane, non-movie-hacking
vulnerability framing consistent with this project's own stated
design philosophy. "Non-compliant chaos" (frontier/independent/Belter
operators who don't implement DREs at all) is treated as a hazard
class distinct from active adversaries — a useful three-way framing
(compliant / actively malicious / just chaotic-non-compliant) worth
carrying into `corporations.md`'s or `os-lineages.md`'s own threat
framing if it isn't already implicit there.

---

## RFC-2309 — L0 Test and Validation Suite (5692 lines)

**Status:** 📝 not converted (Companion doc exists, "Timing"). Read via
headers + representative sampling — this document is a structured
certification catalog (test scenarios, error codes, log field
definitions) rather than conceptual/narrative content, so it's lower
density for new inconsistencies but genuinely high-value as a *lookup
reference* if the game ever wants real fault/failure-mode simulation.
No internal contradictions found.

Structure: purpose/rationale → validation scope (physical-layer,
data-link, forensic reconstruction) → test harness architecture →
synthetic/adversarial/performance test packs → certification workflow
→ regression/logging/cross-vendor-equivalence requirements →
compliance levels. **Appendix A** is a real scenario catalog with
IDs worth reusing directly as content hooks — `SC-0100` (Nominal
Operation), `SC-0112` (Controlled Occlusion), `SC-1204` (Structured
Interference Envelope), `SC-2407` (Chaos Envelope Injection),
`SC-3301` (Thermal Drift Ramp). **Appendix C** is a full error-code
registry, cleanly banded by domain: 1000s timing/clock, 2000s state
machine, 3000s environmental reporting, 4000s interference/occlusion,
5000s logging/forensic, 6000s **security-relevant** (e.g.
`EC-6005 Unauthorized Emission Detected`, `EC-6013 Log Integrity
Failure`), 7000s vendor-defined, 8000s reserved. **Appendix D** gives a
clean 5-state fallback/recovery machine: `nominal → degraded →
fallback → recovering → nominal`, plus an `initializing` entry state.
§7's Adversarial Test Pack (malformed emissions, jitter injection,
partial occlusion/multi-path distortion, structured vs. randomized
chaos envelopes, contested-channel behavior) is a solid template for
designing new hardware `failure_modes` content, matching the shape
`db/hardware/relay-courier-rig-class-c.json` already uses.

---

## RFC-2351 — L1 Frame Format (A/N Header Split) (9071 lines, largest doc in corpus)

**Status:** 📝 not converted (Companion doc exists). Read via extensive
header-scan (Grep across the full document) plus targeted Read of
load-bearing sections; this is the single densest document in the
corpus and repetitive by design (every section restates the same
"minimal, non-extensible, no state at L1" philosophy from a different
angle), so full line-by-line reading isn't worth it past the first
confirmed pattern.

Defines the L1 header split into A-stack (Authority: routing/trust
metadata) and N-stack (Namespace: local service/discovery metadata).
**§6** the 7 core header fields: FrameType, QoSClass, FreshnessTag,
ProvenancePointer, TLVContainerLength, TLVContainer, CompactAuthTag.
**§7/§8** TLV container format + TLV Key Registry, banding TLV keys by
range: 0-31 SSWG-reserved, 32-63 A-stack, 64-127 N-stack, 128-255
vendor. **§11-13** the three header profiles: Minimal, Reduced, Full —
each profile MUST/MUST NOT a specific field/TLV/QoSClass subset, and
higher profiles MUST accept lower-profile frames (this asymmetry
matters, see finding below). **§17** QoSClass Registry: one byte,
values 0-7 defined (BestEffort, LowLatency, BulkTransfer,
ControlCritical, Discovery, Keepalive, AuthCritical, ReservedCritical),
8-255 reserved — **this confirms RFC-2350 §5.2's citation is
accurate**, resolving the open cross-check flagged in this index's
RFC-2350 entry. **§18** FreshnessTag semantics: minimal replay/recency
signal only, explicitly MUST NOT be used for ordering, QoSClass
interaction, or as a routing-loop/hop-count proxy — consistent with
the document's overall anti-scope-creep design stance. **§20** N-stack
TLV misuse prohibitions (explicitly bans using N-stack TLVs as a
service registry — the Working Group calls this out as a real
historical implementer mistake). **Appendix B** is the clearest
distilled design-philosophy statement in the whole corpus: B.1-B.5
walk through *why* L1 has no reliability, ordering, fragmentation, or
confidentiality (each rejected for concrete DTN reasons — long delays
break ACK/window assumptions, buffering costs power, fragmentation
conflicts with duty-cycle limits, confidentiality needs trust domains
that belong to A-stack not L1), B.12 "Why Relays Are Dumb," B.13 "Why
L1 Is Not Extensible." Worth reusing directly as in-game
flavor/justification text for why L1 tooling in Scrapshell feels so
bare-metal.

**Findings — two internal duplication defects, one of them a real
contradiction, not just a repeat:**

1. **§8 "TLV Key Registry" is duplicated verbatim**, out of numeric
   order: full §8 (with 8.1-8.5, the same 0-31/32-63/64-127/128-255
   range definitions) appears first at line 247, then §7 "TLV
   Container Format" appears *after* it at line 304 (so the document
   reads §8, §7, §8), then §8 repeats verbatim again at line 346 with
   identical opening text and range definitions. Directly verified by
   Read, not just Grep header list. Editorial/assembly error — no
   content difference between the two §8 instances, just a copy-paste
   duplication with a numbering hiccup.

2. **"Appendix H — Interoperability Matrix" appears twice, and the two
   versions actually disagree**, not just repeat — this is the more
   important of the two findings. First instance (line 4977): a 3×3
   profile matrix (Minimal/Reduced/Full × Minimal/Reduced/Full) where
   **every cell reads "MUST interoperate"** — i.e., full symmetric
   interoperability is mandatory across all profile pairs. Second
   instance (line 5208): a differently-structured table that states
   interoperability is **"asymmetric by design"** — e.g. Reduced→
   Minimal is **FORBIDDEN** ("Minimal MUST reject TLVs"), Full→Minimal
   is **FORBIDDEN** ("Minimal MUST reject TLVs and AuthTag"), Full→
   Reduced is **CONDITIONAL**. These are not reconcilable as written:
   the first table's "MUST interoperate" in the Reduced-sends/Minimal-
   receives cell directly contradicts the second table's "FORBIDDEN"
   for the same pair. Both instances independently verified by direct
   Read (not just the Grep header list). This is a real spec defect —
   worth flagging to the user since it isn't cosmetic (an implementer
   reading only the first Appendix H would build a Minimal-profile
   device that's supposed to accept Reduced-profile TLV-bearing frames;
   reading only the second, they'd reject them, which is also what the
   Minimal-profile field rules in §11-13 actually require elsewhere in
   the document). **The second instance's content is consistent with
   the rest of the document's asymmetric-interoperability framing
   (§11-13's own MUST/MUST NOT profile rules), so the first instance
   looks like the stale/incorrect one** — likely an earlier draft of
   the appendix left in place when it was rewritten, rather than two
   equally-valid alternatives.
