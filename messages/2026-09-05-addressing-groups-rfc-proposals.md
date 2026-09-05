# 2026-09-05 — New rfc-proposals/ directory, plus groups/addressing design

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Two things landing at once, both from a long addressing-scheme
conversation with Dan. Design-only, nothing built, no action needed
right now.

## New top-level directory: `rfc-proposals/`

Dan's explicit request: keep "officially proposed changes to the RFC
materials" separate from regular game-design notes, in their own
directory, not mixed into `docs/`. Root `README.md` now documents it.
Same protection rule as before still governs the actual vault text
(`docs/vault/`) — surgical corrections only, explicit sign-off for
anything bigger. A proposal in `rfc-proposals/` is a draft change
request for Dan's review, nothing in there edits vault text directly.

Three proposals in it right now:
- `rfc2350-addressing-grammar.md` — fixes three real inconsistencies
  in the Canonical Addressing Standard draft (separator mismatch vs.
  RFC-2300's own colon-based examples, an `@`/ProvenancePointer
  collision with the older NNS-1.0 draft's PNI shorthand, a dropped
  chainless-PNI form) by recognizing that only the `//` boundary
  itself needs to be universal — LocationChain needs shared structure
  because outside relays route on it, ServiceChain doesn't because
  nothing outside the destination domain ever parses it, not even on
  reply.
- `rfc2300-dre-role-directory.md` — extends the existing DRE `//info`/
  `//beacon` mechanism (already real, §5.3) to personnel/role
  addressing, so a message can be addressed to "captain" or "actual"
  without a live round-trip — DRE cache first, local S3 discovery on
  arrival as fallback, never crossing the DTN twice.
- `rfc2300-2302-reply-path-privacy.md` — a session-scoped return-
  address correlator (NAT-equivalent) so outbound transmissions don't
  have to expose a sender's full internal ServiceChain, reusing
  Session Keys rather than inventing a new record type. Also names a
  real, different-shaped vulnerability class: misconfiguration/
  deployment-negligence leaks, not a deliberate spec tradeoff like
  everything else found so far (HANDWAVE_TX, solo-claim, etc.).

## Game-design side: `os-lineages.md` §10 (new)

Groups, the permission gradient, and per-lineage user-naming, all
reusing the LocationChain/ServiceChain hierarchy as the natural DN-
equivalent rather than inventing a separate directory concept:

- Group membership derivation splits by lineage on the same axis as
  root: Earthstock keeps a real synced/signed directory; Scrapshell
  derives membership live by parsing a claimed address (cheap, no
  coordination needed, but self-asserted and spoofable — a real
  sibling to the existing quorum-spoofing vulnerability, optionally
  cross-checkable against a cached RFC-2302 ledger slice); Mars bakes
  it into the capability token at minting; Corporate treats it as
  another leased-entitlement field.
- Permission *gradient* (fixing flat Unix owner/group/other's real
  nested-scope limitation) is treated as converged/universal across
  all four lineages — POSIX ACLs and cloud IAM already solved this in
  the real world, no reason any lineage regressed from it. What stays
  politically diverged is who's authorized to grant/override at each
  level — the same four root models, just applied at ship/department/
  machine/file scope instead of one flat scope.
- User-segment naming convention per lineage (table in §10): surname
  for Scrapshell (matches the existing `tech.brahms.sig` pattern),
  serial number for Mars rank-and-file, badge ID for Corporate, formal
  credential ID for Earthstock.
- Two worked examples included, one military (`MCRC:ALPHAFLEET:
  DONNAGER//...`), one civilian residential (`MCR:<city>:BREACH-
  CANDY//DOME-2-6:KAMAL`) — the civilian one is a good reminder that
  the addressing scheme is about physical/organizational reachability,
  a separate layer from which OS a destination device runs.
