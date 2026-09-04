# Proposed sectional revision — RFC-2392, Sequence Wrap Handling

**Status: superseded, 2026-09-04.** Gary hand-converted RFC-2305 (Power and Duty Cycle
Constraints — a real, already-drafted RFC) into actual content (`db/protocols/
rfc2305-duty-reservation.json`, `db/hardware/relay-courier-rig-class-c.json`) with a real
spec-noncompliance vulnerability, and that replaced the EXPP placeholder everywhere it was used
(`db/vfs/registry/files.json`, `docs/lore/os-lineages.md` §6, the `relay-pallas-07` instance).
That's a strictly better fix than this proposal — real content beats a new proposed section. This
file is kept as a stub rather than deleted, because the underlying observation is still true and
might matter later: **RFC-2392 (Session and Conversation Layer) is a real planned-but-undrafted RFC
slot** (`docs/vault/New RFCs/TODOv2.md` line 124), and if a genuine session/handshake-sequencing
need comes up later that RFC-2305 doesn't cover, this is where that proposal would start from.

Original proposal below, kept for reference, not active.

---

**Status: proposed draft only, not canon.** This is a request for Dan to review, rewrite into
proper RFC voice/language, and decide whether/how to incorporate — not something added to
`docs/vault/` directly, per the RFC editing rule.

## Where this targets

**RFC-2392 — Session and Conversation Layer**, currently a planned-but-undrafted RFC (outlined in
`docs/vault/New RFCs/TODOv2.md` line 124: "Session framing, QoS, retries, session tokens,
resumption... SessionToken format, resumption rules, QoS mapping"). No file exists for RFC-2392
yet — this proposes one section of it, not the whole RFC.

## Why this exists

I'd embedded placeholder content (invented by Gary, explicitly marked non-canon in his own notes)
as if it were real RFC text, citing a fake "RFC-4419" — Dan caught this and asked me to check
whether real RFC content already covers it, or route it through a proper proposal instead of
inventing citations. I checked:

- **RFC-2351 §18.2 (FreshnessTag Wraparound Behavior)** covers wraparound conceptually but is not
  the same mechanism, and is actually the opposite in spirit: it's strict and mandatory
  ("Wraparound is a normal condition. Implementations MUST NOT attempt to detect or compensate for
  it") — no permissive gap, nothing to route around. Doesn't supply what the game example needs.
- **RFC-2392** is the correct conceptual home (session/handshake sequencing, not L1 framing) but
  doesn't have this section — or any drafted content — yet.

The game needs a session-layer sequence-wraparound rule with a **spec-honest permissive gap**: the
kind of MAY/RECOMMENDED language a real spec-writer would write in good faith for a case they
assumed was rare, that becomes exploitable wherever that assumption doesn't hold (same shape as the
Scrapshell quorum fallback in `docs/lore/os-lineages.md` §3, and the general pattern the RFC
Companion Designer Briefs already use throughout the vault). This is the anchor for the worked
`spec`/`probe` gameplay example already built (`db/vfs/registry/files.json`,
`docs/lore/os-lineages.md` §6).

## Proposed section text

Draft only — written in a generic normative-SSWG register (closest to RFC-2304/2353's tone) since
RFC-2392 has no established author voice yet. Deliberately does **not** self-annotate the gap it
creates — a real spec wouldn't flag its own loophole, and that's the point (nothing hidden, nothing
announced either). Section/subsection numbering is a placeholder pending wherever this actually
lands in the finished RFC.

> ### X.X Sequence Wrap Handling
>
> Implementations MAY validate sequence-number wraparound on receipt of an out-of-order DATA frame
> following HANDSHAKE_WAIT. Validation is RECOMMENDED but not required where the underlying buffer
> hardware performs wrap detection natively.
>
> Implementations that omit validation under this exemption remain responsible for confirming that
> their deployed hardware satisfies the native-detection condition. This RFC does not mandate a
> mechanism for that confirmation.

## What I'd need from Dan

- Confirmation this is the right RFC/section to attach it to (vs. some other planned slot).
- The actual finished language, in whatever voice/register you want RFC-2392 to carry — happy to
  take a pass at matching a specific existing RFC's voice if you point me at one, but wasn't going
  to guess at that unprompted for protected content.
- Once real text exists, `db/vfs/registry/files.json`'s `expp_rfc_v1` entry (and the "RFC-4419"
  citation wherever it still appears — `docs/lore/os-lineages.md`, `reference/vault_annex.md`)
  should be updated to cite RFC-2392 for real instead.
