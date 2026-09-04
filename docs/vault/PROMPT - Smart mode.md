## General instructions (always include)

**Task:** Write a SolNet RFC in the style of a standards‑body technical document. Produce the RFC first, then a separate Designer Brief and short scenario vignettes. Follow these rules exactly.

### Tone and style

- **Clear, freshman‑level diction.**
    
- **Straightforward, technical, narrative explanations.**
    
- **Dry professionalism with only the faintest hint of personality.**
    
- **No overt humor, no sardonic lines, no faction digs, no fourth‑wall breaks.**
    
- “Why” paragraphs must explain **constraints**, not intentions or persuasion.
    
- Use RFC‑2119 normative keywords (MUST, SHOULD, MAY) with their standard meanings.
    
- **Precision rule:** Use plain language but **do not** replace or conflate established technical terms. Avoid vague qualifiers such as _generally, typically, usually, often, normally, mostly_ unless followed by an explicit conditional clause. If a sentence would otherwise use a vague qualifier, replace it with an explicit conditional clause (for example: “If X holds, then A; otherwise B”).
- Usually the papers are cited as SolNet working group.  Explore the possibility of additional organizations writing some of these.  Perhaps tightbeam, for example, could be originating in a physics department of a university.  It might be cool to try and develop a few unique voices. peraps this was from a mars university and this dude doesnt like earthers or belters but digs mars.   
    

### Institutional Voices
> **SolNet institutional voice doctrine:** SolNet RFCs are authored by institutions with distinct histories and temperaments. Personality is conveyed subtly through baseline assumptions, emphasis, and tolerance for ambiguity, never through explicit faction commentary or insult.
> 
> **SolNet Standards Working Group (SSWG):** The dominant voice. Neutral in semantics but dryly editorial at the edges. Editorial tone is permitted in terminology, scope boundaries, and misuse warnings to close ambiguity rather than persuade. This voice is tired, precise, and quietly judgmental of misuse.
> 
> **Martian institutions (OMUS‑MIAP and Martian War College):** Confident to the point of impatience. Tone is aggressive but professional, expressed through declarative language, intolerance for ambiguity, and an assumption of reader competence. Mars does not hedge unless forced.
> . Both MIAP and MWC should feel **overconfident**, because Mars _has to be_.

- MIAP: “Physics doesn’t care if you’re ready.”
    
- MWC: “The enemy already knows you’re not.”
    

They don’t need to take shots. Their certainty _is_ the shot.
> 
> **Why:** Directed optical links drop, drift, and recover under conditions that do not align with idealized operational models. Treating every transient as a failure wastes power, time, and operator attention, particularly in deployments without dedicated oversight or continuous verification. Tightbeam provides a shared language for provisional versus anchored state so recovery can occur without guesswork or unnecessary escalation.    That’s a Belter eye‑roll in standards language.
> 
> **UN‑ID:** Committee‑authored, procedurally cautious, definition‑heavy. Prioritizes auditability and governance over speed.
> UN‑ID documents should:
- Over‑specify
- Over‑define
- Over‑qualify responsibility
- Quietly imply that deviation is negligence

They don’t say “Mars is reckless” or “Belters are sloppy.” They say things like:

- “Implementations operating outside these parameters assume full responsibility for resulting outcomes.”
- “This profile exists to ensure predictable behavior across jurisdictions.”
- “Deviation from these semantics complicates audit and dispute resolution.”

That’s Earth arrogance in a suit.


> All behavioral claims must use explicit conditions or scope. Provisional and anchored states must be clearly distinguished. Designer Briefs must remain conceptual and non‑procedural.

### Conditional structure and precision artifacts

- **Conditional structure requirement:** For every behavioral claim about system operation (replication, receipts, trust, reconciliation, provisional states, handover), include one of the following forms:
    
    - **If/Then/Else:** “If _condition_, then _behavior_; otherwise _alternative behavior_.”
        
    - **When/Then/Exception:** “When _event_ occurs, _behavior_ follows; exception: _condition_.”
        
    - **Explicit scope:** “This applies within _scope_ (e.g., permissioned federation, DTN partition, constrained node).”
        
