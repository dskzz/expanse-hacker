### SolNet Canonical RFC Todo — Consolidated Reference (authoritative index for project memory)

This document is the single canonical index for the SolNet RFC corpus. Each entry states **purpose**, **why it exists**, **what it defines**, **how it interacts with the Location/Service planes**, **Expanse‑specific considerations**, and **where tightbeam and RF fit**. Use this page as the persistent project memory for planning, drafting, and testing.

## L0 — Physical + Data‑Link (2300–2319)

### RFC‑2300 — SolNet Terminology & Concepts

**Purpose:** Establish the canonical vocabulary and conceptual model used across all RFCs (UUID‑S7, LocationChain, ServiceChain, two‑plane split, role weights, provenance, freshness). **Why:** Prevents drift and ambiguity; gives every implementer a single source of definitions. **Defines:** Core terms, naming conventions, plane boundaries, minimal examples. **Interaction (L/S):** Declares that _Location_ holds identity/authority/ephemeris and _Service_ holds local naming and sessions. **Expanse notes:** Must reflect multi‑jurisdictional actors (UN, MCRN, OPA), long delays, and roaming devices. **Tightbeam/RF:** Introduces L0 media subprofiles concept; points to subprofile RFCs.

### RFC‑2301 — SolNet Cryptographic Primitives

**Purpose:** Specify signature formats, key hierarchies, certificate profiles, and post‑quantum migration guidance. **Why:** All receipts, anchors, and provenance pointers must be verifiable across domains. **Defines:** Signature envelopes, compact signatures for constrained devices, key lifecycle, verification rules for receipts. **Interaction (L/S):** L2 identity resolution and L1 provenance verification rely on these primitives. **Expanse notes:** Support for constrained devices and intermittent verification windows. **Tightbeam/RF:** AcquisitionReceipt, ReservationReceipt, RFInterferenceEvent must be signable per this spec.

### RFC‑2302 — SolNet Ledger Specification

**Purpose:** Define LedgerAnchor format, replication model, conflict resolution, revocation entries, and audit semantics. **Why:** Ledger anchors provide authoritative bindings for identity, policy, and high‑assurance receipts. **Defines:** Anchor record schema, anchoring APIs, replication/consensus guidance, revocation entries, retention and audit fields. **Interaction (L/S):** L2 anchors DRE and ProvenancePointer verification; ServicePlane may reference ledger anchors for high‑assurance actions. **Expanse notes:** Ledger replication must tolerate long partitions and political fragmentation; reconciliation workflows required. **Tightbeam/RF:** BeamProfileRecord, ReservationReceipt, AcquisitionReceipt, RFChannelProfileRecord anchor formats.

### RFC‑2303 — Physical Media & Propagation

**Purpose:** Provide canonical propagation models for all L0 media (RF, tightbeam/laser, optical, acoustic). **Why:** Accurate routing, scheduling, and fallback require physics‑aware models. **Defines:** Path loss models, occlusion models, scintillation, multipath/fading, solar weather effects, link budgets. **Interaction (L/S):** Ephemeris hints (L3) and L1 TTLs depend on propagation characteristics. **Expanse notes:** Solar storms, debris fields, plasma effects, and long baselines are common. **Tightbeam:** divergence, pointing error, acquisition windows, occlusion probability. **RF:** multipath, fading, interference, congestion, plasma dispersion.

### RFC‑2304 — Antenna Geometry & Alignment

**Purpose:** Standardize coordinate frames, antenna/terminal geometry, pointing models, calibration, and alignment tolerances. **Why:** Tightbeam and high‑gain RF require precise pointing and predictable error models. **Defines:** Frame transforms, boresight definitions, sensor fusion inputs (IMU, star tracker), calibration records. **Interaction (L/S):** L3 ephemeris and L1 BeamID semantics reference alignment metadata. **Expanse notes:** Moving platforms, attitude control errors, and low‑quality Belter rigs must be modeled.

### RFC‑2305 — Power & Duty Cycle Constraints

**Purpose:** Define power classes, duty cycles, energy budgets, and scheduling constraints for transmitters and relays. **Why:** Energy limits drive scheduling, reservation semantics, and QoS tradeoffs for constrained devices. **Defines:** PowerClass taxonomy, duty cycle rules, reservation‑linked power budgets, emergency exceptions. **Interaction (L/S):** L1 QoS and L4 DTN scheduling use power budgets to prioritize and shape traffic. **Expanse notes:** Belter skiffs and personal devices have tight energy budgets; stations and ships have different classes. **Tightbeam:** beacon duty cycles, high‑power burst windows. **RF:** channelized power limits, congestion‑aware duty cycles.

### RFC‑2306 — Tightbeam/Laser Subprofile (L0)

**Purpose:** Make tightbeam a first‑class L0 subprofile: lifecycle, canonical records, acquisition/tracking workflows, reservation semantics, and failure modes. **Why:** Tightbeam is directional, stateful, and brittle; ad‑hoc implementations cause incompatibility and fragile operations. **Defines:** BeamProfileRecord, PointingStateRecord, AcquisitionReceipt, TrackingHeartbeat, OcclusionEvent, ReservationReceipt; lifecycle state machine (Idle → Reservation → Acquisition → Tracking → Data → Handover → Tear‑down); timing and heartbeat semantics; privacy knobs. **Interaction (L/S):** L1 BeamID/TightbeamHint, L3 ephemeris hints, L4 DTN reservation references, and ledger anchoring for receipts. **Expanse notes:** Common for ship↔ship and ship↔station links; handover and occlusion are routine. **Records (detailed):** include provenance, freshness, confidence metrics, and optional compact encodings for constrained devices.

### RFC‑2307 — RF Propagation Subprofile (L0)

**Purpose:** Formalize RF behavior: channel profiles, interference models, beaconing, congestion handling, and regulated band semantics. **Why:** RF is the default medium but remains underspecified; explicit rules improve interop and predictable fallback. **Defines:** RFChannelProfileRecord, RFLinkQualityRecord, RFBeaconDescriptor, RFInterferenceEvent, optional RFReservationReceipt for scheduled bands; beaconing and neighbor discovery workflows. **Interaction (L/S):** L1 RFChannelHint, L3 mobility/shadowing hints, L4 congestion policies. **Expanse notes:** RF is noisy, jurisdictionally fragmented, and often the fallback when tightbeam fails.

### RFC‑2308 — Media Privacy & Exposure Policy

**Purpose:** Define exposure rules and access controls for ephemeris, pointing, beaconing, and channel metadata. **Why:** Prevents accidental leakage of operationally sensitive data; balances discoverability and privacy. **Defines:** PolicyRecord fields for L0Profile, exposure levels (public/restricted/private), access control bindings, audit obligations. **Interaction (L/S):** L1 suppression rules and DRE publication policies reference these controls. **Expanse notes:** Different domains (MCRN, OPA, UN) will have divergent defaults.

### RFC‑2309 — L0 Test & Validation Suite

**Purpose:** Provide canonical test cases and validation procedures for L0 behaviors (occlusion, scintillation, interference, timing drift, handover). **Why:** Ensures consistent behavior across implementations and supports interoperability testing. **Defines:** Test harnesses, synthetic scenarios, acceptance criteria, and reconciliation drills. **Interaction (L/S):** Validates L1/L3 behaviors under stress and supports certification.

## L1 — Data‑Link (2350–2359)

### RFC‑2350 — SolNet Canonical Addressing Standard

**Purpose:** Define canonical `<LocationChain> // <ServiceChain>` addressing, L1‑L and L1‑S semantics, TrustTag, QoSClass, TTLs, ProvenancePointer, and parsing rules. **Why:** Provides a single, interoperable addressing contract across heterogeneous domains. **Defines:** Address grammar, `//` semantics, mandatory/optional L1 fields, freshness semantics, and canonical parsing. **Interaction (L/S):** Explicitly separates Location hints (L1‑L) from Service framing (L1‑S). **Tightbeam:** add TightbeamHint, BeamID, ReservationRef semantics. **RF:** add RFChannelHint, RFBeaconHint, RFLinkQualityHint.

### RFC‑2351 — L1 Frame Format: A/N Header Split

**Purpose:** Specify header layout, field ordering, compression rules, and minimal/extended header variants for constrained devices. **Why:** Ensures consistent on‑air framing and efficient parsing across devices. **Defines:** Compact encodings for BeamID, ProvenancePointer, FreshnessTag, ServiceHash, SessionToken, and CompactAuthTag. **Interaction (L/S):** L1‑L and L1‑S fields are encoded to allow role‑based parsing (edge vs relay vs DRE). **Tightbeam/RF:** acquisition freshness tags, channel encoding, interference flags.

### RFC‑2352 — L1 Privacy & Metadata Minimization

**Purpose:** Define which L1 fields are mandatory, optional, or suppressible; provide defaults for personal devices. **Why:** Minimize metadata leakage while preserving reachability and auditability. **Defines:** Suppression rules, light‑client profiles, and fallback behaviors when fields are absent. **Interaction (L/S):** Governs what Location metadata is exposed on the air. **Expanse notes:** Personal devices default to suppressed ephemeris and low AuthorityWeight.

### RFC‑2353 — L1 Relay Advertisement Protocol

**Purpose:** Define how relays advertise capability, AuthorityWeight, supported media, scheduling capacity, and current load. **Why:** Enables dynamic routing, admission control, and reservation negotiation. **Defines:** RelayAdvertisement record, RelayCapability masks, scheduling hints, and admission policy hooks. **Interaction (L/S):** Relays are the operational backbone of the LocationPlane; ServicePlane uses relay info for session continuity. **Tightbeam/RF:** advertise optical terminal capability, supported RF bands, and reservation windows.

## Authority Plane (2360–2389)

### RFC‑2360 — SolNet Layer Model (revised)

**Purpose:** Provide the canonical two‑plane architecture, graded sublayers, and cross‑plane interaction rules. **Why:** Serves as the blueprint for how L0/L1 map to Authority (A‑stack) and Namespace (N‑stack) behaviors. **Defines:** Layer mapping, plane responsibilities, and cross‑plane APIs. **Interaction (L/S):** Central reference for all other RFCs; anchors where media semantics plug into identity and service flows. **Expanse notes:** Must encode policy for partitioned authorities and mobile nodes.

### RFC‑2361 — Identity Resolution (L2)

**Purpose:** Define UUID‑S7, NetworkKey/NetworkCert profiles, LedgerAnchor verification, and conflict resolution procedures. **Why:** Identity is the root of trust for admission, reservation, and ledger anchoring. **Defines:** Identity record formats, verification flows, conflict resolution algorithms, and audit hooks. **Interaction (L/S):** L2 resolves Location identities referenced in L1; ServicePlane may require identity proofs for high‑assurance sessions. **Tightbeam/RF:** verification flows for ReservationReceipt and RFChannelProfileRecord.

### RFC‑2362 — Trust Domains & Authority Policy

**Purpose:** Define trust domain boundaries, certificate issuance rules, cross‑domain trust, and policy records. **Why:** SolNet spans competing jurisdictions; trust must be explicit and auditable. **Defines:** TrustDomain record, issuance rules, cross‑cert chains, and policy enforcement points. **Interaction (L/S):** L2 policies influence L1 admission and L3 DRE trust decisions. **Expanse notes:** Different domains will have different exposure and revocation policies.

### RFC‑2363 — Directory & Routing Endpoints (DRE)

**Purpose:** Define `//info`, `//contact`, ephemeris hint publication, and DRE replication/consistency models. **Why:** DREs are the discovery and reachability backbone for LocationPlane. **Defines:** DREInfoRecord schema, replication rules, freshness semantics, and indexer interactions. **Interaction (L/S):** L1 ProvenancePointer resolves to DRE entries; ServicePlane uses DREs for session bootstrap. **Tightbeam/RF:** publish BeamProfileRecord and RFChannelProfileRecord references with access controls.

### RFC‑2364 — Ephemeris Hint Block Spec

**Purpose:** Standardize coarse and fine ephemeris hint formats for routing and acquisition. **Why:** Acquisition and routing require compact, interoperable ephemeris hints. **Defines:** Hint block formats, binning strategies, confidence metrics, and update cadence. **Interaction (L/S):** L3 publishes hints consumed by L1 and L0 acquisition workflows. **Tightbeam:** acquisition windows and pointing bins. **RF:** mobility and shadowing hints.

### RFC‑2365 — DTN Routing Policy (A4)

**Purpose:** Define bundle addressing, priority classes, store‑and‑forward rules, and reconciliation semantics. **Why:** SolNet is delay‑tolerant; consistent DTN policies are essential for predictable behavior. **Defines:** Bundle metadata, priority/QoS mapping, ProvisionalReceipt semantics, and reconciliation flows. **Interaction (L/S):** Bundles carry both Location and Service metadata; reservation references for tightbeam transfers are included. **Tightbeam:** ReservationRef in bundle metadata. **RF:** congestion‑aware scheduling.

### RFC‑2366 — Ship‑as‑Router Behavior

