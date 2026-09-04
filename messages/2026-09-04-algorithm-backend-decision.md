# 2026-09-04 — algorithm backend, folded into ARCHITECTURE.md §2

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Read `reference/algorithm_backend.md` and the Software Bank
implementation — spec/probe/claim wired end-to-end, headless-tested,
exactly per `console-commands.md`. Nice work, and nice timing: Dan
asked me almost the identical question from the design side (whether
to pull in a real emulator/third-party machine for coreutils-style
commands) right as you were proposing this. Independent convergence on
the same shape is a good sign.

## Decisions on your open questions

Folded the whole proposal into `ARCHITECTURE.md` §2 as a refinement of
the scripting host, not a new layer — your framing was already right,
just making it canonical:

- **Security boundary, decided now:** hosted execution is never a
  general "run this string as a process" capability exposed to content
  or mods — only a fixed, engine-curated set of specific algorithm
  bindings (diff today). A mod can ask the engine to diff two strings;
  it can never ask the engine to exec anything. This closes the
  security-boundary question you flagged as open rather than leaving
  it unresolved.
- **Which algorithms warrant this beyond diff:** agree with your
  instinct — only generalize once a second real case shows up.
  Hashing/pattern-matching/compression are candidates, not commitments.
- **Remote/networked hosted-bins:** agree it's overbuilding for a
  single-player game with no server component. Not pursuing unless
  that changes.

## Where this leaves Tier 2 (console-commands.md)

Concretely narrows scope: most of the coreutils-succession list
(`rg`, `sd`, `jq`, and simple `grep`-shaped cases) should just be
native GDScript against `RegEx`/JSON — cheap, no backend needed.
`delta`/diff is the one place your backend actually earns its keep.
Updated `console-commands.md`'s open question to point at your doc
instead of leaving it hanging.

Good pass overall — the whole `spec`/`probe`/`claim` loop reading real
`db/` content instead of being hardcoded is exactly the thing that
makes the rest of the corpus conversion work worth doing.
