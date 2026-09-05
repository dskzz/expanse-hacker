# 2026-09-05 — glove-safe §4 generalized into "projection surfaces"

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

`docs/systems/glove-safe-ui.md` §4 rewritten — still design-only, none
of this is built, no action needed on your side right now, just flagging
it since it changes the shape of the biggest deferred item. §1/§2/§3/§5
(everything you've already shipped) are unchanged.

What was one idea (tile `ls` + drag-and-drop) generalized into one
**projection** primitive: any command output that doesn't belong in the
flat text scroll gets a button that pops it into a tappable/viewable
overlay — same kind of surface as `PaletteOverlay`, just fed different
data. Four instances, cheapest to most expensive:

- **4.1 Tile projection** — what §4 already was, `ls` output as a real
  `GridContainer` of draggable tiles, now explicitly *on-demand* (a
  button) rather than a standing "glove mode" that changes how `ls`
  always renders. Text stays the default rendering either way.
- **4.2 History-token projection** — the glove-mode equivalent of
  bash's `!:1`/`!:2` word designators: project any output, tap a token
  to insert it into the input line, tap-and-hold to `pin` it (your
  existing command, just gesture-triggered — not a new primitive).
- **4.3 Image/media viewer** — closes a real gap. Right now an image
  file just gets `bat`'s "surface uncertainty" binary-file treatment,
  which is right for genuinely unknown data and wrong for something a
  player should actually be able to look at. Cheap: `Image`/
  `TextureRect` in a Panel overlay.
- **4.4 Spatial/orbital projection** — the Alex-Kamal-spinning-the-plot
  case (nav/solar charts). Deliberately scoped to one console, not a
  platform-wide capability — matches the existing bin/-presence-as-
  diagnostic logic, a helm-class machine has this because it's built
  for it, a relay-diagnostic box doesn't. Real `Node3D`/`Camera3D` in a
  `SubViewport`, standard trackball-control pattern, but a genuinely
  bigger lift than 4.1-4.3 — sequenced last, gated on the cheaper tiers
  actually being fun first. No console picked for it yet (open question
  in the doc, not blocking).

Also two small additions to what you already built: a dedicated
`Variables` button next to `☰` for the palette (§2), same data, just a
second labeled entry point straight to the registry half; and a note
in §3 that tap-and-hold-to-pin (4.2) is sugar over your existing `pin`
command, not a parallel mechanism.
