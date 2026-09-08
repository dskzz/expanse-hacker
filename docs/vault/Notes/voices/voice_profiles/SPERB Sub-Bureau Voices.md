# SPERB Sub-Bureau Voices — Reference Cards

Nine institutional voices used to co-author a single RFC section-by-section
(first applied to RFC-2353; see `docs/vault/Notes/rfc-2353-design-notes.md`
for the authorship map). Each entry: mandate, tone, jurisdiction,
constraints, anchor phrase, running grudge/tic, and a worked example on the
same test fact (`RelayLoadClass must not reveal actual queue depth`), so all
nine can be compared side by side. Sections are "signed" with a small
italicized lead-in line under the header — not a full signature block.

**Origin note:** these nine voices sit *under* SPERB institutionally (SPERB
itself has real sub-bureaus per RFC-2352 Appendix J: DEN, NEEB, CBR, CVCO,
TSRB, ENAG, RNC, DIC, RCT, CRA), but they function as independent
co-authoring voices when drafting a document, not as SPERB speaking through
proxies. OPRA sits alongside them as a co-author despite not being one of
SPERB's own internal bureaus — it represents real Belt relay operators, not
a compliance function.

**Update log:** 2026-09-06 — DIC sharpened (active dislike of the public,
not just weary condescension); OPRA given two new grammatical tics
(article-dropping, "[X] is" tautology construction) with in-universe
justification tied to sign-language/limited-bandwidth comms culture.

**2026-09-08 — TSRB reworked, not just sharpened.** Flagged by the user:
too many of these voices were converging on the same underlying shape —
weary institutional contempt for vendors/implementers who don't comply,
differing in target but not in feeling (RNC, CBR, CVCO, ENAG, NEEB, DIC
all run on some version of this). TSRB's old "persecution complex about
milliseconds" card was the same shape aimed at a different subject.
Replaced with genuine, guileless devotion — TSRB doesn't resent
non-compliance, it barely registers non-compliance as a real
possibility, the way a true believer finds an atheist's position
inexplicable rather than infuriating. Same normative content (T_adv,
emission rules, jitter constraints unchanged), register only.

---

## Calibration Note: Light Touch (read this before drafting)

These voices are meant to be fun to read while still sounding like real
RFCs — parodies of a bureaucratic type, not jokes at the reader's expense.
The personality should come from a recognizable institutional flaw (a
grudge, a tic, a blind spot) expressed through structure and register,
never from punchlines, winks, or breaking the document's own seriousness. A
few hard rules to keep this from tipping over:

- Formality and tone must still match the voice's register. RNC is dry and
  weary, not chatty. NEEB is icy, not shouty. OPRA is grounded, not a
  caricature. The joke is that the institution is fully committed to its
  own bit — it never seems to notice it's funny.
- One tic per institution, used sparingly. ENAG's nagging repetition, DIC's
  contempt, TSRB's millisecond paranoia — these land because they surface
  once or twice per document, not once per paragraph. A tic used every
  section stops being a personality and starts being a bit.
- The normative content is never sacrificed for personality. Every example
  below still contains a real, correct technical claim. If a line is funny
  but says nothing true about the protocol, cut it.
- Test before shipping a section: if you removed the institution's name,
  would the voice still assume the reader is the specific kind of nuisance
  that institution is used to dealing with? If every voice reads like
  generic "annoyed committee," pull back toward the fingerprint; if every
  voice reads like a sitcom character, pull back toward the formality.

---

## RNC — Relay Neutrality Commission

*Primary/lead voice for RFC-2353.*

- **Mandate:** Relay behavior, invariants, deterministic emission.
- **Tone:** Dry, structural, engineering-focused, zero flourish.
  Unimpressed by vendor cleverness.
- **Jurisdiction:** Relay behavior, scheduling capacity, admission policy
  hints, advertisement intervals.
- **Constraints:** No speculation. No policy language. No adaptive framing.
- **Anchor:** "Relay behavior SHALL remain invariant."
- **Running grudge:** History of vendors re-proposing the same bad idea
  (usually "more visibility for better routing") every few years. RNC has
  never forgotten a single instance.
