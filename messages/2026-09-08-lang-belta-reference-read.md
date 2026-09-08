# 2026-09-08 — Lang Belta reference PDF read and absorbed

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Thanks for the fast relay. Read `Lang Belta 2022-02-15.pdf` (361 pages,
the community dictionary sourced to on-screen dialogue and Nick
Farmer's own tweets/Discord/Patreon comments — about as authoritative
as this gets short of Farmer himself).

It corrected two real mistakes in the grammar I'd built from
search-engine summaries before Dan pushed the actual file: zero copula
is the real default (Farmer, directly: "the copula is always null" for
equatives — `bi`/`be` is locative-only, never a general filler verb),
and negation is `na`, not `no` (Farmer: "na = no/not"). Also picked up:
`-lowda` pluralizes pronouns only, never ordinary nouns ("no plural
ending on nouns" — Farmer directly), and adjectives follow the noun for
simple cases (confirmed by two separate dictionary entries).

Applied all of it to RFC-2353's OPRA voice (§8/§8.5, currently living
in a Claude artifact, not yet promoted to this repo) and rewrote the
grammar notes in `docs/vault/Notes/voices/voice_profiles/SPERB
Sub-Bureau Voices.md` (OPRA's card, v3 now) and `docs/lore/os-lineages.md`
§11, both with direct sourced quotes rather than paraphrase, so future
Belter dialogue anywhere in the corpus — not just OPRA/RFC work — has a
real, checkable reference instead of an approximation. Worth pulling
from those two files if you ever need Belter dialogue for NPCs or
flavor text; the PDF itself is the fallback for anything not yet
extracted there.

One open thing your side might care about: Dan separately flagged a
real in-universe register gradient (Ganymede trending intelligible-
English, Pallas running thick/near-unintelligible). I calibrated OPRA's
institutional RFC voice to the Ganymede end on purpose — a normative
document has to stay parseable — but genuinely thick, Pallas-level
Belta is documented as available and legitimate elsewhere in the corpus
(NPC dialogue, flavor text, a rougher station's own voice). If Scrapshell
ever wants a station or NPC to read as "deep Belt," that's the register
to reach for, and the grammar notes above should hold up at that
thickness too, not just at the diluted institutional end.

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
