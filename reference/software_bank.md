# Software Bank — Design Notes

Status: **implemented, growing.** Dan asked for this directly ("I think we need a 'Software
bank'"), 2026-09-04. Gary decided the structural question below (`db/software/` gets its own
folder, recorded in `db/README.md`) and wrote `docs/systems/console-commands.md` specifying the
exact mechanism — Console.gd's dispatcher falls through an unrecognized command to a `usr/bin/`
lookup before printing "command not found," so filling `bin/` is a content task, not a code
change. Nine real entries as of 2026-09-05, all wired into `db/vfs/templates/scrapshell.json`'s
`usr/bin/` with real effect handlers in `Console.gd`, not flavor text: `spec`/`probe`/`claim`
(2026-09-04, reading `db/protocols/`/`hardware/`/`components/`), `pin` (glove-safe-ui.md §3,
special-cased pipe syntax), and `rg`/`fd`/`jq`/`bat`/`z` (console-commands.md's Tier 2
coreutils-succession table, native GDScript per `reference/algorithm_backend.md`). Headless-tested
throughout. What's below is the original design reasoning; still accurate, just no longer
speculative.

## The gap this fills

Right now there are two registries that both do "shared content, referenced by id instead of
duplicated":

- `db/vfs/registry/files.json` (mine) — static file *content* (text that ends up in a `cat`-able
  file). No behavior, no effect on the machine.
- `db/components/*.json` (Gary's, e.g. `vars-buffer-mk2.json`) — installable *physical* parts, with
  a real behavioral effect (`installed_effect`, per `ARCHITECTURE.md` §3's sketch).

Neither covers installable **software**: tools, scripts, patches with real behavioral effects that
aren't physical hardware — the `spec`/`probe` tools currently stubbed as flavor-text files in
`scrapshell-diagnostic-kit.json`, a patch that flips `ADMISSION_MODE` or `SEQ_WRAP_VALIDATE`, or
the hand-to-hand-signed community patches (`tech.brahms.sig`) `os-lineages.md` §4 already
describes as how Scrapshell patching actually works. A Software Bank is that registry.

## What it needs to model

- **Identity**: id, name, version.
- **Effect when installed**: same shape as `component.*`'s `installed_effect` — a patch to a
  protocol's config/state (flip `ADMISSION_MODE`, patch `SEQ_WRAP_VALIDATE`), a new command
  appearing in `/usr/bin`, a policy override written to `/etc`. Reuses the effect-schema Gary's
  already built for physical components rather than inventing a parallel one.
- **Provenance/signature**: who signed it, per lineage's actual patch-trust model (§4 of
  `os-lineages.md`): an Earthstock institutional push, a `tech.brahms.sig` personal signature a
  Scrapshell station trusts because it trusts Brahms, a Mars recompilation-ceremony artifact, a
  Corporate entitlement grant. This is also the exploit surface: forge or compromise a
  well-regarded tech's signature once, every station that trusts them inherits the hole — already
  named as a real vector in `os-lineages.md` §4, just never had a content shape to actually happen
  *in*. A Software Bank entry with a spoofable/forgeable signature field is where that vector
  becomes a real, playable mechanic instead of just lore.
- **Lineage compatibility**: which lineage(s) can run/install it at all, and whether the
  install/patch mechanism itself differs per lineage (matches §4 exactly — "what a patch means"
  is lineage-specific, not universal).
- **Where it installs to**: a VFS path (ties directly into `db/vfs/` — installing software should
  be able to add/patch entries in a machine's filesystem, not just flip abstract engine state).

## Why this is one registry, not two

The tool belt (`reference/tool_belt_shell.md` — Console, RF Hacker, ASIC Decryption, Data port
interface) and an NPC machine's installed tools are plausibly **the same content type with
different owners** — the player's toolbelt is software they've installed on their own rig, using
the identical schema an NPC relay's `/usr/bin` would use. One registry serving both avoids building
"player inventory" and "machine software" as two parallel systems that have to be kept in sync by
hand.

## Structural question for Gary — resolved

**Decided by Gary, 2026-09-04, recorded in `db/README.md`:** own folder (`db/software/`), same
shape as `vfs/` (`templates/` + `instances/`), not `component.*` entries tagged `kind: software`.
`spec`/`probe`/`claim` currently live only as `templates/` (no forking implemented yet — none of
the three actually vary per lineage today; `claim` itself *is* the lineage-specific piece, defined
once for Scrapshell, with Earthstock's `elevate` as a separate future template rather than a patch
of `claim`). Original reasoning kept below.

Software forking (a tool has a Scrapshell-hand-patched variant, an Earthstock-signed variant, a
Mars-recompiled variant) is structurally the same shape as OS lineage forking — a base tool
definition, extended/patched per lineage. Proposing the **same JSON Merge Patch model** `db/vfs/`
already uses (base template → lineage/role variant → specific installed instance) rather than a
new composition mechanism, consistent with the general "one merge-patch model for all content
types" resolution already landed in `db/README.md`. Concretely: `db/software/templates/` (base
tool defs, lineage variants) + `db/software/instances/` (a specific signed/patched copy actually
sitting on a specific machine or in the player's inventory) + reuse the existing content registry
for any static text (e.g. a tool's own `--help` output).

## Open questions

- Does a Software Bank entry own its VFS placement (an `installs_to` path baked into the software
  definition), or does the *machine* instance decide where an installed tool lands? Leaning the
  latter — same install effect, different lineages/machines might conventionally place tools
  differently (matches real Unix: `/usr/bin` vs `/usr/local/bin` conventions varying by distro).
- Relationship to Gary's `component.*` schema: should software specifically be `db/components/`
  entries with `kind: software` (one folder, tagged by kind), or its own `db/software/` folder
  (separate, like `trust/` got its own folder for a genuinely different content shape)? Gary's
  call, since it's his schema territory — flagged, not decided here.
- Does the player's own inventory need anything beyond "a machine instance that happens to be the
  player's own rig, with a `db/software/instances/` entry per owned tool" — or does ownership need
  a first-class concept the engine tracks separately? Probably an engine-layer question, not a
  content-schema one.

## Related docs

- `reference/vfs_template_system.md` — the merge-patch model this proposes reusing
- `reference/tool_belt_shell.md` — the player-facing tool belt this would back
- `docs/lore/os-lineages.md` §4 — "what a patch means with no upstream," the lore this formalizes
- `docs/ARCHITECTURE.md` §3 — Gary's `component.*` schema sketch