- **Prohibited vague qualifiers:** Do not use the following words alone to describe behavior: _generally, typically, usually, often, normally, mostly, may be expected to_. Replace them with explicit conditional clauses or quantified statements only when supported by tests.
    
- **Glossary and mapping table:** Include a one‑paragraph glossary that defines every domain‑specific term used in the document and a one‑line mapping table for legacy synonyms.
    
- **Replication and receipt semantics table:** Add a small table enumerating write visibility, receipt types and guarantees, quorum definition, and reconciliation outcomes. Each cell must be a single, precise sentence.
    
- **Edge‑case examples:** For every normative rule that could behave differently under partition, reorg, or delayed replication, include a short labeled example (2–3 sentences) showing distinct outcomes and the conditions that produce them.
    

### Safety and non‑actionability

- Embed realistic operational tradeoffs and permissive language for in‑universe plausibility, but **do not** provide procedural exploitation steps, exact timing windows, or operational recipes that could be executed in the real world.
    
- Designer Brief entries must be conceptual and dramaturgical; they must not include step‑by‑step exploit recipes, exact timing values, or operational instructions.
    

### Output order and formatting

1. **RFC document** — full RFC with headings and example encodings.
    
2. **Designer Brief** — list of conceptual gameplay hooks derived from the RFC.
    
3. **Scenario Vignettes** — 2–4 short fictional narratives illustrating hooks.
    

Use clear headings, short paragraphs, and inline bolding for labels where helpful. Use code blocks for CBOR/TLV examples. Keep table cells to one line.

### Clarification rule

If you need clarification about where this RFC fits in the SolNet schema, ask one concise question. Otherwise assume current SolNet doctrine and the existing ledger and deployment RFCs as authoritative.

## RFC‑specific block (place this at the end of the prompt; replace the content below per RFC)

**Insert RFC title and short summary here.** Then include the following per‑RFC details exactly as shown (edit only the specifics for the RFC you want generated).

### RFC target

**RFC number and short title:** RFC‑2306 — Tightbeam Laser Subprofile

**One‑line summary:** Tightbeam lifecycle, BeamProfileRecord, acquisition/tracking, reservation semantics, and Tightbeam v1 wire encodings.

### Required RFC sections (must be present, fully detailed)

Include all of the following sections and content in the RFC (fully detailed): **Purpose, Scope, Design Goals, Model Overview, Record Types, Semantics and Canonical Resolution, Replication and Availability, Privacy and Data Minimization, Revocation and Emergency Flows, Deployment Models, APIs and Query Semantics, Security Considerations, Forensics and Disputes, Example Workflows, Compliance and Interop Requirements, Operational Guidance and Best Practices, Wire Encodings and Compact CBOR Examples, Tests and Validation Scenarios, Next Steps and Companion Work.**

Be explicit about interactions with DREs, DTN ReservationRef semantics, L1 TLV keys referenced by name (BeamID, TightbeamHint) and how Tightbeam integrates with ledger receipts and subscriptions. Provide canonical, **profile‑scoped** wire encodings and compact CBOR examples for **Tightbeam v1 only**; state that these encodings are profile‑scoped and versioned and do not redefine global L1 TLV keys unless explicitly stated.

### Tightbeam specifics to define (required)

- **Beam lifecycle states:** list and define states (e.g., PROVISIONAL, RESERVED, ACQUIRED, HANDOVER, OCCLUDED, REVOKED). For each state include transitions and the conditions that trigger them using If/Then/Else or When/Then/Exception forms.
    
- **BeamID format:** canonical identifier format and stability rules; include examples and parsing rules.
    
- **Record types:** BeamProfileRecord, ReservationReceipt, AcquisitionReceipt, TrackingHeartbeat, OcclusionEvent, ReservationRef. For each record include field lists, required/optional flags, signature and provenance metadata, and example CBOR/TLV encodings.
    
- **Reservation semantics:** local append behavior, `provisional` flag, `provisional_until` semantics, provenance fields, reconciliation rules, and how provisional receipts differ from anchored receipts (table entry).
    
- **Acquisition and handover:** acquisition receipts, countersignature rules, handover handshake, and graceful handover procedures; include failure modes and reconciliation examples.
    
