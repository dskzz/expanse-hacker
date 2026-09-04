# db

Structured/runtime data: JSON or YAML schemas derived from the SolNet RFCs
(TLV registries, record schemas, scenario/mission data), and any local database
files used by the game at runtime or by tooling.

See [`CORPUS-STATUS.md`](CORPUS-STATUS.md) for which RFCs are converted,
which are drafted-but-not-converted, and which are only planned —
including an important note on `New RFCs/` vs. `RFCs/` in the vault not
being two eras of the same numbering.

- `vocabulary.yaml` — shared terms/constants (UUID-S7, planes, layers,
  canonical record types) other content files reference by name.
- `protocols/` — `protocol.yaml`-shape content (stateful, per
  `ARCHITECTURE.md` §3).
- `hardware/` — `hardware.yaml`-shape content (device/component types).
- `trust/` — `kind: trust-model` content: how a network configures the
  engine's generic trust primitive (`ARCHITECTURE.md` §2). Not every RFC
  is a stateful protocol; RFC-2301 (crypto/key hierarchy) is this shape
  instead of `protocols/`.