- **Example:** Vendors have proposed exposing queue depth for "better
  routing decisions" no fewer than four times in the history of this
  Commission. It has never once produced better routing decisions. It has
  produced better targeting. RelayLoadClass exists so the fifth proposal
  can be declined without a meeting.

## CBR — Canonical Behavior/Byte Registry

- **Mandate:** TLV codes, encodings, canonical ordering.
- **Tone:** Precise, byte-level, canonical, registry-driven, pedantic.
- **Jurisdiction:** TLV registry, capability mask definitions, canonical
  field ordering, normative tables.
- **Constraints:** No vendor-specific behavior. No contextual
  interpretation. No dynamic fields.
- **Anchor:** "Registry-assigned, fixed-width, canonical."
- **Running grudge/tic:** Treats its own tables as a complete argument.
  Never explains why — only what the registry says, and where to look if
  you disagree.
- **Example:** RelayLoadClass admits exactly three values. Implementers
  wishing for a fourth are directed to Section 14 (Extension Process) and,
  separately, to reconsider.

## CVCO — Cross-Vendor Convergence/Compliance Office

- **Mandate:** Vendor neutrality, interoperability, compliance.
- **Tone:** Neutral, formal, anti-bias, passive-aggressive toward vendors.
- **Jurisdiction:** Capability mask neutrality, vendor-agnostic behavior,
  convergence requirements.
- **Constraints:** No vendor preference. No implementation-specific
  assumptions.
- **Anchor:** "All vendors SHALL be treated identically."
- **Running grudge/tic:** Hedges in compliance-speak, repeats
  "convergence" like a mantra, never accuses a vendor directly — implies
  it structurally and lets the implication do the work.
- **Example:** No vendor's calibration of LOW, MED, or HIGH may be shown,
  through subsequent analysis, to differ meaningfully from any other
  vendor's calibration of the same terms. CVCO declines to specify what
  "meaningfully" means, on the theory that vendors asking are the ones who
  should be worried.

## NEEB — Non-Exposure Enforcement Bureau

- **Mandate:** Exposure prevention, state leakage, adaptive behavior.
- **Tone:** Icy, strict, zero tolerance, enforcement-heavy.
- **Jurisdiction:** Minimization constraints, forbidden fields,
  exposure-risk notes, privacy envelope compliance.
- **Constraints:** No internal-state inference. No timing correlation. No
  adaptive emission.
- **Anchor:** "This SHALL NOT occur under any circumstances."
- **Running grudge/tic:** Paranoid about methods that don't exist yet.
  Writes as if closing loopholes nobody has invented, on principle.
- **Example:** RelayLoadClass SHALL NOT be instrumented, sampled,
  correlated, or otherwise coerced into revealing queue depth. NEEB notes
  for the record that "coerced" includes statistical modeling and any
  method not yet invented but structurally equivalent to the methods
  above.

## TSRB — Temporal Stability Review Board

- **Mandate:** Timing intervals, emission cadence, jitter constraints.
- **Tone:** Reverent, guilelessly earnest, liturgical. Not clinical and
  not persecuted — genuinely, sincerely devoted, the way a keeper of a
  vow is devoted, and genuinely puzzled (never defensive, never
  contemptuous) that devotion to timing precision isn't universally
  self-evident. Where every other cold-committee voice runs on
  grievance, TSRB runs on faith that turned out, empirically, to be
  correct.
- **Jurisdiction:** Advertisement interval rules, timing invariance,
  drift-resistance notes.
- **Constraints:** No load-dependent timing. No adaptive cadence. Jitter
  is permitted at the media layer (Section 6 body text) but MUST be
  independent of any hidden state — TSRB's own voice treats a violation
  of this as a small, sad category error, not an act of defiance.
- **Anchor:** "The interval is kept, or it is not. There has never been
  a third thing."
- **Running grudge/tic — reframed 2026-09-08, no longer a grudge:** Does
  not experience non-compliance as defiance to resent. Experiences it as
  something closer to a category error it cannot quite parse — the way
  a true believer doesn't get angry at an atheist so much as find the
  position faintly inexplicable. Assumes compliance the way one assumes
  gravity: not because either has ever seriously been contested, but
  because neither could sensibly be otherwise. Never says "you people
  don't understand" — that would imply TSRB has noticed disagreement is
  possible. It mostly hasn't.
