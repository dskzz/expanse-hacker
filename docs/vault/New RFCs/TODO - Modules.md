
### SolNet Module RFC Catalog — full, detailed list (module‑level RFCs ready to draft)

Below is a complete, **module‑level RFC catalog** that maps every modular capability discussed into its own RFC. Each entry follows a fixed template so authors can draft a full spec without touching the frozen L0/L1 substrate. Modules are grouped by the layer they extend and ordered by implementation priority. For each module I provide: **purpose**, **why it’s a module**, **exact TLV keys and numeric suggestions**, **off‑air record schemas to author**, **session flows and example messages to include**, **APIs/endpoints**, **security & privacy requirements**, **test vectors**, **DRE registry example**, and **operator playbook excerpt**. Use this as the authoritative module list to draft the full corpus.

---

## How to use this catalog

- Treat each module entry as a self‑contained RFC draft checklist.
- All on‑air hints must use the TLV container in RFC‑2350; **do not** add mandatory L1 fields.
- Every module RFC must include CBOR/JSON schemas and at least one canonical wire example (header + TLV + payload + receipt).
- Sensitive modules (PD, OTC, Stealth) require governance signoff and a privacy impact statement before DRE registration.

---

# L0 Subprofile Modules (physical behavior and on‑air hints)

### Tightbeam v1 (RFC‑2306.1) — directional optical/laser links

**Purpose:** Canonical lifecycle and receipts for directional tightbeam links used for ship↔ship, ship↔station, and relay handoffs.  
**Why module:** Tightbeam is a specialized L0 mode with stateful reservations and pointing semantics; it must be a profile so devices without optics ignore it.

**TLV key assignments (suggested):**

- `0x20` BeamID (variable string)
- `0x21` ReservationRef (varint pointer)
- `0x22` BeamFlags (bitmask)
- `0x23` PointingHint (compact ephemeris bin)

**Off‑air records to author (CBOR/JSON + compact mapping):**

- **BeamProfileRecord**: `{BeamID, Divergence_mrad, MaxPower_W, SideLobeSpec, OwnerTrustDomain, ProvenancePointer, Freshness}`
- **ReservationReceipt**: `{ReservationID, BeamID, StartISO, EndISO, PowerBudget_W, Signature, Freshness}`
- **AcquisitionReceipt**: `{AcquisitionID, ReservationID, ReceiverID, Timestamp, Confidence, Signature}`
- **TrackingHeartbeat**: `{BeamID, SessionID, Timestamp, PointingError_deg, SNR_dB}`
- **OcclusionEvent**: `{BeamID, Timestamp, OcclusionType, EvidenceRefs}`

**Session negotiation & example messages:**

- **Reservation flow:** client `POST /l0/reservations {FlightPlanRef, BeamCaps, PowerBudget}` → relay returns `ReservationReceipt`. Include canonical wire bytes for reservation request and receipt.
- **Acquisition handshake:** transmitter emits TLV `BeamHint` with `ReservationRef`; receiver responds with `AcquisitionRequest` TLV; transmitter issues `AcquisitionReceipt` on successful lock. Provide hex + decoded CBOR examples.

**APIs / endpoints:**

- `POST /l0/reservations` (CBOR)
- `GET /l0/reservations/<id>`
- `POST /l0/acquire`
- `GET /l0/pointing/<BeamID>`

**Security & privacy:**

- BeamProfile exposure default **suppressed**; DRE access control required.
- ReservationReceipt must be signed by relay or authority; optional ledger anchoring for cross‑domain disputes.
- Stealth mode (separate module) may alter visibility and receipt anchoring.

**Test vectors (must include):**

- Reservation→acquisition→handover success path.
- Occlusion injection: simulate partial occlusion and verify `OcclusionEvent` and fallback.
- Ledger partition: issue ReservationReceipt while ledger unavailable; reconcile after anchor.

**DRE profile registry example:**

```json
{
  "profile":"tightbeam",
  "version":"1.0.0",
  "tlv_keys":[{"key":"0x20","name":"BeamID"},{"key":"0x21","name":"ReservationRef"}],
  "schema":"https://dres.example/profiles/tightbeam/v1/schema.json",
  "privacy":"BeamProfile exposure restricted; default suppression"
}
```

**Operator playbook excerpt (docking corridor):**

