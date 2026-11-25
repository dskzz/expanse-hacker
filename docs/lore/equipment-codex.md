# Equipment Codex

Status: tracking/reference doc, created 2026-11-25. Where
`flashpoints.md` tracks standing political tensions and
`people-pass-queue.md` tracks unnamed figures, this file is a growing
reference for established technology and equipment that doesn't
belong to any one location file — built once, reused everywhere it
applies. Add entries here as new tech gets worked out; cross-
reference it from location files rather than re-deriving it there.

## The Loadframe: gravity-compensation exoskeletons

A powered exoskeleton built to let the wearer move naturally across
very different gravity environments — real engineering with a real
physical asymmetry baked into how it works in each direction.

**Low-gravity assist (walking normally somewhere like Callisto,
0.126g).** The naive fix — just make the suit heavy enough to
recreate Earth-normal weight — doesn't work: weight scales with
gravity × mass, but inertia scales with mass alone, so a suit heavy
enough to fake 1g weight on Callisto would also be roughly 8× as
sluggish to accelerate, turn, or stop. The real fix is active force
synthesis, not dead mass: motorized actuators at every joint,
calculating what force the foot should feel at each point in the
gait cycle under 1g and applying it directly — a powered push during
ground contact (timed so the reaction force goes into the floor, not
back into the wearer), and motor-controlled joint trajectories
substituting for the arc gravity would normally shape during the
swing phase. This genuinely cannot be done passively — you cannot
synthesize missing force from nothing — which makes this direction a
continuous, serious power-budget problem, the same category of
constraint already established for Peale's magnetic-deflection
sortie suits (`peale-extraction.md`).

**High-gravity relief (a Martian or Belter on Earth, 1g).** The
opposite problem, and mechanically easier: gravity is already
supplying plenty of force, so the suit's job is redirecting most of
it away from the wearer's own body rather than generating anything.
A rigid frame with its own independent load path to the ground can
carry the excess weight structurally, in parallel with the human
body, so the wearer's muscles and joints only ever feel the fraction
matching their home gravity. This can be done largely *passively*,
through the frame's own structural strength, with active control
layered on top only for balance and gait smoothness — a real-world-
precedented mechanism (today's medical rehab and industrial heavy-
lift exoskeletons already use exactly this principle, just not yet
tuned for full gravity-equivalence).

**The asymmetry is the point.** Synthesizing missing force is
inherently active and power-hungry; redirecting excess force is
largely a structural-engineering problem. The same Loadframe platform
can do both, but the two directions cost completely different
things, and neither is a simple mirror of the other.

**Why this is a real necessity, not just a convenience.** Long-term
adaptation to low gravity — bone density loss, muscle atrophy — makes
a sudden jump to full Earth gravity genuinely dangerous, not merely
uncomfortable, a real documented concern in actual spaceflight
medicine for returning astronauts. A Martian or Belter traveling to
Earth without a Loadframe-class suit isn't just going to feel heavy —
they're risking real injury.

## Open threads

- No manufacturer assigned yet — a plausible fit given established
  companies: Standard Fabrication Co. (`corporations.md`) for the
  actuator/robotics hardware, though nothing's decided.
- Whether Loadframe suits are cheap and common (routine travel gear)
  or expensive and restricted (a real access/class question, the
  same register as the Jovian Exposure Registry's own quiet power
  over who gets certified, `callisto.md`) isn't decided.
- Whether Peale's magnetic-deflection sortie suits (`peale-extraction.md`)
  share any underlying Loadframe engineering, or are a fully separate
  lineage that happens to solve a different problem the same way
  powered suits generally do — not decided.