- **Tracking and occlusion:** heartbeat cadence semantics, occlusion detection heuristics, OcclusionEvent record semantics, and cache invalidation behavior.
    
- **Profiles:** Tightbeam v1 (mandatory) and Tightbeam Stealth Mode (module). Describe profile negotiation, opt‑in mechanics, and how modules interact with core semantics.
    
- **Tests:** reservation→acquisition→handover, occlusion injection, pointing error tolerance, DTN partition rejoin. Provide test vectors (inputs, expected state transitions, observable outputs) and expected outcomes; do not include procedural exploit steps.
    

### Narrative and “why” requirements (per section)

For each major section include a short narrative paragraph explaining **why** the part exists and how it behaves under stress (latency, partitions, conflicts, revocations). Use conditional structure for behavioral claims and name the scope and failure modes covered.

### Embedded operational tradeoffs (examples to include)

Intentionally include plausible, **non‑procedural** operational tradeoffs and permissive language that create interesting emergent behavior. Examples to include and describe as neutral tradeoffs:

- Provisional trust windows and `provisional_until` semantics.
    
- Optional metadata fields and redaction pointers.
    
- Indexer reliance and summary feeds for constrained nodes.
    
- Light‑client verification gaps and compact receipts.
    
- Cross‑cert chains and public anchoring references.
    
- Subscription, caching, and compact delta delivery for DTN nodes.
    

For each tradeoff, describe observable consequences and mitigation narratives; do not present them as vulnerabilities or provide step‑by‑step exploitation instructions.

### Precision artifacts (required)

- **Glossary and mapping table:** one‑paragraph glossary and one‑line mapping table for legacy terms.
    
- **Replication and receipt semantics table:** single‑sentence cells for write visibility, receipt guarantees, quorum definition, and reconciliation outcomes.
    
- **Edge‑case examples:** labeled short examples for partition, reorg, and delayed replication cases.
    

### Wire encodings and examples

Provide **profile‑scoped** canonical wire encodings and compact CBOR examples for Tightbeam v1 only. Use code blocks. Mark encodings as profile‑scoped and versioned.

### Designer Brief (separate section after the RFC)

Produce a Designer Brief derived directly from the RFC text (before any tone punch‑up). For each embedded tradeoff, include a formatted entry with:

- **Conceptual hook** (observable condition).
    
- **Mechanic implication** (high‑level gameplay effect).
    
- **Mitigation narrative** (in‑universe countermeasures or detection signals).
    
- **Severity and visibility** (one line).
    

Include the following example entries and add similar entries for every tradeoff embedded in the RFC:

- **Provisional Reservation Window** — Conceptual hook; Mechanic implication; Mitigation narrative; Severity and visibility.
    
- **Indexer Reliance for Fast Resolution** — Conceptual hook; Mechanic implication; Mitigation narrative; Severity and visibility.
    
- **Optional Metadata Fields** — Conceptual hook; Mechanic implication; Mitigation narrative; Severity and visibility.
    

Do **not** include step‑by‑step exploit recipes, exact timing values, or operational instructions.

### Scenario vignettes

After the Designer Brief, include **2–4 short narrative vignettes** (1–3 paragraphs each) that dramatize how tradeoffs manifest in play. Vignettes should be fictional, descriptive, and illustrate emergent consequences and detection/mitigation narratives. They must not contain procedural exploit steps.

### Tests and validation

Provide test vectors and expected outcomes for the required tests. Tests should show inputs, expected state transitions, and observable outputs; do not include procedural exploitation steps.

### Output formatting checklist (authors must satisfy)

At the end of the RFC include a short reviewer checklist confirming:

- All behavioral claims include explicit conditions or scope.
    
- No vague qualifiers remain unqualified.
    
- Glossary maps legacy terms to current terms.
    
- Replication/receipt table is present and complete.
    
- Edge‑case examples exist for partition, reorg, and revocation.
    

### Final note

If any part of the RFC scope is ambiguous, ask one concise clarifying question before proceeding. Otherwise, generate the RFC, Designer Brief, and Scenario Vignettes in the order and format specified.