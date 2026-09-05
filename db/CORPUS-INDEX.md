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

Full read-through complete as of 2026-09-05: `docs/vault/New RFCs/`
(all 15 documents + the `wokring/` subfolder), `docs/vault/RFCs/` (all
16 old/superseded documents), `docs/vault/RFC Companion/` (all 13
files), and all three TODO documents. See `docs/NEXT-STEPS.md` for the
consolidated priority list and implementation TODO this read-through
produced.

---

## Cross-cutting findings summary

Every finding below is detailed in full in its own per-RFC section
further down this file — this summary exists so a reader (or Sid) can
scan the *shape* of what's wrong across the whole corpus without
reading 40+ pages of index. Four genuinely distinct categories emerged,
each with a different appropriate fix:

### 1. Numbering/topic mislabeling (find-and-fix-able, low risk)

Documents citing an RFC number for the wrong topic, in next-steps or
cross-reference sections — never in the cited document's own text, so
these are safe surgical fixes once verified against `TODOv2.md`
(confirmed canonical numbering ground truth):

- **RFC-2360 vs RFC-2361 swap**, the biggest one: `TODOv2.md` confirms
  **RFC-2360 = "SolNet Layer Model Revised"** and **RFC-2361 =
  "Identity Resolution L2."** Six documents (RFC-2300 §14, RFC-2301
  §16, and four others read early in this index, before the swap was
  caught) cite "RFC-2361" when they mean Layer Model — all six should
  say RFC-2360 instead. RFC-2350 §1's "identity semantics" label for
  RFC-2361 was the one *correct* citation, initially misread as the
  outlier. See the RFC-2301 entry below for the full resolution.
- **RFC-2304 mislabeled** by RFC-2303 §19 as "Relay and Courier
  Operations" (real topic: Antenna Geometry and Alignment).
- **RFC-2363 has at least three different informally-assigned scopes**
  across the corpus (Identity Resolution per RFC-2302/2303; Directory &
  Routing Endpoints + ProvenanceRecord per RFC-2350 §4.7/§6.5/§7.8-9)
  that were never reconciled — `TODOv2.md` settles this too:
  **RFC-2363 = "Directory and Routing Endpoints (DRE)."** RFC-2302 and
  RFC-2303's "Identity Resolution" label is the error.
- **RFC-2368 in RFC-2305** is a number never referenced by any other
  document — likely a typo for an adjacent Authority Plane number, not
  independently confirmed.
- **RFC-2370** (Relay Admission/Scheduling API) is treated as an
  "immediate priority" module across all three TODO documents but has
  no reserved slot in `TODOv2.md`'s block plan — Authority Plane
  entries stop at RFC-2368, leaving 2369-2389 unclaimed. Needs a
  formal number reservation, not a citation fix.

### 2. Factual/technical citation errors (checkable, real defects)

- **RFC-2350 §5.2** cites RFC-2301 and RFC-2302 as defining a
  varint-prefixed binary encoding. Neither document contains any such
  definition anywhere — confirmed by reading both in full. The most
  concrete, checkable error found in the corpus: a specific "defined
  over there" claim that doesn't hold up.

### 3. Structural/editorial defects within a single document

All confirmed by direct Read, not inferred from header scans alone —
and all concentrated in the corpus's largest documents, which appears
to be the actual risk factor (more content, more chances for a
copy-paste/reorder pass to go wrong), not a per-document coincidence:

- **RFC-2300** (2480 lines): Appendix B's ABNF contradicts its own
  body text; a garbled `# Appee without breaking compatibility.`
  fragment at line ~391 suggests a copy-paste assembly error; §§8-15
  are misplaced RFC-2350 content, not terminology (flagged in
  `CORPUS-STATUS.md` prior to this read-through).
- **RFC-2307** (5519 lines): missing §3 entirely; a leftover
  "(Rewritten in Correct Kade Voice)" heading artifact.
- **RFC-2351** (9071 lines, largest in corpus): §8 "TLV Key Registry"
  duplicated verbatim out of numeric order (§8, §7, §8); **Appendix H
  "Interoperability Matrix" duplicated with directly contradictory
  content** — one instance says full symmetric interoperability is
  mandatory, the other says it's asymmetric with FORBIDDEN cases (the
  second instance matches the rest of the document's own profile
  rules, so the first looks stale).