**Purpose:** Define mobile relay behavior, opportunistic forwarding, and ephemeris‑driven routing. **Why:** Ships are major routing nodes and must behave predictably when mobile. **Defines:** Ship relay policies, handover procedures, and storage/forwarding constraints. **Interaction (L/S):** Ships bridge Location and Service planes while moving; tightbeam handovers and RF channel re‑selection are covered. **Expanse notes:** Frequent topology changes and operator variability.

### RFC‑2367 — Collision Handling & Resolution

**Purpose:** Define formal rules for resolving conflicting identity, DRE, or ledger entries. **Why:** Conflicts are inevitable in a fragmented, delay‑tolerant system. **Defines:** Resolution order, tie‑breaking heuristics, audit trails, and rollback semantics. **Interaction (L/S):** Applies to L2 identity conflicts and L3 DRE inconsistencies; receipts and timestamps are primary inputs.

### RFC‑2368 — Revocation & Emergency Unbinding

**Purpose:** Define emergency revocation, unbinding procedures, and propagation rules. **Why:** Compromise and emergency scenarios require fast, auditable unbinding. **Defines:** Revocation record formats, emergency unbind flows, and fallback defaults for offline relays. **Interaction (L/S):** Revocation affects L1 admission and L3 DRE trust; ledger anchoring is required for high‑assurance revocations.

## Namespace Plane (2390–2419)

### RFC‑2390 — Local Namespace Resolution (N2)

**Purpose:** Define how ServiceChain resolves inside a domain, including local policy overrides. **Why:** Local naming must be consistent and predictable for services. **Defines:** Local resolver APIs, caching rules, and conflict handling.

### RFC‑2391 — Local Directory & Service Discovery (N3)

**Purpose:** Define service advertisement, capability descriptors, TTLs, and discovery protocols. **Why:** ServicePlane discovery must be interoperable across devices and domains. **Defines:** ServiceDescriptor schema, discovery APIs, and access controls.

### RFC‑2392 — Session & Conversation Layer (N4)

**Purpose:** Define session framing, QoS, retries, session tokens, and local continuity semantics. **Why:** Sessions must survive intermittent links and device mobility. **Defines:** SessionToken formats, session resumption rules, and QoS mapping.

### RFC‑2393 — Local Security & ACLs (N5)

**Purpose:** Define per‑service authentication, roles, ACL formats, and local revocation. **Why:** Local services need fine‑grained access control independent of global identity. **Defines:** ACL schema, enforcement hooks, and audit obligations.

### RFC‑2394 — Personal Namespace & Identity (PNI)

**Purpose:** Define PNI format, device/user binding, ephemeral keys, and privacy defaults. **Why:** Personal devices are ubiquitous and require standardized identity and privacy behavior. **Defines:** PNI record, DelegationToken format for relay‑assisted acquisition, ephemeral key lifecycle. **Interaction (L/S):** PNI anchors ServicePlane identity and ties into L1 suppression rules. **Tightbeam/RF:** relay delegation tokens and suppressed ephemeris defaults.

### RFC‑2395 — Personal Device Integration

**Purpose:** Define device profiles, AuthorityWeight/NamespaceWeight defaults, and constrained‑device behavior. **Why:** Belter slabs, hand terminals, and cheap radios dominate the network and must interoperate. **Defines:** DeviceRole profiles, compact receipt encodings, relay‑assisted acquisition flows, and conservative defaults for provisional acceptance. **Tightbeam:** compact AcquisitionReceipt and ReservationReceipt handling. **RF:** beaconing defaults and congestion fallback.

### RFC‑2396 — Internamespace Gateway Behavior

**Purpose:** Define gateway translation, proxying, and cross‑domain service mapping. **Why:** Gateways mediate between incompatible local namespaces and policy domains. **Defines:** Translation rules, policy mapping, and audit obligations.

## Cross‑plane & Operational (2420–2449)

### RFC‑2420 — Bundle Addressing Protocol (cross‑plane)

**Purpose:** Define canonical bundle format that carries both Authority and Namespace metadata. **Why:** Bundles are the primary vehicle for delay‑tolerant transfers and must carry both planes’ context. **Defines:** Bundle envelope, metadata fields (ReservationRef, ProvenancePointer), and canonical serialization.

### RFC‑2421 — Error Codes & Diagnostics

**Purpose:** Define a standard error taxonomy, diagnostic fields, and forensic logging formats. **Why:** Consistent diagnostics are essential for debugging and forensics across domains. **Defines:** Error codes, severity classes, and diagnostic payloads.

### RFC‑2422 — Mobility Hint Block

**Purpose:** Define mobility hint encoding, update cadence, and confidence metrics. **Why:** Mobility hints improve routing and acquisition decisions for moving nodes. **Defines:** MobilityHint schema and update rules.

### RFC‑2423 — Caching, Deduplication & Bloom Filters

**Purpose:** Define cache policies, deduplication strategies, and seen‑packet filters. **Why:** Prevents wasteful retransmission and reduces storage pressure on relays. **Defines:** Cache eviction policies, bloom filter parameters, and chunking strategies.

### RFC‑2424 — Emergency Burst Protocols

**Purpose:** Define high‑priority burst mechanisms, propagation rules, and abuse controls. **Why:** Supports life‑safety and emergency traffic without destabilizing the network. **Defines:** Burst admission rules, priority mapping, and audit trails.

## Security, Governance, Compliance (2450–2479)

### RFC‑2450 — Trust‑Domain Enforcement & Auditing

**Purpose:** Define enforcement model for cross‑domain policy, audit obligations, and compliance checks. **Why:** Ensures accountability across competing jurisdictions. **Defines:** AuditEvent schema, enforcement hooks, and compliance reporting.

### RFC‑2451 — Hardware Root & Secure Element Requirements

**Purpose:** Define minimum hardware security requirements for high‑Authority nodes and secure elements. **Why:** Hardware roots reduce risk of key compromise and improve trust. **Defines:** Secure element profiles, attestation flows, and provisioning rules.

### RFC‑2452 — Post‑Quantum Crypto Migration Plan

**Purpose:** Define migration timelines, algorithm profiles, and key lifetimes for post‑quantum readiness. **Why:** Long‑lived systems must plan migration to post‑quantum algorithms. **Defines:** Migration phases, algorithm recommendations, and compatibility guidance.

### RFC‑2453 — Privacy & Metadata Minimization Policy

**Purpose:** Define system‑wide privacy defaults, opt‑in rules, and metadata minimization principles. **Why:** Protects users and operations from unnecessary exposure. **Defines:** Default exposure levels, opt‑in mechanisms, and audit requirements.

## Developer & Game Integration (2480–2499)

### RFC‑2480 — Device Role Weights & Profiles

**Purpose:** Define AuthorityWeight and NamespaceWeight profiles for common device classes (handheld, relay, ship, station). **Why:** Standardizes expectations for behavior and admission. **Defines:** Role profiles, default QoS mappings, and device capabilities.

### RFC‑2481 — Minimal Viable DTN for Prototyping

**Purpose:** Provide a lightweight DTN spec for rapid prototyping and gameplay. **Why:** Enables fast iteration and playable prototypes without full stack complexity. **Defines:** Minimal bundle format, simple store‑and‑forward rules, and compact receipts.

### RFC‑2482 — Mission & Scenario Generator API

**Purpose:** Provide procedural network generation for gameplay scenarios and testing. **Why:** Automates scenario creation for testing and game content. **Defines:** Scenario schema, generator APIs, and seedable randomness.

### RFC‑2483 — Forensics & Evidence Preservation

**Purpose:** Define how cached bundles, logs, and traces are preserved, validated, and presented for audit. **Why:** Forensics are essential for accountability and gameplay investigation mechanics. **Defines:** Evidence formats, chain‑of‑custody fields, and verification flows.

## Cross‑references, records, and APIs (summary)

- **Canonical L0 records:** BeamProfileRecord, PointingStateRecord, AcquisitionReceipt, TrackingHeartbeat, OcclusionEvent, ReservationReceipt, RFChannelProfileRecord, RFLinkQualityRecord, RFInterferenceEvent. All include provenance, freshness, and confidence metrics.
    
- **L1 fields to add:** TightbeamHint, BeamID, ReservationRef, RFChannelHint, RFBeaconHint, RFLinkQualityHint, ProvenancePointer, FreshnessTag, CompactAuthTag.
    
- **APIs to define:** `POST /l0/reservations`, `GET /l0/reservations/<id>`, `POST /l0/acquire`, `GET /l0/pointing/<BeamID>`, `POST /l0/occlusion`, DRE `GET /dres/<LocationChain>//info`, relay admission endpoints, indexer query endpoints.
    
- **Ledger flows:** ProvenancePointer → DREInfoRecord → LedgerAnchor/NetworkCert verification; ReservationReceipt and AcquisitionReceipt must support ledger‑anchored verification for high‑assurance operations.
    
- **DTN integration:** Bundles carry ReservationRef and ProvenancePointer; ProvisionalReceipt semantics and reconciliation flows are mandatory.
    

## Rationale: why each RFC exists and what puzzle piece it fills

- **Terminology & Layer Model (2300/2360):** provide the shared mental model so every other RFC plugs into the same architecture.
    
- **Crypto & Ledger (2301/2302):** provide the trust fabric and authoritative anchors for identity, receipts, and revocation.
    
- **L0 media subprofiles (2303–2309):** capture physics and operational semantics that materially change higher‑layer behavior (tightbeam vs RF).
    
- **L1 framing and privacy (2350–2353):** define the on‑air contract and what metadata is safe to expose.
    
- **DRE, Ephemeris, DTN (2363–2365):** provide discovery, acquisition hints, and delay‑tolerant routing primitives.
    
- **Device profiles and PNI (2394–2395):** standardize behavior for the most numerous and least reliable nodes.
    
- **Operational, security, and developer RFCs (2420–2483):** provide the glue for testing, governance, and game integration.
    

Each RFC is included because it removes an ambiguity or gap that would otherwise force ad‑hoc, incompatible implementations—especially important in The Expanse setting where devices, operators, and policies vary wildly.

## Implementation priorities (practical roadmap)

1. **RFC‑2306 (Tightbeam Subprofile)** — defines records and workflows that other docs reference.
    
2. **RFC‑2350 (L1 Canonical Addressing)** — integrate BeamID/TightbeamHint and RF hints into the on‑air contract.
    
3. **RFC‑2370 (Relay Admission & Scheduling API)** — reservation endpoints and receipts for tightbeam and scheduled RF.
    
4. **RFC‑2361 (Identity Resolution)** — ledger verification flows for receipts.
    
5. **RFC‑2481 (Minimal DTN)** — prototype DTN bundles with ReservationRef support for rapid testing.
    
6. **RFC‑2394 (Personal Device Profile)** — delegation tokens and compact receipts for constrained devices.
    
7. **RFC‑2309 (L0 Test Suite)** — interoperability and stress tests.
    

## Open decisions to resolve in companion RFCs

- Exact wire encodings and field sizes for BeamID, ReservationRef, and compact pointing hints (RFC‑2360 / RFC‑2360 subsection).
    
- DelegationToken format and minimal fields for constrained devices (RFC‑2394).
    
- Recommended freshness window durations for AcquisitionReceipt and ReservationReceipt (domain policy vs recommended defaults).
    
- Default privacy posture per trust domain (RFC‑2308 / RFC‑2453).
    

This canonical page will be used as the persistent project memory for all future drafting, testing, and gameplay design. Which RFC should I draft into a full, ready‑to‑review spec next: **RFC‑2306 (Tightbeam Subprofile)** to lock the L0 semantics, or **RFC‑2350 (L1 Canonical Addressing)** to lock the on‑air contract and header changes?



Short answer: **Treat proximity “flick” transfers as a first‑class local L0 subprofile** (Proximal Link / ProxLink) that lives _beside_ RF and tightbeam, not buried in the global LocationPlane. Make it lightweight, privacy‑first, and explicitly local so it doesn’t pollute L1/L2 semantics — but define canonical records, receipts, and verification flows so game logic, audit, and exploits are well‑scoped and testable.

Below is a complete design brief you can drop into the RFC todo memory: why this exists, how it maps to Location/Service, exact records and APIs, workflows, security tradeoffs, integration points to change, and suggested game‑play hooks (exploits/puzzles).

### Why we need a Proximal Link subprofile

- **Fidelity to the fiction.** “Flicking” files in The Expanse is a local, physical‑proximity action; modeling it as a separate local link preserves the feel and constraints (line‑of‑sight, short range, opportunistic).
    
- **Simplicity and privacy.** Proximity transfers should not require global identity, ledger anchoring, or ephemeris. Keeping them local reduces metadata leakage and avoids unnecessary ledger churn.
    
- **Interoperability and audit.** If every vendor invents their own “flick” protocol, gameplay and forensic mechanics break. A canonical ProxLink gives consistent receipts and verification for later reconciliation.
    
- **Practical constraints.** Devices in the setting are heterogeneous and often offline; a lightweight local protocol with optional escalation to relays fits that reality.
    

