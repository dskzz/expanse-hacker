# RFC-2352 — L1 Privacy and Metadata Minimization

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the "every device emits the same boring signal, on purpose"
rule. The whole idea: if every device looks physically identical at the
radio/optical layer — same timing, same modulation, same everything —
then nobody can fingerprint, track, or profile a device just from
watching its transmissions. The document (itself notoriously dense and
front-matter-confused in places — a known, tracked quirk, not something
you need to untangle to use it) is absolute about this: metadata not
strictly required for delivery doesn't get sent, full stop, no
exceptions for convenience or performance.

The practical shape of it: every device wraps its emissions in a
**privacy envelope** — a canonical, standardized signature that's
supposed to make it indistinguishable from every other compliant
device. Suppression, not disclosure, is the default state.

## Where to look for exploits

- **The envelope slowly drifting off its canonical shape.** A privacy
  envelope that's supposed to look identical to every other one can
  drift — slightly, over time — in ways that leak vendor, batch, or
  environmental hints. Spotting a drift signature is how you tell two
  "identical" devices apart when you're not supposed to be able to.
- **Suppressed fields reappearing under load.** The envelope is
  supposed to hide things like queue depth and relay load at all
  times — but under stress, some of that suppressed metadata can
  reappear. Pushing a device toward its breaking point is a legitimate
  way to get it to say more than it means to.
- **Two envelopes colliding in a predictable way.** Devices that are
  supposed to be completely unlinkable from each other can end up
  generating envelopes that correlate in a detectable pattern — proving
  two "anonymous" signals actually came from related devices.
- **A relay that forgot to strip metadata before forwarding.**
  Minimization is supposed to happen at every hop. A relay that fails
  to actually strip what it's supposed to strip lets you partially
  reconstruct a message's path, hop by hop.
- **A device that remembers something it's not supposed to.** Last
  hop, local environment, calibration history — a device that retains
  any of this longer than it should is leaking "ghost metadata" about
  its own past behavior, even while behaving perfectly normally right
  now.
- **A predictable randomization seed.** The whole privacy envelope
  depends on genuinely unpredictable randomization. If the seed itself
  turns out to be predictable, you can deanonymize an entire cluster of
  devices that thought they were independently random.
- **Talking your way past the privacy envelope entirely.** This is the
  biggest category in the whole document, and it's not technical at
  all: convincing an operator (or a device's own maintenance logic)
  that this is a real audit, a calibration check, an emergency, or
  vendor support reaching out — any of which can get minimization
  relaxed "temporarily," voluntarily, with nobody needing to break
  anything. A fake compliance-audit prompt that scares a device into
  "proving" it's compliant by exposing exactly the metadata it's
  supposed to protect is the single most elegant version of this.

## What's deliberately out of scope here

This document only governs what gets *emitted* — it doesn't define how
a relay decides who's allowed to ask for more than the minimized
default (that's RFC-2308's territory) or how trust gets established in
the first place (RFC-2362). A social-engineering exploit that gets
someone to relax their envelope is a privacy failure here; whether the
person asking should have been trusted at all is a different document's
question.
