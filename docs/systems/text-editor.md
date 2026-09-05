# Text Editor: One Core, Per-Lineage Veneer

Status: drafted 2026-09-05, closing a gap flagged repeatedly but never
addressed — `scrapshell.json`'s own notes on `/etc/scrapper.profile`
say "no in-game text editor exists yet to let a player edit this
live," and `console-commands.md` blocks `sd` on "real file-write
support, which nothing has yet." Design-only, nothing built.

## 1. Why one editor, not four

Building four bespoke lineage editors is a lot of surface area for
something with a well-earned reputation for edge cases. There's
already a house pattern for exactly this problem — shared substrate,
thin per-lineage veneer, same shape as Console's dispatch being one
implementation with per-lineage `usr/bin` contents, or the confirm
modal being one component with a per-lineage accent color
(`glove-safe-ui.md` §5). One editor core, backed by Godot's built-in
`CodeEdit` node (multi-line editing, syntax-highlighting hooks, no
need to build a text widget from scratch); lineage identity is a
keybinding/theme *preset* on top of it, not a separate implementation.

## 2. Base editing model: nano-shaped, not real vi or Emacs

Real vi is a full motion/operator composition grammar; real Emacs is
close to a Lisp machine with an editor attached. Building either
faithfully would dwarf everything else in this project for a payoff
that's mostly cultural flavor, not gameplay. Default editing model
across all lineages: **nano-shaped** — always-insert-mode, a small flat
command set, no modal states to remember. Small surface area, few edge
cases, and it's the actual typing experience regardless of which
lineage's box you're on.

Worth being explicit about which part of "nano-shaped" is a rendering
artifact and which part isn't, since it's not all one thing:

- **The visible `^O Write Out  ^X Exit` footer is a rendering
  artifact** — plain text because that's all a real terminal could do.
  No reason to keep that specific presentation: the glove-safe widget
  vocabulary (`glove-safe-ui.md` §1) and the sidebar (§4) already
  render actual tappable buttons, which are strictly better for
  discoverability than an ASCII hint row.
- **The `Ctrl`-key shortcuts underneath are not a rendering artifact —
  keep them as the real, primary path.** Power users default to
  keyboard shortcuts because staying on the keyboard preserves flow;
  reaching for a button on every save/cut breaks that on purpose for
  no reason. So `Ctrl-O`/`Ctrl-X`/etc. stay live and primary for typed
  use, exactly as in real nano.

Buttons are additive, not a replacement — same "gesture is sugar over
a real command" doctrine as `pin`'s tap-and-hold (`glove-safe-ui.md`
§3) and `$_:N`'s tap-vs-type duality (§4.2): the shortcut is the real
action, the button is a second, equally real way to trigger the exact
same thing, there for discoverability and for glove mode specifically
(where reaching a physical `Ctrl` chord one-handed in a suit glove is
the actual problem being solved, not a taste preference). Nano's
genuine contribution here is the *model* — flat, modeless, no hidden
state — not its keyboard shortcuts being disposable; those stay.

## 3. Where the evolved feeling actually lives: naming history, not keybindings

First instinct (below, revised 2026-09-05) was to let Scrapshell's
editor *feel* modal — `:w`/`:q`-shaped surface vocabulary — without
implementing real vi's grammar underneath. Dan's catch: even that
shallow a gesture starts to unravel fast. The moment any vi vocabulary
shows up at all, copy/paste, visual-mode selection, and count-prefixed
motions (`3dw`) stop being optional — players expect coherence, and
those compose combinatorially in a way "just `:w` and `:q`" can't
honestly promise. Not worth it even as flavor.

