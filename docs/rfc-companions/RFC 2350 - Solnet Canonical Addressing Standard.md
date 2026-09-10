# Designer Brief — Embedded operational realities and exploit vectors

This brief lists permissive design choices and operational realities intentionally present in RFC‑2350. Each item explains the conceptual mechanism and how it could be used as a gameplay or narrative element. The RFC itself does not label these as vulnerabilities; the brief collects them for design use.

## 1 Optional ProvenancePointer reliance

**Mechanic:** L1‑L may include an optional ProvenancePointer that points to authoritative LedgerAnchor or NetworkCert records. Indexers and relays may use these pointers to fetch verification data. **Conceptual exploit vector:** An attacker can poison or delay indexer caches, causing clients to rely on stale or malicious indexer responses when they do not fetch the authoritative LedgerAnchor. Gameplay use: players discover mismatched ProvenancePointer targets and must fetch authoritative records to prove identity. **Design note:** Use indexer poisoning as a narrative puzzle; require players to obtain LedgerAnchor proofs to resolve disputes.

## 2 ProvisionalReceipt semantics and trust windows

**Mechanic:** Relays may issue ProvisionalReceipts when accepting frames but deferring forwarding. ProvisionalReceipts are advisory until a ForwardingReceipt is observed. **Conceptual exploit vector:** Actors can flood relays with frames that generate ProvisionalReceipts, creating ambiguous acceptance states and delaying confirmation. Gameplay use: players must trace ForwardingReceipts and reconcile provisional states to determine whether a message was actually propagated. **Design note:** Provisional receipts create time windows where intent exists but confirmation does not.

## 3 Optional CoarseEphemerisHint exposure

**Mechanic:** CoarseEphemerisHint is optional and domain‑policy controlled. Some devices suppress it for privacy. **Conceptual exploit vector:** Domains that expose coarse ephemeris allow correlation attacks across observations; conversely, suppressed hints force inference from indirect signals. Gameplay use: players correlate sparse ephemeris hints and L1 observations to locate a target node. **Design note:** Balance privacy and discoverability in scenarios.

## 4 TrustTag categorical admission decisions

**Mechanic:** Admission decisions rely on categorical TrustTag values in L1‑L. TrustTag is asserted by the sender and interpreted by relays. **Conceptual exploit vector:** If TrustTag assertions are misissued or forged, admission policies can be bypassed. Gameplay use: players obtain or forge TrustTag assertions to gain temporary admission to restricted relays, then must avoid detection by audit trails. **Design note:** Ensure audit receipts can later reveal forged assertions.

## 5 Light‑client omission of provenance and indexer reliance

**Mechanic:** Light clients may omit ProvenancePointer and rely on indexers or relays for verification. **Conceptual exploit vector:** Indexer compromise or relay collusion can mislead light clients. Gameplay use: players must escalate from light‑client behavior to full verification to expose deception. **Design note:** Use light‑client assumptions to create escalation puzzles.

## 6 Cached DRE responses and stale discovery

**Mechanic:** DREs and indexers cache `//info` entries; caches can be stale. **Conceptual exploit vector:** Players can exploit stale DRE caches to present outdated reachability or authority information, causing misrouting or confusion. Gameplay use: players detect stale caches via freshness tags and reconstruct timelines. **Design note:** Freshness metadata is the key clue.

## 7 CompactAuthTag and local integrity assumptions

**Mechanic:** L1‑S may include a CompactAuthTag for lightweight integrity checks; full verification is deferred to higher layers. **Conceptual exploit vector:** Local integrity checks can be bypassed if higher‑layer verification is not enforced. Gameplay use: players must find where local integrity checks are trusted without higher verification and exploit that gap to inject or alter local service frames. **Design note:** Provide defenders with audit trails that show higher‑layer verification failures.

## 8 Provisional scheduling and reservation manipulation

**Mechanic:** Relays accept reservations and issue ReservationReceipts; scheduling can be deferred or reallocated. **Conceptual exploit vector:** Manipulating reservation queues or forging ReservationReceipts can deny service or create false transmission guarantees. Gameplay use: players manipulate reservation systems to create time‑sensitive windows for actions. **Design note:** Ensure reservation logs and AuditEvents can be used to trace manipulation.

