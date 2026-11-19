# RFC-2301 — SolNet Cryptographic Primitives

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the key-management rulebook — not which exact crypto algorithm
to use (that's a later RFC), but the *shape* of how identity and trust
get built out of keys, and what happens when one gets stolen.

The core idea is a **ladder of keys**, each one shorter-lived and lower-
stakes than the one above it:

1. **Hardware Root** — a tamper-resistant chip, required on anything
   important (ships, relays, directory servers), optional on personal
   gear.
2. **Anchor Key** — the big one. Long-lived (years to decades), bound
   permanently to a domain or persistent node's identity. If this is
   compromised, that identity is compromised, full stop.
3. **Device Key** — tied to one physical device, lives months to years,
   can be revoked and replaced without touching the Anchor Key above it.
4. **Service Key** — short-lived, used for day-to-day announcements like
   "here's how to reach me."
5. **Session Keys** — thrown away after one conversation.
6. **One-time tokens** — used once, for emergencies or handoffs, then
   dead.

The whole point of the ladder: losing a key near the bottom should
never let you forge something that requires a key near the top. And
when something *is* compromised, there's a defined emergency process —
revoke it, log why, and (if things are bad enough) issue a short-lived
override token so legitimate recovery work can still happen.

The document also sets up for a future where quantum computers can
break today's classical signatures: long-lived keys are expected to use
"hybrid" signatures (classical + post-quantum together) so a future
crack of one half doesn't unravel everything retroactively.

## Where to look for exploits

- **The gap between "we noticed" and "everyone's cache updated."**
  Revocation doesn't happen instantly everywhere — it has to propagate.
  A stolen key is still technically useful during that window, especially
  against any device that didn't prioritize updating its revocation
  cache right away.
- **Treating a low-tier key as harmless because it's "just" a Service
  Key or Device Key.** A stolen Device Key is much less catastrophic than
  a stolen Anchor Key — but if some system lets a Device Key sign
  something it shouldn't (something that really needed Anchor-Key-level
  authority), that's the whole point of the ladder being quietly broken.
- **Rotation grace periods.** When a key rotates, there's a deliberate
  overlap window where both the old and new key are still considered
  valid, specifically so nothing breaks mid-transition. That overlap is
  also exactly when a stolen *old* key is most useful to an attacker who
  wants to use it one last time before it's dead for good.
- **Personal devices without a hardware root.** Big important nodes are
  required to have tamper-resistant hardware protecting their keys.
  Personal devices are only *recommended* to. A personal device running
  on pure software protection is the soft target — and because every
  identity is ultimately chained back to the key hierarchy, a convincing
  forgery starts by finding the weakest link in that chain, not the
  strongest.
- **Fresh-boot randomness.** A device is supposed to reseed its random-
  number generator on boot, after sleep, and after anything suspicious.
  A device that skips this, or boots from a predictable state, is
  generating session keys that are weaker than they look — right up
  until that reseed actually happens.
- **A quietly swapped algorithm.** Switching a long-lived identity key
  to a different cryptographic algorithm without logging it anywhere is
  explicitly forbidden — which also means it's exactly the kind of thing
  worth watching for: a node whose anchor suddenly "upgraded" with no
  ledger entry documenting it is a very good reason to ask questions.

## What's deliberately out of scope here

The actual algorithm names, key sizes, and post-quantum timeline are
punted to RFC-2451 (hardware root requirements) and RFC-2452 (concrete
algorithm choices) — this document only defines the shape of the
system, not which specific math it runs on.
