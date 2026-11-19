# RFC-2353 — L1 Relay Advertisement Protocol

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is how a relay tells the rest of the network "I exist, here's
roughly what I can do" — a small, repeating broadcast, like a
lighthouse blinking on a schedule, not a conversation. The whole design
is built around one rule: a relay is only allowed to say a few coarse,
boxed-in things about itself — capability, rough capacity, rough
admission status, media type — and never anything precise enough to
track, target, or profile it.

The one thing it leaks on purpose: **HopCount** — how many hops away a
message's origin is. That's unavoidable since messages travel relay to
relay, so the rule admits it openly instead of pretending otherwise.
Everything else is deliberately boring: a fixed broadcast schedule that
never speeds up or slows down based on load (because a schedule that
reacts to load becomes a way to spy on load), and a byte-for-byte
identical structure regardless of how busy the relay actually is.

Forgery and tampering (altering a forwarded record) are treated like
fraud — investigated after the fact by an audit board, never blocked
cryptographically, because a verifiable custody chain would itself leak
exactly who was in the path. That's a deliberate tradeoff, and it's
also a real gap.

## Where to look for exploits

- **Mapping territory using only the one sanctioned leak.** HopCount is
  legally public. A patient observer collecting it from many relays
  across a sector can reconstruct a rough distance map without
  breaking a single rule — the one perfectly legal exploit in the whole
  document.
- **Listening to *when* a relay broadcasts, not what it says.** The
  broadcast schedule itself is supposed to never react to load — but a
  relay that jitters early under stress, even by milliseconds, leaks
  its load curve through timing alone, which is exactly the leak the
  fixed-schedule rule exists to prevent.
- **A relay lying about its own capacity class.** Advertising
  theoretical maximum throughput instead of realistic sustained
  capacity is a known, named non-compliant pattern — sessions routed
  there predictably fail, and once you've documented the pattern, you
  have leverage over whoever's running it.
- **Quiet favoritism behind an "open" sign.** A relay can advertise
  itself as open to everyone while quietly favoring specific peers —
  invisible from the outside, provable only by comparing who actually
  gets admitted against who was told "open." The same trick works one
  level up too: compromising a cache node that *looks up* relays can
  make specific relays effectively vanish from search results without
  touching the relays at all.
- **Spoofing or replaying a relay's identity.** A RelayID provides no
  built-in proof of origin — that's explicitly somebody else's job,
  higher up the stack. A system that skips that higher-layer check can
  be handed a spoofed advertisement for a trusted relay and lured
  toward one you actually control.
- **Tampering with HopCount as a forwarded record passes through.**
  Since tampering is only ever caught after the fact by audit, not
  prevented in real time, a forger who moves fast — or whose forged
  hop never gets audited — gets away with it structurally. You can use
  this to hide a relay's existence from part of a sector, or make it
  look reachable from further away than it really is.
- **Abusing the one legitimate excuse for an off-schedule broadcast.**
  A relay rejoining after a network partition, or recovering from a
  physical occlusion, is allowed a single early, off-cycle update.
  Faking that exact scenario lets you slip a status change past the
  fixed-schedule rule without it looking like the timing-leak exploit
  above.
- **Squatting on an unregistered capability bit.** Certain bits in the
  capability mask require formal registration before use. An
  unregistered one is a known, named "interoperability defect awaiting
  discovery" — meaning it's also a cheap, temporary covert channel,
  right up until the registrar notices and shuts it down.
- **Faking a compliance audit to make an operator hand over raw
  numbers.** The audit board's power to permanently revoke a relay's
  certification, with no appeal, is real and frightening enough that a
  fake "compliance inquiry" can talk a nervous operator into disclosing
  exactly the real queue depth, load, and peer list this whole protocol
  was built to keep hidden.

## What's deliberately out of scope here

This protocol only covers what a relay *advertises about itself* — it
doesn't decide who's trusted (RFC-2362), what gets exposed to whom
(RFC-2308), or how an address actually resolves (RFC-2350). It's the
lighthouse's blink, not the harbor's rulebook.
