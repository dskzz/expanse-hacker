# RFC‑2353 Companion — Exploits, Missions, Software, Structures

Internal design reference. No in-universe voice, no institutional stamps — this is the
game-design translation layer for RFC‑2353 (L1 Relay Advertisement Protocol), matching
the format already established for the RFC‑2352 companion doc. Everything below is
fictional, non-actionable, and grounded in RAP's actual field set and rules (TLV registry,
capability masks, scheduling/admission hints, T_adv timing discipline, HopCount
propagation, media profiles, sparse-topology fairness).

---

# I. Exploit Classes (Fictional, RFC‑2353‑Aligned)

RAP's whole design is "say as little as possible, on a schedule nobody can nudge." Every
exploit class below is either (a) a violation of a rule the RFC states outright, or (b) a
misuse of the one thing RAP deliberately does disclose (HopCount). Several combine a
technical mechanism with a social-engineering angle, same as the 2352 set.

## 1. HopCount Cartography (Sanctioned Leak, Weaponized)

Section 5.6 concedes HopCount discloses relative distance on purpose — the "one leak
this Bureau permits." A patient observer collecting HopCount values from many origins
across many forwarding relays can reconstruct a coarse distance map of a sector without
ever breaking a rule. This is RAP's only *legal* exploit, and the game should treat it
that way: no alarms trip, no SPERB case opens, but the player has still mapped hostile
territory using nothing but public, compliant traffic.

**Player gains:** relative-distance sector map; rough relay density per region.

## 2. Timing Correlation Attack

T_adv is deliberately unpublished as a number, but a relay's actual emission timestamps
are observable. A relay that jitters early under load — even by milliseconds, even
unintentionally — leaks a load curve through timing alone (Section 6 exists entirely to
prohibit this). Aggregating emission timestamps across many cycles recovers the pattern
Section 5's field-level minimization was built to prevent.

**Player gains:** inferred load curve for a target relay; congestion windows; best time
to slip traffic through unnoticed.

## 3. The Optimistic Capacity Class (Canon Non-Compliant Pattern)

Already named in Appendix G: a relay advertises SchedulingCapacityHint off theoretical
maximum throughput instead of sustained capacity. In-game this is a vendor fraud angle —
find relays lying about their own class, exploit the guaranteed-to-disappoint sessions
that get routed there, or blackmail the vendor once you can prove the pattern.

**Player gains:** predictable session failures at a specific relay class; leverage over
the vendor/operator once documented.

## 4. Quiet Favoritism / Admission Bias

Section 8 and 8.5 both name this directly: a relay (or the automated admission logic
behind it) advertises A2 (Open) for everyone while quietly favoring specific peers. This
is RAP's version of a rigged door — invisible from the outside, provable only by
statistical comparison of who actually gets admitted versus who's told "open."

**Player gains:** proof of sector-level discrimination (a real OPRA-flavored mission
hook — Belt sectors get quietly deprioritized by Inner-Worlds-vendor hardware); or, run
the other way, a tool to *install* quiet favoritism on a relay you control.

## 5. Structural / Byte-Length Fingerprinting

Section 5 requires byte-for-byte identical record structure regardless of load. A buggy
or cheaply-built implementation that varies record shape under stress (padding
differences, optional-TLV presence flicker) creates a side channel nobody intended.
Detecting this requires diffing many captured advertisements from the same RelayID
across different observed conditions.

**Player gains:** operational-state inference (busy/idle, degraded/nominal) from a relay
that thinks it's compliant.

## 6. Capability Mask / Extension Fingerprinting

RelayCapabilityMask's core 8 bits are meaningless for vendor ID by design, but bits
8–15 (vendor extension range) are exactly where sloppy implementations leak lineage —
a vendor's registered extension combination, or its *unregistered* bit usage, becomes a
fingerprint CVCO explicitly tries to prevent (Section 3.2, 3.3). This is the RAP
equivalent of a browser fingerprint.

**Player gains:** vendor/hardware-lineage identification from capability mask patterns
alone — useful for targeting a known-vulnerable hardware line across a whole sector.

