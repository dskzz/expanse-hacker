
# RFC‑2301 — SolNet Cryptographic Primitives

_SolNet Standards Working Group (SSWG)_ _Status: Informational / Foundational_

## 1 Purpose

Define the cryptographic building blocks and key‑management model that every SolNet implementation should understand and interoperate with. This RFC sets conceptual rules, minimum expectations, and a migration posture for cryptography across the Authority and Namespace planes without locking the system to a single vendor or era‑specific primitive.

## 2 Scope

Covers key hierarchy and binding model; signature and key usage semantics; entropy and randomness expectations; required algorithm properties (by property, not by name); key lifetimes, rotation, and revocation semantics; ledger anchoring and certificate binding model (conceptual); and post‑quantum readiness posture and migration guidance. Wire encodings and exact algorithm identifiers are deferred to a later RFC.

## 3 Principles and Constraints

- **Identity before convenience.** Long‑lived identity anchors (domains, repeaters, ships) must be cryptographically robust and auditable; ephemeral conveniences must never weaken anchors.
    
- **Minimal metadata exposure.** Signatures and headers should reveal the least metadata necessary for routing and trust decisions.
    
- **Layered keys.** Use a hardware root where available, persistent device keys for identity, and ephemeral keys for sessions and forward secrecy.
    
- **Post‑quantum readiness.** Design for algorithm agility and migration; avoid irreversible choices for long‑lived anchors.
    
- **Practicality.** The system must be implementable on constrained devices and hardened for high‑Authority nodes.
    

## 4 Canonical Key Hierarchy

A clear hierarchy reduces mistakes and supports auditability.

1. **Hardware Root (HR)** — secure element or TPM equivalent; optional for low‑end devices, required for high‑Authority nodes.
    
2. **Anchor Key (AK)** — long‑lived keypair bound to a UUID‑S7 for a domain or persistent node; used to sign NetworkCerts and ledger transactions. Stored in HR when available.
    
3. **Device Key (DK)** — persistent keypair for a physical device; may be subordinate to AK for operator‑owned devices.
    
4. **Service Key (SK)** — per‑service key for signing service announcements and DRE registrations; shorter lifetime than DK.
    
5. **Session Keys (Ephemeral)** — short‑lived keys for end‑to‑end encryption and forward secrecy; derived or negotiated per session.
    
6. **One‑time / Ephemeral Tokens** — single‑use tokens for emergency bursts or transient handoffs.
    

**Binding rule:** AK ↔ UUID‑S7 ↔ AuthorityChain must be provably bound via NetworkCert and optionally LedgerAnchor; device and service keys inherit trust via signed assertions.

## 5 Signature and Key Usage Semantics

- **NetworkCert:** AK signs a certificate binding `AuthorityChain → UUID‑S7 → AK.public`. This is the canonical identity assertion.
    
- **Ledger transactions:** signed by AK (or authorized ledger agent) to record anchors, revocations, and authoritative metadata.
    
- **DRE registrations:** SK signs `//info` and `//contact` records; high‑trust entries may require AK countersignature.
    
- **Routing metadata:** DK or SK may sign routing announcements and ephemeris hints; relays verify against known anchors.
    
- **Session establishment:** session keys are negotiated and authenticated using DK or ephemeral key exchange; session tokens are short‑lived.
    
- **Local namespace assertions:** N‑stack services sign local claims with SK; these are not globally authoritative unless backed by AK/ledger.
    

## 6 Entropy, RNG, and Key Generation

Implementations MUST use a hardware RNG where available; otherwise combine multiple OS and environmental entropy sources. Deterministic key derivation from seeds is allowed only when the seed is protected by HR. Devices must reseed session RNGs on boot, after sleep, and after suspicious events. AK and DK generation SHOULD occur in secure environments (HR preferred); SK and session keys may be generated in software but must use strong RNG.

## 7 Required Algorithm Properties

Rather than mandating specific algorithms, require these properties:

- **Signatures:** fast verification, compact signatures, well‑studied security proofs; batch verification desirable at DREs.
    
- **Key exchange:** ephemeral Diffie‑Hellman semantics for forward secrecy; authenticated key exchange for session establishment.
    
- **Symmetric crypto:** AEAD primitives for confidentiality and integrity.
    
- **Hashing:** collision‑resistant and preimage‑resistant for identifiers and ledger commitments.
    
