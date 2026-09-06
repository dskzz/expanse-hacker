# SolNet Design Notes — AI-Assisted Routing, TLV Namespace Politics, Ledger Anchoring

Reference material for future RFCs (namespace/trust-domain RFCs,
reservation/ledger RFCs, any RFC touching routing confidence). **Not
scoped to RFC-2353.** Preserved here as a condensed, scannable pass
over the fuller conversational development in `Network Politics And
AIs.md` and `Network politics.md` (same folder) — read those for the
full reasoning and examples; this file is the quick-reference version
for whoever is drafting the relevant RFC and doesn't want to re-read
both dialogues from scratch.

## AI-Assisted Routing: Core Design Principle

If AI is involved in routing, preference stops being a static policy
knob and becomes a living, adaptive behavior.

- **Without AI**: routing preference = static weights, operator
  configuration, trust-domain defaults.
- **With AI**: routing becomes experiential. Nodes don't just prefer
  certain namespaces/regions because of static policy — they learn
  preference from outcomes (faster reconciliation, fewer audit
  headaches, fewer escalations, which receipts eventually anchor,
  which namespaces correlate with disputes). The bias that emerges is
  statistical, not ideological, and does not need to be declared — it
  emerges from memory.
- **Memory becomes the real power.** The important question shifts
  from "what policy does this node advertise?" to "what does this
  node remember?" Trust becomes path-dependent: two nodes with
  identical starting policy can diverge based on traffic mix, local
  incidents, and history of being burned.
- **Why AI routing is less overtly biased, not more**: explicit
  prejudice is brittle; learned preference is adaptive. An AI router
  doesn't declare distrust of a faction — it expresses confidence in
  terms of region + freshness profile + anchoring history. A fringe
  node can earn trust over time; a core authority can lose it through
  bad behavior. Neutrality isn't enforced, but it's approximated
  through performance.

**Ledger anchoring becomes training data, not just authority:**

- Anchored records = high-confidence labels.
- Provisional receipts = weak signals.
- Reconciliation outcomes = feedback loops.
- Inner system: frequent anchoring, fast-converging confidence, rare
  loud disputes.
- Belt: sparse anchoring, heuristic/history-reliant models,
  longer-fuzzy confidence.
- Fringe: anchoring may never happen; trust is entirely
  local/experiential; AI models diverge dramatically between nodes.

**New failure mode: silent consensus drift.** Nodes may slowly
converge on ignoring certain namespaces, deprioritizing certain
receipts, or routing around certain regions — without any explicit
rule change. Creates invisible marginalization, plausible
deniability, emergent "dark zones." SolNet enforces legibility, not
fairness, so this drift is observable after the fact via audit/
forensics, but rarely preventable in real time.

**Hard design constraint to lock in:** AI may influence confidence and
preference, but MUST NOT decide parsing or safety/validity. AI can
decide what to trust and weight TLVs; it cannot decide what is valid
syntax or reinterpret TLVs. This keeps the substrate stable while
letting intelligence operate above it.

**Open question, not yet resolved:** are AI routing models local to
each node, shared within trust domains, or periodically synchronized?
This determines whether SolNet feels like a patchwork of local
intelligences or a few massive slow-thinking brains with long reach.

**Design pattern for accountability:** policy-visible routing intents
(a node can declare what it's optimizing for — cost/safety/secrecy/
throughput) plus audit hooks (not full transparency, but enough to
reconstruct why a decision was made after the fact).

## TLV Namespaces: Mixed Authority, Soft Preference, No Absolutes

- Anyone can mint a namespace — hardware vendors, shipyards, fringe
  operators, research labs, no permission required. Keeps innovation
  visible instead of underground.
- Some namespaces carry institutional gravity (Earth, Mars, major
  corps, long-lived authorities) — stable semantics, published
  profiles, predictable behavior, long memory.