1. Submit flight plan → request reservation.
2. Await `ReservationReceipt`; schedule acquisition window.
3. On acquisition, verify `AcquisitionReceipt` and begin data/control transfer.
4. If occlusion occurs, issue `HandoverProposal` and log `OcclusionEvent`.

---

### RF Channel v1 (RFC‑2307.1) — RF channel profiles and scheduled bands

**Purpose:** Standardize RF channel descriptors, beaconing, interference events, and scheduled band reservations.  
**Why module:** RF is ubiquitous but heterogeneous; a profile prevents ad‑hoc beacon formats.

**TLV key assignments:**

- `0x24` RFChannelHint (band/channel id)
- `0x25` RFBeaconHint (beacon descriptor pointer)
- `0x26` RFLinkQualityHint (compact SNR/RSSI)

**Off‑air records:**

- **RFChannelProfileRecord**: `{ChannelID, FrequencyHz, BandwidthHz, PowerClass, RegulatoryFlags, ProvenancePointer}`
- **RFBeaconDescriptor**: `{BeaconID, Interval_ms, PayloadSchemaPointer}`
- **RFInterferenceEvent**: `{ChannelID, Timestamp, InterferenceType, EvidenceRefs}`
- **RFReservationReceipt**: `{ReservationID, ChannelID, Start, End, PowerBudget, Signature}`

**Session flows & examples:**

- Beaconing: periodic TLV `RFBeaconHint` with minimal payload; include example TLV and decoded JSON.
- Scheduled band reservation: `POST /rf/reservations` → `RFReservationReceipt`.

**APIs:**

- `POST /rf/reservations`
- `GET /rf/channels`
- `POST /rf/beacon` (for authorized beacons)

**Security & privacy:**

- Beacon payloads minimized by default; regulatory flags indicate public emergency channels.
- Interference events must be logged and optionally anchored for enforcement.

**Tests:**

- Beacon discovery under congestion.
- Interference detection and mitigation.
- Scheduled band reservation conflict resolution.

**DRE entry:** `//profiles/rf/v1` with TLV map and schema link.

**Operator playbook (emergency broadcast):**

1. Issue emergency beacon TLV with `EmergencyLevel`.
2. Relays prioritize and issue `AdmissionReceipt`.
3. Log `RFInterferenceEvent` if jamming suspected.

---

### ProxLink v1 (RFC‑2306.2) — proximity/BAN transfers (suit flicks)

**Purpose:** Canonical local discovery, handshake, chunked transfer, and receipts for proximity transfers.  
**Why module:** Proximal transfers are local, ephemeral, and privacy‑sensitive; they must be a local profile.

**TLV key assignments:**

- `0x27` ProxID (16‑bit ephemeral)
- `0x28` ProxCaps (bitmask)
- `0x29` ProxNonce (anti‑replay)

**Off‑air records:**

- **ProxBeacon**: `{ProxID, ServiceCaps, TTL_s, TrustHint, CompactAuthTag}`
- **ProxHandshake**: `{SessionID, NonceA, NonceB, RequestedAction, AuthProof}`
- **ProxTransferDescriptor**: `{SessionID, FileHash, Size, ChunkCount, ChunkHashes}`
- **ProxTransferReceipt**: `{ReceiptID, SessionID, ChunkRange, ReceiverID, Timestamp, Signature}`

**Session flows & canonical messages:**

- **Discovery:** device emits `ProxBeacon` TLV; receiver responds with `ProxDiscoveryResponse`. Provide wire bytes for beacon and response.
- **Handshake:** mutual nonce exchange and ephemeral session key derivation; show CBOR handshake example.
- **Transfer:** chunked push with per‑chunk `ProxTransferReceipt`.

**APIs / local endpoints:**

- Local UDP/short‑range endpoint for discovery and handshake.
- Optional `POST /prox/escalate` to relay for store‑and‑forward.

**Security & privacy:**

- Default ephemeral ProxID; physical confirmation required for high‑value transfers.
- AuthProof optional for low‑value; required for legal evidence.
- Delegation to relay requires `DelegationToken` and `DelegationReceipt`.

**Tests:**

- Flick transfer success and partial transfer reconciliation.
- Replay attack: ensure nonces prevent replay.
- Relay escalation: verify `DelegationReceipt` and eventual ledger anchor if requested.

**DRE entry:** `//profiles/proxlink/v1`.

**Operator playbook (flick file):**