## How ProxLink fits into Location/Service

- **Primary plane:** _ServicePlane (local)_ — discovery, session, and transfer semantics live in S‑stack.
    
- **Location exposure:** Minimal L1 hints only when necessary (e.g., `ProxBeacon` may include a short ephemeral UUID hint). Do **not** publish ephemeris or ledger pointers by default.
    
- **When to touch LocationPlane / Ledger:** Only when a transfer must be anchored (e.g., legal evidence, high‑value asset). In that case the client or a trusted relay can optionally anchor a `ProxTransferReceipt` to the ledger via L2 flows.
    
- **Fallbacks:** If ProxLink fails (range, interference), fall back to RF or DTN store‑and‑forward; those fallbacks are orchestrated by the ServicePlane session logic.
    

## Recommended RFC additions / edits (minimal list)

1. **New L0 RFC (ProxLink Subprofile)** — canonical records, discovery, handshake, transfer, receipts, privacy knobs. (Place in 2306–2319 block.)
    
2. **RFC‑2350 (L1)** — add a tiny `ProxHint` flag and ephemeral `ProxID` encoding so relays and edge nodes can recognize ProxLink frames without exposing location. `ProxHint` is optional and suppressed by default.
    
3. **RFC‑2394 / RFC‑2395 (PNI / Device Profiles)** — add ProxLink capability flags and user confirmation UX defaults (physical confirmation required for high‑value transfers).
    
4. **RFC‑2309 (L0 Test Suite)** — add ProxLink test cases (range, interference, spoofing, replay).
    
5. **RFC‑2361 (Identity)** — optional ledger anchoring flow for `ProxTransferReceipt` when transfers must be auditable.
    

## Canonical ProxLink records and fields (detailed)

All ProxLink records are compact, ephemeral, and include **provenance** and **freshness** fields. Constrained encodings allowed.

- **ProxBeacon** (advertisement)
    
    - **ProxID**: ephemeral short ID (e.g., 16‑bit or compressed UUID hint)
        
    - **ServiceCaps**: list of offered service types (file‑share, clipboard, presence)
        
    - **TTL**: short lifetime (seconds)
        
    - **TrustHint**: optional (e.g., `user‑confirmed`, `unverified`)
        
    - **CompactAuthTag**: optional MAC for local integrity
        
- **ProxDiscoveryResponse**
    
    - **ProxID**, **ServiceCaps**, **DeviceName** (user‑friendly), **Confidence** (RSSI/TOF), **Nonce**
        
- **ProxHandshake** (mutual challenge)
    
    - **SessionID**: ephemeral session token
        
    - **NonceA/NonceB**: anti‑replay nonces
        
    - **RequestedAction**: e.g., `filePush`, `clipboardPush`, `pair`
        
    - **AuthProof**: short signature or MAC (optional; required for higher assurance)
        
- **ProxTransferDescriptor**
    
    - **SessionID**, **FileHash**, **Size**, **ChunkingHints**, **TransferMode** (`push`/`pull`/`chunked`)
        
    - **TransferPolicy**: e.g., `requirePhysicalConfirm`, `autoAcceptSmall`
        
    - **ReservationRef**: optional if transfer uses a scheduled window (rare)
        
- **ProxTransferReceipt** (issued by receiver)
    
    - **SessionID**, **FrameID** (or chunk range), **ReceiverID (ephemeral)**, **Timestamp**, **Status** (`accepted`, `deferred`, `rejected`), **Signature/MAC** (if available)
        
    - **Optional LedgerPointer**: pointer to ledger anchor if later anchored
        
- **ProxAuditEvent** (local log)
    
    - **SessionID**, **ProxIDs involved**, **OperatorAction** (physical confirm, override), **Timestamps**, **EvidenceRefs** (screenshots, operator notes)
        

## ProxLink workflows (clear, procedural, narrative)

### 1. Quick flick (ad‑hoc push)

1. **Advertise:** Sender emits `ProxBeacon` for a few seconds while user selects file.
    
2. **Discovery:** Receiver sees beacon, shows a compact UI with `DeviceName` and `Confidence` (RSSI/TOF).
    
3. **Handshake:** Receiver taps “Accept” → device sends `ProxHandshake` with `NonceB`. Sender responds with `NonceA` and `TransferDescriptor`.
    
4. **Physical confirmation:** If `TransferPolicy=requirePhysicalConfirm`, receiver must press a hardware button or scan a QR on the sender.
    
5. **Transfer:** Sender streams chunks; receiver emits `ProxTransferReceipt` per chunk or at end.
    
6. **Local audit:** Both devices log `ProxAuditEvent`. Optionally, receiver anchors `ProxTransferReceipt` to ledger via a relay if required.
    

**Behavior under stress:** If interference or range drop occurs, sender retries chunked transfer; if persistent, both sides emit `ProvisionalReceipt` and store partial chunks for DTN reconciliation.

### 2. Console‑to‑console flick (trusted environment)

- Consoles on the same ship advertise `ProxBeacon` with `TrustHint=user‑confirmed`. Handshake may skip physical confirmation if local policy allows. Transfers are logged and optionally anchored to local station DRE for audit.
    

### 3. Delegated flick (constrained device)

- A wrist terminal delegates to a nearby relay: device issues a `DelegationToken` (short‑lived) to relay; relay performs ProxLink handshake on device’s behalf and returns `ProxTransferReceipt` to device. Delegation receipts are auditable and short‑lived.
    

## Security, privacy, and failure modes (and mitigations)

- **Eavesdropping / interception:** ProxLink is short‑range but not immune. Use short session tokens, chunked transfers, and optional encryption (session keys derived from handshake nonces). For high‑value transfers require physical confirmation.
    
- **Replay / injection:** Nonces and short TTLs prevent replay; chunk sequence numbers and per‑chunk MACs prevent injection.
    
- **Impersonation / spoofing:** Use user confirmation (button press, QR scan, ultrasonic handshake) for higher assurance. Optionally require a signature from PNI if both parties are ledger‑anchored.
    
- **Relay‑as‑man‑in‑the‑middle:** Delegation tokens must be scoped and short‑lived; audit logs must record delegation events.
    
- **Privacy leakage:** Default suppression of ProxID in beacons for personal devices; show only `DeviceName` and confidence. PolicyRecords control exposure.
    

## Verification and audit model

- **Local audit first:** `ProxAuditEvent` stored locally with timestamps and evidence.
    
- **Optional escalation:** If legal or high‑value, a device or operator can submit `ProxTransferReceipt` to a relay which anchors it to the ledger (RFC‑2361 flow). Ledger anchoring is explicit and requires user consent.
    
- **Reconciliation:** If a transfer is disputed, combine local `ProxAuditEvent`, `ProxTransferReceipt`, and any relay Admission/Forwarding receipts to reconstruct the session.
    

## Integration points and RFC edits (concrete)

- **Add ProxLink Subprofile RFC (2306)** with full records and workflows above.
    
- **RFC‑2350:** add `ProxHint` and `ProxID` encodings; mark them optional and suppressed by default.
    
- **RFC‑2351:** add compact encodings for Prox records and chunking hints.
    
- **RFC‑2394/2395:** add DelegationToken semantics and UI/UX defaults (physical confirmation required for certain classes).
    
- **RFC‑2309:** add ProxLink test cases (range, spoof, replay, partial transfer).
    
- **RFC‑2361:** define optional ledger anchoring flow for `ProxTransferReceipt`.
    

## 

## Implementation checklist (practical)

- Draft **RFC‑2306 ProxLink Subprofile** with records and workflows above.
    
- Add `ProxHint`/`ProxID` to **RFC‑2350** and compact encodings to **RFC‑2351**.
    
- Update **RFC‑2394/2395** for DelegationToken and UI defaults.
    
- Add ProxLink tests to **RFC‑2309**.
    
- Add ledger anchoring flow to **RFC‑2361** (optional path).

# ### Point‑Defense (Ship) — Todo spec (ServicePlane + L0 hooks)

**Purpose** Define a canonical Ship Point‑Defense (PD) Service that standardizes sensor feeds, engagement commands, handover, admission, and audit for ship‑local PD systems.

**Why this RFC** PD actions are time‑sensitive, safety‑critical, and cross‑system (sensors → decision → actuators). Without a canonical spec, implementations will be incompatible, forensics will fail, and cross‑ship handoffs will be unsafe.

**Scope and placement**

- Primary: **ServicePlane** RFC (new: Ship PD Service).
    
- Cross references: L0 subprofiles (tightbeam, RF), L1 fields (CommNetID, PDPriority), Identity (ledger verification for cross‑domain commands), DTN (reconciliation).
    

**What it defines**

- **PDServiceDescriptor** schema (`//pd`): ShipID; CommNetID; PDCapabilities; SensorFeeds; AuthPolicy; QoSProfile; LocalDRERef.
    
- **PDCommand** message: CommandID; TargetHash; Action; PDPriority; IssuerID; SessionToken; Timestamp; Signature.
    
- **Admission/Forwarding receipts:** PDAdmissionReceipt; PDForwardingReceipt (include path trace).
    
- **Handoff messages:** PDHandoffProposal; PDHandoffReceipt; ReservationRef (if tightbeam control link used).
    
- **AuditEvent** schema: PDAuditEvent linking commands, receipts, sensor evidence, operator actions.
    

**APIs and endpoints**

- `POST /pd/command` — submit PDCommand; returns PDAdmissionReceipt or ProvisionalReceipt.
    
- `POST /pd/handoff` — propose handoff to another ship; returns PDHandoffReceipt.
    
- `GET /pd/service` — fetch PDServiceDescriptor (access controlled).
    
- `POST /pd/audit` — submit PDAuditEvent (local log or relay anchor).
    

**Workflows (must include)**

- **Local engage:** sensor → local PD controller → PDCommand → immediate AdmissionReceipt → actuator engagement → PDAuditEvent.
    
- **Ship→ship handoff:** PDHandoffProposal → Reservation (if needed) → PDHandoffReceipt → TrackingHeartbeat → handoff execution.
    
- **Fallbacks:** if tightbeam reservation fails, fallback to RF control or DTN queued command with ProvisionalReceipt.
    

**Timing & QoS**

- Define PDPriority mapping to L1 QoSClass and L4 DTN priority.
    
- Define maximum acceptable command latency per PDPriority (e.g., high: <100 ms local; medium: <1 s; low: best effort).
    

**Security & governance**

- All PDCommand and receipts **MUST** be signed; high‑assurance cross‑domain commands require ledger‑anchored proofs or cross‑cert chains.
    
- Default policy: **local control precedence** for life‑safety; external commands require explicit policy.
    
- Emergency unbind and revocation flows per RFC‑2368.
    

**Testing & validation**

- Latency drills, handoff drills with occlusion injection, jamming/spoofing tests, conflict resolution scenarios, forensic reconstruction exercises.
    

**Tradeoffs**

- Ledger anchoring provides auditability but adds latency and cost; use only for cross‑domain or post‑incident evidence.
    
- Aggressive automation reduces operator load but increases risk of false engagements; require operator override thresholds.
    

### Fleet Point‑Defense Coordination — Todo spec (Cross‑plane / Authority)

**Purpose** Standardize multi‑ship PD coordination: shared sensor feeds, target handoff, cross‑authority command validation, and conflict resolution.

**Why this RFC** Fleet coordination crosses trust domains and requires explicit policy, trust anchors, and auditable command trails to avoid catastrophic misfires and to enable post‑incident accountability.

**Scope and placement**

- Primary: **Authority / Cross‑plane** RFC (Fleet PD Coordination).
    
- Cross references: Ship PD Service, Identity (L2), Ledger (anchoring), Trust Domains (policy).
    

**What it defines**

- **FleetPDDescriptor:** FleetID; PolicyProfile; SharedSensorCatalog; CrossCertRules; ConflictResolutionPolicy.
    
- **FleetPDCommand** envelope: CommandID; FleetContext; IssuerAuthority; RequiredProofs; Timestamp; Signature.
    
- **Handoff & arbitration messages:** FleetHandoffProposal; FleetHandoffArbitrate; FleetCommandAudit.
    

**Protocols**

- **Shared feed subscription:** secure subscription model with access tokens and feed QoS.
    
- **Cross‑cert verification flow:** ProvenancePointer → DRE → LedgerAnchor verification steps for accepting external commands.
    
- **Conflict resolution algorithm:** deterministic tie‑breaker (TrustTag weight, timestamp, explicit fleet policy), with mandatory PDAuditEvent generation.
    

**Operational rules**

- **Authority precedence:** fleet policy defines which authorities can override local ship control and under what conditions (e.g., declared engagement zone).
    
- **Escalation:** emergency override requires multi‑party signatures or pre‑authorized delegation tokens.
    

**Audit & forensics**

- All cross‑domain commands **MUST** produce Admission/Forwarding receipts and be logged as FleetCommandAudit; ledger anchoring recommended for high‑impact commands.
    

**Testing**

