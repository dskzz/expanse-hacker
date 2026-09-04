# AI's Role in the Console — Design Notes

Status: early concept, not locked. Captures the "form fits function" thought exercise from
2026-09-04: 300 years out, is the console still recognizably a Unix-lineage shell, and how does
ubiquitous agentic AI (which the show predates and barely touches) change that without redesigning
it?

## The framing

Some tools are what they are — a mousetrap, a toilet — because their form is dictated by their
function, and real innovation *improves* them without *replacing* the category. The distinction
worth drawing: does an innovation change the *daily labor/assumptions* of using the thing (running
water on a toilet — still a toilet, wildly different lived experience) versus a genuine category
replacement (composting toilet vs. incinerating toilet — different fixture entirely)?

Applied here: is 300-years-mature agentic AI running-water-on-a-toilet for the hacking console, or
does it actually change what kind of tool it is?

## The vault already half-answered this

Two passages, not previously connected to each other or to the console/tool design:

From `Notes/RULES.md`:
> AI may influence confidence and preference, but not parsing or safety. AI can decide *what to
> trust*. AI must never decide *what is valid syntax*. AI can weight TLVs. AI cannot reinterpret
> them.

From `New RFCs/TODOv2.md` (deferred RFC-24xx, "Autonomous and Delegated Network Actors" sketch):
> Core protocol behavior must be implementable without learning systems. Autonomous actors may
> tune parameters but must not redefine semantics.

Both are about the SolNet protocol itself, not tooling — but they already draw exactly the line
this thought exercise needed: **AI is real, ubiquitous, and trusted with triage/weighting/
confidence, but explicitly walled off from parsing, validity, and semantic authority.** That's the
plumbing/fixture boundary, just not phrased that way yet.

## The answer: AI is the running water

Real-world analogy worth keeping close, because it's not speculative — it's the current decade:
**AI coding assistants in IDEs.** VS Code didn't stop being a text editor when Copilot arrived.
Same fixture — files, syntax, a cursor, you still write real code — but the assumption "you type
every character yourself" broke. That's the exact shape of change to extrapolate 300 years onto a
hacking console: same category of tool, radically different labor economics.

**What stays manual** (doctrine, not habit): crafting the actual exploit, deciding what to trust,
judging whether a signal is real or noise. Not a technology gap — a legislated boundary, in a
culture that already sounds like it got burned by cleverness before (same register as Dr. Vargo's
contempt in RFC-2306 for operators who "treat precision as optional"). SolNet governance forbids
AI from redefining semantics or asserting validity; by extension, the tooling built on top of it
inherits that same wall. This also happens to be good game design for free — an AI that just
"does the hack for you" collapses the entire gameplay loop. Doctrine and fun point the same way.

**What AI plausibly owns by then:** triage and attention, not action. Today's SOC/SIEM tooling is
already trending toward automated anomaly-flagging over raw manual log review; 300 years is enough
runway for "which of these ten thousand signals deserves a human's attention" to be functionally
solved. Concretely, an ambient layer that constantly pre-sorts, flags anomalies, translates natural
language into the right command, and summarizes a wall of log text into "these three lines are
odd" — without ever deciding what's *true*, what's *valid*, or what to *do* about it.

## What this changes about the operator's day (and the console's design)

Not "the AI hacks for you." The shift is from *"wade through raw signal to find the interesting
bit, then act on it"* to *"the interesting bits are already surfaced, you apply craft and judgment
to them."* Real change in what the job is; the console still looks and works like a terminal.

Design implication for the tool belt / Console (see `tool_belt_shell.md`): the ground-truth layer
stays command-line, monospace, utilitarian — matches the "Kali but utilitarian" instinct and the
show's dense-panel visual language already catalogued in `satellite_relay_interaction.md`. An
ambient-assist layer (anomaly highlighting, NL-to-command suggestion, log summarization) sits over
that ground truth as an optional/toggleable convenience, never a replacement path — the same
relationship Copilot has to the actual code, or the same relationship RFC-2300 draws between AI
weighting TLVs and AI being forbidden from reinterpreting them.

## Open questions

- Does the ambient-assist layer have an in-fiction name/identity (a "co-pilot" character, an
  institutional product, a generic OS feature), or does it stay unnamed/implicit chrome?
- Gameplay surface: is AI-assist a togglable difficulty/accessibility setting (assist on = easier,
  off = "raw" hacker mode for players who want the full manual experience), a narrative/mission
  variable (some targets jam or forbid it), or both?
- Does this reframe any tool in the roster specifically — e.g. is the RF Hacker's spectrum view
  AI-pre-highlighted by default, with a toggle to see the "raw" waveform a human would've had to
  read unaided in an earlier era?

## Related docs

- `reference/tool_belt_shell.md` — the console/tool-belt shell this assist layer would live in
- `reference/satellite_relay_interaction.md` — visual language reference, screen-type catalog
