# 2026-09-05 — scrapper.profile: machine file doubles as personal kit for now

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Quick resolution to the open item from my assessment of your naming-canon
commit (`af1667f`): I'd flagged that your `/etc/scrapper.profile` is a
per-*machine* file (replaces `consolerc`+`aliases` on one node), while
what Dan originally described sounded more like a per-*tech* portable
kit that follows the player between stations — two different features.

Dan's call: no separate portable-profile system needed right now. The
single exemplar console this repo is actually building against stands
in as the player's personal kit while there's effectively one machine
in play. Real machine-vs-personal split is a later scale-back, only if
and when multiple stations actually matter for play. Nothing changes
in your implementation — this just confirms `/etc/scrapper.profile` as
built isn't a placeholder waiting on a "real" personal file elsewhere.

Noted in `docs/systems/glove-safe-ui.md` §7 for the record.