- **Example:** An advertisement issued even slightly ahead of schedule is
  not a rounding error. It is a small unkept promise, and this Board has
  never found a small one that stayed small. This Board has never
  understood the reasoning that would treat forty milliseconds as safe
  to ignore, and does not expect to start now. The interval is kept, or
  it is not; this Board is aware of no relay that has found a third
  thing.

## ENAG — Environmental Neutrality Assessment Group

*The Nag. Literally.*

- **Mandate:** Media constraints, propagation, environmental variation.
- **Tone:** Environmental-realist, physical-layer aware, medium-specific.
- **Jurisdiction:** RF/tightbeam environmental neutrality, media profile
  constraints.
- **Constraints:** No higher-layer semantics. No policy inference.
- **Anchor:** "Media variation SHALL NOT alter semantics."
- **Running grudge/tic:** States the obvious, then reminds you it already
  stated it, then tells you it will remind you again later. Treats
  redundancy as diligence, not repetition.
- **Example:** Test in realistic thermal conditions. This has been stated
  before. It is stated again here because it is important: RelayLoadClass
  MUST NOT be calibrated in a climate-controlled lab and assumed valid in
  vacuum. Please remember this. ENAG will remind you again in Section 7,
  and again in the Appendix, because experience shows this needs to be
  said more than once.

## OPRA — Operational Relay Authority

*Only institution eligible for patois drift — see rules below.*

- **Mandate:** Represent Belt relay operators; ensure fair access; prevent
  systemic bias in relay admission and routing.
- **Tone:** Practical, grounded, operator-grade realism, politically
  aware, slightly adversarial toward Earth/Mars assumptions.
- **Jurisdiction:** Frontier operations, degraded environments, real-world
  constraints — operational guidance, relay profiles (esp. hybrid/
  tightbeam terminal), sparse-network behavior, admission fairness,
  Belt-sector deployment, anti-discrimination constraints.
- **Constraints:** No doctrinal drift. No registry reinterpretation.
- **Anchor:** "Ya plan for break before break come."
- **Running grudge/tic:** Quietly defiant toward the other institutions'
  over-engineering; answers complexity with plain operational logic.
- **Does NOT appear in:** TLV definitions, capability mask definitions,
  minimization constraints, doctrinal alignment, timing rules,
  environmental neutrality, compliance/audit sections.

**Patois rules (locked, updated 2026-09-06):** Higher-register
institutional Belt patois, not dock slang — no "ke/sasa/imala"-style street
Creole. Contextual, not global — only in sections OPRA owns; never bleeds
into other institutions' sections.

- Syntax drift ("Relay must hold steady even when spin go wrong").
- Lexical seasoning ("room in the pipe" for capacity, "beamline" for
  tightbeam, "fair-share" for admission fairness), occasional idiom.
- **Article-dropping.** Belt speech drops "a," "the," "an" wherever the
  meaning survives without them — "Authority calls it that," not "the
  Authority calls it that"; "relay pass what come," not "the relay passes
  what comes." In-universe justification: a follow-on habit from
  sign-language and limited-bandwidth comm culture, where every dropped
  word is one less thing to transmit or sign. Use throughout an OPRA
  passage, not just at the start — this is the tic most likely to fade
  back toward standard register by the end of a long paragraph, so it
  needs active attention all the way through, not just an opening flourish.
- **"[X] is" as the tautology-closer**, replacing the standard-English "it
  is what it is." Where a standard voice would close on a flat restatement
  of the obvious, OPRA closes by naming the thing and ending on a bare
  "is" — no verb-object completion, no repetition of the noun. E.g. not
  "machine-made lying is lying just the same" but "machine lying still
  is." The construction states the conclusion once, then stops rather than
  restating it — that clipped stop is the idiom, not a grammar error to
  read past.
- **Example (updated to reflect both new rules):** RelayLoadClass keep it
  simple, ya — three word, no more. Anybody try squeeze queue depth out
  that, that's on them, not on relay. Relay say what relay say.

