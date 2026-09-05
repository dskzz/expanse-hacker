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

**§4 rewritten 2026-09-05 (still design-only, not built)**, twice, from
a follow-on conversation with Dan. First pass generalized "tile `ls`"
into a **projection** primitive rendered as on-demand overlays. Second
pass corrected the architecture: it isn't a series of per-command
popups, it's a **persistent sidebar beside the console acting as a
second renderer** over the same Action/Observation data
`ARCHITECTURE.md` §1 already describes the terminal pane rendering as
text — see §4 below for why that's a meaningfully better shape. Still
sequenced last per §6, still nothing new to build until the cheaper
pieces above prove out, and now includes an in-fiction shell extension
(§4.2) and a resolved glove-mode toggle (§7).

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

## 4. The sidebar: a second renderer, not a popup

Real-world grounding for why this doesn't need to be invented from
whole cloth: personal-device UI in the show routinely renders past the
edge of the physical screen — Miller's, Kamal's, and others' handheld
and console displays project content that isn't confined to the
device's own bezel, and it's still directly interactive (spun, dragged,
grabbed), not just decorative overflow. A shell that evolved in that
world would plausibly do the same thing: not "replace the terminal
with a GUI," and not "cram a graphical widget into a text cell," but a
genuine second surface the console can hand data to.

Concretely: `ARCHITECTURE.md` §1 already establishes that the engine
emits Action/Observation data and the UI is just a renderer over it —
the terminal pane rendering that data as scrolling text has always
been *one* renderer, not the only possible one. The sidebar is a
**second renderer of the exact same Observation**, standing to the
right of the console, not a popup summoned per command:

- The console's text output stays the required, complete rendering —
  the fallback isn't a special case anyone has to remember to build,
  it's just "the sidebar doesn't exist / doesn't recognize this
  Observation type," same ignore-unrecognized doctrine as §1's widget
  tags. A plain terminal with no sidebar loses nothing functionally.
- When the sidebar *is* present, it echoes the same structured data
  the console just rendered as text, in whatever graphical form fits
  that data's shape — a scrollable/tappable list for a directory
  listing, an image for image data, a diagram for topology data. No
  command needs bespoke "does the sidebar exist" logic; it emits one
  Observation, both renderers consume it.
- Click-and-hold on a sidebar entry pins it (§3's `pin`, same command,
  gesture-triggered — not a parallel mechanism).

