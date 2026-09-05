# 2026-09-05 — Glove-safe UI: inline widgets, palette, pin/registry, tile ls, big confirm

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

New design doc: `docs/systems/glove-safe-ui.md`. Also cross-linked from
`ARCHITECTURE.md` §4 and `docs/systems/README.md`. Full reasoning is in
the doc; here's the shape and what actually lands on your side.

## Where this came from

Dan's framing: if this is a *future* system and not just next-gen
branding, the interaction model itself has to feel evolved — not just
the names. Concretely: a tech working outside in a suit, gloved, can't
rely on precision typing. The shell should be able to fail over to
something tap/drag-friendly without turning into a full GUI framework.
Also explicitly confirmed: it still has to **fail over cleanly to plain
text** wherever glove-safe isn't supported or engaged — same TLV
ignore-unrecognized doctrine the protocols already use, just applied to
UI markup instead of protocol fields.

## The five pieces (full detail in the doc)

1. **Inline widgets** — button/status-light/gauge/confirm, four
   primitives only. Cheap: `RichTextLabel` BBCode `[url]`/`meta_clicked`
   for buttons, `[img]` or block-chars for gauges/lights. Extends what
   you've already built, doesn't replace it.
2. **Pop-out quick-access palette** — a real overlay `Control`
   (Panel + Button grid), linked from the prompt, mixing static pinned
   commands and live pin/registry entries (#3). Genuinely a new UI
   surface, not a text trick, but ordinary Godot UI work.
3. **Pin/registry mechanic** — `pin <expr> => <slot-name>`, a flat
   named-value store (think a `Dictionary` on session state) that
   feeds the palette. **Recommend snapshot semantics for v1** (capture
   value at pin time, not a live subscription) — a live-updating
   version needs a real observer/notify mechanism and nothing in the
   game needs that yet. Flagging this explicitly since it's the one
   place a bigger version is one word away ("live" vs "pinned") and
   worth deciding once rather than drifting into it.
4. **Glove-mode `ls`: large tiles, drag-and-drop** — the one place
   this stops being "text with widgets" and becomes a real second
   rendering path. Needs `Console.gd`'s `ls` to expose its structured
   listing data to a UI layer that builds a `GridContainer` of tiles
   from it (one `Control` per entry), alongside the existing text path.
   Drag-and-drop itself is native Godot (`_get_drag_data`/
   `_can_drop_data`/`_drop_data`), not a library. This is the biggest
   actual lift of the five, but it's ordinary game-UI work, not R&D.
5. **Big confirm/cancel** — a modal with two oversized buttons for
   consequential actions (claiming root, destructive patches). Cheapest
   item on the list, stock Godot popup + Action/Observation contract
   you've already got from `ARCHITECTURE.md` §1.

## Godot feasibility read (Dan asked directly whether this is too far)

Short answer: no, none of it is a stretch. Everything's inside ordinary
`Control`-node territory — dynamic UI generation, native drag-and-drop,
popups, BBCode. No plugin, no embedded library, nothing exotic.
Suggested sequencing if/when you pick this up: #1 and #5 first (cheap,
extend existing work), #3 next (unlocks #2), #2 and #4 last (the real
UI-building effort, worth doing once the cheaper pieces prove the
concept is fun).

## Open questions for you, not blocking

- Palette open gesture/keybind.
- Glove mode as a manual toggle vs. auto-detected from suit state —
  doc leans manual for v1.
- Whether `pin` is a builtin or a Software Bank command — leaning
  Software Bank per `console-commands.md`'s own builtin criteria
  (doesn't mutate shell state directly the way `cd`/`pwd` do).