## Presentation guidance for gameplay use (safe)

- Present these mechanics as investigative puzzles requiring cross‑correlation of receipts, DRE records, and LedgerAnchors.
    
- Avoid providing step‑by‑step exploit instructions; instead, surface ambiguous evidence and require players to gather authoritative records.
    
- Use freshness, provenance, and multi‑source verification as the primary tools players use to resolve ambiguity.
    

Which companion document should I draft next to support prototyping and gameplay: the formal L1 header encodings (RFC‑2360) or the Relay Admission & Scheduling API (RFC‑2370)?


# **APPENDIX 2350‑INTERNAL — GAME DESIGN MATERIAL**

This appendix is for **internal game development only**. It defines:

1. **Fictional exploit classes** derived from RFC‑2350
    
2. **Mission and storyline hooks**
    
3. **In‑game software/tools** the player uses
    
4. **Game systems** that implement RFC‑2350 mechanics
    

Everything here is **safe**, **non‑real‑world**, and **purely fictional**.

# **1. FICTIONAL, GAME‑SAFE EXPLOIT CLASSES**

These are **conceptual vulnerabilities** created by _misuse_ or _misinterpretation_ of RFC‑2350 rules — never real techniques.

## **1.1 TLV Ordering Drift**

**Cause:** Non‑compliant nodes reorder TLVs “for readability.” **Effect:** Player can detect drift and impersonate a node by mimicking its incorrect ordering. **Gameplay:**

- Scan a node
    
- Identify its TLV ordering signature
    
- Craft a spoofed AddressRecord with matching quirks
    
- Gain temporary access to its local namespace
    

## **1.2 ProvenancePointer Blind Spot**

**Cause:** Some nodes ignore ProvenancePointer entirely. **Effect:** Player can inject records with ambiguous provenance to confuse routing. **Gameplay:**

- Insert a “floating” provenance hash
    
- Cause misrouting or delayed routing
    
- Use the confusion window to slip a payload (fictional) through
    

## **1.3 Vendor TLV Leakage**

**Cause:** Vendor TLVs appear on public networks. **Effect:** Player can reverse‑engineer vendor behavior. **Gameplay:**

- Capture vendor TLVs
    
- Decode patterns
    
- Unlock vendor‑specific shortcuts or backdoors (fictional)
    

## **1.4 Experimental TLV Persistence**

**Cause:** Testbed TLVs leak into production. **Effect:** Player can exploit forgotten experimental behavior. **Gameplay:**

- Identify experimental TLVs
    
- Trigger old fallback logic
    
- Gain temporary elevated access or bypass checks
    

## **1.5 Advisory‑Field Misinterpretation**

**Cause:** Nodes treat advisory hints as authoritative. **Effect:** Player can manipulate routing or privacy behavior. **Gameplay:**

- Inject a PrivacyHint that forces a node into “low‑visibility mode”
    
- Inject a RoutingHint that forces a node into “slow path”
    
- Create openings for stealth operations
    

## **1.6 TLV Value Overflow (Fictional)**

**Cause:** Nodes mishandle long TLV values. **Effect:** Player can cause a node to drop into safe‑mode. **Gameplay:**

- Craft a borderline‑length TLV
    
- Force the node into degraded mode
    
- Slip past while it resets
    

## **1.7 Multi‑Provenance Ambiguity**

**Cause:** Some nodes incorrectly allow multiple ProvenancePointers. **Effect:** Player can create “identity fog.” **Gameplay:**

- Insert two provenance hashes
    
- Node becomes uncertain which trust domain applies
    
- Player bypasses policy checks
    

# **2. MISSION & STORYLINE HOOKS**

These are **fictional missions** built around the above exploit classes.

## **2.1 “The Drifting Relay”**

A Belter relay is reordering TLVs incorrectly. Player must:

- Scan the relay
    
- Identify its TLV drift signature
    
- Craft a spoofed AddressRecord
    
