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

**Timeline note:** "now" (game-present) is placed here at roughly
**the 2390s** — about fifty years after the SolNet L0/L1 RFCs were
actually promulgated (~2340s). That number came from the user directly
and isn't precisely locked; treat every date below as approximate and
adjustable, not settled canon.

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

**~2320 — the Vesta Blockade.** Not humanity's first war, but the
first one caused by network rot. Timing drift and corrupted diplomatic
traffic turn a routine standoff into a shooting war — Earth reads
Mars's silence as defiance, Mars reads Earth's silence as escalation.
One Martian cruiser cripples five UN destroyers. Everyone blames
everyone else. No one blames the network. The drift that caused it
doesn't stop.

**~2320–2330 — the Drift Years** (vault-canonical name, not this doc's
invention). Earth piles on redundancy that overloads Belt relays; Mars
tightens encryption that breaks Earth's routing; Belt engineers patch
everything with salvage and improvisation. Firmware diverges, timing
windows drift, metadata becomes political. This is the same mechanism
§0 describes — nobody rebelling, everybody solving their own problem
on their own clock — compressed into a single decade under real
technical and political strain, not stretched across centuries of
drift-by-distance the way the original version of this doc had it.

**~2330 — Anderson Station.** The Drift Years' body count. A surrender
message gets flagged low-priority, drifts through Earth's civilian
filters, and is silently dropped. Fred Johnson orders an assault based
on silence the network itself manufactured. This is the setting's
founding trauma — the moment "the network is unreliable" stops being
an engineering footnote and becomes something people died over.

**~2330s–2339 — Johnson, Dawes, and the Ceres Broadcast.** Johnson,
exiled and haunted, quietly rebuilds a fleet-class broadcast node from
salvage on Ceres. Anderson Dawes, watching from the docks, confronts
him instead of turning him in. Together they force the Anderson
footage onto the network in a way no faction's filters can suppress.
For the first time, Earth, Mars, the Belt, and the megacorps all see
the same failure at the same moment.

**~2339–2342 — the OPRA moment: SolNet's real founding.** The one time
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

**~2342–2347 — marginalization, and the birth of the OPA.** The
moment the fires are out, the old habits return. Earth bureaucrats
reclaim the committees; Mars reasserts doctrinal purity; corporate
vendors flood the standards process; BRA is thanked, praised, and
quietly excluded despite having done the work that saved the network.
The engineers who built BRA scatter, carrying technical expertise,
institutional memory, and a specific, founded grievance. That's the
actual seed of the OPA — infrastructure and betrayal, not abstract
ideology.

**~2342 → now (the 2390s) — roughly fifty years of renewed
divergence.** With the coalition dissolved and no authority left to
enforce it, the same mechanism from the Drift Years resumes — except
now it's diverging *away from* a real, once-shared standard instead of
never having had one. This is the window the four OS lineages below
actually crystallize in. Fifty years is deliberately the same order of
magnitude as real Unix's own fork history (1969 to now) — plenty of
time for genuine, load-bearing dialects to form, nowhere near enough
time for anyone to have forgotten *why*. Scrapshell's divergence
should read as recent and felt, not ancient and archaeological (§5).

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
│   │                       #   2361 -- the year the union stopped
│   │                       #   waiting for Earthstock's confirmed-
│   │                       #   reservation handshake on routine
│   │                       #   traffic. Nobody's proud of it. Nobody's
│   │                       #   reverted it either.
│   ├── union.trust          #   local quorum roster -- the root model, on disk
│   └── patches.log          #   append-only: every hand-applied patch, who
│                             #   signed it, when. Entries go back to 2344 --
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
drwxrwx---  7 tech   union    340  2396-03-14 09:11 .
-rwx------  1 root   root    2200  2396-03-14 09:11 duty-reservation.state
-rw-r--r--  1 root   union   9800  2361-11-02 00:00 rfc2305.txt

$ spec rfc2305
RFC-2305 -- Power and Duty Cycle Constraints (SolNet Standards Working
  Group, adopted union-side since 2361 with local ADMISSION_MODE
  override, see /etc/duty-policy.conf)
  §16.1 -- stress behavior
    "Blindly transmitting at full power without a confirmed
    reservation is a policy violation."

$ probe duty-reservation --node RELAY-PALLAS-07
RELAY-PALLAS-07: solnet.rfc2305/duty-reservation, ADMISSION_MODE=HANDWAVE_TX
  (local override since 2361, no re-audit on file)
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
- **Known internal vault inconsistency, not resolved here:** the
  Incident Timeline (`Notes/history/SolNet Incident Timeline.md`)
  lists Anderson at ~2330 and "Drift Years (2330–2336)" as a *separate,
  later* heading, while `Notes/voices/background/The Drift Years and
  the Birth of the BRA.md` has the Drift Years causing Anderson (Vesta
  → 15 years of drift → Anderson). §1 above follows the Incident
  Timeline's dates but the BRA narrative's causal shape (drift causes
  Anderson) since that's the more load-bearing story; someone should
  reconcile these properly rather than this doc picking a winner by
  default.
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
  --union-vote` "blocks... within a window").
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
- The Incident-Timeline-vs-BRA-narrative sequencing conflict flagged
  in §7 is still unresolved — needs the user's call, not a default
  pick.
- `corporations.md` populates the Corporate lineage with named players
  beyond Mao-Kwikowski; worth checking whether Scrapshell (or any
  other lineage) should get the same treatment — right now Scrapshell
  reads as one unified culture, which may undersell how much variation
  a fifty-year-old, hand-patched, no-central-authority lineage should
  actually have station-to-station.
