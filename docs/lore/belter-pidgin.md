# Rock Talk — the Belter Pidgin (replaces Lang Belta)

Status: **locked, 2026-11-20.** Replaces the real, sourced Lang Belta
grammar/vocabulary used in RFC-2353 and RFC-2310's §7 field note — same
reasoning as the MCRN→MDR/OPA→OSL/ASA renames: Lang Belta is Nick
Farmer's specific invented conlang for a different, actively-marketed
franchise, not something to ship in a commercial product.

**In-universe name:** Rock Talk, spoken by the **Kamenya** (Belters,
collectively).

## The governing idea: a VOX language first

Rock Talk started as suit-comms and relay-channel discipline, not a
native tongue — the same justification already established for OPRA's
article-dropping tic (`Notes/voices/voice_profiles/SPERB Sub-Bureau
Voices.md`: tied to "sign-language/limited-bandwidth comms culture").
This takes that from one grammatical tic to the organizing principle
of the whole pidgin: **if a word's meaning survives without it, cut
it.** That's also the hard filter for adding any new word later: it
must (a) already be recognizable to an English reader — a naturalized
loanword, not obscure foreign vocabulary — and (b) be short, one
syllable preferred, two at the outside. Savvy/palaver/Kamenya get an
exception because they're load-bearing named concepts, not ordinary
vocabulary.

## What this is built from

Two real historical layers, neither of them Lang Belta's:

1. **Age-of-sail trade pidgin** — Chinese Pidgin English (Canton/Hong
   Kong trade, 17th–19th c. — also gave English "long time no see,"
   "no can do") and the broader Atlantic maritime pidgin of the same
   era. Source of the core grammar: object-form pronouns for every
   role, `all-` as a plural marker, `bimeby` ("by and by") as the
   future particle, `s'pose` ("suppose") for conditionals, plain `no`
   for negation. Genuinely old, not contemporary-coded.
2. **A handful of already-naturalized loanwords** from French, German,
   and Hindi/Sanskrit — chosen because English speakers already
   half-know them, the same way `savvy` and `palaver` work. Not a
   systematic four-language vocabulary; just enough spice to read as
   a real multi-substrate pidgin without needing a glossary.

## Core grammar

- **SVO word order.**
- **Zero copula for equatives** (default — "X Y" = "X is Y").
- **`tam`** — locative ("there/is there"), the one case zero-copula
  doesn't cover.
- **Object-form pronouns, every role:** `me` / `you` / `him` (he-she-it,
  gender-collapsed).
- **Plural via `all-` prefix:** `all-me` (we), `all-you` (you-all),
  `all-him` (they).
- **`no`** — negation, preverbal.
- **`bimeby`** — future ("gonna," "will eventually").
- **`fini`** — completive/perfective ("already done").
- **`s'pose`** — conditional ("if").
- **`dis` / `dat`** — demonstratives (this/that).
- **Reduplication** marks habitual, intensity, or "for real, no
  exceptions": `trouble trouble` (serious danger), `same same`
  (genuinely identical), `no no` (absolutely not).
- **The identity suffix `-ya`** is productive — attach it to a root to
  make a demonym/collective-identity noun: `kamen` (rock) + `-ya` =
  **Kamenya** (Belters); `inner` + `-ya` = **Innya** (Inners,
  generic for Earth/Mars). Extensible the same way if Earth and Mars
  ever need splitting apart (`Erya`, etc.).
- **No articles, ever.**

## Core vocabulary

| Rock Talk | English | Source |
|---|---|---|
| `savvy` | know / understand | pidgin-English (Sp./Port. *sabe*) |
| `palaver` | talk / negotiation / unresolved deal | pidgin-English (Port. *palavra*) |
| `kaputt` | broken / failed | German |
| `ami` | friend | French |
| `bon` | good | French |
| `fini` | done / completive (grammar particle, see above) | French |
| `chai` | tea | Hindi |
| `guru` | expert / wise one | Hindi/Sanskrit |
| `karma` | consequence / debt owed | Hindi/Sanskrit |
| `kamenya` | Belters, collectively | Russian *камень* (stone) + `-ya` |
| `innya` | Inners (Earth/Mars people), collectively | English "inner" + `-ya` |

**Kept plain English, no replacement forced:** water, work,
trouble/danger, fast, for — no candidate loanword cleared the
recognizability-and-brevity bar, so these just stay English.

## Worked examples

> `Him bon ami.`
> he/she good friend
> *"They're a good friend."*

> `Dis no bon. No go tam.`
> this not good. not go there.
> *"This isn't good. Don't go there."*

> `Trouble trouble tam — no go.`
> trouble-trouble there — not go
> *"There's real danger over there — stay away."*

> `All-me fini work. All-him no fini.`
> we completed work. they not completed.
> *"We're done. They're not."*

> `Bimeby you savvy why.`
> by-and-by you understand why
> *"You'll understand why, eventually."*

> `S'pose you no savvy, no go.`
> suppose you not understand, not go
> *"If you don't understand, don't go."*

> `No palaver till him fini pay karma.`
> not talk until he/she completed pay consequence
> *"No negotiating until they've paid what they owe."*

> `Kamenya no ami for Innya.`
> rock-people not friend for inner-people
> *"Belters have no love for Inners."*

> `Innya no savvy kamenya. Kamenya no savvy Innya.`
> inner-people not understand rock-people. rock-people not understand inner-people.
> *"Inners don't get Belters. Belters don't get Inners."*

## Still open

- Vocabulary stays small and growable — extend here when a document
  needs a word that isn't listed, applying the filter above, rather
  than inventing one-offs elsewhere.
- Applying this corpus-wide (RFC-2353's "beltalowda" line, RFC-2310's
  field note) is a separate, not-yet-done pass — this file locks the
  language itself; applying it to existing documents comes next.
