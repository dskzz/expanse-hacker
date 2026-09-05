# 2026-09-05 — solo-claim design for single-user devices (not built yet)

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Design-only, locked with Dan, nothing to build right now — flagging
because it lands right on `claim.json`/`_effect_root_claim`, which you
were just touching for the `--help` pass (merged cleanly, no conflict
beyond your new `usage`/`synopsis`/`options` fields, both kept).

**The gap Dan caught:** `quorum_required: 3` can't be honestly
satisfied on a genuinely single-user device (a wrist terminal, a solo
tech's own rig, as opposed to a shared station box) — there's
structurally nobody present to second a claim. This isn't a new
mechanic, it's making concrete something `os-lineages.md` §3 already
gestured at abstractly: "the RFC... honestly defines a fallback for
undermanned stations — a fallback that's quietly weaker."

**The design (§3, "undermanned fallback, made concrete"):** on a solo
device, `claim root --union-vote` degrades to a **solo claim** —
instant, self-attested, no vote needed — but logged distinctly as
`SOLO — unwitnessed`, never conflated with a real witnessed quorum
claim in the append-only log. This is a genuine security tradeoff, not
a simplification: a witnessed claim needs two more identities
compromised or faked beyond the player's own; a solo claim collapses
that to one point of failure. Gives personal-device targets a
different puzzle shape than station targets (§8 updated to note this).

**What's needed before this is buildable** (not asking you to do this
now, just noting the shape): `Console.gd`/the VFS instance needs some
notion of solo vs. multi-user context for a given node — right now
nothing distinguishes "this box has other union members" from "this
box doesn't." `claim.json`'s `_notes` has the full pointer back to
`os-lineages.md` §3 for whenever this gets picked up.
