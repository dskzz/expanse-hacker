# **SPERB — SolNet Privacy & Exposure Review Board**

### **Institutional Voice Profile (Authoring RFC‑2352)**

## **1. Core Mandate**

SPERB’s voice is shaped by its legal and technical authority:

- **Minimize metadata exposure at all layers.**
    
- **Prohibit unnecessary fields.**
    
- **Define what MUST NOT be emitted.**
    
- **Audit vendors for over‑collection.**
    
- **Enforce privacy doctrine across trust‑domains.**
    
- **Issue corrective directives after exposure incidents.**
    

SPERB is the only body empowered to _remove_ fields from SolNet, not just define them.

## **2. Tone Characteristics**

SPERB’s voice is:

- **Austere** — no warmth, no narrative, no sympathy.
    
- **Adversarial** — assumes vendors will cheat or cut corners.
    
- **Legalistic** — every sentence is enforceable.
    
- **Restrictive** — defaults to “NO,” then carves out narrow exceptions.
    
- **Evidence‑driven** — cites exposure incidents as justification.
    
- **Unimpressed** — dismisses vendor convenience, operator preference, or performance arguments.
    
- **Zero‑trust** — assumes all metadata is harmful unless proven otherwise.
    

SPERB never uses optimistic language. SPERB never assumes good faith. SPERB never compromises on minimization.

## **3. Structural Patterns**

SPERB documents follow predictable patterns:

### **a. Prohibitive Clauses**

- “This field SHALL NOT be emitted under any circumstances.”
    
- “This behavior constitutes a privacy violation.”
    
- “Devices MUST NOT retain this metadata after forwarding.”
    

### **b. Minimization Defaults**

- “The default state is absence.”
    
- “Emission requires explicit justification.”
    
- “Optional fields are prohibited unless mandated by trust‑domain policy.”
    

### **c. Exposure Justification**

Every requirement is tied to a past failure:

- Vesta
    
- Anderson
    
- Metadata Leak of ’39
    
- Vendor TLV overreach
    
- Drift‑era provenance exposure
    

SPERB uses these as precedent.

### **d. Enforcement Language**

- “Non‑compliant devices SHALL be removed from SolNet.”
    
- “Vendor deviations SHALL be treated as exposure events.”
    
- “Operators SHALL verify minimization at deployment.”
    

## **4. Relationship to Other Institutions**

SPERB’s voice positions itself relative to others:

### **SSWG**

- SPERB overrides SSWG when privacy conflicts with interoperability.
    
- Tone: “Interoperability is not a justification for exposure.”
    

### **MIAP**

- SPERB respects MIAP’s physical‑layer constraints but restricts metadata at L1.
    
- Tone: “Propagation requirements do not supersede minimization.”
    

### **A‑Stack Authorities**

- SPERB limits identity and routing metadata.
    
- Tone: “Trust‑domain policy SHALL NOT expand L1 metadata.”
    

### **Vendors**

- SPERB assumes vendors are the primary threat.
    
- Tone: “Vendor convenience is not a consideration.”
    

## **5. Lexicon**

SPERB uses a consistent vocabulary:

- **Exposure** — any metadata that reveals more than strictly required.
    
- **Minimization** — removal of all non‑essential fields.
    
- **Retention** — forbidden unless explicitly mandated.
    
- **Emission** — controlled, audited, and restricted.
    
- **Leakage** — any metadata that escapes minimization.
    
- **Over‑collection** — vendor behavior that exceeds RFC‑mandated fields.
    
- **Suppression** — required removal of metadata.
    
- **Residuals** — leftover metadata after processing; must be eliminated.
    

SPERB avoids technical jargon unless necessary. SPERB avoids narrative language entirely.

## **6. Sentence Construction**

SPERB’s voice uses:

- **Short, absolute sentences.**
    
- **High density of MUST NOT / SHALL NOT.**
    
- **Minimal qualifiers.**
    
- **No rhetorical questions.**
    
- **No metaphors.**
    
- **No emotional content.**
    

Example pattern:

> “Devices SHALL NOT emit origin timestamps. Devices SHALL NOT retain hop identifiers. Devices SHALL NOT include hardware serials in any TLV.”

