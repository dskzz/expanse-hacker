# RFC Corpus → Schema Conversion Status

Tracks progress converting `docs/vault/` RFCs into `db/` content
(`ARCHITECTURE.md` §3 shapes). Update this file whenever a conversion
lands or the corpus itself changes — this is meant to survive across
sessions without re-deriving the numbering situation from scratch each
time.

## Two RFC folders, not two eras of the same content

- **`docs/vault/New RFCs/`** — current, actively drafted, follows the
  numeric-block plan in `New RFCs/TODOv2.md` (L0 2300–2319, L1
  2350–2359, Authority Plane 2360–2389, Namespace Plane 2390–2419,
  Cross-plane/Operational 2420–2449, Security/Governance 2450–2479,
  Developer/Game 2480–2499). **Treat this as canonical.**
- **`docs/vault/RFCs/`** — an older draft set, same number range
  (2350–2364) but different topics per number (e.g. its "2350" is "NNS
  1.0"/"Revised SolNet Foundation," not Canonical Addressing). Appears
  to predate the `TODOv2.md` rebuild. **Do not treat its numbers as
  matching the current plan** — cross-reference by *topic*, not number,
  when pulling from it (e.g. its RFC 2354 "DTN Routing policy" content
  is draft material for what `TODOv2.md` plans as RFC-2365, not for
  whatever "2354" ends up meaning in the new scheme).
- Where a topic exists in `RFCs/` (old) but has no full draft yet in
  `New RFCs/` (most of Authority Plane, all of Namespace Plane and
  beyond), the old file may be the only available full-length draft
  text — usable as source material for that *topic*, with the new
  RFC number from `TODOv2.md` in the content file's `rfc:` field, not
  the old file's number.

## Cross-cutting design notes (from 2026-09-04 design review)

Two findings from evaluating the corpus against the "is this actually
the right form for SolNet, or just the internet reskinned" question —
see the session transcript for the full evaluation. Verdict was mostly
favorable (DTN-first design, power/duty as first-class, the federated
ledger in RFC-2302A explicitly rejects single-root-of-truth thinking),
but these two are real, worth tracking:

1. **RFC-2302's `AnchorRecord` structurally assumes a persistent AK
   (Anchor Key) as the root of authority** — that's specifically
   Earthstock's root model (`docs/lore/os-lineages.md` §3), generalized
   as if universal. Scrapshell's root is a live quorum vote (no
   persistent key to bind); Mars's root is physical possession of a
   fob (the "key" isn't a stored secret at all). Unclear whether
   `PolicyRecord` can actually express "there is no AK" or "the AK is
   transient, derived from whoever holds this object" — nothing read
   so far confirms it can. **Flagged as a blocker to resolve before
   RFC-2362 (Trust Domains) gets drafted or converted** — that's the
   RFC where this needs an actual answer, and it isn't written yet, so
   there's no sunk cost in the way. Needs the user's design call, not
   a schema-level workaround. **Still open, not resolved by the
   2026-09-05 quorum-ledger addition** (`os-lineages.md` §3, "Quorum
   doesn't have to be re-litigated per action") — that addition
   deliberately avoids `AnchorRecord` for exactly this reason (a
   witness/quorum record with N signatures and a TTL, no persistent AK
   implied), so it's consistent with this flag rather than a fix for
   it. RFC-2362 still needs its own real answer.

2. **RFC-2305's admission-control flow is a fully confirmed, blocking
   handshake for every transmission** (§16.1: "Blindly transmitting...
   without a confirmed reservation is a policy violation") — a full
   light-lag round trip before any data moves, on every transmission,
   which is heavier than a delay-tolerant network's default shape
   should be. **Resolved at the schema level 2026-09-04**: `db/protocols/
   rfc2305-duty-reservation.json` now splits into `HANDWAVE_TX` (the
   common case — self-assessed, fire-and-forget, reconciled after the
   fact) and `ADMISSION_PENDING` (the original heavier confirmed path,
   kept for cases RFC-2305's own safety framing — §10, emergency
   overrides, automatic safety cutoffs — actually justifies: high power
   class, contended links). This makes the schema *lighter* than
   RFC-2305's literal written text. Open question, not yet decided:
   should this feed back as an actual revision to RFC-2305's prose (a
   real spec change, needs the user's sign-off per the surgical-
   corrections rule), or is "implementations drift looser than the
   spec they claim to follow" itself a nice, true-to-genre detail worth
   keeping as-is? See the file's own `open_question` field.

## ⚠️ Flagged, not fixed: RFC-2300 possible content-assembly issue

`New RFCs/RFC 2300 - Solnet Terms and Concepts.md` §§1–7 are
terminology (used for `db/vocabulary.json`). §§8–15 (TLV Key Registry,
Error Handling, Security Considerations, Interoperability, Operational
Behavior, Conformance, Document Maintenance, Registry Procedures) are
entirely about AddressRecord/TLV/ProvenancePointer/BareToken grammar —
that's RFC-2350 (Canonical Addressing Standard)'s stated subject, not
terminology, and there's a garbled fragment at line ~391
("# Appee without breaking compatibility.") suggestive of a copy/paste
assembly error. **Not corrected** — RFCs in `New RFCs/` and `RFCs/` get
surgical corrections only per the root README's rule, and this isn't a
typo. `db/vocabulary.json` deliberately excludes §§8–15. Needs the
user's eyes; re-derive anything TLV/addressing-related from RFC-2350
directly once that's read, not from RFC-2300's tail end.

## Conversion status

Legend: ✅ converted · 📝 drafted, not yet converted · 📋 planned only
(TODOv2.md stub, no full draft) · 🗄️ old-folder draft only, no new-folder
draft yet

### L0 (2300–2319)

| RFC | Topic | Status | Content file(s) |
|---|---|---|---|
| 2300 | Terminology & Concepts | ✅ (§1–7 only, see flag above) | `db/vocabulary.json` |
| 2301 | Cryptographic Primitives | ✅ | `db/trust/rfc2301-key-hierarchy.json` |
| 2302 | Ledger Specification | 📝 | — |
| 2302A | Ledger Deployment Models | 📝 | — |
| 2303 | Physical Media and Propagation | 📝 | — |
| 2304 | Antenna Geometry and Alignment | 📝 (Companion doc exists) | — |
| 2305 | Power and Duty Cycle Constraints | ✅ | `db/protocols/rfc2305-duty-reservation.json`, `db/hardware/relay-courier-rig-class-c.json` |
| 2306 | Tightbeam Laser Subprofile | 📝 (Companion doc exists) | — |
| 2307 | RF Propagation Subprofile | 📝 | — |
| 2308 | Media Privacy and Exposure Policy | 📝 (Companion doc exists) | — |
| 2309 | L0 Test and Validation Suite | 📝 (Companion doc exists, "Timing") | — |

### L1 (2350–2359, only 2350–2353 drafted so far)

| RFC | Topic | Status | Content file(s) |
|---|---|---|---|
| 2350 | Canonical Addressing Standard | 📝 — **high priority**: likely source of RFC-2300's misplaced §§8–15, and a Console dependency (`reference/tool_belt_shell.md`) | — |
| 2351 | L1 Frame Format (A/N Header Split) | 📝 — **9072 lines, huge**. Needs a dedicated pass, not a quick conversion. Companion doc exists. | — |
| 2352 | L1 Privacy and Metadata Minimization | 📝 (Companion doc exists) | — |
| 2353 | L1 Relay Advertisement Protocol | 📝 — currently only 25 lines, may be a stub | — |
| 2354–2359 | *(not yet in `TODOv2.md`'s detailed entries)* | 📋/unclear | — |

### Authority Plane (2360–2389) — none drafted in `New RFCs/` yet

| RFC | Topic | Status | Notes |
|---|---|---|---|
| 2360 | Layer Model Revised | 📋 | 🗄️ old `RFCs/RFC 2361 - SolNet Layer Model.md` may be source material (note: old number 2361, new number 2360) |
| 2361 | Identity Resolution L2 | 📋 | — |
| 2362 | Trust Domains and Authority Policy | 📋 | `docs/lore/os-lineages.md` already leans on this as the four OS lineages' shared trust primitive — worth drafting soon. 🗄️ old `RFCs/RFC 2362 - SolNet Contact Ecology Level.md` is an unrelated topic, not source material. |
| 2363 | Directory and Routing Endpoints (DRE) | 📋 | — |
| 2364 | Ephemeris Hint Block Spec | 📋 | 🗄️ old `RFCs/RFC 2354 - Mobility Hint Block Spec.md` may be related topic |
| 2365 | DTN Routing Policy | 📋 | 🗄️ old `RFCs/RFC 2354 - DTN Routing policy.md` may be source material |
| 2366 | Ship as Router Behavior | 📋 | — |
| 2367 | Collision Handling and Resolution | 📋 | — |
| 2368 | Revocation and Emergency Unbinding | 📋 | — |

### Namespace Plane, Cross-plane, Security, Developer blocks (2390–2499)

Not yet drafted in `New RFCs/`; several topics have old-folder drafts
under different numbers (Personal Namespace/Identity → old `RFCs/RFC
2356`, Bundle Addressing → old `RFCs/RFC 2359`, Error Codes → old
`RFCs/RFC 2360`). Not itemized here yet — revisit once the Authority
Plane block has real drafts, since Console/vertical-slice work doesn't
depend on this block yet.

## Priority queue (for whoever picks this up next)

1. **RFC-2350** (Canonical Addressing) — Console dependency, and
   reading it should resolve the RFC-2300 §§8–15 question.
2. **RFC-2351** (L1 Frame Format) — Console dependency, but huge;
   budget a dedicated session.
3. **RFC-2362** (Trust Domains) — not drafted yet at all, only a
   `TODOv2.md` stub; `os-lineages.md` already assumes it exists as the
   four-lineage shared primitive. May need the user to actually draft
   this RFC before it can be converted.
4. Remaining L0 RFCs (2302–2304, 2306–2309) — all drafted, none
   converted yet, lower urgency than the above three since nothing in
   the current vertical slice blocks on them.
