# Per-Machine "System Orchestration" File — Design Note

Status: proposal, 2026-09-04. Dan's idea, prompted by building the `/dev/` hardware-derivation
mechanism and noticing where the seams don't line up cleanly. Maps directly onto something Gary
already sketched, not a new concept.

## The gap this points at

`db/vfs/instances/relay-pallas-07.json` just grew a `hardware` block (`type_ref`,
`installed_components`) so `probe` and the new `/dev/` synthesis have real data to read. That
block isn't really *filesystem* data — it's *machine* data that the filesystem view happens to
need. Right now the VFS instance file is doing double duty: "what does this machine's Console see"
and "what hardware/protocols does this machine actually have" are the same file, which won't hold
up once there's a second consumer of "what hardware does this machine have" that isn't the
Console (an engine-side simulation step, a mission scenario, a different UI surface entirely).

## This is already Gary's `node.yaml`/`network.yaml`, not a new idea

`ARCHITECTURE.md` §5's repo-shape sketch already has this slot: *"`node.yaml` / `network.yaml` —
templates for populating a scenario: station/ship/relay instances, which hardware, which protocols
active, which trust roots, starting topology."* Never built yet, but the shape was already right.
What's changed is there's now a concrete, working example of the problem it needs to solve — the
`hardware` block that's currently bolted onto a VFS instance file because there was nowhere else
for it to live.

## Proposed direction (not decided — Gary's schema territory)

A single per-machine (or per-machine-type) file — `db/nodes/relay-pallas-07.json` or similar — as
the actual source of truth: identity, which OS lineage/template it runs, hardware type +
installed components, active protocols, trust domain membership, starting position/topology.
`db/vfs/instances/*.json` and any future `db/software/instances/*.json` become *derived from* or
*referenced by* the node file for their specific concern (filesystem view, installed software
list) rather than each independently owning a copy of machine-level facts like hardware state.
Concretely, the `hardware` block currently in `relay-pallas-07.json` (VFS instance) would move to
the node file; the VFS instance would reference it (`node_ref: "relay-pallas-07"`) instead of
carrying its own copy.

## Why this matters now rather than later

The `/dev/` synthesis mechanism just built (`ContentLoader.synthesize_dev_folder`, reading
`hardware_state` off the VFS instance) is exactly the kind of code that gets awkward to migrate
later if machine-level data stays scattered — better to name the seam now, while there's only one
example of it (`relay-pallas-07`), than after five machines have independently duplicated
`hardware` blocks in their VFS instance files.

## Open questions (Gary's call)

- One node file per machine instance, or per machine *type* with instance-level overrides — same
  templates/instances split every other content type in `db/` uses, or something flatter since a
  node is inherently a "this specific machine" concept rather than a reusable template?
- Does this fold into `ARCHITECTURE.md` §5's `network.json` (topology-level, many nodes) directly,
  or is there a `node.json` (one machine) that `network.json` then references many of?
- Migration path for `relay-pallas-07.json`'s existing `hardware` block once this exists — not
  urgent, the current setup works, just flagged as the first thing that'd move.

## Related docs

- `docs/ARCHITECTURE.md` §5 — the `node.yaml`/`network.yaml` slot this fills
- `reference/vfs_template_system.md` — the VFS instance system whose `hardware` block prompted this
- `reference/software_bank.md` — same "instance carries machine-level state" pattern, same
  question would apply once software instances get authored
