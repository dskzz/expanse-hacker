# RFC-2300 — SolNet Terminology & Concepts

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the dictionary everything else in the corpus assumes you've
already read. It doesn't define any one feature — it defines the words
and layers every other RFC builds on top of.

The big ideas:

- **UUID-S7** — everyone and everything gets one opaque, permanent ID
  that reveals nothing about who you are, where you are, or what
  authority you answer to. It's just a name, deliberately boring.
- **Two address halves** — where something *is* (LocationChain) and what
  it's *for* (ServiceChain), kept strictly separate so knowing a
  service's name never leaks where it physically lives.
- **A five-layer stack for "can I even reach you and should I trust
  you"** — going from raw physical signal, up through "who are you
  really," "where can I find you," "how does my message actually get
  there," to "do I trust your side of this conversation at all." Each
  layer only answers its own question and doesn't peek at the others.
- **A separate, local-only stack for "what can I do once I'm already
  talking to you"** — session handling, local service lookup, local
  permissions — deliberately insulated so your local systems keep
  working even when the wider network is having a bad day.
- **Session Keys** — short-lived, disposable proof that *this specific
  conversation, right now* is legitimate, separate from your permanent
  identity.

The document's one running theme: sources disagree, go stale, and are
sometimes wrong, and the correct response is always to admit that and
widen your error bars — never to quietly trust the most recent or most
official-sounding answer.

## Where to look for exploits

The specific exploits below come from this corpus's proximity/courier
file-transfer subsystem, one of the concrete systems built on top of
RFC-2300's foundations:

- **A fake "I'm nearby and trusted" signal.** A console can be spoofed
  into looking like a trusted, physically-close device. The tell is
  usually in the fine print — a confidence score that doesn't quite
  match the claim, or an audit trail that should exist and doesn't.
- **A relay claiming it delivered something it wasn't actually
  authorized to carry.** It can get away with this right up until
  someone traces the actual paper trail (delegation receipts, ledger
  anchors) and shows the relay's authorization never covered that
  transfer.
- **"Did this file actually arrive?" being genuinely unanswerable from
  the records alone.** A transfer can leave a trail that *looks*
  complete but never produces the final receipt — meaning a clever
  operator can plausibly claim either outcome, and only physical/network
  trace evidence settles it.
- **Faking "we're physically close enough to trust this."** Proximity
  proof is built from several independent physical signals (signal
  strength, time-of-flight, an ultrasonic handshake) specifically
  because any *one* of them alone is fakeable — the exploit is finding
  a device credulous enough to accept fewer than it should.

## What's deliberately out of scope here

RFC-2300 itself doesn't contain exploits in the normal sense — it's
definitions, not a protocol with attack surface. The exploits above
belong to the specific systems (proximity transfer, courier custody)
built on top of it; treat this page as the dictionary you'll need
before reading those systems' own plain-language write-ups.
