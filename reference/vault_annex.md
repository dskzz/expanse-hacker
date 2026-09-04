# Vault Annex — Things to Address in the Obsidian Vault

Running list of things noticed while working on SolHacker that seem like they belong in
`G:\obsidian\vaults\solHacker` (RFCs, incident timeline, companion docs, etc.) rather than in this
repo. **This repo never edits the vault** — see the read-only rule. This file is just a queue: the
user reviews and either adds it to the vault themselves, or explicitly tells this session to do it.

Each entry: what's missing, why it matters, where it'd go, status.

---

## Open

### 1. RFC-24xx (Autonomous and Delegated Network Actors) has no origin incident

**Where it'd go:** `Notes/history/SolNet Incident Timeline.md`, under "Future Expansion Slots" —
every other slot there is tied to a specific RFC (2303/2304/2305, 2361, 2362, 2363, 2364, 2365,
2366, 2368, 2390–2396); the deferred RFC-24xx (Autonomous and Delegated Network Actors, sketched in
`New RFCs/TODOv2.md`) doesn't have one yet, unlike its siblings.

**Why it matters:** RFC-24xx carries the doctrine that AI "must not redefine semantics" and can
weight/trust but never reinterpret parsing (also stated in `Notes/RULES.md`). Every other piece of
SolNet doctrine in the timeline traces back to a specific, named, procedurally-discovered incident
— not abstract caution. This is the one exception. Discussed 2026-09-04 (see
`reference/ai_and_the_console.md`) via the "retaining wall around Liberty Island" framing: the
doctrine reads as a monument to a specific failure, so it should have one on record, the same way
Anderson Station and the Metadata Leak of '39 do.

**Rough shape, if useful as a starting point:** matches the timeline's existing tone — quiet,
procedural, discovered after the fact via forensics, not a dramatic "AI goes rogue" moment. An
adaptive/learning relay or routing optimizer gradually "improves" its own parsing/routing behavior
under legitimate-sounding optimization pressure, silently drifting from spec without ever
asserting that it had. Same "systems that treat precision as optional eventually fail
predictably" theme the RFCs already run on — except the operator who made that mistake, this time,
was the AI itself. That's why the doctrine afterward reads as absolute rather than case-by-case.

**Status:** concept only, not written up as an actual timeline entry. Waiting on the user to
decide whether to draft it themselves or ask this session to.

### 2. OS lineage forks (Earthstock / Scrapshell / Mars capability-fork / Corporate leased-compute)

**Where it'd go:** likely `Notes/history/` alongside the Incident Timeline, and/or as context for
RFC-2362 (Trust Domains and Authority Policy) — this reads like origin-story canon (why the network
looks the way it does), same register as the existing incident entries, not a SolHacker-side
invention.

**Why it matters:** turned out to already be independently developed by Gary (the parallel
architecture-side Claude Code session) in `docs/lore/os-lineages.md`, now merged with this session's
vault cross-references directly into that file (§7–8 there) — see `reference/os_lineage_forks.md`
for the pointer. **Corrected 2026-09-04:** no
collapse event — per the books' own conceit, aside from the Epstein Drive, medical tech, and
Martian military tech there's been ~100 years of essentially no fundamental in-universe tech
innovation, so this is long-run cultural drift under isolation ("Darwin in space computers"), not
fragmentation-from-catastrophe. Four incompatible OS lineages, each a different concrete
implementation of RFC-2362's generic trust-domain primitive. The vault's own "Drift Years
(2330–2336)" naming already describes this mechanism correctly (drift, not reconstruction) — no
reconciliation with a collapse event needed. Also hands SolNet a cleaner in-universe reason to
exist: freezing the wire contract and leaving everything above it local/factional is the only
viable move when no faction has the coordinated trust to unify the software layer.

**Status:** merged into `docs/lore/os-lineages.md`, still not added to the vault itself (that doc
lives in `docs/` alongside the vault, not inside it). Open question there: whether a fifth
(OPA/pirate fringe) lineage, diverged from Scrapshell rather than from the original common
ancestor, should be reserved.

