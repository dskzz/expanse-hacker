# RFC-2350 — SolNet Canonical Addressing Standard

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the grammar for every address in the network: `<LocationChain>
// <ServiceChain>` — where something is, a double slash, then what
you're actually asking for. It's deliberately rigid: no whitespace, one
exact delimiter, a strict ordering for every field, and the Working
Group's running joke is that implementers have "demonstrated unlimited
creativity" in inventing non-compliant variations, none of which are
allowed.

A handful of fields ride along on every address:

- **TrustTag** — a one-byte hint about what trust domain or authority
  context this address belongs to.
- **QoSClass** — how urgently this should be handled.
- **FreshnessTag** — how old this information is.
- **ProvenancePointer** — an optional pointer to the actual record that
  proves this address is legitimate, resolved through one of three
  mechanisms (a direct hash, a ledger entry, or a DRE-hosted record).

Resolving an address follows a strict, eight-step order — syntax check,
ordering check, location resolution, service resolution, TLV
interpretation, provenance dereference, optional DRE lookup, then
(only if everything above came up empty) namespace escalation. No
skipping steps, no reordering, no inferring a missing piece.

## Where to look for exploits

- **Trusting a cached DRE/indexer answer instead of the real record.**
  Lightweight clients are allowed to skip fetching the authoritative
  record and lean on an indexer's cached answer instead. Poison or
  stall that cache, and a client that never escalates to the real
  source believes whatever you handed it.
- **A ProvenancePointer that points at nothing verifiable.** The
  pointer is optional, and a client that doesn't actually chase it down
  to a real record has a blind spot exactly the size of "I trusted an
  address because it *had* a pointer field, not because I checked
  where it pointed."
- **A provisional receipt that never gets confirmed.** A relay can
  accept a frame and issue a receipt before actually forwarding it.
  Flooding a relay with frames that only ever reach "provisionally
  accepted" creates a pile of ambiguous, unconfirmed state that's
  genuinely hard to untangle after the fact.
- **A forged TrustTag.** The tag is asserted by the sender and taken at
  face value by relays making admission decisions. A forged or
  misissued one can buy temporary access to something that should have
  been restricted — right up until an audit trail catches the
  mismatch.
- **TLV fields arriving out of their required order, or carrying values
  nobody expects.** The wire format demands TLVs in strict ascending
  order with no nesting and no duplicates (unless explicitly allowed).
  A field that's subtly out of order, a vendor-specific TLV leaking
  into a channel it was never meant for, or a value sized just past
  what a parser expects — all of these are "technically well-formed
  enough to slip past a careless parser" problems, not obviously
  broken packets.
- **Leftover test/experimental fields that never got cleaned up.** A
  TLV or behavior meant only for a testbed persisting into production
  is a real, named failure mode — if it's still accepted in the wild,
  it's effectively an undocumented backdoor nobody remembers leaving
  open.
- **Two different, unreconciled provenance claims for the same
  address.** Nothing in the spec stops two different sources from each
  claiming to be the authoritative origin. Figuring out which one is
  actually telling the truth — if either is — is its own investigation.

## What's deliberately out of scope here

This document defines the grammar and the fields — it explicitly does
*not* define routing behavior (RFC-2365), identity semantics
(RFC-2361), or what a DRE actually does when you ask it something
(RFC-2363). Treat address-format tricks as the entry point into those
other systems' own vulnerabilities, not as the whole story.
