# Expanse Hacker Game — Architecture Plan (v0)

Status: planning only, no engine code yet. This document exists to fix the
shape of the system before content (RFCs) or UI get built against it, so
none of the three layers below leak into each other later.

## 0. Premise, restated

- Setting: an Expanse-like solar system. Networking is physical, slow,
  and political — laser relay links between ships/stations/habs, store-
  and-forward across light-lag gaps, no central authority. "SolNet" is a
  loose federation of networks-of-networks that nobody governs and
  everybody half-trusts.
- The player is a **belter technician**, not a desk hacker. Compromise
  happens by understanding real (in-fiction) protocol behavior and real
  physical topology — splicing into a line, swapping a buffer on a relay,
  misconfiguring a router you have physical access to, exploiting a
  documented-but-overlooked edge case in an RFC. There is no `nmap && exploit`
  shortcut. If a vulnerability is guessable, it's not designed right yet.
- Canon lives in fake-but-plausible RFCs the designer (you) writes by
  hand, vulnerabilities baked into the spec text itself, sometimes
  in the "Security Considerations" section, sometimes nowhere at all.
- Hard requirement: **engine, content, and UI are three separately
  replaceable things.** A modder should be able to write a new RFC's
  worth of content, or reskin the UI, without touching the other two.

## 1. Three-layer split

```
┌─────────────────────────────────────────────────────────────┐
│  UI          terminal/IDE pane + physical-tool pane          │
│              renders state, collects player intent            │
└───────────────────────────▲────────────────────────────────┘
                             │ Action / Observation protocol
                             │ (a stable, versioned message contract)
┌───────────────────────────┴────────────────────────────────┐
│  ENGINE      sim core: nodes, links, light-lag, protocol      │
│              execution, DTN store-and-forward, physical       │
│              layer state, permission/trust resolution         │
│              — knows NOTHING about specific protocols,        │
│              devices, or vulnerabilities. Only knows the      │
│              *rules by which content-defined things behave*.  │
└───────────────────────────▲────────────────────────────────┘
                             │ Content-loader API
                             │ (schema below)
┌───────────────────────────┴────────────────────────────────┐
│  CONTENT     data files derived from RFCs: protocols,         │
│              hardware specs, node/network templates,          │
│              vulnerabilities, tools, mission/scenario setup   │
│              — no code, or only sandboxed scripted hooks      │
└─────────────────────────────────────────────────────────────┘
```

The rule of thumb for "which layer does X live in": **if it's true for
every game you could build on this engine, it's engine. If it's true
because of *this* fictional universe's protocols and hardware, it's
content. If it's about how a human perceives/operates on any of the
above, it's UI.** Nothing gets a pass into the engine layer just because
it's convenient — that's how "scan/exploit" games happen, because the
verbs got baked into the core instead of left as content-defined
behavior the player has to discover.

## 2. Engine layer

Responsibilities, and only these:

- **Topology & simulation clock.** A graph of nodes and links. Each link
  has a medium (laser, RF, cable, sneakernet/physical courier) and a
  propagation delay computed from real distance — this is where "delay
  tolerant" stops being a slogan and starts being a mechanic: a message
  from Ceres to Luna is *minutes* away, store-and-forward is not
  optional, and the player has to reason about stale state.
- **Bundle/store-and-forward transport primitive.** Analogous to the
  real DTN Bundle Protocol: engine provides "queue this for eventual
  delivery, retry per content-defined policy, expose partial/duplicate/
  out-of-order delivery" as a primitive. It does not know what's inside
  a bundle.
- **Protocol execution sandbox.** Content defines protocol state
  machines (see §3); engine provides the executor — a deterministic,
  resource-bounded interpreter that runs a content-defined state machine
  against messages on a link/node and produces effects (state changes,
  emitted messages, log events). This is also where a "vulnerability"
  becomes real: it's just a state machine with a transition the spec-
  writer put there on purpose, executed faithfully by an engine that
  has no concept of "this transition is a bug."
