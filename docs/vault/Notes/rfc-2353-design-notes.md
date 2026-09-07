# RFC‑2353 — Design Notes and Document Map

Working reference — preserves the pre-strict design blueprint and the section-by-section
institutional ownership map. Not part of the RFC deliverable itself; see
`rfc-2353-working-draft.md` (same folder) for the actual document.

## Todo / Scope Summary

**Current todo:** Purpose: RelayAdvertisement record, capability masks, scheduling capacity, admission hooks. Why: Enables dynamic routing and admission control. Defines: RelayAdvertisement TLV keys, RelayCapability masks, load metrics, admission policy hints. Interaction: ServicePlane uses relay info for session continuity and reservation negotiation. Profiles: relay capability extensions (tightbeam terminal, RF bands). Tests: relay advertisement parsing, admission decision tests.

**Original todo (superseded but retained for reference):** Purpose: Define how relays advertise capability, AuthorityWeight, supported media, scheduling capacity, and current load. Why: Enables dynamic routing, admission control, and reservation negotiation. Defines: RelayAdvertisement record, RelayCapability masks, scheduling hints, and admission policy hooks. Interaction (L/S): Relays are the operational backbone of the LocationPlane; ServicePlane uses relay info for session continuity. Tightbeam/RF: advertise optical terminal capability, supported RF bands, and reservation windows.

## Design Blueprint (Pre-Strict)

### 1. Purpose

RAP (Relay Advertisement Protocol) lets SolNet relays announce: presence, capabilities, scheduling capacity, admission policy hints, supported media (RF/tightbeam/hybrid), and load metrics (minimized, non-exposing). Enables dynamic routing, session continuity, reservation negotiation, admission control, and relay selection by ServicePlane. Must remain compliant with RFC‑2352 (Privacy & Metadata Minimization) and RFC‑2350 (Canonical Addressing).

### 2. RelayAdvertisement Record

TLV-structured, emitted at controlled intervals.

**Required TLVs:**

- RelayID — canonical L1 address (RFC‑2350); non-identifying, non-correlatable.
- RelayCapabilityMask — bitmask of supported media, scheduling modes, relay behaviors.
- SchedulingCapacityHint — minimized, quantized indicator of available scheduling slots.
- AdmissionPolicyHint — coarse, non-exposing indicator of session acceptance.
- MediaProfile — RF, tightbeam, hybrid, or extended profiles.
- RelayLoadClass — privacy-preserving load class (LOW/MED/HIGH); does not reveal queue depth.

**Optional TLVs:**

- ReservationSupport — reservation endpoint support, per RFC‑2370.
- CapabilityExtensions — vendor-neutral extension mask.
- EphemerisHint — for tightbeam terminals, per RFC‑2306/2364.

### 3. RelayCapability Masks

Bitfield describing what a relay can do, not how.

**Core bits:** 0x01 RF Relay · 0x02 Tightbeam Terminal · 0x04 Hybrid Relay · 0x08 Scheduling Relay · 0x10 Reservation-Capable · 0x20 Mobility-Aware · 0x40 DTN-Aware · 0x80 Privacy-Hardened

**Extended bits:** reserved for faction-specific relay types, vendor-specific capabilities, future SolNet layers. All extended bits MUST be non-exposing.

### 4. Scheduling Capacity

Quantized, privacy-preserving capacity hint — policy-derived, not state-derived.

Classes: C0 (No Capacity) – C1 (Limited) – C2 (Moderate) – C3 (Ample) – C4 (High) – C5 (Unrestricted). Not proportional to actual queue depth.

Update rules: MUST NOT update more frequently than canonical interval; MUST NOT correlate with instantaneous load; MUST NOT reveal queue depth or peer identity.

### 5. Admission Hooks

AdmissionPolicyHint — coarse indicator: A0 (Closed), A1 (Restricted), A2 (Open), A3 (Preferential, e.g. reserved sessions).

Admission decisions made by ServicePlane, reservation endpoints, relay scheduling logic — but relay MUST NOT reveal why it's closed, how many sessions it has, or which peers it prefers.

### 6. Interaction with Other Layers

- **ServicePlane:** uses RelayAdvertisement to select relays, maintain session continuity, negotiate reservations, avoid saturated relays.
- **Reservation Negotiation (RFC‑2370):** RelayAdvertisement provides ReservationSupport, SchedulingCapacityHint, AdmissionPolicyHint.
- **Namespace Plane:** advertisements may be cached by N2 (Local Namespace) / N3 (Service Discovery) but MUST NOT be used for fingerprinting.

### 7. Profiles

- **RF Relay Profile:** RF media, environmental neutrality, standard scheduling.
- **Tightbeam Terminal Profile:** tightbeam media, ephemeris hints, reservation-heavy, mobility-aware.
- **Hybrid Relay Profile:** RF + tightbeam, multi-media scheduling, extended capability mask.

### 8. Tests

- **Advertisement Parsing:** TLV ordering, TLV validation, capability mask correctness, privacy envelope compliance.
- **Admission Decision:** correct interpretation of AdmissionPolicyHint/SchedulingCapacityHint, correct fallback behavior.
- **Minimization:** no queue-depth leakage, no peer-identity leakage, no timing-based exposure.
- **SPERB/SPEAR‑B:** canonical interval compliance, non-exposing behavior, capability mask neutrality.

### 9. SPEAR‑B (SPERB) Notes

