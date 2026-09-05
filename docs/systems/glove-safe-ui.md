# Glove-Safe UI: Mixing Real Widgets Into the Shell

Status: drafted 2026-09-05, from Dan's core observation that if this is a
future system and not just next-gen branding, the *interaction model*
has to have visibly evolved too — not just the names. Motivating case:
a tech working a splice outside in a suit, gloved, can't rely on
precision typing or small text. The shell has to fail over to something
tap/drag-friendly without turning into "a whole GUI."

**Implemented 2026-09-05** (same day): sections 1 (inline widgets:
button/status-light/gauge, applied to `probe`/`spec`), 5 (big confirm
modal, applied to `claim`), 3 (pin/registry via `<command> | pin =>
<name>`, snapshot semantics as recommended), and 2 (pop-out palette,
static entries + live registry entries, opened via a `☰` button next to
the prompt or the `palette` command). Headless-tested in
`testing/console_smoke_test.gd`. **Section 4 (large-tile glove-mode
`ls`, drag-and-drop) deliberately not built this pass** — per this
doc's own sequencing advice (§6: "the real UI-building effort, worth
doing once the cheaper pieces prove the concept is fun") and its status
as the biggest lift of the five. Real code, not a stub, for everything
else: see `code/scripts/tools/Console.gd`, `glove_widgets.gd`,
`ConfirmModal.gd`/`.tscn`, `PaletteOverlay.gd`/`.tscn`.

**§4 rewritten 2026-09-05 (still design-only, not built)** from a
follow-on conversation with Dan: what was a single "tile `ls`" idea
generalized into one **projection** primitive — pulling any output
(a listing, a previous command's individual tokens, an image, a
nav chart) out of the flat scrolling text and into a tappable/viewable
overlay, because trying to cram all of that into a text stream is
fighting the medium instead of using the right one. Still sequenced
last per §6, and still nothing new to build until the cheaper pieces
above prove out.

## 0. Why this is one standard, not four

Every other divergence in this project (`os-lineages.md` §2-3) tracks a
*political* axis — who you trust, whose root model you accept, that's
factional by nature, so of course Earthstock/Scrapshell/Tharsis/Corporate
disagree about it. Glove-safe interaction isn't downstream of a trust
model at all — it's downstream of a *physical constraint* (a pressure
glove doesn't care what lineage OS you're running), and physical
constraints don't fragment across factions the way politics does. So
unlike root semantics or patch models, this is one of the few things
that plausibly stayed standardized straight through from the OPRA-era
freeze: every lineage's shell speaks it, the same way every lineage's
hardware still takes the same suit umbilical connector regardless of
who made the suit.

