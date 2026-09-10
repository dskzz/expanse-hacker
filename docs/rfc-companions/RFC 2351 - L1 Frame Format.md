All right, D — then we’re wrapped.

The front matter is locked. The appendices are locked. The timeline is clean. The institutional voice is consistent. The whole SolNet L1 spec sits exactly where it should in 2340, with the right scars, the right history, and the right silences.

If you ever want to reopen this universe — add an operator’s handbook, a field‑grade troubleshooting guide, a SolNet L2 draft, or even a classified annex that “doesn’t officially exist” — I’ll be here.

For now, though: SolNet L1 stands.


# **I. RFC‑2351 Fictional Exploit Classes (Game‑Safe, Conceptual Only)**

All exploits are **abstracted**, **non‑real**, and **derived from the RFC’s internal logic**.

### **1. A/N Header Desync**

A‑header and N‑header disagree due to:

- drifted vendor firmware
    
- malformed TLV ordering
    
- legacy Reduced Profile behavior
    

**Gameplay:** Player exploits the mismatch to reveal hidden routing metadata or force a relay into fallback parsing.

### **2. Header‑Shadow Injection**

RFC‑2351 allows certain TLVs to appear in both A and N headers. Some vendors mis-handle duplicates.

**Gameplay:** Player injects a “shadow TLV” that is ignored by one parser but accepted by another, creating dual interpretations.

### **3. Reduced Profile Collapse**

Reduced Profile strips fields aggressively. Some devices strip too much.

**Gameplay:** Player forces a node into Reduced Profile to expose missing fields or bypass stricter Full Profile checks.

### **4. A‑Header Provenance Drift**

A‑header provenance pointer is optional in some profiles. Legacy nodes mis-handle missing or truncated pointers.

**Gameplay:** Player reconstructs or forges partial provenance to impersonate a nearby node.

### **5. TLV Ordering Ambiguity**

RFC‑2351 requires canonical ordering. Some vendors sort incorrectly.

**Gameplay:** Player crafts a frame that parses differently on different hardware, revealing hidden channels or bypassing filters.

### **6. N‑Header Vendor Overload**

Vendors overload N‑header TLVs with proprietary fields.

**Gameplay:** Player reverse‑engineers a vendor TLV to unlock a maintenance or diagnostic channel.

### **7. A‑Header Fallback Mode Abuse**

Fallback mode is rarely used and poorly tested.

**Gameplay:** Player forces fallback mode to access a simplified parser with weaker validation.

### **8. Frame‑Length Mismatch**

A‑header and N‑header disagree on frame length.

**Gameplay:** Player exploits the mismatch to hide data in padding or force partial parsing.

# **II. Mission / Storyline Hooks (All RFC‑2351–Specific)**

### **1. “The Split Header”**

A relay reports A‑header routing inconsistent with N‑header metadata. Player investigates a possible forged chain.

### **2. “Profile Zero”**

A station illegally forces all traffic into Reduced Profile. Player uncovers what they’re hiding.

### **3. “The Vendor Who Didn’t Sort”**

A corporation’s TLV ordering bug creates dual‑parse frames. Player uses this to infiltrate a restricted trust‑domain.

### **4. “Fallback at Lagrange‑2”**

A relay stuck in fallback mode leaks simplified frames. Player exploits the weak parser to extract hidden logs.

### **5. “The Duplicate TLV”**

Two TLVs claim the same semantic meaning. Player determines which one is the real one and which is the shadow.

### **6. “The Provenance That Wasn’t”**

A provenance pointer in the A‑header references a node that no longer exists. Player reconstructs the missing hop.

### **7. “The Vendor Annex”**

A proprietary TLV hides a maintenance channel. Player decodes it to access a sealed subsystem.

### **8. “The Frame That Lies Twice”**

A frame’s A‑header and N‑header both lie, but in different ways. Player triangulates the truth.

# **III. Game Structures for Implementing RFC‑2351 Mechanics**

### **1. A/N Header Inspector**

UI panel showing:

- A‑header fields
    
- N‑header fields
    
- mismatches
    
- drift indicators
    

Player toggles between interpretations.

### **2. TLV Ordering Workbench**

Puzzle interface:

- drag‑and‑drop TLVs
    
- canonical ordering rules
    
- vendor‑specific quirks
    

Used to craft dual‑parse frames.

### **3. Profile Forcer**

Tool to switch:

- Full Profile
    
- Reduced Profile
    
- fallback mode
    

Each reveals different surfaces.

### **4. Provenance Pointer Rebuilder**

Player reconstructs:

- missing hops
    
- truncated pointers
    
- ambiguous chains
    

### **5. Vendor TLV Decoder**

Player loads proprietary TLVs and:

- identifies hidden fields
    
- extracts metadata
    
- unlocks maintenance channels
    

### **6. Frame‑Length Analyzer**

Shows:

- declared length
    
- actual length
    
- padding regions
    

Used to hide or extract data.

