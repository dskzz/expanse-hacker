# RFC-2302A — Ledger Deployment Models

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

RFC-2302 says what a ledger has to guarantee. This document is the
companion that says *how you'd actually build one*, with two real
options:

- **Permissioned Federation** — a small, known set of trusted operators
  (a fleet, a government, a corp) run the replicas. Fast, cheap,
  private, tightly governed. The tradeoff: it's only as trustworthy as
  that small group of operators.
- **Hybrid Blockchain** — the same trusted-operator core, *plus*
  optionally publishing a hash/commitment of important records to a
  public blockchain for extra tamper-evidence and so independent
  outsiders can discover and verify them without trusting the federation
  at all. The tradeoff: public chains are slow to finalize, cost fees,
  and leak metadata.

The document's own recommendation is a **hybrid default**: run the fast
private federation for day-to-day trust and governance, and optionally
anchor specific high-value records into the public chain for the
records that actually benefit from a second, independent witness.

A few mechanics worth knowing: a ship or station cut off during a
partition can mint its own **provisional, locally-originated** anchor
rather than waiting for connectivity — but it's explicitly marked
provisional, and there's a defined grace window (a day or three) before
an unresolved conflict escalates and requires an actual human to sort it
out.

## Where to look for exploits

- **Collusion inside a small trusted group.** A Permissioned Federation
  is only as honest as its bounded set of operators. Fast, deterministic
  finality is a feature — right up until enough of that small group
  decides to agree on something false together. The smaller and more
  insular the federation, the easier this is to pull off quietly.
- **The provisional window on a cut-off ship.** A station or ship that's
  lost its connection is explicitly allowed to self-anchor something
  provisionally and keep operating. That grace window (24–72 hours in
  the document's own example) before the conflict gets escalated and
  looked at is exactly the kind of window a mission could be built
  around — mint something provisional, get what you need done, and be
  gone before the grace period runs out and someone notices the
  conflict.
- **Relying on the public chain for something urgent.** The document
  explicitly warns against trusting public-chain finality alone for
  time-critical revocations, because public chains can be slow and can
  reorganize their own recent history. A system that cuts corners and
  *does* lean on public finality for an urgent revocation has a real
  window where a "revoked" identity can still look valid if the public
  chain hasn't caught up — or worse, briefly un-reverts if the chain
  reorganizes.
- **The bridge is a single point of failure.** Linking a permissioned
  anchor to a public-chain commitment runs through a signed
  cross-certificate from a bridge key. Compromise that one key, and you
  can forge the link between what the trusted federation actually
  agreed to and what the public chain appears to show — which is
  exactly the kind of mismatch the public anchoring was supposed to
  catch, not create.
- **Jamming the out-of-band alert instead of the ledger itself.**
  Urgent revocations are supposed to go out via direct subscriber alerts
  so affected systems don't have to wait on ledger replication at all.
  If you can disrupt *that* channel specifically — comms jamming,
  targeted interference — a revoked anchor can keep looking trusted in
  whatever pocket of the network didn't get the alert, even though the
  ledger itself was updated correctly.

## What's deliberately out of scope here

This document doesn't pick a specific consensus protocol, bridge
implementation, or light-client proof format — those are flagged as
future companion work (a Permissioned Federation Implementation Guide
and a Hybrid Bridge Spec), not settled here.
