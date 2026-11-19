# RFC-2303 — Physical Media & Propagation

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the rulebook for how data actually moves across a network where
most links are slow, intermittent, or physically carried by a ship. It
covers every kind of transport SolNet uses — fast fiber, line-of-sight
laser/microwave, long-haul deep-space radio, a literal ship or drive
scheduled to show up eventually, and tiny constrained devices — and
defines the one thing all of them have to agree on regardless of how
different they are physically: how to describe *how good* a link is,
and how to talk about data that hasn't fully "landed" yet.

Key ideas:

- **Every link has to describe itself honestly** — how fast, how
  reliable, on what schedule, under what authentication. Routing without
  this is guessing, and guessing causes real problems.
- **"Provisional" vs "Confirmed."** Something you just received might
  not be fully propagated across the network yet — it's accepted
  locally but not yet backed up everywhere it needs to be. The system is
  required to let you ask "is this provisional or confirmed?" rather
  than silently treating the two the same.
- **Receipts are the paper trail.** Every accepted record produces a
  signed receipt — who sent it, who received it, when. This is what
  lets anyone reconstruct what actually happened after the fact.
- **Couriers are the slow-but-reliable backbone.** A physical ship or
  drive carrying data is a legitimate, first-class transport option —
  it just comes with its own manifest and custody rules, since nobody's
  watching it happen live.
- **Conflicts get preserved, not resolved by force.** If the network
  splits and two branches both keep writing, reconciling them later
  must keep *both* conflicting records visible rather than one side
  just winning.

## Where to look for exploits

- **The provisional window is a race-condition playground.** Something
  "accepted but not yet confirmed" behaves differently on different
  devices for a little while. A mission built around acting *during*
  that window — before confirmation flips one way or the other — is a
  legitimate, built-in soft spot, not a bug being abused.
- **Hiding data inside things that are allowed to carry extra payload.**
  Records and courier manifests are explicitly allowed to carry
  encrypted blobs or odd metadata. A few innocuous-looking blobs
  repeating across unrelated records is how you'd actually smuggle
  coordination messages past anyone just skimming the logs.
- **Advisory indices aren't supposed to be trusted blindly — but
  something will trust them anyway.** Relays keep unofficial "reputation"
  or lookup indices that are explicitly labeled non-authoritative. Poison
  one of those, and anything downstream that acts on it automatically
  (a quarantine, a trust bump) without a human double-check is exploitable.
- **A single relay's word being treated as good enough.** Lightweight
  devices are allowed to trust one relay's compact proof instead of
  checking the full ledger themselves. Spoof or compromise that one
  relay, and you can feed a constrained device (like a courier's wrist
  terminal) a convincing lie.
- **Courier manifests are physical paperwork, and physical paperwork
  gets tampered with.** A courier's signed manifest and chain-of-custody
  records are only as good as the operator's own enforcement — swap or
  alter a manifest mid-transit and you can make a shipment lie about
  what it's actually carrying.
- **Replaying something old through a relay that buffered it too long.**
  Relays are allowed to hold data before forwarding it. Reintroducing an
  old, previously-valid record after it should have expired can trick a
  system that isn't strict about freshness windows into accepting
  something it shouldn't.
- **Trust can be laundered through a long chain of weak middlemen.**
  Cross-domain trust certificates can chain through intermediate
  signers. A long enough chain with one weak link in the middle can make
  an untrustworthy source look properly vouched-for by the time it
  reaches you.
- **Admission controls (fees, reputation, proof-of-work) can themselves
  be gamed.** Whatever a relay uses to decide who's allowed to send it
  data is itself an attack surface — pay, grind, or game your way past
  it and you can flood a relay or smuggle records through that should
  have been rejected.

## What's deliberately out of scope here

The actual ledger semantics these receipts and provisional states refer
to belong to RFC-2302 (and its companion, RFC-2302A, on deployment
models) — this document only defines how the *data gets there*, not
what the ledger itself guarantees once it does.