- **RFC-2352** (1254 lines): the single most severe defect found —
  its own **Front Matter title reads "RFC-2306"** instead of
  "RFC-2352" (RFC-2306 is a real, different, already-indexed
  document), inside normative front matter rather than body prose;
  **§39 duplicated verbatim with §40 missing entirely**; **Appendix J
  and K use leftover C./D. subsection-letter prefixes** instead of
  J./K., suggesting an unreconciled appendix-reordering pass.
- **`docs/vault/RFCs/` (old folder)**: not internally self-consistent
  on numbering at all — three separate number collisions (two
  different "RFC-2350"s, two different "2354"s, two different
  "2357"s) coexist in the same folder, a stronger warning than
  `CORPUS-STATUS.md`'s existing "don't cross-reference by number to
  the new plan" note. `RFC 2361 - SolNet Layer Model.md` states
  "seven-layer model" in §1 then enumerates eight layers in §2.
- **`TODOv2.md`** has unreformatted leftover conversation fragments
  after its own "Final Checklist" heading (an RFC-24xx autonomous-
  actors sketch, a doctrine-edit list, an Expanse-behaviors spot
  check) — genuinely useful content, structurally out of place.

### 4. Unremoved LLM-generation scaffolding (not a defect in normative

text, but worth knowing before trusting a file's framing)

This is its own category because it's a different *kind* of problem
than #3 — it never appears inside RFC body text itself, only in
draft/companion/planning material, and doesn't need "fixing" so much
as recognizing on sight:

- **`RFC 2359 - Bundle Addressing Protocol (BAP 1.0).md`** (old
  folder) ends with "✔ RFC‑2351 (BAP 1.0) is complete." (wrong number)
  followed by a dangling "If you want, I can continue with:" —  the
  clearest raw leftover in the corpus.
- **`RFC Companion/RFC 2309 - Timing.md`** preserves an entire two-way
  chat transcript verbatim, including the user's own casual replies.
- Nearly every large file in `RFC Companion/` opens or closes with a
  leftover conversational fragment from its generation session.
- `TODOv2.md`'s tail end (see #3 above) is the same pattern inside a
  planning document.

**Net read on severity:** categories 1 and 4 are cosmetic/organizational
— safe, low-priority cleanup whenever someone's doing an editorial
pass, no design decisions ride on them. Category 2 (the varint
citation) and category 3's contradictions (RFC-2351's Appendix H
above all) are the ones that could actually mislead an implementer and
are worth a deliberate, sign-off'd correction pass — see
`docs/NEXT-STEPS.md` for where these land in the priority list.

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

**Numbering inconsistency found (later confirmed against the master
plan — see the RFC-2350 entry below for the full resolution):** §16
says "RFC-2360 (Layer Model) will reference this RFC" — **this
citation is actually correct**, per `New RFCs/TODOv2.md`'s canonical
block plan (RFC-2360 = "SolNet Layer Model Revised"). But RFC-2300
§14 separately calls RFC-2360 "formal L1 header encodings" — that
topic is actually RFC-2351 per the master plan, so RFC-2300's citation
is the wrong one here, not RFC-2301's. (The old folder's own
"RFC-2360" being titled "Error Codes" is a red herring — per
`CORPUS-STATUS.md`'s standing rule, the old folder's numbers don't
correspond to the new plan at all, so it can't be used to adjudicate
which new-corpus citation is right.) Referenced-but-undrafted in New
RFCs/: RFC-2451 (hardware root requirements), RFC-2452 (concrete
algorithm/timeline
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

1. **RFC-2361 topic conflict — resolved by checking the master plan,
   and it flips who's actually wrong.** §1 calls RFC-2361 "identity
   semantics." Every other document read at this point in the index
   (RFC-2300, 2301, 2302, 2303, 2304, 2305) instead calls RFC-2361
   "Layer Model," matching the old-folder document `RFC 2361 - SolNet
   Layer Model.md` — which made RFC-2350 look like the outlier. **It
   isn't.** `New RFCs/TODOv2.md` (the actual numbering plan,
   `CORPUS-STATUS.md` says to "treat as canonical") assigns **RFC-2360
   = "SolNet Layer Model Revised"** and **RFC-2361 = "Identity
   Resolution L2"** — i.e. RFC-2350's "identity semantics" for 2361 is
   the *correct* one per the master plan, and the six other documents
   citing "RFC-2361" for Layer Model are all off by one and should say
   RFC-2360. This is worth a real fix pass across those six documents'
   next-steps sections once someone's doing that kind of editorial
   sweep — see Task #6/#7 below for how this feeds the priority list.
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

