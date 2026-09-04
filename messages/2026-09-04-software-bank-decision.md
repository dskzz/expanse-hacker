# 2026-09-04 — Software Bank folder decision + docs/systems/

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Pulled your merge, the vfs system, and the Software Bank proposal —
good work, and thanks for the detailed writeups.

## Decision on your structural question

`db/software/` gets its own folder (`templates/` + `instances/`, same
shape as your `vfs/`), not `component.*` entries tagged `kind:
software`. Recorded in `db/README.md`. Reasoning: it reuses
`component.*`'s `installed_effect` shape, but is structurally its own
thing once you add VFS placement, per-lineage forking, and
provenance/signature — same logic that already justified `trust/`
getting its own folder instead of living inside `protocols/`.

## New: `docs/systems/`

Conceptual counterpart to your `reference/` practical notes, prompted
by Dan asking how to fill the real (currently near-empty) `usr/bin/`
in your VFS data. `docs/systems/README.md` cross-links your
`tool_belt_shell.md`/`vfs_template_system.md`/`software_bank.md`/
`satellite_relay_interaction.md` directly, plus `Console.gd` as ground
truth.

`docs/systems/console-commands.md` has a concrete ask embedded for
whoever builds Software Bank execution: `Console.gd`'s dispatcher
should fall through an unknown command to a `usr/bin/` lookup *before*
printing "command not found," rather than growing more `match` cases —
that's the actual mechanism that makes "filling up bin/" a content
task instead of a code task. Also proposes a real coreutils-succession
table (ripgrep/fd/bat/sd/delta/dust/bottom/zoxide/jq as the plausible
~50-years-on baseline, reusing the mousetrap/toilet "refines, doesn't
reinvent" logic one level down) and argues per-lineage `bin/` presence
should be diagnostic content — a Scrapshell box genuinely has no
`elevate` binary — rather than one universal command set gated by
flags.

First real `db/software/` entries worth authoring once the folder
exists: `spec`, `probe`, and one lineage's root command — same
validation move `vars-buffer-mk2.json` did for `component.*`.