- Slip into its maintenance channel
    
- Recover a lost cargo manifest
    

## **2.2 “Ghost Provenance”**

A Martian node is ignoring provenance entirely. Player must:

- Inject ambiguous provenance
    
- Cause routing confusion
    
- Slip a message through a restricted channel
    
- Avoid triggering the node’s fallback logic
    

## **2.3 “Vendor Mode 7”**

A vendor TLV leaked onto a public network. Player must:

- Capture the TLV
    
- Reverse‑engineer its meaning
    
- Unlock a vendor diagnostic mode
    
- Use it to access a sealed subsystem
    

## **2.4 “The Forgotten Experiment”**

An experimental TLV from a testbed is still active. Player must:

- Identify the experimental TLV
    
- Trigger old behavior
    
- Gain access to a deprecated routing table
    
- Extract historical data
    

## **2.5 “Privacy Collapse”**

A node treats PrivacyHint as authoritative. Player must:

- Inject a crafted PrivacyHint
    
- Force the node into low‑visibility mode
    
- Slip past its monitoring system
    
- Retrieve a hidden message
    

## **2.6 “Safe‑Mode Breach”**

A node mishandles long TLV values. Player must:

- Craft a borderline TLV
    
- Force the node into safe‑mode
    
- Access its maintenance interface
    
- Repair or sabotage (fictional) its routing
    

## **2.7 “Identity Fog”**

A node accepts multiple ProvenancePointers. Player must:

- Insert two provenance hashes
    
- Confuse its trust logic
    
- Gain temporary access to a restricted namespace
    

# **3. IN‑GAME SOFTWARE / TOOLS**

These are **fictional operator‑grade tools** the player uses.

## **3.1** `solscan`

Scans a node and displays:

- TLV ordering
    
- BareToken structure
    
- ProvenancePointer position
    
- Compliance level
    
- Drift signatures
    

## **3.2** `solcraft`

Crafts AddressRecords with:

- Custom TLVs
    
- Custom ordering
    
- Custom provenance
    
- Vendor/experimental fields (fictional)
    

## **3.3** `soltrace`

Traces routing behavior:

- Advisory vs authoritative interpretation
    
- Fallback logic
    
- Degraded‑mode transitions
    

## **3.4** `solforge`

A fictional “AddressRecord assembler”:

- Build records from templates
    
- Inject drift
    
- Insert experimental TLVs
    
- Simulate vendor behavior
    

## **3.5** `solsim`

Simulates node behavior:

- How a node interprets TLVs
    
- How it handles malformed input
    
- How it behaves under load
    
- How it handles provenance ambiguity
    

## **3.6** `solreplay`

Replays captured AddressRecords to:

- Test drift
    
- Test fallback
    
- Test provenance confusion
    
- Test advisory misinterpretation
    

# **4. GAME SYSTEMS THAT IMPLEMENT RFC‑2350**

These are the **core gameplay systems** that make the RFC meaningful.

## **4.1 AddressRecord Parser**

- Player sees the actual structure
    
- Can toggle between “canonical view” and “raw wire view”
    
- Errors and drift are visible
    

## **4.2 TLV Manipulation Engine**

- Drag‑and‑drop TLVs
    
- Reorder keys
    
- Insert vendor/experimental TLVs
    
- Validate against RFC rules
    

## **4.3 Provenance Engine**

- Player can craft provenance hashes
    
- Nodes react differently based on trust domain
    
- Ambiguity creates stealth opportunities
    

## **4.4 Compliance Scanner**

- Every node has a compliance score
    
- Lower compliance = more exploitable
    
- Higher compliance = more predictable
    

## **4.5 Drift Signature System**

- Every non‑compliant node has a unique “signature”
    
- Player learns to recognize patterns
    
- Missions revolve around exploiting or correcting drift
    

## **4.6 Advisory Field Influence**

- Advisory fields subtly affect routing
    
- Some nodes misuse them
    
- Player can manipulate them for stealth or misdirection
    

## **4.7 Degraded‑Mode Simulation**

- Nodes enter degraded mode under stress
    
