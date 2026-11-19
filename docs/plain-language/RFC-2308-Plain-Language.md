# RFC-2308 — Media Privacy and Exposure Policy

*Plain-language companion. The real document is normative; this one
exists so a player, GM, or new designer can understand what it does and
where it's weak without parsing RFC voice first.*

## What this actually does

This is the "how much does the network accidentally tell on you"
document. Every transmission leaks *something* beyond its actual
content — timing patterns, beaconing intervals, diagnostic chatter,
secondary data nobody meant to send — and this RFC exists to define
what counts as an unacceptable leak and who's responsible for stopping
it.

The key pieces:

- **A DRE is the gatekeeper.** Before handing anything over, a DRE is
  supposed to run every request through a strict decision process:
  verify who's asking → evaluate what they're allowed to see → either
  show it or suppress it → log what happened. If anything in that chain
  fails, it falls back to the safest possible answer by default, not
  the most helpful one.
- **Domain Privacy Profiles.** Every faction runs a different exposure
  policy — tight and heavily regulated (UN-style), military-strict
  (Mars), loosely enforced (Belter), or somewhere in between (mixed
  corporate/OPA) — and a DRE is supposed to know which profile it's
  talking to before deciding what to show.
- **A PolicyRecord spells out, field by field, what's sensitive and
  what isn't.** Classification, exposure level, suppression rules,
  audit requirements — all explicit, not left to judgment calls.
- **Non-compliant nodes exist and are explicitly anticipated** —
  improvised hardware, legacy relays, and genuinely unregulated
  operators are a known, named category, not an edge case somebody
  forgot to think about.

## Where to look for exploits

- **Reading what a node is leaking without meaning to.** A relay
  broadcasting an odd timing pattern, or a diagnostic bundle carrying
  "extra" fields nobody intended to expose, tells you things the node
  itself doesn't realize it's telling you. This is the single biggest
  category of exploit here — not breaking in, just *listening
  carefully* to what's already public.
- **Tracing a broken chain of custody.** If a record's provenance trail
  has a gap or a contradiction, somewhere in that chain a node is lying,
  misconfigured, or compromised — and finding exactly which hop it is
  is a real, legitimate investigative puzzle.
- **Catching a system exposing more than its own stated profile
  allows.** Every domain is supposed to only show what its declared
  Privacy Profile permits. A system quietly leaking more than that —
  whether from operator error, legacy behavior, or just being
  non-compliant by nature — is a concrete, checkable violation, not a
  vague suspicion.
- **A non-compliant node acting as an accidental amplifier.** Some
  relays absorb and re-broadcast whatever metadata reaches them,
  without caring about anyone's privacy profile. Mapping where that
  data is going to spread next — and deciding which links to cut before
  it does — is its own kind of race against time.
- **An operator who disabled suppression "just for a moment."** This
  is the single most common real-world-shaped failure in the whole
  document: someone turns off a protection temporarily to troubleshoot
  something, and whatever leaked in that window is now permanently out
  there. Finding out *who* captured it during that window is usually
  the actual mission.
- **A relay chain with mismatched compliance levels.** A real path from
  A to B rarely passes through nodes that are all equally strict — a
  compliant node, a legacy one, a bit of improvised hardware, and an
  unknown relay can all sit on the same route. The weakest link in that
  chain is where you'd actually go looking for the leak, not the
  strongest one.

## What's deliberately out of scope here

This document decides *how much* of a record gets shown once someone's
already been granted access — it doesn't decide *whether* they should
have been trusted at all in the first place. That's RFC-2362's job; the
two only work correctly together.
