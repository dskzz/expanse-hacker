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
- `components/` — installable physical/software parts (the same schema
  a stock part uses). First real example: `vars-buffer-mk2.json`, tied
  to `docs/lore/corporations.md`'s Voss-Achebe Relay Systems.
- `trust/` — `"kind": "trust-model"` content: how a network configures
  the engine's generic trust primitive (`ARCHITECTURE.md` §2). Not every
  RFC is a stateful protocol; RFC-2301 (crypto/key hierarchy) is this
  shape instead of `protocols/`.
- `vfs/` — Sid's filesystem template/instance system for the Console
  tool (templates + instances + shared registry, JSON Merge Patch
  inheritance — RFC 7386). See `reference/vfs_template_system.md`.
  Whether `protocols/`/`hardware/`/`trust/` should adopt the same
  merge-patch inheritance model is open — not yet reconciled.
