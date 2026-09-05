# Shell Scripting: `sh <script>` and the `sash` Dialect

Status: drafted 2026-09-05, resolving `ARCHITECTURE.md` §7's long-open
"scripting host choice" item and `console-commands.md`'s "scripting
isn't addressed here" note. Design-only, nothing built.

Prompted by Dan's direct observation: a hacking game needs at least
basic scripting — writing a patch script, automating a probe across
several relays — not just one-shot interactive commands.

## 1. Not an embedded language — a shell-script interpreter

`ARCHITECTURE.md` §2 used to list "sandboxed Lua" or "a restricted Perl
compartment" as scripting-host candidates. Both predate the Godot
decision and both solve a harder problem than this project actually
has: they're general-purpose embedded languages, sized for letting
untrusted code do arbitrary things safely. This project doesn't need
that, for a reason worth being explicit about: it's single-player, so
there's no untrusted third party submitting code to defend against.
"Sandboxed" here means something narrower and cheaper — (a) staying
in-fiction (a technician writes shell scripts, not arbitrary programs)
and (b) not letting a runaway loop hang the game client.

Both are solved by keeping the scripting surface exactly as big as the
interactive shell already is: variables, pipes, simple `for`/`if`
control flow, and command invocation that goes through the **identical
Action/Observation dispatch** interactive typing uses — a script
calling `probe` is the same engine call a human typing `probe` makes,
not a special back door. Nothing needs separately walling off, because
the vocabulary itself is the wall. This is also just accurate to what
`ARCHITECTURE.md` §4 already described ("writing a patch script...is
the same execution path, not a fake minigame") — this doc makes that
concrete instead of leaving it aspirational.

Real-world grounding, same pattern as the rest of this project: POSIX
shell scripting (variables, pipes, loops, conditionals) is exactly the
kind of "solves a truly general problem" thing `os-lineages.md` §0
argues survives mostly unchanged for centuries. This isn't inventing a
new paradigm — it's implementing the same one real Unix already proved
out, natively in GDScript instead of embedding something else.

## 2. Grammar scope, deliberately small

- **Variables** — same primitive as `pin`'s registry (`glove-safe-
  ui.md` §3) and the `$_:1`/`$_:2` current-command-token variables
  (§4.2 of the same doc). Scripting doesn't introduce a second variable
  system; it's the same one, just usable in a script body instead of
  only interactively.
- **Pipes** — `cmd1 | cmd2`, already load-bearing today (`pin` itself
  is invoked via a pipe: `probe --nearby | pin => nodes.local`).
- **Control flow** — `for` (iterate a listing/output), `if` (branch on
  exit status or a simple comparison). Deliberately not full
  expressions, functions, or general arithmetic — this is shell-script
  complexity, not programming-language complexity.
- **Command invocation** — any builtin or Software Bank command
  available on the current node, exactly as if typed.

## 3. Execution model: a step budget, not a sandbox

Real sandboxing (instruction-counted VMs, capability-scoped
interpreters) solves the "untrusted code" problem this project doesn't
have. What it does need: a script with `while true` shouldn't hang the
Godot main thread. A bounded per-frame step budget — run N interpreter
steps, yield, resume next frame — handles this cheaply, and has a nice
side effect: a long script *visibly running* (the console showing
progress rather than freezing solid) is a better diegetic fit than an
instant no-op anyway.

## 4. Naming: `sh`, or lineage-specific

Scrapshell's shell binary is already named `sash` (`os-lineages.md`
§2's naming table — eroded from "Scrapshell sh"). A Scrapshell script
is plausibly a `sash` script, invoked via `sh <script>` (generic
builtin) or `sash <script>` (lineage-flavored alias) — same shared
interpreter underneath either way, matching the pattern already used
for lineage-specific root commands (`claim` vs. `elevate`): one engine
capability, per-lineage naming/invocation on top.

## 5. Fixed: a stale doc inconsistency

`ARCHITECTURE.md` §2's "Scripting host" bullet still described
"sandboxed Lua via Inline::Lua, or a restricted Perl safe-compartment"
— leftover from the pre-Godot proposal, and inconsistent with §5's own
note that engine and UI are Godot/GDScript now. Updated to point here.

## 6. Open questions

- Exact grammar isn't spec'd to EBNF-level precision yet — needed
  before implementation, not before design sign-off.
- Whether the interpreter is a builtin (like `cd`) or engine-level
  infrastructure exposed to `sh`/`sash` as builtins that invoke it —
  leaning toward the latter: the interpreter itself is `ARCHITECTURE.md`
  §2 engine capability (like the algorithm backend), not lineage-
  installable Software Bank content, since every lineage needs *some*
  way to run a script even though the invocation name may differ.
