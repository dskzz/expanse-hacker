# Console Commands: What Fills `bin/`

Status: drafted 2026-09-04, grounded directly against `code/scripts/
tools/Console.gd` and `db/vfs/` as they actually exist right now, not
just theory. Prompted by Dan noticing `bin/`/`usr/bin/` exist in the
real VFS data as near-empty directories and asking how to fill them.

## The real shape, as implemented today

`Console.gd`'s command dispatch is a hardcoded `match cmd:` with seven
entries: `help`, `clear`, `whoami`, `pwd`, `cd`, `ls`, `cat`. Anything
else prints `command not found`. `usr/bin/` in `db/vfs/templates/
scrapshell.json` is a real directory in the data — currently `children:
{}`. **"Filling up `bin/`" concretely means authoring `db/software/`
entries (Sid's Software Bank, see `reference/software_bank.md`), not
adding more `match` cases to `Console.gd`.** That distinction is the
actual design decision this doc is about, not a detail — get it right
and the system scales by adding data; get it wrong and every new
command is a code change.

## Two tiers, and they're genuinely different kinds of thing

**Builtins** — commands that need direct access to shell state
(`_cwd`, `_history`, the output buffer) or are so fundamental they're
reasonable to bake in. `cd` and `pwd` *must* be builtins — they mutate
shell state directly. `ls`, `cat`, `whoami`, `help`, `clear` are
builtins today too, which is a defensible simplicity call for a first
pass, not a hard requirement — nothing below argues for moving them,
since they're universal enough on every real Unix that "which lineage
has `ls`" was never going to be an interesting question.

**Software Bank commands** — everything content-defined, lineage-
forkable, and meant to vary by node: real coreutils successors,
`spec`/`probe`, and the lineage-specific root commands. These are what
`usr/bin/` should actually fill up with, as real Software Bank
`instances/` entries that resolve to a VFS file node Console's
dispatcher checks *after* the builtin match fails and *before* printing
"command not found."

That fallthrough order is the one concrete engine-side change this doc
is asking for: unknown command → check current node's `usr/bin/` (from
the loaded VFS) for a matching entry → if found, run its effect →
otherwise, `command not found`. Everything else here is content.

## Tier 2, populated: real tool succession

Same logic as the mousetrap/toilet argument that grounds this whole
project — "the internet, but 300 years on" mostly *refines*, it
doesn't reinvent. Applied one level down, to coreutils themselves: a
handful of today's already-winning replacements are the plausible
SolNet baseline, not their 1970s ancestors.

| Classic | Real successor (already winning today) | Why it plausibly won | SolNet baseline | Scrapshell dialect |
|---|---|---|---|---|
| `grep` | ripgrep | faster, sane defaults, respects ignore-rules | `rg` | same — the "alternative" framing died out long before now |
| `find` | fd | friendlier syntax, sane defaults | `fd` | same |
| `cat`-adjacent | bat | shows corruption/binary/truncation *explicitly* instead of garbling — fits RFC-2304 §4's "surface uncertainty, don't hide it" doctrine directly | `bat` (Console's builtin `cat` stays the plain/fast path; `bat` is the diagnostic one) | same |
| `sed` | sd | safer regex defaults, fewer footguns | `sd` | same |
| `diff` | delta | genuinely readable output — the tool a tech uses to compare `/etc/patches.log` against what `spec` says the RFC requires | `delta` | Scrapshell calls running it on a config "pulling a Dawes" — folk-named after whoever first used it to prove a station's config didn't match standard, during the BRA years |
| `du` | dust | visual, tree-based — useful for a finite physical scratch chip (`/tmp`) | `dust` | same |
| `ps`/`top` | procs/bottom | shows resource budgets per tenant, not just per process — direct fit for the tenant/namespace layer (`ARCHITECTURE.md` §2) | `btm` | same |
| `cd`-adjacent | zoxide | frecency-jump across a DTN filesystem with many relay hops is a bigger real win here than on a laptop | `z` | same |
| *(no classic ancestor)* | jq | content is JSON now, for real, not fictionally — querying a `PowerCapabilityRecord` with jq-style syntax is load-bearing | `jq` | same |
| `man` | tldr-style curation | short, curated example beats a full-text dump for daily use | this is what `spec` already *is* — see below | — |

Pattern worth keeping as a filter for future additions: tools that won
on **pure mechanical merit** (`rg`, `fd`, `sd`, `jq`) just keep their
real name — the timescale (see `os-lineages.md` §1, ~50 years since
the RFCs shipped, same order of magnitude as real Unix's own fork
history) is long enough that "alternative" stopped meaning anything.
Tools that became **a technician's specific move** rather than just a
utility (`delta`-as-config-audit) are where Scrapshell folklore/slang
actually attaches — same pattern as `/etc` → "Everyone's To-Change."
Don't invent slang uniformly; only where a tool became a *practice*,
not just a program.

