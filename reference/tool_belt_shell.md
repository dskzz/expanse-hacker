# Tool Belt / Shell — Design Notes

Status: early concept, not locked. Captures the "tool belt" idea discussed 2026-09-03: the
player's actual interface to SolNet isn't one console, it's a shell that hosts multiple tools.

## Core idea, in web-dev terms

This is a desktop-like app shell, not a game HUD. If you've built a dashboard with draggable
widgets, or used VS Code / Figma's panel system, you already know the shape of this:

- A **toolbar** ("tool belt") across the top — like a bookmark bar or an app launcher — where each
  icon opens a **tool** into a floating window.
- Every open window is **movable and resizable** within the play area, same as draggable widgets
  on a dashboard.
- **Layout persists**: which tools are open, where, at what size — saved and restored, same idea
  as an app saving UI state to `localStorage` or a user-settings table, just to a local save file.
- **Multi-monitor is a stretch goal, not a blocker**: start with everything inside one resizable
  game window (drag that window across an ultrawide or second monitor — already usable). Real
  per-tool OS windows (drag a single tool out onto monitor 2 as its own window) is a later
  upgrade, not part of the first build.

## Proposed architecture (Godot terms, with web analogies)

- **Shell / window manager**: one reusable "window frame" component (title bar, drag handle,
  resize corner, close button) that wraps arbitrary content — same pattern as a React/Vue layout
  component rendering different pages inside one shared chrome. Build this once, use it for every
  tool.
- **Tools as scenes**: each tool (Console, RF Hacker, etc.) is a self-contained Godot scene — the
  rough equivalent of a component/module — that gets instanced into a window frame when opened.
  A tool scene shouldn't know or care that it's inside a window; the shell owns positioning,
  z-order (which window is on top/focused), and persistence.
- **Save format**: a simple serialized list of `{tool_id, position, size, tool-specific state}` —
  no different in spirit from saving a dashboard layout as JSON. Tool-specific state (e.g. what
  the Console currently has open, RF Hacker's last scan) is each tool's own business; the shell
  just persists the envelope.
- **Multi-window (later)**: Godot supports multiple real OS windows (`Window` nodes). When this
  becomes worth building, a tool "pops out" by re-parenting its content from an in-game floating
  frame into a real `Window` positioned on a second display — the tool scene itself doesn't need
  to change, only where the shell puts it.

## Draft tool roster

Starting list from this conversation, each mapped to the SolNet domain it'd operate on. Not
locked — expect this to grow/shrink once the shell itself exists and tools get prototyped.

| Tool | What it does | SolNet grounding |
|---|---|---|
| **Console** (core) | The base terminal — general TLV/record browser, auth/session shell, command entry. Everything else assumes this exists. Concrete command vocabulary sketched in `docs/lore/os-lineages.md` §6's worked example: `ls`, `spec <protocol>` (surfaces the RFC's own MAY/RECOMMENDED language for that protocol), `probe <protocol> --node <target>` (surfaces what a specific node actually implements/patched — fork, build, hardware), plus lineage-specific escalation (`elevate --cert=...`, `claim root --union-vote`, `invoke cap://...`, `request-entitlement ...`). Prompt format: `user@host (lineage version) [lag +Xs → target]`. | RFC-2301 (crypto/auth), RFC-2351 (L1 frame/TLV format), RFC-2362 (Trust Domains — the four lineages' root models) |
| **Data port interface** | Plug into a physical access port on an object (the "data port" hotspot from `satellite_relay_interaction.md`) — embedded/constrained device access. | RFC-2395 (Personal Device Integration), RFC-2451 (Hardware Root/Secure Element) |
| **RF hacker** | Spectrum view, signal injection/interference, beacon manipulation. | RFC-2307 (RF Propagation Subprofile), RFC-2303 (Physical Media) |
| **ASIC decryption platform** | Brute-force/side-channel style crypto breaking against a captured signature or record. | RFC-2301 (Crypto Primitives), RFC-2452 (PQ Crypto Migration — old/weak algorithms as a difficulty axis) |
| *(candidate, not yet requested)* Transponder/ID editor | Directly maps to the transponder-spoofing panel found in the show reference (`satellite_relay_interaction.md` → screen-type catalog) — edit vessel identity fields to impersonate another platform. | RFC-2306 §6.1 misidentification exploit |
| *(candidate, not yet requested)* Ledger/anchor auditor | Inspect/dispute LedgerAnchor and revocation chains — a "forensics" tool rather than an "attack" tool. | RFC-2302 (Ledger Spec), RFC-2483 (Forensics) |

## Open questions

- Does the Console *contain* the other tools' output (one big terminal with modes), or are they
  genuinely separate windows that happen to talk to the same underlying game state? Leaning
  separate windows — matches the "tool belt" framing and keeps each tool's UI simple.
  - **Note:** what "the Console" does at the object-inspection layer (per-hotspot record panels in
    `satellite_relay_interaction.md`) vs. what it does as one tool in this shell needs reconciling
    — are hotspot panels opened *inside* the Console tool, or does clicking a hotspot open the
    relevant specialized tool directly (antenna hotspot → opens RF hacker, data port → opens Data
    port interface)? **Confirmed 2026-09-03 — leaning toward the latter**: clicking a hotspot
    opens its specialized tool directly. Gives the tool belt a reason to exist beyond the
    object-inspection flow.
- How much tool-specific state needs to survive a save/reload vs. reset each session? (e.g. does
  the RF hacker remember a saved spectrum scan from a prior session, or is that mission-scoped?)
- **Build order: decided 2026-09-03 — Console first.** It's the key tool (per the user: "console
  is key so we should work on it first"), and every other tool assumes it exists (auth/session
  shell, TLV/record browser). This settles the shell-vs-vertical-slice question below in favor of
  a vertical slice: build the Console as a real tool before investing in full window-manager
  polish (drag/resize/multi-window) for the rest of the belt. The shell needs to exist in some
  minimal form to host the Console, but doesn't need to be fully-featured before Console work
  starts.

## Related docs

- `reference/satellite_relay_interaction.md` — the object-inspection flow this shell's tools
  presumably get opened from