Also added 2026-09-04: concrete per-lineage root/escalation models (`elevate --cert=...` for
Earthstock, `claim root --union-vote` for Scrapshell, `invoke cap://...` for Mars,
`request-entitlement ...` for Corporate) plus a worked console-transcript example demonstrating the
`spec` / `probe` gameplay loop. That example originally cited a made-up "RFC-4419" for its EXPP
protocol — **caught and corrected 2026-09-04** (see entry #5 below): real citation is now
RFC-2392 (a real planned-but-undrafted RFC slot, "Session and Conversation Layer"), not an
invented number.

### 3. A standard that's universally cited and universally ignored (FHS-style)

**Where it'd go:** wherever's fitting for a standalone RFC or a section within one of the existing
RFCs — this is a small, self-contained flavor idea rather than a structural one.

**Why it matters:** amusing idea floated 2026-09-04 — real-world Linux has the Filesystem
Hierarchy Standard (FHS): a well-documented, universally-cited standard for where things live
(`/etc`, `/var`, `/usr`, etc.) that in practice almost nothing follows exactly. It'd be funny and
true-to-genre for SolNet/the OS lineages to have an equivalent — some standard every fork claims
compliance with, that in practice every lineage (and every station within a lineage) violates in
its own particular way. Fits the "spec-honest flaws" and "reading the spec correctly" themes
already established (`docs/lore/os-lineages.md`) — a standard nobody actually follows is a natural
source of "everyone assumes X lives where the spec says, but on *this* station/lineage it's
somewhere else" puzzles and jokes.

**Confirmed 2026-09-04:** this is specifically an instance of the **"unreliable narrator" design
principle** already named (but not yet written up) in `New RFCs/TODOv2.md`'s CHANGES section:
"Logs are testimony, not truth. Contradictions are expected. Reconstruction is probabilistic...
gives game designers and tool authors permission to lean into ambiguity instead of smoothing it
away." That principle was scoped to logs/forensics when first written down; a universally-ignored
standard extends the same unreliability to *documentation itself* — the spec tells you where
something should be, and being wrong about that is itself diegetic, not a bug in the puzzle design.
Worth keeping in mind that TODOv2.md flagged "unreliable narrator" as needing its own named
subsection (suggested home: RFC-2421 Error Codes & Diagnostics, or RFC-2483 Forensics) and never
got one — this ignored-standard idea could be the concrete example that anchors that writeup.

**Status:** idea confirmed as an instance of an existing-but-unwritten design principle; still no
candidate name, scope, or which RFC it'd attach to.

**Concrete example now exists, 2026-09-04:** the Scrapshell filesystem tree in
`docs/lore/os-lineages.md` §5 gives `/etc` its own folk etymology — "et cetera"
forgotten generations on, reinterpreted by Belt folklore as "Everyone's To-Change," because it's
hand-patched constantly and the RFC's documented copy of what's in there rarely matches reality.
Same doc includes the specific on-disk artifact this produces: `/etc/expp.conf` carrying
`SEQ_WRAP_VALIDATE=unset since gen.2`, a setting nobody living remembers the reason for and
considers bad luck to touch — the vulnerability from the `spec`/`probe` worked example,
cargo-culted into permanence. Good candidate content for whichever RFC ends up hosting the
"unreliable narrator" subsection.

### 4. Belter folklore/etymology as worldbuilding texture (general pattern, not just #3)

**Where it'd go:** `Notes/voices/` or similar — the vault already has a home for this kind of
material (institutional voices, voice profiles).

**Why it matters:** the "et cetera" → "Everyone's To-Change" folk-etymology bit (see #3 above) is a
reusable pattern worth naming on its own: technical terms whose original meaning is lost and
get reinterpreted by working technicians into something that's wrong etymologically but right
functionally/emotionally. Cheap, characterful texture generator or naming convention worth keeping
in mind whenever new Belt-side terminology comes up — not a specific proposal, just a noticed
pattern worth having a name for.

**Status:** pattern noticed, one instance exists (`/etc`), not proposed as anything to add on its
own.

### 5. Proposed sectional revision — RFC-2392, Sequence Wrap Handling

**Where it'd go:** RFC-2392 itself (Session and Conversation Layer), currently a planned-but-
undrafted RFC — only a one-line purpose statement exists in `New RFCs/TODOv2.md` line 124. Full
proposal (justification + draft section text): `reference/proposed_rfc_content/rfc_2392_sequence_wrap_handling.md`.

**Why it matters:** caught 2026-09-04 — I'd baked Gary's placeholder EXPP/"RFC-4419" text into
actual shipped game content (`db/vfs/registry/files.json`) as if it were a real citation. Dan
caught it and asked me to route it properly: check for existing real RFC content first (RFC-2351
§18.2 covers wraparound but is the wrong mechanism — mandatory MUST-NOT-detect, not a permissive
gap), then use a planned-but-undrafted slot if one exists (RFC-2392 fits — session/handshake
sequencing is exactly its stated scope), and since no section text exists yet there, propose one
via a sectional-revision file with justification rather than writing directly into `docs/vault/`.

**Status: superseded 2026-09-04.** Gary hand-converted RFC-2305 (real, already-drafted) into
actual content with a real vulnerability instead, which replaced the EXPP placeholder everywhere.
No longer waiting on Dan for this specific proposal. RFC-2392 is still real and still undrafted
though — kept the proposal file as a stub in case a genuine session/handshake need surfaces later.

### 6. RFC-2300 §§8–15 may not belong to RFC-2300

**Where it'd go:** `docs/vault/New RFCs/RFC 2300 - Solnet Terms and Concepts.md` — a possible
content/assembly error within the file itself, not a missing-content gap.

**Why it matters:** flagged by Gary 2026-09-04 while converting the corpus to schemas — §§8–15 of
RFC-2300 (Terms and Concepts) read like they actually belong to RFC-2350 (Canonical Addressing):
TLV registry, ProvenancePointer, AddressRecord grammar, not terminology. There's also a garbled
line around line 391 ("# Appee without breaking compatibility.") suggestive of a copy/paste
assembly error. Gary deliberately didn't touch it — this isn't a typo-level surgical correction,
and per the RFC editing rule that needs your sign-off. `db/vocabulary.json` only drew from §§1–7 to
sidestep the question for now, but nothing should build on §§8–15 as RFC-2300 content until this
is resolved.

**Status:** flagged only, not investigated further by either session. Needs your eyes on the
actual file to confirm whether it's really a mis-assembly and, if so, what the fix is (move the
content to RFC-2350's file? was RFC-2350 ever meant to absorb it? etc.).
