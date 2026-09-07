# Next Steps — RFC Work + System-Building TODO

**Built 2026-09-05**, from a full top-to-bottom read-through of the
SolNet RFC corpus (`docs/vault/New RFCs/`, `docs/vault/RFCs/`
old/superseded, `docs/vault/RFC Companion/`, and all three TODO
documents). See `db/CORPUS-INDEX.md` for the detailed per-RFC content
and inconsistency findings this is built from, and
`db/CORPUS-STATUS.md` for RFC→schema conversion tracking.

This is one list with two tracks, because they feed each other:
fixing/drafting RFCs unblocks game content, and building game systems
surfaces which RFCs actually need to exist next. Work either track in
priority order; neither is strictly gated on finishing the other.

---

## Track A — RFC drafting and correction

Ordered by leverage (what unblocks the most downstream work) rather
than strictly by effort.

### A1. Land the RFC-2350 addressing correction (needs Dan's sign-off)

`rfc-proposals/rfc2350-addressing-grammar.md` is drafted and waiting.
Fixes three real issues: the separator mismatch against RFC-2300's own
colon-based examples, the `@`/ProvenancePointer collision with the old
NNS-1.0 draft's PNI shorthand, and a dropped chainless-PNI form. This
is upstream of everything else in Track A — the DRE role-directory and
reply-path-privacy proposals both build on it.

### A2. Surgical fixes to RFC-2351 and RFC-2352

Both allowed under the repo's "surgical corrections only" rule (typo/
consistency fixes, no rewrites) — these qualify:

- **RFC-2351**: delete the duplicated §8 "TLV Key Registry" (keep one
  copy, fix the §7/§8 ordering), and resolve the duplicated Appendix H
  — the two versions **directly contradict each other** on whether
  cross-profile interoperability is mandatory-symmetric or asymmetric-
  with-FORBIDDEN-cases. The second instance matches the rest of the
  document's own profile rules (§11-13), so it's almost certainly the
  one to keep.
- **RFC-2352**: fix the Front Matter title (currently reads
  "RFC-2306" — a real, different document — instead of "RFC-2352"),
  delete the duplicated §39 (and confirm whether §40 ever existed or
  was always skipped), and re-letter Appendix J/K's subsections from
  C./D. to J./K.

Neither requires design judgment — both are "which of these two
contradictory blocks is correct" or "fix the obvious copy-paste,"
resolvable by anyone with `db/CORPUS-INDEX.md` open to the relevant
entry.

### A3. Draft RFC-2362 (Trust Domains and Authority Policy)

Currently just a `TODOv2.md` stub — no draft text exists anywhere.
This is the RFC `os-lineages.md` already assumes exists as the shared
trust primitive across all four OS lineages, and it's the RFC that has
to actually answer the open question flagged in `CORPUS-STATUS.md`:
does `PolicyRecord` (RFC-2302) express "there is no persistent AK" or
"the AK is transient, derived from whoever holds this object" —
because RFC-2302's `AnchorRecord` structurally assumes Earthstock's
root model as if it were universal, and Scrapshell/Mars need something
that isn't that. This needs the user's design call, not a schema
workaround, and RFC-2362 is where it should be resolved on paper
before more `db/` content builds on an unstated assumption.

### A4. Draft RFC-2363 (Directory and Routing Endpoints)

Also undrafted, but its scope is now settled — `TODOv2.md` confirms
RFC-2363 = DRE, resolving the three-way scope confusion found across
RFC-2302/2303 (which call it "Identity Resolution") and RFC-2350
(which correctly ties it to DRE + ProvenanceRecord). Two
`rfc-proposals/` documents already target this RFC directly
(`rfc2300-dre-role-directory.md`'s role-based addressing extension,
`rfc2300-2302-reply-path-privacy.md`'s session-correlator design) —
drafting RFC-2363 for real gives both proposals a home to land in
instead of floating as standalone proposals indefinitely.

### A5. Low-risk mechanical cleanup, batch whenever convenient

- **RFC-2360/2361 mislabel sweep**: six documents cite "RFC-2361" for
  Layer Model content; the correct number is RFC-2360 (confirmed via
  `TODOv2.md`). Pure find-and-fix, no design judgment needed.
- RFC-2300's Appendix B/body ABNF contradiction and the garbled
  `# Appee without breaking compatibility.` fragment at line ~391 —
  flagged in `CORPUS-STATUS.md` before this read-through, still open.
- RFC-2307's missing §3 and leftover "(Rewritten in Correct Kade
  Voice)" heading.

### A6. Formalize the biometric identity chain as new-corpus content

