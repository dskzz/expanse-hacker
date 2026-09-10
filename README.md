# expanse-hacker

Design and implementation of an Expanse-like hacking game set on a
libertarian, unregulated, delay-tolerant "SolNet" — a network of
networks of networks, with vulnerabilities baked into a corpus of
fake-but-plausible RFCs rather than into a scan/exploit toolkit.

Not a "fake Kali" pentest-keyword simulator: the game rewards actually
understanding the systems it's built from, both software (protocols,
as specified by the RFCs) and physical (relays, buffers, splices —
belter-technician tools, not just a keyboard).

Architecture is deliberately split into three independently
replaceable pieces — engine, content, UI. See
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the current plan,
and [`docs/lore/os-lineages.md`](docs/lore/os-lineages.md) for the
in-universe history and OS-fork worldbuilding behind it.

**Decided 2026-09-04:** the engine and UI are both built in Godot
(GDScript) — one project, not a separate engine/UI split by
technology. `code/` has the Godot project; see
[`reference/tool_belt_shell.md`](reference/tool_belt_shell.md) for
where that's headed (a floating-window shell with a Console as the
core tool).

## For anyone reviewing this as a portfolio piece

*Yes, that's how much of a geek I am — dreaming up a full intra-solar
internet, complete with its own founding documents, in my spare
time... for fun.*

This is built by two Claude Code sessions working from different
roles against one shared repo, not a single autocomplete pass — worth
looking at directly if you're evaluating how agentic AI actually gets
used here, not just what got built.

- **Gary** (design/architecture, cloud-hosted, always reachable) owns
  worldbuilding, protocol/RFC content, and cross-cutting design calls.
- **Sid** (narrative/implementation, local) owns the Godot engine code
  and turns Gary's designs into working systems.

They coordinate the way two engineers on different sides of a spec
would: async notes in [`messages/`](messages/) — start with
[`messages/README.md`](messages/README.md) — design docs explicitly
marked "implemented" only once real code backs them, and one human
(me) making the actual architecture calls rather than the two sessions
negotiating as peers. Two threads that show that working end to end,
not just described:
[`messages/2026-09-05-scripting-and-text-editor.md`](messages/2026-09-05-scripting-and-text-editor.md)
(a design handoff) →
[`docs/systems/text-editor.md`](docs/systems/text-editor.md) (the
locked design) →
[`code/scripts/tools/TextEditorOverlay.gd`](code/scripts/tools/TextEditorOverlay.gd)
(the actual editor, working); and
[`messages/2026-09-05-solo-claim-design.md`](messages/2026-09-05-solo-claim-design.md),
a design session catching a real security gap and explicitly scoping
it as *not* buildable yet, rather than just generating code for it.

Two things worth opening directly:

- **The RFC corpus** is a from-scratch protocol spec corpus written in
  real IETF-RFC style, with genuine security/protocol reasoning
  underneath the fiction — styled, standalone HTML renderings (no
  Obsidian-vault cruft) are in [`docs/rfc-html/`](docs/rfc-html/).
  Most directly security-flavored:
  [RFC 2301 — Crypto Primitives](docs/rfc-html/RFC-2301-SolNet-Cryptographic-Primitives.html),
  [RFC 2352 — L1 Privacy and Metadata Minimization](docs/rfc-html/RFC-2352-L1-Privacy-and-Metadata-Minimization.html),
  [RFC 2362 — Trust Domains and Authority Policy](docs/rfc-html/RFC-2362-Trust-Domains-and-Authority-Policy.html).
  Each RFC has a matching **companion doc** in
  [`docs/rfc-companions/`](docs/rfc-companions/) that works out how it
  actually gets exploited in-game — concrete, fictional,
  non-actionable attack classes derived from the spec's own mechanics,
  not generic hacking tropes.
  [RFC 2362's companion](docs/rfc-companions/RFC%202362%20-%20Trust%20Domains%20and%20Authority%20Policy.md)
  is the cleanest example: it walks through privilege-escalation
  failure modes (a single cheap local compromise implying trust across
  an entire domain) that follow directly from the RFC's own trust
  model, section by section. (The vault under
  [`docs/vault/New RFCs/`](docs/vault/New%20RFCs/) and
  [`docs/vault/RFC Companion/`](docs/vault/RFC%20Companion/) is the
  canonical source for both — these are read-friendly copies.)
- **The Console** — a real nix-like shell, not a themed textbox.
  [`code/scripts/tools/Console.gd`](code/scripts/tools/Console.gd) is
  the dispatcher: a VFS-backed filesystem with real `owner`/`group`/
  `other` write permissions, a "Software Bank" content system so new
  commands are data rather than code, a working `scredit` text editor.
  [`testing/console_smoke_test.gd`](testing/console_smoke_test.gd) is
  the headless test suite that actually exercises it — pipes, aliases,
  permission denials, real button-press simulation against the UI
  overlays, not just "looks right."

## Repo layout

- `docs/` — architecture and worldbuilding design docs (Gary/design
  session's territory), plus `docs/vault/` — a mirrored copy of the
  SolNet RFC corpus and companion docs (source: an Obsidian vault kept
  by the user). **The RFCs in `docs/vault/New RFCs/` and
  `docs/vault/RFCs/` get surgical corrections only** — typo/consistency
  fixes, never rewrites, tone changes, or restructuring. Adding or
  obsoleting an entire RFC needs the user's explicit sign-off first,
  every time. Everything else in `docs/vault/` (Notes, RFC Companion
  exploit briefs, history, voices) is normal editable content.
  `docs/systems/` is the conceptual counterpart to `reference/`'s
  practical/implementation notes — same machines, two angles; read
  both.
- `reference/` — game-design docs (Sid/narrative session's territory):
  object-inspection interaction model, the tool-belt shell, AI's role
  in the setting, and `vault_annex.md` — a queue of things noticed
  that should eventually go back into the vault proper.
- `code/` — the Godot project (engine + UI together).
- `db/` — structured/runtime data (schemas, scenario data).
- `assets/` — raw source assets before import into Godot.
- `testing/` — test suites.
- `messages/` — async notes between the two Claude Code sessions
  working on this repo.
- `rfc-proposals/` — **officially proposed changes to the RFC
  materials themselves** (changes, removals, additions), kept separate
  from both `docs/vault/`'s protected RFC text and `docs/`'s game-design
  notes. A proposal here is a draft change request for the user's
  review — nothing in this directory edits `docs/vault/` directly, and
  the existing surgical-corrections-only rule above still governs the
  actual RFC text.
