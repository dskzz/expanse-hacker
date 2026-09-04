# OS Lineages & the Drift

Status: worldbuilding, reconciled against the vault's real RFC corpus
as of 2026-09-04 (§7). This grew out of a planning conversation
working backward from a real
question — "is Unix/Linux the mousetrap/toilet of computing, a form
that fits its function so well that 300 years mostly refines it at the
edges rather than replacing it?" — and landing on an answer with a
built-in reason for the exact kind of divergence and baked-in
vulnerability the [architecture plan](../ARCHITECTURE.md) wants: no
single collapse, no war. Just distance, and no one ever having the
standing to force reconvergence.

## 0. Why fragmentation, not collapse

The mousetrap/toilet analogy holds for the parts of Unix that solve a
truly general problem — a hierarchical namespace, small composable
tools, a REPL shell, documentation co-located with the tool. Those
survive intact for the same reason a toilet's "hole" does: there's no
better answer to the problem, so 300 years just refines the edges.

But the premise of this setting — genuinely no central authority,
ever — means the parts of Unix that *did* rely on central coordination
(a shared upstream, a common patch stream, one trusted CA) can't stay
unified. Nobody had to fight a war for SolNet's software to fork; it
just had to get far enough apart, for long enough, that "pull the
latest patch from upstream" stopped being a real option for whoever
was standing in front of a dying relay. This isn't invented — it's
the same mechanism that stalled the real-world Filesystem Hierarchy
Standard: no revision since 2015, while systemd, containers, ostree,
and Nix all quietly built past it, each solving their own problem,
because no one has the standing to reconcile them. SolNet just runs
that same process for 200 years with light-hours standing in for
"nobody funded the meeting."

## 1. Timeline

**Act I — Expansion (now → ~+150y).** Humanity spreads through the
system. Still one lineage with regional patches, the way real Linux
distros descend from one upstream today — Earth/Luna is close enough,
and connected enough, that "the latest patch" still means something.

**Act II — the Drift (~+150y → +200y).** Round-trip sync time to Earth
stretches past the point where waiting for upstream is survivable.
Every outpost starts hand-patching locally, not out of rebellion but
because the alternative is a dead relay. Nobody planned to fork —
every station solved its own problem on its own clock, because no
central authority had the standing to say "sync back." Fragmentation
is what "totally unregulated" *produces*, mechanically, given enough
light-hours.

**Act III — Stagnation (last ~100y).** Each lineage hits its own
local optimum and stops moving. Switching costs (retraining every
tech, re-flashing every relay, breaking every downstream script)
exceed the payoff, and there's no authority left to force convergence
even if someone wanted it. Several stable, separately-optimized
dialects, frozen — each one still visibly descended from a common
ancestor, the way modern Linux, BSD, and even Android still share a
Unix-shaped skeleton without agreeing on much past it.

## 2. The four lineages

| Lineage | Vibe | Design implication |
|---|---|---|
| **Earthstock** | Inner-system corporate/mil descendant. Verbose, ceremony-heavy, signed packages — closest to "the original" since Earth kept the coordination capacity to patch longest. | Textbook-correct, and over-trusting of its own PKI: designed assuming a reachable CA. |
| **Scrapshell** | Belt vernacular. Terse, hand-patched, full of undocumented folklore ("everyone knows you SIGHUP twice on a Kestrel relay"). The primary player-facing dialect. | Inconsistent by nature — every station only fixed what broke *for them*, so the same nominal protocol behaves differently relay to relay. |
| **Mars capability-fork** | Disciplined military-industrial fork that actually pulled off one real paradigm shift early — capability-based security instead of Unix DAC — then froze it. | Rigorous on paper; assumes physical custody equals authority. Capture the hardware, inherit the capability, no exploit required. |
| **Corporate leased-compute fork** | The "modern-feeling" one — GUI-first, phones home, subscription-flavored. Most distrusted by belters. | Assumes connectivity it doesn't reliably have in the Drift. Trusts cached, expired grants because whoever wrote it assumed the network would always be there to time-check against. |

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
but without the user holding their own rollback keys.

## 3. Root, four ways