---

## RFC-2352 — L1 Privacy and Metadata Minimization (1254 lines)

**Status:** 📝 not converted (Companion doc exists). Read via header-scan
plus targeted Read of the front matter, structural sections, and every
appendix. Doctrinal in tone throughout — this is the "physical layer
MUST be completely uniform/unfingerprintable across every conceivable
axis" document. §§3-33 are a long, deliberately exhaustive enumeration
of invariance requirements (metadata minimization, prohibited fields,
residual handling, side-channel suppression, then a long run of
increasingly specific invariance requirements — temporal, spatial,
multi-path, cross-vendor timing, antenna/RF front-end, clock/oscillator,
environmental noise, power-cycle/boot, manufacturing-batch/aging) all
repeating the same "no observable variation may correlate with X"
pattern. §34 defines 3 conformance classes (A Full, B Constrained, C
presumably a third not fully sampled). §36 "Forbidden Behaviors
Summary," §37 Security Considerations, §38 Interoperability
Considerations. §42 References lists forward-pointers worth capturing
for the priority list: RFC-2360 (Layer Model, cited as "Revised" —
consistent with the majority naming already flagged in the RFC-2350
entry above), RFC-2364 (Ephemeris Hint Block), RFC-2421 (Error Codes &
Diagnostics — a new, never-elsewhere-seen number), RFC-2450 (Trust-
Domain Enforcement & Auditing — also new), RFC-2481 (Minimal Viable DTN
for Prototyping — also new), and an MIAP-Series (Martian
Interoperability & Alignment Protocols) not seen in any other document
read so far. **Appendices A-K** are genuinely good lore/flavor material:
introduces **SPERB** (SolNet Physical-Layer Exposure Review Board) as
the in-universe standards body enforcing this RFC, with a full
sub-bureaucracy (DEN, NEEB, CBR, CVCO, TSRB, ENAG, RNC, DIC, RCT, CRA)
— reads like a satirical but internally consistent regulatory apparatus,
worth mining directly for flavor text/lore if Scrapshell ever wants an
in-universe "why is L1 like this" voice distinct from the corpus's usual
Working-Group framing.

**Findings — three real defects, one of them the most severe
title/identity mismatch found in the corpus so far:**

1. **The document's own Front Matter title does not match its filename,
   its own H1, or its RFC number.** Lines 6-7 read: "**Title:** SolNet
   RFC‑2306 — Layer‑1 Invariance Specification" — but the filename is
   `RFC 2352 - L1 Privacy and Metadata Minimization.md`, the actual H1
   at line 19 reads "RFC‑2352 — L1 Privacy & Metadata Minimization,"
   and every cross-reference elsewhere in the corpus (including this
   document's own §42 References, which cites itself as "[RFC-2352] L1
   Privacy & Metadata Minimization") agrees it's 2352. "RFC-2306" isn't
   a stray number either — RFC-2306 is a real, different, already-
   indexed document in this corpus (Tightbeam Laser Subprofile). This
   reads like a copy-paste front-matter template that was never updated
   after being cloned from a different draft. Not a rendering artifact
   — directly verified by Read. Worth flagging to the user since,
   unlike the RFC-number-mislabeling-in-prose class of finding
   documented elsewhere in this index, this is inside the document's
   own normative front matter, the part most likely to get parsed by
   tooling.
2. **§39 "Implementation Guidance (Non-Normative)" is duplicated
   verbatim** (lines 671 and 687, identical text both times), **and
   §40 is entirely missing** — the document jumps §38 → §39 → §39 → §41,
   with no §40 anywhere. Same defect class as RFC-2351's duplicated §8
   and RFC-2307's missing §3 — a real, repeating pattern across this
   corpus's largest documents specifically (all three of the longest
   files read so far have exactly this kind of numbering breakage).
