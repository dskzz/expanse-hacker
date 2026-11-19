# RFC-2307 — RF Propagation Subprofile

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is radio's version of RFC-2306 — the rulebook for how RF links
behave, except radio is far more forgiving of pointing error than a
laser, so the document's obsession is almost entirely about *honesty
and discipline*, not physics.

The big pieces:

- **Canonical channel profiles.** A channel declares upfront what kind
  it is — a plain default band, a scheduled reservation, a frequency-
  hopping/low-intercept mode, or a known high-interference environment
  — and, as of the most recent revision, whether it's carried on a
  *directional* antenna (a dish or phased array) that needs its own
  pointing data, same as a laser link would.
- **Interference is normal, not mysterious.** The document defines six
  measurable interference classes and insists that "RF seems weird
  today" is never an acceptable diagnosis — everything has a
  measurable cause.
- **Everything needs a provenance chain.** Every beacon, channel
  record, and diagnostic has to carry a verifiable signed origin.
  Nothing is trusted just because it showed up on the right frequency.
- **Scheduled bands are a hard contract.** If you reserved a window,
  you transmit in that window — not "approximately," not "just one
  more packet."
- **Operators are treated as the main risk.** This document is
  unusually blunt about it: its own acknowledgments section explicitly
  thanks people for *preventing* human improvisation, not for
  contributing ideas.

## Where to look for exploits

- **Spoofing a beacon well enough to pass casual inspection.** A fake
  beacon with correct-looking timing but a broken or missing provenance
  chain, or a mismatched profile ID, is supposed to be rejected
  outright — but only by a system that's actually checking those fields
  carefully. One that isn't will accept it as genuine.
- **Desynchronizing a frequency-hopping link on purpose.** Deliberately
  inducing drift in dwell time or hop timing can knock a hopping link
  out of sync — the real tell for a victim trying to diagnose it is
  that the drift shows up as a measurable, classified condition, not an
  unexplained glitch, if anyone bothers to check.
- **Transmitting just outside a reservation window and hoping nobody
  notices.** Scheduled-band enforcement is supposed to be absolute —
  "just one more packet" is explicitly called out as the excuse that's
  caused real historical network-wide meltdowns in-universe. A system
  that's even slightly lenient about window boundaries is exploitable
  exactly the way that history already played out.
- **A directional channel claiming it doesn't need pointing data.**
  Since the latest revision, a dish/phased-array channel is supposed to
  declare itself directional and carry alignment data accordingly. A
  channel that's actually directional but never makes that declaration
  skips the pointing-accountability requirements entirely — it's lying
  about its own physical shape to dodge scrutiny.
- **Social-engineering an operator into a manual override.** The
  single most emphasized vulnerability in the whole document isn't
  technical at all — it's convincing a human operator that "just this
  once" bumping the power or fudging the timing will fix a problem.
  Every historical disaster case study in the document traces back to
  exactly this.
- **Smuggling something through the private-use identifier range.**
  Vendor private-use values are supposed to stay strictly local and
  never appear in anything that actually propagates (beacons, shared
  channel records, hints). Something that *is* propagating through that
  "quarantined" range is either a bug or someone deliberately hiding
  traffic in a space nobody's supposed to be watching.

## What's deliberately out of scope here

The actual pointing/tracking mechanics a directional RF channel now
depends on are RFC-2304's job, not this document's — RF just consumes
them the same way the laser profile (RFC-2306) always has.
