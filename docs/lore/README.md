# Lore Index

Status: created 2026-11-24 as a navigation aid once this folder
passed the point where "just read the files" scales. Not a wiki —
GitHub's built-in repo wiki or a static docs site (MkDocs,
Docusaurus) are the natural next steps if this still isn't enough
once the worldbuilding settles down, but setting one up mid-flow
while new interconnected lore lands every session would mean
maintaining two copies of everything in parallel. This index is the
cheap fix for now.

**A loose naming convention, 2026-11-24:** as the roster of obscure-
honorific facility names grows (Oberth, Slayton, Peale, Lassell,
Marius...), names that give no hint where the place actually is risk
blurring together. Where that's a real problem, append the body
directly into the formal name — `[Name] - [Body]`, e.g. "Peale Remote
Extraction Platform - Io," "Lassell Relay - Triton," "Marius Works -
Ganymede." Not a hard rule: a location with its own deep, heavily-
developed lore (Vishvakarma, Thisbe Station) earns memorability
through content rather than needing the crutch, and a body-named
location (Ceres, Vesta, Psyche) has no problem to fix in the first
place. Applied so far to the three names above; worth revisiting for
any existing or future name that turns out just as hard to place.

## Foundational

- **`os-lineages.md`** — the big one. OS/software lineage history,
  the Seven Day War, the Massacre at Thisbe Station, the Frontier
  Opportunity Program, the four OS lineages (Earthstock, Scrapshell,
  Mars capability-fork, Corporate). Most other docs trace back to
  something here. Now also (§12): SolNet's political character named
  explicitly — "ancap in networking," unenforceable by design. The
  narrow waist is addressing only (RFC-2350's LocationChain/
  ServiceChain plus RFC-2351's A-header); the N-header and everything
  behind a location's own gateway is unstandardized local discretion,
  universally (a station can run literal Token Ring behind a
  translation gateway and still be a valid participant), with a real,
  named, deliberately low compliance floor (RFC-2351's fallback mode).
  What actually holds the system together absent any enforcement
  mechanism is reputation and access-gating, not law — which reframes
  the UN's own "federal in space" authority
  (`earth-political-structure.md`) as the same access-gating logic
  applied politically, not coercive enforcement. Earth's own nine-bloc
  fragmentation is this same trust-domain paradigm (RFC-2362) read at
  the political layer: one Earthstock lineage, nine CA roots,
  cross-certification tracking actual diplomacy.
- **`demographics.md`** — how Sol's population map actually shifted:
  Earth's non-nuclear decline, old capital surviving state collapse,
  and which cultural threads are load-bearing where (West African,
  Slavic, Chinese, Indian, Dutch/Germanic, French). Now also: the
  Slavic thread's second, earlier seed (Korolev Propulsion and
  Vernadsky Systems, decades before the later religious-discomfort
  wave) and a new, deliberately niche Scottish/Irish thread anchored
  to Saturn's own Highland-coded clans, earned the same way Hauptmann
  & Voskuijlen's Dutch/Germanic thread is — old hardship's thread, not
  a national one.
- **`frontier-timeline.md`** — companion to this file and to
  `os-lineages.md`'s own §1: not which cultural threads are load-
  bearing, but *when* each settlement wave actually happened and what
  real, Earth-side condition pushed it outward, each one explaining
  why the next became necessary. Four phases — ambition and rivalry
  (~2095–2180, nobody fleeing anything yet), release valve (India's
  own exodus and Vishvakarma's real founding, ~2150–2180), the
  diasporas multiplying and Jupiter filling up (~2180–2250, Saturn
  lagging behind it as Jupiter's own water supplier before its real
  settlement boom), and scarcity (the 2330s to now, Luna's own
  depletion pushing Mercury's economic upgrade, Saturn's charter fight,
  and Venus's very recent wealth-funded luxury boom) — with the
  Rupture (`os-lineages.md`) sitting fixed between the first two.
  Also: Spitzer Station, Korolev Propulsion, and Vernadsky Systems
  (the actual engineering origin of fusion-torch propulsion and
  closed-loop life support, both carrying genuinely old Hauptmann &
  Voskuijlen equity — `corporations.md`); Armstrong City's real
  founding trigger; and Terebra Subsurface, the Mars tunneling firm
  that built Mercury's Deep Ring.

## Mars

- **`mars-political-structure.md`** — MDR/MRN, the Commonwealth of
  Elysium (Datong as its capital, its 13th Consular seat, its
  authoritarian-corporatist evolution), the Mariner Valley Caucus,
  Mars's own helium-3 independence via Phobos/Deimos, and Admiralty
  House — the MRN's real command center, deliberately kept mobile
  and off any fixed body (real kinetic-bombardment logic), its exact
  host ship rotated and treated as classified rather than published
  through the usual LocationChain honesty this corpus otherwise
  holds to everywhere else. Now also: four intelligence services, not
  one — ODS (domestic/doctrinal, "a bit fascistic," Mariner-Valley-
  wide), MVBI (conventional federal law enforcement, deliberate
  coup-proofing rival to ODS), MRN Intelligence out of Admiralty House
  (external/military), and Elysium's own Jinyiwei (the real Ming
  Dynasty's imperial secret police, Cheka-style methods, a far more
  honest fit for Elysium's Sino-Russian lineage than copying Mariner
  Valley's own naming register, colloquially "the Jinis") — with ODS
  and the Jinyiwei both claiming Elysium's own ground. Also now:
  "Beyond the Moons," a Mars-born spacer's own first-departure-past-
  Phobos/Deimos threshold ceremony, named in Mars's own plain,
  undecorated register rather than Earth's borrowed poetry.
- **`mariner-valley.md`** — the capital itself: founding history (a
  dozen underground starter colonies), capability-is-authority, the
  Presidency, the Martian Congress's malapportionment problem, and
  the Consular College. Now also: **Severance Day, ~2265**
  (`frontier-timeline.md`) — MDR's own actual independence date, pinned
  down rather than left open, with the UN choosing not to contest it
  by force during the same stretch of overreach driving Saturn's
  settlement — the real root of Mars's own standing insecurity, not
  just a dating detail, and named plainly rather than triumphantly on
  purpose.

## The Belt

- **`belt-political-structure.md`** — OSL/ASA and the shared
  Anti-Solar Accord they both claim to descend from. Now also: OSL's
  own seat, nominal at Ceres but actually a monthly rotating circuit
  among notable rocks (sometimes Jupiter) — a quiet, continuous
  rebuke of Hetman Piast's own claimed centrality, and the same
  rotating-seat logic already used for the Three Seas bloc and Patria
  Grande, applied to physical location instead of just who holds the
  chair. Also now: a third axis beyond OSL/ASA, "unclaimed" — real
  salvage-law vocabulary borrowed for political standing, not a
  standing organization (that would defeat the point), with Davida
  as the clean unclaimed-by-neglect example; VPH (Vesta/Pallas/
  Hygiea, `asteroid-bases.md`) stays confirmed ASA territory in three
  real flavors, corrected here after an earlier pass mistakenly
  treated Pallas as neutral ground. Now also: "Down the Well" and
  "Past the Rocks," the Belt's own pair of threshold ceremonies in
  opposite directions (home has two edges when you live in the
  middle), plus a full small family of related ceremonies tied to
  other homes and extremes — Earth's "Leaving the Cradle"
  (`armstrong-city.md`), Mars's "Beyond the Moons"
  (`mars-political-structure.md`), and the two genuinely Sol-wide
  ones belonging to no one's home, Diving the Furnace
  (`mercury.md`) and Saturn's Gate, now fully built out (`saturn.md`).
- **`belter-pidgin.md`** — Rock Talk/Kamenya, the original
  constructed pidgin replacing Lang Belta. (The `Lang Belta
  2022-02-15.pdf` in this same folder is old external reference
  material, not canonical — superseded by this file.)
- **`ceres.md`** — the Belt's biggest hub: the UN's MFN trade
  framework, Hetman Stanislav Piast, the Consular-College-style
  Magnate class, and Imara Oduya's opposition. Now substantially
  deepened: real grounding (largest Belt object, Occator Crater,
  Ahuna Mons, Dawn as the completed-mission anchor); one of the
  earliest Belt settlements (~2100–2130, `frontier-timeline.md`), an
  early Slavic technical-elite population growing its own organic
  political culture over a century-plus rather than a recent
  transplant; the real physics ruling out spinning the asteroid itself
  (escape velocity, the real asteroid "spin barrier"); and **Cole
  Spindle Works'** real, two-generation spin-habitat solution instead
  — a small original pair (~2100s) and the much larger **Cole
  Standard** (~2220–2250): four modules (two counter-rotating pairs),
  670m radius, 1,500m length, 1 RPM, built to a 0.75g capacity
  deliberately exceeding Mars's own already-accepted 0.38g floor (a
  real economic analysis, A=2V/r, showing that choice was a deliberate
  spend past the bare minimum, not the cost-optimal one), operated at
  a gentler 0.5g for accessibility. Full internal design worked out:
  a radial zone stack doubling as a class gradient (premium/admin at
  the rim, down through mid-tier and lower-class/industrial to a
  260m-radius Core Complex of docking, traffic, and heavy industry);
  population and agriculture scaled against each other; Belter-scale
  (~4.5m) stories; three-ring drive redundancy; inter-module connector
  tunnels and buffer-zone surface access shafts (Terebra Subsurface's
  fifth genuine use in this corpus); and a non-rotating bypass tube
  with zero-g emergency stations trading a sub-minute rotational wait
  for a much faster response than the main transit network. All of
  which feeds a real, sharpened version of the Oduya/Piast rivalry: the
  joke underneath it is that Cole Spindle Works' engineers had already
  solved the fight quietly, as a side effect of the geometry — the
  original 0.5g setting already puts the lower-class tier near a third
  of a g — until Piast breaks that working compromise by recklessly
  spinning a single module (not the physics-sound paired version) up to
  its full 0.75g for Earth immigrants who haven't arrived yet,
  defending it by pointing out the poor already live at a third of a g
  in his own building — a decree that earns its own lasting nickname,
  "Piast's Ugly Spin," from day one. A literal Berlin-Wall-shaped
  gravity fight results, with the movement's own catchy, technically-
  unworkable-if-taken-literally chant ("Slow down the drums! Point
  Three G!") sitting over Oduya's real platform: let Piast keep his
  Ugly Spin, and build a new, cheaper, purpose-built 0.3g module as its
  counter-rotating partner, fixing his own structural recklessness for
  free. That real compromise, stolen from an internal white paper by a
  hired, deliberately unnamed consultant and leaked stripped of
  context, becomes the next day's "Oduya Sells Out to Piast" — plus a
  genuine three-tier Belter-body spectrum, with Ceres itself — the
  Belt's own capital — ending up the place "Belter bodies" are least
  common, not most.
- **`thisbe-station.md`** — the founding-trauma site: the real
  asteroid, the workers' cooperative, the space-Cuba diplomatic
  stalemate, and the live, unresolved helium-3 crisis. Now also: the
  cooperative's own internal three-way split over what to do with the
  discovery (develop-carefully, keep-it-hidden, cash-out), a real
  internal opposition dynamic underneath the already-established
  external UN/OSL/ASA/MDR pressure.
- **`slayton-construction-yards.md`** — the deliberate, better-
  reasoned replacement for Expanse's Tycho Station: a real Kirkwood
  gap siting, an early corporate-by-necessity founding, and the
  ownership-vs-partnership structure protecting Elias Voss.
- **`rickover-naval-yards.md`** — the physical place behind
  `corporations.md`'s Earth military-industrial decline arc: Luna
  plus dispersed orbital facilities, `UN:LUNA:RICKOVER`.
- **`industrial-stations.md`** — real orbital anchors and
  LocationChain addresses for the rest of the shipbuilding supply
  chain and industrial-components companies (Anchorpoint, Garrison,
  Corelli, Standard Fabrication, Patchwright, Skipjack, Cutwater,
  Millrace), lighter tier than a full page each.
- **`vishvakarma.md`** — the oldest industrial station in Sol,
  sited at the genuinely stable Earth-Moon L4 point, named for
  India's ascendant era and the real demographic thesis in
  `demographics.md` — a structural (not name-for-name) echo of Honor
  Harrington's Hephaestus.
- **`asteroid-bases.md`** — the next tier after Ceres/Thisbe: Vesta,
  Pallas, Hygiea (oldest, hardest-luck, ASA-leaning, each with its
  own distinct flavor of that politics), genuinely ordinary Davida,
  Tortuga-styled Sylvia's Reach, and the deliberately minor,
  unhighlighted Shoemaker Outpost (Eros).
- **`psyche.md`** — Oberth Extraction's home: a deliberately
  hands-off, heavily-automated skeleton-crew mining claim built on
  the real exposed-protoplanet-core hypothesis. Wasn't always empty —
  a decade-long automation campaign hollowed out a real workforce
  (the Core), feeding a Belt-wide diaspora and leaving bitter last
  holdouts as ASA's single most dangerous unresolved recruiting
  target.

## Inner Planets

- **`mercury.md`** — Lawrence Station - Mercury: real polar water ice trapped
  by Mercury's own permanently-shadowed craters, paired with
  exceptional solar collection from the same planet's extreme flux.
  Automated for a fourth distinct reason beyond everywhere else built
  so far — brutal thermal cycling, not radiation or light-lag. Now
  also: why that solar power doesn't get exported as power (real
  energy-density economics, the same logic that keeps aluminum
  smelting near cheap hydro power) — instead it runs the Deep Ring,
  an underground particle-accelerator complex fed by the Parker
  Array on a nearby "peak of eternal light" ridge, under old Earth
  university consortia with a formal Mars research agreement tied to
  MDR's own fusion-fuel-independence program. Now also: the same
  polar cold traps are plausibly the richest helium-3 deposit in the
  solar system by concentration (Mercury's weak field doesn't shield
  the surface, and it's far closer to the Sun than Luna); a second,
  non-polar site for platinum-group metals tied to the core-stripping
  mystery; real delta-v economics explaining why only those two
  justify the genuinely brutal trip (Mercury orbit costs more delta-v
  than Pluto in some real mission profiles); mass drivers as the
  real-engineering answer for the local surface-to-orbit leg only,
  not the trip itself; and why a Mercury-bound ship needs its own
  dedicated thermal/radiation outfitting (sunshades, oversized
  radiators, a flare/CME storm shelter, with the Parker Array
  doubling as early-warning infrastructure). Now also: the Mercury
  Run gets its own Earthstock-exclusive merchant house, Perihelion
  Traders, running sail-assisted Zephyr-class haulers
  (`ship-class-codex.md`) crewed by the Sunbirds on dose-budget-
  driven rotations (roughly one round trip per tour, not a fixed
  calendar figure) through "the Furnace" — the real tea-clipper trade
  as direct ancestor, real solar-sail physics (outbound direct
  thrust, inbound angled angular-momentum-shedding), real rocket-
  equation limits on what fusion drives actually buy, and real
  Earth-Mercury launch-window mechanics (a ~116-day synodic cadence,
  a lead-angle targeting model rather than "same side of the Sun").
  Now also, system by system: metal-cable sail rigging and EVA
  maintenance work; suits with solar-cell fabric and extreme glare
  protection; active electromagnetic shielding against solar
  energetic particles specifically (not cosmic rays or gamma
  radiation); a safe room shielded by real water/consumables mass
  rather than a lead box, plus waste mass doing the same job through
  the dive before getting "ballasted" sunward on the way out for a
  free reaction-thrust assist; and the Corona Watch, a human
  coronagraph-watch role backing up the Parker Array's own
  early-warning network. Also now: why the Sunbirds are the one crew
  with a real reason to revive old sailing-era rigging vocabulary
  everyone else dropped, a flagged future RFC hook (a veteran
  Sunbird's own voiced section on real solar-conjunction comms
  blackouts), and "Diving the Furnace" as their own Crossing-the-
  Line-style threshold ceremony. Also now: Terebra Subsurface, the
  Mars tunneling firm that actually built the Deep Ring in a joint UN
  venture, and Lawrence Station's own founding pinned down as research-
  first (~2190–2200), with the He-3/platinum-group economy above a
  real but later upgrade once Lunar depletion made the trip newly
  worth making (`frontier-timeline.md`).
- **`venus.md`** — Landis Habitat(s) - Venus: real floating aerostat cities
  in the one altitude band where Venus's atmosphere is nearly Earth-
  like, using ordinary breathable air as the lifting gas. The one
  genuinely pleasant place in the whole corpus — atmospheric/
  biosignature research (the real, still-disputed phosphine question)
  alongside a luxury wellness destination, with altitude-keeping as
  the actual hazard instead of survival. Now also: a real cluster of
  independently-operated, mutually-tethered platforms (not three
  isolated habitats) plus a dedicated spaceport, with a real class
  divide between wealthy guests and the maintenance crew (plausibly
  Atlantic Zone labor migrants) doing the actually dangerous
  buoyancy/station-keeping work; governance split between the UN
  Space Survey Directorate (research) and Off-World Development (the
  resort side); a precise clarification of what "enclosed" actually
  means here (a light greenhouse-style envelope, not a pressure hull
  or thermal shield); a real senior-housing niche backed by actual
  gravity/vestibular medicine; a reservoir platform doubling as a
  beach — precious imported water flaunted rather than conserved, the
  deliberate opposite of Mercury's own waste-ballast relationship to
  scarce mass; and Mars's own small, deliberate toehold alongside
  Earth's sprawl. Now also: Venusian golf, real gravity's own modest
  distance boost deliberately stacked with custom-thinned-air drag
  reduction for genuinely absurd yardage (a flex, not a planetary
  freebie); gas yachting, rowboats, and engineered-wind sailing on
  the reservoir; a second real economic pillar in gravity-
  reacclimation medicine, giving Mars's own presence real operational
  weight as a readaptation layover en route to Earth; and "Venusian
  birding" — real, serious microbial-astrobiology science underneath
  a romanticized popular nickname, like the Loch Ness hunt but mobile
  across a vast shifting volume instead of one fixed lake. Now also:
  Earth-Venus transit as a genuinely casual run rather than a delta-v
  trap (comparable cost to a Mars transfer, real aerobraking/
  aerocapture available given the thick atmosphere, a ~584-day real
  synodic launch window), and the real cause behind the station-
  keeping hazard — Venus's actual atmospheric super-rotation, circling
  the whole planet in ~4-5 days versus the solid planet's 243-day
  rotation, also giving residents a genuinely alien day/night rhythm.
  Now also a full institutional layer: a Spaceguard node and a DSS
  listening post hiding under a basic UN embassy; a real Berlin-
  situation counterpart, MRN Intelligence's own post hiding inside
  Mars's research platform, both sides' posts a known, unspoken
  secret, concentrated at "the Embassy Platform"; Venus's own
  Monaco/Switzerland-style registrar appeal (distinct from Doris's
  obscurity model), with Hauptmann & Voskuijlen running the private-
  banking side; a weather service and small meteorology university;
  real sightseeing appeal including an engineered, bespoke "safe tan"
  (natural cloud-filtered light is actually UV-poor, not UV-rich); a
  stakeholders'-council governance model distinct from Armstrong
  City's or Ceres's; OSL's own modest gravity-remediation presence
  tied to the Belt's "Down the Well" ceremony; and a live cross-
  platform unionization fight the New International is organizing,
  resisted hard because a win on one platform threatens to cascade to
  all of them. Now also a real, two-stage settlement history
  (`frontier-timeline.md`): a modest, unglamorous research-platform
  presence going back to the 2200s, and the luxury-wellness cluster
  above as a very recent addition within the last 50 years, funded by
  wealth concentrated from Saturn's own platinum rush and Mercury's
  Sunbird trade — the real reason Venus reads as the newest and least
  lived-in major development in the whole corpus.

## Earth

- **`earth-political-structure.md`** — massively expanded: the real
  nine-bloc structure governing Earth's actual domestic politics
  (the Atlantic Zone, the African Union, Bharat, a Zhongguo-descended
  bloc, a Three Seas-descended bloc, the Eurasian Union, Patria
  Grande, ASEAN and Others, an OIC-descended bloc), indirect/caucus
  UN representation, the loyal Proportionality Caucus alongside the
  revolutionary New International, the UN's real three-tier geography
  (NYC ceremonial, New Delhi administrative, Luna's off-world
  bureaucracy), and a full military-teeth framework — toothless on
  Earth but federal-strength in space, an unusable kinetic deterrent,
  treaty-capped ground forces weaker than Mars's, orbital embargo as
  the real lever, and a rogue-command vulnerability that's technical
  underneath its political safeguard. Now also: four permanent veto
  seats (Atlantic Zone, Eurasian Union, Zhongguo-bloc, and Bharat —
  won through funding/tech leverage, not fairness), a Joint Military
  Council instead of an SG-as-CINC, symmetric selection/removal
  thresholds for the Secretary-General, and the UN's genuinely
  different postures toward the Belt (co-option via Permanent
  Observer status) versus Jupiter (defending an existing seat). Now
  also: the Committee of the Whole at New York (each bloc's seven
  caucus delegates plus up to three delegates per individual member
  nation — the UN's deliberately oversized, mostly-ceremonial body
  that doubles as crisis-response infrastructure), money/lobbying/
  corruption mechanics (varying by bloc, two-tier corruption split
  between NYC's petty version and New Delhi's well-hidden version), a
  short list of other UN departments, a command structure revised into
  two layers (the small professional Fleet Staff — Home Fleet Admiral,
  Frontier Fleet Admiral, Marine Commandant, Merchant Marine liaison —
  under the nine-seat civilian Joint Military Council), and Mars's
  explicit footing as a peer sovereign power outside the bloc system
  entirely, not a tenth bloc. Now also: procurement via geographic
  return (modeled on the real European Space Agency's own practice)
  and how the Atlantic Zone out-competes a rising Bharati contractor
  through technical-standards manipulation rather than denying Bharat
  its own guaranteed share; four specialized agencies (the
  International Court, the UN Monetary Authority with its own
  capital-weighted voting hierarchy, the Public Health Directorate,
  the Commons and Environment Directorate), each nominally
  independent but structurally tied to the same funding/bloc politics
  as everything else; and a fully worked example of the rare Earth-
  binding-consensus mechanic actually firing — the UN Convention
  Against Torture, binding on all nine blocs, genuinely unenforced in
  practice, and binding on neither Mars nor Doris nor the Belt, which
  is exactly the seam Haven Corrections Group's Earth-Mars joint
  venture now sits on. Now also: the UN Human Rights Council (the
  broad standing mandate the Committee Against Torture sits under as
  one treaty-specific committee); Additional Protocol IV (Outer
  Space), extending real Geneva Convention tradition off-world with
  genuinely enforceable bite given the same domain split, OPRA's relay
  network named as explicitly protected, and signatories outside the
  nine blocs entirely; each bloc's own CA-root/trust-domain
  fragmentation under Earthstock (`os-lineages.md` §12); and two more
  departments, the UN Spaceguard Directorate (dual-purpose near-object
  detection, doubling as deliberate-kinetic-attack early warning, with
  Mars's own already-flagged missing capability creating a real
  dependency) and the UN Space Survey Directorate (survey/registration
  ahead of Off-World Development's own economic arrangements); and a
  space-only UN intelligence/counterintelligence service, the
  Directorate of Security Services ("the Quiet Service"), tasked above
  all with guarding the Fleet's own authorization systems against the
  rogue-command vulnerability — and just as plausibly the likeliest
  vector for exploiting it, captured by the four veto powers the same
  way everything else here is. Now also: the opposition landscape
  rounded out beyond just the New International and Proportionality
  Caucus — the New International's own open/underground internal split
  (live tension, not yet a clean break), the Sovereignty League (the
  missing right-wing, anti-UN-integration counterpart, strongest in the
  Atlantic Zone and Three Seas bloc), and the Free Commerce Alliance
  (an outright astroturf group, secretly Sol-Industrial-Trust-funded).
  Also now: the Good Neighbor Understanding, an informal, unwritten
  spheres-of-influence norm among all four veto powers (the real
  Monroe Doctrine/Good Neighbor Policy as direct ancestor), giving the
  Patria Front a second, sharper grievance beyond Brazilian dominance
  (`earth-blocs.md`). Still explicitly a work in progress.
- **`space-law-compacts.md`** — the real maritime-law family, ported
  compact by compact: the Sol Tripartite Process (UN proposes, then
  Mars/UN/OSL negotiate — ASA structurally excluded by having no seat
  in it); the Good Samaritan Compact of 2112 (duty to render
  assistance to persons and vessels alike, the *Amaranth*/*Ondine*
  founding incident echoing the real Titanic/SOLAS history, exceptions
  including a space-specific propellant-margin carve-out); Salvage Law
  ("no cure, no pay"); Interplanetary Rules of the Road; the General
  Average Compact; the Limitation of Liability Compact; the
  Interplanetary Marine Insurance Framework (three genuinely different
  models across Earth/UN, Mars, and Belt/OSL, plus ASA's total
  uninsurability); the Anti-Piracy Compact's universal jurisdiction;
  flag-state jurisdiction named outright; the Interplanetary Nuclear
  Non-Proliferation Agreement (all nine Earth blocs already
  nuclear-armed by the time it's negotiated — the real teeth is
  keeping weapons out of space and barring proliferation to new
  actors, not Earth's own already-settled proliferation); the
  Interstation Tax Compact (captured by design via Doris, not just
  weakly enforced); and the Freedom of Transit Compact, deliberately
  loaded with five real-world-grounded loopholes.
- **`earth-resources-and-pressures.md`** — Earth's own "double studs":
  real demographic/social pressure per bloc (the Atlantic Zone's
  decline-and-urban-decay, the African Union's youth-bulge double
  edge, Bharat's and the Zhongguo bloc's food-security strain, the
  Eurasian Union's demographic decline without the Atlantic Zone's
  wealth cushion, Patria Grande's inequality offset by real export
  leverage, the Three Seas bloc's emigration drain, ASEAN and Others'
  industrialization cost, and the OIC bloc's fusion-era economic
  anxiety), plus who feeds whom (Patria Grande, the Eurasian Union,
  the Atlantic Zone's own agriculture, and ASEAN as net exporters;
  Bharat, the Zhongguo bloc, and the OIC bloc as net importers) and
  who makes things (the Atlantic Zone's advanced/aerospace-grade
  manufacturing, the Zhongguo bloc's higher-value industry, ASEAN and
  Bharat competing for mass manufacturing). The OIC bloc's fusion
  anxiety ties directly into a new, second motive behind the Europa
  Allocation Council's quota fight and standing UN-level pressure
  against expanding Thisbe Station's helium-3 discovery. Now also:
  waste as an export rather than a burial problem — the real orbital
  mechanics ruling out literally firing garbage into the Sun (it costs
  more delta-v than leaving the solar system outright), and the real
  reason a mass driver at Ecuador's Chimborazo works instead (the
  equatorial bulge making its summit the single point on Earth
  farthest from Earth's center, plus the equator's own free rotational
  boost). Officially the Equatorial Bulk Export Program, popularly "the
  Trash Train" — outbound cargo becomes genuine Belt-side salvage
  feedstock for Driftwood Salvage & Reclamation (`corporations.md`),
  received and sorted by a real, grim waste-picker labor economy with
  a direct real-world precedent in India's own informal waste-picking
  cities, traveling outward with the same diaspora already established
  (`frontier-timeline.md`).
- **`earth-blocs.md`** — the deferred follow-up: each of the nine
  blocs' own internal governance, one real institutional ancestor per
  bloc rather than a shared template (the Atlantic Zone's EU-style
  rotating-Presidency Council, the African Union's matured real AU
  structure, Bharat's genuinely competitive parliamentary democracy,
  the Zhongguo bloc's centralized unitary state, the Three Seas bloc's
  deliberately loose summit-based governance, the Eurasian Union's
  Russia-anchored formal-equality-masking-real-dominance structure,
  Patria Grande's Brazil-anchored Mercosur-descended rotating
  presidency, ASEAN and Others' consensus-bound "ASEAN Way" with
  Turkey's awkward fit, and the OIC bloc's Iran/Saudi rivalry brokered
  by Pakistan's own neutral position). Now also: named zone-level
  domestic opposition for each bloc, distinct from the Earth-wide
  Sovereignty League/New International/Proportionality Caucus
  (`earth-political-structure.md`) — the Lagos Compact (AU
  regionalism), the Kisan Front (Bharat, real farmer-protest-grounded),
  the Steppe Accord (Eurasian Union junior-member autonomy), the
  Patria Front (ironic-naming Peronist opposition to Brazilian
  dominance), and a fusion-economy "diversify now" reformist faction
  inside the OIC bloc, kept deliberately non-sectarian. Now also:
  Patria Grande's own flagship orbital infrastructure, finally, and an
  Ecuadorian one rather than Brazil's — the Chimborazo mass-driver
  complex (`earth-resources-and-pressures.md`).
- **`armstrong-city.md`** — Armstrong City and Shackleton Base: the
  DC/Congress governance model, the UN's two-tier geography
  (prestige on Earth, bureaucracy on Luna), and the corporate HQ tax
  incentive. Now also: mass drivers (real O'Neill-proposal
  engineering) as the likely mechanism moving bulk regolith from
  Luna's surface mining sites up to orbit — the proven precedent
  Lawrence Station - Mercury (`mercury.md`) later reuses rather than
  reinventing. Also now: "Leaving the Cradle," an Earth-born spacer's
  own first-departure-beyond-Luna threshold ceremony, named directly
  for the real Tsiolkovsky quote. Also now: Armstrong City's actual
  founding trigger (`frontier-timeline.md`) — a UN confidence-
  restoring tourism project after an early refinery disaster, India's
  own ring of hydroponic farms, and a mass driver originally built to
  launch grain down to Earth before its later regolith-to-orbit
  repurposing above.

## Saturn

- **`saturn.md`** — the outer-planets pass's anchor entry, and the
  corpus's first genuinely clan-based polity: the Ringers, modeled
  directly on real Highland clan politics (constant real inter-clan
  feuding and shifting alliances existing alongside a shared identity
  that's mostly how outsiders see them, becoming real unity only in
  rare moments of genuine shared threat — the Wars of Scottish
  Independence against Edward I — and conspicuously absent even then
  in the moments that mattered most, the Jacobite risings' own
  clan-on-clan split). No standing government — the Gathering convenes
  periodically without ever holding authority between gatherings.
  Real Saturn-system grounding throughout: a surprisingly Earth-like ~1.07g at the real 1-bar
  reference level, genuinely weaker radiation belts than Jupiter's,
  real helium rain explaining Saturn's own measured excess heat, and
  the real scale gap between the ring/E-ring debris zone and Titan's
  own much more distant, genuinely clear orbit. Three occupations: the
  Rorqual-class (`ship-class-codex.md`) break-and-scoop ice-harvesting
  fleets, clan-controlled, working the rings themselves; a genuinely
  practical atmospheric skimming operation for hydrogen and helium-3 —
  Saturn's shallower gravity well succeeding exactly where Ganymede's
  own Jupiter-atmosphere research stays impractical
  (`ganymede-condominium.md`) — run by an outside UN/MDR consortium in
  a deliberate, uncomfortable echo of the real Highland Clearances, the
  one occupation the clans don't control; and plow ships maintaining
  marked, buoyed lanes through the real debris-choked zone near Saturn
  itself (the actual shape of real icebreaker escort services, which
  clear one hazardous stretch, not an entire voyage), with outside
  haulers cutting reckless real gravity-assist slingshot lines through
  those lanes as the one hazard every clan actually despises. Also:
  Cassini Works - Rhea (refineries and forges for both resource
  streams), Huygens Landing - Titan (a genuinely "better Venus" built
  on human-powered flight — real physics, given Titan's ~0.14g and
  thicker-than-Earth atmosphere — and sailing the real liquid-methane
  Kraken Mare and Ligeia Mare), and Herschel Station - Enceladus (the
  outer system's own flagship unresolved-biosignature question, real
  geyser-sampled organics and phosphates playing the same role Venus's
  phosphine and Europa's ocean evidence play elsewhere). Saturn's Gate
  itself is now fully built out — crossing the real heliocentric
  distance of Saturn's orbit outbound, literally through one of the
  plow ships' own lane gates, into the deep, nearly empty system
  Lassell Relay alone occupies beyond it. Also now a second political
  axis layered across clan rivalry, the real Highland/Lowland divide
  ported directly, with all six houses now named: three Highland
  clans working the rings themselves — Dunmore (innermost, fiercest
  holdout), Ardcarrick (Tethys, holding the one plow-ship lane all
  Lowland trade actually depends on), and the Stanitsa (mobile,
  Russian/Cossack-descended and deliberately consolidated rather than
  scattered, the real exception to the other two's Scottish/Irish
  coding) — against three Lowland
  houses clustered around Mercat - Dione and Rhea, openly aping the
  Jovian system's own commercial sophistication: Fennick (cautious,
  established), Kerrow (aggressive, impatient with Fennick), and
  Dalreoch (Rhea-based, enmeshed with Cassini Works, the named local
  face of the atmospheric consortium's own Clearances-style grievance).
  Mercat itself is the Lowlands' own capital, nowhere near Callisto's
  level, its houses chasing an as-yet-ungranted JDC-style charter the
  Highland side blocks on principle — with Ardcarrick's own lane as
  its real, physical leverage. Now also a real settlement history
  (`frontier-timeline.md`): Saturn's first reason for existing was as
  Jupiter's own water supplier, lagging Jupiter's own settlement
  accordingly, and its real population boom came later, triggered by
  an unconfirmed platinum-group-metals "gold rush" rumor during the
  UN's own heavy-handed stretch — with Scottish and Irish settlers
  giving the whole culture its vocabulary, the Stanitsa's Russian/
  Cossack contingent converging into the same structure, and Bible
  Belt American and South American religious threads folded in
  without their own Combine yet.

## Beyond Saturn

- **`lassell-relay.md`** — deliberately the only post-Saturn location
  in the corpus: a single tiny OPRA relay/research outpost at Triton,
  not the seed of an outer-system region. Takes the network-drift
  themes already running through `os-lineages.md` and `psyche.md` to
  their physical limit — a four-hour one-way light-lag that forces a
  *deliberately approved* long-lived-trust exception, instead of an
  accidental one.

## Jupiter

- **`peale-extraction.md`** — the Jovian-moons pass's first entry:
  the Peale Remote Extraction Platform ("PREP"), an active,
  profitable sulfur/SO2 extraction operation at Io, deliberately not
  a refinery and deliberately not abandoned. Real tidal-heating
  volcanism, zero permanent human presence (Jupiter's
  radiation is lethal, not just inconvenient), fully robotic and
  teleoperated from Ganymede in near-real-time.
- **`europa.md`** — the pass's second entry: a genuine science-versus-
  industry standoff, not just another resource site. The Europa
  Protocol (a free structural borrowing of the real Antarctic Treaty
  System) protects the real subsurface-ocean evidence and Conamara
  Chaos specifically, while licensing ice harvesting elsewhere —
  because Europa's water is also a massive deuterium source. Kivelson
  Station does the ocean science and doubles, uneasily, as the only
  real check on the harvesters.
- **`callisto.md`** — the pass's third entry, and a deliberate
  inversion of the first two: not a resource site, but the one safe
  place in the whole Jupiter system, which makes safety itself the
  scarce thing people fight over. Home to the Jovian Development
  Company (a free structural borrowing of the real East India
  Company — chartered monopoly, eroding authority, gridiron flag and
  all) and its own bureaucracy, the free-trade Jovian Trade
  Association, Jovian Traffic Control, the Jovian Sentinel Survey
  (debris tracking, named in spirit for the real Shoemaker-Levy 9
  impact), the Jovian Exposure Registry (radiation-dose certification
  with real quiet power over who keeps working), and — tellingly —
  the Europa Allocation Council's actual meeting chamber, and the
  Emporium Zone — a chartered Free Trade Zone the JDC built as a new
  revenue stream once its commercial monopoly broke, whose licensed
  entertainment core ("the Strip") is a direct, deliberate echo of
  Macau and Shanghai's old International Settlement. The
  Callisto Home Rule League's push for self-governance has split a
  maximalist pan-Jovian wing (the United Moons) away from it, which is
  in turn pushing Earth, Mars, and the Belt toward their own
  negotiated partition (the ironically-named Concord Settlement) —
  three real, mutually exclusive outcomes left deliberately open as
  this pass's biggest live political thread, none of which actually
  consults the irregular-moon clans who hold real leverage of their
  own through Four Moons Hospitality.
- **`jovian-irregular-moons.md`** — the pass's fourth entry, and
  deliberately light-touch: the four real debris families beyond the
  Galileans (Himalia, Ananke, Carme, Pasiphae), treated as Jupiter's
  own mini-belts — genuinely clustered, unlike the real Belt's
  isolation, functionally ungoverned rather than formally free, clan-
  run rather than corporate-run, and a natural landing spot for VPH's
  and Psyche's Belt diaspora. A small inter-clan foundry at Himalia
  handles intramoon logistics. Also covers the real inner ring-moons
  (Metis, Adrastea, Amalthea, Thebe) as a genuinely distinct, even
  more hazardous second tier — not worth exploiting, not developed.

## Shared/cross-cutting

- **`relay-outposts.md`** — a reusable template, not a location: how
  and when a bare relay installation (RFC-2353's own hop-point
  infrastructure) organically grows into something resembling a
  town, with four tiers from pure hardware up to genuine settlement
  and the technical-core/social-periphery split that lets any future
  instance vary without redoing the underlying pattern. Resolves the
  long-flagged "relay-town archetype" thread below.
- **`people-pass-queue.md`** — a running list of every unnamed role
  or figure the corpus has flagged as needing a name once the
  deferred people pass actually starts. Add to it as new ones come
  up; don't let a named-figure gap live only in a single file's own
  open threads.
- **`flashpoints.md`** — a running list of every live, standing
  tension loaded enough to actually erupt, not just an undecided
  detail. Swept corpus-wide 2026-11-24: three in the Jovian system
  (the sovereignty crisis, Ganymede's three-way friction, Europa's
  quota fight), three on Mars (Elysium's devolution friction, the
  Martian Congress's malapportionment crisis, the Mariner Valley
  Caucus/Elysium rivalry), five in the Belt (the OSL/ASA split,
  Vesta's worker councils, Ceres's Oduya-vs-Piast rivalry, Psyche's
  live ASA asset, Thisbe's unfinished fallout), plus the New
  International vs. the UN, the Rockline Compact's suspicion of the
  Trust, and Lunar resource depletion as a newly-identified root
  cause tying several of the others together. Add to it the same way
  as the people-pass queue.
- **`equipment-codex.md`** — a growing reference for established
  technology that doesn't belong to one location file. First entry:
  the Loadframe, a gravity-compensation exoskeleton — active force
  synthesis to walk normally in low gravity (a real power-budget
  problem), structural load redirection for relief in high gravity (a
  real structural-engineering problem, mechanically easier), and a
  genuine medical necessity for anyone long-adapted to low gravity
  visiting somewhere like Earth.
- **`ship-class-codex.md`** — the same idea for named ship classes.
  Mars's Ballista-class precision-bombardment ships, alongside the
  UN's own deliberate, logged absence of an equivalent — refining a
  kinetic deterrent into an actual weapon system would undercut the
  "unthinkable last resort" logic it depends on. Now also: the
  Zephyr-class, Perihelion Traders' sail-assisted fusion haulers for
  the Mercury Run, crewed by the Sunbirds (`mercury.md`).

- **`ganymede-condominium.md`** — the one place Earth, Mars, and the
  Belt all hold a real stake: orbital infrastructure, joint defense,
  research IP, and the Belt's informal technical backdoor into it.
  Now substantially deepened to match Mercury/Venus/Saturn's own
  rigor: real grounding (the largest moon in the solar system, the
  only one with its own magnetic field — a partial, not total,
  radiation shield — strong subsurface-ocean evidence, the real
  Laplace 1:2:4 resonance with Europa and Io, ESA's real JUICE mission
  as the present-day anchor); a real settlement history as Jupiter's
  gateway moon (~2180–2200, the magnetosphere mattering because
  reliable active rad-shielding didn't exist yet), first tunnels dug
  with pirated Terebra tunnel-boring tech (an embezzling researcher,
  unnamed), then **Heinlein Dome** — a direct tribute, and the
  settlement's own named anchor point — followed by a plain
  bureaucratic numbering grid (Ag Dome [Quadrant]-[Ring]-[Number]) as
  domes proliferated past any reasonable naming budget; a real power
  mechanism (electrodynamic tether satellites tapping Ganymede's own
  field, beaming power down by microwave, both real studied concepts
  stacked rather than invented); a UN-funded exobiology program as this
  corpus's fourth running unresolved-biosignature candidate; and a real
  native-water drilling project, finally viable, running into a
  legitimate-sounding Europa-precedent objection that doubles as cover
  for a quiet Saturnite influence campaign protecting Saturn's own
  water-export economy — the same economy Ganymede's own agricultural
  growth created in the first place (`frontier-timeline.md`). Also now
  a real Jupiter/Saturn cold war with an actual ~19.86-year tempo (the
  real Great Conjunction's synodic period), mutual Border-Reivers-style
  raiding during cheap-transit windows (two-register slang: "the
  Reivers" for anyone sounding historically literate, "Ring Rats" as
  the actual everyday slur), and real interdependency (Jupiter's water
  needs, Saturn's market needs) keeping it cold rather than hot. Also
  now: the Condominium's own real founding, dated ~2270 rather than to
  Ganymede's own settlement — Mars's new sovereignty creating the
  diplomatic room, a major orbital-expansion phase's sheer cost
  creating the practical pressure, both converging almost by accident,
  with the actual joint-venture architect plausibly dead by now and
  due a posthumous honor rather than a hand-waved centenarian cameo; a
  genuinely tamer population by deliberate UN/MDR institutional
  selection, "the chillest of the chillest" of the Belt's own already-
  diverse population, with a mellow sideline in normalized marijuana
  cultivation and a distilling/winemaking culture reflecting that same
  mix (an India-diaspora whiskey informally branded Heinlein Reserve,
  a scatter of other Belt-coded distillers, and one numbered Ag Dome
  that's earned the actual nickname "the Vineyard"); a second medical
  pillar built on genuinely triple-layered radiation shielding — Muller
  Center (named for the real Nobel laureate behind the actual science
  of radiation-induced mutation) anchoring Ganymede as the safest place
  in the outer system to gestate a child, and Ganymede's own ~0.146g
  as the gentlest rung of a real system-wide gravity-rehab ladder
  (Ganymede, Mars, Venus, Earth) rather than Venus's own isolated
  niche, giving Ganymede a second, distinct senior-housing market
  (`venus.md`); Greenhollow's own physical footprint fleshed out (a
  half-buried pyramid HQ, Palisade Security, its own private satellite
  dome network and tunnels); a gentle exoagritourism niche; and the
  single sharpest everyday local grievance — the best food getting
  licensed away to off-world buyers rather than reaching Ganymede's own
  table — alongside loyal, Proportionality-Caucus-shaped political
  opposition rather than anything separatist.
- **`corporations.md`** — the full corporate landscape: 39 sectors,
  ~50+ companies, the Sol Industrial Trust, the Rockline Compact, the
  passive giants (Bedrock/Longview), credit raters, hidden ownership,
  Doris (the flag-of-convenience jurisdiction), hospitality &
  entertainment (Callisto's Emporium Zone casino operators), and —
  newest — textiles & advanced fabrics: Verdant Loom (Ganymede,
  grown out of its agricultural program, genuinely better space-
  relevant tech) versus Albion Weave (Earth, old Atlantic Zone
  capital winning on market power rather than product). Also now:
  Perihelion Traders, the Mercury Run's own Earthstock-exclusive
  merchant house (`mercury.md`, `ship-class-codex.md`). Also now:
  Korolev Propulsion and Vernadsky Systems (Earth orbit, the actual
  historical origin of fusion-torch propulsion and closed-loop life
  support, both carrying real, old Hauptmann & Voskuijlen equity —
  H&V's oldest hidden-ownership tendril, predating Doris, Piast's
  leverage, the Frontier Opportunity Program, Venus's bank, and Nova
  Court combined) and Terebra Subsurface (Mars, tunnel-boring, built
  Mercury's Deep Ring, pirated to dig Ganymede's own first tunnels, and
  now drilling for Ganymede's native water table too —
  `frontier-timeline.md`, `ganymede-condominium.md`). Also now:
  Driftwood Salvage & Reclamation is the receiving end of Earth's own
  Equatorial Bulk Export Program, "the Trash Train"
  (`earth-resources-and-pressures.md`).

## Open threads worth knowing about before adding more

- Interlocking directorates (`corporations.md`) are unblocked now
  that `demographics.md` exists, but not yet built.
- Resolved: the relay-town archetype (maintenance crews → bar →
  organic settlement, tied to RFC-2353's own hop-count mechanics) now
  has a proper writeup, `relay-outposts.md`.
- Black sites (R&D, surveillance, prison, weapons placement, across
  Mariner Valley, Elysium, and Earth) remain a flagged future pass.
- An outer-system pass (Hidalgo, Adonis, Amor, the Jupiter Trojans/
  Greeks, the Hilda group — `asteroid-bases.md`'s own open threads)
  is flagged: small independent mining operations plus minor
  "traveler's inn" waypoint stations at each region's entry point,
  not yet built.
