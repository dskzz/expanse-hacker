# RFC-2304 — Antenna Geometry and Alignment

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the "how do you actually point a dish or a laser at something
that's moving" document — the shared foundation both tightbeam laser
links and directional radio links are built on.

The core ideas:

- **Reference frames.** You need to describe "where something is"
  relative to *something* — the platform itself, the local horizon, or
  a fixed inertial frame — and the document defines all three so
  everyone's talking about the same kind of "where."
- **A pointing state machine.** A link is always in one of a few modes:
  idle, actively acquiring a target, tracking it, or re-acquiring it
  after losing lock. Nothing jumps straight from "not pointed at
  anything" to "locked on" — it has to go through acquisition first.
- **Ephemeris is advisory, and the document says so out loud.** Where a
  target *should* be, based on known orbits/trajectories, comes with an
  honest error estimate attached — never presented as more precise than
  it actually is.
- **Alignment policy is local, not globally enforced.** Each operator
  sets their own rules for things like how long to keep re-trying a lost
  lock before giving up — there's no system-wide standard forcing
  consistency here.

The document's whole philosophy, stated plainly: a system that admits
"this is approximate and a little old" is better than one that pretends
to be precise when it isn't.

## Where to look for exploits

- **Feeding someone slightly-wrong position data.** Ephemeris is
  explicitly advisory and allowed to be coarse — which means a platform
  that's being fed subtly biased data will develop systematic pointing
  errors that look like bad luck or bad hardware, not sabotage. This
  hits budget/constrained platforms hardest, since they're the ones most
  likely to just trust an assisted feed instead of double-checking it.
- **Talking someone into widening their beacon "just for now."**
  Beaconing and beam width are configurable, and nothing stops an
  operator from being talked into a wider, more frequent beacon "to make
  acquisition easier." That also makes the platform far easier to
  detect and locate — a good way to get someone to accidentally reveal
  something they meant to keep quiet.
- **A quietly wrong reference frame.** The math that converts between
  "where the platform thinks it's pointing" and "where the target
  actually is" can be subtly miscalibrated and still report "within
  tolerance" most of the time. A persistent small pointing error with no
  obvious smoking gun is exactly the kind of thing that takes real
  investigation to trace back to one bad frame definition.
- **Trusting a single source for something that matters.** The system
  encourages cross-checking ephemeris/alignment data against multiple
  sources, but doesn't require it everywhere. Any link that, in
  practice, depends on just one feed gives whoever controls that one
  feed disproportionate power over whether the link works at all.
- **Gaps in the re-acquisition search pattern.** How a system searches
  to regain a lost lock is left entirely up to local implementation.
  A poorly-designed search pattern will have predictable blind spots —
  times or directions it never actually checks — and anyone who knows
  the pattern can move through those blind spots deliberately.
- **The coarse view hides what the detailed view would catch.**
  Operators are allowed to show outsiders only a coarse version of their
  own alignment/ephemeris data while keeping the detailed version
  internal. That gap is exactly where misbehavior or misconfiguration
  can hide from an external auditor who never gets to see the real
  numbers.

## What's deliberately out of scope here

This document is about pointing and tracking — it doesn't define what
happens once a link is actually acquired (that's RFC-2306 for laser,
and the RF-specific profiles for radio), and it doesn't define the
ephemeris hint *format* itself (that's RFC-2364).