RelayAdvertisements MUST NOT reveal internal state. Capability masks MUST NOT encode vendor identity. SchedulingCapacityHint MUST NOT correlate with real load. AdmissionPolicyHint MUST NOT encode topology. SPERB insists on "SPEAR‑B" pronunciation and rejects vendor documentation using "Sperb."

## Institutional Authorship Map (Section Ownership)

| Section | Owning Institution(s) | Notes |
|---|---|---|
| 0. Document Preface | DIC | Doctrinal frame, invariance doctrine, "This RFC SHALL…" |
| 1. RelayAdvertisement Structure | RNC (primary) | Relay-behavior spec |
| 2. TLV Registry and Field Definitions | CBR | Canonical ordering/naming, zero ambiguity |
| 3. Capability Masks | CBR + CVCO | CBR: precise/table-driven; CVCO: vendor-neutrality watchdog |
| 4. Scheduling Capacity & Admission Policy Hints | RNC | Operational engineering, non-exposure |
| 5. Minimization Constraints | NEEB | Enforces RFC‑2352 compliance |
| 6. Timing & Interval Rules | TSRB | Drift/timing invariance |
| 7. Media Profiles (RF/Tightbeam/Hybrid) | ENAG | Environmental realism |
| 8. Operational Considerations (Sparse Topologies, Belt Sectors) | OPRA | Patois-eligible; fairness/anti-discrimination focus |
| 9. Vendor Neutrality Requirements | CVCO | Capability masks don't leak vendor lineage |
| 10. Security & Exposure Notes | NEEB | Compliance threats, exposure warnings |
| 11. Doctrinal Alignment Notes | DIC | Consistency with RFC‑2352/2360 |
| 12. SPERB Procedural Rules | SPERB | Compliance/audit, revocation authority |
| 13. Test Vectors & Parsing Tests | CBR + RNC + NEEB | CBR: canonical test defs; RNC: relay-behavior tests; NEEB: exposure tests |
| Appendix A. Rationale | DIC | |
| Appendix B. Formal Proof Sketch | DIC + NEEB | |
| Appendix C. Test Vector Overview | CBR + RNC | OPRA may also appear |
| Appendix D. Deployment Guidance | OPRA + ENAG + RNC | |
| Appendix E. Security Considerations | NEEB | |
| Appendix F. Known Non-Compliant Patterns | NEEB + RNC | |
| Appendix G. Historical Context | DIC + OPRA | |
| Appendix H. SPERB Procedural Rules | SPERB | |
| Appendix I. Implementation Notes | OPRA + ENAG | |
| Appendix J. Organizational Structure | SPERB | |
| Appendix K. Authorship | All institutions (bodies, not individuals) | |

OPRA appears most in: C, D, G, I (and potentially more per authorial discretion).

Where OPRA never appears: TLV definitions, capability mask definitions, minimization constraints, doctrinal alignment, timing rules, environmental neutrality, compliance/audit sections.

## In-Universe Authorship Note (for Appendix K)

**Primary Authors:** RNC (relay behavior, forwarding neutrality, admission policy hints), CBR (TLV registry, capability masks, canonical advertisement structure), NEEB (prevents leakage of queue depth/peer identity/topology), DIC (invariance doctrine alignment, non-violation of RFC‑2352).

**Contributing Bodies:** TSRB (interval rules, timing-exposure review), ENAG (RF/tightbeam environmental-state leakage review), CVCO (vendor-identity encoding review in capability masks).

**Custodian of Record:** CBR (maintains authoritative TLV registry and capability mask definitions).

## Open Design Consideration: Propagation Model (Not Yet in RFC Body)

Raised during drafting; not yet incorporated into the numbered sections. Flagging here so it isn't lost.

- RAP exchanges are one-way by design. A RelayAdvertisement is emitted without expecting a synchronous response. Any eventual reply (e.g., a route forming back toward the origin) is a separate, independently-routed, unpromised event that may occur much later, not part of the original exchange. **"Handwaves, not handshakes."**
- **Multi-hop propagation.** An advertisement is not observed only by immediate neighbors — it propagates outward hop-by-hop, giving nodes further up the chain a coarser, farther-reaching picture of what's reachable in that direction.
- **Hop-limited, not unlimited.** Propagation stops after a bounded number of hops (a TTL-like field). This is a real tradeoff, not a free parameter: too small a limit produces dead ends (a propagation chain terminating before reaching anything useful); too large a limit lets stale/unreachable path information persist and become hard to correct ("non-repairable"). Both risks are believed to shrink as the hop limit is tuned toward a sweet spot rather than pushed to either extreme.
- **Possible real-world precedent (unconfirmed):** hop-limited flooding / distance-vector propagation, and historical fixes to distance-vector routing (e.g., stale-route/loop mitigation), were flagged as a possible inspiration — worth verifying specifics before committing RAP's hop-limit design to closely mirror a named real protocol.
- **Not yet decided:** whether this becomes a new field/section in RFC‑2353 itself (Section 1 currently describes RAP as single-hop/locally-observed) or is deferred to a later revision or companion RFC.

**Status (2026-09-06):** still not incorporated into `rfc-2353-working-draft.md` — this is the next concrete gap to close on that document, per Gary's review of the draft against this map.

## Open Item

Whether to introduce a UN‑ID-style "cover-my-ass" / liability-shifting institutional voice (established for RFC‑2306, not currently present in the RFC‑2353 roster) — see voice guide doc for details. **Unresolved as of last discussion.**