- Player can induce or exploit this
    
- Degraded mode exposes hidden interfaces


# **1. SUITE‑LEVEL BRANDING OPTIONS**

You said “L1SolSuite” — good direction. Here are refined options:

### **1.1 Clean, technical suite names**

- **SolNet L1 Operator Suite**
    
- **SolNet L1 Analysis Stack**
    
- **SolNet L1 Toolchain**
    
- **SolNet L1 Diagnostics Suite**
    
- **SolNet L1 Field Kit**
    

### **1.2 More mystifying / underground suite names**

- **Blacklight L1 Suite**
    
- **GhostLayer Toolkit**
    
- **NullSpan Operator Pack**
    
- **DeepChain Utilities**
    
- **The Lattice Kit**
    
- **Spectral L1 Tools**
    
- **The Parallax Suite**
    

### **1.3 Hybrid (clean + mystique)**

- **SolNet Parallax Tools**
    
- **L1 GhostLayer Operator Suite**
    
- **SolNet DeepChain Kit**
    

Pick one suite name and all tools can nest under it.

# **2. RENAMING THE TOOLS (WITH OPTIONS)**

Below are replacements for your earlier tool names. Each tool gets:

- **A clean name** (for UI)
    
- **A mystifying codename** (for flavor)
    
- **A short description**
    

You can mix and match.

## **2.1 Node Scanner (formerly solscan)**

### Clean names:

- **L1 Inspector**
    
- **AddressRecord Scanner**
    
- **SolNet Analyzer**
    

### Mystifying names:

- **SpecterScan**
    
- **GhostTrace**
    
- **Blacklight Inspect**
    
- **NullScope**
    

### Purpose:

Scans nodes, extracts TLVs, ordering, provenance, drift signatures.

## **2.2 Record Crafter (formerly solcraft)**

### Clean names:

- **AddressRecord Builder**
    
- **L1 Record Forge**
    
- **SolNet Constructor**
    

### Mystifying names:

- **ChainWeaver**
    
- **GlyphForge**
    
- **Parallax Assembler**
    
- **DeepChain Writer**
    

### Purpose:

Crafts AddressRecords with custom TLVs, ordering, provenance.

## **2.3 Routing Behavior Tracer (formerly soltrace)**

### Clean names:

- **L1 RouteTracer**
    
- **SolNet Path Inspector**
    
- **Routing Behavior Monitor**
    

### Mystifying names:

- **EchoPath**
    
- **GhostRoute**
    
- **Spectral Trace**
    
- **NullVector**
    

### Purpose:

Shows how nodes interpret advisory fields, fallback logic, degraded mode.

## **2.4 Record Simulator (formerly solsim)**

### Clean names:

- **L1 Behavior Simulator**
    
- **SolNet Node Emulator**
    
- **Record Interpretation Engine**
    

### Mystifying names:

- **PhantomSim**
    
- **DeepSim**
    
- **LatticeSim**
    
- **ShadowNode**
    

### Purpose:

Simulates how a node would parse and react to a crafted AddressRecord.

## **2.5 Record Replayer (formerly solreplay)**

### Clean names:

- **L1 Replay Engine**
    
- **SolNet Record Replayer**
    
- **AddressRecord Playback Tool**
    

### Mystifying names:

- **EchoReel**
    
- **GhostLoop**
    
- **NullReplay**
    
- **SpecterLoop**
    

### Purpose:

Replays captured AddressRecords to test drift, fallback, provenance confusion.

# **3. OPTIONAL: EXPLOIT‑ORIENTED TOOL NAMES**

These are **fictional**, **safe**, and **purely thematic** — they don’t imply real hacking, just in‑universe manipulation of SolNet metadata.

Use these for tools that specifically interact with drift, provenance ambiguity, or TLV misuse.

### **3.1 Drift‑focused tools**

- **DriftSeeker**
    
- **DriftLens**
    
- **PhaseShift**
    
- **ChainSkew**
    

### **3.2 Provenance‑focused tools**

- **OriginMask**
    
- **HashGhost**
    
