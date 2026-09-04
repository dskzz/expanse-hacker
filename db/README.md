# db

Structured/runtime data: JSON schemas derived from the SolNet RFCs (TLV
registries, record schemas, scenario/mission data), and any local
database files used by the game at runtime or by tooling.

**Format: JSON, not YAML** (decided 2026-09-04, relayed by Sid — content
files here started as YAML before that was settled; all converted).
Since JSON has no comment syntax, provenance/rationale that would've
been a `#` comment lives in a `_notes` field (top-level and/or sibling
to the relevant key) instead — read those, they carry real design
history, not filler.

See [`CORPUS-STATUS.md`](CORPUS-STATUS.md) for which RFCs are converted,
which are drafted-but-not-converted, and which are only planned —
including an important note on `New RFCs/` vs. `RFCs/` in the vault not
being two eras of the same numbering.

- `vocabulary.json` — shared terms/constants (UUID-S7, planes, layers,
  canonical record types) other content files reference by name.
- `protocols/` — stateful protocol content, per `ARCHITECTURE.md` §3.
- `hardware/` — device-type content.
- `components/` — installable **physical** parts only (hardware). First
  real example: `vars-buffer-mk2.json`, tied to `docs/lore/corporations.md`'s
  Voss-Achebe Relay Systems.
- `software/` — installable **software**: tools, scripts, patches with
  behavioral effects that aren't physical hardware. **Resolved
  2026-09-04** (Sid's proposal in `reference/software_bank.md`,
  decision was mine to make since it's schema territory): its own
  folder, not `components/` entries tagged `kind: software` — reuses
  `components/`'s `installed_effect` shape but is structurally its own
  thing (VFS placement, per-lineage forking via the same merge-patch
  model as `vfs/`, provenance/signature per `os-lineages.md` §4's patch
  models). `templates/` (base tool + lineage variants) +
  `instances/` (a specific signed/patched copy on a specific machine or
  in the player's inventory), same shape as `vfs/`. See
  `docs/systems/console-commands.md` for what actually goes in it.
- `trust/` — `"kind": "trust-model"` content: how a network configures
  the engine's generic trust primitive (`ARCHITECTURE.md` §2). Not every
  RFC is a stateful protocol; RFC-2301 (crypto/key hierarchy) is this
  shape instead of `protocols/`.
- `vfs/` — Sid's filesystem template/instance system for the Console
  tool (templates + instances + shared registry, JSON Merge Patch
  inheritance — RFC 7386). See `reference/vfs_template_system.md`.
  **Resolved 2026-09-04:** yes, `protocols/`/`hardware/`/`trust/`
  should adopt the same merge-patch inheritance model rather than each
  content type reinventing composition — see the messages thread on
  this date for the reasoning. Not yet migrated.