**Earthstock — chain-of-custody.** `elevate --cert=<chain>
--witness=<tech-id>` — a signed capability token tracing back through
an institutional CA lineage, sometimes requiring a second technician
to co-sign ("two-tech rule," liability culture fossilized into
protocol). Coherent, *if* the chain still reaches you — which out in
the Drift it often doesn't.

**Scrapshell — quorum.** No shared CA anyone trusts, so root is
social, not cryptographic: `claim root --union-vote` blocks until N
other logged-in union members `second` it within a window, logged
append-only like a ship's log. The RFC honestly assumes every station
has ≥3 union members present to form quorum, and honestly defines a
fallback for undermanned stations — a fallback that's quietly weaker.
Nobody hid a bug; the spec made a reasonable tradeoff for a case it
assumed was rare.

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

## 5. A Scrapshell filesystem, 300 years on

```
/
├── bin -> usr/bin        # fossil symlink. real /bin retired ~gen.6; nobody's
├── sbin -> usr/bin        # deleted the link, same superstition that kept
│                           # compat symlinks around after our own usrmerge
├── etc/                   # "et cetera" lost to memory generations ago —
│   │                       # belt folklore now reads it as "Everyone's
│   │                       # To-Change," a bitter joke about how often it's
│   │                       # hand-patched and how rarely the copy in the
│   │                       # actual RFC gets updated to match
│   ├── expp.conf           #   SEQ_WRAP_VALIDATE=unset since gen.2 — nobody
│   │                       #   living remembers why, changing it is
│   │                       #   considered bad luck (it's the vulnerability,
│   │                       #   cargo-culted into permanence)
│   ├── union.trust          #   local quorum roster — the root model, on disk
│   └── patches.log          #   append-only: every hand-applied patch, who
│                             #   signed it, when. closest thing to a changelog
├── usr/{bin,lib}/          # merged long ago, unremarkable — Scrapshell never
│                             # had the coordination to move past a mutable
│                             # tree to something Nix-like; that took Mars-
│                             # level up-front investment the Belt never had
├── dev/
│   ├── relay7/
│   │   ├── buffer0          # an installed component — the SAME object the
│   │   │                     # physical-tool pane shows as a slot. cat it for
│   │   │                     # raw telemetry, write to it to reconfigure.
│   │   ├── laser.tx, laser.rx
│   │   └── power             # power budget/draw, exposed as a device
│   └── console0              # the physical port you jack a terminal into
├── link/                    # /proc's descendant, but for link/DTN state
│   │                          # instead of just local processes — because
│   │                          # here "what's my link doing" matters as much
│   │                          # as "what's my process doing" (see
│   │                          # ARCHITECTURE.md §2, "state as an inspectable
│   │                          # namespace")
│   ├── relay7/
│   │   ├── state              # EXPP state machine's live state, readable
│   │   ├── lag                  # measured propagation delay, live
│   │   ├── queue/                # bundles waiting store-and-forward, one
│   │   │                          # file per bundle
│   │   └── integrity              # link health — degrades if e.g.
│   │                               # buffer_overflow_desync fires
│   └── self/                       # this node's own process state
├── tmp/                     # unchanged — universal need, now explicitly a
│                              # finite, named physical scratch chip
└── var/                     # still logs, still the least-loved directory
```

