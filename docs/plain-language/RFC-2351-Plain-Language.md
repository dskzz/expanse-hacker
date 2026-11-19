# RFC-2351 — L1 Frame Format (A/N Header Split)

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This defines the actual bits-on-the-wire shape of every L1 frame, split
into two halves: an **A-header** (Authority — routing/trust metadata)
and an **N-header** (Namespace — local service/discovery metadata).
Seven core fields live in there: frame type, QoS class, a freshness
tag, a provenance pointer, a TLV container length, the TLV container
itself, and a compact auth tag.

There are three allowed "profiles" a frame can declare — Minimal,
Reduced, or Full — each one requiring or forbidding a specific subset
of fields, with one load-bearing rule: **a higher profile must always
be able to accept a lower-profile frame**, but not the reverse. The
document is also deeply, repeatedly opinionated that L1 should stay
*dumb* on purpose — no reliability guarantees, no ordering, no
fragmentation, no built-in confidentiality — because adding any of
those at this layer breaks the delay-tolerant assumptions everything
above it depends on.

## Where to look for exploits

- **The A-header and N-header disagreeing with each other.** They're
  supposed to describe the same frame consistently. Drifted vendor
  firmware, malformed TLV ordering, or legacy Reduced-Profile behavior
  can make them tell two different stories — and whichever one a given
  relay trusts determines what it actually does with the frame.
- **A duplicate field that two parsers read differently.** Some TLVs
  are allowed to appear in both headers. A vendor that mishandles the
  duplicate can end up with one parser ignoring a field the other one
  honors — meaning the exact same frame means two different things
  depending on which device is reading it.
- **Forcing a node down to Reduced Profile.** Reduced Profile strips
  fields aggressively by design, which also means it skips some of the
  stricter checks Full Profile enforces. A node tricked (or starved)
  into falling back to Reduced Profile is a node running with its guard
  down.
- **A provenance pointer that's optional, missing, or truncated.**
  Legacy nodes don't always handle a missing or partial provenance
  pointer gracefully. Reconstructing — or forging — just enough of one
  can be enough to impersonate a nearby, already-trusted node.
- **A frame that parses differently depending on whose hardware reads
  it.** TLV ordering is supposed to be canonical and strict. A vendor
  that sorts incorrectly creates frames that genuinely mean different
  things on different hardware — which is exactly the kind of ambiguity
  that can hide a channel from one observer while it's plainly visible
  to another.
- **A proprietary vendor field nobody ever properly documented.**
  N-header TLVs are easy for a vendor to overload with their own
  proprietary extensions. Reverse-engineering one of those can unlock a
  maintenance or diagnostic channel that was never meant to be reachable
  from outside.
- **Abusing the rarely-used fallback mode.** Fallback exists for when
  things go wrong, which also means it's the least-tested, least-
  hardened code path in most real implementations. Forcing a device
  into fallback gets you a simpler parser with weaker validation —
  on purpose, for resilience, but that's exactly what makes it useful
  to someone looking for the path of least resistance.
- **The two headers disagreeing about how long the frame even is.**
  If A-header and N-header report different frame lengths, there's
  room to hide data in the padding, or to force a parser into reading
  only part of the frame.

## What's deliberately out of scope here

This document is strictly about the wire format of one frame — it
doesn't define routing, addressing semantics, or anything above L1.
Those headers get interpreted by RFC-2350 (addressing) and everything
built on top of it; this document just defines what's physically in
the envelope.
