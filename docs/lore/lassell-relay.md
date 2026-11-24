# Lassell Relay (Triton)

Status: locked, 2026-11-24. Deliberately the *only* post-Saturn
location in the corpus — not the seed of an outer-system region, a
single thematic capstone. Uranus and Neptune don't get an economy or
a politics; they get one tiny relay/research outpost that exists
specifically to take the network-drift themes already running through
this corpus (`os-lineages.md`, `psyche.md`) to their physical limit.

**LocationChain:** `OPRA:TRITON:LASSELL` — the first facility in the
corpus anchored to OPRA's own domain rather than a political one
(`BELT`, `UN`, `MDR`, `ELYSIUM`, `TGC`). Fitting: OPRA
(`belt-political-structure.md`) is explicitly the neutral technical
standards body both OSL and ASA still have to use regardless of their
rivalry — the one kind of authority with an actual standing reason to
be this far out, since no political or economic actor has one.

Named for **William Lassell** — a real, genuinely obscure Victorian
astronomer, a brewer by trade who built his own telescopes and
discovered Triton in 1846. Same naming convention as Oberth, Slayton,
and Shoemaker: an honest, honorific reuse of real, minor history
rather than an invented name.

## Real facts: the solar system's edge case

Triton isn't an ordinary moon — it's a captured Kuiper Belt object,
and the only large moon in the solar system on a **retrograde orbit**
(orbiting backwards relative to Neptune's own rotation), strong
evidence it formed elsewhere and was caught rather than born in place.
It's also one of the only confirmed geologically active bodies this
far out: Voyager 2's single 1989 flyby photographed actual **nitrogen
geysers** — dark plumes of nitrogen gas and dust erupting from
sunlight-warmed surface ice — alongside "cantaloupe terrain," a bizarre
dimpled surface texture unique to Triton and still not fully explained.
It's extremely cold (among the lowest surface temperatures measured
anywhere in the solar system) and extremely reflective, with a thin
nitrogen atmosphere.

**The data problem is itself a real fact, not invented texture.**
No spacecraft has ever orbited Triton — the entire modern dataset is
one 1989 flyby, decades old by any measure and well over a century
old by "now" (~2350). Neptune's orbital period is 165 real years, so
the long Neptunian season has shifted substantially since that single
look — whatever Lassell's science annex is actually observing today
is, in real terms, mostly *not* what Voyager saw. The newest, best
information anyone has about this place is permanently old, and stays
that way no matter how long the outpost runs.

**The latency is the real fact that matters most for SolNet.**
Neptune sits roughly 30 AU out — a one-way signal takes on the order
of four hours to reach Earth, so a single question-and-confirmation
exchange eats most of a working day before anyone involved does
anything else. That's not an engineering shortfall anyone can patch;
it's the actual speed of light, a hard floor under everything else
this file describes.

## Who's there, and for how long

A small crew — comfortably under ten — splitting between relay/comms
maintenance (OPRA's actual mandate here) and a modest, Earth-funded
science annex studying the geysers (the same Earth-owns-the-science-
IP pattern already established for Ganymede,
`ganymede-condominium.md`), riding along because nobody funds two
separate missions this far out when one outpost can host both.

**Isolation here is physics, not policy — the direct opposite of
Psyche's model.** Oberth deliberately keeps Psyche's holdouts
transient so no community can organize (`psyche.md`); Lassell can't
do that even if it wanted to; a tour is measured in years because the
travel cost makes anything shorter uneconomical, and nobody's
"rotating out" quickly regardless of what policy says. The people who
take a Lassell posting tend to be specialists who genuinely want the
isolation, or who simply have nothing more urgent pulling them
elsewhere — a self-selecting population, not a managed one.

## What the light-lag forces, architecturally

A four-hour one-way light-lag makes any live-handshake trust check
physically impossible — not a drift artifact, a hard constraint. So
Lassell runs on **long-lived, delegated authority tokens, refreshed
on a schedule measured in weeks or months rather than checked live**
— and critically, this is a **deliberate, formally approved design
exception**, not an accident. That's the real distinction from
Psyche's stale cached authorization: Psyche's version is drift nobody
noticed; Lassell's version is the system doing *on purpose*, for one
node, exactly what everywhere else is a bug — the same formal-versus-
real-authority throughline already running through MDR's capability-
is-authority logic and Elysium's Consular seat, just surfacing here
as protocol design instead of politics.

**The hook that falls straight out of the model:** a node that's
institutionally *expected* to go unverified for weeks at a time is
the single stealthiest place in the entire network to plant something
durable, precisely because nobody treats a long silence from Lassell
as suspicious — it's the designed-in norm, not an anomaly. Whether
anyone's ever actually tried that isn't decided; it's the obvious
next hook if Lassell shows up in anything plot-specific.

## Open threads

- Whether Lassell's long-lived-trust exception is formally documented
  in a specific SolNet RFC or just long-settled operational practice
  nobody's ever written down — open, and relevant to `os-lineages.md`'s
  own "no one had the standing to force a clean redesign" thesis.
- Whether anyone's actually exploited the exception yet, and who —
  deliberately left open.
- No named crew yet (added to `people-pass-queue.md`).
- Exact founding date isn't pinned down beyond "long enough ago that
  the Voyager-era dataset's obsolescence is already an old joke on
  station, not a fresh complaint."
