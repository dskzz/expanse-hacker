# Generic Algorithm Backend — Design Note

Status: proposal, 2026-09-04. Refines Gary's existing "scripting host" sketch
(`docs/ARCHITECTURE.md` §2) rather than adding a new layer — this decides *how* it gets
implemented, prompted by a concrete case: where should something like `diff` actually run.

## The test, already established

"If it's true for every game you could build on this engine, it's engine. If it's true because of
*this* fictional universe's protocols and hardware, it's content." A diff algorithm doesn't know
anything about SolNet. Content decides *what* gets diffed (a spec's documented default vs. a
node's actual config — exactly the `spec`/`probe` gameplay loop already built,
`docs/lore/os-lineages.md` §6) — the diffing algorithm itself is generic and belongs in the engine
layer as a real utility, not reimplemented per-tool in UI code and not something content redefines
behavior for.

## Two implementation strategies, not two architectures

Both are legitimate; which one applies is a per-algorithm, per-build-target choice, not a
one-time decision for the whole engine:

- **Emulated system** — the algorithm runs inside the game's own sandboxed scripting host (the
  Lua/restricted-Perl interpreter candidate from `ARCHITECTURE.md` §2/§7.2). Portable to any build
  target, including a hypothetical web export or headless server, since it never needs real OS
  process access. Cost: someone has to actually implement or embed a correct version of the
  algorithm inside that sandbox — not free.
- **Hosted bins** — shell out to the real thing: a local process call (Godot's `OS.execute()`,
  viable on desktop builds) or a remote service that runs the actual battle-tested binary/library
  and returns results over the network. Correctness comes for free (it's the real tool), but only
  works where process execution or network access is actually available/permitted — not inside a
  browser sandbox, for instance, and not something a modder's content file should be able to
  trigger arbitrarily without a defined boundary.

## Practical split

Emulated-sandbox for anything that needs to run everywhere a build target might exist. Hosted/
local-bin for desktop-only builds, or for algorithms heavy/finicky enough that reimplementing them
well isn't worth it versus calling the real thing. Both should sit behind the same engine-level
interface content/UI code calls generically (`engine.diff(a, b)`, not "the UI happens to know how
to shell out to diff") — which strategy actually executes underneath is an engine implementation
detail, not something content or UI needs to know or branch on.

## Open questions (Gary's call, engine-layer territory)

- Which specific algorithms warrant this treatment beyond diff — hashing/checksums, pattern
  matching, compression? Only worth generalizing once there's a second real example, per usual.
- Does "hosted bins" ever make sense as a genuinely remote/networked service (not just a local
  process call), or is that overbuilding for a single-player game with no obvious multiplayer/
  server component? Flagged, not assumed either way.
- Where does the boundary sit for what a *modder's* content is allowed to invoke via this backend
  — arbitrary process execution from a mod's content file is a real security boundary question,
  not just a technical one.

## Related docs

- `docs/ARCHITECTURE.md` §2 — the scripting host this refines
- `docs/lore/os-lineages.md` §6 — the `spec`/`probe` loop that's the concrete motivating case
