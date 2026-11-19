# RFC-2363 — Directory and Routing Endpoints (DRE)

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

A "DRE" is a bulletin board, not a phone book. Any device — a relay, a
station's traffic computer, a ship's comms rig — can post notices on it:
"here's how to reach us," "here's who's currently captain," "here's
roughly where we are." Nobody guarantees the board is current, complete,
or even honest. You read it, you weigh it against anything you can check
directly, and you move on.

Three things get posted there:

- **A DRE's own "about me" card** — who it speaks for, and optionally a
  little lookup table mapping roles ("captain," "duty-tech") to whoever
  currently holds that job. This is what lets you address a message to
  "whoever's captain" without knowing a name.
- **Proof of where an address came from** — who says this address is
  legitimate, and on what basis.
- **A domain's public privacy promise** — how much it guarantees it will
  and won't expose about you before you even talk to it.

None of this spreads like a phone-book update pushed from head office.
It spreads like gossip — whenever two of these boards happen to have a
link, they trade whatever they've got. No schedule, no guarantee it
arrives, no guarantee it's current.

The one new wrinkle: every notice a domain posts carries a number that
only ever goes up, each one cryptographically chained to the one before
it. That's what stops someone from digging up an old-but-genuine notice
and passing it off as current — you can tell it's behind just by the
number, without trusting whoever handed it to you.

## Where to look for exploits

- **The "about me" card can lie about who's in charge, and it takes days
  to notice.** A role table ("captain," "duty-tech") is only as current
  as the last time someone updated it and someone else copied it. A
  forged or just-plain-stale entry sends people to the wrong person for
  as long as it takes someone physically present to actually ask.
- **Contact info leaking real names and departments.** A station is
  supposed to publish an anonymous, session-only way to reach it — not
  its actual internal org chart. A lazily-configured one leaks exactly
  that, and it looks perfectly normal until someone cross-references it.
  This is a real, boring, forty-one-relays-before-anyone-noticed kind of
  mistake, not a clever hack.
- **Two boards disagreeing, and nobody resolving it the way you'd
  expect.** If two sources contradict each other, the system is
  *supposed* to show you both and let you decide — it should never
  silently pick a winner. A system that picks one anyway, especially
  consistently favoring one faction's relays, is itself the exploit.
- **"This notice doesn't exist here" being mistaken for "this notice was
  revoked."** It isn't the same thing — absence usually just means that
  board hasn't heard about it yet. Anyone who panics (or acts) on
  absence-as-revocation can be baited into reacting to nothing.
- **Replaying an old-but-genuine notice to make stale information look
  current.** This is the attack the new numbering scheme exists to shut
  down — but only once everyone actually implements the check. A system
  that accepts the record without comparing the number against the last
  one it saw is still vulnerable, chain or no chain.
- **Loop-counting is honor-system, not proof.** The hop-count that
  prevents a notice from circulating forever is just a number a relay
  can lie about. It can't forge a notice or fake its age, but a relay
  lying about hop count can make a flood of junk circulate longer than
  it should — a nuisance/DoS angle, not an authenticity break.

## What's deliberately out of scope here

This document doesn't decide whether a requester is *trusted* (that's
RFC-2362) or how *much* of a record they're actually shown (that's
RFC-2308). An exploit that depends on either of those being broken
belongs in their plain-language write-ups, not this one.
