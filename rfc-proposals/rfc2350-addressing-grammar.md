# Proposed correction: RFC-2350 Canonical Addressing Standard, §4

Status: proposed 2026-09-05, from a design conversation working through
concrete cross-domain addressing scenarios (a Martian warship, a
civilian residential address, a pirate fleet). Targets
`docs/vault/New RFCs/RFC 2350 - SolNet Canonical Addressing Standard.md`
§4 (grammar) — that file is untouched; this describes the proposed
change for Dan's review.

## The one thing that actually needs to be universal

`Address = LocationChain "//" ServiceChain`. The `//` boundary is the
single hard, non-negotiable law — every relay between sender and
destination has to find it to know where global concern ends and local
concern begins. Everything else earns its normativity by a different
test: **does an outside party (a relay, an intermediate hop, anyone who
isn't the destination domain) actually need to parse it to do their
job?** LocationChain: yes — that's the whole point of it, it's what
every hop routes on, the same reason a phone number's country/area
code has to follow one universal digit format regardless of carrier.
ServiceChain: no — RFC-2300 §3 already says its resolution is local
("if you leak it globally, that is on you"), and §7 already says it
`MUST NOT` be used to infer global identity. Nothing outside the
destination domain ever reads it, not even on reply (a relay routes on
the LocationChain the same way SMTP routes on the domain part of an
address, treating everything before the `@` — or here, everything in
ServiceChain — as opaque cargo it never interprets).

## Three real inconsistencies found, and how this fixes all three

**1. Separator mismatch.** RFC-2300's own illustrative examples use
colon-separated segments (`MCRC:ALPHAFLEET:DONNAGER`), but the current
formal ABNF (`LocationChain = LocationElement *( "/" LocationElement )`)
mandates a single `/` instead. Once LocationChain's internal separator
is understood as a real, load-bearing standard (not just an
illustration) rather than an afterthought, it needs to actually be
picked correctly — and colon is the right pick, for a concrete
technical reason, not aesthetics: `BareToken`'s own charset already
permits hyphen, underscore, and dot as legal characters *inside* a
segment name (`ALPHA / DIGIT / "-" / "_" / "."`). The corpus's own
examples already rely on that — `ENG-1` and this project's own
`RB-CERES-119` are each one segment with a literal hyphen in them, not
two segments split by a hyphen-as-separator. If hyphen or dot were
*also* the separator, a parser couldn't tell whether `ENG-1` is one
token or two. Colon is the one candidate not already claimed as legal
token content, so it's the only one of the plausible choices that
doesn't collide with something the corpus already depends on.
**Proposed fix:** `LocationChain = LocationElement *( ":" LocationElement )`,
matching what RFC-2300 already shows.

**2. `@` meaning collision.** The older `RFC 2350 "NNS 1.0"` draft
(`docs/vault/RFCs/`, superseded folder) uses `@` for a PNI shorthand
(`<Identity>@<AuthorityChain>`). The current formal draft reallocates
`@` to `ProvenancePointer` — an audit/origin reference, restricted to
LocationChain, structurally excluded from ServiceChain entirely
(`ServiceElement = BareToken / TLV`, no ProvenancePointer variant).
This is a real collision only because both readings were being applied
to the same shared grammar. Once ServiceChain is understood as
genuinely local and never parsed by outsiders, the collision
dissolves: ProvenancePointer's `@` stays the one true meaning on the
*LocationChain* side (that's the side where global agreement actually
matters), and a domain is free to use `@` for a personal-identity
marker *inside its own ServiceChain* with zero conflict, because
nothing outside that domain is ever required to parse ServiceChain
structurally in the first place — including anything reading
ProvenancePointer, which only ever looks at LocationChain.
**Proposed fix:** add PNI as its own top-level grammar constituent,
syntactically following ServiceChain rather than nested inside it:
`Address = LocationChain "//" ServiceChain [ "@" PNI ]`. This
satisfies "the user segmented totally" literally — PNI is a fourth
field, not a ServiceElement — and gives a clean minimal-address form
for a single-user console: `SHIP//@tech-Kamal` (empty ServiceChain,
straight to the PNI).

**3. Dropped chainless-PNI capability.** RFC-2300 §3 defines PNI as
explicitly for personal devices that "do not need full Location
anchoring," and the old NNS-1.0 draft had a real standalone form for
this (`<Identity>@<AuthorityChain>`, or even a bare `<Identity>` for
same-domain reference) used *instead of* the full
LocationChain//ServiceChain skeleton. The current formal grammar
requires LocationChain to be non-empty and `//` to always appear —
there's no legal production for a genuinely chainless address anymore,
even though RFC-2300's own PNI concept still assumes one should exist.
This reads as an accidental capability loss from the NNS-1.0 →
Canonical Addressing Standard rewrite, not a deliberate one.
**Proposed fix:** restore a standalone PNI-only address form,
independent of the `Address` production above, for devices that
genuinely have no LocationChain to anchor to.

## What stays local, explicitly, per the `//`-is-the-only-hard-law test

Not proposing to further specify these — flagging them as correctly
*out of scope* for this RFC, precisely because they fail the "does an
outsider need to parse this" test:

- ServiceChain's own internal separator/charset within a domain
  (colon is a sensible default a domain can deviate from; RFC-2300's
  own worked example already reuses one string, a ship's name, on
  both sides of `//` with no issue, since the two chains resolve
  completely independently).
- Whether a domain's ServiceChain uses non-ASCII/exotic characters
  internally. A domain that *wants* to be reachable by the standard
  network still needs a standard-conformant LocationChain (see above)
  — but ServiceChain, once a packet has already arrived, is that
  domain's own business.
- The exact convention for a trailing personal-identity segment inside
  ServiceChain (plain colon-segment like the existing `SomeGuy`/
  `LtLopez` examples, vs. the PNI form above) — this is a local/
  per-lineage choice, not something this RFC should mandate.

## Worked examples (not proposed RFC text, just confirming the fix reads correctly)

```
MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG1:Reactor:TECH-TK421
MCR:<city>:BREACH-CANDY//DOME-2-6:KAMAL
SHIP//@tech-Kamal
```
