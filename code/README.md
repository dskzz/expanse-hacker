# code

Godot 4.7 project (GDScript) and any supporting source (tools, generators, protocol simulation
logic not authored directly in the Godot editor).

## Opening it

Godot Engine 4.7.2 is installed on this machine (via winget, `GodotEngine.GodotEngine`). Open the
Godot editor, "Import" this `code/` folder (it contains `project.godot`), and run the project
(F5) — it opens straight into `scenes/Shell.tscn`.

## What's here so far

A minimal vertical slice of the [tool belt shell](../reference/tool_belt_shell.md): a toolbar with
a "Console" button that opens a draggable, resizable window hosting a basic terminal (try `help`).
Window position/size is saved to the user data dir on close and restored on next launch.

- `scenes/Shell.tscn` / `scripts/Shell.gd` — the shell: toolbar + window layer, opens tools,
  saves/loads window layout (`user://shell_state.json`).
- `scenes/ToolWindow.tscn` / `scripts/ToolWindow.gd` — the reusable floating window frame
  (title bar drag, corner resize, close button). Any tool gets wrapped in one of these.
- `scenes/tools/Console.tscn` / `scripts/tools/Console.gd` — the Console tool itself: output log
    and command input, currently just `help` / `clear` / `whoami` as placeholder commands.

Not yet built: any other tool from the roster (RF Hacker, ASIC Decryption, Data port interface),
real command handling tied to SolNet records, the object-inspection flow from
[satellite_relay_interaction.md](../reference/satellite_relay_interaction.md), or real OS-level
multi-monitor pop-out (current windows are floating panels inside one game window).