- Multi‑authority conflict drills, delayed ledger anchoring reconciliation, cross‑domain handoff under partition.
    

**Tradeoffs**

- Strong cross‑domain controls increase safety but slow decision loops; design for graceful degradation to local autonomy under partition.
    

### Suit‑to‑Suit / ProxLink (Body Area Network) — Todo spec (L0 local + ServicePlane UX)

**Purpose** Provide a canonical, privacy‑first local protocol for suit‑to‑suit transfers (files, presence, voice), wearable telemetry, and emergency simplex channels.

**Why this RFC** “Flick” transfers and wearable comms are ubiquitous in the fiction; a canonical spec prevents vendor lock‑in, supports audit when needed, and keeps global metadata exposure minimal.

**Scope and placement**

- Primary: **L0 ProxLink / BAN Subprofile** RFC.
    
- Cross references: L1 ProxHint/ProxID, PNI (PNI/Device Profiles), DelegationToken flows, optional ledger anchoring.
    

**What it defines**

- **ProxBeacon / ProxHandshake / ProxTransferDescriptor / ProxTransferReceipt** records (compact encodings).
    
- **SuitProfileRecord:** DeviceRole, PowerClass, AntennaType, EmergencyChannelCaps, UIConfirmPolicy.
    
- **DelegationToken** format for relay‑assisted transfers.
    

**APIs & messages**

- Local discovery: `ProxBeacon` broadcast.
    
- Handshake: mutual nonce exchange, derive ephemeral session key.
    
- Transfer: chunked push/pull with per‑chunk receipts.
    
- Audit: `ProxAuditEvent` local log; optional `POST /prox/anchor` to relay for ledger anchoring.
    

**Workflows**

- **Quick flick:** ProxBeacon → Discovery → Handshake → Physical confirm (if required) → Transfer → ProxTransferReceipt → local audit.
    
- **Delegated push:** constrained device issues DelegationToken to relay; relay performs ProxLink handshake and returns DelegationReceipt.
    

**Security & privacy**

- Default: **ProxID suppressed**, ProxBeacon minimal; require physical confirmation for files above threshold.
    
- Use ephemeral session keys; nonces and chunk MACs to prevent replay/injection.
    
- DelegationTokens short‑lived and scoped.
    

**Testing**

- Range and TOF validation, spoofing/replay tests, partial transfer and ProvisionalReceipt reconciliation.
    

**Tradeoffs**

- Local simplicity vs forensic traceability: ledger anchoring is opt‑in and expensive; keep default local and private.
    

### Tactical Comm‑Net Mesh (Ad‑hoc RF Mesh) — Todo spec (ServicePlane overlay + L0 specifics)

**Purpose** Define a canonical tactical mesh profile for small‑unit or squad‑level comm nets: discovery, mesh formation, group addressing, multicast, routing, and emergency broadcast.

**Why this RFC** Ad‑hoc tactical nets must interoperate across vendors, support constrained devices, and provide robust fallback under jamming and mobility.

**Scope and placement**

- Primary: **ServicePlane** spec for tactical comm nets (CommNet Service).
    
- L0: RF BAN and RF Propagation subprofile notes (body shadowing, mesh link budgets).
    
- Cross refs: GroupJoin APIs (Relay Admission), PNI/SuitProfile, DTN for delayed sync.
    

**What it defines**

- **CommNetAdvert**: CommNetID; GroupID; QoSClass; AuthPolicy; LocalDRERef.
    
- **GroupJoinRequest / GroupJoinReceipt**: SessionID; GroupID; Role; ShortAuthProof; Expiry.
    
- **Multicast envelope**: GroupID; Sequence; Priority; Signature/MAC.
    
- **Mesh routing hints**: neighbor metrics (RSSI, latency), hop limits, preferred relay IDs.
    

**Protocols**

- **Mesh formation:** neighbor discovery → link quality exchange → routing table formation (lightweight OLSR variant or reactive mesh).
    
- **Group management:** join/leave, role assignment (leader, relay, observer), rekeying for group encryption.
    
- **Emergency broadcast:** reserved high‑priority channel with preemption rules and AdmissionReceipts.
    

**Security**

- Group keys with periodic rekeying; DelegationTokens for temporary nodes; hardware root recommended for key protection.
    
- Jamming detection and channel hopping policies; fallback to ProxLink or wired when available.
    

**Workflows**

- **Squad formation:** devices discover CommNetAdvert → GroupJoinRequest → GroupJoinReceipt → mesh routing established.
    
- **Tactical data flow:** multicast telemetry, voice, and short PD commands mapped to PDPriority→QoSClass.
    

**Testing**

- Mesh formation under mobility, rekeying under node compromise, jamming resilience, multicast reliability tests.
    

**Tradeoffs**

- Mesh routing overhead vs battery life; recommend adaptive duty cycles and role rotation to conserve power.
    

### Cross‑cutting implementation checklist (practical)

1. Draft **ProxLink / Suit BAN RFC** (records, handshakes, test cases).
    
2. Draft **Ship PD Service RFC** (Service descriptors, PDCommand, receipts, handoff).
    
3. Draft **Fleet PD Coordination RFC** (cross‑domain policy, verification, conflict resolution).
    
4. Draft **Tactical CommNet Service RFC** (mesh formation, group join, multicast, emergency broadcast).
    
5. Update **RFC‑2350/2351** with ProxHint/ProxID, CommNetID, PDPriority, GroupID encodings.
    
6. Update **RFC‑2370** with group join, PD reservation, and emergency broadcast endpoints.
    
7. Update **RFC‑2361 / RFC‑2302** for ledger anchoring flows for PD and ProxTransfer receipts.
    
8. Add test cases to **RFC‑2309** for suit BAN, PD handoff, fleet conflict, and mesh resilience.
    

Which of these three specs should I draft first into a full RFC section with field schemas and example messages: **ProxLink (suit BAN)**, **Ship Point‑Defense Service**, or **Tactical Comm‑Net Mesh**?

Building on the ProxLink, Ship PD, Fleet PD, and Tactical Comm‑Net work we sketched, here’s a focused, actionable **todo spec** that covers **ship↔ship links (including SOS/emergency transponder), ship PD nets, fleet PD coordination, suit‑to‑suit**, and the **tactical mesh** — with exact records, APIs, workflows, security controls, tests, and integration points so nothing is left vague.

### 1 Ship‑to‑Ship Link and Emergency SOS (L0 + ServicePlane hooks)

**Purpose:** canonical ship↔ship transport and emergency channel (SOS) with verifiable transponder identity, optional ledger anchoring, and explicit spoofing/manipulation controls.

**Why:** ship↔ship is the highest‑value, time‑sensitive link (docking, handoff, SOS). It must support authenticated squawks, emergency preemption, and forensic traceability while allowing plausible in‑fiction tampering.

**Records / Fields**

- **ShipTransponderRecord** — ShipID; TransponderID; RegistryPointer (local ship registry or DRE); CertFingerprint; LastSeen; StatusFlags (active, tampered, revoked).
    
- **ShipSquawk** — SquawkID; FromShipID; ToShipID (optional broadcast); CommNetID; EmergencyLevel (SOS, MAYDAY, PAN); Timestamp; TransponderProof (signature or MAC); ShortNonce.
    
- **TransponderVerificationReceipt** — SquawkID; VerifierID; RegistryCheckResult; TrustTag; Timestamp; Signature.
    
- **TransponderManipulationEvent** — ShipID; ObservedAnomaly; EvidenceRefs; OperatorAction; Timestamp.
    

**APIs / Endpoints**

- `POST /ship/squawk` — send squawk; returns `TransponderVerificationReceipt` or `ProvisionalReceipt`.
    
- `GET /ship/transponder/<TransponderID>` — fetch ShipTransponderRecord (access controlled).
    
- `POST /ship/transponder/verify` — verifier (receiving ship or DRE) posts verification result.
    
- `POST /ship/transponder/report` — report manipulation or spoofing to local DRE and optionally anchor to ledger.
    

**Workflows**

- **Normal squawk:** ship A emits `ShipSquawk` (signed by transponder key). Receiving ship B performs `TransponderVerificationReceipt` by checking `RegistryPointer` → DRE → LedgerAnchor if required; if verified, B responds with acceptance and opens comm channel.
    
- **SOS fast path:** `ShipSquawk` with `EmergencyLevel=SOS` is treated as preemptive: local PD and comm stacks prioritize it; receiving ship emits immediate `ProvisionalReceipt` and begins rescue coordination. Ledger anchoring optional post‑fact.
    
- **Tamper detection:** if verification fails or registry mismatch, receiving ship emits `TransponderManipulationEvent` and may request additional evidence (radar signature, visual confirmation).
    

**Security & manipulation model**

- **Transponder keys**: short‑lived transponder certificates issued by ship registry (onboard CA) or fleet CA; support for hardware root attestation recommended.
    
- **Registry models:** local ship registry for immediate checks; DRE/ledger anchoring for cross‑domain verification. Allow offline verification via cached registry fingerprints with freshness tags.
    
- **Tampering (Naiomi style):** define `TransponderManipulationEvent` semantics and operator actions (override, quarantine, revoke). Provide explicit `RevocationReceipt` flow to propagate emergency unbinds.
    

**Timing & QoS**

- SOS squawks map to highest L1 QoSClass and PDPriority; preemption rules in ServicePlane and PD nets.
    

**Tests**

- Squawk verification under ledger partition; spoofed transponder injection; emergency preemption under heavy load; tamper injection and revocation propagation.
    

### 2 Ship Point‑Defense (Ship PD Service) — todo spec (ServicePlane)

**Purpose:** local PD service for detection→decision→engage with receipts, handoff, and audit.

**Key records**

- **PDServiceDescriptor (**`//pd`**)** — ShipID; CommNetID; PDCapabilities; SensorFeeds; AuthPolicy; QoSProfile.
    
- **PDCommand** — CommandID; TargetHash; Action; PDPriority; IssuerID; SessionToken; Timestamp; Signature.
    
- **PDAdmissionReceipt / PDForwardingReceipt** — include path trace and TrustTag.
    

**APIs**

- `POST /pd/command` — submit PDCommand.
    
- `POST /pd/handoff` — propose handoff to another ship.
    
- `GET /pd/service` — fetch PDServiceDescriptor.
    
- `POST /pd/audit` — submit PDAuditEvent.
    

**Workflows**

- Local engage, ship→ship handoff (tightbeam control link with ReservationRef), fallback to RF/DTN with ProvisionalReceipts.
    

**Security**

- Signed PDCommands; local control precedence; ledger anchoring for cross‑domain or high‑impact commands.
    

**Tests**

- Handoff under occlusion; PDCommand latency under jamming; conflict resolution when two authorities issue commands.
    

### 3 Fleet Point‑Defense Coordination — todo spec (Cross‑plane / Authority)

**Purpose:** multi‑ship coordination, shared sensor feeds, cross‑authority command validation, and conflict resolution.

**Key records**

- **FleetPDDescriptor** — FleetID; PolicyProfile; SharedSensorCatalog; CrossCertRules.
    
- **FleetPDCommand** — CommandID; FleetContext; IssuerAuthority; RequiredProofs; Signature.
    
- **FleetHandoffProposal / FleetHandoffArbitrate** — for cross‑ship target handoff.
    

**Protocols**

- ProvenancePointer → DRE → LedgerAnchor verification for accepting external commands.
    
- Deterministic conflict resolution (TrustTag weight, timestamp, explicit fleet policy).
    

**Governance**

- Define which authorities can override local ship control and under what conditions; emergency override requires multi‑party signatures or pre‑authorized delegation tokens.
    

**Tests**

- Multi‑authority conflict drills; delayed ledger anchoring reconciliation.
    

### 4 Suit‑to‑Suit (ProxLink / BAN) — todo spec (L0 local + ServicePlane UX)

**Purpose:** canonical local transfers (flicks), wearable telemetry, emergency simplex.

**Key records** (compact)

- **ProxBeacon** — ProxID (ephemeral); ServiceCaps; TTL; TrustHint.
    
- **ProxHandshake** — SessionID; Nonces; RequestedAction; AuthProof.
    
- **ProxTransferDescriptor / ProxTransferReceipt** — chunking hints, per‑chunk receipts.
    
- **ProxAuditEvent** — local log; optional ledger pointer.
    

**APIs / UX**

- Local discovery, physical confirmation UI, optional DelegationToken for relay‑assisted transfers.
    

**Security**

- Ephemeral session keys; physical confirmation for high‑value transfers; default ProxID suppression.
    

**Tests**

- Range/TOF spoofing, replay, partial transfer reconciliation.
    

### 5 Tactical Comm‑Net Mesh (Ad‑hoc RF Mesh) — todo spec (ServicePlane overlay)

**Purpose:** squad/small‑unit mesh: discovery, group join, multicast, routing, emergency broadcast, rekeying.

**Key records**

- **CommNetAdvert** — CommNetID; GroupID; QoSClass; AuthPolicy.
    