- **Trust/identity resolution.** No CA. Engine provides a generic
  web-of-trust primitive (keys, signatures, trust edges with decay/
  revocation) — content decides how any given network *uses* it
  (a corp net might require signed-chain-to-root-of-3; a pirate relay
  might accept anything signed at all; a union net might use
  reputation-weighted quorum instead of keys at all).
- **Physical/hardware state.** Engine tracks a node's installed
  components as a slot graph (ports, buffers, power budget, thermal,
  physical access requirement) with content-defined component types.
  Installing a buffer on a laser relay is: player has physical-access
  capability on that node → content defines what a "buffer" component
  does to that node's link behavior → engine just executes the effect.
- **Event/observation bus.** Everything the engine does emits typed
  events; UI subscribes and renders, never pokes engine state directly.
- **Action intake.** UI submits typed Actions (see §4); engine validates
  against current sim state and content rules, applies or rejects.
- **Scripting host.** A sandboxed interpreter (candidate: embed a small
  Lua via Inline::Lua, or a restricted Perl safe-compartment) that content
  and *players* can both target — content defines protocol behavior in
  it, and in-fiction "the player writes a script and runs it on a node"
  is the same execution path, not a fake minigame bolted on top.

Explicitly NOT engine responsibilities: what a "router" is, what TCP-
equivalent-for-SolNet looks like, what counts as a vulnerability, what
tools exist, mission structure, win conditions. All content.

## 3. Content layer — schema sketch

You don't have the 2-3 existing RFC-derived schemas on hand right now,
so treat this as a first draft to reconcile against those when you can
get them back, not a final answer. Format-agnostic on purpose (YAML
shown for readability; could be TOML/JSON/whatever the engine's loader
parses) — the point is the shape of the data, not the syntax.

**protocol.yaml** — one per RFC-defined protocol
```yaml
id: solnet.expp/1          # "Extra-Planetary Propagation Protocol"
rfc: RFC-4419               # traceability back to the fictional doc
layer: bundle-application
states:
  IDLE: {on: {SYN: HANDSHAKE_WAIT}}
  HANDSHAKE_WAIT:
    on: {ACK: ESTABLISHED, TIMEOUT: IDLE}
    emit: [{type: SYN_ACK, delay: link.propagation}]
  ESTABLISHED:
    on: {DATA: ESTABLISHED, FIN: CLOSED}
    # the vulnerability: an oversized SEQ wrap isn't validated per RFC
    # §7.2's (deliberately underspecified) "MAY" language
    on_data_overflow: {seq_wrap: no_validate}
  CLOSED: {terminal: true}
security_considerations: |
  (flavor text shown to the player if they read the RFC in-game —
  sometimes this honestly hints at the flaw, sometimes it's a red
  herring, exactly like a real spec)
```

**hardware.yaml** — device/component types
```yaml
id: relay.laser.mk3
slots:
  buffer: {accepts: [component.buffer.*], requires_physical_access: true}
  power: {budget: 400W}
default_protocols: [solnet.expp/1, solnet.beacon/2]
failure_modes:
  - id: buffer_overflow_desync
    trigger: {protocol: solnet.expp/1, condition: seq_wrap}
    effect: {link.integrity: -1, emit_event: relay_desync}
```

**component.yaml** — installable physical/software parts (tools double
as content here too — a "buffer" the player installs is the same schema
as a stock part)
```yaml
id: component.buffer.overrun_patch
kind: buffer
installed_effect: {seq_wrap: validate}   # patches the flaw
crafted_from: [scrap.optics, printer.time:20m]
```

**node.yaml / network.yaml** — templates for populating a scenario:
station/ship/relay instances, which hardware, which protocols active,
which trust roots, starting topology.

**vuln.yaml** *(optional separate layer, or folded into failure_modes
above — open question, see §7)* — lets a designer define a
vulnerability without necessarily writing a whole new protocol, for
lighter-weight authoring.

Content is data-only wherever possible; the only "code" content should
ever contain is small scripted hooks run inside the engine's sandboxed
interpreter (§2), never arbitrary host-Perl. That's the moddability
boundary: a mod that's just new YAML can't touch anything outside the
sim; nobody should need engine-repo access to add a network.

