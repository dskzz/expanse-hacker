# RFC-2309 — L0 Test and Validation Suite

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This isn't a protocol — it's the *certification exam* every physical-
layer implementation has to pass before anyone trusts it. It defines:

- **A scenario catalog** — a big, numbered library of test conditions a
  device gets run through (normal operation, controlled interference,
  structured chaos injection, thermal drift, and more), each with an
  ID like `SC-1204` or `SC-3301`.
- **An error-code registry**, cleanly banded by what kind of problem it
  is — timing issues in the 1000s, state-machine problems in the
  2000s, environmental reporting in the 3000s, interference/occlusion
  in the 4000s, logging/forensic failures in the 5000s, and — notably —
  **security-relevant codes in the 6000s**, things like "unauthorized
  emission detected" or "log integrity failure."
- **A five-state recovery machine**: a device that hits trouble goes
  `nominal → degraded → fallback → recovering → nominal`, with a
  separate `initializing` state for startup. There's a defined path
  back to normal — devices aren't supposed to get stuck anywhere.
- **Certification levels.** Passing the catalog is what earns a device
  the right to call itself compliant at all.

## Where to look for exploits

- **Building something that passes the exam without actually being
  reliable.** The entire scenario catalog is public and numbered. A
  device that's specifically engineered to handle exactly `SC-0100`,
  `SC-1204`, `SC-2407`, and nothing else can pass certification clean
  while still failing in any real condition the catalog didn't happen
  to test. Certification proves "survives the known list," not "is
  actually trustworthy."
- **Hiding real traffic inside what looks like routine testing.** Since
  the test scenarios are well-known and expected to appear during
  validation, something that mimics the *shape* of a known synthetic
  test scenario can blend into noise that nobody double-checks —
  because it looks like the system doing exactly what it's supposed to.
- **Getting a device stuck mid-recovery.** The fallback/recovery cycle
  is supposed to always lead back to nominal. A device that can be
  repeatedly re-triggered into `degraded` right as it's about to
  recover never actually gets back to normal operation — a real,
  nameable denial-of-service shape, not a crash, just permanent limping.
- **Tampering with the evidence instead of the system.** The error-code
  registry has a whole named category for exactly this — "Log Integrity
  Failure" is a real, anticipated error code, meaning the system
  already expects someone might go after the *logs* instead of the
  live behavior. If you can't fake the behavior, fake (or quietly
  break) the record of it.
- **An "unauthorized emission" that nobody flags as such.** The
  registry has a dedicated code for a device transmitting when it
  shouldn't — which means the real question for an investigator isn't
  "did this happen," it's "did the device that should have logged
  `EC-6005` actually log it, or did someone suppress that too."

## What's deliberately out of scope here

This document doesn't define the protocols being tested — it's a
lookup/reference tool for *validating* RFC-2303, RFC-2306, RFC-2307,
and the rest. Treat its scenario and error-code catalogs as useful raw
material for building real in-fiction failure-mode content, not as a
system with its own live network attack surface.
