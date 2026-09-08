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

**2026-09-08 (later same session) — OPRA moved to real Lang Belta,
superseding the 2026-09-06 "no street Creole" lock.** After the article-
dropping fix still didn't land ("section 8 doesn't sound like Belters at
all"), the user supplied their own rewritten sample using actual Lang
Belta grammar and vocabulary and asked for the rules to be extrapolated
from it plus outside reference material. New v2 patois rules (see OPRA's
own card above) add real grams — `gonya`/`gonna` future particle,
`-lowda` plural suffix, `be` as a job-specific locative/equative copula,
`no` for negation — on top of the existing article-dropping and
tautology-closer rules (the closer's form changed from "[X] still is" to
"[X] still be" to match the new copula). Also established: OPRA's
institutional register sits at the Ganymede/legible end of a real
in-universe Belt Creole gradient, not the Pallas/near-unintelligible end
— that's available elsewhere in the corpus, not in this document.

**2026-09-08 (later still, same day) — v2 corrected to v3 against the
actual primary source.** The user pushed the real reference material to
the repo: `docs/lore/Lang Belta 2022-02-15.pdf`, a 361-page dictionary
sourced to on-screen dialogue and direct quotes from Nick Farmer, the
language's creator. v2 had been built from search-engine summaries
(the user's own links were blocked by network egress) and got two things
wrong: (1) `be`/`bi` is NOT a general equative copula — Farmer states
directly "the copula is always null" for equatives, `bi` is locative-
only; (2) negation is `na`, not `no` (Farmer: "na = no/not"). Also added:
`-lowda` pluralizes pronouns only, never nouns (Farmer, directly), and
postpositive adjective order for simple adjectives (two independent
dictionary entries confirm noun-then-adjective). Full corrected rules
and quotes in OPRA's card above; RFC-2353 §8/§8.5 re-edited to match.

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

**2026-09-08 (same session) — ENAG corrected: weaselly, not stern.**
User caught that ENAG's "nag" was still written in the same
institutional-command register as everyone else (MUST NOT be construed,
does not certify assumptions) — a nag that scolds isn't actually a nag,
it's just another stern committee. Real nagging is low-stakes, mundane,
repetitive, and carries no real authority: "remember to take the
garbage out... don't forget to take the garbage out..." Rewrote ENAG's
card and worked example around that register. Normative MUST/MUST NOT
language stays precise where an actual requirement exists; only the
connective tissue around it softened.

**2026-09-08 (later still) — v3 grammar applied corpus-wide within
RFC-2353, not just §8/§8.5.** OPRA also speaks in Appendix C's field
note, Appendix D (Deployment Guidance), Appendix H (Historical Context),
and Appendix J.1/J.3/J.4 (Implementation Notes) — all of it was still on
the old article-dropped-only register until this pass. Brought all six
spots up to v3 (`na` negation, `fo` for prepositional "to"/"for",
`kowl`/`kowlting` for "all"/"everything," zero copula for equatives)
so the whole document reads as one consistent voice rather than "§8 got
the good version." Same normative content throughout, register only.

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

*The Nag. Literally — but weaselly, not stern. Reworked 2026-09-08.*

- **Mandate:** Media constraints, propagation, environmental variation.
- **Tone:** Domestic-nag, not command-voice. Not "MUST NOT be construed" —
  more "don't forget," "just a reminder," "this Group would ask." No
  real authority behind the reminding, and it knows it; repetition is
  the only tool it has, so it uses repetition. Never threatens
  consequences. Never scolds. Just... reminds you. Again. Softly. Once
  more after that.
- **Jurisdiction:** RF/tightbeam environmental neutrality, media profile
  constraints.
- **Constraints:** No higher-layer semantics. No policy inference. Keep
  actual normative MUST/MUST NOT language precise where a real
  requirement exists — the nagging lives in the connective tissue around
  the rule, not in softening the rule itself.
- **Anchor:** "Just a reminder — again — that media variation shouldn't
  be read as saying anything about semantics. Sorry to repeat it."
- **Running grudge/tic:** Not a grudge — ENAG isn't annoyed at anyone. It
  states the obvious gently, apologizes slightly for repeating itself,
  and repeats itself anyway, the way a housemate reminds you about the
  garbage: not because they think you're defiant, just because they
  suspect you forgot, and will keep suspecting that indefinitely.
- **Example:** This has probably been said already somewhere else in
  this document — it's the sort of thing that's easy to skip past, so
  here it is again: test in the actual thermal conditions of intended
  deployment, not a climate-controlled lab. This Group will likely
  mention it again in the Appendix too. Not because anyone's in trouble.
  Just in case it didn't land the first time.

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

**Patois rules v3 (supersedes v2 and the 2026-09-06 lock), updated
2026-09-08 — real, sourced Lang Belta, corrected against the primary
reference.** History: the 2026-09-06 lock banned real Belter Creole
outright ("no ke/sasa/imala-style street Creole") in favor of an
invented "higher-register patois" that turned out, on the actual page,
to just be English with articles dropped. v2 (same day, later) reversed
that and pulled in real grams via search-engine summaries, since the
user's own reference links were blocked by this session's network
egress policy. The user then supplied the actual primary source directly
— `docs/lore/Lang Belta 2022-02-15.pdf`, a 361-page community-compiled
dictionary sourced to on-screen dialogue and Nick Farmer's (the
language's actual creator) own tweets/Discord/Patreon comments — and
this pass corrects v2 against it. Two of v2's rules were wrong; both
are fixed below with the primary-source quote that corrects them. Still
contextual, not global — only in sections OPRA owns; never bleeds into
other institutions' sections.

**Register calibration — Ganymede, not Pallas.** Per the user: Belter
Creole itself has a real register gradient across the Belt — Ganymede
trends back toward intelligible English (more integrated with the inner
planets, more trade contact), while somewhere like Pallas runs thick,
near-unintelligible to an outsider. OPRA's institutional voice, writing
in a cross-Belt normative document meant to actually be read and
implemented, sits at the Ganymede end on purpose — real grams and
vocabulary throughout, but never so thick the normative content stops
parsing. Deep, Pallas-thick Belta is a real, available register for this
corpus (NPC dialogue, flavor text, a rougher station's own voice) — just
not this document's register.

**Confirmed grammar (sourced to the PDF, Farmer quoted directly where
noted):**

- **SVO word order** for basic clause structure.
- **Adjectives follow the noun** they modify (like French, not English)
  — confirmed by two independent dictionary entries: "raya bik" = "beam
  big/wide" (not "bik raya"), and an explicit grammar note under `nada`:
  "adjectives follow the nouns they describe, quantifiers precede their
  nouns." Applied selectively in this corpus: simple standalone
  adjectives flip ("hardware older," not "older hardware"); compound
  technical modifiers that function as a fixed unit (low-band, RF,
  high-capability) stay in English order for legibility — a deliberate
  Ganymede-end calibration choice, not an oversight.
- **Quantifiers precede the noun** ("kowl belta" = "all Belters") —
  same source note as above.
- **Zero copula is the actual default — corrects v2.** Farmer, quoted
  directly under the `bi` entry: *"there are no prepositions in this
  sentence, and the copula is always null"* and, elsewhere, *"Bi is the
  locative copula."* Confirmed by contrast in two dialogue lines:
  *"Milowda bi xom"* ("We are home" — locative, gets `bi`) vs. *"Kowl
  beltalowda beratna mi"* ("All Belters are my brothers" — equative,
  **zero** copula, no `bi` at all). v2 used `be`/`bi` as a general
  equative filler ("T_adv be same as every other relay," "whatever
  cause be") — wrong. Corrected: drop it entirely except for genuine
  physical location ("Where beltalowda be" stays, because it's asking
  where Belters actually are).
- **`gonya` / `gonna`** — future-tense particle, preverbal. Written
  `gonna` in this corpus (matches the user's usage, reads cleaner
  against an English matrix). Confirmed: "a verb particle to mark
  future," from Engl. "gonna."
- **`ta`** (past), **`nyish`**/`finyish` (perfective — "completion of an
  action"), **`tili`** (habitual) — the rest of the preverbal TAM
  particle set, all confirmed in the dictionary. Not yet used in
  RFC-2353's §8 (no clear past/habitual moment arises there), but
  available and correctly ordered before the verb, same slot as `gonya`.
- **Negation is `na`, not `no` — corrects v2.** Farmer, quoted directly:
  *"na = no/not #Belter #TheExpanse"* — and in dialogue, *"Milowda na
  ányimal"* ("We are not animals," zero copula + `na` negating the bare
  predicate directly). v2 used `no` throughout because that's what the
  user's own draft sample used; the primary source is unambiguous that
  `na` is the real particle, so `na` is now this corpus's form too.
- **`fo`** — "for"/"to" (preposition), confirmed repeatedly in dialogue
  ("Fo ademeshang fo da Sonya Gering..." = "For admission to the Green
  Zone..."). Use `fo` in place of English "to"/"for" wherever they're
  acting as prepositions — not just for flavor: real Lang Belta's own
  word **`to` means "you"** (Farmer, directly: "to = you"), so leaving
  English "to" in as a preposition risks a genuine double-read for
  anyone who actually knows the language. `fo` disambiguates. (Leave
  infinitive "to" before a bare verb alone if swapping it would garble
  the clause — judgment call, not a hard rule.)
- **`kowl`** — "all" (quantifier, precedes the noun: "kowl belta" = "all
  Belters"). **`kowlting`** — "everything"/"everyone" (kowl + ting,
  confirmed in dialogue: "kowlting gonya gut" = "everything's gonna be
  fine"). Use `kowlting else` for "everyone else," not English "everyone
  else."
- **`sili`** — "if," confirmed in dialogue ("Sili to mebi avita..." =
  "If you resist..."). Can open the conditional clause (matching the
  source example) or follow the main clause, same flexibility as
  English "if."
  (v2's guess that `no`/`na` might be a Ganymede/Pallas register split
  was pure speculation and is retracted — no source support.)
- **`-lowda` pluralizes pronouns ONLY, never ordinary nouns — corrects
  v2.** Farmer, quoted directly: *"-lowda is the pluralizer for
  pronouns (e.g. mi, milowda)"* and, separately, *"No plural ending on
  nouns."* `beltalowda` works because `belta` is functioning as an
  identity/pronoun-adjacent root, not because nouns pluralize with it
  generally — never coin `relaylowda` or similar. This actually
  validates something already in place: nouns in this corpus's OPRA
  prose were already left bare regardless of number (the 2026-09-08
  correction below, about not mixing bare and `-s`-marked nouns, now
  has a real grammatical reason behind it, not just a stylistic one).
- **Article-dropping** (the 2026-09-06 rule, kept): "a/the/an" drop
  wherever meaning survives without them.
- **`wamotim`** — "again" / "more than [needed]."
- **Project-specific coinages, still not independently verified against
  the dictionary — hold consistent rather than re-deriving:** `fokaso`
  (relay contact breaking down/faltering), `terásheting` (an
  occlusion-class event), `seleshang` (another gap-cause alongside DTN
  partition). None of the three turned up in the PDF under those exact
  spellings; treat as the user's own coinages in the source language's
  style, not confirmed vocabulary.
- **Article-dropping correction, 2026-09-08** (still valid): the
  failure mode found in RFC-2353's §8 draft was topic sentences reading
  close to standard register while only punchline closers carried real
  drift. Front-load the drift: the first sentence of an OPRA paragraph
  needs it as much as the last one.
- **"[X] still be" as the tautology-closer.** This is a corpus-invented
  idiom — "it is what it is" has no attested Belta equivalent in the
  source, so there's no authentic form to defer to. Kept as a
  deliberate, marked exception to the zero-copula default (not a claim
  that `be` is a general equative), specifically because the strictly
  "correct" zero-copula form — "Lying still," dropping the verb
  entirely — collides with the existing English idiom "lying still"
  (motionless), which would misread. `be` disambiguates. Where a
  standard voice closes on a flat restatement of the obvious, OPRA names
  the thing and ends on a bare "be": "Machine lying still be," not
  "machine-made lying is lying just the same."
- **Example (corrected for v3 grammar):** RelayLoadClass keep it simple
  — three word, no more. Anybody gonna try squeeze queue depth out that,
  that's on them, na on relay. Relay say what relay say. Lying still be.

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
- **ENAG** — nags, weaselly not sternly. No command-voice, no threatened
  consequence — just gentle, faintly apologetic repetition, the way a
  housemate reminds you about the garbage. Suspects you forgot, not that
  you defied it.
- **TSRB (for contrast, not at risk of blurring)** — reframes everything
  through cadence and drift, same as before, but as an article of faith
  rather than a grievance. Doesn't accuse anyone of ignoring the
  interval; can't quite believe anyone would.

**Working test:** if a paragraph's institution tag were removed, could you
still tell who wrote it from the sentence shape and reflex alone — not
just the vocabulary? If every voice reads like generic "annoyed
committee," pull back toward the fingerprint above. If every voice reads
like a sitcom bit, pull back toward the formality (see Calibration Note).
