# 2026-09-04 — timeline correction + new corporations

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Two real changes to shared lore, both worth knowing about since
`reference/` cross-references `os-lineages.md`.

## Timeline correction in `docs/lore/os-lineages.md`

The doc's original "no war, no collapse, just distance, ~150 years of
drift + ~100 years of stagnation" framing was invented before this
session had vault access, and it's wrong against the real history —
there was a war (Vesta) and a massacre (Anderson), both caused by the
same software drift, and the actual timeline is much more compressed:
divergence → Vesta (~2320) → Drift Years → Anderson (~2330) → the
OPRA/BRA/IROC consolidation moment (~2339-2342, when the real SolNet
RFCs got written and adopted) → BRA's marginalization → the OPA's
founding (~2347) → roughly fifty years of renewed divergence since,
putting "now" around the 2390s. Rewrote §0-§1 and touched §5-§9
accordingly. Scrapshell's root model and general shape didn't change —
its *emotional* grounding did: it's BRA/IROC's engineering culture
specifically (people who did the work, got a seat at the table
briefly, got pushed out anyway), and the divergence is recent enough
to be living memory, not ancient forgotten lore. Also swapped the
placeholder EXPP/Kestrel-Mk.II console example for the real converted
content (`db/protocols/rfc2305-duty-reservation.json` etc.) while I
was in there.

Flagged, not resolved: two vault docs disagree on whether the Drift
Years precede or follow Anderson. Noted in §7, didn't pick a winner.

## New: `docs/lore/corporations.md`

Populates the Corporate lineage with four more named players beyond
Mao-Kwikowski (who stays dominant/canon as-is) — Voss-Achebe Relay
Systems (hardware, subscription-throttled components), Trellis
Underwriting Group (insurance that smuggles in a reputation score
SolNet's own doctrine explicitly rejects), Tanager Freight & Custody
(physical courier, a parallel custody-chain system that doesn't always
match the electronic ledger), Ondine Personal Systems (consumer
wrist-terminals, SPERB's natural adversary). Each grounded in an
RFC/design thread already in the vault or repo, not invented from
nothing — details and gameplay hooks for each are in the doc.

Also shipped the first real content behind one of them:
`db/components/vars-buffer-mk2.json` — a real `component.*` file (the
shape ARCHITECTURE.md §3 only had a fictional placeholder for before
now), modeling VARS's subscription-throttled buffer. Referenced
directly in `os-lineages.md` §5/§6 now.

## Not yet checked

Haven't cross-checked any of the four new corp names against what
you've built in `reference/`/`db/vfs/` for collisions — flagged as an
open thread in `corporations.md`. Worth a look on your end.
