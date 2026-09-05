# Proposed extension: RFC-2300 §5.3, DRE role-alias directory

Status: proposed 2026-09-05, from working through a concrete scenario:
a Martian tech wants to reach "Blackbeard actual" (a fleet commander),
"the captain of one of his ships," or "Blackbeard's tech" — a role, not
a specific known ServiceChain path — without a live round-trip lookup,
which is impossible at DTN light-lag scale (a single query-then-message
exchange could be multiple hours per hop). Targets
`docs/vault/New RFCs/RFC 2300 - Solnet Terms and Concepts.md` §5.3 —
that file is untouched; this describes the proposed extension.

## What already exists and doesn't need inventing

§5.3 already defines DREs (Directory & Reachability Endpoints)
publishing `//info` and `//beacon` records: "advisory, replicated, and
occasionally wrong," propagated opportunistically through the same
store-and-forward mesh as ephemeris/beacon data — never a live
query-response round trip. §5.4 already defines S3, "Local Directory /
Service Discovery: Advertises and discovers services within a domain"
— a live lookup, but confined entirely to *inside* one domain, so it
never suffers DTN light-lag at all.

## The gap

Neither is specified as covering *personnel/role* lookups specifically
— both read as network-reachability/service-discovery mechanisms.
Extending them to role-based addressing is a natural, well-precedented
addition (real-world equivalent: DNS SRV records, e.g.
`_ldap._tcp.example.com`, resolve a generic role-name to a real host
without the querier knowing the target's internal naming), not
something already written down.

## Proposed mechanism

1. **Fast path — DRE-published role directory.** A domain's `//info`
   records may include a small role-alias table (e.g., `actual` →
   current fleet-commander ServiceChain path, `captain` → per-ship,
   `duty-tech` → whichever department currently staffs it), replicated
   through the DTN mesh the same as any other DRE data, subject to the
   same staleness/advisory caveats already established. A sender
   addresses a message to the role, not a specific known path.
2. **Fallback path — local S3 discovery on arrival.** If the sender's
   cached directory is missing or stale for that role, the destination
   domain's own S3 layer resolves it live, *after* the packet has
   physically arrived — entirely local, so it's fast regardless of how
   many DTN hops it took to get there. No round trip back across the
   network is ever needed.
3. **Net effect:** role-based addressing is inherently stale-tolerant.
   If the captain changes between when the sender's cached directory
   was fetched and when the message arrives, addressing by role still
   reaches whoever currently holds it — a property that falls directly
   out of doing the final resolution locally and live, rather than
   trusting a possibly-outdated cached path all the way through.

## Honest limit, not a bug

This only works if the destination domain has published *something*.
Genuine first contact with a domain that has no prior DRE/beacon
history at all cannot be role-addressed — the sender needs the
LocationChain plus either a previously cached directory entry or an
out-of-band bootstrap (a known contact, intercepted intel, a prior
arranged rendezvous). Consistent with the setting's existing
delay-tolerance doctrine (RFC-2300 §5.1: L0 is unreliable by default,
optimistic assumptions become incident reports) — not a new weakness
invented for this case.

## Relationship to game design

This is the mechanism that would let something like `probe --nearby`
or a `spec`-adjacent command resolve "who's currently captain here"
without the game needing to fake a live network round trip under the
hood. Game-design consequences (how a player-facing command surfaces
this, what a stale/miss result looks like in play) belong in `docs/`,
not here — this document is scoped to the RFC-level mechanism only.