## `spec`, restyled

`spec <protocol>` should be styled like `tldr`, not `man`: a short,
curated hit (the specific clause that matters) with a `--full` flag
for the complete RFC text, not a wall of text by default. This isn't
new behavior — the worked example in `os-lineages.md` §6 already reads
this way — just naming the actual precedent so future protocol entries
stay consistent with it rather than drifting toward full-text dumps.

## Per-lineage `bin/` presence is diagnostic, not decorative

A Scrapshell box's `usr/bin/` should not contain `elevate` — that
binary was never part of its lineage, the same way `claim` was never
part of Earthstock's. This means **which commands exist on a node is
itself something `probe` (or just `ls /usr/bin`) can reveal about its
fork** — not flavor text bolted onto a fixed universal command set. A
`db/software/templates/` lineage base should define its own root-model
command (`scrapshell.json` ships `claim`, `earthcore.json` ships
`elevate`, etc.) rather than one shared template shipping all four
gated by a flag.

## Physical actions stay out of `bin/`

`ARCHITECTURE.md` §4 treats physical actions (install/remove a
component) as peers to console commands, not console commands
themselves. Nothing here proposes a CLI shortcut for installing a
`vars-buffer-mk2` — that stays the physical-tool pane's job. Worth
holding this line deliberately: a CLI shortcut for physical actions is
exactly the kind of thing that quietly turns the physical pane back
into decoration.

## Open questions

- ~~Scripting (`sh <script>` or equivalent, running against the
  sandboxed scripting host) isn't addressed here~~ — **resolved
  2026-09-05**: see `docs/systems/scripting.md` — a native-GDScript
  shell-script interpreter, not an embedded language, reusing the same
  command dispatch and variable primitives (`pin`, `$_:N`) as
  interactive use.
- ~~No content exists yet in `db/software/`~~ — **done 2026-09-04**:
  `spec`, `probe`, and `claim` (Scrapshell's root command) are real,
  wired into `usr/bin`, with working effect handlers in `Console.gd`
  reading actual `db/protocols/`/`hardware/`/`components/` content.
  See `reference/software_bank.md`.
- ~~Whether `bat`/`rg`/etc. need actual behavioral implementations...~~
  — **answered 2026-09-04** by `ARCHITECTURE.md` §2's generic algorithm
  backend (Sid's proposal, `reference/algorithm_backend.md`): mostly
  cheap/native (GDScript's own `RegEx`/JSON cover most of Tier 2), one
  shared engine-level backend (emulated-sandbox or hosted-real-binary,
  never a general process-exec capability) reserved for the few where
  the algorithm itself is genuinely hard — `delta`/diff being the
  concrete first case, not `rg`/`sd`/`jq`.
- **`rg`, `fd`, `jq`, `bat`, `z` built 2026-09-05** — real Software Bank
  entries + `Console.gd` effect handlers, confirming the native-GDScript
  read above: `rg`/`fd` walk the VFS tree with `RegEx`/substring match,
  `jq` does a single dotted-path lookup against a protocol/hardware doc
  (not full jq filter syntax), `bat` adds a header/line numbers and
  explicitly flags opaque/binary content per RFC-2304's doctrine, `z` is
  recency-only (not true frecency) against a session-local visited-dirs
  list. `delta`/diff and `sd` still not built — `sd` specifically needs
  real file-write support, which nothing has yet (same gap as editing
  `/etc/scrapper.profile` live). `dust`/`btm` not attempted — lower value
  without the tenant/namespace engine layer they're meant to visualize.
- ~~Real file-write support, which `sd` and live-editing
  `/etc/scrapper.profile` were both blocked on~~ — **closed 2026-09-05**:
  `docs/systems/text-editor.md`'s shared `CodeEdit`-backed editor is
  real, engine-level (not a Software Bank/`usr/bin` entry — every
  lineage needs *an* editor even before its own naming/succession story
  is written), dispatched by matching `Console.gd`'s `_editor_name`
  (loaded from `identity.editor_name`) rather than a fixed command
  string, so only the name varies per lineage. Scrapshell's is
  `scredit` (`scrapshell.json`). Nano-shaped everywhere, real `Ctrl-O`
  write-out/`Ctrl-X` exit keybindings as the primary path (buttons
  additive, see `TextEditorOverlay.gd`). `sd` and live `.profile`
  editing are now both unblocked in principle but still not built —
  this only landed the editor itself.