- **SourceFog**
    
- **TwinOrigin**
    

### **3.3 TLV‑focused tools**

- **KeyBreaker** (fictional TLV ordering analyzer)
    
- **ValueBend**
    
- **TLV Mirage**
    
- **ChainDistort**
    

### **3.4 Advisory‑field manipulation**

- **HintCaster**
    
- **WhisperRoute**
    
- **ShadowHint**
    
- **QuietPath**
    

### **3.5 Degraded‑mode manipulation**

- **FailSoft**
    
- **LowSignal**
    
- **GreyMode**
    
- **CollapseTrigger**
    

# **4. PUTTING IT ALL TOGETHER (EXAMPLE SUITE)**

If you want a cohesive suite, here’s a sample:

### **Suite Name:**

**SolNet Parallax Tools**

### **Tools:**

- **Parallax Inspect** (scanner)
    
- **Parallax Forge** (record builder)
    
- **Parallax Trace** (routing behavior)
    
- **Parallax Sim** (node emulator)
    
- **Parallax Loop** (record replay)
    

### **Exploit‑adjacent utilities:**

- **OriginMask** (provenance ambiguity)
    
- **DriftSeeker** (ordering drift detection)
    
- **TLV Mirage** (TLV manipulation)
    
- **QuietPath** (advisory influence)
    

This gives you a **coherent brand**, **snazzy names**, and **clear gameplay roles**.

# **If you want next:**

I can generate:

- **A full suite naming matrix**
    
- **Logos / UI flavor text for each tool**
    
- **In‑game descriptions for tooltips**
    
- **Unlock progression / skill tree integration**
    
- **Faction‑specific variants of each tool**



- **Appendix 2350‑Internal‑B: Node Types & Behaviors**
    
- **Appendix 2350‑Internal‑C: Faction‑Specific Exploit Patterns**
    
- **Appendix 2350‑Internal‑D: UI/UX mockups for solscan/solcraft**
    
- **Appendix 2350‑Internal‑E: Mission progression structure**
    
- **Appendix 2350‑Internal‑F: Player skill tree based on RFC mastery**


# **1. STRUCTURAL MASTERY**

Focus: Understanding and manipulating the **AddressRecord grammar**, BareTokens, ordering rules, and structural correctness.

### **Tier 1 — Basic Parsing**

- Player can read AddressRecords in “canonical view.”
    
- UI highlights structural elements (BareTokens, TLVs, ProvenancePointer).
    
- Unlocks: basic scanner tool.
    

### **Tier 2 — Structural Fault Detection**

- Player can identify malformed structures.
    
- UI flags misplaced TLVs, missing ProvenancePointer, invalid tokens.
    
- Unlocks: missions involving broken nodes.
    

### **Tier 3 — Structural Crafting**

- Player can build AddressRecords from scratch.
    
- Gains access to templates and auto‑validation.
    
- Unlocks: record‑crafting tool.
    

### **Tier 4 — Structural Subversion**

- Player can intentionally craft borderline‑valid structures.
    
- Enables fictional exploits like “safe‑mode forcing” or “fallback triggering.”
    
- Unlocks: advanced crafting modes.
    

# **2. TLV MANIPULATION**

Focus: Understanding TLV ordering, canonical keys, vendor keys, experimental keys, and drift signatures.

### **Tier 1 — TLV Literacy**

- Player learns canonical TLV keys and meanings.
    
- UI shows TLV ordering and highlights violations.
    

### **Tier 2 — TLV Injection**

- Player can add or remove TLVs.
    
- Can insert vendor or experimental TLVs (fictional effects only).
    

### **Tier 3 — Ordering Drift Analysis**

- Player can detect TLV ordering drift in non‑compliant nodes.
    
- Unlocks missions involving drift exploitation.
    

### **Tier 4 — TLV Distortion**

- Player can craft TLVs that trigger fictional fallback logic.
    
- Enables exploits like “drift mimicry” or “TLV mirage.”
    

# **3. PROVENANCE & IDENTITY**

Focus: ProvenancePointer behavior, trust domains, ambiguity, and identity fog.

