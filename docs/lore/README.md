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
  Slavic, Chinese, Indian, Dutch/Germanic, French).

## Mars

- **`mars-political-structure.md`** — MDR/MRN, the Commonwealth of
  Elysium (Datong as its capital, its 13th Consular seat, its
  authoritarian-corporatist evolution), the Mariner Valley Caucus,
  Mars's own helium-3 independence via Phobos/Deimos, and Admiralty
  House — the MRN's real command center, deliberately kept mobile
  and off any fixed body (real kinetic-bombardment logic), its exact
  host ship rotated and treated as classified rather than published
  through the usual LocationChain honesty this corpus otherwise
  holds to everywhere else.
- **`mariner-valley.md`** — the capital itself: founding history (a
  dozen underground starter colonies), capability-is-authority, the
  Presidency, the Martian Congress's malapportionment problem, and
  the Consular College.

## The Belt

- **`belt-political-structure.md`** — OSL/ASA and the shared
  Anti-Solar Accord they both claim to descend from.
- **`belter-pidgin.md`** — Rock Talk/Kamenya, the original
  constructed pidgin replacing Lang Belta. (The `Lang Belta
  2022-02-15.pdf` in this same folder is old external reference
  material, not canonical — superseded by this file.)
- **`ceres.md`** — the Belt's biggest hub: the UN's MFN trade
  framework, Hetman Stanislav Piast, the Consular-College-style
  Magnate class, and Imara Oduya's opposition.
- **`thisbe-station.md`** — the founding-trauma site: the real
  asteroid, the workers' cooperative, the space-Cuba diplomatic
  stalemate, and the live, unresolved helium-3 crisis.
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
  so far — brutal thermal cycling, not radiation or light-lag.
- **`venus.md`** — Landis Habitat(s) - Venus: real floating aerostat cities
  in the one altitude band where Venus's atmosphere is nearly Earth-
  like, using ordinary breathable air as the lifting gas. The one
  genuinely pleasant place in the whole corpus — atmospheric/
  biosignature research (the real, still-disputed phosphine question)
  alongside a luxury wellness destination, with altitude-keeping as
  the actual hazard instead of survival.

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
  way everything else here is. Still explicitly a work in progress.
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
  against expanding Thisbe Station's helium-3 discovery.
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
  by Pakistan's own neutral position).
- **`armstrong-city.md`** — Armstrong City and Shackleton Base: the
  DC/Congress governance model, the UN's two-tier geography
  (prestige on Earth, bureaucracy on Luna), and the corporate HQ tax
  incentive.

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
  First entry: Mars's Ballista-class precision-bombardment ships,
  alongside the UN's own deliberate, logged absence of an equivalent
  — refining a kinetic deterrent into an actual weapon system would
  undercut the "unthinkable last resort" logic it depends on.

- **`ganymede-condominium.md`** — the one place Earth, Mars, and the
  Belt all hold a real stake: orbital infrastructure, joint defense,
  research IP, and the Belt's informal technical backdoor into it.
  Its universities also fund a long-term, currently-impractical
  research line into mining helium-3 straight from Jupiter's
  atmosphere — motivated directly by Lunar resource depletion
  (`flashpoints.md`), the one reservoir big enough to actually solve
  that crisis, decades before the energy economics might ever work.
- **`corporations.md`** — the full corporate landscape: 38 sectors,
  ~50 companies, the Sol Industrial Trust, the Rockline Compact, the
  passive giants (Bedrock/Longview), credit raters, hidden ownership,
  Doris (the flag-of-convenience jurisdiction), and — newest —
  hospitality & entertainment, Callisto's Emporium Zone casino
  operators.

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
