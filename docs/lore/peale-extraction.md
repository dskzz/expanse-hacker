# Peale Remote Extraction Platform - Io

Status: locked, 2026-11-24. First entry in the Jovian-moons pass.
Deliberately an **extraction platform**, not a refinery, and
deliberately still active — a real correction to the common
impression (including, per discussion, Expanse's own portrayal) that
Io hosts a derelict or abandoned industrial site. There's no reason
to abandon something this valuable once the actual hazard is solved
by simply never sending anyone there to begin with. Informally, on
every manifest and in every casual conversation, it's just **PREP**
— the full name is for paperwork.

**LocationChain:** `JUPITER:IO:PEALE` — the first facility anchored
to a bare `JUPITER` region domain rather than `TGC`, which stays
scoped specifically to the Ganymede Condominium
(`ganymede-condominium.md`) and doesn't extend to the rest of the
Jovian system.

Named for **Stanton Peale** — a real, genuinely obscure planetary
scientist who, with Patrick Cassen and Ray Reynolds, correctly
*predicted* in 1979 — before Voyager 1 ever arrived to confirm it —
that Io should have active volcanism, from pure orbital-mechanics
reasoning alone. Same honorific-naming convention as Oberth, Slayton,
Shoemaker, and Lassell: real, minor history, not an invented name.

## Real facts: the solar system's most violent moon

Io is the most volcanically active body known — more than 400 active
volcanoes, more than Earth has. The real cause is **tidal heating**:
Io, Europa, and Ganymede sit in a genuine orbital resonance (the
Laplace resonance, their orbital periods locked at roughly 1:2:4),
which keeps Io's orbit slightly eccentric instead of settling into a
perfect circle. Jupiter's gravity then flexes Io's interior on every
orbit, generating enormous frictional heat — the same mechanism, at
far greater intensity, behind Enceladus's own geysers. Peale, Cassen,
and Reynolds worked this out from the numbers alone, years before
anyone photographed the result.

**The correction worth making explicit:** Io isn't volatile-rich —
it's the driest of the four Galilean moons. All that heat and
billions of years of continuous resurfacing baked its water ice away
long ago. What the volcanism *does* produce in genuine abundance is
**sulfur and sulfur dioxide**, erupted and redeposited constantly,
giving Io its real mottled yellow-orange "pizza" coloring. That's the
actual commodity here — unglamorous, but real and valuable.

**The flux tube, free and genuinely strange:** Io's motion through
Jupiter's magnetic field drives a real electrical current — on the
order of a million amps — flowing between Io and Jupiter's poles,
visibly contributing to Jupiter's own aurorae (the real "Io
footprint"). The same process feeds the **Io plasma torus**, a
donut-shaped ring of ionized sulfur and oxygen tracing Io's orbit.
Good texture, not currently load-bearing for anything below.

**The hazard that actually defines this location:** Io sits deep
inside Jupiter's radiation belts — the most intense of any planet in
the solar system, well beyond Earth's own Van Allen belts. Sustained
human exposure this close to Jupiter is lethal on a timescale of
hours without exceptional shielding, a fundamentally different and
more severe hazard than anything else this corpus has built so far.

## No permanent human presence — not a policy, a hard physical limit

Psyche's skeleton crew (`psyche.md`) is a deliberate cost-and-control
choice; Lassell's small long-tour crew (`lassell-relay.md`) is forced
by light-lag. Peale has **no permanent human presence at all**,
because the math doesn't work any other way: shielding heavy enough
to make a human stay survivable costs far more than the robots that
don't need it. Electronics degrade under this radiation too, just
far more slowly and far more cheaply than keeping a person alive.

**A fully robotic, mobile harvester fleet** does the actual
extraction — deliberately mobile rather than fixed, because Io's
resurfacing rate is fast enough that a stationary rig risks getting
buried or overrun by a fresh flow with real regularity. Losing a unit
to an eruption is a routine operating cost here, not an incident
report.

**Teleoperated in real time from Ganymede** — close enough that the
light-lag is minutes, not hours, so the robotic fleet can be driven
almost conversationally rather than on Lassell's delayed-confirmation
model. This gives Ganymede's administrative weight
(`ganymede-condominium.md`) a second, quieter justification beyond
Condominium politics: it's also the nearest safe staging base for
every dangerous robotic operation in the Jupiter system, Peale
included.

**The rare exception, and the real physics behind the gear.** A
handful of physical tasks — a jammed mechanism, a unit that needs
physical retrieval — genuinely can't be done by remote hands alone.
What makes even a brief crewed sortie survivable isn't a thicker
version of an ordinary hazmat suit: Jupiter's radiation belts are
overwhelmingly **trapped charged particles** — electrons and ions,
not gamma rays or cosmic rays — and charged particles are something a
magnetic field deflects far more efficiently, per kilogram, than any
amount of passive mass shielding can block. A civilization already
running a fusion economy on He-3 (`mars-political-structure.md`'s
Phobos/Deimos operations, among others) already has the mature
superconducting-magnet and plasma-confinement engineering base that
this calls for — so Peale's sortie gear is plausibly an **active
magnetic-deflection suit or small armored pod**, generating its own
shielding field, rather than a passive lead-and-tungsten shell heavy
enough to be nearly unwearable at the scale needed.

**The real limit isn't the concept, it's the power budget.** A field
strong enough to matter has to run continuously, so sortie duration
is capped by whatever the suit's power cell can sustain, not by
choice — "extremely brief" stays extremely brief, now for a specific,
well-grounded reason instead of a hand-waved one. It also only solves
the radiation problem: it does nothing for Io's volcanic and fast-
resurfacing hazards, which stay exactly as dangerous as before. Even
with the gear, this remains the single most hazardous, best-paid, and
rarest duty assignment anywhere in this corpus — not a standing crew
roster, just better-understood gear behind the same rare exception.

## What this actually exposes

The ultimate version of `os-lineages.md`'s "logs are testimony, not
truth" theme: there is no possible *human* verification of routine
Peale operations, ever. Not slow to verify (Lassell), not merely
expensive to verify (Psyche) — genuinely, permanently impossible,
because sending someone to check is a death sentence, not a cost
tradeoff.

**The industry's actual answer to that: log bots — formally, the
witness channel.** No regulator or insurer signs off on "just trust
the operational telemetry" forever, so Peale runs a second, dedicated
fleet of hardened units whose only job is independent visual
witness — fixed and roaming cameras covering the harvester fleet
from multiple separate angles, each frame hardware-signed at the
point of capture rather than after the fact, consistent with the
AuthorityWeight/cross-cert trust primitive already underpinning this
corpus's authority model (`corporations.md`, `os-lineages.md`).
Multiple independent, cryptographically-rooted witnesses from
different physical positions are a real, well-precedented way to
raise the cost of a convincing fake well above forging a single
telemetry stream — genuine security engineering, not theater.

**It raises the bar; it doesn't restore ground truth.** The witness
channel is still transmitted data riding the same teleoperation link
to Ganymede as everything else — harder to fake convincingly across
every angle at once, but not a physical human check, and nothing
that was never transmitted live ever existed in the first place.
There's no local archive to retrieve later the way a black box
usually implies: if the link is down or compromised at the exact
moment something happens, the record isn't delayed, it's gone.

**And the cover for blinding it is already built in.** Log bots sit
on Io's surface too, which means they're exposed to the same
volcanic attrition as the harvester fleet — losing one to an
eruption is exactly as routine and exactly as unremarkable as losing
a harvester unit (above). Which means disabling a witness unit
deliberately, right before something you don't want recorded, looks
identical to ordinary bad luck. The very ordinariness of equipment
loss on Io is the perfect deniable cover for blinding the one system
built specifically to prevent deniability.

The teleoperation link from Ganymede — now carrying both the
operational and witness channels — is accordingly the entire attack
surface for this location: compromise it convincingly enough across
every angle, or simply arrange for the right unit to go quiet at the
right moment, and there is no physical cross-check anyone could ever
perform to catch it — not eventually, not at any cost.

## Why it's still running, not abandoned

Sulfur and sulfur dioxide are real, unglamorous bulk industrial
commodities — sulfuric acid production, ore-leaching chemistry — with
an obvious downstream customer already built into this corpus: the
Belt's metal-refining operations (Oberth Extraction's own processing
chain at Psyche, `psyche.md`, among others) plausibly need exactly
this kind of reagent feedstock. Once the hazard is solved by removing
humans entirely rather than by abandoning the site, there's no reason
for a profitable, in-demand extraction operation to ever shut down —
the thing Expanse's own derelict-refinery image never quite explains
is *why* anyone would walk away from wealth like this instead of just
automating around the one real problem.