### **Tier 1 — Provenance Awareness**

- Player can view provenance hashes and trust domains.
    
- UI shows whether provenance is missing, stale, or unverifiable.
    

### **Tier 2 — Provenance Crafting**

- Player can generate fictional provenance hashes.
    
- Can attach or remove provenance pointers.
    

### **Tier 3 — Ambiguity Injection**

- Player can create ambiguous provenance (e.g., dual pointers).
    
- Enables stealth missions where nodes misinterpret trust.
    

### **Tier 4 — Identity Fog Engineering**

- Player can fully manipulate provenance to confuse nodes.
    
- Unlocks missions involving bypassing trust boundaries.
    

# **4. OPERATIONAL BEHAVIOR & DRIFT**

Focus: How nodes behave under load, degraded mode, fallback logic, and compliance levels.

### **Tier 1 — Compliance Detection**

- Player can see a node’s compliance score.
    
- UI shows likely weaknesses.
    

### **Tier 2 — Degraded‑Mode Triggering**

- Player can induce fictional degraded mode via crafted records.
    
- Nodes expose maintenance interfaces or reduced checks.
    

### **Tier 3 — Fallback Logic Manipulation**

- Player can craft records that push nodes into alternate behavior paths.
    
- Enables missions involving routing misdirection.
    

### **Tier 4 — Drift Engineering**

- Player can intentionally create drift signatures.
    
- Unlocks advanced stealth and infiltration missions.
    

# **5. CROSS‑TREE ULTIMATE SKILLS**

These unlock only when multiple pillars are mastered.

### **5.1 ChainGhost**

- Player can craft AddressRecords that appear valid to some nodes and invalid to others.
    
- Used for stealth routing missions.
    

### **5.2 DriftMask**

- Player can mimic any node’s drift signature.
    
- Enables deep infiltration missions.
    

### **5.3 Provenance Eclipse**

- Player can temporarily suppress provenance interpretation in targeted nodes.
    
- Used for bypassing trust‑domain boundaries.
    

### **5.4 TLV Parallax**

- Player can create TLVs that behave differently under different fallback logic paths.
    
- Enables high‑level puzzle missions.
    

# **6. PROGRESSION & UNLOCK FLOW**

- Early game: structural literacy, basic scanning, simple TLV manipulation.
    
- Mid game: drift detection, provenance crafting, degraded‑mode manipulation.
    
- Late game: identity fog, drift mimicry, fallback exploitation.
    
- Endgame: parallax‑style exploits, multi‑layer manipulation, stealth routing.
    

# **7. HOW THE SKILL TREE INTERACTS WITH MISSIONS**

Each mission type maps to specific skills:

- **Drift missions** → TLV Manipulation + Operational Behavior
    
- **Provenance missions** → Provenance & Identity
    
- **Routing misdirection missions** → Advisory manipulation + fallback logic
    
- **Node infiltration missions** → Structural mastery + degraded‑mode triggering
    
- **Vendor/experimental missions** → TLV literacy + injection
    

The tree ensures players **learn the RFC by playing**, not by reading.

# **1. STRUCTURAL MASTERY**

Focus: Understanding and manipulating the **AddressRecord grammar**, BareTokens, ordering rules, and structural correctness.

### **Tier 1 — Basic Parsing**

- Player can read AddressRecords in “canonical view.”
    
- UI highlights structural elements (BareTokens, TLVs, ProvenancePointer).
    
- Unlocks: basic scanner tool.
    

### **Tier 2 — Structural Fault Detection**

- Player can identify malformed structures.
    
- UI flags misplaced TLVs, missing ProvenancePointer, invalid tokens.
    
- Unlocks: missions involving broken nodes.
    

### **Tier 3 — Structural Crafting**

- Player can build AddressRecords from scratch.
    
- Gains access to templates and auto‑validation.
    
- Unlocks: record‑crafting tool.
    

### **Tier 4 — Structural Subversion**

- Player can intentionally craft borderline‑valid structures.
    
- Enables fictional exploits like “safe‑mode forcing” or “fallback triggering.”
    
