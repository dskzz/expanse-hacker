# Rohktok — the Belter Pidgin (replaces Lang Belta)

Status: locked, 2026-11-20. Original constructed pidgin for OPRA's voice
and general Belt-flavor dialogue, replacing the real, sourced Lang Belta
grammar/vocabulary used in RFC-2353 and (until this note) RFC-2310's §7
field note. Same reasoning as the MCRN→MDR/OPA→OSL/ASA renames: Lang
Belta is Nick Farmer's specific invented conlang for a different,
actively-marketed franchise, not something to ship in a commercial
product.

**In-universe name:** Rohktok ("rock talk") — a Belter-coined term,
following the same real naming pattern Tok Pisin and Bislama use
("talk" + descriptor), without reusing either of those actual names.

**What this is built from, and what it isn't.** The grammar below
follows well-documented, real-world creole typology — the kind of
structural features (zero copula, preverbal tense-aspect particles,
no case marking, reduced inflection) that recur independently across
dozens of real creoles worldwide, including Tok Pisin and Krio, which
is why this reads as authentically "creole-shaped" rather than
invented nonsense. The actual **words** are original coinages, not
borrowed from Tok Pisin, Krio, or Lang Belta. Same split as Lang
Belta's own real creator used — real structure, invented vocabulary —
just without reusing anyone's specific existing words, theirs or ours.

## Core grammar

- **SVO word order.**
- **Zero copula for equatives** (the default — "X Y" means "X is Y,"
  no linking verb). `sta` is the one exception: a dedicated **locative**
  copula, used only for genuine physical location ("where something
  actually is"), same split Lang Belta's `bi`/zero-copula distinction
  made for RFC-2353.
- **Preverbal TAM particles**, one per verb phrase, in this order
  (future/past/aspect, then negation, then verb):
  - `sko` — future ("gonna")
  - `tol` — past
  - `zeh` — perfective/completed
  - `ruk` — habitual
- **Negation:** `vey`, preverbal — "`ten vey sko go`" = "they're not
  gonna go."
- **Quantifiers precede the noun:** `vash` = all, `vashting` = everything
  /everyone (vash + ting, same compounding logic as Lang Belta's
  kowl/kowlting, different root).
- **No articles** — drop a/the/an wherever meaning survives without them.
- **No plural suffix on ordinary nouns.** Pronouns pluralize with a
  dedicated suffix, `-wa`: `ja` (I/me) → `jawa` (we); `yo` (you) →
  `yowa` (you-all); `ten` (he/she/it) → `tenwa` (they).
- **Conditional:** `lenga` ("if"), opens or follows the clause, same
  flexibility as English "if."
- **Preposition for "for/to":** `ku`.

## Core vocabulary

| Rohktok | English |
|---|---|
| `ja` / `yo` / `ten` | I-me / you / he-she-it (plural: `jawa`/`yowa`/`tenwa`) |
| `vey` | not / no (preverbal negation) |
| `sko` / `tol` / `zeh` / `ruk` | future / past / perfective / habitual particle |
| `sta` | locative copula ("is [somewhere]") |
| `vash` / `vashting` | all / everything, everyone |
| `ku` | for / to |
| `lenga` | if |
| `rohkfolk` | Belters, collectively (the identity-root, parallel to `belta` — invariant, doesn't need a plural marker) |
| `fray` | to fail / break / glitch |
| `kreb` | work / duty / job |
| `deng` | danger / trouble |
| `lenz` | to listen / hear |
| `zuv` | to know |
| `mek` | to make / do |

## Worked comparison

RFC-2353's existing OPRA line, in Lang Belta (as currently shipped) vs.
Rohktok:

> Lang Belta: *"Where beltalowda be, relay contact gonna fokaso, gonna
> break."*
>
> Rohktok: *"Where rohkfolk sta, relay contact sko fray, sko break."*

RFC-2310 §7's field note, in Rohktok (replaces the Lang Belta version
currently live in the artifact):

> *"Sector vey got repeater infrastructure vey lose QKD's
> eavesdropping-detection property — lose reach, same way lose reach on
> any physically constrained medium. This the existing admission-
> fairness, sparse-topology deng OPRA already kreb elsewhere this
> corpus, vey new one this document bringing. No new OPRA mechanism
> proposed here; this note sta so parallel vey lost next time somebody
> sko draft one."*

## Still open

- This vocabulary is intentionally small (just enough to cover OPRA's
  established grammatical tics — article-dropping, zero-copula,
  tautology-closer, future/negation particles). It'll need expanding
  the next time a document needs a Rohktok word that isn't here yet —
  extend it here, don't invent one-off words in the document itself.
- The actual corpus-wide swap (RFC-2353's "beltalowda," and RFC-2310's
  field note once this is confirmed) hasn't been done yet — this file
  locks the language itself; applying it is a separate pass.
