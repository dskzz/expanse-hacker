
# **SolNet Incident Timeline (Running Master List)**

_(Internal design document — expandable as new RFCs are created)_

## **Pre‑SolNet Failures (Major Canonical Events)**

### **~2320 — Vesta Blockade Failure**

- Catastrophic military miscommunication.
    
- Conflicting orders, incompatible comms stacks.
    
- Multiple deaths due to routing drift and metadata exposure.
    
- Cited by SSWG, MIAP, and SPERB.
    

### **~2325–2328 — Pallas Exposure Event**

- Civilian governance breakdown due to comms desync.
    
- Contradictory directives from Earth/Ceres.
    
- Metadata retention allowed reconstruction of civilian movement patterns.
    
- First major privacy scandal.
    
- SPERB’s precursor committees formed.
    

### **~2330 — Anderson Station Incident**

- Fatal escalation caused by delayed, misrouted, and contradictory transmissions.
    
- Provenance pointer corruption cited as contributing factor.
    
- SSWG and SPERB both treat this as a foundational precedent.
    

## **Drift Years (2330–2336)**

- Relay drift, vendor divergence, inconsistent TLV ordering.
    
- Legacy nodes accumulate unpatched behavior.
    
- Multiple unrecorded minor failures.
    
- Basis for early SolNet L1 drafts.
    

## **SolNet L1 Development Era (2336–2340)**

_(These are the incidents referenced in RFC‑2351 and related documents.)_

### **2336 — Early Interoperability Failures**

- VARINT mis‑encoding.
    
- TLV ordering inconsistencies.
    
- Relay non‑interference violations.
    

### **2337 — Vendor Profile Negotiation Collapse**

- Vendors attempt to introduce “flexible profiles.”
    
- Leads to routing ambiguity and metadata leakage.
    

### **2338 — Testbed Authentication Failures**

- CompactAuthTag introduced after repeated failures.
    
- ProvenancePointer semantics clarified.
    

### **2338 — Reduced Profile Over‑Stripping Event**

- Devices strip essential metadata.
    
- Causes routing loops and impersonation incidents.
    

### **2339 — Metadata Leak of ’39**

- Vendor TLV overreach exposes user movement patterns.
    
- SPERB cites this as a defining exposure event.
    
- Leads to strict metadata minimization doctrine.
    

### **2339 — Relay Rewriting Scandal**

- Several relays caught rewriting TLVs.
    
- SSWG issues strict MUST NOT language.
    

### **2339 — Dual‑Parse TLV Incident**

- Vendor mis‑sorts TLVs, creating dual interpretations.
    
- Basis for TLV canonicalization rules.
    

## **Post‑Publication Incidents (2340–2350)**

_(These are the “little ones” implied by the RFCs and future‑proofed for expansion.)_

### **2341 — Fallback Optical Misfire**

- Relay stuck in fallback mode leaks simplified frames.
    
- SPERB cites this as an exposure risk.
    

### **2343 — Provenance Ghost Chain Event**

- Legacy node reappears in provenance chains.
    
- Causes routing confusion.
    

### **2345 — Vendor Annex Breach**

- Proprietary TLV hides a maintenance channel.
    
- Operators exploit it to bypass trust‑domain boundaries.
    

### **2346 — Reduced Profile Collapse**

- Station forces all traffic into Reduced Profile to hide activity.
    
- SPERB issues corrective directive.
    

### **2347 — Frame‑Length Mismatch Incident**

- Relay mis‑parses padding regions.
    
- Leads to partial metadata exposure.
    

### **2349 — A/N Header Divergence Spike**

- Multiple relays show inconsistent A/N header parsing.
    
- SSWG issues emergency audit.
    

## **Future Expansion Slots (for upcoming RFCs)**

_(These are placeholders you will fill as we write more RFCs.)_

### **23XX — [Physical Layer Failure]**

For RFC‑2303 / 2304 / 2305.

### **23XX — [Identity Resolution Exposure]**

For RFC‑2361.

### **23XX — [Trust‑Domain Collapse]**

For RFC‑2362.

### **23XX — [Directory Routing Failure]**

For RFC‑2363.

### **23XX — [Ephemeris Hint Block Misuse]**

For RFC‑2364.

### **23XX — [DTN Routing Policy Incident]**

For RFC‑2365.

### **23XX — [Ship‑as‑Router Catastrophe]**

For RFC‑2366.

### **23XX — [Revocation & Emergency Unbinding Failure]**

For RFC‑2368.

### **23XX — [Namespace Exposure Event]**

For RFC‑2390–2396.