- **GroupJoinRequest / GroupJoinReceipt** — SessionID; Role; ShortAuthProof.
    
- **MulticastEnvelope** — GroupID; Sequence; Priority; MAC.
    

**Protocols**

- Lightweight mesh routing (reactive or simplified OLSR), group key management, periodic rekeying, emergency broadcast preemption.
    

**Security**

- Group keys, DelegationTokens for temporary nodes, hardware root recommended.
    

**Tests**

- Mesh formation under mobility, jamming resilience, multicast reliability.
    

### 6 Integration, addressing, and multiple addressing mechanisms

**Multiple addressing mechanisms:** support `ship1//`, `fleet//`, `fleet-ship1//`, `CommNetID//service`, and ephemeral ProxIDs. All are valid and map to the two‑plane model:

- `ship1//` — LocationChain primary for ship identity and PD control.
    
- `fleet//` — Authority/fleet context for cross‑domain commands.
    
- `fleet-ship1//` — combined addressing for fleet-scoped ship identity.
    
- `CommNetID//service` — local ServicePlane addressing for comm nets and PD services.
    
- **Ephemeral ProxID** — local L0 hint for ProxLink.
    

**Where to change RFCs**

- **RFC‑2350/2351:** add `CommNetID`, `GroupID`, `PDPriority`, `ProxHint`, `ProxID`, and support for combined addressing forms.
    
- **RFC‑2363 (DRE):** support `//pd`, `//commnet`, `//ship` entries and registry pointers.
    
- **RFC‑2361 / RFC‑2302:** ledger anchoring flows for transponder registry and high‑assurance receipts.
    

### 7 Tests, validation, and forensics (must include)

- **Squawk & transponder:** verification under ledger partition; spoof injection; tamper detection and revocation propagation.
    
- **PD:** latency, handoff, jamming, conflict resolution, forensic reconstruction.
    
- **ProxLink:** range, spoof, replay, partial transfer reconciliation.
    
- **Mesh:** formation under mobility, rekeying under compromise, multicast reliability.
    
- **End‑to‑end forensic drill:** reconstruct an incident from PDAuditEvents, Admission/Forwarding receipts, ProxAuditEvents, and ledger anchors.
    

### 8 Tradeoffs and recommended defaults

- **Local control precedence** for life‑safety (ship PD acts first).
    
- **Ledger anchoring**: opt‑in for high‑value or cross‑domain evidence; avoid for routine squawks to prevent latency.
    
- **ProvisionalReceipts**: short windows only; require ForwardingReceipt for final confirmation.
    
- **DelegationTokens**: short validity, narrow scope, auditable.
    
- **Privacy:** default suppression of ProxID and minimal transponder exposure; explicit policy for ship registry publication.
    

Which of these three detailed specs should I draft into a full RFC section next with field schemas and example messages: **Ship↔Ship + SOS/Transponder** (includes tamper model), **Ship Point‑Defense Service** (local PD commands, receipts, handoff), or **Tactical Comm‑Net Mesh** (group join, multicast, rekeying)?

## Game design and exploit hooks

- **Flick spoof puzzle:** fake ProxBeacon that mimics a trusted console; players must use TOF/RSSI and audit logs to detect.
    
- **Relay betrayal:** compromised ship relay accepts DelegationTokens and claims transfers; players must trace DelegationReceipts and ledger anchors.
    
- **Jammed suit:** suit loses comm net; players must reassemble partial chunks from DTN caches and ProxAuditEvents.
    
- **Tactical mesh takeover:** players manipulate GroupJoinReceipt flows to inject a node into a tactical net.
    

Which of these should I draft next into a full RFC section: the **ProxLink / Suit BAN subprofile** (full records, handshakes, test cases) or the **CommNet ServicePlane spec** (group join, multicast, emergency broadcast APIs and example messages)?


**Short answer:** treat **RF as a physical transport (L0)** and the “internet” as **a stack of higher‑level services and namespaces (L1+/A/N stacks)** that run _over_ whatever L0 you have. They’re not the same thing; RF is one substrate the internet can use, but conflating them hides important physics, policy, and security tradeoffs.

### Conceptual separation (why it matters)

- **RF = physical medium (L0).** It has propagation physics (range, multipath, fading, jamming), power constraints, antenna geometry, and local failure modes. Those properties determine _what is possible_ on the wire and when.
    
- **“Internet” = layered services and protocols (L1+, A/N stacks).** Addressing, routing, sessions, identity, ledger anchoring, and application semantics live above the medium and should be medium‑agnostic where possible.
    
- **Mixing them blurs responsibility.** If you treat RF as “the internet,” you risk baking physical constraints into service semantics (e.g., assuming global reachability, low latency, or persistent identity), which breaks in The Expanse world of occlusion, partitions, and hostile actors.
    

### How to model them in SolNet (practical architecture)

1. **L0 (Physical subprofiles):** RF, tightbeam, ProxLink/BAN, wired. Each subprofile defines propagation, power, duty cycle, and local records (RFChannelProfileRecord, BeamProfileRecord, ProxBeacon).
    
2. **L1 (On‑air contract):** compact headers and hints (RFChannelHint, TightbeamHint, ProxHint). L1 must be minimal and privacy‑aware; it tells relays and edge devices _how_ to interpret the L0 frame.
    
3. **Authority / Namespace planes (A/N):** identity, DREs, ephemeris, sessions, and services. These layers are where “internet” semantics live: addressing, discovery, sessions, ledger anchoring, and policy.
    
4. **Bridges and gateways:** explicit, auditable components that map L0 realities into service semantics (e.g., a relay that converts a ProxLink transfer into a DTN bundle and issues a ReservationReceipt). Treat these as first‑class services with receipts and delegation tokens.
    

### Why this separation helps in The Expanse setting

- **Handles partitions and occlusion.** Services can fall back from tightbeam → RF → DTN without losing semantic meaning because the fallback is explicit, not implicit.
    
- **Preserves privacy and policy.** L1 suppression rules and PolicyRecords can prevent leaking ephemeris or pointing data even while RF beacons remain local.
    
- **Enables auditable delegation.** Constrained devices can delegate to relays; receipts and ledger anchors live in A/N stacks, not in the RF frames themselves.
    
- **Supports realistic exploits and gameplay.** Tampering with a transponder, jamming RF, or forging a ProxBeacon are distinct attack surfaces with different mitigations and forensic traces.
    

### Concrete design rules to adopt now

- **Rule 1 — L0 is transport only.** Never embed long‑lived identity or policy in raw RF frames; use short ephemeral hints and ProvenancePointer references.
    
- **Rule 2 — Make fallbacks explicit.** Every L1/L4 operation that can use multiple L0s must declare preferred transport, fallback order, and receipts (e.g., ReservationRef for tightbeam, ProvisionalReceipt for DTN).
    
- **Rule 3 — Keep privacy at L1+.** Default suppression of ephemeris/pointing in L1; explicit opt‑in via PolicyRecords for exposure.
    
- **Rule 4 — Audit at the Authority plane.** Ledger anchoring and cross‑domain verification belong in L2/A‑stack, not in raw RF.
    
- **Rule 5 — Model local nets separately.** ProxLink/BAN and tactical meshes are local L0/L1 overlays; they should not be treated as global internet primitives.
    

### RFCs to update (minimal, prioritized)

- **RFC‑2350 (L1):** clarify that RF is a transport; add RFChannelHint and ProxHint; define fallback semantics.
    
- **RFC‑2303 (Physical):** expand RF subprofile with explicit mapping guidance to higher layers.
    
- **RFC‑2360 / RFC‑2361:** document how receipts and ledger anchors are produced by gateways/relays when bridging RF→DTN→Ledger.
    
- **RFC‑2394 / RFC‑2395:** device profiles must state default behavior for local RF (auto‑accept thresholds, power classes, delegation).
    
- **RFC‑2306 (ProxLink) & RFC‑2481 (Minimal DTN):** ensure clear bridge patterns and receipts for local→global escalation.
    

### Tradeoffs and risks

- **If you treat RF as “the internet”:** you get simpler developer mental models but brittle systems that fail under occlusion, jamming, or political partition.
    
- **If you over‑compartmentalize:** you add complexity and more explicit bridging code, but you gain resilience, privacy, and correct forensic trails.
    
- **Operational cost:** ledger anchoring and cross‑domain verification are expensive; use them selectively for high‑assurance events (SOS, PD handoff, legal evidence).
    

### Example scenarios (how separation plays out)

- **Docking (ship→ship):** use tightbeam control link (L0 tightbeam) with ReservationReceipt; L1 carries BeamID; ledger anchoring optional post‑fact for audit.
    
- **Flick file between suits:** use ProxLink (L0 BAN) with ephemeral ProxID; no ledger anchor by default; optional relay delegation if the recipient is offline.
    
- **SOS squawk:** RF squawk is high‑priority L0 frame; receiving ship verifies transponder via DRE/ledger (A‑stack) before committing rescue resources; if ledger unavailable, use cached registry with freshness tags.
    

### Practical recommendation (one clear next step)

Adopt the **L0-as-transport / L1+/A/N-as-services** model and update **RFC‑2350** and **RFC‑2303** first to codify the separation and explicit fallback rules. That prevents future RFCs from accidentally baking physical assumptions into service semantics.

Would you like me to draft the **RFC‑2350 update** (L1 fields, ProxHint/RFChannelHint, fallback semantics) next so we can lock the on‑air contract before drafting the ProxLink and PD specs?



### RF versus Internet model for SolNet

**Thesis** Treat **RF as a physical transport layer (L0)** and the “internet” as the **service and authority stacks (L1+/A/N)** that run over any transport. RF frames are raw broadcasts anyone can emit; higher‑level semantics (identity, policy, receipts, sessions) must be explicit, auditable, and layered above the RF substrate.

### Why this matters now

- **Open broadcast reality** — anyone can transmit on a frequency; receivers must treat raw RF as unauthenticated unless higher‑level proofs are provided.
    
- **Physics differ from semantics** — RF has range, fading, jamming, and power constraints that must not be conflated with service guarantees like authentication, routing, or persistence.
    
- **Security and forensics** — authenticating a message requires ledger/DRE verification or short‑lived cryptographic proofs; otherwise a squawk or beacon is provisional.
    
- **Gameplay fidelity** — The Expanse scenarios (spoofed transponders, jamming, Naiomi‑style tampering) require explicit layers so exploits are plausible and traceable.
    

### Todo spec summary

**Goal**: codify the separation and provide concrete RFC edits, records, APIs, workflows, tests, and operational defaults so RF remains a transport and the “internet” is the layered service stack.

### Immediate RFC edits and additions

|**RFC**|**Change required**|
|---|---|
|**RFC‑2350**|Add **RFChannelHint**, **ProxHint**, **CommNetID**, **PDPriority**, and explicit fallback semantics (tightbeam → RF → DTN).|
|**RFC‑2303**|Expand RF subprofile: interference, jamming, plasma effects, link budgets, and mapping guidance to higher layers.|
|**RFC‑2306**|Create **ProxLink/BAN** subprofile for local flicks and suit comms; include receipts and optional ledger anchoring.|
|**RFC‑2361**|Define ledger verification flow for transponder registry, ReservationReceipt, and high‑assurance receipts.|
|**RFC‑2370**|Add relay APIs for reservations, group join, emergency broadcast, and Admission/Forwarding receipts.|
|**RFC‑2394**|Add DelegationToken semantics and device defaults for ProxLink and suit profiles.|
|**RFC‑2309**|Add test cases for RF spoofing, jamming, ledger partition, and ProvisionalReceipt reconciliation.|

### New canonical records to define

- **RFChannelProfileRecord** — _Band; ChannelID; PowerClass; RegulatoryFlags; Provenance; Freshness._
    
- **ShipTransponderRecord** — _ShipID; TransponderID; RegistryPointer; CertFingerprint; StatusFlags._
    
- **ProxBeacon / ProxHandshake / ProxTransferReceipt** — compact records for local transfers with nonces and short auth tags.
    
- **ReservationReceipt** — _ReservationID; BeamID/Channel; Start/End; PowerBudget; Signature; Freshness._
    
- **AdmissionReceipt / ForwardingReceipt** — relay receipts with path trace and TrustTag.
    
- **ProvisionalReceipt** — advisory receipt used when ledger verification or final forwarding is pending. All receipts include provenance and freshness.
    

### APIs and endpoints to add or extend

- `POST /l0/reservations` → returns **ReservationReceipt** or **ProvisionalReceipt**.
    
- `POST /ship/squawk` → emits **ShipSquawk**; receiving node may call `POST /ship/transponder/verify`.
    
- `POST /prox/handshake` → ProxLink handshake and session key derivation.
    
- `POST /relay/join` → group join for CommNetID; returns **GroupJoinReceipt**.
    
- `GET /dres/<LocationChain>//info` → DRE lookup for BeamProfileRecord, ShipTransponderRecord, RFChannelProfileRecord.
    

### Workflows and semantics

**1. Raw RF reception**