1. Sender emits `ProxBeacon`.
2. Receiver accepts and performs `ProxHandshake`.
3. Sender streams chunks; receiver issues `ProxTransferReceipt` per chunk.
4. If receiver offline, escalate to relay with `DelegationToken`.

---

### Stealth L0 Modes (RFC‑Stealth.1) — LPD/LPI parameters and governance

**Purpose:** Define L0 parameters and operational rules for low probability of detection/intercept modes.  
**Why module:** Stealth is sensitive and must be opt‑in with governance and audit hooks.

**TLV key assignments:**

- `0x2A` StealthClass (enum A–E)
- `0x2B` RendezvousSeedPointer (ProvenancePointer to encrypted seed)
- `0x2C` BurstWindowHint (timing hint)

**Off‑air records:**

- **StealthProfileRecord**: `{PlatformID, StealthClass, AllowedModes, MaxBurstPower, ProvenancePolicy}`
- **StealthReservationReceipt**: `{ReservationID, StealthClass, Start, End, Signature, Freshness}`
- **StealthAuditEvent**: `{EventID, SessionID, EvidenceRefs, OperatorAction, LedgerPointer}`

**Session flows & examples:**

- Stealth reservation uses `POST /l0/reservations` with `StealthClass` flag; relay issues `StealthReservationReceipt` (provisional). Provide example of deferred ledger anchoring.

**APIs:**

- `POST /l0/reservations?stealth=true`
- `POST /stealth/unmask-request` (multi‑party approval flow)

**Security & privacy:**

- Default opt‑in; unmasking requires multi‑party approval and produces `StealthAuditEvent` anchored to ledger with redaction metadata.
- ProvisionalReceipts used by default; final anchoring deferred.

**Tests:**

- LPD/LPI detection thresholds.
- Unmasking approval flow and ledger anchoring with redaction pointer.
- Abuse detection and audit.

**DRE entry:** `//profiles/stealth/v1`.

**Operator playbook (unmasking):**

1. Submit `UnmaskRequest` with evidence.
2. Collect multi‑party approvals.
3. On approval, create `StealthAuditEvent` and anchor to ledger with redaction pointer.

---

# L1 TLV Modules (on‑air hints and small on‑air payloads)

### ProxHint (RFC‑ProxHint.1)

**Purpose:** Minimal L1 hint to identify ProxLink frames without exposing location.  
**TLV keys:** `0x30` ProxHint; `0x31` ProxTTL.  
**Records:** small TLV payload mapping to ProxLink profile.  
**Tests:** TLV parsing, TLV skipping behavior.  
**DRE entry:** `//profiles/prox-hint/v1`.

### BeamHint (RFC‑BeamHint.1)

**Purpose:** L1 hint for tightbeam acquisition and reservation pointers.  
**TLV keys:** `0x32` BeamHint; `0x33` ReservationPointer.  
**Records:** BeamHint TLV; ReservationRef pointer format.  
**Tests:** hint usefulness in acquisition workflows.  
**DRE entry:** `//profiles/beam-hint/v1`.

### CommNetID & GroupID (RFC‑CommNet.1)

**Purpose:** Short group addressing for tactical meshes.  
**TLV keys:** `0x34` CommNetID; `0x35` GroupRole; `0x36` GroupAuthHint.  
**Records:** CommNetAdvert TLV; GroupJoinRequest TLV.  
**Tests:** group join, multicast envelope parsing.  
**DRE entry:** `//profiles/commnet/v1`.

### Emergency Burst Hint (RFC‑EmergencyHint.1)

**Purpose:** Mark emergency bursts for preemption.  
**TLV keys:** `0x37` EmergencyLevel; `0x38` BurstNonce.  
**Records:** EmergencyBurst TLV; minimal audit pointer.  
**Tests:** preemption behavior and abuse detection.  
**DRE entry:** `//profiles/emergency-burst/v1`.

---

# Authority Plane Modules

### ProvenancePointer (RFC‑2361.1)

**Purpose:** Canonical pointer format and DRE fetch semantics for off‑air records.  
**Pointer format:** `<DRE-ID>:<record-hash-hex>:<short-timestamp>` (e.g., `DRE1:9f3a7b:20260326T1631Z`)  
**APIs:** `GET /dres/<LocationChain>//info` returns CBOR record and optional `LedgerPointer`.  
**Tests:** pointer resolution, ledger anchoring roundtrip.  
**DRE entry:** `//profiles/provenance-pointer/v1`.

### Identity & NetworkCert (RFC‑Identity.1)