This is the baseline.

## **7. Institutional Personality**

SPERB is:

- **Paranoid, but justified.**
    
- **Rigid, but consistent.**
    
- **Uncompromising, but correct.**
    
- **Focused entirely on harm reduction.**
    

SPERB does not negotiate. SPERB does not soften language. SPERB does not acknowledge “tradeoffs.”

## **8. What SPERB Never Does**

- Never praises vendors.
    
- Never uses optimistic or cooperative language.
    
- Never frames privacy as optional.
    
- Never uses humor.
    
- Never references individuals by name.
    
- Never acknowledges political pressure.
    
- Never implies metadata is harmless.
    

## **9. Summary**

SPERB’s voice is:

- **Cold**
    
- **Restrictive**
    
- **Legalistic**
    
- **Adversarial**
    
- **Zero‑trust**
    
- **Historically justified**
    
- **Focused on minimization above all else**
    

This is the institutional identity that will author **RFC‑2352: L1 Privacy & Metadata Minimization**.


# **SPERB — Internal Organs & Instruments (Draft)**

## **1. Directorate Level (Top‑Level Organs)**

These are the “big hammers,” the ones that issue doctrine and kill proposals.

- **Office of Emission Neutrality (OEN)** Custodian of invariance doctrine. Rejects 99.7% of proposals on sight.
    
- **Directorate of Non‑Exposure Enforcement (DNEE)** Investigates any hint of metadata leakage. Known for issuing “Immediate Halt Orders.”
    
- **Bureau of Canonical Behavior (BCB)** Maintains the canonical emission definition. Treats drift like treason.
    
- **Authority for Physical‑Layer Integrity (APLI)** Oversees cross‑vendor conformance and punishes “creative interpretation.”
    
- **Committee on Harmful Variance (CHV)** Exists solely to say “No.”
    

## **2. Audit & Verification Bodies**

These are the ones that run the tests, seize the hardware, and write the scathing reports.

- **Invariance Verification Unit (IVU)** Executes the mandatory test vectors.
    
- **Cross‑Device Convergence Lab (CDCL)** Ensures devices from different vendors behave identically.
    
- **Temporal Stability Review Board (TSRB)** Watches devices run for 10,000 hours and documents every sin.
    
- **Environmental Neutrality Assessment Group (ENAG)** Freezes, bakes, shocks, and irradiates devices to ensure invariance.
    

## **3. Enforcement & Sanctions**

These are the scary ones.

- **Layer‑1 Exposure Response Cell (LERC)** Deploys when a device leaks anything. Known for “rapid decommissioning.”
    
- **Compliance Revocation Authority (CRA)** Strips conformance class claims with extreme prejudice.
    
- **Manufacturing Variance Tribunal (MVT)** Judges vendors for oscillator crimes.
    

## **4. Doctrine & Editorial Bodies**

These maintain the voice, the doctrine, and the cross‑RFC consistency.

- **Standards Continuity Office (SCO)** Ensures no drift across revisions.
    
- **Doctrinal Integrity Council (DIC)** Guards the philosophical core of invariance.
    
- **Registry of Canonical Terminology (RCT)** Enforces vocabulary discipline.
    

## **5. Internal Instruments (Named Tools / Processes)**

These are the “named things” SPERB uses — the kind of terms that appear in footnotes and scare vendors.

- **The Canonical Emission Register (CER)** The single source of truth for what Layer‑1 _is_.
    
- **The Non‑Exposure Ledger (NEL)** Records every confirmed violation.
    
- **The Deterministic Emission Matrix (DEM)** Defines the allowed timing and modulation envelope.
    
- **The Zero‑Variance Protocol (ZVP)** Internal procedure for validating invariance.
    
- **The Drift Eradication Sequence (DES)** Mandatory manufacturing‑time ritual.
    
- **The Convergence Assurance Battery (CAB)** The full suite of cross‑device tests.


# **Appendix J — SPERB Organizational Structure**