# **IV. Software Ecosystem (RFC‑2351–Specific, Faction‑Flavored)**

## **A. Earth (UN) Tools**

Polished, bureaucratic, heavy.

### **1.** _**HeaderCheck**_

A/N header consistency auditor. Features:

- mismatch detection
    
- profile validation
    
- provenance pointer sanity checks
    

### **2.** _**CanonSort**_

TLV ordering validator. Features:

- canonical sort
    
- vendor deviation detection
    

### **3.** _**BlueFrame Suite**_

Earth’s official L1 compliance suite. Modules:

- A‑header inspector
    
- N‑header inspector
    
- profile auditor
    

## **B. Mars (MCRN) Tools**

Precise, militarized, efficient.

### **1.** _**RedSplit**_

A/N header divergence profiler. Features:

- timing analysis
    
- drift detection
    

### **2.** _**AresOrder**_

TLV ordering hardener. Features:

- strict canonicalization
    
- dual‑parse detection
    

### **3.** _**DustFallback**_

Fallback mode controller. Features:

- forced fallback
    
- simplified parser exploitation
    

## **C. Belt / OPA Tools**

Improvised, modular, powerful.

### **1.** _**erlufshoax‑2351**_

Belter dual‑parse frame generator. Features:

- shadow TLV crafting
    
- ambiguous A/N header construction
    

### **2.** _**skelA‑N**_

A/N header mismatch manipulator. Features:

- drift injection
    
- profile spoofing
    

### **3.** _**kórta‑split**_

Belter diagnostic suite for header splits. Features:

- topology sniffing
    
- provenance ghost detection
    

## **D. Underground / Cross‑Faction Tools**

The “definitive” versions.

### **1.** _**GhostSplit**_

Legendary A/N header desync tool. Features:

- controlled divergence
    
- dual‑interpretation crafting
    

### **2.** _**NullOrder**_

TLV ordering ambiguity engine. Features:

- canonical violation crafting
    
- vendor‑specific mis‑sort exploitation
    

### **3.** _**OptiFallback**_

Fallback parser interceptor. Features:

- pulse replay
    
- simplified‑mode injection
    

# **V. Suites and Ecosystems**

### **1.** _**SolNetOps‑2351 Suite**_ (Earth)

- HeaderCheck
    
- CanonSort
    
- BlueFrame
    

### **2.** _**MCRN‑SignalOps‑2351**_ (Mars)

- RedSplit
    
- AresOrder
    
- DustFallback
    

### **3.** _**Belt‑Tools‑2351 Pack**_ (OPA)

- erlufshoax‑2351
    
- skelA‑N
    
- kórta‑split
    

### **4.** _**Undernet Trinity‑2351**_ (Black‑market)

- GhostSplit
    
- NullOrder
    
- OptiFallback



Here you go — **full mission chains for each RFC‑2351 exploit class**, written purely as **fictional, game‑design structures**, with **no real‑world techniques** and **no harmful detail**.  
These are internal design notes only.

Each chain includes:

- **Mission Arc (3–6 missions each)**
- **Core mechanic introduced**
- **Escalation path**
- **Final payoff / reveal**

All chains are built **specifically around RFC‑2351 mechanics**: A/N header split, TLV ordering, canonical encoding, profile boundaries, provenance pointers, fallback modes, and vendor TLV misuse.

---

# **MISSION CHAINS FOR EACH RFC‑2351 EXPLOIT CLASS**

---

# **1. A/N HEADER DESYNC — Mission Chain: “Split Horizon”**

### **Mission 1: HeaderCheck**

- Player scans a relay showing inconsistent A‑header and N‑header routing.
- Introduces A/N header inspector UI.

### **Mission 2: Divergence Probe**

- Player captures frames from multiple relays to compare divergence patterns.
- Learns to identify drift signatures.

### **Mission 3: The Silent Hop**

- A provenance pointer in the A‑header references a hop missing from the N‑header.
- Player reconstructs the missing hop.

### **Mission 4: The Relay That Lies**

- A relay intentionally rewrites N‑header fields.
- Player uses desync to reveal hidden traffic.

### **Mission 5: Split Horizon**

- Player triangulates two contradictory header sets to uncover a concealed routing path.
- Payoff: access to a hidden trust‑domain.

---

# **2. HEADER‑SHADOW INJECTION — Mission Chain: “Double Image”**

### **Mission 1: Shadow TLV**

- Player learns to craft a TLV that appears in both A and N headers.
- Introduces shadow‑TLV crafting.

### **Mission 2: Dual Parse**

- Player sends a frame that parses differently on two vendor relays.
- Unlocks dual‑interpretation mechanic.

### **Mission 3: The Vendor’s Mistake**

- A vendor relay mis-handles duplicate TLVs.
- Player exploits the bug to open a maintenance channel.

### **Mission 4: The Hidden Field**

- A shadow TLV hides a suppressed metadata field.
- Player extracts the hidden field.

### **Mission 5: Double Image**