- **Post‑quantum:** support hybrid constructions (classical + PQ) for long‑lived signatures and key exchange.
    
- **Compactness:** prefer compact encodings and small key/signature sizes on constrained devices where security permits.
    

Concrete algorithm recommendations and timelines will be specified in RFC‑2452.

## 8 Key Lifetimes, Rotation, and Expiry

- **AK:** long lifetime (years to decades) but MUST have a planned rotation and migration path; ledger entries record AK history and deprecation windows.
    
- **DK:** medium lifetime (months to years) depending on device class; rotate on compromise or schedule.
    
- **SK:** short to medium lifetime (days to months); rotate frequently for exposed services.
    
- **Session keys:** ephemeral; rotate per session or per short time window. Rotations MUST be atomic from the trust consumer’s perspective: publish new key, cross‑sign with old key, and update ledger entries if required; explicit grace periods are required.
    

## 9 Revocation and Emergency Unbinding

Revocation vectors include ledger entries, CRL‑like lists, and short‑lived revocation tokens; LedgerAnchor is the canonical long‑term revocation record. For catastrophic compromise, a trust‑domain authority can issue an emergency unbind that marks an AK revoked and optionally issues a short‑lived override token for recovery operations; emergency unbinds must be auditable and carry justification metadata. Revocation must propagate through the A‑stack and be visible to L1 relays where feasible; personal devices must prioritize cache invalidation on revocation.

## 10 Ledger Anchoring and Auditability

The ledger stores authoritative bindings (UUID‑S7 ↔ AuthorityChain ↔ AK.public), revocations, and signed audit events; it is append‑only and replicated. Ledger entries are signed by AK or an authorized ledger agent and include timestamps, optional human‑readable notes, and cross‑references. Ledger entries enable forensic reconstruction of identity history; long‑term signatures should be stored to support future verification (consider timestamping and archival strategies).

## 11 Post‑Quantum Readiness and Migration Strategy

- **Hybrid approach:** use hybrid signatures/key exchange (classical + PQ) for long‑lived anchors and ledger entries.
    
- **Algorithm agility:** include algorithm identifiers and versioning in all formats so new algorithms can be adopted without breaking parsing.
    
- **Migration windows:** define explicit migration windows for anchors; disallow silent, unlogged algorithm swaps for anchors.
    
- **Staged rollouts:** require lab validation → DRE pilot → domain pilot → system‑wide migration.
    

RFC‑2452 will pin concrete PQ choices and timelines.

## 12 Hardware Root and Device Classes

High‑Authority nodes (repeaters, ships, DREs) MUST have a hardware root or equivalent tamper‑resistant module. Personal devices SHOULD use secure elements where feasible; if unavailable, software mitigations and shorter key lifetimes are required. HR compromise consequences include immediate revocation, ledger entry, and emergency unbind.

## 13 Interop and Minimal Requirements

Implementations claiming SolNet cryptographic compatibility MUST implement the key hierarchy and binding semantics; support signed NetworkCerts binding AuthorityChain ↔ UUID‑S7 ↔ AK.public; support session key negotiation with forward secrecy; include algorithm identifiers and versioning in signed objects; provide a revocation mechanism visible to A‑stack components; and support hybrid signing for long‑lived anchors or be explicitly marked as non‑PQ‑ready.

## 14 Example Workflows

- **Register a domain:** generate AK in HR → create NetworkCert binding AuthorityChain to UUID‑S7 → publish LedgerAnchor signed by AK → DREs pick up `//info` signed by SK with AK cross‑signature.
    
- **Onboard a device:** device generates DK → operator signs DK with AK to produce a device assertion → device stores assertion and uses DK for sessions; ledger may record device registration if required.
    
- **Respond to compromise:** detect compromise → AK issues revocation transaction to ledger → DREs and relays mark anchor revoked → emergency unbind if needed.
    

## 15 Security Considerations

Anchors are the most valuable assets — protect them with HR and ledger anchoring; minimize metadata exposure; adopt hybrid PQ strategies for long‑term risk reduction; ensure revocation is fast, auditable, and visible; and provide pragmatic defaults for constrained devices.

## 16 Dependencies and Next Steps

RFC‑2451 will define hardware root requirements and minimum secure element features. RFC‑2452 will pin concrete algorithm lists and migration timelines. RFC‑2360 (Layer Model) will reference this RFC for cryptographic expectations per layer.