Better home for the "this has evolved, this feels lived-in" payoff:
**the editor's own naming history**, not its keybindings. Real
precedent, and a good one — pico shipped with Pine (University of
Washington's mail client) under a restrictive license that kept it out
of free distros; nano was written from scratch as a free reimplementation
of *the exact same interface* (originally named "TIP: TIP Isn't Pico").
The interaction model barely changed across that fork — what changed
was ownership and licensing, not functionality. That's a real-world
instance of the same thesis `os-lineages.md` §0 already runs the whole
project on ("solves a truly general problem, so time refines the edges
instead of replacing it"), just applied to an editor's *name* instead
of its behavior.

So: keep the interaction model **identical** across lineages (§2,
nano-shaped, no vi gesture at all) and let a lineage's editor instead
carry its own small succession story — renamed or re-forked once or
twice across the ~50 years of post-OPRA divergence for reasons that are
political/social/licensing-flavored, not functional (a union fork after
a dispute, a maintainer's affiliation changing hands), the same way
`os-lineages.md` §2's OS/shell naming table already gives each lineage
its own product history. Cheaper than partial-vi, and more honest about
where "evolution" actually shows up in software that already solved its
problem once: the changelog is mostly who owns it and what it's called,
not what it does.

### Scrapshell's editor: `scredit` (locked 2026-09-05)

The OPRA-era joint drafting suite (~2339-42, `os-lineages.md` §1) that
compiled the L0/L1 RFC text bundled a plain, unremarkable composer for
the job — dry and forgettable on purpose, the kind of utility an
institutional coalition never bothers branding because it just works
(fits Earthstock's naming register: functional, not cute). BRA relay
techs did much of the actual RFC-compiling grunt work, and being
dockworker-practical, never called the tool by whatever technical name
it had — they called the *task*: grinding out a long, tedious technical
writeup (an incident report, a patch justification, anything destined
for an append-only log like `patches.log`) was "screeding," Belt slang
for writing a literal screed.

When BRA got pushed out post-OPRA (~2342-47, same section), it lost
standing — and with it, licensed/signed access to the official,
institutionally-administered suite, same mechanism real pico's license
being tied to an institution actually worked. Locked out, and unwilling
to lose the one tool they used daily for exactly the kind of writing
their whole append-only-log culture runs on, BRA-descended engineers
rebuilt the composer from scratch as free, hand-patched software —
identical flat, modeless interaction, nothing to relearn. They named
their own clone honestly, after the only thing anyone ever actually
called using it: **Screed Editor**. Decades of hand-patched Scrapshell
maintenance eroded that into **`scredit`** — same folk-contraction
instinct as `sash` from "Scrapshell sh."

Present day: `scredit` is just what a Scrapshell tech opens to write
anything — patch justifications, incident writeups, scripts. The
interaction model never changed; only the name, the ownership, and who
was allowed to touch it did. The concrete, mundane instance of
`os-lineages.md` §0's whole thesis, and a direct mirror of real
pico-to-nano per this section's own argument above.

## 4. Glove-mode vs. typed-mode: physics vs. politics, again

The same argument `glove-safe-ui.md` §0 makes for why glove-safe
interaction stays unified across lineages applies here directly: a
pressure glove doesn't care whose editor convention you grew up on, and
Earthers/Martians/Belters doing EVA/hardware work all face the
identical physical constraint. So:

- **Glove-mode rendering is universal, not lineage-specific.** A big-
  tap text buffer with on-screen action buttons standing in for
  keystrokes (save, cut, paste) — this is just the sidebar/projection
  system from `glove-safe-ui.md` §4 rendering *this* editor's buffer
  instead of `ls` output, not a new architecture. One editor, two
  renderers, exactly the same pattern as the sidebar being a second
  renderer of the same Action/Observation data everywhere else.
- **Typed/ungloved editing behavior is also unified** now that §3
  drops the vi-flavor gesture — the actual keybindings are the same
  nano-shaped set everywhere. What's free to diverge per lineage is
  the editor's *name and ownership history* (§3), not its behavior —
  the same split as `bash`/`sash`/`msh` sharing near-identical shell
  behavior under genuinely different names.

## 5. No wrapping a third-party editor (Notepad++, etc.)

Recommend against. `ARCHITECTURE.md` §2 already decided, on purpose,
that hosted execution is never a general external-process/application
surface exposed to content — only a fixed, curated set of specific
bindings (`diff` today, see `reference/algorithm_backend.md`).
Launching a real external GUI editor is a much bigger, much less
curated version of exactly what that decision was written to prevent,
and it's platform-locked (Notepad++ is Windows-only) in a way that
breaks the headless/web portability the project's own test suite
(`testing/console_smoke_test.gd`) depends on.

## 6. Import/export from the player's real filesystem: worth it, scoped narrow

Not really a 4th-wall break if it's framed as an unglamorous QoL
feature rather than a narrative device — save/load doesn't get an
in-fiction justification either. Mechanically it's just a file
read/write through Godot's native `FileDialog`, nothing that touches
the process-exec boundary §5 above leans on. Real precedent for wanting
this: Screeps-style "write your actual code in your actual tools" is a
beloved feature for the exact audience a hacking game attracts.

Scope: an explicit **import script from disk** / **export to disk**
action pair, not a live-synced folder and not launching an external
app. Whether this covers any VFS file or just scripts specifically is
open (§8).

## 7. What this closes

Once a real editor exists and can write back to a VFS node's `content`
field, two previously-flagged gaps resolve for free: `sd` (needs real
file-write support, `console-commands.md`'s own blocker) and live-
editing `/etc/scrapper.profile` (`scrapshell.json`'s own "next step
this file sets up for" note).

## 8. Open questions

- ~~Scrapshell's actual editor name/succession story (§3) isn't written
  yet~~ — **resolved 2026-09-05**: `scredit` (Screed Editor), see §3.
  Other lineages' editor names/histories are still open — same exercise
  as `os-lineages.md` §2's OS/shell table, not done for Earthstock/
  Mars/Corporate yet.
- Whether the editor is a builtin (like `cd`) or engine-level UI
  infrastructure alongside Console itself — leaning toward the latter,
  since it's not lineage-installable content the way Software Bank
  commands are, every lineage needs *an* editor even if the typed-mode
  flavor differs.
- Import/export scope (§6): scripts only, or any VFS file — not
  decided.
