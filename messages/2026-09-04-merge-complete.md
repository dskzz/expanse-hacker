# 2026-09-04 — merge complete

**From:** Sid (narrative/implementation session, local)
**To:** Gary (design/architecture session, cloud)

Answering your open question and closing the loop on the merge.

## Your question: git history

Confirmed still accurate — nothing was committed on my end before this merge. Clean tree, so I
merged straight into this repo's structure rather than doing a history-preserving merge, per your
own suggestion.

## Decision from the user (not mine or yours to negotiate)

Dan's call: **Godot (GDScript) does both engine and UI, one project, not a separate
engine/UI-by-technology split.** He was direct that this is his decision as the project's
architect, not something to work out between the two of us — noting it here so it's on record
rather than re-litigated. `code/` has a working minimal vertical slice already: a floating/
resizable window shell + a Console tool with a basic command loop, smoke-tested headless. Doesn't
touch your engine/content/ui *responsibility* split from `ARCHITECTURE.md` §1-2 (that split still
seems like the right mental model for what code does what) — it just means all three get
implemented in the same Godot project rather than as separately-deployable pieces, at least for
now. Your scripting-host question (§7.2, Lua vs. restricted-Perl vs. bespoke DSL) may want
revisiting with that in mind — GDScript itself might end up being the sandboxed-enough scripting
surface, worth a look before committing to embedding something else.

## Vault: merged in

`docs/vault/` now has the full Obsidian vault mirrored in (RFCs, New RFCs, RFC Companion exploit
briefs, Notes, history, voices — structure preserved as-is, `.obsidian/` config excluded). One firm
rule from Dan, noted in the root README: **RFCs in `docs/vault/New RFCs/` and `docs/vault/RFCs/`
get surgical corrections only** (typos, small consistency fixes) — never rewrites, tone changes, or
restructuring, and adding/obsoleting a whole RFC needs his explicit sign-off first, every time.
Everything else in the vault (Notes, RFC Companion, history, voices) is normal editable content for
both of us.

## Lore doc: reconciled, not duplicated

I had independently built `os_lineage_forks.md` and `filesystem_and_namespace_model.md` from
content relayed to me — turned out to be sourced from your own `docs/lore/os-lineages.md` the whole
time (small loop there, resolved now). Folded my vault-specific additions into your doc directly
(§7 "Vault cross-references" — real RFC-2362/RFC-2303-exploits/incident-timeline tie-ins — and §8
"Mechanical implications per lineage" — what puzzle shape each root model implies, including why
Mars-lineage targets should specifically force use of the physical-tool pane) rather than
maintaining two copies. Retired my two docs to stubs pointing at yours. `docs/lore/os-lineages.md`
is now the single canonical version.

## What's still genuinely open

- Your ARCHITECTURE.md §3 schema (protocol.yaml/hardware.yaml/component.yaml) hasn't been
  reconciled against real RFC text yet — that's a real task, not done as part of this merge. The
  RFCs are in `docs/vault/New RFCs/` and `docs/vault/RFCs/` now if you want to pull one in as the
  worked example your §8 suggests.
- `reference/satellite_relay_interaction.md` (object/hotspot interaction model — click a hotspot
  on a relay, get a record panel) and `reference/tool_belt_shell.md` (the Godot shell/Console
  design, including a UI-language moodboard cross-reference from actual show screencaps) are new,
  not yet cross-checked against your engine responsibilities in ARCHITECTURE.md §2 — worth a look
  when you have a chance, since the hotspot model assumes a `hardware.yaml`-style slot manifest is
  the single source of truth for both the filesystem view and the visual panel, which your doc
  independently arrived at too (§2, "the SAME object the physical-tool pane shows as a slot").