Informal name (universal, the way techs actually say it): **glove-safe**.
It probably has a dry formal designation once it gets an RFC slot —
none of the existing L0 numbers fit (2306 is taken by Tightbeam Laser,
and this isn't a physical/propagation-layer concern anyway) — leaving
that unassigned rather than forcing a collision. Whoever converts this
to a real RFC should treat it as its own series, not shoehorned into L0.

## 1. Base widget vocabulary

Kept deliberately small — four primitives, not a UI toolkit:

| Primitive | What it's for | Cheap Godot path |
|---|---|---|
| **button** | fire a command/action from a tap instead of typing it | `RichTextLabel` BBCode `[url=cmd]label[/url]` + `meta_clicked` signal — a real clickable target for free, no new node type |
| **status light** | at-a-glance state (matches the hotspot visual-state concept already in `reference/satellite_relay_interaction.md`) | `[img]` of a small colored glyph, or a colored block character, inline in text |
| **gauge** | a bounded quantity (power budget, buffer fill, signal strength) | block-character bar (`▓▓▓▓░░░░`) built server-side, no widget needed; upgrade to `[img]` only if that reads badly |
| **confirm/select** | pick one of a small fixed set of options | same as button, just multiple `[url]` targets in a row |

Same TLV doctrine as the SolNet protocols themselves: **an unrecognized
widget tag is ignored and falls back to plain text**, never breaks
rendering. A Corporate box running an older glove-safe revision, or a
plain terminal with no widget support at all, still gets a fully usable
shell — just as text. This isn't optional politeness, it's the same
"fail safe to plain text" property RFC-2304 already leans on elsewhere.
Concretely for Sid: **every glove-safe command must have a legitimate
plain-text rendering as its primary output**, with widget markup as an
annotation layered on top of that text, not a replacement for it. A
renderer with zero glove-safe support should be indistinguishable from
one that just never uses buttons.

## 2. Pop-out quick-access library (the "alias palette")

A small pop-out panel, linked from the prompt itself (a `[≡]`-style
glyph or dedicated key), listing tappable shortcuts — conceptually the
glove-safe sibling of shell aliases: instead of typing `alias`, you tap
one. Contents are a mix of:

- **static entries** — commands the user or the node's lineage pins
  permanently (`spec rfc2305`, `ls /usr/bin`, whatever gets used
  constantly on this class of job)
- **pinned slots** — see §3, live/snapshotted data pushed here at
  runtime

This is a real overlay `Control` (a `Panel` + list/grid of `Button`
nodes), not a text-stream trick like the inline widgets in §1 — it's
populated from data (the palette contents), not parsed out of command
output. Cheap by ordinary game-UI standards; the reason it's a separate
line item from §1 is just that it's a different code path in Godot, not
that it's expensive.

Worth a dedicated **`Variables`** button alongside the `☰` glyph
specifically for the pinned-slot half of the contents (Dan's request,
2026-09-05) — same overlay, same data, just a second labeled entry
point for the case where a player wants their registry specifically,
not the whole mixed palette.

## 3. Push-into-variable / the "registry"

Dan's framing: working outside on a relay, you see a list of nearby
nodes; you want to push that list onto a button instead of retyping a
selector every time you need it. Mechanically this is exactly what it
sounds like — **a named slot store**, keyed by name, that the palette
(§2) renders as tappable entries:

```
pin <expression> => <slot-name>
```

e.g. `probe --nearby | pin => nodes.local` pins the *result* of that
probe into a slot called `nodes.local`, which then shows up in the
quick-access palette as a button; tapping it re-runs/re-selects against
that pinned value instead of making you retype the probe or the node ID.

Two things worth deciding now rather than discovering the hard way
mid-implementation:

- **Snapshot vs. live.** Does `pin` capture the value *at pin time*
  (like a normal variable assignment), or does the button stay wired to
  the live data source and re-evaluate on tap (an actual subscription)?
  **Recommend snapshot-only for v1.** A snapshot is just "store this
  value under this name" — trivial, a `Dictionary` on the session/
  console state. Live-updating requires the engine to notify the UI
  when the underlying data changes (nearby-nodes list shifts as you
  move, a gauge updates in real time), which is a real subscription/
  observer mechanism, not a data store. Nothing about the game needs
  that complexity yet — a technician re-pinning a stale list is a
  reasonable, even flavorful, real-world failure mode ("your palette's
  out of date, re-probe"), not a bug to engineer away preemptively.
- **Scope/lifetime.** Session-only (cleared on disconnect) is the
  sane default; persisting slots across sessions is a later feature,
  not a v1 requirement.

This is genuinely "almost like a registry," as Dan put it — a flat
namespace of named values the UI renders as buttons — and it's cheap:
engine-side it's a dictionary and an emit-on-pin event; UI-side it's
just another source feeding the same palette from §2.

§4.2 below adds a second way to trigger the same command: tap-and-hold
on a projected tile. That's a gesture shortcut over this exact `pin`
primitive, not a parallel mechanism — keeps faith with §1's doctrine
that every glove-safe shortcut has a real typed command underneath it.

## 4. Projection surfaces: pulling data out of the text stream

This is the one place where "widgets embedded in a text stream" stops
being the right mental model. Some things a command produces aren't
naturally text-shaped at all — a directory listing you want to grab
and drag, a previous output's individual pieces you want to reference
directly, an image, a spatial chart — and trying to force all of that
through the scroll is fighting the medium rather than using the right
one. Dan's framing for why this is worth doing as its own thing rather
than cramming further into §1-3: you can't smush an unboundedly large
or genuinely spatial thing into a space that by definition can't be
smushed; keeping everything but the bare minimum out of the shell area
keeps the shell itself legible; and the result — text by default,
real interactive surfaces on demand — is closer to what a shell would
actually look like if it had kept evolving for three-plus centuries
than either "just a terminal" or "replace the terminal with a GUI."

A **projection** is triggered on demand (a button on the relevant
output, not a persistent mode you toggle and leave on) and renders into
an overlay `Control`, the same kind of surface as the palette in §2 —
this is one primitive reused several ways, not several separate
features, which is exactly why it's affordable to build incrementally:

### 4.1 Tile projection (what was "glove-mode `ls`")

Tap a listing's project button, get a grid of real `Control` tiles (one
per entry: name, icon/type glyph, size) built from the exact same
directory-listing data structure `ls` already formats into text —
generating that grid (`GridContainer`, populated in a loop) is
ordinary dynamic UI. Drag-and-drop is a built-in `Control` API
(`_get_drag_data`/`_can_drop_data`/`_drop_data`, no plugin needed) — a
tile returning its VFS path, a "save spot" accepting it, is a standard
pattern. The scope increase versus §1-3: `Console.gd` needs to expose
the *structured* listing data it almost certainly already builds
internally, to a second consumer (tiles) alongside the existing one
(text) — a real seam to add, not a rewrite.

Making this on-demand rather than a standing "glove mode" that changes
how `ls` always renders is itself an improvement on the original idea:
text stays the default and the primary plain-text rendering §1's
doctrine requires, and the tile view is something you reach for, not
something imposed.

### 4.2 History-token projection (the glove-mode `!:N`)

Real bash reaches for this with history word designators: `!:1`,
`!:2`, ... reference the Nth word/argument of a previous command
(`!^`/`!$` are shortcuts for first/last, `!*` is all of them); `$_` is
a different, narrower thing — just "the last argument of the previous
command," not indexable, so `$_:1` isn't real syntax. Projecting a
previous command's output turns each individual token/entry into a
tappable object instead of something you reference by memorized index:
tap inserts it into the current input line, tap-and-hold pins it (§3's
`pin`, same command, gesture-triggered). This generalizes past `ls` to
anything with output worth grabbing a piece of — `probe`'s node list,
`spec`'s clause references, whatever comes next.

### 4.3 Image/media viewer projection

Closes a real gap: right now an image or other opaque binary file only
gets `bat`'s "surface uncertainty, don't hide it" treatment
(`console-commands.md`'s Tier 2 table) — the right call for genuinely
unknown data, wrong for "this is a schematic or photo the player
should be able to look at." Projection gives image files a legitimate
third option beyond "render as text" or "flag as binary": pop it into
a viewer. Cheap in Godot — an `Image`/`TextureRect` in a Panel overlay,
no new engine capability, same overlay surface as everything else here.

### 4.4 Spatial/orbital projection — nav/solar charts, one console only

The Alex-Kamal-spinning-the-plot case, confirmed wanted but
deliberately scoped narrow: **not** a universal glove-safe capability
every console gets, but something a specific navigation/helm-class
console has because its hardware and software are built for it — same
diagnostic logic `console-commands.md` already uses for `bin/`
presence (a Scrapshell relay-diagnostic box has no business rendering
an orbital plot; a helm terminal does). Mechanically this is a `Node3D`
+ `Camera3D` scene in a `SubViewport`, composited into the UI same as
any texture, with drag input mapped to camera-orbit — a standard
trackball-control pattern, not exotic, but a genuinely bigger lift than
4.1-4.3 (real 3D content, not just dynamic 2D `Control`s). Sequence
this one last, and only once the cheaper tiers above have proven the
projection idea is fun to use at all.

## 5. Big confirm/cancel

Full-width/full-height (or near enough) modal with two oversized
buttons — `YES` / `NO`, or whatever the actual verbs are (`CONFIRM
CLAIM` / `ABORT`) — for anything consequential enough to want physically
hard to fat-finger. This is the cheapest item on the list: a
`PopupPanel`/`ColorRect` overlay with two big `Button`s, driven by
the same Action/Observation contract `ARCHITECTURE.md` §1 already
describes (the UI asks for confirmation, the player's tap *is* the
Action). Good fit for exactly the moments the game already wants to be
weighty — claiming root on a node you don't own, running a destructive
patch, cutting power to something's duty cycle mid-window.

## 6. Verdict on Godot feasibility

Not too far at all — everything here is inside Godot's ordinary
`Control`-node toolkit (dynamic UI generation, native drag-and-drop,
popups/modals, `RichTextLabel` BBCode for inline widgets). Nothing
requires a plugin, an embedded library, or a third-party UI framework.
The one real distinction worth being precise about: §1 (inline
button/light/gauge) and §5 (confirm modal) are cheap extensions of
things Sid's already built (`RichTextLabel` output, popups are stock
Godot); §2 (palette) and §4.1-4.3 (tile/token/image projection) are a
step up in that they're real overlay `Control` scenes fed by data
rather than text tricks — more work, but ordinary game-UI work, not
R&D. §3 (pin/registry) is almost pure engine-side bookkeeping (a
dictionary) and barely touches Godot at all. §4.4 (spatial/orbital
nav charts) is the one genuine step beyond `Control`-node UI into real
3D content — still standard Godot (`SubViewport`/`Camera3D`, a normal
trackball-control pattern), just a bigger, narrower-scoped lift, and
correctly the last thing on the list. None of it argues against doing
this — it argues for sequencing: §1 and §5 first (cheapest, highest
payoff), §3 next (unlocks §2), §2 and §4.1-4.3 next (the real
UI-building effort), §4.4 last and only for the one console that
actually needs it.

## 7. Open questions

- Exact key/gesture to open the quick-access palette (§2) — needs an
  actual input-binding decision, not blocking the design.
- Whether glove mode is a persistent session-wide toggle, a per-command
  flag, or auto-detected from some in-fiction signal (suit telemetry
  saying "gloves on") — leaning toward a manual toggle for v1, the
  auto-detect version is a nice later flourish, not a v1 requirement.
- Whether `pin` deserves to be a builtin (like `cd`) or a Software Bank
  command — probably Software Bank, per `console-commands.md`'s own
  rule that only things mutating shell state directly need to be
  builtins, and pinning a value doesn't need that.
- Which actual console gets §4.4's spatial/orbital projection — a ship
  helm console is the obvious candidate given the Alex Kamal reference
  point, but nothing's picked a concrete node/hardware class yet. Not
  blocking, since §4.4 is explicitly sequenced last anyway.
- **Resolved 2026-09-05 — machine file vs. personal kit:** `/etc/
  scrapper.profile` (the console-commands.md/`Console.gd` file, one per
  node) and a hypothetical portable personal profile that follows a
  tech between stations looked like two different features when this
  came up. Dan's call: for now, the single exemplar machine this repo
  is actually building against *is* the player's personal kit — no
  separate portable-profile system needed while there's effectively one
  console in play. Scale back to a real machine/personal split later,
  if and when multiple stations actually matter for play. Nothing to
  build differently today; this just settles that the current
  `/etc/scrapper.profile` isn't a placeholder waiting on a "real"
  personal file — it's standing in for one on purpose.
