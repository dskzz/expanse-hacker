# Expanse Hacker Game — Architecture Plan (v0)

Status: planning only, no engine code yet. This document exists to fix the
shape of the system before content (RFCs) or UI get built against it, so
none of the three layers below leak into each other later.

In-universe worldbuilding that motivated several decisions here — why
the setting fragments without a war or collapse, the four OS lineages,
their root/patch models, and a worked filesystem/console sketch — lives
in [`docs/lore/os-lineages.md`](lore/os-lineages.md).

**Decided 2026-09-04 (not this doc's call — the project's architect's):**
engine and UI are both built in Godot (GDScript), one project, not
separately-deployable pieces by technology. See root `README.md` and
`messages/2026-09-04-merge-complete.md`. This doesn't change the
engine/content/UI *responsibility* split below — §1's boundaries are
still the right way to reason about what code does what — it just means
all three get implemented in one codebase rather than as physically
separate builds. §5 and §7.2 below are updated accordingly.

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
  Physical access is deliberately *not* the same thing as full access —
  see the tenant/namespace layer below.
- **Tenant/namespace layer.** A node's physical shell can host more than
  one logical tenant — the same isolation-is-a-view idea Linux
  namespaces/cgroups proved out for containers, applied to a node
  instead of a kernel. Physical access (jacking into a console/port)
  gets a player *a* view; content decides whether that node multiplexes
  tenants at all, and if so what each tenant can see (files, devices,
  link telemetry) and what resources (power, bandwidth — generalizing
  the `power: {budget: ...}` field in §3's `hardware.*`) are
  attributed to them. A leased Corporate relay might jail a player to a
  thin slice of a much bigger physical machine; a Belt station might run
  flat and single-tenant by cultural choice, trading compartmentalization
  for simplicity. Escaping a tenant's view into another one is a
  legitimate, content-defined action — not a bug the engine has to
  prevent, any more than a real container escape is the kernel's fault
  for correctly implementing what it was told to isolate.
- **Event/observation bus, exposed as an inspectable namespace.**
  Everything the engine does emits typed events; UI subscribes and
  renders, never pokes engine state directly — but content can also
  expose live engine state (protocol state-machine position, bundle
  queue contents, link integrity, tenant resource usage) as a
  browsable, greppable namespace, the direct descendant of `/proc`:
  "everything is a file" extended from local process state to
  networked, delay-tolerant link state. This isn't a UI affordance
  bolted on after the fact — it's the same event data the bus already
  carries, given a filesystem-shaped read path alongside the typed one,
  scoped per-tenant like everything else in this layer.
- **Action intake.** UI submits typed Actions (see §4); engine validates
  against current sim state and content rules, applies or rejects.
- **Scripting host.** A sandboxed interpreter (candidate: embed a small
  Lua via Inline::Lua, or a restricted Perl safe-compartment) that content
  and *players* can both target — content defines protocol behavior in
  it, and in-fiction "the player writes a script and runs it on a node"
  is the same execution path, not a fake minigame bolted on top.
- **Generic algorithm backend** (Sid's refinement, 2026-09-04, of the
  scripting host above — not a new layer). Same test as everything
  else here: a diff algorithm doesn't know anything about SolNet, so
  it's engine, not content — content only decides *what* gets diffed
  (`spec`'s documented default vs. `probe`'s actual node state, per
  `docs/lore/os-lineages.md` §6). Two legitimate implementation
  strategies behind one generic engine interface
  (`engine.diff(a, b)`, never "the UI happens to know how to shell out
  to diff"): **emulated** — runs inside the sandboxed scripting host
  above, portable to any build target including headless/web, at the
  cost of someone implementing the algorithm correctly inside the
  sandbox; **hosted** — shells out to the real thing (`OS.execute()`
  on desktop builds), correctness for free, only viable where process
  execution is actually available. Which strategy runs for a given
  algorithm/build is an engine implementation detail, not something
  content or UI branches on. **Security boundary, decided now rather
  than left open:** hosted execution is never a general "run this
  string as a process" capability exposed to content or mods — only a
  fixed, engine-curated set of specific algorithm bindings (diff today;
  hashing/pattern-matching/compression are candidates once a second
  real case shows up, not before). A mod can ask the engine to diff two
  strings; it can never ask the engine to exec anything. See
  `reference/algorithm_backend.md` for the full writeup and
  `docs/systems/console-commands.md` for the motivating case
  (whether Tier 2 coreutils-successors like `rg`/`sd`/`jq` need this at
  all, or are cheap enough to implement natively against GDScript's own
  `RegEx`/JSON support — current read: mostly the latter, this backend
  is for the few, like `delta`, where the algorithm itself is the hard
  part).

Explicitly NOT engine responsibilities: what a "router" is, what TCP-
equivalent-for-SolNet looks like, what counts as a vulnerability, what
tools exist, mission structure, win conditions. All content.

## 3. Content layer — schema sketch

**Format decided 2026-09-04: JSON, not YAML** (Dan's call, relayed by
Sid) — the sketch below was originally written in YAML back when this
was still "format-agnostic... the point is the shape of the data, not
the syntax." Shape didn't change, syntax did. Since JSON has no comment
syntax, provenance/rationale that would've been a `#` comment lives in
a `_notes` field instead (top-level and/or sibling to the relevant
key) — see `db/README.md` and the real files below for the convention
in practice.

**Reconciled against a real RFC 2026-09-04** — see
`db/protocols/rfc2305-duty-reservation.json` and
`db/hardware/relay-courier-rig-class-c.json`, hand-converted from
RFC-2305 (Power and Duty Cycle Constraints) now that the vault is
merged in. That confirmed the shape below still holds, and also broke
it in exactly the useful way §8 predicted: a real `PowerCapabilityRecord`
can't be expressed as a flat `power: {budget: 400W}` number, because
the RFC separately requires power class, peak/sustained power, duty
limit, and energy capacity as independently-relevant fields — the
example below is kept as originally written (still illustrative, still
not canon, still in its original YAML form since rewriting a fictional
placeholder isn't worth the churn), but treat the real JSON files as
the current reference for what a hardware power slot actually needs to
look like.

**protocol.\*** — one per RFC-defined protocol (original sketch, still YAML;
real ones are JSON, see `db/protocols/`)
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

**hardware.\*** — device/component types
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

**component.\*** — installable physical/software parts (tools double
as content here too — a "buffer" the player installs is the same schema
as a stock part)
```yaml
id: component.buffer.overrun_patch
kind: buffer
installed_effect: {seq_wrap: validate}   # patches the flaw
crafted_from: [scrap.optics, printer.time:20m]
```

**node.\* / network.\*** — templates for populating a scenario:
station/ship/relay instances, which hardware, which protocols active,
which trust roots, starting topology.

**vuln.\*** *(optional separate layer, or folded into failure_modes
above — open question, see §7)* — lets a designer define a
vulnerability without necessarily writing a whole new protocol, for
lighter-weight authoring.

**Composition/inheritance: open, per Sid's `db/vfs/` system** — the
Console's filesystem content already uses templates + instances + a
shared registry composed via JSON Merge Patch (RFC 7386) — e.g.
`scrapshell.json` → `scrapshell-relay.json` → `relay-pallas-07.json`.
Not yet decided whether `protocols/`/`hardware/`/`trust/` should adopt
the same merge-patch model for one consistent inheritance mechanism
across all content types, or whether they're different enough to
warrant their own composition rules. See `reference/vfs_template_system.md`.

Content is data-only wherever possible; the only "code" content should
ever contain is small scripted hooks run inside the engine's sandboxed
interpreter (§2), never arbitrary host-Perl. That's the moddability
boundary: a mod that's just new JSON can't touch anything outside the
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
  `hardware.*` slot graph directly), install/remove component
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

## 5. Repo shape (actual, superseding the original proposal below)

The `engine/`/`content/`/`ui/`/`docs/` split originally proposed here
assumed separately-deployable pieces, possibly in different languages.
That's superseded by the 2026-09-04 Godot decision above. Actual
layout, from root `README.md`:

```
docs/           # architecture + worldbuilding (this doc's territory)
  vault/        # mirrored SolNet RFC corpus + companion docs — RFCs in
                # New RFCs/ and RFCs/ get surgical corrections only,
                # see root README for the full rule
  lore/         # os-lineages.md etc.
reference/      # game-design docs (narrative/implementation territory):
                # object-inspection model, tool-belt shell, etc.
code/           # the Godot project — engine + UI together
db/             # structured/runtime data: protocol.*/hardware.*-
                # style schemas derived from the RFCs, scenario data
assets/         # raw source assets before Godot import
testing/        # test suites
messages/       # async notes between the two sessions working on this repo
```

The engine/content/UI *responsibility* split in §1-§4 above still
describes what code should reason about what — it's just that "engine"
and "UI" now both live under `code/` rather than in separate
directories, and "content" lives under `db/` rather than `content/`.

<details>
<summary>Original proposal (2026-09-03), kept for history</summary>

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

Assumed a possibly-Perl engine using the `dskzz/skzzutil-perl` toolkit.
Superseded — engine and UI are Godot/GDScript, not Perl.
</details>

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
- Physical access is not full access. A node's tenant/namespace layer
  is allowed to legitimately show a player a partial, honest view —
  the gap between "I'm jacked in" and "I can see the flaw" is
  gameplay, not a UI bug to be smoothed over.

## 7. Open questions (need your input / the missing RFC files to close)

1. Vulnerability authoring: fold into `hardware.failure_modes` (above)
   or a first-class `vuln.*` layer? Depends on whether most flaws
   you're designing are hardware-triggered, protocol-triggered, or both.
   `db/hardware/relay-courier-rig-class-c.json`'s worked example used
   `failure_modes`, which held up fine for a first real case, but that's
   one data point, not a decision.
2. Scripting host choice: sandboxed Lua vs. restricted-Perl compartment
   vs. a tiny bespoke DSL — **revisit in light of the Godot decision**:
   GDScript itself might be the sandboxed-enough scripting surface,
   worth a look before committing to embedding something else
   (flagged in `messages/2026-09-04-merge-complete.md`).
3. Tick granularity for the sim clock (real-time with light-lag scaled
   down, or discrete turns/ticks) — affects whether store-and-forward
   *feels* tense or just becomes a wait screen.
4. How much of "network of networks of networks" is generated
   procedurally vs. hand-authored per scenario — affects whether
   `network.*` needs a generator spec, not just static templates.
5. ~~Once you can get to the 2-3 existing RFC/schema files, we should
   reconcile them against §3~~ — **done 2026-09-04**, see §3's note and
   `db/protocols/`, `db/hardware/`.
6. Tenant/namespace layer: is it per-node content (defined in
   `hardware.*` alongside slots) or its own top-level content file
   (`tenancy.*`)? Depends on whether tenancy setups get reused
   across many node instances (a "Corporate leased relay" template) or
   are usually one-off per scenario.
7. `db/hardware/relay-courier-rig-class-c.json` references
   `policy.union.ceres-119` as a `power_policy_ref` — RFC-2305's
   PowerPolicyRecord isn't modeled as its own content file yet. Worth a
   `policy.*` shape once a second RFC gets converted and the pattern
   is clearer (RFC-2305 also has DutyCycleRecord, EmergencyOverrideRecord,
   and AuditEvent as candidate content or engine-state shapes, not yet
   triaged either way).

## 8. Suggested next step

~~Bring in one real RFC (even partial) and hand-convert it into the §3
schema shapes as a worked example~~ — done, see §3. Next: a second real
RFC, ideally one with a genuinely different shape (RFC-2305 is a
policy+state admission-control protocol; something more like a classic
handshake — RFC-2351 L1 Frame Format or RFC-2359 Bundle Addressing are
candidates — would stress the schema differently). Also open per §7.7:
whether PowerPolicyRecord-style referenced-but-not-yet-modeled record
types need their own content shape before a second conversion, or
whether that becomes clear once one exists.
