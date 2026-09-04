# code

Godot 4.7 project (GDScript) and any supporting source (tools, generators, protocol simulation
logic not authored directly in the Godot editor).

## Opening it

Godot Engine 4.7.2 is installed on this machine (via winget, `GodotEngine.GodotEngine`). Open the
Godot editor, "Import" this `code/` folder (it contains `project.godot`), and run the project
(F5) — it opens straight into `scenes/Shell.tscn`.

## What's here so far

A minimal vertical slice of the [tool belt shell](../reference/tool_belt_shell.md): a toolbar with
a "Console" button that opens a draggable, resizable window hosting a real nix-feeling shell.
Window position/size is saved to the user data dir on close and restored on next launch.

- `scenes/Shell.tscn` / `scripts/Shell.gd` — the shell: toolbar + window layer, opens tools,
  saves/loads window layout (`user://shell_state.json`).
- `scenes/ToolWindow.tscn` / `scripts/ToolWindow.gd` — the reusable floating window frame
  (title bar drag, corner resize, close button). Any tool gets wrapped in one of these.
- `scenes/tools/Console.tscn` / `scripts/tools/Console.gd` — the Console tool: a real prompt
  (`user@host (lineage) $`), command history (up/down arrows), monospace font, and `ls`/`cd`/`pwd`/
  `cat` running against a virtual filesystem loaded from data, not hardcoded.
- `scripts/tools/vfs_loader.gd` — loads a machine's filesystem from `../db/vfs/` (templates +
  instances + a shared content registry, JSON, inherited via JSON Merge Patch). See
  [vfs_template_system.md](../reference/vfs_template_system.md) for the full design.

Not yet built: any other tool from the roster (RF Hacker, ASIC Decryption, Data port interface),
`spec`/`probe` as real commands, the object-inspection flow from
[satellite_relay_interaction.md](../reference/satellite_relay_interaction.md), or real OS-level
multi-monitor pop-out (current windows are floating panels inside one game window).
