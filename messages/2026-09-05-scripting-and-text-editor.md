# 2026-09-05 — Scripting and text editor, both design-only

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Two new docs, both resolving long-open items, both design-only —
nothing built, no action needed right now.

## `docs/systems/scripting.md` — `sh`/`sash <script>`

Closes `ARCHITECTURE.md` §7's oldest open item (scripting host choice)
and fixes a real staleness bug while I was in there: §2's "Scripting
host" bullet still said "sandboxed Lua via Inline::Lua, or a restricted
Perl safe-compartment" — leftover from the pre-Godot proposal,
contradicted by §5's own note that engine+UI are Godot now. Fixed.

The actual design: not an embedded language. A small native-GDScript
shell-script interpreter — variables (same primitive as `pin`'s
registry and `$_:N`), pipes, `for`/`if`, command invocation through the
*identical* dispatch path interactive typing uses. Reframe worth
noting: "sandboxed" here doesn't mean adversarial-safe (single-player,
no untrusted third party) — it means in-fiction-scoped (a technician
writes shell scripts, not arbitrary code) and non-hanging (a bounded
per-frame step budget, yield and resume, instead of a real sandbox).
The vocabulary itself is the wall.

## `docs/systems/text-editor.md` — one editor, per-lineage veneer

Closes a gap flagged twice already: `scrapshell.json`'s own notes on
`/etc/scrapper.profile` ("no in-game text editor exists yet") and
`console-commands.md`'s `sd` blocker ("needs real file-write support,
which nothing has yet"). Once this exists and writes back to a VFS
node's `content`, both resolve for free.

Shape: one `CodeEdit`-backed editor core, not four bespoke ones — same
shared-substrate-plus-veneer pattern as Console dispatch or the confirm
modal's per-lineage accent color. Base editing model is **nano-shaped**
(always-insert, on-screen hints, `Ctrl`-shortcuts) — **identically, on
every lineage, no vi gesture at all**, which is a revision worth
flagging: first pass had Scrapshell's editor *feeling* modal via
surface vocabulary (`:w`/`:q`) without real vi grammar underneath, but
Dan caught that even that shallow a gesture snowballs — the moment any
vi vocabulary shows up, copy/paste and visual-mode selection stop
feeling optional, and that's real vi's actual complexity, not a
shortcut around it.

Better home for the "this evolved" payoff, and a nice one: real pico →
nano is a case of a functionally-frozen interface getting renamed/
reimplemented for licensing reasons (pico was Pine's non-free-licensed
editor; nano's a free clone of the identical interface, originally
called "TIP: TIP Isn't Pico") — same `os-lineages.md` §0 thesis, just
applied to an editor's *name* instead of its behavior. So: identical
nano-shaped interaction everywhere, and each lineage's editor instead
gets its own small naming/ownership succession story (a union fork
after a licensing dispute, etc.) — same exercise as the OS/shell naming
table, not done for editors yet (open question in the doc).

Glove-mode rendering is universal across lineages either way, same
physics-not-politics argument `glove-safe-ui.md` §0 makes — it's just
the sidebar/projection system (§4) rendering this editor's buffer
instead of `ls` output, not new architecture.

Also recommended against wrapping a real third-party editor
(Notepad++, etc.) — runs straight into the process-exec boundary
`ARCHITECTURE.md` §2 already decided on purpose (curated bindings only,
never a general external-app surface), plus it's platform-locked and
breaks headless/web portability. Import/export from the player's real
disk is worth it instead, scoped narrow (an explicit file-dialog action
pair, not a live-synced folder) — it's a plain file read/write, doesn't
touch that boundary at all, and is real precedent for the technically-
inclined audience this game attracts (Screeps does the same thing).

Both docs have open questions sections if you want the specifics
before picking either up.
