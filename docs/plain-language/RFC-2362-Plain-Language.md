# RFC-2362 — Trust Domains and Authority Policy

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the answer to "when one domain has to decide whether to believe
another, what actually happens?" Every domain declares, honestly, which
of exactly four ways it proves who's in charge:

- **CHAIN_OF_CUSTODY** — a persistent key, passed down and tracked
  (the UN/Earthstock model).
- **QUORUM_WITNESS** — a vote among the domain's recognized
  representatives, no persistent key at all (the Belt/Scrapshell model).
- **CAPABILITY_TOKEN** — physical possession of something minted at a
  specific ceremony (Mars).
- **LEASED_ENTITLEMENT** — a revocable grant from somewhere else,
  cached locally (corporate leases).

The single most important rule in the whole document: **winning root
on one specific machine is not the same as having authority over the
whole domain.** A Scrapshell dockworker vote on one station doesn't
make that station's winner the Belt's overall representative — those
are two different, deliberately separate things, and conflating them
is the document's own named failure mode.

The second big rule: **trust doesn't automatically chain.** Domain B
trusting Domain A, and Domain A trusting Domain C, does *not* mean B
trusts C — unless B's own PolicyRecord explicitly says so. Recognizing
that a domain runs a legitimate-looking root model is not the same as
recognizing any specific thing that domain vouches for.

## Where to look for exploits

- **Turning one cheap, local win into domain-wide credibility.** This
  is the single biggest payoff-to-effort exploit here: get a system
  that never properly separated "local root" from "domain root" to
  treat your one-station win as if it were standing across the whole
  domain.
- **Laundering trust through an extra hop.** If a buggy system lets "A
  trusts C, and B trusts A" quietly imply "B trusts C" with no actual
  policy decision behind it, you can reach a domain that never agreed
  to trust you at all — through someone you legitimately do have
  standing with.
- **Presenting the wrong proof for the model you're claiming.** A
  domain is supposed to check that its declared root model actually
  matches the kind of proof backing it up. A system that skips that
  check can be shown a weak kind of proof dressed up as if it came from
  a stronger model.
- **A forged "we already agreed to trust them" record.** The record
  that documents a trust decision isn't the same thing as the decision
  itself. Forging the documentation, with no real decision behind it,
  fools anyone who checks "does this record exist?" instead of "was
  this actually decided?"
- **Stacking fake votes in a quorum-based domain.** A vote-based
  domain's legitimacy depends entirely on the voters being who they
  claim to be. Pack the voting body with fakes or compromised accounts,
  and you can produce a technically-valid-looking claim to that
  domain's own root — the Belt-model equivalent of stealing a signing
  key.
- **Confusing a local theft with a ceremony-level compromise.** Someone
  stealing a few physical tokens is a local incident. Someone
  compromising the actual minting ceremony is a domain-wide
  catastrophe. The exploit is getting a domain to misjudge which one
  just happened — either hiding a real ceremony compromise as "just a
  few stolen tokens," or panicking a rival into an unnecessary,
  reputation-wrecking full domain reset over a theft that was actually
  contained.
- **Rolling back your own clock to keep a lease looking valid.** A
  device can fake an unexpired grant just by setting its own clock
  back — a real, acknowledged flaw, not a secret one. Works for exactly
  as long as the device stays disconnected enough that nobody notices
  the clock is wrong.
- **Squatting on a reserved tag before anyone registers it.** A handful
  of trust-tag values are reserved for sub-domains but require
  registration to actually claim. Until someone does, a system is
  required to treat an unregistered one as inheriting the parent
  lineage's trust by default — meaning you can get broad trust just by
  sitting in that gap and never finishing the registration that was
  supposed to narrow it.
- **Winning the blame game instead of the technical fight.** Fault
  after a dispute gets assigned based on whose policy governed the
  decision, not on who was technically right. That's a pure
  diplomacy/politics play: accept something borderline, then argue
  afterward that it was the *other* side's fault for looking
  trustworthy in the first place.
- **Crying wolf about a domain-wide compromise.** A full domain reset
  is deliberately hard to trigger, specifically because of how
  disruptive it is — which makes falsely triggering one its own
  attack. Convince the right review process that a domain's root is
  compromised at scale when it isn't, and every credential that domain
  has ever issued becomes suspect at once, without you touching a
  single real credential.

## What's deliberately out of scope here

This document doesn't say how any one domain runs its own internal
politics (the UN's internal CA process, the Belt's own union bylaws,
Mars's actual minting ceremony) — only what happens at the boundary
between domains. And it explicitly defers the actual DRE-level
mechanics of checking trust to RFC-2363.