## 4. UI layer

Two panes, one player, matching "belter technician, not desk hacker":

- **Terminal / code pane.** Real line editing, real scripting against
  the engine's sandboxed interpreter (§2) — this is where protocol
  probing, writing a patch script, or scripting an automated relay
  crawl happens. It should feel like a genuine shell + editor, because
  it *is* one, just scoped to the sim.
- **Physical/tool pane.** Non-PC tools as first-class UI, not a menu
  buried under the terminal: a multitool/meter readout, splice/patch
  actions, a slot view of the current node's hardware (matches the
  `hardware.yaml` slot graph directly), install/remove component
  actions. This is where "install a buffer on a laser relay" happens as
  a physical action verb, separate from anything typed.
- Both panes only ever speak the Action/Observation contract from §1 —
  UI holds no game rules, so a terminal-only build (native CLI/TUI) and
  a browser build can be two thin renderers over the identical
  engine/content. That was explicitly your UI answer — terminal-and-IDE
  as the primary interaction, physical tools alongside it, not
  standalone — so the contract needs to carry both kinds of action
  symmetrically from day one, not bolt physical actions on after the
  fact.

## 5. Repo shape (proposed, not yet all created)

```
engine/         # sim core, protocol executor, DTN transport, scripting host
content/
  protocols/
  hardware/
  components/
  networks/
  scenarios/
ui/
  web/          # browser build (terminal pane + physical-tool pane)
  cli/          # native terminal build, same engine
docs/
  rfcs/         # the in-fiction SolNet RFCs (source of truth for content)
  *.md          # this doc and future design docs
```

The `dskzz/skzzutil-perl` toolkit (mysql/web wrappers, logging) is a
candidate dependency for `ui/web/` and persistence if the engine ends
up Perl-based — pulled in explicitly, not something the engine layer
depends on directly, so the engine stays embeddable in a native/CLI
build too.

## 6. Design philosophy checks (so future content doesn't drift)

- A vulnerability is discoverable only through in-fiction information
  (reading the RFC, probing protocol behavior, physical inspection) —
  never surfaced by an engine-level "this thing is vulnerable" flag.
- No verb is a genre shortcut. "Scan" isn't a button; if scanning
  exists at all it's a specific content-defined action with specific
  content-defined limits (a real technician's meter reads specific
  values, not a vuln list).
- Physical actions and protocol/software actions are peers in the
  Action contract, not a minigame layered on top of "the real game."
- Delay-tolerance is a constant pressure, not a flavor detail: engine
  must never let UI pretend a message arrived faster than physical
  propagation allows.
- Trust is decentralized by construction — the engine must not grow a
  built-in "the server/admin is always right" concept anywhere.

## 7. Open questions (need your input / the missing RFC files to close)

1. Vulnerability authoring: fold into `hardware.failure_modes` (above)
   or a first-class `vuln.yaml` layer? Depends on whether most flaws
   you're designing are hardware-triggered, protocol-triggered, or both.
2. Scripting host choice: sandboxed Lua vs. restricted-Perl compartment
   vs. a tiny bespoke DSL — tradeoff is "feels like a real shell" vs.
   "trivially safe to sandbox." Worth prototyping once we see a real
   RFC's worth of protocol complexity.
3. Tick granularity for the sim clock (real-time with light-lag scaled
   down, or discrete turns/ticks) — affects whether store-and-forward
   *feels* tense or just becomes a wait screen.
4. How much of "network of networks of networks" is generated
   procedurally vs. hand-authored per scenario — affects whether
   `network.yaml` needs a generator spec, not just static templates.
5. Once you can get to the 2-3 existing RFC/schema files, we should
   reconcile them against §3 rather than have this doc win by default.

## 8. Suggested next step

Bring in one real RFC (even partial) and hand-convert it into the §3
schema shapes as a worked example — that will break this schema in
useful ways faster than speculating further. No engine code until at
least one such worked example exists, per this session's scope.