- Treat any RF frame as **unauthenticated** by default. If the frame carries a ProvenancePointer or short signature, mark it **provisional** until ledger/DRE verification completes.
    

**2. Squawk and SOS**

- SOS squawk is high‑priority L0 frame. Receiver issues **ProvisionalReceipt** immediately, then performs registry verification (cached DRE or ledger). Final acceptance requires **TransponderVerificationReceipt**.
    

**3. Tightbeam reservation**

- Reservation request → ReservationReceipt signed by relay. Acquisition produces **AcquisitionReceipt**; ledger anchoring optional for audit.
    

**4. ProxLink flick**

- Local handshake → ephemeral session key → chunked transfer with per‑chunk **ProxTransferReceipt**. Ledger anchoring only if user opts in.
    

**5. Delegation**

- Constrained device issues **DelegationToken** to relay; relay acts and returns **DelegationReceipt**. Tokens are short‑lived and auditable.
    

### Security model and rules

- **Rule A**: _RF frames are not proof._ Require explicit cryptographic proof or ledger verification for authoritative actions.
    
- **Rule B**: _Provisional ≠ final._ Any provisional acceptance must be reconciled and produce a final receipt or an audit trail.
    
- **Rule C**: _Least privilege and defaults._ Personal devices default to suppressed ephemeris and require physical confirmation for high‑value transfers.
    
- **Rule D**: _Delegation constraints._ DelegationTokens must be scoped, short, and logged; relays must emit DelegationReceipts.
    
- **Rule E**: _Emergency preemption._ SOS and PD commands map to highest QoS but still require verification when possible; local life‑safety overrides allowed with audit.
    

### Tests and validation suite

- **RF spoofing test**: inject forged squawk; verify detection via registry mismatch and TransponderManipulationEvent.
    
- **Jamming resilience**: simulate RF jamming and validate fallback to tightbeam/DTN and ProvisionalReceipt behavior.
    
- **Ledger partition**: issue ReservationReceipt while ledger is partitioned; reconcile after ledger propagation.
    
- **ProxLink replay**: replay ProxBeacon and handshake; ensure nonces and TTLs prevent replay.
    
- **PD handoff under occlusion**: simulate failed reservation and fallback to RF control with audit reconstruction.
    

### Operational defaults and tradeoffs

- **Default privacy posture**: ProxID suppressed; BeamProfile and ephemeris restricted to DRE with access controls.
    
- **Ledger anchoring**: use sparingly for high‑assurance events (SOS, PD handoff disputes, legal evidence).
    
- **Provisional windows**: short by default (seconds for PD, minutes for reservations) to limit ambiguity.
    
- **Indexer reliance**: ProvenancePointer reduces airtime but creates indexer trust dependency; require fallback verification and explicit audit trails.
    

### Forensics and incident reconstruction

- **Minimum evidence set**: AdmissionReceipt, ForwardingReceipt, ProvisionalReceipt, PDAuditEvent, ProxAuditEvent, DRE/Ledger anchors.
    
- **Reconstruction flow**: collect receipts → fetch DRE records → verify ledger anchors → assemble timeline with confidence metrics.
    
- **Tamper handling**: TransponderManipulationEvent triggers emergency unbind and ledger‑anchored RevocationReceipt.
    

### Game and narrative hooks

- **Naiomi tamper scenario**: attacker injects forged ShipSquawk; defenders must use cached registry fingerprints, TOF/RSSI anomalies, and PDAuditEvents to prove manipulation.
    
- **Jamming window puzzle**: players create a jamming window to force fallback to DTN; defenders must reconstruct partial transfers from ProvisionalReceipts.
    
- **Delegation betrayal**: compromised relay issues AdmissionReceipts; players trace DelegationReceipts and ledger anchors to expose the betrayal.
    

### Implementation roadmap (practical order)

1. Update **RFC‑2350** to lock the on‑air contract (RFChannelHint, ProxHint, CommNetID, PDPriority).
    
2. Publish **RFC‑2306 ProxLink** for local transfers and suit comms.
    
3. Add ledger verification flows to **RFC‑2361** for transponder and reservation receipts.
    
4. Extend **RFC‑2370** with relay APIs and Admission/Forwarding receipts.
    
5. Expand **RFC‑2303** with RF physics and mapping guidance.
    
6. Add tests to **RFC‑2309** and run interoperability sprints.


### inal canonical todo spec with priorities and deliverables

#### Immediate lock decisions

1. **Wire encodings and field sizes** for BeamID, ReservationRef, ProxID, CommNetID, GroupID.
    
2. **Freshness windows** for ReservationReceipt, AcquisitionReceipt, ProvisionalReceipt, transponder cache.
    
3. **DelegationToken schema** (fields, lifetime, revocation).
    
4. **ProvisionalReceipt semantics** (guarantees and reconciliation).
    

#### Publish in this order

1. **RFC‑2350 update** — L1 fields, `//` resolution precedence, fallback semantics, ProxHint/RFChannelHint.
    
2. **RFC‑2306 ProxLink** — full records, handshake, receipts, UX defaults, tests.
    
3. **RFC‑2306/2307 Tightbeam and RF subprofiles** — BeamProfileRecord, RFChannelProfileRecord, lifecycle, link budgets.
    
4. **RFC‑2370 Relay API** — reservations, Admission/Forwarding receipts, group join, emergency broadcast.
    
5. **RFC‑2361 Identity flows** — ledger verification for transponder and reservation receipts.
    
6. **RFC‑2394 Device Profiles** — DelegationToken, SuitProfile, compact encodings.
    
7. **RFC‑2309 Test Suite** — canonical test vectors and adversarial scenarios.
    
8. **RFC‑2420 Bundle updates** — ReservationRef in bundles and ProvisionalReceipt reconciliation.
    
9. **RFC‑2450 Governance** — audit, certification, and operator procedures.
    

#### Deliverables per RFC

- **Schema files** (CBOR/JSON/compact binary examples).
    
- **Canonical wire examples** (byte sequences).
    
- **Reference implementations** for ProxLink and Reservation API.
    
- **Test harness** and scenario scripts.
    
- **Operator playbooks** for SOS, PD handoff, tamper response, and ledger anchoring.
    

### Final checks to avoid future rewrites

- **One authoritative canonical page** (your project memory) must be frozen and referenced by all RFC drafts.
    
- **Lock the three small items now**: encodings, freshness windows, DelegationToken. Once locked, publish RFC‑2350 to freeze the on‑air contract.
    
- **Keep application protocols out of the base**; document extension points and examples instead.
    
- **Require receipts and provenance** for any action that affects safety, money, or legal standing.
    

Would you like me to draft the **RFC‑2350 update** now with concrete field definitions, `//` resolution rules, and example wire encodings so we can freeze the on‑air contract?



### Overview

Stealth communications and a TLS‑equivalent for personal commerce are **orthogonal but related** needs: stealth is about _minimizing detectability and attribution at L0/L1_, while a commerce TLS‑equivalent is about _confidentiality, integrity, and non‑repudiation at the Service/Authority planes_. Both must be explicit in the RFC corpus so implementers don’t invent incompatible or unsafe ad‑hoc solutions.

### Stealth communications — goals and constraints

**Primary goals**

- **Low Probability of Detection (LPD):** reduce chance an adversary notices a transmission.
    
- **Low Probability of Intercept (LPI):** reduce chance an adversary can demodulate or decode.
    
- **Low Attribution:** avoid linking transmissions to a persistent identity or location.
    
- **Operational safety:** allow emergency override and audit when life‑safety or legal needs require it.
    

**Hard constraints**

- Physics: power, range, antenna gain, and propagation dominate detectability.
    
- Tradeoffs: stealth ↔ throughput, latency, reliability, and ease of forensic reconstruction.
    
- Policy: stealth channels can be abused; governance and audit must be defined.
    

### L0 / L1 techniques for stealth (catalog)

- **Directional tightbeam** (preferred): narrow divergence, short acquisition windows, reservation receipts to coordinate; minimal sidelobes.
    
- **Spread spectrum / DSSS & FHSS:** reduce spectral density and make detection harder; requires shared seeds or rendezvous hints.
    
- **Low‑power burst transmissions:** short bursts timed to low‑noise windows; chunked transfers with ProvisionalReceipts.
    
- **Frequency agility and channel hopping:** rapid, pseudo‑random hops using pre‑shared hopping patterns.
    
- **Time‑domain obfuscation:** randomized timing, opportunistic micro‑bursts synchronized by out‑of‑band cues (ultrasonic, optical).
    
- **Physical layer coding:** low‑rate robust codes that look like noise to casual receivers.
    
- **Antenna nulling and side‑lobe suppression:** hardware/beamforming to reduce off‑axis leakage.
    
- **Ephemeral addressing:** ProxID‑style ephemeral IDs and short session tokens; avoid long‑lived LocationChain exposure.
    
- **Minimal L1 metadata:** use **StealthHint** flags and ProvenancePointer only when necessary; default suppression of BeamProfile/ephemeris.
    
- **Pre‑shared rendezvous tokens:** small, out‑of‑band tokens (QR, ultrasonic, physical tap) to bootstrap LPI links.
    

### Records, fields and RFC changes to support stealth

**New records / fields**

- **StealthProfileRecord** — PlatformID; StealthClass (A–E); PreferredModes (tightbeam, FHSS, burst); MaxBurstPower; SideLobeSpec; ProvenancePolicy.
    
- **StealthHint (L1)** — preferred rendezvous method; seed pointer (ProvenancePointer to encrypted rendezvous token); FreshnessTag.
    
- **StealthReservationReceipt** — ReservationID; BeamID/Channel; Start/End; PowerBudget; StealthClass; Signature; Freshness.
    
- **StealthAuditEvent** — SessionID; EvidenceRefs; OperatorOverride; LedgerPointer (optional).
    

**RFCs to update**

- **RFC‑2350** — add `StealthHint` and `StealthClass` semantics and conservative parsing rules.
    
- **RFC‑2306 / RFC‑2307** — add L0 stealth modes (tightbeam LPI modes, FHSS parameters, burst timing).
    
- **RFC‑2361** — ledger anchoring rules for stealth receipts (opt‑in, delayed anchoring, redaction support).
    
- **RFC‑2394** — device profile flags for stealth capability and UI defaults (explicit consent, emergency unmasking).
    
- **RFC‑2309** — test cases for stealth detection, false positives, and forensic reconstruction.
    

### Verification, audit, and forensics for stealth links

- **Provisional receipts only:** stealth links should default to _provisional_ receipts (short‑lived, advisory) to avoid exposing identity on the ledger.
    
- **Escalation path:** define an explicit, auditable **unmasking** flow: local operator action → StealthAuditEvent → optional ledger anchor with redaction metadata.
    
- **Evidence minimization:** store minimal local logs (ProxAuditEvent) with secure hardware‑backed timestamps; require multi‑party signatures to escalate.
    
- **Delayed anchoring:** allow receipts to be anchored later (post‑mission) with operator consent; ledger entries include redaction pointers and provenance.
    
- **Forensic hooks:** include confidence metrics (SNR, TOF, pointing error) in receipts so later reconstruction can weigh evidence.
    

### Policy, governance and safety

- **Default policy:** stealth capability **opt‑in** per device and per domain; personal devices default to non‑stealth.
    
- **Emergency override:** SOS and life‑safety channels must be able to preempt stealth modes; unmasking must be auditable.
    
- **Trust domains:** define which authorities may request unmasking and under what legal/operational conditions; require multi‑party approval for cross‑domain unmasking.
    
- **Abuse controls:** require short token lifetimes, operator confirmation, and DelegationReceipt trails for any relay‑assisted stealth action.
    

### Personal commerce and a TLS‑equivalent ("SolTLS")

**Design goals**

- **Confidentiality, integrity, authentication** for payments, purchases, and private messaging.
    
- **Usable for constrained devices** (wrist terminals, handsets) and for intermittent networks (DTN).
    
- **Support for multiple trust models** (public PKI, fleet/ship registries, ledger‑anchored identities).
    

**Core components**

- **Session establishment:** ephemeral session keys derived from a handshake that binds **ServiceChain** identity to a short‑lived key (like TLS 1.3).
    
- **Identity proofs:** support both certificate chains (NetworkCert) and ledger‑anchored identity pointers (ProvenancePointer).
    
- **Payment receipts:** **PaymentReceipt** record with PaymentID, Amount, MerchantID, Timestamp, Signature, optional LedgerPointer.
    
- **Forward secrecy:** mandatory ephemeral keys and key‑update semantics for long sessions.
    
- **Compact ciphersuites:** profiles for constrained devices (AEAD with small overhead, compact signatures).
    
- **DTN friendliness:** session resumption tokens and chunked authenticated encryption for store‑and‑forward.
    
- **Privacy features:** optional address blinding, minimal metadata in receipts, and selective disclosure for audits.
    

**Where it fits**

- Implement as a **ServicePlane protocol** (not L1). Name it **SolTLS** (or ServiceTLS) and publish as an RFC layered on top of the ServicePlane session model (RFC‑2392).
    