## 7. RelayID Replay / Spoofing (Section 10(b))

RAP is explicit that RelayID provides no origin authentication on its own. A spoofed or
replayed advertisement, presented by a party other than the relay it claims to be, is
possible whenever a consuming system skips the higher-layer authentication RAP assumes.
This is the most common failure category per Appendix E — and the easiest exploit to
teach a new player.

**Player gains:** impersonate a trusted relay; lure ServicePlane traffic toward a relay
you control by spoofing a well-regarded RelayID.

## 8. HopCount Tampering / Forged Propagation (Section 10(d))

Decrementing HopCount by more or less than one, not at all, or altering any other field
in a forwarded record. This is RAP's forgery crime, and per Section 10 it's *detected*
after the fact via SPERB review, never *prevented* cryptographically — deliberately, to
avoid a worse leak (a verifiable custody chain would name every relay in the path). That
design choice is itself an exploitable gap: a forger who moves fast, or who forges
records that never get reviewed, gets away with it structurally, not just by luck.

**Player gains:** kill an advertisement's reach early (hide a relay's existence from part
of a sector) or extend it past H_max (make a relay appear reachable from further than
policy intends) — either direction, undetected unless SPERB happens to audit that hop.

## 9. DTN-Rejoin / Spin-Shift Excuse Abuse

Section 6 and Section 8 both carve out legitimate early-emission exceptions: rejoining
after a DTN partition, recovering from spin-shift occlusion. Both exceptions are
narrow and single-shot by design — "exception belong fo relay coming back online...
exception na fo relay looking fo excuse fo update." A relay that fakes a rejoin event to
justify an off-cycle advertisement is exploiting the one legitimate escape hatch in an
otherwise airtight timing rule.

**Player gains:** an out-of-cycle advertisement that looks legitimate to a casual
observer — useful for slipping a status change past T_adv discipline without tripping
the obvious version of Exploit #2.

## 10. Extension Bit Squatting

Bits 8–15 require CBR registration before use (Section 3.2). An unregistered bit is, per
the RFC's own words, "an interoperability defect awaiting discovery" — which also means
it's a covert channel nobody's specifically watching for yet, right up until CVCO
notices. Early-game exploit: cheap, easy, gets patched (registered/blocked) the moment
it's caught.

**Player gains:** a temporary, low-bandwidth covert signaling channel between
cooperating relays, hidden inside "normal" capability-mask traffic.

## 11. Namespace-Plane Cache Suppression

Section 10(c): a cache that selectively suppresses or delays specific relays'
advertisements is functionally the same fairness violation as Exploit #4, just moved up
a layer. Compromising a Namespace Plane cache node (N2/N3) lets an attacker make specific
relays effectively disappear from lookup results without touching the relays themselves.

**Player gains:** sector-scale relay censorship from a single compromised cache node,
rather than needing to compromise every relay individually.

## 12. Reservation-Endpoint Fishing (Section 4.3 boundary)

C3/A2 hints are "not obviously futile," not a guarantee. A social-engineering angle:
convince operators (or automated reservation logic) that a favorable-looking
advertisement *is* a commitment, then exploit the resulting over-scheduling when
reservation requests get declined anyway. Pairs well with Exploit #3.

**Player gains:** engineered congestion / denial-of-reservation at a target relay by
flooding it with requests its advertised hints imply it should accept.

## 13. SPERB Audit Impersonation (Social Engineering)

Same shape as SET‑2352's SPEAR‑B‑impersonation module, retargeted at RAP: fake a SPERB
compliance inquiry to an operator, demand "clarifying" logs or raw values the operator
believes must be disclosed to avoid revocation. Exploits operator fear of Section 12's
terminal, non-appealable revocation.

**Player gains:** operator hand-over of exactly the raw fields (queue depth, real load,
peer list) RAP was built to keep off the wire in the first place.

---

# II. Mission / Storyline Hooks

## 1. "Seven Rows, Seven Lies"