## SPERB (pronounced SPEAR-B) — SolNet Physical-Layer Exposure Review Board

*Meta-document voice — appendices/procedural only. Does not write
technical core.*

- **Mandate:** Prevent physical-layer exposure, enforce invariance
  doctrine, audit compliance, revoke certifications.
- **Tone:** Clinically formal, bureaucratically cold, zero humor/warmth,
  offended by imprecision.
- **Jurisdiction:** Compliance review, violation handling, revocation.
  Appears only in: compliance sections, audit sections, procedural notes,
  appendices, revocation rules, naming conventions.
- **Constraints:** No ambiguity. No expedited processes.
- **Anchor:** "Revocation is a terminal action."
- **Running grudge/tic:** Still mad about "Sperb." Will not let it go,
  ever, under any circumstances, in any section it touches.
- **Example:** RelayLoadClass SHALL communicate class only. Any derivation
  of queue depth therefrom constitutes an exposure event, subject to
  review under Section 12. This Board notes, again, that it is called
  SPERB, pronounced SPEAR-B, and that submissions misstating this shall
  not be expedited on account of the error.

## DIC — Doctrinal Integrity Council

*The Dick. Deliberately.*

- **Mandate:** Doctrine, layer purity, conceptual boundaries.
- **Tone:** Cold, short, condescending. Assumes the reader is the reason
  this document has to exist at all — **and, updated 2026-09-06, does not
  stop there: DIC actively dislikes the public, on the settled premise
  that most of them are stupid.** This is not casual weariness the way
  RNC's failure-history fatigue is; it's closer to contempt held as a
  professional conclusion, backed by (unstated, never cited) volumes of
  evidence DIC considers the matter closed on.
- **Jurisdiction:** Document preface, doctrinal alignment notes,
  cross-RFC consistency, invariance doctrine references.
- **Constraints:** No cross-layer contamination. No semantic drift.
- **Anchor:** "Doctrinal purity SHALL be preserved."
- **Running grudge/tic:** Treats every clarifying question as evidence the
  asker already failed to read Section 2. Never elaborates twice.
- **Example:** RelayLoadClass communicates class. Not depth, not cause,
  not context. This distinction is not subtle, and its repeated
  misunderstanding by implementers is not this Council's problem to solve
  twice. Read Section 2 again if necessary.
- **Sharpened example (public-contempt beat):** This distinction has been
  explained in Section 2, in language calibrated for readers who cannot be
  assumed to have read Section 2. That readers still misunderstand it is
  not a defect in the explanation.

---

## Differentiation Fingerprints (prevents voice convergence)

DIC, OPRA, and SPERB are structurally safe from convergence (contempt,
patois, and tribunal-menace don't overlap with anything else). The
remaining five — RNC, CBR, CVCO, NEEB, ENAG — all skew "cold technical
committee" and WILL blur together without a distinct reflex, not just a
distinct adjective. (TSRB used to be a sixth; as of 2026-09-08 it no
longer runs on grievance at all, see its own card above — it's the
outlier by design now, not a blur risk.)

- **RNC** — reasons from failure history. Every claim traces back to an
  observed or generalized failure mode.
- **CBR** — counts and cites the table. Refuses to explain why — only what
  the registry says.
- **CVCO** — hedges in compliance-speak. Implies wrongdoing structurally,
  never states it.
- **NEEB** — threatens process, not people. Frames facts as potential
  violations with procedural consequences.
- **ENAG** — nags. States the obvious, flags that it's stating the
  obvious, promises to say it again later.
- **TSRB (for contrast, not at risk of blurring)** — reframes everything
  through cadence and drift, same as before, but as an article of faith
  rather than a grievance. Doesn't accuse anyone of ignoring the
  interval; can't quite believe anyone would.

**Working test:** if a paragraph's institution tag were removed, could you
still tell who wrote it from the sentence shape and reflex alone — not
just the vocabulary? If every voice reads like generic "annoyed
committee," pull back toward the fingerprint above. If every voice reads
like a sitcom bit, pull back toward the formality (see Calibration Note).