## Concentrate, don't ship rock: Peale's output and the Marius Works - Ganymede

Shipping raw, unprocessed volcanic material off Io would be a real
waste of cargo capacity — most of what the harvester fleet scoops up
is silicate rock and waste alongside the actual sulfur/SO2 content,
and hauling that bulk mass anywhere costs real fuel and real transit
time for no payoff. So PREP's harvesters do **primary concentration
on-site**: robotic thermal/physical separation that strips out the
sulfur-rich fraction and leaves the waste rock behind, the same basic
beneficiation logic real mining operations already use (shipping
ore concentrate or metal pellets, never raw rock). That part doesn't
need delicate human oversight, so it stays inside PREP's existing
zero-crew model.

**Final refining happens somewhere people can actually survive:**
the **Marius Works - Ganymede**, a dedicated refinery stationed in Ganymede's
orbital neighborhood — named for **Simon Marius**, the real,
genuinely under-credited contemporary of Galileo who independently
discovered the Galilean moons around the same time and is the one
who actually proposed their names (Io included). Positioned to take
advantage of Ganymede's existing teleoperation infrastructure
(`ganymede-condominium.md`, and PREP's own teleoperation link above)
without being part of the Condominium's own political jurisdiction —
a clean real-world illustration of this corpus's own LocationChain
principle: physical position and legal/political authority are
separate facts, decoupled on purpose (the same distinction Doris
exists to formalize, `corporations.md`).

**LocationChain:** `JUPITER:GANYMEDE:MARIUS` — anchored at Ganymede's
location but under the bare `JUPITER` domain rather than `TGC`,
precisely because it sits near the Condominium without being part of
it.

**Radiation at Ganymede's distance from Jupiter is dramatically
lower than at Io** — survivable, not lethal — so Marius is where
this corpus's automation spectrum finally resolves back to ordinary
human presence: Psyche's crew is a deliberate cost choice, Lassell's
is forced by light-lag, PREP has none at all by hard physical limit,
and Marius has a real, if modest, human staff simply because the
hazard that forced everything upstream to go robotic has genuinely
dropped away by this point in the chain. Final sulfur, SO2, and
sulfuric-acid-precursor product leaves Marius market-ready — resolving
the open question below about where PREP's output actually goes:
through Marius first, not straight out of the Jovian system as raw
concentrate.

**A real, local customer, not just a long haul to the Belt.** Sulfur
is a genuine plant macronutrient, and sulfuric acid is a key input
for real fertilizers (superphosphate, ammonium sulfate) — and
`ganymede-condominium.md` already establishes that Earth holds
genuinely valuable, licensable agricultural science at Ganymede as
part of the Condominium's farming operations. That means a real share
of Marius's output never leaves the neighborhood at all: it feeds
straight into Ganymede's own agricultural program next door, a far
shorter and more sensible supply chain than hauling everything out to
the Belt's metal-refining economy (Oberth Extraction's own chain at
Psyche, among others, still takes the rest).

## Open threads

- Which company owns and runs Peale isn't decided — deferred to the
  later corporate pass (`corporations.md`), though whoever does
  inherits the same uncontested-monopoly, Rockline-Compact-style
  suspicion already attached to Oberth.
- Whether Peale's sulfur output specifically feeds Oberth Extraction's
  own refining chain or moves through an independent intermediary
  isn't pinned down.
- No named figures — nobody's permanently stationed to name, but
  whoever leads Peale's remote teleoperation team from Ganymede is a
  natural future role (added to `people-pass-queue.md`).
- Whether anyone has actually exploited the witness-channel blind
  spot (a deliberately disabled log bot passed off as volcanic
  attrition) isn't decided — a clean, specific future hook distinct
  from the broader teleoperation-hijack angle above.
