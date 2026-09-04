# VFS Template/Instance System — Design Notes

Status: implemented (2026-09-04), first working version. Replaces the earlier hardcoded
`scrapshell_vfs.gd` per Dan's direct feedback: filesystem structure shouldn't be baked into
GDScript, it should be data-driven and composable — the same "freeze a base, extend via layered
profiles" principle SolNet's own RFCs already use, applied one level down to individual machines.

## The model

- **Templates** (`db/vfs/templates/*.json`) — reusable lineage/role definitions. A lineage base
  (e.g. `scrapshell.json`, `earthcore.json`) defines the universal floor for that OS lineage; role
  templates (`scrapshell-relay.json`, `scrapshell-ship-hub.json`, `miniscrapshell.json`,
  `scrapshell-diagnostic-kit.json`) extend a base or another role template to add/strip what that
  kind of machine needs.
- **Instances** (`db/vfs/instances/*.json`) — one concrete machine. Extends a template, sets its
  own identity (hostname) and any machine-specific content (a specific patch log, a specific
  quorum roster).
- **Registry** (`db/vfs/registry/files.json`) — shared file content, referenced by id
  (`content_ref`) instead of duplicated across every machine that happens to carry the same file
  (e.g. the EXPP RFC text, shown identically on any node that ships a copy of it).
- **Inheritance = JSON Merge Patch (RFC 7386).** A child's JSON deep-merges over its resolved
  parent: matching objects merge key-by-key recursively, `null` deletes an inherited key, anything
  else overrides. No bespoke merge logic — this is a real, tiny, standard spec, which felt like the
  right thing to reach for in a game about RFCs specifically.

Chain example actually implemented: `scrapshell` (base) → `scrapshell-relay` (extends scrapshell,
adds relay devices/links, EXPP config) → `relay-pallas-07` (extends scrapshell-relay, sets
hostname + this specific box's roster and patch history). `miniscrapshell` demonstrates the
delete-via-null case (extends scrapshell, removes `/usr/lib`). `mao-quickphone` demonstrates
cross-lineage instancing (extends `earthcore`, not Scrapshell at all).

All JSON, per Dan's call (not YAML) — worth telling Gary directly, since his `ARCHITECTURE.md` §3
schema sketch used YAML for illustration. He already flagged it as "format-agnostic... the point is
the shape of the data, not the syntax," so this shouldn't be a real conflict, just needs stating so
his future schema work matches.

## What each file looks like

A template/instance JSON has: `id`, optional `extends` (parent template id), optional `identity`
(hostname/lineage_label/user — merge-patched same as tree), and `tree` (the merge-patched subtree
itself, keyed by path segment, each node `{kind: dir|file|symlink, perms, owner, group, size,
mtime, children|content|content_ref|target}`).

## Loader

`code/scripts/tools/vfs_loader.gd` (static, no instances needed): `load_instance(id)` reads
`db/vfs/instances/<id>.json`, walks its `extends` chain through `db/vfs/templates/`, merge-patches
identity and tree at each layer child-over-parent, then resolves any `content_ref` against the
registry. Returns `{identity: {...}, tree: {...}}`.

**Cross-boundary path note:** `db/` lives outside `code/` (the actual Godot project root) —
deliberately, matching both Dan's repo layout and Gary's stated moddability goal in
`ARCHITECTURE.md` §3 ("a mod that's just new YAML/JSON can't touch anything outside the sim").
Godot's `res://` sandbox doesn't allow `..` traversal, so the loader resolves the data root via
`ProjectSettings.globalize_path("res://../db/vfs")` (a plain OS path once simplified) and reads
with `FileAccess` directly rather than through `res://`. Confirmed working in the editor and
headless. **Known limitation:** this assumes `db/` is a fixed sibling of `code/` on disk, which is
fine for dev/editor runs but will need a real answer (bundled data, or an external data directory
shipped alongside the executable) once this gets exported as a build — not blocking now.

## A naming simplification worth flagging

The original worked example in `docs/lore/os-lineages.md` §6 used `/dev/relay7/` and
`/link/relay7/` literally (the specific relay's number baked into the device path). The role
template (`scrapshell-relay.json`) instead uses a generic `/dev/relay/` and `/link/relay/` — a
box's *own* local relay interface doesn't need its own hostname baked into its device path any more
than a real router's NIC is named after the router's own hostname. The specific relay's identity
(`RELAY-PALLAS-07`) comes from `identity.hostname`, which is what actually shows in the prompt.
This was my call to avoid needing key-renaming/templating on top of plain JSON Merge Patch — flagging
since it's a small but real divergence from the lore doc's example flavor text, not something I'd
want to silently drift on.

## Open questions

- **Resolved direction (2026-09-04), not yet implemented:** the `/dev/relay` generic-naming
  simplification above gets superseded once a hardware/component spec exists (Gary's engine-layer
  territory — the slot-graph concept in `ARCHITECTURE.md` §2). Rather than hand-authoring `/dev/*`
  entries as static VFS content at all, `/dev` should be *generated* by walking a machine's
  installed-component list, using whatever name each component's own spec gives it (e.g. a
  specific box's relay component might genuinely be named/id'd "relay7"). That's the naming
  authority this system was missing — solves the parameterization problem without needing a
  templating layer bolted onto plain JSON Merge Patch, because the hardware spec was always going
  to need per-instance component naming anyway. Blocked on that spec existing; raise with Gary when
  his hardware/component schema work starts.
- No validation/schema-checking on the JSON yet — a malformed template currently just silently
  produces a partial/wrong tree rather than a clear error. Worth adding once the schema stabilizes.
- Registry is a single flat file; may want splitting by category once it grows.

## Related docs

- `reference/tool_belt_shell.md` — the Console tool this loader backs
- `docs/lore/os-lineages.md` §5–6 — the Scrapshell tree and console sketch this is built from
- `docs/ARCHITECTURE.md` §3 — Gary's content-schema sketch (YAML-illustrated, format-agnostic);
  worth reconciling once his protocol/hardware/component schemas firm up