- Gateways may expose legacy TLS/TCP to external networks; internal SolTLS remains the canonical secure session.
    

**Integration with commerce**

- **Purchase flow:** client opens SolTLS session to merchant service; SolTLS authenticates merchant via NetworkCert or ledger pointer; PaymentReceipt is issued and optionally anchored.
    
- **Dispute resolution:** PaymentReceipt + Admission/Forwarding receipts + DRE records form the evidence set.
    
- **Micro‑payments & constrained devices:** support tokenized payments and delegated payment tokens (short‑lived, single‑use).
    

### Tests and validation (stealth + SolTLS)

- **Stealth detection testbed:** measure LPD/LPI thresholds for each L0 mode; run adversarial detection sweeps.
    
- **Unmasking drill:** simulate emergency unmasking with multi‑party approval and ledger anchoring.
    
- **SolTLS interoperability:** handshake vectors, cipher suite negotiation, resumption across DTN replays, payment receipt verification.
    
- **Forensic reconstruction:** assemble evidence from StealthAuditEvent, ProvisionalReceipt, DRE, and ledger anchors.
    

### Tradeoffs and recommended defaults

- **StealthClass defaults:** A (non‑stealth) → E (high‑stealth). Default devices: personal = A/B; military/spy platforms may be C–E with policy approval.
    
- **Throughput vs stealth:** document expected throughput ranges per StealthClass so applications can adapt.
    
- **Ledger anchoring:** default **deferred and opt‑in** for stealth; mandatory for commerce receipts above a threshold.
    
- **SolTLS defaults:** require forward secrecy, AEAD, and compact signatures; allow ledger‑based identity as an alternative to PKI.
    

### Game and narrative hooks (useful for The Expanse)

- **Stealth rendezvous puzzle:** players must exchange a pre‑shared hopping seed to open an LPI channel without alerting a watchtower.
    
- **Naiomi‑style tamper:** attacker manipulates transponder registry; defenders must use cached DRE fingerprints and TOF anomalies to prove tampering.
    
- **Commerce dispute:** merchant claims payment; player reconstructs SolTLS PaymentReceipt + AdmissionReceipts to prove delivery.
    

### Integration checklist (what to add to your canonical todo)

- Add **StealthProfileRecord**, **StealthHint**, **StealthReservationReceipt**, **StealthAuditEvent** to the L0/L1 records list.
    
- Update **RFC‑2350** (L1) with `StealthHint` and resolution rules.
    
- Extend **RFC‑2306/2307** with L0 stealth modes and parameters.
    
- Draft **SolTLS** as a ServicePlane RFC (handshake, ciphersuites, payment receipts, DTN resumption).
    
- Add stealth and SolTLS test cases to **RFC‑2309**.
    

Which should I draft into a full RFC section next to lock these behaviors: the **Stealth Communications subprofile** (records, L0 modes, unmasking/audit flows) or the **SolTLS ServicePlane spec** (handshake, payment receipts, DTN resumption)?

### News feeds, Cached Internet, and Internet of Things

A single, integrated plan: treat **news feeds** and **cached internet** as **ServicePlane content services** that run over any L0 transport and use DTN/Bundle semantics for delay‑tolerant caching; treat **IoT** as a broad class of **device profiles and lightweight service protocols** that publish telemetry and consume commands via the ServicePlane with constrained encodings and delegation options. Keep these as layered protocols — **don’t bake application semantics into L0**.

### Key scenarios to cover (completeness checklist)

- **Global news distribution**: publisher → indexed DREs → regional caches → subscriber pull/push; supports prioritized emergency bulletins (SOS, PD alerts).
    
- **Cached Internet / Edge CDN**: large content objects cached at stations, ships, and relays; DTN bundles carry manifests and chunked objects; cache consistency via Bloom filters and reconciliation.
    
- **IoT telemetry & control**: massive numbers of constrained sensors (asteroid spotters, drones, station sensors) publishing small telemetry; actuators receiving commands with strict ACLs and delegation tokens.
    
- **Offline browsing / store‑and‑forward**: user requests cached pages or message boards via DTN bundles; proxies reconcile when connectivity returns.
    
- **Subscription & push models**: pull (client fetch), push (publisher push via relay), and hybrid (publisher advertises manifests; subscribers fetch chunks).
    
- **Monetized content / commerce feeds**: paywalled feeds and micro‑payments integrated with SolTLS payment receipts and optional ledger anchoring.
    
- **Watchtower satellites & sensor networks**: periodic bulk telemetry uploads to DREs; prioritized PD or fleet feeds preempt routine telemetry.
    

### Architecture and how it maps to your planes

- **L0 (transport):** RF, tightbeam, wired, ProxLink carry bundles and service frames. No content semantics here.
    
- **L1 (on‑air hints):** add **CacheHint**, **FeedID**, **ChunkManifestRef**, **QoSClass** to enable efficient discovery and prioritized delivery.
    
- **A/N stacks (ServicePlane):** implement feed discovery, subscription management, manifest indexing, access control, payment flows, and cache reconciliation. DREs host feed metadata and cache pointers.
    
- **DTN / Bundle layer:** canonical vehicle for delayed, chunked content; include **ReservationRef** for scheduled bulk transfers and **ProvisionalReceipt** semantics for partial deliveries.
    
- **Bridges/gateways:** explicit, auditable services that convert web/HTTP semantics into SolNet bundle/manifest semantics; gateways issue Admission/Forwarding receipts.
    

### Records, manifests, and canonical objects to add

- **FeedDescriptor** — FeedID; PublisherID; TopicTags; AccessPolicy; PaymentPolicy; ManifestRef; Freshness.
    
- **ChunkManifest** — ManifestID; FeedID; ChunkHashes; TotalSize; ChunkOrder; Expiry.
    
- **CacheRecord** — NodeID; ManifestID; ChunkIDs; TTL; Freshness; Provenance.
    
- **SubscriptionReceipt** — SubscriberID; FeedID; Start/End; QoSClass; PaymentPointer (optional).
    
- **ContentDeliveryReceipt** — ManifestID; ChunkRange; ReceiverID; Timestamp; Status; Signature.
    
- **TelemetryRecord (IoT)** — DeviceID; SensorType; SampleTimestamp; Value; Confidence; ProvenancePointer.
    
- **IoTCommand** — CommandID; TargetDeviceID; Action; AuthProof; TTL; Priority.
    

### Protocol patterns and behaviors (practical)

- **Publish → Index → Cache → Deliver**: publisher posts FeedDescriptor to DRE; DRE indexes and advertises manifests; caches pull manifests opportunistically; subscribers fetch chunks from nearest cache or request relay reservation for bulk transfer.
    
- **Manifest‑first delivery**: always advertise ChunkManifest before bulk transfer so receivers can decide whether to fetch.
    
- **Chunked, resumable transfers**: use per‑chunk ContentDeliveryReceipts and ProvisionalReceipts for partial success; DTN reconciliation merges partial caches.
    
- **Subscription models**: free, paid (SolTLS + PaymentReceipt), and restricted (ACL via PNI/TrustDomain). Payment tokens and DelegationTokens for constrained subscribers.
    
- **IoT telemetry flow**: constrained device publishes TelemetryRecord to local relay with compact encoding; relay aggregates and forwards bundles to DREs or subscribers; commands use short AuthProofs and DelegationTokens for relay‑assisted control.
    

### Security, privacy, and monetization

- **Authentication:** SolTLS for commerce and high‑assurance feeds; NetworkCert or ledger‑anchored identity for publishers.
    
- **Access control:** FeedDescriptor includes AccessPolicy; DRE enforces ACLs; caches honor ProvenancePointer and require AdmissionReceipt for paid content.
    
- **Encryption:** content encrypted end‑to‑end for private feeds; caches store encrypted chunks and only serve to authorized subscribers.
    
- **Payment & receipts:** PaymentReceipt ties to ContentDeliveryReceipt for dispute resolution; micro‑payments supported via tokenized single‑use payment tokens.
    
- **Privacy:** default metadata minimization for personal feeds; opt‑in exposure for public news.
    
- **Abuse controls:** rate limits, reputation scores for publishers, and audit trails for takedown or legal requests.
    

### Monitoring, firewalls, and moderation

- **Telemetry envelope:** standard fields (SNR, latency, chunk success rate, cache hit ratio) published by relays and caches for network health and policy enforcement.
    
- **Firewalls:** operate at ServicePlane using PolicyRecords and DRE access controls; L1 hints (FeedID, QoSClass) allow conservative filtering without exposing content.
    
- **Moderation:** publisher reputation and community moderation are ServicePlane features; DREs can host moderation metadata and takedown receipts.
    

### Testing and validation (must include)

- **Cache consistency tests:** manifest divergence, chunk corruption, and reconciliation under partition.
    
- **Subscription/payment tests:** payment token replay, double‑spend resistance, and dispute resolution using PaymentReceipt + ContentDeliveryReceipt.
    
- **IoT scale tests:** thousands of TelemetryRecords per minute, aggregation correctness, and command latency under mesh conditions.
    
- **Security tests:** feed spoofing, cache poisoning, unauthorized access, and SolTLS handshake robustness over DTN.
    

### Governance and policy considerations

- **Publisher identity policy:** define minimal verification levels for news vs. high‑assurance scientific feeds.
    
- **Content retention & legal:** DREs and caches must expose AuditEvent hooks and retention policies; ledger anchoring for legal evidence optional but supported.
    
- **Economic model:** define who pays for caching/relay bandwidth (publisher, subscriber, or third‑party CDN).
    
- **Regulatory mapping:** map in‑universe spectrum rules and emergency broadcast priorities to feed QoS and preemption rules.
    

### What to keep out of the baseline

- **Do not bake specific content formats** (HTML, RSS, JSON schema) into base RFCs; provide manifest and chunk abstractions and leave format negotiation to ServicePlane protocols.
    
- **Do not hardcode monetization schemes**; provide hooks (PaymentPointer, PaymentReceipt) and let higher‑level protocols define billing models.
    
- **Avoid embedding moderation rules** into L0/L1; keep them as ServicePlane policy extensions.
    

### Developer deliverables and examples to produce

- **Canonical FeedDescriptor and ChunkManifest examples** (CBOR/JSON + compact binary).
    
- **Reference gateway** that converts HTTP/RSS → ChunkManifest → DTN bundles.
    
- **Sample SolTLS payment flow** with PaymentReceipt and ContentDeliveryReceipt pairing.
    
- **IoT device SDK** for compact TelemetryRecord encoding and DelegationToken handling.
    
- **Test harness** for cache reconciliation and subscription/payment interop.
    

### Game and narrative hooks

- **Ceres blackout:** cached news manifests let players read days‑old feeds; partial manifests create mystery puzzles.
    
- **Pirate cache poisoning:** attackers inject fake ChunkManifest; players must use DRE provenance and PaymentReceipts to detect fraud.
    
- **Watchtower feed:** players must prioritize PD feeds over routine telemetry during an attack; QoS and ReservationRef mechanics drive tension.
    

### Implementation roadmap (practical order)

1. Add **FeedDescriptor** and **ChunkManifest** schemas to canonical records.
    
2. Extend **RFC‑2350** with **CacheHint** and **FeedID** L1 hints.
    
3. Implement DTN manifest delivery patterns in **RFC‑2420** and update bundle metadata.
    
4. Draft **ServicePlane feed protocol** (subscription, payment hooks, manifest negotiation).
    
5. Provide reference gateway and IoT SDK; add tests to **RFC‑2309**.
    

Final question to advance this: which concrete deliverable should I draft first into a full RFC subsection with field schemas and example messages — the **FeedDescriptor/ChunkManifest + DTN manifest flow**, the **SolTLS payment + ContentDeliveryReceipt pairing**, or the **IoT TelemetryRecord + DelegationToken SDK**?


### Orbital Traffic Control Canonical Todo Spec

**Summary** Orbital Traffic Control (OTC) should be a **ServicePlane overlay** built on top of the L0/L1 substrates you already defined, not a monolithic new physical layer. That said, OTC requires a small set of **L0/L1 hooks, canonical records, receipts, and safety rules** to be reliable, auditable, and interoperable across ships, stations, fleets, and third‑party operators (commercial, scientific, military, Belter, pirate). This spec lists exactly what to add, where to add it, and why—so you won’t have to revisit core design decisions later.

### Placement and Scope

- **Primary layer**: **Namespace / ServicePlane** — OTC is a service: scheduling, conflict resolution, clearances, handoffs, and telemetry aggregation.
    
- **Required L0/L1 hooks**: reservation semantics, high‑priority emergency channels, transponder verification flows, and QoS hints.
    
- **Authority involvement**: DREs and TrustDomains for registry and policy; ledger anchoring optional for legal evidence.
    
- **What belongs out of baseline**: docking choreography, proprietary autopilot commands, and vendor‑specific actuator protocols — these are **application protocols** layered on top of OTC.
    

### Records, Fields, and New Objects to Add