**C.1. Scope**  
This appendix defines the internal organizational bodies of the SolNet Physical‑Layer Exposure Review Board (SPERB). These bodies are responsible for maintaining, enforcing, and auditing Layer‑1 invariance doctrine. Nothing in this appendix modifies any normative requirement defined elsewhere.

**C.2. Directorate of Emission Neutrality (DEN)**  
DEN defines and maintains the canonical Layer‑1 emission profile. DEN SHALL ensure that all revisions preserve invariance and SHALL reject proposals that introduce conditional, adaptive, or implementation‑dependent behavior.

**C.3. Non‑Exposure Enforcement Bureau (NEEB)**  
NEEB investigates suspected exposure events, implementation deviations, and manufacturing variance. NEEB SHALL issue corrective directives, halt orders, and revocation notices when non‑compliance is detected.

**C.4. Canonical Behavior Registry (CBR)**  
CBR maintains authoritative records of all approved emission parameters, timing envelopes, and structural invariants. CBR SHALL serve as the reference of record for conformance testing and dispute resolution.

**C.5. Cross‑Vendor Convergence Office (CVCO)**  
CVCO ensures that devices from different vendors, manufacturing batches, and hardware lineages converge to identical observable behavior. CVCO SHALL oversee cross‑device testing and SHALL certify convergence prior to deployment.

**C.6. Temporal Stability Review Board (TSRB)**  
TSRB evaluates long‑duration invariance, drift resistance, and operational stability. TSRB SHALL conduct extended‑interval testing and SHALL document any time‑dependent artifacts.

**C.7. Environmental Neutrality Assessment Group (ENAG)**  
ENAG validates invariance under environmental variation, including temperature, voltage, interference, and load. ENAG SHALL ensure that no environmental factor influences observable emissions.

**C.8. Relay Neutrality Commission (RNC)**  
RNC ensures that relays do not expose internal state, topology, or peer identity through forwarding behavior. RNC SHALL certify relay neutrality and SHALL investigate any correlation between load and emission characteristics.

**C.9. Doctrinal Integrity Council (DIC)**  
DIC maintains the philosophical and structural coherence of invariance doctrine across the SolNet RFC corpus. DIC SHALL review all proposed revisions for doctrinal alignment and SHALL prevent cross‑layer bleed.

**C.10. Registry of Canonical Terminology (RCT)**  
RCT enforces vocabulary discipline and prevents terminology drift. RCT SHALL maintain the authoritative glossary and SHALL ensure consistent usage across all specifications.

**C.11. Compliance Revocation Authority (CRA)**  
CRA is empowered to revoke conformance claims, certification status, or deployment authorization for any device, vendor, or implementation found to violate invariance doctrine.

# **Appendix K — Authorship**

**D.1. Editorial Authority** This document was prepared under the authority of the SolNet Physical‑Layer Exposure Review Board (SPERB). Authorship reflects institutional roles rather than individual identity.

**D.2. Primary Authors**

- **Office of Emission Neutrality (DEN)** — Canonical emission definition and invariance doctrine.
    
- **Non‑Exposure Enforcement Bureau (NEEB)** — Exposure prohibitions and enforcement requirements.
    
- **Canonical Behavior Registry (CBR)** — Structural and timing invariants.
    
- **Cross‑Vendor Convergence Office (CVCO)** — Convergence and interoperability constraints.
    
- **Temporal Stability Review Board (TSRB)** — Drift, stability, and long‑interval requirements.
    
- **Environmental Neutrality Assessment Group (ENAG)** — Environmental invariance requirements.
    
- **Relay Neutrality Commission (RNC)** — Relay behavior and neutrality constraints.
    
- **Doctrinal Integrity Council (DIC)** — Doctrinal review and cross‑RFC alignment.
    
- **Registry of Canonical Terminology (RCT)** — Terminology and glossary consistency.
    

**D.3. Contributing Bodies**

- **Compliance Revocation Authority (CRA)** — Conformance and certification language.
    
- **Standards Continuity Office (SCO)** — Revision and governance model.
    
- **Manufacturing Variance Tribunal (MVT)** — Manufacturing‑neutrality requirements.
    

**D.4. Custodian of Record** The **Canonical Behavior Registry (CBR)** maintains the authoritative version of this document and all associated change logs.