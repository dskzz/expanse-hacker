# RFC-2306 — Laser Communications (Tightbeam Subprofile)

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the rulebook for point-to-point laser links — a much tighter,
much less forgiving cousin of radio, where "pointed at the wrong place
by a hair" means no signal at all rather than just a weaker one.

A laser link always moves through the same five stages, in strict
order: **Reservation** (claiming the intent to use the link) →
**Acquisition** (actually locking on) → **Maintenance** (the link is up
and tracked) → **Occlusion** (something physically blocked the beam —
a *normal*, expected condition, not a failure) → **Release** (the link
ends on purpose). Occlusion can only go back to re-acquiring, never
straight back to "maintained" — you don't get to just assume the beam
snapped back into perfect alignment on its own.

The document's core insight, stated bluntly: **a laser beam proves
nothing about identity.** Anyone who knows your geometry can point a
laser at the same spot. The narrowness of the beam feels like security,
but it isn't — the only real protection comes from authenticated,
signed records (who claimed what, when, countersigned by whom), never
from physics alone. A claim that only one side signed — "I've acquired
you" with no countersignature from the other end — is explicitly
invalid, full stop.

When two sides disagree about the link's state, the system doesn't ask
either operator what they think happened. It runs a strict, three-step
process — validate the records, reconstruct what the signed history
actually shows, then declare the outcome — and that outcome is final,
whether or not it matches what someone on either end believed.

## Where to look for exploits

- **Claiming a lock that was never actually countersigned.** A
  unilateral "I've acquired the link" claim is explicitly invalid on
  its own — a real acquisition needs both ends to sign off. A system
  that's lazy about checking for the countersignature is a system that
  can be talked into believing a link exists when it doesn't.
- **Replaying old, stale records to confuse the link's history.**
  Every record carries a sequence number specifically so a system can
  detect "this is an old record being reintroduced," not new state. A
  system that doesn't strictly enforce that sequence check can be fed
  old metadata to corrupt what it thinks the link's current state is.
- **Faking or inducing an occlusion to cause a misattribution.**
  Occlusion is a normal, expected event (something physically blocked
  the beam) — but the *reason* it happened matters for adjudication. If
  you can trigger an occlusion deliberately, or fake the metadata
  describing one, you can make a deliberate release look like an
  innocent environmental interruption, or vice versa.
- **Introducing a record with no real chain of custody.** Every state
  transition is supposed to carry an unbroken, authenticated reference
  back through the link's history. A record that breaks that chain —
  no valid provenance pointer back to what came before it — shouldn't
  be accepted at all; a system that accepts it anyway has a real gap.
- **An anchor node declaring "TRUSTED" before it's actually earned
  that.** This is called out by name as its own attack class — a node
  asserting a trusted state prematurely or fraudulently, before the
  adjudication process actually supports it. Anything that leans on an
  anchor's TRUSTED flag without checking how it got there is exploitable.
- **Relying on "the beam is narrow, so it must be secure."** This is
  explicitly named as the wrong assumption to make, repeatedly, in the
  document's own text — geometry and narrow beamwidth provide zero
  identity guarantee by themselves. Any system design that treats
  "we're pointed at each other" as proof of "we're who we say we are" is
  exactly the vulnerability this whole security section exists to warn
  against.

## What's deliberately out of scope here

The physical pointing/tracking mechanics (how you actually aim and keep
aim on a moving target) are RFC-2304's job — this document assumes a
beam can be pointed and focuses entirely on what happens to the *link
state and its authenticity* once that's true.