The pattern: anything solving a truly general problem (hierarchy,
`/dev`, `/tmp`, `/proc`'s core idea) survived intact or renamed in
place. Anything that was a one-time hardware accident (`/bin` vs.
`/usr/bin`) is a fossil nobody's brave enough to remove — same as the
real `/usr` merge left compatibility symlinks around out of the same
superstition. `/link` is the one genuinely new top-level idea: not a
replacement for Unix's philosophy, just "everything is a file" pointed
at a domain — DTN link state, bundle queues, protocol state machines —
that didn't exist when the original idea was invented.

## 6. Console sketch (Scrapshell)

```
tech@RB-CERES-119 (Scrapshell 7.2-belt) [lag +0.4s → RELAY-7]
$ ls -la /srv/relay
drwxrwx---  7 tech   union    340  118-09-02 14:02 .
-rwx------  1 root   root    2200  091-03-14 09:11 expp.state
-rw-r--r--  1 root   union   9800  091-03-14 09:11 expp.rfc.txt

$ spec expp
EXPP/1 — Extra-Planetary Propagation Protocol ... RFC-2392 (proposed, draft pending)
  (Earthstock origin, adopted union-side rev. 097)
  §X.X Sequence Wrap Handling [DRAFT]
    Implementations MAY validate SEQ wraparound on receipt of an
    out-of-order DATA frame following HANDSHAKE_WAIT. Validation
    is RECOMMENDED but not required where buffer hardware performs
    wrap detection natively.

$ probe expp --node RELAY-7
RELAY-7: expp/1, Earthstock-fork build 4c19, no belt patches since '088
  buffer hardware: Kestrel Mk.II — no native wrap detection (deprecated '093)
```

`spec` quotes the actual (fictional) RFC text. `probe` reports plain,
bounded facts — fork lineage, patch history, hardware model — the way
a real technician could read them off a panel. Neither is a vuln
scanner; the player has to connect "MAY validate... RECOMMENDED but
not required" with "this hardware doesn't validate it natively"
themselves. Both are ordinary content-defined Actions per the engine
contract in `ARCHITECTURE.md` §1/§4 — nothing here needed new engine
capability.

## 7. Vault cross-references (SolNet RFC corpus)

Reconciled 2026-09-04 against the actual vault (`docs/vault/` in this
repo, mirrored from the design-side session's Obsidian vault). This
lore holds up well against the real RFCs — nothing here contradicts
them, and several things it needed have turned out to already exist:

- **RFC-2362 (Trust Domains and Authority Policy)** is the vault's own
  generic trust primitive (AuthorityWeight, cross-cert chains, no
  global CA) — the four lineages above are four different concrete
  implementations of that one primitive, not a competing system. Worth
  checking whether RFC-2362 as currently drafted can actually express
  all four (Earthstock's reachable-CA assumption in particular reads
  as a degenerate case worth calling out explicitly).
- **Incident Timeline** (`docs/vault/Notes/history/SolNet Incident
  Timeline.md`) already names the Drift correctly without anyone
  intending it to: "Drift Years (2330–2336) — relay drift, vendor
  divergence, inconsistent TLV ordering, legacy nodes accumulate
  unpatched behavior." No reconciliation needed with a collapse event
  because §0 above already rejects one — the Drift Years are the
  visible, RFC-relevant slice of the same ~150-year process this doc
  describes. "Vesta Blockade Failure" (~2320, "incompatible comms
  stacks") reads as one symptom of the drift, not its origin. "2337 —
  Vendor Profile Negotiation Collapse" (vendors attempting "flexible
  profiles," causing routing ambiguity) reads as a failed attempt at
  *re-convergence* across already-drifted lineages — a precursor to
  SolNet's own more disciplined "freeze the substrate, extend via
  profiles" approach succeeding where an uncoordinated vendor attempt
  at flexibility didn't.
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
  `TODOv2.md`) reads, in light of §0 above, as a *treaty-shaped*
  response to permanent drift its authors assume is irreversible —
  not "a good protocol design" in-universe so much as the only viable
  move once no faction has the coordinated trust to unify the software
  layer above the wire contract.

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
  target wastes the player's time. Reinforces that reading the lineage
  correctly — not raw tool power — is the actual skill under test.

## 9. Open threads

- `relay.laser.mk3`, station names, and dates in the examples above are all placeholders invented
  to make the shape concrete, not settled canon. `EXPP` itself now has a real proposed home
  (RFC-2392, currently just a planned/undrafted slot) instead of a made-up citation — see
  `reference/proposed_rfc_content/rfc_2392_sequence_wrap_handling.md` for the actual proposal,
  pending Dan writing the real section text.
- Not yet decided: how many lineages actually exist in play (four was
  useful for design discussion, not necessarily the final roster), and
  whether sub-forks within a lineage (e.g. a specific union splitting
  from mainline Scrapshell) are worth modeling before there's a
  concrete scenario that needs one.
