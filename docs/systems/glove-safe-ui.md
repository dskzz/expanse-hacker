# Glove-Safe UI: Mixing Real Widgets Into the Shell

Status: drafted 2026-09-05, from Dan's core observation that if this is a
future system and not just next-gen branding, the *interaction model*
has to have visibly evolved too — not just the names. Motivating case:
a tech working a splice outside in a suit, gloved, can't rely on
precision typing or small text. The shell has to fail over to something
tap/drag-friendly without turning into "a whole GUI."

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

## 4. Glove mode: large-tile `ls`, drag-and-drop

This is the one place where "widgets embedded in a text stream" stops
being the right mental model. Tap-target-sized file/dir tiles that you
can drag to a "save spot" aren't an annotation on top of `ls`'s text
output — they're a genuinely different rendering of the same
`ls`-shaped data. Concretely: glove mode's `ls` isn't `RichTextLabel`
text at all, it's a grid of real `Control` nodes (one per entry: name,
icon/type glyph, size), generated from the exact same directory-listing
data structure that plain-mode `ls` formats into text.

The good news: this is squarely inside what Godot's `Control` node
already does natively, not exotic.

- Drag-and-drop is a built-in `Control` API —
  `_get_drag_data`/`_can_drop_data`/`_drop_data` — no plugin, no
  library. A file tile returning its VFS path from `_get_drag_data`,
  and a "save spot" `Control` accepting it in `_drop_data`, is a normal
  Godot pattern, not a stretch.
- Generating a tile grid from data at runtime (N children of a
  `GridContainer`, built in a loop from the same listing the text `ls`
  already walks) is bread-and-butter dynamic UI, nothing unusual.

The actual scope increase versus §1-3: `Console.gd` needs to expose the
*structured* directory-listing data (which it almost certainly already
has internally to build the text `ls` output) to a UI layer that can
build tiles from it, rather than only emitting formatted text. That's a
real seam to add, not a rewrite — `ls`'s existing logic already resolves
a VFS node's children; glove mode just needs a second consumer of that
same data (tiles) alongside the existing one (text).

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
Godot); §2 (palette) and §4 (tile `ls`) are a step up in that they're
real overlay `Control` scenes fed by data rather than text tricks — more
work, but ordinary game-UI work, not R&D. §3 (pin/registry) is almost
pure engine-side bookkeeping (a dictionary) and barely touches Godot at
all. None of it argues against doing this — it argues for sequencing:
§1 and §5 first (cheapest, highest payoff), §3 next (unlocks §2), §2 and
§4 last (the real UI-building effort).

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
