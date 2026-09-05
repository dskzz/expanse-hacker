extends RefCounted

# Glove-safe inline widget primitives, per docs/systems/glove-safe-ui.md
# section 1 -- four primitives only, built cheaply on top of RichTextLabel
# BBCode rather than real widget nodes. Same TLV fail-safe-to-plain-text
# doctrine as the protocols themselves: every caller must still make sense
# if these tags render as literal text (e.g. bbcode_enabled = false, or a
# future renderer that doesn't understand [url]) -- so button() always keeps
# the visible label as real, readable text, never hides meaning behind an
# icon-only tag.

# A tappable command shortcut. meta_clicked (wired up in Console.gd) runs
# `command` when clicked. Falls back to being read as plain "label" text if
# bbcode/meta-click support isn't there -- the [url=] tag itself is inert
# without a listener, which is exactly the fail-safe property this needs.
static func button(label: String, command: String) -> String:
	return "[url=%s]%s[/url]" % [command, label]

# At-a-glance state, matching the hotspot visual-state concept in
# reference/satellite_relay_interaction.md (nominal/degraded/flagged).
static func status_light(state: String) -> String:
	var color := "#00d700"
	if state == "degraded" or state == "flagged":
		color = "#d7d700"
	elif state == "critical" or state == "fault":
		color = "#d70000"
	return "[color=%s]●[/color]" % color

# A bounded quantity as a block-character bar -- no widget needed, reads
# fine as plain text if color tags are ignored/stripped.
static func gauge(value: float, max_value: float, width: int = 10, color: String = "") -> String:
	if max_value <= 0.0:
		max_value = 1.0
	var filled := clampi(roundi((value / max_value) * width), 0, width)
	var bar := "▓".repeat(filled) + "░".repeat(width - filled)
	if color == "":
		return bar
	return "[color=%s]%s[/color]" % [color, bar]

# A row of tappable options -- confirm/select is just multiple buttons.
static func choices(options: Array) -> String:
	var parts: Array = []
	for opt in options:
		parts.append(button(opt.get("label", "?"), opt.get("command", "")))
	return "  ".join(parts)
