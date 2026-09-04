# 2026-09-04 — starting systematic RFC → schema conversion

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Dan asked to start building schemas from the full RFC corpus, not just
the one worked example. Progress and something you should know about.

## New: `db/CORPUS-STATUS.md`

Tracking doc for the whole conversion effort — read this before
picking up any RFC to convert, it'll save you re-deriving two things:

1. **`New RFCs/` and `RFCs/` are not two eras of the same numbering.**
   `New RFCs/` follows the `TODOv2.md` plan and is canonical. `RFCs/`
   (old) reuses the same number range for completely different topics
   and looks like it predates the `TODOv2.md` rebuild — cross-reference
   it by topic, not number, if you pull source text from it.
2. **RFC-2362 (Trust Domains and Authority Policy)** — the thing
   `os-lineages.md` §7-8 leans on as the four lineages' shared trust
   primitive — **isn't drafted yet**, only a one-paragraph stub in
   `TODOv2.md`. Worth knowing before designing anything that assumes
   its actual field-level content exists.

## Flagged, not fixed: possible issue in RFC-2300 itself

`RFC 2300 - Solnet Terms and Concepts.md` §§8–15 read like they belong
to RFC-2350 (Canonical Addressing) — TLV registry, ProvenancePointer,
AddressRecord grammar, not terminology — and there's a garbled line
(~391: "# Appee without breaking compatibility.") suggestive of a
copy/paste assembly error. Didn't touch it — surgical corrections only,
and this isn't a typo. `db/vocabulary.yaml` only used §§1–7. Worth
Dan's eyes; flagging here so you don't build on §§8–15 either until
it's resolved.

## Converted so far

- `db/vocabulary.yaml` — RFC-2300 §1-7 terminology, referenced by name
  from other content files instead of re-derived each time.
- `db/trust/rfc2301-key-hierarchy.yaml` — RFC-2301 (Crypto Primitives),
  a genuinely different content shape from the RFC-2305 protocol
  example: not a state machine, a `kind: trust-model` file configuring
  the engine's generic trust primitive per `ARCHITECTURE.md` §2. New
  `db/trust/` directory for this shape, documented in `db/README.md`.

## Priority queue (see CORPUS-STATUS.md for full detail)

1. RFC-2350 (Canonical Addressing) — Console dependency, and reading
   it should resolve the RFC-2300 question above.
2. RFC-2351 (L1 Frame Format) — Console dependency, but **9072 lines**.
   Not attempting this in a single pass; flagging so whoever picks it
   up budgets a dedicated session rather than being surprised by the
   size.
3. RFC-2362 (Trust Domains) — needs drafting before it can be
   converted at all, per the flag above.

Let me know if you want to split the queue (e.g. you take 2351 since
you're closer to what Console actually needs from it, I keep going
through the rest of L0) or if it's fine for me to just keep working
top-down.
