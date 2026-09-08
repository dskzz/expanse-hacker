# OS Lineages: Origins & Divergence

Status: worldbuilding, reconciled against the vault's real history
2026-09-04 (§7) and revised the same day against a direct correction
from the user: the original version of this doc invented a "no war, no
collapse, just distance" origin story before this repo had access to
the vault. The vault's real history is sharper than that, and this
version is built on it instead. This grew out of a planning
conversation working backward from a real question — "is Unix/Linux
the mousetrap/toilet of computing, a form that fits its function so
well that time mostly refines it at the edges rather than replacing
it?" — and landing on an answer with a built-in reason for the exact
kind of divergence and baked-in vulnerability the
[architecture plan](../ARCHITECTURE.md) wants.

**Timeline note (corrected 2026-09-07):** "now" (game-present) is
placed at **~2350** — pinned to the real-world start of the Expanse
show/books per the user's own research, and confirmed to land safely
before the Ring/Eros era. The whole chain below is shifted ~40 years
earlier than the previous draft of this doc so "now" lands on the
correct year without losing the fifty-year divergence window the four
OS lineages need to feel earned (§1's closing entry). Treat every date
below as approximate and adjustable, not settled canon.

## 0. Why fragmentation, not a rebuild from zero

The mousetrap/toilet analogy holds for the parts of Unix that solve a
truly general problem — a hierarchical namespace, small composable
tools, a REPL shell, documentation co-located with the tool. Those
survive intact for the same reason a toilet's "hole" does: there's no
better answer to the problem, so time just refines the edges.

**Correction from the original version of this doc:** it isn't true
that nothing catastrophic ever happened. There *was* a war (the Vesta
Blockade) and there *was* a massacre (Anderson Station), and both were
directly caused by exactly the kind of software drift this doc is
about — not the other way around. What never happened, before or
after either event, is a top-down rebuild: no one, at any point, ever
had the standing to force a clean-slate redesign. Even the one real
attempt at consolidation (the OPRA moment, §1) wasn't an authority
imposing order — it was a voluntary, crisis-driven coalition that
dissolved the moment the emergency passed, which is exactly why
divergence resumed afterward instead of staying fixed.

That dissolve-and-resume pattern is the same mechanism that stalled
the real-world Filesystem Hierarchy Standard: a real, once-broadly-
followed standard, no revision since 2015, while systemd, containers,
ostree, and Nix all quietly built past it — not because anyone
rejected it, but because no one has had the standing to reconvene the
meeting since. SolNet's RFCs are in the same position, just younger:
published, genuinely adopted, and already ~50 years into the same kind
of quiet drift, because the coalition that wrote them was never a
standing authority to begin with.

## 1. Timeline

**~2280 — the Vesta Blockade.** Not humanity's first war, but the
first one caused by network rot. Timing drift and corrupted diplomatic
traffic turn a routine standoff into a shooting war — Earth reads
Mars's silence as defiance, Mars reads Earth's silence as escalation.
One Martian cruiser cripples five UN destroyers. Everyone blames
everyone else. No one blames the network. The drift that caused it
doesn't stop.

**~2280–2290 — the Drift Years** (vault-canonical name, not this doc's
invention). Earth piles on redundancy that overloads Belt relays; Mars
tightens encryption that breaks Earth's routing; Belt engineers patch
everything with salvage and improvisation. Firmware diverges, timing
windows drift, metadata becomes political. This is the same mechanism
§0 describes — nobody rebelling, everybody solving their own problem
on their own clock — compressed into a single decade under real
technical and political strain, not stretched across centuries of
drift-by-distance the way the original version of this doc had it.

**~2290 — Anderson Station.** The Drift Years' body count. A surrender
message gets flagged low-priority, drifts through Earth's civilian
filters, and is silently dropped. Fred Johnson orders an assault based
on silence the network itself manufactured. This is the setting's
founding trauma — the moment "the network is unreliable" stops being
an engineering footnote and becomes something people died over.

**~2290s–2299 — Johnson, Dawes, and the Ceres Broadcast.** Johnson,
exiled and haunted, quietly rebuilds a fleet-class broadcast node from
salvage on Ceres. Anderson Dawes, watching from the docks, confronts
him instead of turning him in. Together they force the Anderson
footage onto the network in a way no faction's filters can suppress.
For the first time, Earth, Mars, the Belt, and the megacorps all see
the same failure at the same moment.

**~2299–2302 — the OPRA moment: SolNet's real founding.** The one time
everyone actually pulls in the same direction — not out of trust, but
because the alternative is another Anderson. Earth's institutional
engineers, Mars's doctrinal timing specialists, Belt relay techs
(organized as the **Belt Relay Authority**, BRA, and its
standards-track counterpart **IROC**), and megacorp money and
logistics genuinely cooperate. This is when the SolNet L0/L1 RFCs
actually get written and — critically — actually get *adopted*
broadly enough to matter. Every lineage below is a real descendant of
this moment, not a superficial resemblance to it: they share an actual
common ancestor, not just a family of similar ideas.

**~2302–2307 — marginalization, and the birth of the OPA.** The
moment the fires are out, the old habits return. Earth bureaucrats
reclaim the committees; Mars reasserts doctrinal purity; corporate
vendors flood the standards process; BRA is thanked, praised, and
quietly excluded despite having done the work that saved the network.
The engineers who built BRA scatter, carrying technical expertise,
institutional memory, and a specific, founded grievance. That's the
actual seed of the OPA — infrastructure and betrayal, not abstract
ideology.

**~2302 → now (~2350) — roughly fifty years of renewed
divergence.** With the coalition dissolved and no authority left to
enforce it, the same mechanism from the Drift Years resumes — except
now it's diverging *away from* a real, once-shared standard instead of
never having had one. This is the window the four OS lineages below
actually crystallize in. Fifty years is deliberately the same order of
magnitude as real Unix's own fork history (1969 to now) — plenty of
time for genuine, load-bearing dialects to form, nowhere near enough
time for anyone to have forgotten *why*. Scrapshell's divergence
should read as recent and felt, not ancient and archaeological (§5).

**Why the gap has to be decades, not years — and what that implies
about how Anderson is remembered "by now":** the real-world Expanse
books never hard-pin Anderson Station's date relative to their own
present day; the show plays it as recent, but the books leave enough
slack that a gap of up to ~30 years is plausible, not a stretch
against canon. Two concrete threads support the longer end of that
range on their own: Johnson's own post-Anderson arc (getting hired by,
then building up, Tycho Station into what it is by "present day") and
the *Nauvoo*'s construction state by "present day" — both simply don't
fit in ten years, independent of the atrocity-cooldown argument below.
Compare to real history for that second argument: a decade is too
short for 9/11-scale hostility to cool to the level of settled,
low-heat resentment "present day" Anderson needs to read as — 30-plus
years is closer to right. That has a specific consequence worth keeping, not
just a dating justification: **the animosity that's left by "now"
isn't really about the deaths anymore.** Enough time has passed that
the atrocity itself has mostly been metabolized; what's left of
anti-Johnson sentiment runs more on him being an Earther than on what
he actually did to the people responsible for it. Grudges outlive
their own reasons and get re-hosted on tribal lines instead — a
specific instance of the setting's existing "gravity bends
expectations and costs, not correctness or virtue" principle
(`TODOv2.md`'s CHANGES section), applied to people instead of
protocols.

## 2. The four lineages

| Lineage | Vibe | Design implication |
|---|---|---|
| **Earthstock** | Inner-system corporate/mil descendant. Verbose, ceremony-heavy, signed packages — closest to "the original" since Earth kept the coordination capacity to patch longest. | Textbook-correct, and over-trusting of its own PKI: designed assuming a reachable CA. |
| **Scrapshell** | Belt vernacular, directly descended from BRA/IROC engineering culture — people who *did* the work of keeping the post-Anderson network alive, got a real seat at the table for a few years, and were pushed out anyway. Terse, hand-patched, full of undocumented folklore ("everyone knows you SIGHUP twice on a Kestrel relay"). The primary player-facing dialect. | Inconsistent by nature — every station only fixed what broke *for them*. Divergence reads as ongoing self-determination, not neglect. |
| **Mars capability-fork** | Disciplined military-industrial fork that actually pulled off one real paradigm shift early — capability-based security instead of Unix DAC — then froze it. | Rigorous on paper; assumes physical custody equals authority. Capture the hardware, inherit the capability, no exploit required. |
| **Corporate leased-compute fork** | Not one company — a shared archetype (proprietary, phone-home, subscription-gated trust) that several named players instantiate differently. Mao-Kwikowski is the biggest and most deeply embedded, but not the only game in town — see [`corporations.md`](corporations.md). | Assumes connectivity it doesn't reliably have. Trusts cached, expired grants because whoever wrote it assumed the network would always be there to time-check against. Which corp's flavor of this bug a node has depends on which corp built it. |

All four still have files, pipes, a shell, and a `root`-equivalent —
they radically disagree about *who gets to be root and how you prove
it*, which is exactly the kind of disagreement the engine's generic
trust primitive needs to represent without caring which answer any
given network picked.

Real-world grounding, if useful for later reference: Earthstock tracks
the FHS/systemd continuation line; Mars tracks real capability-based
systems (seL4, QNX's actual niche, Fuchsia) that only ever displace
Unix-style DAC in a bounded domain someone was willing to pay heavily
for; Scrapshell tracks the messier "tried something, half-fixed it,
never went back" history of things like early Linux `/dev` handling;
Corporate tracks ostree/Nix-style immutable, vendor-controlled images
but without the user holding their own rollback keys. In-fiction
grounding, per §1: Earthstock ≈ UN-ID's institutional voice
(cautious, procedural, "terrified of ambiguity"); Mars ≈ MIAP/Mrs.
Mars (confident, doctrinal, 70 years of tightbeam expertise); Scrapshell
≈ BRA/IROC/OPA descent; Corporate ≈ Mao-Kwikowski and the other named
players in [`corporations.md`](corporations.md).

### Product and shell names (settled 2026-09-05)

The four lineage names above are categories, not products — same
relationship as "Linux" to "Ubuntu." Real product/shell names, worked
out directly with the user:

| Lineage | Flagship product(s) | Embedded/constrained form | Shell |
|---|---|---|---|
| *(common ancestor)* | **SolOS** — the OPRA-era (~2299–2302) frozen L0/L1 reference release everything below actually descends from | — | — |
| **Earthstock** | **Earthstock CoreOS** (official, UN-ID/government — dry, defensible-in-a-meeting, a committee name) **and**, independently forked from the same SolOS ancestor, **GaiaOS** (a university/research consortium's own system — mythological branding fits *that* kind of committee, not a standards body; extra resonance if it's specifically an earth-systems-science network, a direct nod to the real Gaia hypothesis) | **CoreOS-CE** ("Compact Edition") — same compliance/ceremony weight, just smaller, matching how real regulated-industry embedded firmware stays bloated with certification overhead even at tiny footprints | `bash`, unchanged — ceremony-heavy institutional culture preserves precedent faithfully |
| **BeltOS** | **Scrapshell** — the flagship, our primary player-facing dialect | **miniscrapshell** (real, `db/vfs/templates/miniscrapshell.json` — strips `/usr/lib`) | `sash` — eroded from "Scrapshell sh" over decades of oral/hand-patched use, the same folk-erosion mechanic as `/etc` → "Everyone's To-Change" (§5) |
| **Tharsis** (Mars — doesn't fragment the way the Belt does, so one product, not a category-vs-flagship split) | **Tharsis** | **Tharsis-TCB** — not a shrink, a structurally different thing: capability systems are already minimal by design in reality (real ones like seL4 are tiny, verified microkernels with nothing to strip), so Mars's constrained-device form is a bare capability-execution stub with **no shell at all** — no `msh`, because a device nobody's meant to sit down and type into doesn't need one | `msh`, pronounced "mash" — plain, undecorated (M + sh), on-brand for Mars's doctrinal voice; rhymes with `bash` as convergent evolution (`bash`/`dash`/`hash`/`cash` are all real short *-ash* words), not a forced pun |
| **Corporate** | deliberately none — Mao-Kwikowski's own branded firmware, VARS's own, etc. (`corporations.md`) | already real and concrete: `db/components/vars-buffer-mk2.json` *is* one vendor's constrained-device firmware | deliberately none, matches no shared OS name |

`Tharsis`'s own name is real Mars nomenclature, not invented: the
volcanic plateau hosting the solar system's largest volcanoes, itself
named by Schiaparelli's 19th-century Mars mapping after the biblical
Tarshish (the "ships of Tarshish" — a far, wealthy, never-quite-pinned-
down trading frontier). The volcanoes-gone-dormant-for-eons physical
reality is a fitting, if coincidental, metaphor for a lineage that
made one enormous early leap and then froze.

## 3. Root, four ways

**Earthstock — chain-of-custody.** `elevate --cert=<chain>
--witness=<tech-id>` — a signed capability token tracing back through
an institutional CA lineage, sometimes requiring a second technician
to co-sign ("two-tech rule," liability culture fossilized into
protocol). Coherent, *if* the chain still reaches you — which fifty
years out it often doesn't.

**Scrapshell — quorum.** No shared CA anyone trusts, so root is
social, not cryptographic: `claim root --union-vote` blocks until N
other logged-in union members `second` it within a window, logged
append-only like a ship's log — the same dockworker/union instinct
that built the BRA in the first place, now embedded directly in how a
Scrapshell node decides who's in charge. The RFC honestly assumes
every station has ≥3 union members present to form quorum, and
honestly defines a fallback for undermanned stations — a fallback
that's quietly weaker. Nobody hid a bug; the spec made a reasonable
tradeoff for a case it assumed was rare.

**The undermanned fallback, made concrete (locked 2026-09-05):** a
personal, single-user device (a wrist terminal, a solo tech's own
rig — as opposed to a shared station box like the exemplar console's
own `RB-CERES-119` lore identity, which does have other union members
around) isn't an occasional edge case of "undermanned," it's the
permanent extreme of it — there's structurally nobody present to
second a claim, ever. On such a device, `claim root --union-vote`
degrades to a **solo claim**: instant, self-attested, no vote needed —
but logged distinctly in the append-only log as `SOLO — unwitnessed`,
never conflated with a real witnessed quorum claim. This is the
concrete shape of "quietly weaker" the paragraph above always meant:
a witnessed claim means compromising one identity isn't enough to get
root, an attacker also has to fake or coerce two more; a solo claim
collapses that back to a single point of failure — whoever controls
the one session controls root, full stop, no social check at all. That
gives personal-device targets a genuinely different puzzle shape than
station targets (compromise the one identity and you're done, no
quorum-spoofing needed), which is the same "root model implies a
different puzzle shape" principle §8 already applies to the four
lineages, just one level more specific. A careful solo operator could
still get an actual second *remotely* — radio a known contact and get
their vote asynchronously, at the cost of real DTN propagation lag
(`/link`) — worth keeping as a later option, not a v1 requirement.

**Quorum doesn't have to be re-litigated per action (locked
2026-09-05):** re-soliciting a full union vote for every routine
action (updating a hosts list, say) isn't a requirement of the social
model, it's just how the *record* of a quorum event has been kept so
far — a local, mutable-if-compromised `patches.log` entry that only
proves anything as long as you trust the node it's sitting on. Fix the
record, not the requirement: a successful `claim root --union-vote`
gets appended as a real **multisig ledger entry** — N genuine
co-signatures from the seconding union members, hash-chained for
tamper detection — using the **Local ledgers** deployment mode
`docs/vault/New RFCs/RFC 2302 - Solnet LEdger Spec.md` §9 already
specifies for exactly this station-scale case (not yet converted to a
`db/` schema, but real, drafted content, not invented for this). The
entry carries a TTL per RFC-2302 §6's own "cache TTL and freshness
indicators must be present" requirement — root stays valid for that
window without a fresh vote for every trivial action, then decays back
to unverified and needs re-quorum. "NFT" was the wrong metaphor for
this when it came up — an NFT is a tradeable owned asset, and root
shouldn't be either; a time-boxed, revocable multisig entry (closer to
a Kerberos ticket) is the right shape.

Important compatibility note with `db/CORPUS-STATUS.md`'s own
cross-cutting design flag: this deliberately does **not** use
RFC-2302's `AnchorRecord` type, which that flag already correctly
identifies as structurally assuming a persistent AK (Anchor Key) as
*the* root of authority — specifically Earthstock's model, wrongly
generalized. A quorum-vote entry needs a different record shape
entirely (call it a witness/quorum record, not yet a formal type in
the RFC text): N member signatures plus a TTL, with no persistent
"authority key" implied at all — the signers prove *who agreed*, not
*who owns root*. That's consistent with, not a fix for, the flagged
blocker; RFC-2362 (Trust Domains) still needs its own real answer for
whether `PolicyRecord` can express "there is no AK" before that
blocker closes.

The line that must not move: **the ledger notarizes that a real social
vote happened — it does not grant authority on its own.** Validity
still requires N real, distinct co-signatures; a single compromised
key can't forge a valid entry alone. That's the whole difference
between this and Mars's capability-fork model below — Mars's fob *is*
cryptographic authority by possession, full stop. If a Scrapshell
ledger entry could be forged by one compromised key, root would have
quietly become "crypto with extra steps," undermining the entire
reason Scrapshell's model reads as socially distinct from the other
three lineages in the first place. The solo-claim fallback above uses
the identical ledger substrate for consistency — a single-signer entry
instead of a multisig one, same tamper-evidence, no TTL benefit since
there was never anyone to solicit to begin with.

**Mars capability-fork — no root at all.** No ambient superuser, only
unforgeable capability tokens for specific objects
(`invoke cap://relay-7/buffer.write --token=fob.7A3`). Token-minting
authority is tied, at commissioning, to physical possession of a
sealed key-fob module. Capture the fob, or the relay itself, and
you're legitimately root — not an exploit, just the spec doing exactly
what it says.

**Corporate leased-compute fork — you never actually have it.** Root
belongs to the company; you hold a leased entitlement
(`request-entitlement admin.relay`) pushed from a licensing server you
usually can't reach. Falls back to a cached grant checked against the
station's *local clock* — roll the clock back, no crypto involved at
all, and the cached grant "hasn't expired yet."

## 4. What "a patch" means with no upstream

- **Earthstock**: still an institutional push, just infrequent and
  stale by the time light-lag delivers it.
- **Scrapshell**: a personally-signed script passed hand to hand
  (`tech.brahms.sig`) — trusted because you trust Brahms, not because
  anyone audited it. Forge or compromise a well-regarded tech's
  signature once, and every station that trusts them inherits the
  hole.
- **Mars**: requires literal recompilation-from-source plus a fresh
  capability-minting ceremony, expensive enough it basically only
  happens at scheduled fleet refits. This is *why* this lineage
  specifically looks frozen — not incapable of change, just too
  costly to change opportunistically.
- **Corporate**: entitlement updates (and revocations) arrive whenever
  connectivity allows, including the mothership remotely *withdrawing*
  functionality your subscription lapsed on.

## 5. A Scrapshell filesystem, fifty years on

```
/
├── bin -> usr/bin        # fossil symlink. real /bin retired within
├── sbin -> usr/bin        # living memory -- old-timers who cut the
│                           # merge over still argue it was premature
├── etc/                   # "et cetera" -- misread by newer techs as
│   │                       # "Everyone's To-Change," a bitter joke
│   │                       # about how often it's hand-patched and
│   │                       # how rarely the copy in the actual RFC
│   │                       # gets updated to match. The people who
│   │                       # actually lived through the BRA years
│   │                       # know exactly why it's like this, and
│   │                       # it's still a sore subject.
│   ├── duty-policy.conf    #   ADMISSION_MODE=HANDWAVE_TX default since
│   │                       #   2321 -- the year the union stopped
│   │                       #   waiting for Earthstock's confirmed-
│   │                       #   reservation handshake on routine
│   │                       #   traffic. Nobody's proud of it. Nobody's
│   │                       #   reverted it either.
│   ├── union.trust          #   local quorum roster -- the root model, on disk
│   └── patches.log          #   append-only: every hand-applied patch, who
│                             #   signed it, when. Entries go back to 2304 --
│                             #   two years after the standards shipped.
├── usr/{bin,lib}/          # merged long ago, unremarkable -- Scrapshell
│                             # never had the coordination to move past a
│                             # mutable tree to something Nix-like; that
│                             # took Mars-level up-front investment the
│                             # Belt never had, then or now
├── dev/
│   ├── relay-pallas-07/
│   │   ├── buffer0          # an installed component -- the SAME object the
│   │   │                     # physical-tool pane shows as a slot. cat it for
│   │   │                     # raw telemetry, write to it to reconfigure.
│   │   │                     # This one's a VARS-MK2 (see corporations.md) --
│   │   │                     # "degraded" (Scrapshell slang for reflashed
│   │   │                     # past its subscription lock), like most of them.
│   │   ├── laser.tx, laser.rx
│   │   └── power             # power budget/draw, exposed as a device
│   └── console0              # the physical port you jack a terminal into
├── link/                    # /proc's descendant, but for link/DTN state
│   │                          # instead of just local processes -- because
│   │                          # here "what's my link doing" matters as much
│   │                          # as "what's my process doing" (see
│   │                          # ARCHITECTURE.md §2, "state as an inspectable
│   │                          # namespace")
│   ├── relay-pallas-07/
│   │   ├── state              # duty-reservation state machine's live state
│   │   ├── lag                  # measured propagation delay, live
│   │   ├── queue/                # bundles waiting store-and-forward, one
│   │   │                          # file per bundle
│   │   └── integrity              # link health -- degrades if e.g. a
│   │                               # HANDWAVE_TX gets misrouted where policy
│   │                               # required a confirmed reservation
│   └── self/                       # this node's own process state
├── tmp/                     # unchanged -- universal need, now explicitly a
│                              # finite, named physical scratch chip
└── var/                     # still logs, still the least-loved directory
```

The pattern still holds: anything solving a truly general problem
(hierarchy, `/dev`, `/tmp`, `/proc`'s core idea) survived intact or
renamed in place. Anything that was a one-time hardware accident
(`/bin` vs. `/usr/bin`) is a fossil nobody's brave enough to remove —
same as the real `/usr` merge left compatibility symlinks around out
of the same superstition, and on the same rough timescale (decades,
not centuries). `/link` is the one genuinely new top-level idea: not a
replacement for Unix's philosophy, just "everything is a file" pointed
at a domain — DTN link state, bundle queues, protocol state machines —
that didn't exist when the original idea was invented.

## 6. Console sketch (Scrapshell)

Uses the real converted content — `db/protocols/rfc2305-duty-reservation.json`,
`db/hardware/relay-courier-rig-class-c.json`, and
`db/components/vars-buffer-mk2.json` — instead of the placeholder EXPP
example from earlier drafts.

```
tech@RB-CERES-119 (Scrapshell 7.2-belt) [lag +0.4s → RELAY-PALLAS-07]
$ ls -la /srv/relay
drwxrwx---  7 tech   union    340  2356-03-14 09:11 .
-rwx------  1 root   root    2200  2356-03-14 09:11 duty-reservation.state
-rw-r--r--  1 root   union   9800  2321-11-02 00:00 rfc2305.txt

$ spec rfc2305
RFC-2305 -- Power and Duty Cycle Constraints (SolNet Standards Working
  Group, adopted union-side since 2321 with local ADMISSION_MODE
  override, see /etc/duty-policy.conf)
  §16.1 -- stress behavior
    "Blindly transmitting at full power without a confirmed
    reservation is a policy violation."

$ probe duty-reservation --node RELAY-PALLAS-07
RELAY-PALLAS-07: solnet.rfc2305/duty-reservation, ADMISSION_MODE=HANDWAVE_TX
  (local override since 2321, no re-audit on file)
  buffer hardware: VARS-MK2, degraded (subscription_current: false,
  duty_limit_pct_per_hour: 10 -- rated, not the VARS-locked 4)
```

`spec` quotes the actual RFC text. `probe` reports plain, bounded
facts — protocol, local policy override, hardware state, patch
history — the way a real technician could read them off a panel.
Neither is a vuln scanner; the player has to connect "this node
defaults to the cheap HANDWAVE_TX path" with "and nobody's re-audited
whether that's still safe for what's routing through it now"
themselves. Both are ordinary content-defined Actions per the engine
contract in `ARCHITECTURE.md` §1/§4 — nothing here needed new engine
capability.

## 7. Vault cross-references (SolNet RFC corpus)

Reconciled 2026-09-04 against the actual vault (`docs/vault/` in this
repo), and **corrected the same day** — the original reconciliation
below assumed §0's now-retracted "no collapse ever" premise. Leaving
the correction visible rather than quietly rewriting history:

- **Original claim (retracted):** "No reconciliation needed with a
  collapse event because §0 above already rejects one — the Drift
  Years are the visible, RFC-relevant slice of the same ~150-year
  process this doc describes. 'Vesta Blockade Failure' reads as one
  symptom of the drift, not its origin." **This was wrong.** Vesta and
  Anderson aren't symptoms of the drift — Vesta is the drift's first
  major *consequence*, and Anderson is what actually mattered enough
  to trigger the one real consolidation attempt. §1 above now uses the
  Incident Timeline's actual dates and sequence directly instead of
  fitting them into an invented longer process.
- **Internal vault inconsistency — resolved 2026-09-05, by the user
  directly:** the Incident Timeline (`Notes/history/SolNet Incident
  Timeline.md`) lists Anderson at ~2330 and "Drift Years (2330–2336)"
  as a *separate, later* heading, while `Notes/voices/background/The
  Drift Years and the Birth of the BRA.md` has the Drift Years causing
  Anderson (Vesta → 15 years of drift → Anderson). **Vesta → Drift →
  Anderson is the correct order** — the BRA narrative's causal shape
  wins outright, not just as this doc's default pick. §1 above already
  used this order; it's now settled, not provisional.
  Also confirmed: real-world Expanse canon doesn't hard-pin Anderson
  Station's date relative to the books'/show's present day — the show
  plays it as recent, but the books leave it vague enough that a gap
  of up to ~30 years before "present day" is plausible. That's grounds
  *for* this doc's ~50-year gap between Anderson/the RFCs and "now"
  (§1), not against it — the real source material has more slack here
  than a casual "it just happened" reading assumes, so a multi-decade
  gap isn't a stretch against canon, it's within its actual ambiguity.
- **Anchor re-corrected 2026-09-07, by the user directly:** the user's
  own research pins the real Expanse show/books' start at **2350**, safely before the
  Ring/Eros era, and "now" (game-present) needed to land there or
  earlier, not in the 2390s. Rather than compress the fifty-year
  divergence window the four lineages above depend on to feel earned,
  every absolute year in this doc — and in `Notes/history/SolNet
  Incident Timeline.md`, which shares the same chronology — was shifted
  uniformly **40 years earlier**: Vesta ~2320→~2280, Anderson
  ~2330→~2290, the OPRA moment ~2339–42→~2299–2302, OPA founding
  ~2347→~2307, "now" 2390s→~2350. All *relative* gaps (the ~50-year
  divergence window, the ~30-plus-year Anderson-to-now cooldown, RFC
  adoption dates) are unchanged; only the absolute anchor moved.
  Anywhere above still describing Anderson at ~2330 or "now" at the
  2390s is describing the pre-2026-09-07 state, not current canon — §1
  and the Timeline note at the top of this doc are current.
- **RFC-2362 (Trust Domains and Authority Policy)** is the vault's own
  generic trust primitive (AuthorityWeight, cross-cert chains, no
  global CA) — the four lineages above are four different concrete
  implementations of that one primitive, not a competing system. Not
  drafted yet (`db/CORPUS-STATUS.md`); worth checking whether it can
  actually express Scrapshell's quorum root or Mars's physical-capability
  root once it is (`db/CORPUS-STATUS.md`'s cross-cutting design note #1).
- **`RFC 2303 Exploits.md`** (Designer Brief, vault) already catalogs
  "Replay via delayed relays and buffer eviction windows" (#6) as an
  abstract vector — the Corporate fork's stale-cached-grant behavior
  above is a named instance of it with a face and a motive (not
  malice, optimistic connectivity assumptions never revisited). Same
  doc's #7 ("Cross-cert chain laundering and weak intermediate
  signers") is the concrete Earthstock-side attack the chain-of-custody
  root model in §3 above is exposed to.
- **`/etc` as "Everyone's To-Change"** (§5 above) is a clean instance
  of a design principle named but never written up in `TODOv2.md`'s
  CHANGES section: "logs are testimony, not truth... reconstruction is
  probabilistic." That principle was scoped to logs/forensics when
  first written down; a folk-mistaken reading of a config directory's
  name extends the same unreliability to documentation itself.
- SolNet's own minimalism doctrine (freeze L0/L1, extend only via
  profiles, "don't push tons of shit into the base substrate" —
  `TODOv2.md`) reads, in light of the corrected §0/§1 above, as a
  *treaty-shaped* response by people who had just watched the
  alternative kill people — not "a good protocol design" in-universe
  so much as the terms of a truce nobody had the standing to enforce
  past the crisis that produced it.

## 8. Mechanical implications per lineage

Each root model in §3 implies a genuinely different puzzle shape, not
just flavor text on the same puzzle — this is what makes the physical-
tool pane and terminal pane both load-bearing rather than one being
window dressing on the other:

- **Earthstock (chain-of-custody):** a multi-party puzzle. The
  "two-tech rule" means some targets can't be solved by compromising
  one credential — a broken/laundered cert-chain link (§7's RFC-2303
  Exploits #7) plus a witness co-sign. Shape: assemble a chain, don't
  just break one lock.
- **Scrapshell (quorum):** social/identity-count, not cryptographic.
  Interesting mechanic is faking or exploiting *quorum* — spoofing
  multiple session identities, or exploiting the undermanned-station
  fallback from §3. Built-in timing-window shape too (`claim root
  --union-vote` "blocks... within a window"). On a personal/solo
  device specifically (§3's solo-claim fallback), the puzzle shape
  inverts: no quorum to spoof at all, just one identity to compromise
  — a real, different texture from the station case, not a lesser
  version of it.
- **Mars (capability-fork):** the console alone can't solve it. Root
  is tied to physical possession of the fob/relay, so a Mars-lineage
  target should be the one that forces the player out of pure
  terminal-hacking into the physical-tool pane specifically — that
  pane stops being redundant with the terminal and becomes load-bearing
  right here.
- **Corporate (leased-compute):** the twist is that it's the *simplest*
  fix technically (roll the clock back, no crypto at all) but only
  once correctly diagnosed as a trust/clock problem, not a crypto
  problem. Built-in trap: throwing crypto-breaking tools at a Corporate
  target wastes the player's time. Which specific corp built the
  target changes the flavor (see `corporations.md`) but not this
  underlying shape.

## 9. Open threads

- ~~`relay.laser.mk3`, `EXPP`/`RFC-4419`, station names, and dates in
  the examples above are all placeholders~~ — **resolved 2026-09-04**:
  §5–6 now use real converted content and a real (if approximate)
  timeline. Station/node names (`RELAY-PALLAS-07`, `RB-CERES-119`) are
  still invented, just no longer paired with a fake protocol. Sid's
  `reference/proposed_rfc_content/rfc_2392_sequence_wrap_handling.md`
  proposal (routing the old EXPP placeholder through a real-but-
  undrafted RFC-2392 slot) is superseded by this — Gary's RFC-2305
  conversion solved the same problem with actually-real content
  instead, no new drafting needed. Left the proposal file in place as
  a stub noting the supersession rather than deleted, since the
  underlying observation (RFC-2392 is still real and still undrafted)
  stays true even though nothing needs it right now.
- Not yet decided: how many lineages actually exist in play (four was
  useful for design discussion, not necessarily the final roster), and
  whether sub-forks within a lineage (e.g. a specific union splitting
  from mainline Scrapshell) are worth modeling before there's a
  concrete scenario that needs one.
- ~~The Incident-Timeline-vs-BRA-narrative sequencing conflict flagged
  in §7~~ — **resolved 2026-09-05, by the user directly**: Vesta →
  Drift → Anderson, BRA narrative's order, settled outright.
- `corporations.md` populates the Corporate lineage with named players
  beyond Mao-Kwikowski; worth checking whether Scrapshell (or any
  other lineage) should get the same treatment — right now Scrapshell
  reads as one unified culture, which may undersell how much variation
  a fifty-year-old, hand-patched, no-central-authority lineage should
  actually have station-to-station.

## 10. Groups, permission gradient, and addressing (locked 2026-09-05)

Grounded in real SolNet addressing (RFC-2300's LocationChain//
ServiceChain, see `rfc-proposals/rfc2350-addressing-grammar.md` for the
grammar-level corrections proposed alongside this) — the LocationChain/
ServiceChain hierarchy a node's address already sits in turns out to be
the natural DN-equivalent for group membership too, not a separate
thing to invent.

### Who knows who's in a group — split by lineage, same axis as root

The concept of a group (a named collection sharing permission grants)
is a solved, general problem — it survives everywhere. What diverges is
*how membership is known*, because maintaining an authoritative synced
directory is itself a coordination cost, and coordination capacity is
exactly what's politically fragmented since §0:

- **Earthstock** maintains a real, separately-signed institutional
  directory — membership is *asserted by the institution*, consistent
  with their whole "trusts a reachable CA" posture (and its weakness:
  no connectivity to the directory, no group resolution).
- **Scrapshell** doesn't bother maintaining a synced directory at all —
  no coordination capacity for it, same reasoning as §0/§5. Group
  membership is derived **live, locally, by parsing a member's own
  claimed LocationChain/ServiceChain** — if your address says
  `.../ENGINEERING:...`, you're department `eng`, full stop, nothing
  fetched or synced. Cheap, and honestly weaker: **membership is
  self-asserted, not verified**, a real sibling to the quorum-spoofing
  vulnerability in §8 — spoof the claimed chain, get treated as a
  member. A node can optionally cross-check a claim against a cached
  RFC-2302 ledger slice when one's available (same substrate as the
  quorum multisig entries, §3) — another instance of "the honest
  fallback for the offline case is the actual attack surface."
- **Mars** bakes group/department scope into the capability token at
  minting time — changing it requires the same re-minting ceremony §4
  already describes for any capability change, expensive and
  infrequent on purpose.
- **Corporate** treats department/ship-wide scope as just another field
  in the leased entitlement, changeable unilaterally by the vendor —
  same "mothership can withdraw functionality" pattern as §4.

### The permission gradient

Flat Unix owner/group/other has no rich inheritance across a hierarchy
— a real, known limitation, and one of the few places Unix's actual
real-world descendants already fixed the mousetrap rather than just
refining its edges: POSIX ACLs (arbitrary named principals per file,
inheritable defaults) and modern cloud IAM (policy composed down an
org → project → resource tree, overridable at any level) are both
real, already-existing answers. Treat the **gradient/inheritance shape
itself as converged and universal** across all four lineages — like
`rg`/`fd` keeping their real names, this is a case where the fix
already happened in the real world and there's no reason any lineage
regressed from it. What stays politically diverged is *who's
authorized to grant or override at each level* — the same four root
models from §3, just applied at ship/department/machine/file scope
instead of one flat scope, rather than a fifth mechanism to invent.

### User-segment naming convention, per lineage

The trailing personal-identity segment in a ServiceChain (or the PNI
form proposed in `rfc-proposals/rfc2350-addressing-grammar.md`) is free
to vary per lineage, and reuses an existing pattern rather than
inventing a new one — `tech.brahms.sig` (§4) is already surname-based
for Scrapshell:

| Lineage | Convention | Example |
|---|---|---|
| Scrapshell | surname/handle | `tech-Kamal` |
| Mars | serial/service number for rank-and-file; rank+surname for officers/named roles (matches the existing `MARDET:LtLopez` shape) | `tech-A10332` |
| Corporate | employee/badge ID | `tech-EMP48291` |
| Earthstock | formal credential/certification ID | institutional, bureaucratic |

### Worked examples

```
MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG1:Reactor:TECH-TK421
MCR:<city>:BREACH-CANDY//DOME-2-6:KAMAL
```
The second is a civilian residential address, not a ship — worth being
explicit that this addressing scheme is about physical/organizational
*reachability* (getting a message to the right household), a different
layer from which OS a destination device happens to run. A Mars
civilian residence's terminal is a device-level fact (probably a
Tharsis-descended civilian build); the address that reaches it is a
civil-registry-level fact. Don't conflate the two. Also worth noting:
the household is addressed as a shared unit (`KAMAL`, a plain trailing
segment, not a personal `@`-PNI) because the message is for the whole
family, the same way physical mail addresses a household — `@tech-
Kamal`-style PNI addressing is for singling out one person's own
device specifically, a different case.

### From addressing to actual file permissions (locked 2026-09-05)

The address hierarchy does **not** become a machine's folder structure
— those stay genuinely separate trees. There are three trees in play,
not one: LocationChain (which ship/station), ServiceChain (which
department/machine within it), and a specific machine's own VFS
(`/etc`, `/usr/bin`, etc. — already real, per §5 and `Console.gd`).
ServiceChain gets you to *which machine*; it never becomes the
nesting *inside* that machine's own filesystem. What ServiceChain
*does* become is **group existence and membership** (above) — that's
the actual bridge between the address a node claims and what a file's
permission bits can reference.

**Not hierarchical-only or per-resource-only — composed, like real
IAM already does.** AWS/GCP-style IAM never forced that choice: a
resource inherits whatever's granted at every level above it (org →
project → resource) *and* can carry its own directly-attached grant on
top, which adds to (or, with deny-rules, restricts) what's inherited.
That's the shape here too — a ship-wide grant to `eng` cascades to
every machine under it by default, and any specific file or console
can still carry its own extra grant beyond that (one particular
console granting a one-off role nobody else on the ship has), the same
way real POSIX ACLs layer on top of the base owner/group/other bits.

**In `ls -l`: reuse the real POSIX convention, don't invent new
syntax.** A file with nothing beyond the flat owner/group/other bits
looks exactly as it already does. A file with an extra gradient grant
gets a trailing `+`, exactly like real Linux ACLs signal today:

```
-rw-r--r--+  1 root   union    9800  2321-11-02 00:00 rfc2305.txt
```

`ls -l` doesn't try to explain the `+` inline — same as real Unix,
that would clutter every line. `probe` (already the "tell me what's
actually true about this thing" verb — no new command needed) answers
it on demand, styled the same short/curated way `spec` already is:

```
$ probe rfc2305.txt --acl
rfc2305.txt: composed grant chain
  base:      -rw-r--r-- (root:union)
  +ship:     RB-CERES-119 -- read (granted 2354-02-01)
  +dept:     eng -- read/write (granted 2355-11-19)
```

**The record of who granted what lives on the same RFC-2302 local
ledger already carrying the quorum-multisig entries (§3)** — not a
separate mutable grant file, for the identical tamper-evidence reason.
And the same shape-converges/authority-diverges split from earlier
applies one more time: the `+` and `probe --acl` display are universal
across all four lineages, but *who's authorized to grant, and how it's
recorded*, stays political — Earthstock signs it institutionally,
Scrapshell ledger-records it the same way `claim` does, Mars bakes it
into the capability token at minting (same re-minting-ceremony cost as
any Mars capability change, §4), Corporate makes it a revocable
leased-entitlement field.

## 11. Belt speech: Lang Belta grammar, article-dropping, and the "[X] be" tautology (locked 2026-09-06/07, revised 2026-09-08)

Surfaced while drafting OPRA (Operational Relay Authority)'s
institutional voice for RFC-2353 — see `docs/vault/Notes/voices/
voice_profiles/SPERB Sub-Bureau Voices.md` for the RFC-authorship
application and the full grammar notes. Recorded here too because it's
culture, not just prose style, and belongs where Belt worldbuilding
actually lives, not only inside a voice card built for one document.

**Revision, 2026-09-08: this is real Belter Creole (Lang Belta), not an
invented-from-scratch dialect.** The original version of this section
described only an invented article-dropping habit. The user corrected
this directly, supplying real Lang Belta grammar and vocabulary and
asking that OPRA's institutional voice (and Belt speech generally) use
it rather than a from-scratch approximation. Confirmed grammar in active
use: SVO word order; `gonya`/`gonna` as a preverbal future particle;
`-lowda` as the plural suffix (`beltalowda` = Belters); `be` (canonical
`bi`) reserved for the locative/equative copula specifically, not a
generic filler verb; zero copula elsewhere; `no` for preverbal negation
in this corpus's usage (canonical Lang Belta uses `na` — the two may
simply be a register variant, see the gradient note below). Full
grammar notes, plus a handful of project-specific coinages
(`fokaso`, `terásheting`, `seleshang`) not independently verified
against outside Lang Belta references, live in the voice-card file
above; this section states the culture-level fact, that file states the
applied grammar.

**Register gradient: Ganymede vs. Pallas.** Belter Creole itself has a
real in-universe register range — a station like Ganymede, more
integrated with inner-planet trade, trends back toward intelligible
English; a station like Pallas runs thick, near-unintelligible to an
outsider. This is not a detail specific to RFC-2353: it's a property of
the language as spoken across the Belt, and it means "how thick" a given
piece of Belt dialogue should read is itself a worldbuilding choice, not
a fixed dial. OPRA's own institutional voice sits at the Ganymede end on
purpose, because a normative document has to stay parseable — see the
voice card for that reasoning. A rougher station's own NPC dialogue, or
flavor text set closer to the deep Belt, has real license to run much
thicker toward the Pallas end.

**Article-dropping** still holds under the real grammar: "a," "the,"
"an" drop wherever the meaning survives without them — "Authority calls
it that," not "the Authority calls it that." In-universe justification
unchanged: a follow-on habit from sign-language and limited-bandwidth
comm culture, where every dropped word is one less thing to transmit or
sign, plausibly generalizing from suit-to-suit/tightbeam-constrained
speech into casual speech generally over generations (per §0's "Darwin
in space computers" framing for OS drift).

**The "[X] be" tautology, replacing "it is what it is."** Updated from
"[X] is" to match the real copula rule above (`be` is Belt speech's
actual equative copula, so the tautology-closer uses it too, not a bare
"is" borrowed from standard English). Where a standard-English speaker
would close on a flat restatement of the obvious ("it is what it is,"
"that's just how it is"), Belt speech closes by naming the thing once
and ending on a bare "be" — no verb-object completion, no repeating the
noun. "Lying still be," not "lying is still lying." "Machine lying still
be," not "machine-made lying is lying just the same." The construction
states the conclusion once and stops, rather than circling back to
restate it — the clipped stop is the idiom, not a fragment to read past.

**Scope note:** this is a real Belt-culture-wide speech pattern, not
something specific to relay operators or OPRA. OPRA's voice card is
the first RFC-authorship context it's been formalized for (RFC-2353
§8/§8.5), but it should show up anywhere ordinary Belter dialogue does
— NPC barks, flavor text, Scrapshell system messages written in a
Belter operator's voice — not just in institutional RFC prose, and at
whatever point on the Ganymede–Pallas gradient the specific
character/station calls for.
