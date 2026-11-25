# Relay Outposts: A Reusable Pattern

Status: locked, 2026-11-25. Not a location — a template, the same
kind of reusable reference as the LocationChain convention and the
`[Name] - [Body]` naming rule (`README.md`). Resolves a thread this
lore README has flagged since early in the project: "the relay-town
archetype (maintenance crews → bar → organic settlement, tied to
RFC-2353's own hop-count mechanics) was discussed but never written
up." This is that writeup, built to be instantiated anywhere a small
facility needs one rather than re-derived each time.

## The real mechanic underneath it

RFC-2353's L1 Relay Advertisement Protocol means SolNet needs
physical hop points wherever distance, light-lag, or line-of-sight
breaks a direct connection — the same real principle behind actual
submarine-cable landing stations, radio relay towers, and satellite
ground stations. Most of these points never become more than
hardware: an unmanned repeater, serviced on a maintenance schedule,
nothing resembling a settlement. This template is about the minority
that do.

## Why relay points sometimes grow into towns

A relay station is necessary infrastructure, which means some number
of people have to be near it on a maintenance schedule regardless of
whether anyone ever intends to build a settlement there. Once people
are reliably passing through or stationed nearby, informal services
follow the traffic, not a plan: a place to eat, a place to sleep
between transit windows, basic repairs, eventually small-scale trade.
Nobody founds a relay town on purpose — it accretes, the same real
pattern behind countless actual towns that grew up around railway
junctions, river crossings, mountain passes, and desert caravan
stops. The relay is the reason the location exists; the town, if one
forms at all, is a side effect nobody planned for and nobody owns.

## Four tiers, not a fixed destination

Most relay points stop at tier one. Growing past that takes real,
sustained traffic, not just time:

1. **Pure hardware.** Unmanned repeater equipment, serviced on a
   remote maintenance schedule. The overwhelming majority of relay
   points in the system never become anything else.
2. **Minimal crew.** A small maintenance team living on-site because
   the hardware needs hands-on attention a remote schedule can't
   provide — Lassell Relay's own model (`lassell-relay.md`), where the
   crew exists because of distance and light-lag specifically, not
   because of accumulated traffic.
3. **Organic accretion.** Real, if tiny, services have grown up
   around the relay — a bar, basic resupply, lodging — because enough
   outside traffic reliably passes through or stops there for its own
   unrelated reasons (mining runs, long-haul transit, waiting out a
   window). This is the tier the still-unbuilt outer-system
   "traveler's inn" waypoints (Hidalgo, the Jupiter Trojans/Greeks,
   the Hilda group, `asteroid-bases.md`'s own open threads) are meant
   to land on whenever they actually get built.
4. **Genuine settlement.** The rare exception: traffic stayed heavy
   and steady long enough that what's there now has a real economic
   and political identity of its own, even though its origin was
   nothing but relay infrastructure. Not the default outcome for any
   new relay point — earned, not assumed.

## Two layers, almost always split

The technical core and the social periphery are owned by different
people, and that split is itself worth keeping consistent: OPRA (or
a regional analog, `belt-political-structure.md`) owns and mandates
the relay hardware itself, strictly technical and deliberately
neutral — the same character already established for Lassell. The
informal services that grow up around it (the bar, the resupply shop,
the lodging) are independent, small-scale, and entrepreneurial,
because OPRA's own mandate has no reason to extend to running a bar.
That split is also what gives any future instance of this template
real flexibility: the hardware's character stays consistent system-
wide, while who shows up and sets up shop around it is wherever a
scenario wants it to be.

## The hook this template carries automatically

Any relay point, at any tier, inherits the same mechanically real
texture already built for Lassell: a node this far from the center
of any trust network tends toward long-lived, delegated authority
rather than live verification, simply because live verification
isn't always physically possible. A tier-three or tier-four relay
town, specifically, adds a wrinkle Lassell's own isolation doesn't:
real, mixed outside traffic passing through constantly means more
people touching the local trust fabric, not fewer — a bigger, messier
attack surface than Lassell's small fixed crew, for the opposite
reason.

## Open threads

- No specific instance has actually been built out past this
  template yet — the outer-system "traveler's inn" waypoints remain
  the most obvious next use, whenever that pass happens.
- Whether any tier-three or tier-four relay town has ever had its
  trust fabric actually compromised through its own mixed traffic
  isn't decided — a clean, template-level hook for whichever specific
  instance ends up needing one.
