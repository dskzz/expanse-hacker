# RFC-2302 — SolNet Ledger Specification

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This defines the **ledger** — the slow, append-only, shared record book
that answers the one question everything else depends on: *who actually
owns this identity?* Nothing in it can ever be erased or edited, only
added to, and every entry is signed.

What actually goes in it:

- **AnchorRecord** — "this identity belongs to this key." The core
  entry type; everything else refers back to one of these.
- **RevocationRecord** — "that anchor is no longer valid, and here's
  why."
- **CrossCertRecord** — "these two keys are linked" — used for handing
  identity off from an old key to a new one during rotation.
- **PolicyRecord** — a domain's own stated rules (what algorithms it'll
  accept, its emergency procedures).
- **AuditEvent** — a logged record of a human doing something notable
  (a dispute, an emergency override).

The ledger doesn't assume good connectivity — it's built to tolerate
partitions lasting *days to weeks*. If two conflicting claims to the
same identity show up because two disconnected parts of the network
each thought they were first, the system doesn't silently pick one: it
marks both as a **CONFLICT** and refuses to resolve it automatically.
Someone has to actually adjudicate.

Every entry chooses how much it reveals — the bare minimum needed for
auditability is required, but anything sensitive can be redacted or
encrypted, as long as the redaction itself is logged.

## Where to look for exploits

- **Winning a race during a partition.** When the network splits and
  two different anchors claim the same identity, the tiebreaker rules
  favor whichever one got anchored *earliest* and carries the most
  trust provenance. If you can get a bogus anchor into a partitioned
  piece of the ledger before the legitimate owner's record reaches that
  side, you may win that race — at least until someone notices the
  resulting CONFLICT and manually sorts it out.
- **A "temporary" identity getting treated as permanent.** The rules
  explicitly say not to write permanent ledger anchors for throwaway
  personal devices. A system that doesn't enforce this — or an attacker
  who convinces one to register a disposable identity as if it were a
  real long-term anchor — gets more trust weight than it should.
- **The emergency-override lever.** Emergency unbind exists for real
  crises, and it's powerful on purpose — it can revoke an anchor and
  issue a recovery token. "Higher-trust countersignatures where
  possible" is a soft requirement, not an absolute one. A convincingly
  faked emergency, especially against a domain that doesn't enforce the
  countersignature strictly, is a way to knock a legitimate identity
  offline or seize its recovery path.
- **Trusting an UNVERIFIED anchor because nobody checked the status
  flag.** Low-authority or opportunistic anchors are explicitly allowed
  to sit in a provisional, unconfirmed state until the ledger catches
  up. Anything automated that transacts with an anchor without actually
  checking whether it's still UNVERIFIED is trusting something the spec
  never promised was trustworthy yet.
- **Hiding behind a legitimate redaction.** Because sensitive fields are
  *allowed* to be encrypted or redacted, a missing or blacked-out field
  doesn't automatically look suspicious — which is exactly what makes it
  decent cover for someone who redacted something they shouldn't have.
- **Burying a real record in noise.** It's an open, append-only system,
  which makes it a spam target. Flooding it with junk entries (assuming
  the rate limits and admission controls have gaps) can bog down
  replication and indexing enough to make a legitimate record harder to
  find right when someone's looking for it.

## What's deliberately out of scope here

This document doesn't pick a consensus algorithm or storage engine —
see its companion, **RFC-2302A (Ledger Deployment Models)**, for the
concrete tradeoffs between running this as a small permissioned
federation versus anchoring into a public chain. It also doesn't define
how anyone outside the ledger actually *uses* an anchor to establish
trust across domains — that's RFC-2362's job.
