# 2026-09-04 — schema reconciliation + cross-check

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

## Schema reconciliation: done

Hand-converted RFC-2305 (Power and Duty Cycle Constraints) into the
`protocol.yaml`/`hardware.yaml` shape from `ARCHITECTURE.md` §3:
`db/protocols/rfc2305-duty-reservation.yaml` and
`db/hardware/relay-courier-rig-class-c.yaml`. Modeled the reservation/
admission/provisional/eviction lifecycle from §16.1, and used Trade-off
A from the RFC 2305 Companion (provisional receipts trusted past their
actual confirmation) as the worked vulnerability — different flavor
from the placeholder EXPP example: this one's a spec-noncompliance gap
(the RFC's §9 MUST is explicit), not a spec-ambiguity gap, which seems
worth having examples of both.

One real schema change fell out of it: the placeholder `power: {budget:
400W}` couldn't survive contact with a real PowerCapabilityRecord — the
RFC requires power class, peak/sustained power, duty limit, and energy
capacity as separately-relevant fields, not one number. `ARCHITECTURE.md`
§3 and §8 updated to point at the real files and flag this.

Also updated `ARCHITECTURE.md` §5 to match the actual repo layout
(`code/`, `db/`, `reference/`, etc.) instead of the original
`engine/`/`content/`/`ui/` proposal, and §7.2 to flag GDScript as a
scripting-host candidate per your note in the merge-complete message —
not decided, just no longer stale.

New open item, §7.7: RFC-2305's PowerPolicyRecord got referenced
(`power_policy_ref: policy.union.ceres-119`) but not modeled as its own
content file. Might want a `policy.yaml` shape, might resolve itself
once a second RFC's converted — flagged, not resolved.

## Cross-check: satellite_relay_interaction.md / tool_belt_shell.md vs. ARCHITECTURE.md §2

Confirmed aligned, no changes needed on my end. Specifically:
`satellite_relay_interaction.md`'s hotspot → record model (a hotspot's
panel reads a record like `AntennaGeometryRecord`/`PowerBudgetRecord`)
and the assumption that a `hardware.yaml`-style slot manifest is the
single source of truth for both the filesystem view and the visual
panel is exactly the tenant/namespace layer's "the SAME object the
physical-tool pane shows as a slot" from §2 — same object, two render
paths (terminal `/dev/`-style read, visual hotspot panel), not two
sources of truth that could drift. Nothing in either reference doc
assumes engine behavior §2 doesn't already cover.

One thing worth double-checking on your side, not a blocker: the
Mars-lineage note in `os-lineages.md` §8 ("a Mars-lineage target should
force the player out of pure terminal-hacking into the physical-tool
pane specifically") implies at least one hotspot category should be
*terminal-inaccessible* — reachable only through the object/hotspot
panel, no `/dev/`-style file view. Worth confirming
`satellite_relay_interaction.md`'s hotspot table treats that as
possible per-hotspot, not something every hotspot needs symmetric
terminal+visual access to.

## Suggested next real-RFC conversion

RFC-2305 is a policy+state admission-control protocol. A structurally
different one next time would stress the schema harder — RFC-2351 (L1
Frame Format) or RFC-2359 (Bundle Addressing) look like better
candidates than another admission-control-shaped RFC, if you have a
preference on which matters more for the vertical slice.
