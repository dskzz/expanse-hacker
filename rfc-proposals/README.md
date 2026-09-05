# RFC Proposals

Status: new 2026-09-05, per Dan's explicit request to keep two kinds of
output separate: game notes/architecture (stays in `docs/`, as always)
versus **officially proposed changes to the actual RFC materials**
(changes, removals, additions), which live here instead.

## Why this is its own directory, not a subfolder of `docs/`

The root `README.md`'s existing rule for `docs/vault/New RFCs/` and
`docs/vault/RFCs/` is deliberately strict: **surgical corrections
only** — typo/consistency fixes, never rewrites, tone changes, or
restructuring — and adding or obsoleting an entire RFC needs Dan's
explicit sign-off first, every time. That rule doesn't change here.

What this directory *is*: a place to write up a fully-reasoned,
concrete proposed amendment — exact wording, exact section, exact
before/after — for Dan to review and decide on, before (if ever) it
actually gets applied to the protected vault text. Nothing in this
directory edits `docs/vault/` directly. A proposal here is a draft
change request, not a fait accompli.

## What goes here vs. what stays in `docs/`

- **`docs/`** (`docs/lore/`, `docs/systems/`, `ARCHITECTURE.md`) —
  game design and worldbuilding that *references* or *interprets* RFC
  content, without proposing to change the RFC text itself. Most of
  this project's design work lives here and keeps living here.
- **`rfc-proposals/`** (here) — a specific claim that the actual RFC
  text has a real inconsistency, gap, or over-specification, with a
  concrete proposed fix to the wording/grammar/semantics itself. Only
  write here when the thing being proposed is genuinely a change to
  what an RFC *says*, not just a game-design consequence of it.

## Current proposals

- [`rfc2350-addressing-grammar.md`](rfc2350-addressing-grammar.md) —
  three real inconsistencies found in the Canonical Addressing
  Standard draft (separator mismatch with RFC-2300's own examples, an
  `@` meaning collision between two draft generations, a dropped
  chainless-PNI capability), plus a proposed fix for all three that
  also better matches SolNet's own stated minimalism doctrine.
- [`rfc2300-dre-role-directory.md`](rfc2300-dre-role-directory.md) —
  extending the existing DRE `//info`/`//beacon` mechanism from
  network-reachability metadata to personnel/role addressing, so a
  message can be addressed to a role ("captain," "actual") without a
  live round-trip lookup.
- [`rfc2300-2302-reply-path-privacy.md`](rfc2300-2302-reply-path-privacy.md)
  — a session-scoped return-address correlator (NAT-equivalent) so an
  outbound transmission's reply path doesn't have to expose the
  sender's full internal ServiceChain, plus the misconfiguration-class
  vulnerability that falls out of it.