- Unlocks: advanced crafting modes.
    

# **2. TLV MANIPULATION**

Focus: Understanding TLV ordering, canonical keys, vendor keys, experimental keys, and drift signatures.

### **Tier 1 — TLV Literacy**

- Player learns canonical TLV keys and meanings.
    
- UI shows TLV ordering and highlights violations.
    

### **Tier 2 — TLV Injection**

- Player can add or remove TLVs.
    
- Can insert vendor or experimental TLVs (fictional effects only).
    

### **Tier 3 — Ordering Drift Analysis**

- Player can detect TLV ordering drift in non‑compliant nodes.
    
- Unlocks missions involving drift exploitation.
    

### **Tier 4 — TLV Distortion**

- Player can craft TLVs that trigger fictional fallback logic.
    
- Enables exploits like “drift mimicry” or “TLV mirage.”
    

# **3. PROVENANCE & IDENTITY**

Focus: ProvenancePointer behavior, trust domains, ambiguity, and identity fog.

### **Tier 1 — Provenance Awareness**

- Player can view provenance hashes and trust domains.
    
- UI shows whether provenance is missing, stale, or unverifiable.
    

### **Tier 2 — Provenance Crafting**

- Player can generate fictional provenance hashes.
    
- Can attach or remove provenance pointers.
    

### **Tier 3 — Ambiguity Injection**

- Player can create ambiguous provenance (e.g., dual pointers).
    
- Enables stealth missions where nodes misinterpret trust.
    

### **Tier 4 — Identity Fog Engineering**

- Player can fully manipulate provenance to confuse nodes.
    
- Unlocks missions involving bypassing trust boundaries.
    

# **4. OPERATIONAL BEHAVIOR & DRIFT**

Focus: How nodes behave under load, degraded mode, fallback logic, and compliance levels.

### **Tier 1 — Compliance Detection**

- Player can see a node’s compliance score.
    
- UI shows likely weaknesses.
    

### **Tier 2 — Degraded‑Mode Triggering**

- Player can induce fictional degraded mode via crafted records.
    
- Nodes expose maintenance interfaces or reduced checks.
    

### **Tier 3 — Fallback Logic Manipulation**

- Player can craft records that push nodes into alternate behavior paths.
    
- Enables missions involving routing misdirection.
    

### **Tier 4 — Drift Engineering**

- Player can intentionally create drift signatures.
    
- Unlocks advanced stealth and infiltration missions.
    

# **5. CROSS‑TREE ULTIMATE SKILLS**

These unlock only when multiple pillars are mastered.

### **5.1 ChainGhost**

- Player can craft AddressRecords that appear valid to some nodes and invalid to others.
    
- Used for stealth routing missions.
    

### **5.2 DriftMask**

- Player can mimic any node’s drift signature.
    
- Enables deep infiltration missions.
    

### **5.3 Provenance Eclipse**

- Player can temporarily suppress provenance interpretation in targeted nodes.
    
- Used for bypassing trust‑domain boundaries.
    

### **5.4 TLV Parallax**

- Player can create TLVs that behave differently under different fallback logic paths.
    
- Enables high‑level puzzle missions.
    

# **6. PROGRESSION & UNLOCK FLOW**

- Early game: structural literacy, basic scanning, simple TLV manipulation.
    
- Mid game: drift detection, provenance crafting, degraded‑mode manipulation.
    
- Late game: identity fog, drift mimicry, fallback exploitation.
    
- Endgame: parallax‑style exploits, multi‑layer manipulation, stealth routing.
    

# **7. HOW THE SKILL TREE INTERACTS WITH MISSIONS**

Each mission type maps to specific skills:

- **Drift missions** → TLV Manipulation + Operational Behavior
    
- **Provenance missions** → Provenance & Identity
    
- **Routing misdirection missions** → Advisory manipulation + fallback logic
    
- **Node infiltration missions** → Structural mastery + degraded‑mode triggering
    
- **Vendor/experimental missions** → TLV literacy + injection
    

The tree ensures players **learn the RFC by playing**, not by reading.