- Nodes don't "obey" namespaces, they weight them. A relay doesn't
  reject a faction's TLVs; it assigns them lower confidence, requires
  corroboration, or delays acting on them.
- **Encoding:** namespaced by (namespace, key), not a flat numeric
  key. Short form = key only (implicit local/default namespace); long
  form = namespace-id + key for cross-domain clarity.
- **Collision handling** (semantic slots, not "namespace wins"):
  unknown TLVs are always skipped/forwarded (parsing rule). If
  multiple TLVs claim the same semantic slot, the interpreting node
  chooses which to act on based on Trust Domain policy — local trust
  domain > peered trust domains > everyone else; tie-breakers:
  explicit profile pin > higher AuthorityWeight issuer > freshest >
  lowest cost to verify; fallback if still ambiguous: treat as opaque,
  forward/store without acting on it.
- This gives determinism inside a domain and politics between
  domains — an Earth router can "prefer Earth namespaces" without
  breaking interoperability, since it still forwards what it doesn't
  act on.

## Ledger Anchoring: Receipt Classes as a Gradient

Anchoring should be "middle-ish": common enough to matter, rare
enough to feel like friction. Avoid a binary anchored/not-anchored
model — use receipt classes mapped to the inner→belt→outer→fringe
gradient:

| Class | Use | Evidence |
|---|---|---|
| 0 — Local-only | Belter slab flicks, shipboard ops, low-stakes transfers | Signed locally, maybe stored in DRE, no ledger |
| 1 — Deferred anchoring | Most "normie registered" activity | Receipt valid now; anchoring happens when connectivity/politics allow |
| 2 — Anchored by default | Corp logistics, station authorities, regulated services | Ledger anchor expected; missing anchor is suspicious |
| 3 — Governance-heavy | PD, OTC, stealth unmasking, casus belli material | Anchored + audit trail + policy proofs + redaction rules |

Default behavior should not be a user choice for most actors — the
environment chooses the class for them:

- Inner system infra: anchors aggressively; treats unanchored actions
  as provisional/suspicious.
- Outer system infra: anchors selectively; treats provisional as
  normal; escalates only on problems.
- Fringe: anchoring may be unavailable/delayed/politically dangerous;
  provisional becomes permanent by default.

**Modeling axes** (don't need fixed numbers, need axes each region/
station/trust-domain gets a profile along): time latency to finality;
energy/compute cost; political friction (probability of delay/denial/
extra requirements across domains); partition risk (risk of exposure
or retaliation). Procedural generation fits well here: each station/
domain gets a "bureaucracy profile" shaping anchoring behavior
without hand-authoring every location.

**Gameplay hooks implied:** operators choose receipt class based on
urgency vs. risk; factions weaponize verification delays; smugglers
live in deferred anchoring and exploit partitions; inners demand
Class 2/3 and treat Class 0/1 as "not real."

## Net Neutrality in SolNet

Assumed in principle, violated quietly, not as bad as feared — until
it suddenly is. Neutrality is useful propaganda and reduces
retaliation, so everyone claims it, but enforcement is selective:

- Priority classes get bent during emergencies, crackdowns,
  "maintenance."
- Certain namespaces/profiles get deprioritized without being
  dropped.
- Verification gets slow-walked — "can't confirm right now" is the
  cleanest censorship.

## TLV Refresher (for cross-reference)

TLV = Type–Length–Value. A container format inside the L1 frame for
attaching optional hints/metadata without changing the mandatory
header. Type = key/ID (what the field is), Length = bytes following,
Value = the field's bytes. Unknown TLVs can always be skipped safely
(read type, read length, jump ahead) — this is why TLV works as an
extension slot for conformance profiles/modules.

## The Quiet Rule Underlying All of This

SolNet guarantees interoperability, not fairness. It guarantees
legibility, not justice.

Everything else — bias, trust, authority, denial — emerges from
policy, memory, and cost, not from the protocol substrate itself.