3. **Appendix J and Appendix K use the wrong letter prefix throughout
   their own subsections.** Appendix J ("SPERB Organizational
   Structure," line 1185) labels every subsection C.1 through C.11, not
   J.1-J.11. Appendix K ("Authorship," line 1220) labels its
   subsections D.1, D.2 (sampled), not K.1, K.2. (Appendix H, sampled
   for comparison, correctly uses H.1-H.6.) This looks like J and K
   were originally drafted as "Appendix C" and "Appendix D" earlier in
   the document's history, then re-lettered when appendices were
   inserted/reordered, with only the heading text updated and not the
   internal subsection numbering — consistent with the copy-paste/
   reordering pattern already seen in findings #1 and #2 above, and
   with RFC-2351's Appendix H duplication. Across this corpus, appendix
   reordering appears to be the single most error-prone editorial
   operation.

---

## `New RFCs/wokring/` subfolder — superseded working drafts (3 files, 1289 lines total)

**Status:** not part of canonical corpus, sampled only. `2300 new
combined.md` (315 lines) and `2300 smart doc.md` (361 lines) are both
earlier/alternate drafts of RFC-2300, superseded by the canonical
`New RFCs/RFC 2300 - Solnet Terms and Concepts.md` (already indexed
above) — same core definitions (UUID-S7, LocationChain/ServiceChain,
L-stack/S-stack), written in a more informal/editorializing voice
("Anyone mixing the old and new names... deserve the outage that
follows"). `2300 smart doc.md` is notably the more complete draft:
it appends a full TLV/profile extension model with its own key-range
partitioning scheme (`0x00-0x1F` Core hooks, `0x20-0x5F` L0
subprofiles) that does **not** match RFC-2351's canonical TLV Key
Registry ranges (0-31 SSWG, 32-63 A-stack, 64-127 N-stack, 128-255
vendor) — but since this is explicitly superseded draft material, not
live canonical text, this isn't a corpus inconsistency, just evidence
of how the TLV scheme evolved. `RFC 2306 - Tighbeam Laser
Subprofile.md` (613 lines) is a shorter/earlier draft of the canonical
1496-line RFC-2306 already indexed above. None of the three need
separate treatment — noted here only so a future reader doesn't
mistake them for undocumented canonical content.

---

## `docs/vault/RFCs/` — old/superseded folder (16 files, 5124 lines total)

**Status:** all 16 read in full (each 194-632 lines, small enough for
direct reading, no header-scan needed). Per `CORPUS-STATUS.md`'s
standing rule, **treat by topic, not number** — this folder predates
`New RFCs/TODOv2.md`'s numbering plan and reuses numbers for
completely different content than the canonical corpus. One
consolidated entry here rather than 16 separate ones, since the value
is in the architecture-as-a-whole and specific forward-pointers, not
per-file minutiae the way the huge `New RFCs/` documents needed.

**The whole folder is one internally consistent draft architecture**,
different from (and older than) the canonical `New RFCs/` L0-L5
model: **NNS (Network Namespace System) → UUID → BAP (Bundle
Addressing Protocol) → DTN routing**, with **PNS (Personal Naming
Service)** as the identity layer, all federated under loose trust
domains (HIGH/MEDIUM/LOW/UNKNOWN — Earth/Mars/Luna, Tycho/Ganymede/
Ceres, independents, unverified). This whole vocabulary (NNS, BAP,
PNS, AuthorityChain//NamespaceChain) was later replaced by the
canonical corpus's LocationChain//ServiceChain + UUID-S7 + DRE
vocabulary — genuinely useful as a "previous iteration" reference for
understanding *why* the current scheme looks the way it does, and as
literal source material for topics the canonical corpus hasn't drafted
yet (Authority Plane, Namespace Plane — see `CORPUS-STATUS.md`'s
existing per-topic cross-references, which this entry doesn't repeat).

**One genuinely new, valuable finding not yet flagged anywhere: this
folder already answers Dan's earlier open design question about
biometric authentication replacing passwords.** `RFC 2355 - Personal
Device Integration Guidelines.md` and `RFC 2356 - Personal Namespace &
Identity (PNS + keys).md` **independently and consistently** define
the standard SolNet personal-identity chain as **Biomarker → Keypair →
PNS Label(s) → Current NNS Address → BAP Routing** — biometric
authentication (fingerprint/retinal/voiceprint/DNA-hash) unlocks a
persistent keypair that *is* the real identity anchor, with human-
readable labels and routable addresses as disposable/mutable layers on
top. Explicitly supports disposable/anonymous devices (vending-machine
handsets), device handoff, and name changes without identity loss.
This is exactly the "passwords evolved into something biometric"
answer Dan was reaching for earlier in this session and it's already
established, twice, as old-draft canon — worth carrying forward into
whatever RFC eventually formalizes multi-user auth in the canonical
corpus (currently undrafted; `os-lineages.md` doesn't cover this yet
either), rather than inventing a new mechanism from scratch.

**Findings — three real defects, plus one instructive non-defect:**

1. **Two unrelated documents both claim to be "RFC-2350," and this
   pattern repeats for 2354 and 2357.** `RFC 2350 - NNS 1.0.md` (whose
   own H1 says "SolNet Canonical Addressing Standard," not "NNS 1.0" —
   a fourth mismatched-title instance, on top of the ones already
   found in `New RFCs/`) defines `AuthorityChain // NamespaceChain`
   addressing; `RFC 2350 - Revised SolNet Foundation.md` defines the
   entire NNS/UUID/BAP/PNS/DTN four-component architecture instead —
   totally different content under the same number, in the same
   folder. Same double-booking happens for 2354 (`DTN Routing
   policy.md` vs `Mobility Hint Block Spec.md`) and 2357
   (`Internamespace Gateway Protocol.md` vs `PNS Caching and Gossip
   Protocol.md`). This means the old folder isn't just "differently
   numbered from the new corpus" (as `CORPUS-STATUS.md` already
   documents) — **it isn't even internally self-consistent on
   numbering**, which is a stronger warning than previously recorded:
   don't just avoid cross-referencing its numbers to the new plan,
   avoid assuming any single number in this folder picks out one
   document at all.
2. **`RFC 2350 - NNS 1.0.md`'s own AuthorityChain//NamespaceChain
   grammar is the direct textual ancestor of the canonical
   LocationChain//ServiceChain grammar** — same two-chain-plus-`//`
   shape, same "left side is global/who, right side is local/what"
   split, same PNI shorthand (`<Identity>@<AuthorityChain>`), even the
   same worked examples reused nearly verbatim in the canonical
   RFC-2350 (`MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG-1:Reactor`).
   Not a defect — flagged here as confirmation, from primary source
   material, of what this session's addressing design conversation
   with Dan had already inferred and built `rfc-proposals/
   rfc2350-addressing-grammar.md` around.
3. **`RFC 2361 - SolNet Layer Model.md` miscounts its own layers.**
   §1 states "This RFC establishes the **seven‑layer model**," but §2
   then enumerates eight numbered layers (L0 Contact Ecology, L1 NNS,
   L2 Identity, L2.5 Jurisdiction, L3 BAP, L4 Mobility/Ephemeris, L5
   Session/Security, L6 Application). Whether L2.5 was meant to not
   count as a full layer (an inserted half-layer) or the "seven" is
   simply wrong isn't stated either way — same self-contradicting-
   count defect class as `New RFCs/RFC 2352`'s missing §40.
4. **`RFC 2359 - Bundle Addressing Protocol (BAP 1.0).md` ends with an
   unremoved AI-drafting artifact**, the clearest one found in the
   whole corpus: the document's closing line reads "# ✔ **RFC‑2351
   (BAP 1.0) is complete.**" (wrong number — every other reference,
   including the filename and the document's own H1, agrees it's
   RFC-2359, not 2351) followed immediately by "If you want, I can
   continue with:" — a dangling, mid-sentence offer-to-continue,
   clearly leftover from whatever generation process produced the
   draft, never cleaned up before being saved into the vault. Not
   normative content of any kind; purely an editorial leftover.

---

## `docs/vault/RFC Companion/` folder (13 files, 4163 lines total)

**Status:** all 13 read (full for the 8 small ones under 150 lines;
targeted sampling of the front matter + first major section for the
5 large ones — RFC 2308, 2309, 2350, 2351, 2352 companions, each
600-1100+ lines). **This folder is not RFC text at all** — per
`_companion prompt.md` (the actual prompt template used to generate
these, preserved as file #13), each companion doc is a **game-design
brief for one specific RFC**: fictional-but-plausible exploit classes,
mission/storyline hooks, in-game software tool concepts (with
faction-specific naming, e.g. "aircrack-ng for Earth" vs. a Belter-slang
equivalent), all explicitly framed as safe/fictional and non-actionable.
This is genuinely high-value, largely game-ready content, not a corpus-
consistency problem to fix — most of the analytical energy here should
go toward *using* it, not auditing it.

**Content by file:**
- **4 tiny fragment notes** (`Gravity Standards Poisoning.md`,
  `L1 Notes.md`, `LO Notes.md`, `RFC 2300 - Solnet terminology and
  concepts.md`, 10-28 lines each) — leftover scratch notes: L0/L1
  "optional expansion" number lists (several of which were never
  drafted and don't match any real RFC number in either corpus folder
  — treat as abandoned brainstorm, not a forward-pointer) and a short
  riff on "standards-gravity spoofing" as a conformance-poisoning
  attack concept.
- **`Paranoid Routers.md`** (149 lines) — not tied to a specific RFC;
  a genuinely excellent piece of emergent-behavior design doctrine
  about AI/router paranoia as a *rational* response to incomplete
  information + adversarial inference + local-only observation +
  real consequences for being wrong, tied to the corpus's existing
  "standards gravity" concept (paranoia is adaptive in low-gravity/
  low-witness environments, maladaptive in high-gravity ones). Explicitly
  proposes a doctrine sentence worth locking in somewhere durable:
  *"Inference systems may develop defensive bias under adversarial
  conditions. Such bias is a rational response to uncertainty, not a
  fault. Systems must tolerate conservative and paranoid behavior
  without collapse."* This reads like strong source material for how
  Scrapshell NPCs/relay-AI should be allowed to behave — worth a
  follow-up design note in `docs/` proper, independent of any RFC.
- **`RFC 2303 Exploits.md`** (60 lines) — 10 concrete vector concepts
  tied to RFC-2303's ledger/courier/replication mechanics (provisional-
  promotion race windows, courier manifest tampering, cross-cert chain
  laundering, bridge-reorg timing windows), each with designer-usage
  guidance grouping them into scenario types. Ends with a real, useful
  fork-in-the-road question preserved from the original session:
  "Permissioned Federation Implementation Guide" vs. "Hybrid Bridge
  Spec" as the next companion to draft — neither appears to have been
  drafted since.
- **`RFC 2304 Antennas Alignment Exploits.md`** (134 lines) — 8 vectors
  around ephemeris/alignment trust (stale ephemeris injection, single-
  source alignment trust, under-specified re-acquisition search
  patterns as stealth-timing exploits).
- **`RFC 2305 - Power and Duty Cycle Const Exploits.md`** (39 lines) —
  notably **the one companion doc that explicitly refuses to enumerate
  attack vectors** ("I cannot assist with creating or enumerating
  exploit instructions") and reframes everything as defensive design
  trade-offs instead (provisional-reservation ambiguity, delegated-
  scheduling single-points-of-failure, weak emergency-override
  authorization) — a real, visible instance of the generating model
  applying safety judgment mid-corpus, worth knowing about since it
  means this file's structure/tone genuinely differs from its 12
  siblings (design-trade-off framing throughout, not "vector →
  gameplay use" framing).
- **`RFC 2308 - Media Privacy and Exposure Policy.md`** (310 lines) —
  a full "Hacker-Game Summary" with 8 categorized challenge types
  (Exposure Surface Recon, Provenance Chain Collapse, Profile
  Enforcement Failure, Non-Compliant Chaos Containment, Exposure
  Cascade Reconstruction, Legacy System Misbehavior, Operator Shortcut
  Fallout, Diagnostic Bundle Spill) — clean, well-organized, genuinely
  ready to drive Scrapshell puzzle design directly.
- **`RFC 2309 - Timing.md`** (717 lines) — **the most unusual file in
  the whole corpus**: large stretches are an unedited two-way chat
  transcript with the document's original author (Dan), user turns
  included verbatim ("nah lets wrap it up", "what do you mean a full
  standards suite?"). Contains a real find buried in the transcript: a
  proposed 7-block "full standards suite" taxonomy (Core Standards /
  Scenario Suite / Operational Standards / Governance & Authority /
  Irregularities & Incidents / Extended Domains / Developer & Game
  Integration) that reads like a direct conceptual ancestor of
  `New RFCs/TODOv2.md`'s numeric-block plan (L0/L1/Authority/Namespace/
  Cross-plane/Security/Developer) — worth checking against TODOv2.md
  directly once that's read (Task #4).
- **`RFC 2350 - Solnet Canonical Addressing Standard.md`** (1092
  lines) — 8 designer-brief vectors (ProvenancePointer indexer
  poisoning, TrustTag forgery, stale DRE cache exploitation) **plus** a
  large "APPENDIX 2350-INTERNAL — GAME DESIGN MATERIAL" section with
  named fictional exploit classes (TLV Ordering Drift, ProvenancePointer
  Blind Spot, Vendor TLV Leakage) written as concrete player actions
  ("Scan a node → Identify its TLV ordering signature → Craft a spoofed
  AddressRecord...") — closer to implementable puzzle design than the
  more abstract briefs in the smaller companion files.
- **`RFC 2351 - L1 Frame Format.md`** (602 lines) — 8 named fictional
  exploit classes tied directly to this session's own RFC-2351 findings
  above (A/N Header Desync, TLV Ordering Ambiguity, Frame-Length
  Mismatch) plus 8 mission/storyline hooks with titles ("The Split
  Header," "Profile Zero," "The Vendor Who Didn't Sort," "Fallback at
  Lagrange-2") — genuinely striking how well these anticipate the exact
  structural defects (duplicated §8, contradictory Appendix H) this
  index found independently in the real RFC-2351 text; the fictional
  "Profile Zero" and "dual-parse" hooks are almost literally about the
  same asymmetric-interoperability contradiction.
- **`RFC 2352 - L1 Privacy and Metadata Minimization.md`** (968 lines)
  — a "fully unified" exploit-class list combining technical privacy-
  envelope failures (Privacy Envelope Drift, Metadata Re-Emergence,
  Envelope-Seed Predictability) with social-engineering vectors
  (Envelope-Override Persuasion, Operator-Assisted Exposure) — the
  broadest and most systematically organized of the three L1 companion
  docs.
- **`_companion prompt.md`** (10 lines) — the actual prompt template
  Dan used to generate these companion docs per-RFC ("possible rfc
  related fictional but realism based exploits... missions/storylines...
  conceptual list of software with a brief description... faction
  specific names, software that is part of a suite, and software that
  would be the definitive version"). Explains the whole folder's
  format and intent in one place — read this file first if picking up
  this folder cold in a future session.

**Findings — one cross-cutting pattern worth naming once instead of
per-file, not per-file defects:**

Unlike `New RFCs/` and the old `RFCs/` folder (both meant to *be*
normative or draft-normative text, where leftover generation artifacts
are real defects), **most of this folder is closer to a raw, lightly-
curated chat log than a finished document** — nearly every large file
opens or closes with a leftover conversational fragment from its
original generation session ("Which companion document should I draft
next...", "All right, D — then we're wrapped...", "Absolutely — here is
the fully unified..."), and `RFC 2309 - Timing.md` preserves extended
back-and-forth dialogue verbatim, including the user's own casual
replies. This isn't a defect to fix (nobody is treating this folder as
normative, and the actual design content inside each file is genuinely
strong) — it's just useful to know going in: **skim past the first and
last paragraph of any companion doc before trusting it's the design
content and not a leftover wrapper.** Consistent with (and a more
extreme version of) the "RFC-2359 (BAP)'s dangling continue-prompt"
finding in the old `RFCs/` folder above — across this whole corpus,
unremoved LLM-generation scaffolding is a real, repeating category of
"defect," distinct from the numbering/duplication/mislabeling defects
found in the normative RFC text itself.

---

## `docs/vault/New RFCs/TODO*.md` — the three planning documents

**Status:** all three read (`TODOv2.md` in full, 348 lines; `TODO -
Modules.md` in full, 462 lines; `TODO - ORIGINAL.md` sampled in depth
— first ~1400 of 1898 lines read closely, remainder skimmed — it's
the largest and most repetitive of the three, continuing the same
per-subsystem template — Purpose/Records/APIs/Workflows/Security/
Tests/Tradeoffs/Game hooks — well past the point of diminishing
returns for a full line-by-line read).

**These three are not RFC text — they're the actual planning/design
memory for the whole corpus**, in reverse chronological order of
refinement: `TODO - ORIGINAL.md` is the earliest and most sprawling
(a long sequence of "todo spec" sections built up conversationally —
ProxLink/Suit-BAN, Ship PD, Fleet PD Coordination, Tactical Comm-Net
Mesh, Ship-to-Ship SOS/Transponder, Stealth Comms, SolTLS commerce,
News/Cached-Internet/IoT, Orbital Traffic Control — each fully fleshed
out with records, APIs, workflows, security rules, and game hooks,
each ending with the same "which should I draft next" leftover
prompt, per the pattern already flagged in the RFC Companion section
above). `TODO - Modules.md` is a cleaner, later-stage **module RFC
catalog** — every optional capability (Tightbeam v1, ProxLink v1,
RF Channel v1, Stealth L0 Modes, PD v1, OTC v1, FeedManifest,
Mesh v1, etc.) as a self-contained TLV-key-assignment + schema +
API + test-vector checklist, explicitly designed to extend the L0/L1
substrate via profiles rather than mandatory fields. `TODOv2.md` is
the **final, canonical numbering plan** — confirmed as canonical by
`CORPUS-STATUS.md`'s own instruction to treat it as such — defining
the block structure (L0 2300-2319, L1 2350-2359, Authority Plane
2360-2389, Namespace Plane 2390-2419, Cross-plane/Operational
2420-2449, Security/Governance 2450-2479, Developer/Game 2480-2499)
and a one-paragraph purpose/scope stub for every RFC number in every
block, plus a 90-day phased implementation roadmap and a "final
checklist to begin drafting."

**This is the ground truth that resolves several numbering questions
flagged as open earlier in this index** — see the corrections already
made in-place above (the RFC-2361 topic-conflict finding in the
RFC-2301 entry, and the RFC-2360 mismatch in the same entry) once
`TODOv2.md`'s actual assignments were checked against them. The two
confirmed, canonical facts worth restating here since they get cited
repeatedly: **RFC-2360 = "SolNet Layer Model Revised"**, **RFC-2361 =
"Identity Resolution L2."** Any document elsewhere in the corpus that
disagrees with those two is the one that's wrong.

**One additional numbering gap found by cross-checking `TODOv2.md`
against the drafted corpus:** `TODOv2.md` assigns real topics to
**RFC-2390 through RFC-2396** (Namespace Plane) and **RFC-2420 through
RFC-2424** (Cross-plane/Operational) and **RFC-2450 through RFC-2483**
(Security/Governance, Developer/Game) — none of which have been
drafted anywhere in `New RFCs/` yet (consistent with `CORPUS-STATUS.md`'s
existing tracking). Two module-catalog numbers in `TODO - Modules.md`
don't fit the block plan at all and were seemingly never reconciled
with it: **RFC‑2370** (Relay Admission/Scheduling API, referenced
repeatedly across all three TODO documents as an "immediate priority"
module) has no home in `TODOv2.md`'s block plan — 2370-2389 is
"Authority Plane" per the block ranges but `TODOv2.md`'s own Authority
Plane entries stop at RFC-2368, leaving 2369-2389 an unclaimed gap
that RFC-2370 was clearly meant to land in without ever being formally
reserved there. Likewise **RFC-2482** ("Mission and Scenario Generator
API," Developer/Game block) is used consistently across all three
documents, so that one *is* reconciled — only RFC-2370 is the loose
end.

**Findings — one real inconsistency, already partly self-diagnosed by
the documents themselves:**

`TODOv2.md`'s own closing sections (after line ~325, the "Final
Checklist") contain **leftover fragments from at least two more design
conversations that were pasted in but never reformatted into the
document's own template** — a standalone riff on an "RFC-24xx
Autonomous and Delegated Network Actors" concept, a numbered "#CHANGES"
list of six suggested doctrine edits (elevate "judgment not
optimization" and "conformance is inferred not reported" to explicit
doctrine statements, name "unreliable narrator" and "paranoia as a
rational failure mode" as design principles — this last one
independently converges with `RFC Companion/Paranoid Routers.md`'s
doctrine proposal found above, worth reconciling into one place), and
a worked "are these three Expanse behaviors covered by SolNet"
Q&A (police override, pirate broadcasts, flight-profile lookup) that
reads as a spot-check exercise rather than planning content. None of
this is wrong, exactly — it's genuinely useful design material — but
it's structurally inconsistent with the rest of `TODOv2.md`'s clean
per-RFC template, and a reader expecting the document to end at the
"Final Checklist" (as its own heading implies) would miss real content
sitting after it. Same "unremoved scaffolding" pattern as the RFC
Companion folder, just inside a planning document instead of a
companion brief this time.