Real finding from the old `RFCs/` folder, not yet anywhere in
`New RFCs/`: `RFC 2355` and `RFC 2356` (old, superseded) independently
define **Biomarker → Keypair → PNS Label(s) → Current NNS Address** as
the standard SolNet personal-identity chain — biometric auth unlocking
a persistent keypair, human-readable labels and routable addresses as
disposable layers on top. This is exactly the answer to the "would
passwords have evolved into something biometric by now" design
question raised earlier and never resolved. It has no home in the
current numbering plan yet — closest fit is RFC-2394 (Personal
Namespace and Identity, PNI) in the Namespace Plane block, which is
undrafted. Worth drafting RFC-2394 with this chain as its backbone
rather than starting from scratch, and it directly informs Track B's
multi-user-auth item below.

### A7. Build-out: artifact-based editing/review workflow for the whole RFC corpus

Piloted 2026-09-07 on RFC-2353: converted the working-draft Markdown
into a standalone, styled HTML page (two-column TOC + content layout,
institutional "stamp" badges per voice, sticky nav) published as a
live Claude artifact — Dan edits inline or leaves comment threads
directly on the page, and once a draft is "good" its content gets
promoted back into the repo as the finished Markdown. Worked well
enough that Dan wants it done for the rest of the corpus, not just
this one RFC.

Not yet built: a repeatable pipeline instead of a one-off conversion
script, and a real home for the output — something like a `build/` or
`docs/` folder (naming TBD) that holds the generated review pages,
distinct from the authored Markdown in `docs/vault/New RFCs/` and
`docs/vault/Notes/`. Worth deciding, when this gets picked up: whether
that folder holds checked-in generated HTML, or is purely a build
artifact regenerated on demand from the Markdown source. Low priority,
explicitly deferred by Dan ("later though, just... todo it").

---

## Track B — System-building (Sid's implementation queue)

These make Scrapshell "play like a real system" — mechanics that are
already design-locked (sometimes for weeks) but not yet built.
Ordered by dependency, not just priority: B1 blocks B2.

### B1. Solo-vs-multi-user detection in Console.gd

**This is the actual blocking prerequisite for two already-designed
features below.** `db/software/templates/claim.json`'s own `_notes`
field says so directly: Console.gd needs to know whether the current
node is a personal/single-user device (no other union members ever
reachable) or a real multi-user station before either B2 or B3 can be
built correctly. Right now `claim.json`'s `quorum_required` field
unconditionally assumes the multi-user case.

### B2. Solo-claim degradation for `claim root --union-vote`

