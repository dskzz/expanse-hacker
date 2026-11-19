# RFC-2305 — Power and Duty Cycle Constraints

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This governs how much power a device is allowed to draw, how often it's
allowed to transmit, and how it schedules itself around those limits —
the budget everything else (beaconing, acquisition, reservations) has to
live inside.

Key mechanics:

- **Reservations can be provisional.** A relay can provisionally accept
  a scheduling request (a `ProvisionalReceipt`) before formally
  confirming it, which keeps things moving in a partitioned, laggy
  network — but "provisional" means it can still be evicted later if
  the relay runs out of room.
- **Constrained devices delegate scheduling.** A tiny, battery-limited
  device can hand its scheduling decisions to a trusted relay instead of
  managing them itself, to save power.
- **Emergency overrides exist.** Life-safety communications are allowed
  to exceed normal duty-cycle limits, with appropriate logging.
- **Telemetry can be minimal on purpose.** Small devices are allowed to
  publish compact power-state records instead of detailed ones, to save
  bandwidth and protect privacy.
- **Policy enforcement varies by operator.** There's no single global
  rulebook forcing every domain to enforce duty-cycle policy the same
  way.

## Where to look for exploits

- **A reservation that was never actually guaranteed.** Provisional
  acceptance is a real, intentional gap — an originator can reasonably
  believe their slot is locked in when it was only ever provisional,
  and get silently evicted later. The paper trail (the original
  receipt vs. the eviction record) is what settles whether that was a
  mistake or something deliberate.
- **One scheduler, many devices depending on it.** When constrained
  devices delegate their scheduling to save power, that relay becomes a
  single point of failure for every device that trusted it. A
  misconfigured — or quietly compromised — scheduler can cause
  widespread delays that look like bad luck across dozens of unrelated
  devices, when it's really one bad actor in the middle.
- **A weakly-authorized "emergency."** Overrides for genuine
  emergencies are allowed to exceed normal power/duty limits. If the
  authorization behind one is weak or ambiguous, that override itself
  becomes the thing worth investigating — a convincing-enough "this is
  an emergency" claim buys real operational slack that a legitimate
  request wouldn't have gotten.
- **Not enough data to prove what actually happened.** Compact,
  minimal telemetry is allowed specifically to save power and protect
  privacy — which also means there's less to cross-check against. Real
  misbehavior can hide inside the gap between "technically compliant,
  minimal reporting" and "enough detail to actually verify anything."
- **A beacon that got quietly widened "to help acquisition."** Beacon
  duty cycle can be temporarily widened to make it easier for others to
  find and lock onto a signal — which also makes the transmitting
  device easier to detect and locate. An anomalous widening with no
  clear operational reason is worth tracing back to whoever actually
  changed the policy.
- **Different domains enforcing the rules differently.** Since
  duty-cycle policy is advisory and locally enforced, two domains can
  have genuinely incompatible interpretations of the same situation —
  producing conflicting receipts or routing decisions that aren't
  anyone's fault individually, just an artifact of nobody being forced
  to agree.

In every case, the way you'd actually *catch* one of these in-fiction is
the same: pull the audit trail — the signed receipts, the eviction logs,
the policy records — and look for where the paper trail stops matching
what actually happened. The system is built so that misbehavior leaves
evidence; it just doesn't always get looked at.

## What's deliberately out of scope here

This document doesn't define the actual beaconing/acquisition behavior
that power and duty constraints get applied to — that's RFC-2304's job
(and the laser/RF-specific profiles built on top of it).
