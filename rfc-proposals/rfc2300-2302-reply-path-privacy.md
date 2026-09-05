# Proposed mechanism: session-scoped return-address correlator

Status: proposed 2026-09-05, Dan's idea. Not confirmed to be missing
from the corpus — RFC-2300 runs to ~2480 lines and this review only
fully covered to roughly line 1810 of it, so there may be existing
text past that point covering this already. Treating this as a
well-motivated extension pending that check, not asserting a gap with
confidence. Targets RFC-2300 §6.1 (Session Keys) and RFC-2302 §7
(Privacy and Data Minimization) — neither file touched; this describes
a proposed addition.

## The problem

A naive outbound transmission's return address carries the sender's
full internal identity verbatim — e.g. `... from DONNAGER//
ENGINEERING:ENG1:REACTOR:TECH-TK421`. That's directly readable by the
destination and anyone relaying the packet, which conflicts with a
principle already on the books: RFC-2300 §7 already says "L1‑L exposure
SHOULD be minimized for personal devices," and RFC-2302 §7 already
asks for "minimal public footprint" and "selective disclosure" on
ledger records. Neither currently extends that instinct to a message's
own reply-path field.

## Why this isn't redundant with UUID-S7

UUID-S7 is already deliberately opaque by design (RFC-2300 §4: "does
not leak location, authority, or operational metadata"), but that's a
narrower guarantee than what's at risk here — an opaque UUID reveals
nothing on its own, but it was never designed to carry a full
organizational path in the first place. A human-legible ServiceChain
like `ENGINEERING:ENG1:REACTOR:TECH-TK421` reveals real internal
structure (department, section, role, person) that UUID-S7 doesn't
even attempt to protect, because it's not the thing UUID-S7 replaces
here. This is a complementary mechanism, not a duplicate.

## Proposed mechanism

The originating domain's own outbound gateway swaps the real
ServiceChain identity for an opaque, session-scoped correlator before
transmission:

```
naive:    to BLACKBEARD//captain  from DONNAGER//ENGINEERING:ENG1:REACTOR:TECH-TK421
private:  to BLACKBEARD//captain  from DONNAGER//7f3a-91c2-...
```

The gateway keeps a local mapping (correlator → real internal
identity), analogous to real NAT connection tracking, or more
precisely to consumer email-alias-relay features (a per-correspondent
alias forwards to the real address; the recipient never learns it).
When a reply arrives addressed to the correlator, the gateway reverses
the mapping and delivers internally. Best-fit existing vocabulary:
RFC-2300 §6.1's **Session Keys** ("answer whether a specific
interaction is current and authorized") — this is a session-scoped
correlator, not a persistent identity, and should not be modeled as a
new record type if Session Keys already cover the shape.

## The vulnerability this creates — a genuinely different shape than every other one found this project

Every other honest vulnerability found in this design work so far
(duty-reservation's `HANDWAVE_TX`, Scrapshell's solo-claim fallback,
the biometric-degraded-auth fallback discussed separately) is a
**deliberate, documented spec tradeoff** for a legitimate edge case —
the spec is honest that the fallback is weaker, on purpose. This one is
a **misconfiguration/deployment-negligence** class instead: the
mechanism is specified correctly, but a node can simply be set up
without it enabled, and leak the full internal chain on every outbound
transmission without anyone noticing for a long time. Strong real-world
precedent for exactly this bug class: VPN DNS leaks, `X-Forwarded-For`
headers leaking a real client IP through a supposedly anonymizing
proxy, misconfigured Tor exit nodes. Worth specifying as its own named
failure mode (something a `probe`-equivalent could actually detect) so
it reads as a real, checkable misconfiguration rather than an abstract
warning.

## Open question for whoever picks this up

Whether this needs a new record type at all, or whether it's purely an
operational/deployment convention layered on existing Session Keys
with no new wire-level structure required. Leaning toward the latter —
flagging rather than deciding.