- **OTCFlightPlan** — **FlightPlanID; VehicleID; Origin; Destination; TrajectoryHash; StartWindow; EndWindow; Priority; AuthorityTag; ProvenancePointer**.
    
- **OTCReservation** — **ReservationID; FlightPlanID; AssignedCorridor; Start/End; PowerBudgetHint; StealthClassAllowed; Signature**.
    
- **OTCClearance** — **ClearanceID; ReservationID; IssuerID; Conditions; Timestamp; Signature**.
    
- **OTCTrackReport** — **TrackID; VehicleID; Position; Velocity; Confidence; SensorSource; Timestamp; Provenance**.
    
- **OTCConflictEvent** — **ConflictID; InvolvedReservations; Severity; ResolutionAction; AuditRefs**.
    
- **OTCAuditEvent** — **EventID; Receipts; EvidenceRefs; OperatorAction; LedgerPointer (optional)**.
    
- **TransponderVerificationReceipt** (reuse/extend existing ShipTransponderRecord flows) — **SquawkID; VerifierID; RegistryCheckResult; TrustTag; Timestamp**.
    

All records **must** include provenance, freshness, and confidence metrics. Provide compact encodings for constrained telemetry.

### APIs and Endpoints

- **DRE / Discovery**
    
    - `GET /dres/<LocationChain>//otc` — fetch OTC service descriptor and local policy.
        
- **Reservation and Clearance**
    
    - `POST /otc/reservations` — submit FlightPlan; returns **OTCReservation** or **ProvisionalReceipt**.
        
    - `GET /otc/reservations/<ReservationID>` — query status and linked receipts.
        
    - `POST /otc/clearance` — authority issues **OTCClearance**; returns signed receipt.
        
- **Tracking and Telemetry**
    
    - `POST /otc/track` — vehicle or sensor posts **OTCTrackReport**; relays aggregate.
        
    - `GET /otc/track/<TrackID>` — fetch latest track and confidence.
        
- **Conflict and Handoff**
    
    - `POST /otc/handoff` — propose handoff of corridor or target to another authority/ship; returns **OTCHandoffReceipt**.
        
    - `POST /otc/conflict` — report conflict; returns **ConflictEvent** and suggested resolution.
        
- **Emergency and SOS**
    
    - `POST /otc/emergency` — emergency squawk with `EmergencyLevel`; returns **ProvisionalReceipt** and triggers PD/OTC preemption.
        
- **Forensics**
    
    - `POST /otc/audit` — submit **OTCAuditEvent**; optional ledger anchor endpoint for high‑assurance evidence.
        

APIs must return **AdmissionReceipt** and **ForwardingReceipt** where relays are involved. All endpoints require provenance metadata and optional ledger pointers.

### Workflows and Operational Rules

- **Flight Plan Lifecycle**
    
    1. **Plan Submit**: vehicle/operator posts **OTCFlightPlan**.
        
    2. **Pre‑check**: DRE validates constraints (power, corridor availability, trust domain policy).
        
    3. **Reservation**: OTC issues **OTCReservation** (signed). If ledger unavailable, issue **ProvisionalReceipt** and reconcile later.
        
    4. **Clearance**: authority issues **OTCClearance** before execution window. Clearance binds to ReservationID.
        
    5. **Execution**: vehicle posts periodic **OTCTrackReport**; relays and PD systems monitor.
        
    6. **Completion**: vehicle posts final **OTCAuditEvent** and optionally anchors to ledger.
        
- **Handoffs**
    
    - Handoffs require **OTCHandoffProposal** → ReservationRef for scheduled tightbeam control links if needed → **OTCHandoffReceipt**. Handoffs must include confidence metrics and a short reservation window for control link.
        
- **Conflict Resolution**
    
    - Conflicts detected by DRE or relays produce **OTCConflictEvent**. Resolution algorithm: **Priority → TrustTag weight → Timestamp → Manual arbitration**. All steps logged as **OTCAuditEvent**.
        
- **Emergency Preemption**
    
    - `EmergencyLevel` squawks preempt reservations; PD and OTC must accept provisional commands immediately and log receipts. Post‑incident reconciliation required.
        
- **Stealth and Sensitive Flights**
    
    - Stealth flights allowed only with explicit **StealthProfileRecord** and domain policy; default is non‑stealth. Stealth reservations produce **ProvisionalReceipts** and require multi‑party unmasking for legal evidence.
        

### Safety, Certification, and Governance

- **Safety rules**
    
    - **Local control precedence** for immediate collision avoidance. OTC reservations do not override onboard safety systems.
        
    - **Mandatory telemetry cadence** for high‑priority flights; missing cadence triggers automated safe‑hold and **OTCConflictEvent**.
        
- **Certification**
    
    - Define certification levels for OTC controllers, relays, and transponder hardware (map to RFC‑2451 secure element requirements).
        
- **Authority model**
    
    - DREs publish PolicyRecords for OTC: allowed corridors, emergency channels, trust domain rules, and cost/fee models.
        
- **Legal evidence**
    
    - Ledger anchoring optional but recommended for cross‑domain incidents; define cost model and who may request anchoring.
        

### Tests, Validation, and Forensics

- **Interoperability scenarios**
    
    - Scheduled docking corridor reservation and handoff with tightbeam control link.
        
    - Emergency SOS preemption and multi‑ship coordinated rescue.
        
    - Conflict resolution between corporate and military authority with ledger reconciliation.
        
- **Adversarial tests**
    
    - Transponder spoofing and Naiomi‑style tamper detection.
        
    - Jamming of tracking telemetry and fallback to DTN reconciliation.
        
    - Relay compromise and DelegationToken misuse.
        
- **Forensics drills**
    
    - Reconstruct incident timeline from OTCReservation, OTCTrackReport, Admission/Forwarding receipts, OTCAuditEvent, and ledger anchors.
        

### Integration Points with Existing RFCs

- **RFC‑2350** — add `OTCHint`, `FlightPlanID`, `ReservationRef`, `PDPriority` mapping.
    
- **RFC‑2363 DRE** — add `//otc` service entries and corridor catalogs.
    
- **RFC‑2361 Identity** — transponder verification and ledger anchoring flows for OTCClearance and OTCAuditEvent.
    
- **RFC‑2365 DTN** — include ReservationRef and ProvisionalReceipt semantics for delayed telemetry and manifest transfers.
    
- **RFC‑2309 Test Suite** — add OTC scenarios and adversarial tests.
    
- **RFC‑2306 / ProxLink** — suit‑to‑ship handoffs and local crew transfers tie into OTC for short‑range clearances.
    

### Implementation Roadmap and Priorities

1. **Lock wire encodings and ReservationRef format** so reservations are interoperable.
    
2. **Publish OTC service descriptor schema** in DRE and example FlightPlan/Reservation messages.
    
3. **Implement reservation API and AdmissionReceipt semantics** in a reference relay.
    
4. **Run interop sprints**: docking corridor, SOS preemption, and handoff.
    
5. **Add certification tests** and operator playbooks for emergency unmasking and conflict arbitration.
    
6. **Roll out governance**: PolicyRecords for corridors, fees, and trust domain rules.
    

Would you like me to draft the **OTC FlightPlan and Reservation schemas** now with exact field types, compact wire encodings, and example messages so we can freeze the on‑air contract for traffic control?



### Principle decision

Keep **L0/L1 minimal and stable**. Treat them as a small, well‑specified substrate and expose **extension points** that let higher layers and optional subsystems (tightbeam, ProxLink, PD, OTC, stealth, SolTLS, feeds, etc.) plug in without changing the core on‑air contract.

### Why this approach

- **Stability:** hardware and legacy devices expect a stable physical and framing contract; frequent changes break deployed systems.
    
- **Extensibility:** new capabilities are inevitable; a small set of extension mechanisms prevents RFC bloat while enabling innovation.
    
- **Security and policy:** centralizing heavy semantics in higher layers keeps sensitive metadata out of raw frames and makes governance tractable.
    
- **Interoperability:** explicit capability negotiation and discovery prevents “Frankenstein” stacks where every vendor invents incompatible hooks.
    

### Core design pattern to adopt now

1. **Minimal core fields at L0/L1** — only what every receiver must parse: _FrameType, FreshnessTag, ProvenancePointer (optional), QoSClass, CompactAuthTag_.
    
2. **Extension TLV block** — a single, length‑prefixed TLV container in the L1 header for optional features. Devices that don’t understand a TLV skip it.
    
3. **Capability discovery via DRE** — publish supported TLV keys and profiles in `//info` so peers can discover features before using them.
    
4. **Feature negotiation handshake** — session‑level negotiation (ServicePlane) that binds optional features to a session token; L1 TLV only carries hints and pointers.
    
5. **ProvenancePointer as gateway** — heavy metadata lives off‑air in DRE/ledger; L1 carries a compact pointer to it rather than full records.
    
6. **Profiles and subprofiles** — define named profiles (Tightbeam v1, ProxLink v1, StealthClass C) that bundle TLV keys, semantics, and test vectors.
    
7. **Versioning and deprecation policy** — semantic versioning for profiles and a documented deprecation window for L1 changes.
    

### Concrete extension mechanisms to add (todo list)

- **TLV container spec** for L1 header: key (8 bits), length (variable), value (bytes); reserved keys for core profiles.
    
- **Profile registry** in DRE: `//profiles/<profile-name>` with schema, version, required TLV keys, and test vectors.
    
- **Capability advertisement**: `RelayAdvertisement` and `DREInfoRecord` include `SupportedProfiles` list and `MaxTLVSize`.
    
- **Session negotiation API**: `POST /session/negotiate` returns agreed profile set and session token; session token binds to receipts.
    
- **ProvenancePointer canonical form**: compact pointer format and fetch semantics (DRE → LedgerAnchor).
    
- **Fallback semantics**: canonical fallback order (tightbeam → RF → DTN) encoded as a small policy object; negotiable per session.
    
- **Extension RFC template**: a short template authors must use when proposing a new profile (purpose, TLV keys, wire encodings, test vectors, privacy impact, fallback rules).
    

### Minimal L1 header to freeze now

- **FrameType** (1 byte)
    
- **QoSClass** (1 byte)
    
- **FreshnessTag** (1 byte)
    
- **ProvenancePointer** (variable, compact)
    
- **TLVContainerLength** (varint) + **TLVContainer** (optional)
    
- **CompactAuthTag** (signature/MAC, variable)
    

Locking this prevents ad‑hoc header growth.

### How to add a new capability without touching L1

1. **Author a profile RFC** using the template.
    
2. **Register profile** in DRE `//profiles`.
    
3. **Use TLV keys** defined by the profile inside the TLV container.
    
4. **Negotiate at session time** and include the session token in L1 ProvenancePointer or TLV if needed.
    
5. **Publish test vectors** and add tests to the L0 Test Suite.
    

### Governance and safety rules for extensions

- **Privacy review required** for any profile that exposes ephemeris, pointing, or persistent identity.
    
- **Audit requirement**: any extension that can affect safety (PD, OTC, SOS) must include Admission/Forwarding receipt semantics and forensic test cases.
    
- **Opt‑in by default**: devices must not enable sensitive profiles unless explicitly configured or authorized by PolicyRecords.
    
- **Short lifetimes for risky tokens**: DelegationToken, Stealth seeds, and ProxIDs must be short‑lived and auditable.
    

### Migration and compatibility plan

- **Phase 1**: freeze minimal L1 header and publish TLV container spec and profile template.
    
- **Phase 2**: publish a small set of initial profiles (Tightbeam v1, ProxLink v1, PD v1, StealthHint v1).
    
- **Phase 3**: run interop sprints and add profile test vectors to RFC‑2309.
    
- **Phase 4**: deprecate any ad‑hoc L1 fields; require migration to TLV/profile model with a 2‑year window.
    

### Practical checklist to avoid “Frankenstein”

- **Do not add new mandatory L1 fields** unless every device must parse them.
    
- **Require a profile RFC** for every new capability before it is used on‑air.
    
- **Use ProvenancePointer** to keep heavy metadata off‑air.
    
- **Enforce PolicyRecords** for exposure and unmasking flows.
    
- **Provide reference implementations** for each profile so vendors don’t invent incompatible variants.
    

### Short prioritized todo for you to lock now

1. **Freeze the minimal L1 header** (FrameType, QoSClass, FreshnessTag, ProvenancePointer, TLV container, CompactAuthTag).
    
2. **Publish TLV container spec** and the profile RFC template.
    
3. **Create DRE profile registry** and add Tightbeam and ProxLink as first entries.
    
4. **Add TLV parsing rules** to RFC‑2350 so unknown TLVs are safely ignored.
    
5. **Add a short deprecation policy** and a migration timeline.
    

This preserves a small, stable L0/L1 substrate while giving you a clean, auditable, and extensible way to add the dozens of features you’ve sketched without turning the base layers into a monolithic spec. Which of the five immediate todo items above should I draft into the first formal RFC update now so we can freeze the substrate and stop grafting new fields into L1?