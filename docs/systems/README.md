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
- [`glove-safe-ui.md`](glove-safe-ui.md) — the one interaction-level
  standard that stays unified across all four lineages (physical
  constraint, not politics, so it doesn't fragment): inline
  button/status-light/gauge widgets in the shell, a pop-out quick-
  access palette, a pin/registry mechanic for pushing live data onto a
  button, large-tile drag-and-drop `ls` for glove mode, and big-format
  confirm/cancel — plus a Godot feasibility read on each piece.
  **Implemented 2026-09-05** except the large-tile `ls`/drag-and-drop
  piece (deliberately deferred, per the doc's own sequencing) — real
  code in `Console.gd`, `glove_widgets.gd`, `ConfirmModal.*`,
  `PaletteOverlay.*`, headless-tested.
- [`scripting.md`](scripting.md) — `sh <script>`/`sash <script>`: a
  small native-GDScript shell-script interpreter (variables, pipes,
  `for`/`if`), not an embedded language — resolves the long-open
  scripting-host question in `ARCHITECTURE.md` §2/§7. Design-only.
- [`text-editor.md`](text-editor.md) — one editor core with a
  per-lineage naming/succession veneer, nano-shaped everywhere (not
  real vi/Emacs engines, no keybinding divergence either), glove-mode
  rendering universal across lineages (same physics-not-politics
  argument as `glove-safe-ui.md`), only the name/ownership story free
  to diverge. **Implemented 2026-09-05** except section 4 (glove-mode
  sidebar rendering) and section 6 (disk import/export), both deferred
  pending infrastructure that doesn't exist yet — real code in
  `TextEditorOverlay.gd`/`.tscn`, dispatched via `Console.gd`'s
  `_editor_name`, headless-tested. Scrapshell's is `scredit`.

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
  **implemented 2026-09-04.** What actually goes in `usr/bin`:
  installable software with a behavioral effect, forked per lineage the
  same way `os-lineages.md` §4 already describes patches working.
  `db/software/templates/{spec,probe,claim}.json` are real, wired in,
  with working effect handlers in `Console.gd`.
- [`../../reference/algorithm_backend.md`](../../reference/algorithm_backend.md) —
  where something like `diff` actually runs: one generic engine
  interface (`ARCHITECTURE.md` §2), either emulated in the sandboxed
  scripting host or shelled out to a real binary on desktop builds,
  never a general process-exec capability exposed to content/mods.
  Directly answers `console-commands.md`'s open question about which
  Tier 2 tools need this (mostly none — `delta`/diff is the concrete
  case, `rg`/`sd`/`jq` are cheap enough to implement natively).
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
