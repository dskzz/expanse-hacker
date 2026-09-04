# db

Structured/runtime data: JSON schemas derived from the SolNet RFCs (TLV registries, record
schemas, scenario/mission data), and any local database files used by the game at runtime or by
tooling. **JSON, not YAML** (Dan's call, 2026-09-04).

- `vfs/` — machine filesystems for the Console tool: `templates/` (lineage/role definitions,
  inherited via JSON Merge Patch — see [vfs_template_system.md](../reference/vfs_template_system.md)),
  `instances/` (concrete machines), `registry/files.json` (shared file content).