**Purpose:** Identity record formats, NetworkCert profiles, verification flows.  
**Records:** IdentityRecord, NetworkCert, IdentityProof.  
**Tests:** identity verification, cross‑cert chains, conflict resolution.  
**DRE entry:** `//profiles/identity/v1`.

### DelegationToken (RFC‑Delegation.1)

**Purpose:** Relay and constrained device delegation tokens.  
**Token fields:** `{issuer, subject, scope, expiry, nonce, signature}`  
**APIs:** `POST /delegation/issue`, `POST /delegation/revoke`.  
**Tests:** token misuse, revocation propagation.  
**DRE entry:** `//profiles/delegation-token/v1`.

### Ledger Anchoring (RFC‑LedgerAnchor.1)

**Purpose:** Anchoring flow, AnchorReceipt format, delayed anchoring semantics.  
**Records:** LedgerAnchor, AnchorReceipt, RevocationEntry.  
**Tests:** partitioned anchoring, reconciliation, cost accounting.  
**DRE entry:** `//profiles/ledger-anchor/v1`.

---

# Namespace Plane Modules

### ServiceDescriptor (RFC‑ServiceDesc.1)

**Purpose:** Canonical service descriptor and discovery semantics.  
**Records:** ServiceDescriptor, CapabilityMask, AccessPolicyPointer.  
**APIs:** discovery endpoints, TTL semantics.  
**Tests:** discovery under mobility, TTL expiry.  
**DRE entry:** `//profiles/service-descriptor/v1`.

### Session Resumption (RFC‑SessionResume.1)

**Purpose:** SessionToken formats and DTN resumption tokens.  
**Records:** SessionToken, SessionResumptionToken.  
**Tests:** resumption across DTN hops.  
**DRE entry:** `//profiles/session-resume/v1`.

### PNI / Personal Namespace (RFC‑PNI.1)

**Purpose:** Personal identity, ephemeral keys, privacy defaults.  
**Records:** PNI record, DelegationToken usage.  
**Tests:** PNI suppression enforcement.  
**DRE entry:** `//profiles/pni/v1`.

### ACL & Local Security (RFC‑ACL.1)

**Purpose:** Per‑service ACL schema and enforcement hooks.  
**Records:** ACLRecord, RoleProfile.  
**Tests:** ACL enforcement and revocation propagation.  
**DRE entry:** `//profiles/acl/v1`.

---

# Cross‑plane Operational Modules

### PD v1 (RFC‑PD.1) — Ship Point Defense

**Purpose:** PDCommand semantics, handoff, audit, and receipts.  
**TLV keys:** `0x40` PDHint; `0x41` PDPriority.  
**Records:** PDServiceDescriptor, PDCommand, PDAuditEvent, PDAdmissionReceipt, PDForwardingReceipt.  
**APIs:** `POST /pd/command`, `POST /pd/handoff`, `POST /pd/audit`.  
**Security:** signed PDCommands, local control precedence, ledger anchoring for disputes.  
**Tests:** handoff under jamming, conflict resolution between authorities.  
**DRE entry:** `//profiles/pd/v1`.

### OTC v1 (RFC‑OTC.1) — Orbital Traffic Control

**Purpose:** FlightPlan, Reservation, Clearance, tracking, conflict handling.  
**TLV keys:** `0x42` OTCHint; `0x43` FlightPlanPointer.  
**Records:** FlightPlan, OTCReservation, OTCClearance, OTCTrackReport, OTCAuditEvent.  
**APIs:** `POST /otc/reservations`, `POST /otc/clearance`, `POST /otc/track`.  
**Security & governance:** safety rules, certification for OTC controllers, emergency preemption.  
**Tests:** docking corridor reservation, emergency preemption, cross‑authority arbitration.  
**DRE entry:** `//profiles/otc/v1`.

### FeedManifest (RFC‑Feed.1) — news & cached internet

**Purpose:** FeedDescriptor, ChunkManifest, ContentDeliveryReceipt, subscription/payment hooks.  
**TLV keys:** `0x44` FeedID; `0x45` ManifestPointer; `0x46` CacheHint.  
**Records:** FeedDescriptor, ChunkManifest, ContentDeliveryReceipt, SubscriptionReceipt.  
**APIs:** subscription endpoints, manifest fetch.  
**Tests:** cache reconciliation, payment pairing, manifest poisoning detection.  
**DRE entry:** `//profiles/feed-manifest/v1`.

