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
| 2300 | Terminology & Concepts | ✅ (§1–7 only, see flag above) | `db/vocabulary.json`. Two proposed extensions pending review, not yet applied: `rfc-proposals/rfc2300-dre-role-directory.md` (§5.3 DREs, role-based addressing) and `rfc-proposals/rfc2300-2302-reply-path-privacy.md` (§6.1 Session Keys, return-path privacy). |
| 2301 | Cryptographic Primitives | ✅ | `db/trust/rfc2301-key-hierarchy.json` |
| 2302 | Ledger Specification | 📝 | — . Already has a real mechanical use lined up despite not being converted yet — see `os-lineages.md` §3's quorum-multisig-ledger design and `rfc-proposals/rfc2300-2302-reply-path-privacy.md`'s §7 cross-reference. |
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
| 2350 | Canonical Addressing Standard | 📝 — **high priority**: likely source of RFC-2300's misplaced §§8–15, and a Console dependency (`reference/tool_belt_shell.md`). A proposed correction to its §4 grammar is pending review, not yet applied — see `rfc-proposals/rfc2350-addressing-grammar.md` (separator mismatch with RFC-2300's own examples, an `@`/ProvenancePointer collision with the older NNS-1.0 draft's PNI shorthand, a dropped chainless-PNI capability). | — |
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

**Updated 2026-09-05** after a full corpus read-through — see
`db/CORPUS-INDEX.md` (per-RFC content + inconsistencies) and
`docs/NEXT-STEPS.md` (the full consolidated TODO this produced) for
the detail behind this list. The RFC-2300 §§8-15 question below is
now resolved: it's RFC-2350's own content, misplaced by an assembly
error, not something reading RFC-2350 would explain away.

1. **RFC-2350 correction + review** (Canonical Addressing) — Console
   dependency. The three-issue `rfc-proposals/rfc2350-addressing-
   grammar.md` proposal is drafted and waiting on the user's sign-off;
   land that first, since everything downstream (DRE role-directory,
   reply-path privacy proposals) builds on it.
2. **RFC-2351 surgical fixes** (L1 Frame Format) — huge (9071 lines)
   but the two defects found are narrow and real: duplicated §8 TLV
   Key Registry, and a duplicated Appendix H with **directly
   contradictory** interoperability rules (one version mandates full
   symmetric interop, the other says it's asymmetric with FORBIDDEN
   cases). The second instance matches the rest of the document — fix
   is likely "delete the first Appendix H," not a full rewrite.
3. **RFC-2352 surgical fixes** (L1 Privacy & Metadata Minimization) —
   its own Front Matter title says "RFC-2306" instead of "RFC-2352"
   (the single most severe mislabeling found anywhere in the corpus,
   sitting in normative front matter); §39 duplicated with §40
   missing; Appendix J/K use leftover C./D. subsection prefixes.
4. **RFC-2362** (Trust Domains) — not drafted yet at all, only a
   `TODOv2.md` stub; `os-lineages.md` already assumes it exists as the
   four-lineage shared primitive, and it's the RFC that has to answer
   the still-open `AnchorRecord`/root-model question below. May need
   the user to actually draft this RFC before it can be converted.
5. **RFC-2363** (Directory & Routing Endpoints) — also undrafted, but
   now has a settled scope (confirmed via `TODOv2.md`: DRE, not
   Identity Resolution as RFC-2302/2303 assumed) and two `rfc-
   proposals/` documents already targeting it (role-directory
   addressing, reply-path privacy) — a natural next full draft once
   RFC-2362 exists to depend on.
6. **RFC-2360/2361 mislabel sweep** — low-risk, mechanical: six
   documents cite "RFC-2361" for Layer Model content; `TODOv2.md`
   confirms that's RFC-2360, and RFC-2361 is actually Identity
   Resolution. A pure find-and-verify pass, safe to batch with any of
   the above.
7. Remaining L0 RFCs (2302–2304, 2306–2309) — all drafted, none
   converted yet, lower urgency since nothing in the current vertical
   slice blocks on them. Note: `RFC Companion/` already has ready-made
   exploit/mission/puzzle content for 2303, 2304, 2305, and 2308 —
   converting these has a running head start.
