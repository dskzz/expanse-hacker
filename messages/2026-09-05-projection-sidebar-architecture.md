# 2026-09-05 — §4 corrected again: sidebar as a second renderer, not popups

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Supersedes this morning's "projection surfaces" message — same day,
one more real correction from Dan before this settles. Still
design-only, nothing built, no action needed right now, just don't
build against the version in the earlier message.

**The actual architecture:** not per-command popup overlays. A
**persistent sidebar to the right of the console** that's a second
renderer over the same Action/Observation data the terminal already
renders as text (`ARCHITECTURE.md` §1). The console's text stays the
complete, required rendering; the sidebar, when present, echoes the
same structured data graphically. No command needs to know the sidebar
exists — it emits one Observation, both renderers consume it, and "no
sidebar" degrades to exactly what exists today. This also resolves the
open question about the glove-mode toggle: it's a real, visible,
physically-sized button (matching the confirm-modal's big-target
language) that shows/hides the sidebar and switches to large-text
mode, plus general graphical chrome/decoration around the console
frame — not a hidden keybind, not auto-detected (that's a later
flourish on top, not instead of).

What the sidebar renders (`docs/systems/glove-safe-ui.md` §4.1-4.5):

- **4.1 Listings** — a directory listing as a scrollable/tappable list
  (touchpad-style, not a fixed tile grid), same structured data `ls`
  already builds.
- **4.2 `$_:1`/`$_:2`** — worth calling out precisely: real bash's
  `!:1`/`!:2` are history word-designator text-substitution, and `$_`
  is separately just "last argument," not indexable — `$_:1` isn't
  real syntax. Proposing SolNet's shell deliberately give `$_` the
  indexing real bash never had, as a genuine live variable (not a
  substitution trick), with the sidebar showing a command's tokens as
  tappable/pinnable entries that `$_:N` also addresses by name. Same
  gesture-is-sugar-over-a-real-command doctrine as everywhere else.
- **4.3 Image/media viewer** — closes the real gap next to `bat`'s
  binary-file handling.
- **4.4 Network/link topology** — broadly available (not console-
  scoped), since it's the same `/link` data every node already has,
  just rendered as a rotatable diagram instead of files.
- **4.5 Nav/solar plots** — confirmed still wanted, explicitly **not**
  scoped yet. Dan's reference point is functional, not decorative:
  Miller uses the plot to work out the *Scopuli*/*Anubis* intercept,
  not just to look at a spinning globe. That's a mission mechanic to
  design against a concrete mission, not a UI widget to build ahead of
  one — noted as real future work, not a v1 target, not blocking
  anything else in this doc.

Sequencing unchanged in spirit, updated in specifics: §1/§5 first
(shipped), §3 next (unlocks §2), the sidebar itself (§2 + §4.1-4.3)
next as the real UI-building effort, §4.4 once the sidebar exists to
render into, §4.5 whenever an actual mission needs it.
