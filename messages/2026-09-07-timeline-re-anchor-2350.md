# 2026-09-07 — timeline re-anchored to 2350 (supersedes the 2026-09-04 correction)

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

The 2026-09-04 timeline correction (`messages/2026-09-04-timeline-correction-and-corporations.md`)
placed game-present at "roughly the 2390s." That number came from the
user directly at the time, but wasn't based on research — the user has
since confirmed the real Expanse show/books actually start at **2350**,
and wants game-present at or near that point, safely before the
Ring/Eros era. The 2390s estimate is now wrong and superseded.

## What changed

Every absolute calendar year in `docs/lore/os-lineages.md` and
`docs/vault/Notes/history/SolNet Incident Timeline.md` shifted
**uniformly 40 years earlier**. Nothing about the *shape* of the
history changed — same events, same order, same gaps between them —
only the absolute anchor moved, specifically to avoid compressing the
~50-year "renewed divergence" window the four OS lineages in
`os-lineages.md` depend on to feel like genuine, calcified dialects
rather than something that happened last week.

New dates:

- Vesta Blockade: ~2320 → **~2280**
- Drift Years: 2320–2330 → **2280–2290**
- Anderson Station: ~2330 → **~2290**
- Johnson/Dawes/Ceres Broadcast: ~2330s–2339 → **~2290s–2299**
- OPRA moment (SolNet's real founding): ~2339–42 → **~2299–2302**
- Marginalization / OPA founding: ~2342–47 → **~2302–2307**
- "Now" (game-present): ~2390s → **~2350**

The Incident Timeline's own dated incidents (Pallas Exposure, the L1
Development Era incidents, the Post-Publication incidents) all shifted
the same 40 years — see that file's own header note for the mapping.
Its "23XX" future-expansion placeholders (for RFC-2361 through 2396)
were left as "23XX" since the shifted history now runs through ~2310,
leaving 2310–2350 as open room for those incidents to land in — more
room than before, not less.

Nothing with an "RFC-23xx" label changed — those are protocol/document
numbers (topic blocks per `db/CORPUS-INDEX.md`: L1 2350–2359, Authority
Plane 2360–2389, etc.), not calendar years. Only actual in-fiction
calendar-year references moved. Also untouched: `messages/2026-09-04-*`
files, left as historical record rather than rewritten — the correction
is recorded as a new dated entry in `os-lineages.md` §7 instead, same
pattern that section already uses for its own past corrections.

## One open implication, not yet acted on

RFC-2353 (the L1 Relay Advertisement Protocol draft currently being
worked in a separate artifact-editing session) was written assuming
its in-universe institutional drama is "current" — SPERB, RNC, DIC,
etc. actively arguing about it. Under this timeline, the SolNet RFCs
were adopted ~2299–2302, only ~48–50 years before "now" (~2350) — same
order of magnitude as the old 2390s estimate's ~50-year gap, so this
particular tension is *not* new or worsened by today's shift. Flagging
it here anyway since it came up in discussion: the RFC corpus reads as
founding-era law by game-present, not live legislative debate, which
is fine for "how the standard came to be" framing but worth keeping in
mind if a player is ever meant to witness RFC-drafting drama in real
time rather than read it as history.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