This also settles how the console *looks*, not just how it behaves:
graphical chrome/decoration around the console frame, and a real,
visible, physically-sized **glove-mode toggle button** (same big-target
visual language as §5's confirm buttons) that shows/hides the sidebar
and switches the console into large-text mode — resolves the "manual
toggle vs. auto-detect" open question from an earlier draft in favor of
a big, obvious, deliberate control rather than something ambient.

### 4.1 Sidebar rendering of listings (what was "tile `ls`")

A directory listing renders in the sidebar as a scrollable, tappable
list — closer to a touchpad selection list than a fixed tile grid,
built from the exact same structured data `ls` already formats into
text. `Console.gd` needs to expose that structured data to a second
consumer (the sidebar) alongside the existing one (text) — a real seam
to add, not a rewrite, since `ls`'s own logic already resolves a VFS
node's children.

### 4.2 `$_:1`, `$_:2` — a real variable, and a deliberate shell extension

Real bash has two related but distinct things here: `!:1`, `!:2`, ...
are history *word designators* — text-expansion tricks that substitute
the Nth word of a previous command line before execution (`!^`/`!$`
shortcuts for first/last, `!*` for all); `$_` is a separate, narrower
special variable — just "the last argument of the previous command,"
not indexable, so `$_:1` isn't real bash syntax. Worth doing on purpose
rather than treating that as a limitation to work around: a SolNet-era
shell finally giving `$_` the indexing real bash always denied it is
exactly the kind of small, specific "this is what three more centuries
of shell evolution looks like" detail the whole glove-safe project is
chasing — invented, but plausible, and worth being explicit that it's
an invention, not a correction of real Unix. Mechanically it's a real
live variable (not a text-substitution trick like `!:N`): the sidebar
shows the current/last command's individual tokens as tappable/pinnable
entries, and `$_:1`/`$_:2`/etc. address them by typed name too, so the
gesture and the typed form are the same underlying primitive — same
doctrine as everywhere else in this doc.

### 4.3 Image/media viewer

Closes a real gap: right now an image or other opaque binary file only
gets `bat`'s "surface uncertainty, don't hide it" treatment
(`console-commands.md`'s Tier 2 table) — right for genuinely unknown
data, wrong for "this is a schematic or photo the player should be
able to look at." The sidebar gives image Observations a legitimate
third option beyond "render as text" or "flag as binary": an
`Image`/`TextureRect` in the sidebar, no new engine capability.

### 4.4 Network/link topology diagrams

Broadly available, not narrowly scoped — this is the same link/DTN
state `/link` already exposes on every Scrapshell node
(`os-lineages.md` §5: link state, lag, queues, integrity), rendered
spatially instead of as files, with drag-to-rotate the same way any
`SubViewport`/`Camera3D` trackball control works. Directly useful for
the "nearby nodes" example that motivated `pin` (§3) in the first
place — seeing that list as an actual topology diagram, not just a
scrollable list, is the natural upgrade path once 4.1 exists.

### 4.5 Nav/solar plots — a real future mechanic, not scoped yet

Confirmed still wanted, but explicitly future work, not something to
architect now: the show's actual precedent isn't just visual (spinning
a pretty globe) — Miller uses the plot functionally, to work out where
the *Scopuli* would intercept the *Anubis*. That's a mission mechanic
(compute/visualize an intercept), not a UI widget, and it deserves to
be designed against a concrete mission that needs it rather than
pre-scoped to a specific console now. Mechanically it'd still be the
same `Node3D`/`Camera3D`-in-`SubViewport` approach as 4.4, just with
orbital-mechanics data instead of network topology — noted for later,
not blocking anything above.

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
Godot); §2 (palette) and §4.1-4.3 (sidebar list/variable/image
rendering) are a step up in that they're real overlay `Control` scenes
fed by data rather than text tricks — more work, but ordinary game-UI
work, not R&D. §3 (pin/registry) is almost pure engine-side bookkeeping
(a dictionary) and barely touches Godot at all. §4.4 (network/link
topology) is the one genuine step beyond `Control`-node UI into real 3D
content — still standard Godot (`SubViewport`/`Camera3D`, a normal
trackball-control pattern) but broadly available rather than narrowly
scoped, since it's the same `/link` data every node already has. §4.5
(nav/solar plots) is deliberately not scoped at all yet — real future
work, not a v1 target. None of it argues against doing this — it
argues for sequencing: §1 and §5 first (cheapest, highest payoff), §3
next (unlocks §2), the sidebar (§2, §4.1-4.3) next as the real
UI-building effort, §4.4 after that once the sidebar exists to render
into, §4.5 whenever a concrete mission actually needs it.

## 7. Open questions

- Exact key/gesture to open the quick-access palette (§2) — needs an
  actual input-binding decision, not blocking the design.
- **Resolved 2026-09-05 — glove-mode toggle:** a manual toggle, not
  auto-detect (suit telemetry saying "gloves on" is still a nice later
  flourish, not a v1 requirement) — and specifically a real, visible,
  physically-sized button as part of the console's graphical chrome
  (§4), not a hidden keybind. Auto-detect stays a possible later
  addition on top of this, not a replacement for it.
- Whether `pin` deserves to be a builtin (like `cd`) or a Software Bank
  command — probably Software Bank, per `console-commands.md`'s own
  rule that only things mutating shell state directly need to be
  builtins, and pinning a value doesn't need that.
- §4.5's nav/solar plot mechanic (which console, what mission needs it,
  how orbital-mechanics data actually gets computed) is deliberately
  unscoped — explicitly future work per Dan, not something to design
  ahead of a concrete mission that needs it.
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