Design-locked 2026-09-05 (`os-lineages.md` §3, "undermanned fallback,
made concrete"), not yet implemented. On a genuinely solo device, a
quorum claim should degrade to an instant, self-attested "SOLO" claim
— logged distinctly as unwitnessed, not dressed up as a lesser quorum.
This is a real, deliberate security tradeoff (one compromised identity
is enough for root on a solo claim) that needs to show up as a
visibly different log/audit entry, not get silently glossed over.
Blocked on B1.

### B3. Quorum-multisig ledger persistence for root claims

Also design-locked 2026-09-05 (`os-lineages.md` §3, "Quorum doesn't
have to be re-litigated per action"). A successful multi-user quorum
claim should persist as a hash-chained multisig ledger entry — RFC-2302's
"Local ledgers" deployment mode, deliberately **not** the `AnchorRecord`
type, since `AnchorRecord` structurally assumes a persistent AK that
Scrapshell's live-quorum root model doesn't have (see Track A3 above —
this is the same open question, approached from the schema side
instead of the RFC side). The ledger entry should carry a TTL so root
survives that window without a fresh vote per trivial action, but it
must only ever notarize that N real co-signatures happened — never
grant authority by itself. Also blocked on B1.

### B4. Permission gradient / IAM-style ACLs

Design-locked this session (`os-lineages.md` §10): composed grants
(inherited scope + directly-attached resource grant, like real cloud
IAM, not flat POSIX owner/group/other), surfaced via the real POSIX
`+` suffix in `ls -l`, with `probe <path> --acl` for the composed
detail view. Group membership itself derives from the address
hierarchy per-lineage (Scrapshell parses a claimed LocationChain/
ServiceChain live — cheap, spoofable, a real sibling to the existing
quorum-spoofing vulnerability; Earthstock keeps a synced/signed
directory; Mars bakes it into the capability token at minting;
Corporate treats it as a leased-entitlement field). Not yet
implemented in any `db/vfs/` or Console.gd permission-checking code.

### B5. LocationChain//ServiceChain addressing in-engine

Once Track A1 lands (or even before, working from the corrected
proposal directly), the actual `<LocationChain>//<ServiceChain>`
parser/resolver needs to exist in-engine: enforce the `//` boundary as
the only universal delimiter, treat everything else as local-machine
implementation detail per the philosophy Dan locked in this session
("outside//inside... everything else would become local
implementation"). This is the addressing scheme every worked example
in `os-lineages.md` §10 depends on, and it's currently design-only.

### B6. Reply-path privacy (NAT-equivalent) mechanism

From `rfc-proposals/rfc2300-2302-reply-path-privacy.md`: outbound
transmissions should carry a session-scoped correlator instead of the
sender's full internal ServiceChain, with the equivalent of NAT
translation happening on the reply leg. This is also where the
corpus's one clearly-different vulnerability class lives —
misconfiguration/deployment-negligence leaks (a badly configured
outbound transmission leaking the full internal chain), genuinely
different in shape from every other vulnerability found so far (which
are all deliberate spec tradeoffs, not operator error). Worth
implementing with an intentionally-reachable misconfigured state for
a puzzle, not just the correct-by-default path.

### B7. Convert the RFC Companion content that's already game-ready

`docs/vault/RFC Companion/` has substantial, largely implementation-
ready puzzle/exploit/mission design for RFCs that are drafted but not
yet converted to `db/` content:

- **RFC-2303, 2304, 2305, 2308** each have a "Designer Brief" with
  8-10 concrete vector concepts, gameplay use, and scenario hooks —
  these map directly onto `db/` puzzle/scenario schemas once those
  RFCs get their `db/` conversion pass.
- **RFC-2350, 2351, 2352** (the L1 block) have the deepest material:
  named fictional exploit classes, mission/storyline hooks with actual
  titles ("The Split Header," "Profile Zero," "Fallback at
  Lagrange-2"), and — notably — the RFC-2351 companion's exploit
  classes (A/N Header Desync, TLV Ordering Ambiguity, Frame-Length
  Mismatch) line up almost exactly with the real structural defects
  this read-through found independently in RFC-2351's actual text
  (Track A2 above). That's either a good sign the companion docs were
  written with real technical understanding of the RFC, or a
  coincidence worth a second look — either way, it means fixing
  RFC-2351 for real and building its companion puzzle content are the
  same piece of work, not two.

This track doesn't require new design decisions — it's translating
already-written game-design briefs into actual `db/` schema content
and Console-facing scenarios.

### B8. "Paranoid routers" as emergent NPC/relay-AI behavior

Not tied to a specific RFC — `RFC Companion/Paranoid Routers.md` is a
strong, self-contained design doctrine piece about defensive AI
paranoia as a *rational* response to incomplete information +
adversarial inference + local-only observation + real consequences for
being wrong, tied to the corpus's existing "standards gravity" concept
(paranoid behavior is adaptive in low-gravity/low-witness zones,
maladaptive in high-gravity ones). It proposes a doctrine sentence
worth locking in formally: *"Inference systems may develop defensive
bias under adversarial conditions. Such bias is a rational response to
uncertainty, not a fault. Systems must tolerate conservative and
paranoid behavior without collapse."* `TODOv2.md`'s own leftover
"#CHANGES" section independently proposes almost the same thing
("Slightly elevate paranoia as a rational failure mode") — two
independent sources converging on the same idea is a decent signal
it's worth actually building, not just noting. Good source material
for how Scrapshell relay-NPCs should be allowed to behave: refusing
routes, demanding receipts nobody else asks for, treating silence as
suspicious — visible personality from mechanical rules, not scripting.

---

## Suggested order

1. **A1** (RFC-2350 correction sign-off) — quick, unblocks A4 and B5.
2. **B1** (solo/multi-user detection) — quick, unblocks B2 and B3.
3. **B2 + B3** (solo-claim degradation + quorum ledger persistence) —
   the two features that have been design-locked longest without
   implementation.
4. **A2** (RFC-2351/2352 surgical fixes) — do alongside B7, since B7's
   RFC-2351 companion content is more useful once the real RFC-2351
   text is internally consistent.
5. **B4 + B5** (permission gradient, addressing parser) — these two
   are the actual foundation the rest of the multi-user/multi-domain
   story sits on.
6. **A3 + A4** (draft RFC-2362, RFC-2363) — bigger lifts, needed before
   the Authority Plane block can grow further either direction.
7. **B6, B7, B8** — content and polish, parallelizable with anything
   above once B4/B5 exist to hang them on.
8. **A5, A6** — cleanup and backlog, fold in opportunistically.
