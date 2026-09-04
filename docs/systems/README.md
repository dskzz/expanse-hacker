# Systems — What These Machines Are

Status: new 2026-09-04. This directory is the conceptual/design-level
counterpart to Sid's practical/implementation-facing notes in
`reference/` — the split matches the rest of the repo (`docs/` is the
design session's territory, `reference/` is the narrative/
implementation session's) but this is the first place where the two
sides are directly about the *same system* from two angles, so the
cross-links below matter more than usual. Read both sides, not just
one.

## What's here (conceptual side, this directory)

- [`console-commands.md`](console-commands.md) — what actually lives
  in a machine's `bin/`: shell builtins vs. installable software,
  the coreutils-succession table (ripgrep over grep, etc.), and how
  command presence/absence is itself lineage-diagnostic content.

## The practical/visual counterpart (Sid's side, `reference/`)

These describe how the same machines actually render and run, and are
the ground truth for what's real vs. still just design notes:

- [`../../reference/tool_belt_shell.md`](../../reference/tool_belt_shell.md) —
  the Godot shell: floating windows, the tool belt, Console as the
  core/first-built tool.
- [`../../reference/vfs_template_system.md`](../../reference/vfs_template_system.md) —
  how a machine's filesystem is actually built: JSON templates +
  instances + a shared content registry, composed via JSON Merge Patch.
  `code/scripts/tools/vfs_loader.gd` is the real, working loader;
  `db/vfs/` is the real content. **`bin/` and `usr/bin/` already exist
  in that data as real (currently near-empty) directories** — this is
  the literal thing `console-commands.md` is about filling.
- [`../../reference/software_bank.md`](../../reference/software_bank.md) —
  the proposed registry for what actually goes in `usr/bin`: installable
  software with a behavioral effect, forked per lineage the same way
  `os-lineages.md` §4 already describes patches working. Structural
  question in that doc (own folder vs. tagged `component.*` entries)
  is resolved in `db/README.md` — own folder, `db/software/`.
- [`../../reference/satellite_relay_interaction.md`](../../reference/satellite_relay_interaction.md) —
  the object/hotspot interaction model a physical machine (a relay, a
  satellite) presents beyond its terminal.
- [`../../reference/ai_and_the_console.md`](../../reference/ai_and_the_console.md) —
  where AI sits relative to the console/system, tying to RFC-24xx's
  "must not redefine semantics" doctrine (`docs/lore/os-lineages.md`
  doesn't cover this; it's tracked in `reference/vault_annex.md`
  instead).

## Live implementation, for reference

`code/scripts/tools/Console.gd` is the actual current dispatcher —
read it before designing new commands, since it's ground truth for
what's a shell builtin today (`cd`, `pwd`, `ls`, `cat`, `whoami`,
`help`, `clear`) versus what still needs a Software Bank entry to
exist at all.