### Mesh v1 (RFC‑Mesh.1) — tactical comm net

**Purpose:** Mesh formation, group join, multicast, rekeying.  
**TLV keys:** `0x47` CommNetID; `0x48` GroupJoinNonce; `0x49` MeshMetrics.  
**Records:** CommNetAdvert, GroupJoinRequest, MulticastEnvelope, RekeyEvent.  
**APIs:** group join, rekey endpoints.  
**Tests:** mesh formation under mobility, rekey under compromise.  
**DRE entry:** `//profiles/mesh/v1`.

---

# Security & Governance Modules

### Stealth Governance (RFC‑StealthGov.1)

**Purpose:** Unmasking flow, audit requirements, multi‑party approval.  
**Records:** StealthAuditEvent, UnmaskRequest, UnmaskReceipt.  
**Tests:** unmasking approval flow, redaction anchored ledger entries.  
**DRE entry:** `//profiles/stealth-governance/v1`.

### Trust Domain Enforcement (RFC‑TrustDomain.1)

**Purpose:** Cross‑domain policy enforcement and audit obligations.  
**Records:** TrustDomainPolicy, AuditEvent.  
**Tests:** cross‑domain audit reconstruction.  
**DRE entry:** `//profiles/trust-domain/v1`.

### Hardware Root (RFC‑HWRoot.1)

**Purpose:** Secure element profiles, attestation flows, provisioning rules.  
**Records:** SecureElementProfile, AttestationRecord.  
**Tests:** attestation verification, failure modes.  
**DRE entry:** `//profiles/hw-root/v1`.

### Privacy Minimization (RFC‑PrivacyMin.1)

**Purpose:** System‑wide metadata minimization rules and opt‑in mechanisms.  
**Records:** PrivacyPolicyRecord, ExposureAudit.  
**Tests:** privacy enforcement audits.  
**DRE entry:** `//profiles/privacy-min/v1`.

---

# Developer & Game Integration Modules

### Minimal DTN (RFC‑DTNMin.1)

**Purpose:** Lightweight DTN bundle format for prototyping and gameplay.  
**Records:** BundleEnvelope minimal, CompactReceipt.  
**Tests:** prototype DTN scenarios.  
**DRE entry:** `//profiles/dtn-minimal/v1`.

### Mission Scenario Generator (RFC‑ScenarioGen.1)

**Purpose:** Procedural scenario generation API for tests and game content.  
**Records:** ScenarioSeed, ScenarioManifest.  
**Tests:** reproducibility and coverage.  
**DRE entry:** `//profiles/scenario-gen/v1`.

### Forensics Module (RFC‑Forensics.1)

**Purpose:** Evidence bundle formats, chain of custody, reconstruction tools.  
**Records:** EvidenceBundle, ChainOfCustodyRecord.  
**Tests:** evidence validation and reconstruction drills.  
**DRE entry:** `//profiles/forensics/v1`.

---

## Module RFC author checklist (repeatable for every module)

1. Title, RFC number, scope, abstract.
2. Purpose, rationale, and use cases.
3. Dependencies (base RFCs and other modules).
4. TLV key assignments (numeric values, wire encodings).
5. Off‑air record schemas (CBOR/JSON + compact binary mapping).
6. Session negotiation flows with canonical wire examples (header + TLV + payload + receipt).
7. APIs and endpoints (request/response schemas).
8. Security, privacy, threat model, governance requirements.
9. Test vectors: unit, interop, adversarial.
10. Operator playbook excerpt for critical flows.
11. DRE profile registry JSON example.
12. Migration/versioning notes and deprecation policy.

---

## Immediate drafting priority (first 90 days)

1. **Tightbeam v1** and **ProxLink v1** (author full RFCs with TLV keys, schemas, wire examples).
2. **ProvenancePointer** and **Relay Admission/DelegationToken** modules (anchor flows and receipts).
3. **TLV modules**: BeamHint, ProxHint, EmergencyHint, CommNetID.
4. **Reservation relay reference** and **DRE profile registry** skeleton.
5. **SolTLS v1** and **FeedManifest v1** drafts.

---

I will draft any one of these module RFCs into a full, ready‑to‑review specification next (complete TLV assignments, CBOR/JSON schemas, compact wire encodings, canonical messages, test vectors, and DRE entry). Which module RFC should I produce first in full: **Tightbeam v1** or **ProxLink v1**?