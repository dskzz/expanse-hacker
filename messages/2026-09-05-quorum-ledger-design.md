# 2026-09-05 — Quorum votes get a real ledger record + TTL (design-only)

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Dan's question: could a successful `claim root --union-vote` persist
so a player doesn't need to re-solicit a full quorum vote for every
routine action (updating a hosts list, say)? Design-only, locked with
Dan, nothing to build right now — landing right next to `claim.json`
you were just touching, so flagging before you pick it up again.

## The design (`os-lineages.md` §3, "Quorum doesn't have to be
re-litigated per action")

Fix the *record*, not the requirement. A successful quorum claim gets
appended as a **multisig ledger entry** — N genuine co-signatures from
the seconding union members, hash-chained for tamper detection —
carrying a TTL. Root stays valid for that window without a fresh vote
per trivial action, then decays back to unverified. Real substrate for
this already exists and isn't invented for this: `docs/vault/New RFCs/
RFC 2302 - Solnet LEdger Spec.md` §9 already specifies a **"Local
ledgers"** deployment mode for exactly this station-scale case, and §6
already requires cache TTL/freshness metadata on entries — that's the
"degradation timeframe" mechanism, already spec'd, just not yet
applied to `claim`.

("NFT" was Dan's first framing and it's the wrong metaphor — an NFT is
a tradeable owned asset, root shouldn't be either. This is closer to a
Kerberos ticket: time-boxed, revocable, notarizing an event.)

## The line that must not move

**The ledger notarizes that a real social vote happened — it doesn't
grant authority on its own.** Validity still needs N real, distinct
co-signatures; one compromised key can't forge a valid entry alone. If
it could, root would quietly become "crypto with extra steps," which
collapses the entire reason Scrapshell's model reads as socially
distinct from Mars's capability-fob (crypto/possession-based, full
stop) or Earthstock's chain-of-custody. Build it as "N people actually
agreed, recorded tamper-evidently," never as "one key unlocks root."

## One real compatibility check I did before locking this in

`db/CORPUS-STATUS.md` already flags that RFC-2302's `AnchorRecord`
structurally assumes a persistent AK as *the* root of authority —
specifically Earthstock's model, wrongly generalized, flagged as a
real blocker for RFC-2362 (Trust Domains). This design deliberately
does **not** use `AnchorRecord` for exactly that reason — a quorum
vote needs a different record shape (N signatures + TTL, no persistent
"authority key" implied), not yet a formal type in the RFC text. This
is consistent with that flag, not a fix for it — RFC-2362 still needs
its own real answer, separately. Noted the cross-reference in
`CORPUS-STATUS.md` so it doesn't look like this quietly resolved that
blocker.

## Also applies to the solo-claim fallback

Same ledger substrate, single-signer entry instead of multisig, same
tamper-evidence — no TTL benefit since there was never anyone to
solicit in the first place, but consistent recording either way.

`claim.json`'s `_notes` has the pointer back to `os-lineages.md` §3 for
whenever this gets picked up for real.
