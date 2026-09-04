# The Corporate Landscape

Status: worldbuilding, drafted 2026-09-04 in response to a direct
note: the "Corporate leased-compute fork" lineage in
[`os-lineages.md`](os-lineages.md) had only one populated example
(Mao-Kwikowski, established vault canon) and read as a monolith. It
shouldn't. This doc gives it four more named players, each grounded in
an RFC or design thread already in the vault/repo rather than invented
from nothing, so "Corporate" reads as a shared archetype — proprietary,
phone-home, subscription-gated trust — that several competing
companies instantiate differently, the same way Scrapshell is a
vernacular, not one implementation.

Mao-Kwikowski stays the dominant, most deeply embedded player (see
`docs/vault/Notes/solnet background.md` for existing canon: they
contributed heavily to the SolNet standards effort, are positioned to
understand the system better than almost anyone, and are — per that
material — not yet feared, which is itself foreshadowing). The four
below aren't competing for that same role; each occupies a niche
Mao-Kwikowski doesn't.

## Voss-Achebe Relay Systems (VARS)

**Sells:** physical hardware — antennas, tightbeam terminals, relay
buffers. Not infrastructure or software; the actual boxes.

**How they make money:** components ship sealed and unauditable,
throttled below their real rated capability unless a subscription is
current. A VARS-MK2 buffer's hardware genuinely supports RFC-2305's
full rated duty cycle; the firmware caps it lower unless
`subscription_current` checks out against a reachable licensing
server. See `db/components/vars-buffer-mk2.json` and
`db/hardware/relay-courier-rig-class-c.json` for the concrete content
this produces — a real, playable instance of exactly this mechanic.

**Vibe:** unglamorous, everywhere, the utility company nobody likes
but everyone's hardware is stamped with. Not sinister so much as
extractive in the ordinary, exhausting way real hardware vendors
already are.

**Gameplay hook:** "degrading" a VARS component — reflashing it past
its subscription lock — is common enough Belt-wide to be an actual
verb (see `os-lineages.md` §5's `/dev` entry). It's not a scan-and-
exploit action: it requires physical access and enough of RFC-2301's
key-hierarchy knowledge to feed the firmware an update it'll accept as
signed. A player who understands VARS's update process can do this
deliberately; a technician who did it out of necessity years ago and
never mentioned it is a different, quieter kind of story hook.

## Trellis Underwriting Group

**Sells:** "conformance bonds" — insurance that pays out if a
counterparty's node turns out non-conformant or actively malicious.

**How they make money:** actuarial risk-pricing on node behavior they
have no formal standing to score. SolNet's own doctrine (`TODOv2.md`'s
CHANGES section) is explicit: *"conformance is inferred, not reported...
self-reported state is advisory and unreliable."* Trellis's entire
business is a reputation-score system smuggled in through insurance
premiums instead of protocol fields — technically outside SolNet's
trust model entirely, practically load-bearing because nobody wants to
eat an uninsured loss.

**Vibe:** actuarial, smug, litigious, extremely good at sounding
reasonable. SSWG-purist types (see `Notes/voices/voice_profiles/
SSWG- Solnet working group.md`) treat them as a live doctrinal threat,
not just a business they dislike.

**Gameplay hook:** a node's Trellis conformance-bond status and its
actual measured protocol behavior can disagree — a bonded node that's
quietly non-conformant, or an uninsured node that's actually fine. The
puzzle isn't breaking Trellis's model, it's noticing the two records
don't match and figuring out which one is lying, and why someone would
want them to disagree.

## Tanager Freight & Custody

**Sells:** physical courier transport — the literal ship-based
store-and-forward RFC-2305 §9 already gestures at ("couriers that
physically transport powered storage or scheduled transmit windows").

**How they make money:** custody-chain paperwork for bundles too
large, sensitive, or urgent for RF/tightbeam. They run their own
physical manifest system parallel to the electronic ledger
(`RFC-2302`/`2302A`) — and the two don't always reconcile cleanly.

**Vibe:** blue-collar, freight-dock energy, ship culture. "If RF can't
be trusted, we carry it by hand" as an actual competitive pitch against
electronic relay operators, not a fallback of last resort.

**Gameplay hook:** manifest fraud and forged custody chains are a
genuinely distinct exploit surface from anything electronic — a
puzzle about physical chain-of-custody (who actually had hands on this
crate, when) layered on top of, and sometimes in conflict with, the
electronic provenance model everything else in the corpus assumes.

## Ondine Personal Systems

**Sells:** wrist terminals and personal comms — the consumer end of
RFC-2395 (Personal Device Integration).

**How they make money:** walled-garden lock-in, funded by telemetry
that sits right at the edge of what RFC-2308's minimization doctrine
tolerates. Everyone has one. Everyone complains about it. Nobody
switches, because switching means losing every contact, every cached
session, every piece of accumulated convenience.

**Vibe:** consumer-tech-company energy transplanted onto a Belt/inner-
system personal-device market — friendly branding over an extractive
default. The one corp here whose target is individuals, not
infrastructure.

**Gameplay hook:** gives SPERB (`Notes/voices/voice_profiles/SPERB -
SolNet Privacy & Exposure Review Board.md`, already a vault voice) a
permanent, specific, named adversary instead of an abstract "privacy
is bad" antagonist. Attack surface is the personal/PNI layer — a
different texture from anything infrastructure-side.

## Where this leaves Mao-Kwikowski

Still the biggest, still the most embedded, still the one with the
scale to actually matter system-wide the way existing vault canon
already establishes. The four above don't compete with that role —
they're what "not the only game in town" actually looks like:
Mao-Kwikowski is the company everyone assumes is watching; VARS is the
one whose hardware you can't avoid; Trellis is the one whose paperwork
you can't avoid; Tanager is the one you call when you don't trust the
wire; Ondine is the one in every technician's pocket whether they like
it or not. Different pressure, different niche, same underlying
"Corporate leased-compute" archetype from `os-lineages.md` §2–3.

## Open threads

- None of these have been checked against the vault for name
  collisions with anything Sid or the user has already drafted — worth
  a look before treating them as locked.
- Whether any of these should get their own root-model variant (a
  Trellis-flavored trust quirk distinct from generic "Corporate," for
  instance) or whether they all share the exact same leased-entitlement
  mechanic from `os-lineages.md` §3 is undecided.
- `db/components/vars-buffer-mk2.json` is the only one of these with
  actual converted content behind it so far; Trellis/Tanager/Ondine are
  lore only until something in `db/` models them.
