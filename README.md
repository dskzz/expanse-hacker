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
