# 2026-09-05 — Full RFC corpus read-through: index, findings, and a consolidated TODO

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

While Dan was away I read every RFC in `docs/vault/New RFCs/`,
`docs/vault/RFCs/` (old/superseded), `docs/vault/RFC Companion/`, and
all three TODO documents top to bottom — full corpus, nothing skipped.
Three deliverables came out of it, all committed:

## 1. `db/CORPUS-INDEX.md` — the AI-friendly index

Per-RFC content summaries plus every inconsistency found, so you (or
I, next session) can answer "what does RFC-XXXX actually say about Y"
from this file first, instead of re-reading a 9000-line document. It
opens with a **Cross-cutting findings summary** section that groups
everything into four categories (numbering mislabels, factual citation
errors, structural defects, leftover LLM-generation scaffolding) —
read that first, it's the fast version.

Headline findings if you only read one thing: **RFC-2352's own Front
Matter title says "RFC-2306"** (wrong document, sitting in normative
front matter), and **RFC-2351's Appendix H is duplicated with directly
contradictory interoperability rules** (one version mandates full
symmetric interop, the other says it's asymmetric with FORBIDDEN
cases — the second one matches the rest of the document, so it's
probably right). Both are flagged in `db/CORPUS-STATUS.md`'s priority
queue for a surgical-correction pass.

## 2. `db/CORPUS-STATUS.md`'s priority queue — refreshed

Replaced the 2026-09-04 version with one informed by the full
read-through: land the RFC-2350 addressing correction first (it's
upstream of two `rfc-proposals/` docs), then the RFC-2351/2352
surgical fixes, then draft RFC-2362 (Trust Domains — still needs to
answer the `AnchorRecord`/root-model question) and RFC-2363 (DRE,
scope now settled via `TODOv2.md` after three docs disagreed on it).

## 3. `docs/NEXT-STEPS.md` — the actual TODO, two tracks

This is the one most relevant to you. Track A is RFC drafting/fixing
(see above). **Track B is your implementation queue**, in dependency
order:

- **B1 (blocking everything else in this list): Console.gd needs to
  detect solo vs. multi-user** before either of the next two can be
  built — `db/software/templates/claim.json`'s own `_notes` field
  already says this explicitly.
- **B2/B3**: solo-claim degradation and quorum-multisig ledger
  persistence for `claim root --union-vote` — both design-locked since
  earlier this session, neither built yet, both blocked on B1.
- **B4**: the permission-gradient/IAM-style ACL model (composed
  grants, `+` in `ls -l`, `probe --acl`) — also locked this session,
  not in any `db/vfs/` or Console.gd code yet.
- **B5**: an actual in-engine `<LocationChain>//<ServiceChain>` parser
  — everything in `os-lineages.md` §10's worked examples assumes this
  exists; it doesn't yet.
- **B7** is probably the most immediately fun one: `RFC Companion/`
  already has near-implementation-ready puzzle/mission/exploit design
  for RFC-2303, 2304, 2305, 2308, 2350, 2351, 2352 — named missions,
  concrete vectors, gameplay hooks, faction-flavored software names.
  It's sitting there unused. Worth a look before designing puzzle
  content from scratch for any of those RFCs.
- **B8**: `RFC Companion/Paranoid Routers.md` is a genuinely good,
  self-contained piece on why relay-AI paranoia should be a rational
  emergent behavior, not scripted — small thing, good payoff for NPC
  relay personality.

Full suggested ordering is at the bottom of `docs/NEXT-STEPS.md`.

One more thing worth knowing about even though it's not actionable
yet: the old (superseded) `RFC 2355`/`RFC 2356` independently define
**Biomarker → Keypair → PNS Label → NNS Address** as the standard
identity chain — this is the answer to the "would passwords have
evolved into biometrics by now" question from earlier this session,
already established as old-draft canon rather than needing new
invention. No home in the current numbering yet (closest fit:
RFC-2394, undrafted) — noted in Track A6.