A vendor's relay line advertises all seven required TLVs correctly-formed and still
manages to leak load through emission jitter (Exploit #2). Prove it before the vendor's
lawyers bury the finding.

## 2. "The Optimistic Fleet"

A shipping contractor's entire relay fleet advertises Optimistic Capacity Classes
(Exploit #3). Player has to decide: expose it publicly (tank the contractor, strand
cargo mid-route that was relying on the false capacity) or quietly extort them first.

## 3. "Open Door, Closed Door"

An OPRA-flagged sector reports Belt relays getting consistently worse admission outcomes
than Inner-Worlds-registered ships, despite every relay advertising A2. Build the
statistical case (Exploit #4) and take it to SPERB — or sell the pattern to whoever's
profiting from it.

## 4. "Ghost Relay"

Someone is spoofing a well-trusted RelayID (Exploit #7) to reroute traffic through a
listening post. Trace the impersonation back to its actual origin using timing and
capability-mask fingerprints the spoofer couldn't perfectly fake.

## 5. "The Hop That Wasn't"

A HopCount forgery (Exploit #8) is suspected in a cargo-loss case — a ship trusted a
record showing a relay three hops closer than it actually was. Build a SPERB Section
10(d) case from a full observed hop-sequence, per Appendix I.2's evidentiary
requirement (a single sample won't do).

## 6. "Storm Season Audit"

Post-storm, a sector's H_max values are stale (Appendix D warns about exactly this).
Player is hired to re-survey actual sector topology via legal HopCount cartography
(Exploit #1) and recommend new values — with a rival faction trying to get the survey
wrong on purpose to strand a competitor's shipping lane.

## 7. "Squatter's Rights"

An unregistered extension bit (Exploit #10) has been in quiet use by a small Belt
collective for months as a covert coordination channel. CVCO is about to sweep and
register-or-block it. Help them migrate the channel before it's shut down, or turn them
in to CVCO for the registration bounty.

## 8. "The Cache That Forgot"

A compromised Namespace Plane cache (Exploit #11) has been quietly erasing a rival
faction's relays from local lookups for weeks. Nobody's relay is broken — the cache
just stopped mentioning them. Find and fix (or exploit further) the compromised node.

## 9. "Compliance, or Else"

A fake SPERB audit notice (Exploit #13) is circulating, and at least one honest operator
has already handed over raw queue-depth logs out of pure revocation panic. Find the
impersonator before real SPERB does — for very different reasons depending on the
player's own relationship with SPERB at that point in the campaign.

---

# III. Game Structures (How RFC‑2353 Becomes Gameplay)

## 1. HopCount Cartographer

Passive collection tool. Aggregates HopCount values from captured advertisements across
many origins and forwarding relays into a live, coarse distance map. Entirely legal
in-fiction — this is the one leak SPERB itself concedes — so the tool can run
continuously in the background without triggering any suspicion mechanic.

## 2. Jitter Scope

Plots emission timestamps for a target relay against the canonical interval it *should*
be holding to. Surfaces drift, load-correlated jitter, and DTN/spin-shift-exception
abuse as visually distinct patterns on a timeline.

## 3. Capacity/Admission Ledger

Tracks a relay's advertised SchedulingCapacityHint/AdmissionPolicyHint history over time
against observed session outcomes. This is the tool that catches both the Optimistic
Capacity Class and Quiet Favoritism exploits — it's a statistics engine dressed as a
logbook.

## 4. Fairness Auditor

Takes the Ledger's raw data and runs the actual bias test: does this A2 relay accept
peers at a uniform rate, or does acceptance correlate with peer identity/origin/hardware
class? Output is admissible-in-fiction SPERB evidence if the sample size clears
Appendix I.3's audit-procedure threshold.

## 5. Forgery Docket

SPERB Section 10(d) case-builder. Requires a full observed HopCount sequence across
hops (not a single sample, per Appendix I.2) before it will even open a case file —
mechanically forcing the player to actually gather the evidence rather than accuse on a
hunch.

## 6. Extension Registry Browser

Read access to CVCO's UUID-S7-keyed extension registry (Section 3.3). Lets the player
check whether a capability-mask bit pattern is registered, to whom (by UUID-S7, never a
human-readable name — the registry itself refuses to leak vendor identity), and flag
unregistered usage for the Squatting exploit or for reporting it.

## 7. Spin-Shift Almanac

Predicts spin-shift occlusion windows for known rotating habitats/stations, so the
player can time an attack, a rejoin-exception abuse, or simply know when a target relay
is legitimately about to go quiet for reasons that have nothing to do with them.

## 8. Prompt-Crafting Console (Social Engineering)

Same concept as 2352's, retargeted: assemble tone/authority/urgency/signature-block to
fabricate a convincing SPERB audit notice, vendor diagnostic request, or DTN-rejoin
justification. Reused UI, new template library.

## 9. SPERB Suspicion Meter

Fake audits, sloppy forgeries, and repeated Fairness Auditor queries against the same
relay all raise it. Crosses a threshold, and a *real* SPERB review gets triggered on
the player's own activity, not just the target's.

---

# IV. Software Tools (Technical + Social Engineering)

## A. Earth Tools (Formal, Bureaucratic, Heavy)

**hopMap‑CBR** — Canonical Behavior Registry's own reference implementation of HopCount
cartography. Slow, exhaustive, produces registry-grade sector maps nobody disputes the
accuracy of. Features: multi-relay correlation, confidence intervals, exportable audit
trail.

**jitterAudit‑TSRB** — TSRB-lineage timing analyzer. Detects T_adv drift and DTN/spin-
shift exception abuse. Features: per-relay compliance scoring, historical drift
trendlines, auto-flags repeat offenders for compliance-notice generation.

**capacityCheck‑RNC** — Relay Neutrality Commission's Optimistic-Capacity-Class
detector. Cross-references advertised SchedulingCapacityHint against observed session
outcomes. Features: vendor-fleet-wide aggregation, "spec sheet vs. reality" delta
reports.

**fairnessForm‑OPRA‑lite** — A watered-down, Earth-bureaucratic port of a Belt fairness
tool, missing most of the nuance. Features: basic peer-acceptance-rate comparison,
generates SPERB-filing-ready paperwork, chronically under-samples (per Appendix I.3)
because nobody funded it properly.

**auditPrompt‑GEN‑RAP** — Reused engine from the 2352 companion's auditPrompt‑GEN,
re-skinned for RAP-specific SPERB terminology. Generates convincing fake compliance
inquiries.

**custodyForm‑10D** — Bureaucratic SPERB Section 10(d) forgery-case paperwork generator.
Features: guided evidence checklist matching Appendix I.2's requirements, official-
looking seals, absolutely nothing that speeds up the actual investigation.

## B. Mars Tools (Efficient, Militaristic)

**redHop** — Aggressive, high-speed HopCount cartography built for rapid sector recon
ahead of a fleet movement. Features: real-time map updates, hostile-relay-density
overlay, no confidence-interval hand-wringing — Mars wants an answer, not a caveat.

**ironBeacon** — Spoofs or jams a tightbeam relay's companion RF beacon (Section 1.6),
either to deny discovery of a target relay or to stand up a fake discovery beacon that
lures traffic toward a Mars listening post. Features: beacon-pattern cloning, selective
jamming radius control.

**driftLance** — Militarized jitter analyzer that doesn't just detect load-correlated
timing drift, it actively induces it — hammering a target relay with traffic timed to
force a compliance failure that redHop's sister tools can then document. Features:
load-injection profiles, automatic drift-threshold detection.

**revokeStrike** — Forged-record generator built specifically to trigger Section 10(d)
findings against a target relay (frame it for HopCount tampering it didn't commit).
Features: plausible-forgery templates, timed to land during a real SPERB audit window
for maximum damage.

## C. Belt Tools (Improvised, Clever, Chaotic)

**hopsniff** — Cheap, everywhere, does one thing: passive HopCount collection off
whatever's already on the wire. Features: no UI to speak of, dumps raw values to a log
you correlate by hand or feed into something better. Every Belt tech has a copy.

**fokaso‑scan** — ("fokaso" — broken/failing) Detects a relay about to fail or
already degrading before it announces anything wrong — reads jitter and structural
drift the way a mechanic reads an engine's sound. Features: heuristic, noisy, wrong
often enough that Belters cross-check it, right often enough that they keep using it.

**kowlwatch** — ("kowl" — all) Fairness watcher, the real inspiration for
fairnessForm‑OPRA‑lite's watered-down Earth port. Tracks admission outcomes across an
entire sector's relays at once rather than one at a time. Features: sector-wide bias
heatmap, flags a relay the moment its acceptance pattern breaks from its neighbors'.

**spinwait** — Spin-shift almanac plus exploit timer in one tool: tells you when a
target's antenna goes dark, and starts a countdown for anything you were planning to do
about it. Features: multi-habitat tracking, occlusion-window alarms.

**erlufshoak** — Belt slang name (from a word for "sweet-talk" filtered through
station-tech jargon) for a social-engineering prompt-crafter tuned for extracting DTN-
rejoin justifications and diagnostic dumps out of overworked Earth-vendor support
lines. Features: low-authority/high-familiarity tone presets, exploits the same
"friendly, not official-sounding" gap belta‑ask used against Earth devices in 2352.

**watimeter** — Cheap unregistered-extension-bit scanner. Flags capability-mask traffic
using bits 8–15 in patterns that don't match any known CVCO registration. Features:
basic pattern library, gets outdated fast, gets recompiled by whoever needs it next.

## D. Universal / Canonical Tools (Definitive Versions)

**Canonical Hop Ledger (CHL)** — The gold-standard, SPERB-recognized version of
HopCount cartography. Where hopMap‑CBR is Earth's bureaucratic implementation and
hopsniff is the Belt's improvised one, CHL is the actual reference standard both are
measured against. Features: registry-grade accuracy, cross-referenced against
Appendix C's test vectors, admissible as evidence without further corroboration.

**Temporal Compliance Engine (TCE)** — Definitive T_adv/jitter analysis, supersedes
jitterAudit‑TSRB and driftLance alike for anyone who needs an answer nobody can
dispute. Features: certified-grade drift scoring, direct SPERB case-file export.

**Fairness Ledger (FL)** — The tool kowlwatch wishes it were and
fairnessForm‑OPRA‑lite pretends to be: statistically rigorous admission-bias detection
that satisfies Appendix I.3's audit-sample requirements by construction, not by luck.

**Forgery Docket (FD)** — Definitive Section 10(d) case-builder. Refuses to open a case
without a full observed hop-sequence (Appendix I.2) — the one tool in this whole list
that actively stops the player from filing a lazy accusation.

**Extension Registry Mirror (ERM)** — Read-only, always-current mirror of CVCO's
UUID-S7-keyed extension registry. The only tool that can definitively tell you whether
a capability-mask bit pattern is legitimate, squatted, or simply unassigned.

---

# V. Suites (Grouped Tools)

### 1. Topology Suite
- HopCount Cartographer (structure) / Canonical Hop Ledger (definitive tool)
- hopMap‑CBR, redHop, hopsniff (faction variants)

### 2. Timing Suite
- Jitter Scope (structure) / Temporal Compliance Engine (definitive tool)
- jitterAudit‑TSRB, driftLance, fokaso‑scan (faction variants)

### 3. Fairness Suite
- Capacity/Admission Ledger + Fairness Auditor (structures) / Fairness Ledger
  (definitive tool)
- capacityCheck‑RNC, fairnessForm‑OPRA‑lite, kowlwatch (faction variants)

### 4. Forgery Suite
- Forgery Docket (structure and definitive tool, same name deliberately — there's no
  faction-specific version worth having, the evidentiary bar is the whole point)
- custodyForm‑10D, revokeStrike (aggressor/paperwork variants)

### 5. Fingerprint Suite
- Extension Registry Browser (structure) / Extension Registry Mirror (definitive tool)
- watimeter (Belt variant); no clean Earth/Mars equivalent — this is a specifically
  improvised, under-the-radar category, which is itself worth using narratively

### 6. Social Engineering Suite
- Prompt-Crafting Console (structure)
- auditPrompt‑GEN‑RAP, belta‑ask-lineage erlufshoak (faction variants)