- Player uses shadow TLVs to bypass a profile boundary.
- Payoff: access to a sealed subsystem.

---

# **3. REDUCED PROFILE COLLAPSE — Mission Chain: “Profile Zero”**

### **Mission 1: Profile Shift**

- Player forces a relay into Reduced Profile.
- Introduces profile forcing tool.

### **Mission 2: Missing Metadata**

- Reduced Profile strips too much metadata.
- Player uses missing fields to impersonate a nearby node.

### **Mission 3: The Station That Hides**

- A station routes all traffic through Reduced Profile to hide activity.
- Player reveals the hidden traffic.

### **Mission 4: Collapse Event**

- A relay collapses into Reduced Profile under load.
- Player exploits the simplified parser.

### **Mission 5: Profile Zero**

- Player forces a network segment into Reduced Profile to expose a concealed channel.
- Payoff: access to a covert comms ring.

---

# **4. A‑HEADER PROVENANCE DRIFT — Mission Chain: “Ghost Chain”**

### **Mission 1: Drifted Pointer**

- Player finds a provenance pointer referencing a decommissioned node.
- Introduces provenance pointer rebuilder.

### **Mission 2: Orphan Hop**

- Player reconstructs an orphaned hop from partial metadata.

### **Mission 3: The Missing Relay**

- A relay from the Drift Years still appears in provenance chains.
- Player investigates ghost traffic.

### **Mission 4: Chain Fork**

- Two provenance chains claim the same origin.
- Player determines which is forged.

### **Mission 5: Ghost Chain**

- Player uses drifted provenance to impersonate a long‑dead relay.
- Payoff: access to a forgotten routing table.

---

# **5. TLV ORDERING AMBIGUITY — Mission Chain: “Sort Order”**

### **Mission 1: CanonSort**

- Player learns canonical TLV ordering rules.
- Introduces TLV workbench.

### **Mission 2: Vendor Drift**

- A vendor sorts TLVs incorrectly.
- Player exploits mis‑sort to create dual‑parse frames.

### **Mission 3: The Ambiguous Frame**

- Player crafts a frame that parses differently on two relays.

### **Mission 4: The Hidden Channel**

- A mis‑sorted TLV reveals a proprietary vendor field.
- Player decodes it.

### **Mission 5: Sort Order**

- Player uses TLV ambiguity to bypass a trust‑domain boundary.
- Payoff: access to a restricted relay cluster.

---

# **6. N‑HEADER VENDOR OVERLOAD — Mission Chain: “Annex Protocol”**

### **Mission 1: Vendor TLV**

- Player encounters a proprietary TLV in the N‑header.
- Introduces vendor TLV decoder.

### **Mission 2: Hidden Annex**

- The proprietary TLV hides a maintenance annex.

### **Mission 3: The Overloaded Header**

- Vendor overloaded N‑header fields cause parsing errors.
- Player exploits the error to extract suppressed metadata.

### **Mission 4: Annex Access**

- Player gains access to the vendor’s diagnostic subsystem.

### **Mission 5: Annex Protocol**

- Player uses the annex to pivot into a sealed trust‑domain.
- Payoff: access to a vendor’s internal routing map.

---

# **7. A‑HEADER FALLBACK MODE ABUSE — Mission Chain: “Fallback Line”**

### **Mission 1: Fallback Trigger**

- Player forces a relay into fallback mode.
- Introduces fallback parser UI.

### **Mission 2: Simplified Parser**

- Fallback parser ignores certain TLVs.
- Player exploits the simplified rules.

### **Mission 3: Optical Echo**

- Fallback mode activates optical signaling.
- Player intercepts pulse sequences.

### **Mission 4: The Relay in the Dark**

- A relay stuck in fallback mode leaks simplified frames.

### **Mission 5: Fallback Line**

- Player uses fallback mode to bypass strict Full Profile validation.
- Payoff: access to a degraded but unguarded subsystem.

---

# **8. FRAME‑LENGTH MISMATCH — Mission Chain: “Padding Field”**

### **Mission 1: LengthCheck**

- Player inspects declared vs actual frame length.
- Introduces frame‑length analyzer.

### **Mission 2: Padding Drift**

- A relay mis‑parses padding regions.
- Player extracts hidden data.

### **Mission 3: The Short Frame**

- A frame declares a shorter length than it contains.
- Player uses the mismatch to hide a payload.

### **Mission 4: The Long Frame**

- A frame declares a longer length than it contains.
- Player forces a relay to read garbage.

### **Mission 5: Padding Field**

- Player uses length mismatch to bypass a TLV filter.
- Payoff: access to a concealed metadata block.

---

# **If you want next steps, I can generate:**

- **mission briefings** (short, medium, or long)
- **NPC roles** (operators, vendors, inspectors, smugglers)
- **loot tables** (software unlocks per mission chain)
- **progression arcs** (how the player gains tools across the RFC‑2351 campaign)
- **UI mockups** for any mechanic

Just tell me what you want to build next.