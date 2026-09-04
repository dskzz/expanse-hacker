### Overview

Below is a full, **non‑consolidated** SolNet RFC corpus rebuilt from the ground up. Each RFC entry follows the same template so writers and implementers can pick it up and draft a full spec without guessing intent. The base principle is preserved: **freeze a minimal L0/L1 on‑air contract**, expose extension points, and implement all additional behavior as **versioned modules/profiles** — but I will _not_ collapse or hide RFC numbers: every original RFC topic is present and expanded into a concrete deliverable with module hooks, test vectors, and integration notes.



## How to read this document

- Each RFC entry uses the same fields: **Purpose**, **Why**, **What it defines**, **Interaction with planes**, **Profiles and modules that extend it**, **Canonical records to author**, **Must‑ship test cases**, and **Notes for implementers**.
    
- The corpus is grouped into the same numeric blocks you provided: **L0 (2300–2319)**, **L1 (2350–2359)**, **Authority Plane (2360–2389)**, **Namespace Plane (2390–2419)**, **Cross‑plane & Operational (2420–2449)**, **Security/Governance (2450–2479)**, **Developer/Game (2480–2499)**.
    
- For each RFC I include the minimal set of fields and the **module hooks** that must be implemented as profiles (TLV keys + DRE profile entries) rather than mandatory L1 changes.
    

### L0 Physical and Data‑Link RFCs 2300–2319

#### RFC‑2300 SolNet Terminology and Concepts

**Purpose**: Canonical vocabulary and conceptual model (UUID‑S7, LocationChain, ServiceChain, two‑plane split, provenance, freshness classes). **Why**: Prevents drift; single source of truth for all RFCs. **Defines**: Naming grammar, `//` semantics, plane responsibilities, AuthorityWeight/NamespaceWeight, minimal examples. **Interaction**: Foundation for L1/L2/L3 mappings. **Profiles/Modules**: none — this is normative. **Canonical records**: LocationChain grammar, ServiceChain grammar, FreshnessClass enum. **Tests**: grammar parser unit tests, example resolution scenarios. **Notes**: Lock this first; all RFCs must reference these definitions.

#### RFC‑2301 SolNet Cryptographic Primitives

**Purpose**: Signature envelopes, compact signatures, key hierarchies, PQ migration plan. **Why**: All receipts and anchors must be verifiable across domains. **Defines**: Signature formats (compact, full), key lifecycle, attestation formats, secure element attestation hooks. **Interaction**: L2 identity, L1 CompactAuthTag verification. **Profiles**: hardware attestation profile, constrained signature profile. **Records**: SignatureEnvelope, CompactSignature, AttestationRecord. **Tests**: signature vectors, PQ transition vectors, attestation verification. **Notes**: Provide reference libs for constrained devices.

#### RFC‑2302 SolNet Ledger Specification

**Purpose**: LedgerAnchor format, replication model, revocation entries, anchoring APIs. **Why**: Ledger anchors are authoritative bindings for identity and high‑assurance receipts. **Defines**: Anchor record schema, anchoring API, replication and reconciliation semantics for partitions. **Interaction**: DRE verification, ProvenancePointer anchoring. **Profiles**: lightweight anchor profile for constrained domains; delayed anchoring policy. **Records**: LedgerAnchor, RevocationEntry, AnchorReceipt. **Tests**: partition/reconciliation scenarios, revocation propagation drills. **Notes**: Include cost model and anchoring policy examples.

#### RFC‑2303 Physical Media and Propagation

**Purpose**: Propagation models for RF, tightbeam, optical, acoustic, plasma effects. **Why**: Physics drive scheduling, acquisition, and fallback. **Defines**: Path loss, occlusion, scintillation, link budgets, SNR thresholds. **Interaction**: L1 FreshnessTag, L3 ephemeris hints, reservation timing. **Profiles**: subprofiles for RF, tightbeam, optical, acoustic. **Records**: PropagationModel, LinkBudgetRecord, OcclusionProbability. **Tests**: propagation simulation vectors, occlusion injection tests. **Notes**: Provide parameterized models for game designers.

#### RFC‑2304 Antenna Geometry and Alignment

**Purpose**: Coordinate frames, pointing models, calibration records. **Why**: Tightbeam and high‑gain RF require precise pointing semantics. **Defines**: Frame transforms, boresight, pointing error model, calibration record. **Interaction**: BeamProfileRecord references, acquisition workflows. **Profiles**: antenna capability profile, low‑quality rig profile. **Records**: AntennaGeometry, PointingStateRecord. **Tests**: pointing error propagation, calibration drift tests.

#### RFC‑2305 Power and Duty Cycle Constraints

**Purpose**: Power classes, duty cycles, energy budgets, emergency exceptions. **Why**: Energy constraints shape scheduling and QoS. **Defines**: PowerClass taxonomy, duty cycle rules, reservation power budgets. **Interaction**: ReservationReceipt powerBudget field, L1 QoS shaping. **Profiles**: low‑power device profile, station power class. **Records**: PowerBudgetRecord, DutyCycleEvent. **Tests**: duty cycle enforcement, emergency override tests.

#### RFC‑2306 Tightbeam Laser Subprofile

**Purpose**: Tightbeam lifecycle, BeamProfileRecord, acquisition/tracking, reservation semantics. **Why**: Tightbeam is stateful and brittle; needs canonical behavior. **Defines**: Beam lifecycle states, BeamID format, ReservationReceipt, AcquisitionReceipt, TrackingHeartbeat, OcclusionEvent, ReservationRef semantics. **Interaction**: L1 TLV keys (BeamID, TightbeamHint), DRE BeamProfile entries, DTN ReservationRef. **Profiles**: Tightbeam v1 (mandatory initial profile), Tightbeam stealth mode (module). **Records**: BeamProfileRecord, ReservationReceipt, AcquisitionReceipt, TrackingHeartbeat. **Tests**: reservation→acquisition→handover scenarios, occlusion injection, pointing error tolerance. **Notes**: Provide canonical wire encodings and compact CBOR examples.

#### RFC‑2307 RF Propagation Subprofile

**Purpose**: RF channel profiles, interference models, beaconing, regulated band semantics. **Why**: RF is the default medium and must be predictable. **Defines**: RFChannelProfileRecord, RFBeaconDescriptor, RFInterferenceEvent, RFReservationReceipt (for scheduled bands). **Interaction**: L1 RFChannelHint TLV, DRE RFChannel records. **Profiles**: RF default, RF scheduled band module, FHSS/LPI module. **Records**: RFChannelProfileRecord, RFLinkQualityRecord. **Tests**: beaconing, interference detection, scheduled band reservation.

#### RFC‑2308 Media Privacy and Exposure Policy

**Purpose**: Exposure rules for ephemeris, pointing, beaconing metadata. **Why**: Prevents leakage of operationally sensitive data. **Defines**: PolicyRecord fields, exposure levels, audit obligations. **Interaction**: L1 suppression rules, DRE access controls. **Profiles**: domain privacy profiles (UN, MCRN, OPA, Belter). **Tests**: privacy enforcement, access control audits.

#### RFC‑2309 L0 Test and Validation Suite

**Purpose**: Canonical L0 test cases and validation procedures. **Why**: Ensures consistent behavior across implementations. **Defines**: test harness, synthetic scenarios, acceptance criteria. **Interaction**: referenced by all L0/L1 RFCs. **Modules**: adversarial test pack, performance test pack. **Tests**: occlusion, scintillation, jamming, reservation timing, forensics reconstruction.

### L1 Data‑Link RFCs 2350–2359

#### RFC‑2350 SolNet Canonical Addressing Standard

**Purpose**: `<LocationChain>//<ServiceChain>` grammar, `//` semantics, TrustTag, QoSClass, FreshnessTag, ProvenancePointer canonical form. **Why**: Single interoperable addressing contract. **Defines**: Address grammar, resolution precedence, ProvenancePointer format, TLV key allocations for common L0 features (BeamID, ProxID, CommNetID, GroupID). **Interaction**: L0 subprofiles reference TLV keys; DRE resolves ProvenancePointer. **Profiles**: ProxHint, TightbeamHint, RFChannelHint as TLV keys (profile modules). **Records**: AddressRecord, ProvenancePointer canonical form. **Tests**: address parser, resolution precedence tests, ProvenancePointer fetch tests. **Notes**: Provide exact wire encodings and varint rules.

#### RFC‑2351 L1 Frame Format A/N Header Split

**Purpose**: Header layout, field ordering, compression rules, minimal/extended variants. **Why**: Consistent on‑air framing and efficient parsing. **Defines**: FrameType, QoSClass, FreshnessTag, ProvenancePointer varint, TLVContainerLength, TLV container format, CompactAuthTag encoding. **Interaction**: All L0/L1 frames use this header. **Profiles**: minimal header profile for constrained devices, extended header for relays. **Records**: L1Header schema, TLV key registry. **Tests**: header parsing, TLV skipping behavior, CompactAuthTag verification.

#### RFC‑2352 L1 Privacy and Metadata Minimization

**Purpose**: Mandatory/optional/suppressible L1 fields and defaults for personal devices. **Why**: Minimize metadata leakage. **Defines**: suppression rules, light‑client profiles, fallback when fields absent. **Interaction**: PNI defaults, DRE policy enforcement. **Profiles**: PNI suppression profile, stealth default profile. **Tests**: suppression enforcement, discovery behavior with suppressed fields.

#### RFC‑2353 L1 Relay Advertisement Protocol

**Purpose**: RelayAdvertisement record, capability masks, scheduling capacity, admission hooks. **Why**: Enables dynamic routing and admission control. **Defines**: RelayAdvertisement TLV keys, RelayCapability masks, load metrics, admission policy hints. **Interaction**: ServicePlane uses relay info for session continuity and reservation negotiation. **Profiles**: relay capability extensions (tightbeam terminal, RF bands). **Tests**: relay advertisement parsing, admission decision tests.

### Authority Plane RFCs 2360–2389

#### RFC‑2360 SolNet Layer Model Revised

**Purpose**: Canonical two‑plane architecture and cross‑plane APIs. **Why**: Blueprint for how L0/L1 map to Authority and Namespace behaviors. **Defines**: plane responsibilities, cross‑plane API patterns, ProvenancePointer fetch semantics. **Interaction**: central reference for all RFCs. **Profiles**: cross‑plane governance module. **Tests**: cross‑plane interaction scenarios.

#### RFC‑2361 Identity Resolution L2

**Purpose**: UUID‑S7, NetworkCert profiles, LedgerAnchor verification, conflict resolution. **Why**: Identity is root of trust. **Defines**: Identity record formats, verification flows, conflict resolution heuristics. **Interaction**: L1 ProvenancePointer resolution, ledger anchoring. **Profiles**: constrained identity profile, ledger‑only identity profile. **Records**: IdentityRecord, NetworkCert, IdentityProof. **Tests**: identity verification, conflict resolution drills.

#### RFC‑2362 Trust Domains and Authority Policy

**Purpose**: Trust domain boundaries, issuance rules, cross‑cert chains. **Why**: Explicit, auditable trust across jurisdictions. **Defines**: TrustDomain record, cross‑cert rules, policy enforcement points. **Interaction**: L1 admission influenced by trust domain policy. **Profiles**: cross‑domain delegation module. **Tests**: cross‑cert verification, policy enforcement.

#### RFC‑2363 Directory and Routing Endpoints DRE

**Purpose**: `//info`, `//contact`, ephemeris hint publication, DRE replication. **Why**: DREs are discovery backbone. **Defines**: DREInfoRecord schema, replication rules, indexer interactions. **Interaction**: ProvenancePointer resolves to DRE entries. **Profiles**: profile registry endpoint, profile metadata schema. **Records**: DREInfoRecord, ProfileRegistryEntry. **Tests**: DRE replication, ProvenancePointer fetch, profile registry queries.

#### RFC‑2364 Ephemeris Hint Block Spec

**Purpose**: Coarse/fine ephemeris hint formats for acquisition and routing. **Why**: Acquisition and routing need compact hints. **Defines**: Hint block formats, binning strategies, confidence metrics. **Interaction**: L1 acquisition hints, L0 reservation timing. **Profiles**: high‑precision ephemeris module, coarse ephemeris for privacy. **Tests**: acquisition success rates with hint bins.

#### RFC‑2365 DTN Routing Policy

**Purpose**: Bundle addressing, priority classes, store‑and‑forward rules, reconciliation semantics. **Why**: Delay tolerance is core to SolNet. **Defines**: Bundle metadata, ProvisionalReceipt semantics, reconciliation flows. **Interaction**: Bundles carry ReservationRef and ProvenancePointer. **Profiles**: DTN minimal for prototyping, DTN full for production. **Records**: BundleEnvelope, ProvisionalReceipt, ReconciliationRecord. **Tests**: DTN delivery under partition, provisional reconciliation.

#### RFC‑2366 Ship as Router Behavior

**Purpose**: Mobile relay behavior, opportunistic forwarding, handover. **Why**: Ships are major routing nodes. **Defines**: ship relay policies, handover procedures, storage constraints. **Interaction**: tightbeam handovers, RF re‑selection. **Profiles**: ship relay capability profiles. **Tests**: handover scenarios, opportunistic forwarding correctness.

#### RFC‑2367 Collision Handling and Resolution

**Purpose**: Rules for resolving conflicting identity, DRE, or ledger entries. **Why**: Conflicts inevitable in fragmented systems. **Defines**: resolution order, tie‑break heuristics, audit trails. **Interaction**: applies to identity and DRE inconsistencies. **Tests**: conflict resolution scenarios, rollback semantics.

#### RFC‑2368 Revocation and Emergency Unbinding

**Purpose**: Emergency revocation, unbinding procedures, propagation rules. **Why**: Fast, auditable unbinding required for compromise. **Defines**: RevocationRecord, emergency unbind flows, offline fallback. **Interaction**: affects L1 admission and DRE trust. **Tests**: emergency unbind drills, revocation propagation under partition.

### Namespace Plane RFCs 2390–2419

#### RFC‑2390 Local Namespace Resolution

**Purpose**: ServiceChain resolution inside a domain, local policy overrides. **Why**: Local naming must be predictable. **Defines**: local resolver APIs, caching rules. **Interaction**: ServicePlane discovery and session bootstrap. **Tests**: resolver cache correctness, conflict handling.

#### RFC‑2391 Local Directory and Service Discovery

**Purpose**: Service advertisement, capability descriptors, TTLs. **Why**: Interoperable service discovery. **Defines**: ServiceDescriptor schema, discovery APIs. **Profiles**: discovery over ProxLink, discovery over mesh. **Tests**: discovery under mobility, TTL expiry.

#### RFC‑2392 Session and Conversation Layer

**Purpose**: Session framing, QoS, retries, session tokens, resumption. **Why**: Sessions must survive intermittent links. **Defines**: SessionToken format, resumption rules, QoS mapping. **Profiles**: session resumption for DTN, session for low‑power devices. **Tests**: session resumption across DTN hops.

#### RFC‑2393 Local Security and ACLs

**Purpose**: Per‑service authentication, roles, ACL formats. **Why**: Fine‑grained local access control. **Defines**: ACL schema, enforcement hooks. **Profiles**: role profiles for ship crew, operator, guest. **Tests**: ACL enforcement, revocation propagation.

#### RFC‑2394 Personal Namespace and Identity PNI

**Purpose**: PNI format, device/user binding, ephemeral keys, privacy defaults. **Why**: Standardize personal device behavior. **Defines**: PNI record, DelegationToken format, ephemeral key lifecycle. **Interaction**: anchors ServicePlane identity and L1 suppression. **Profiles**: personal device default, constrained device. **Tests**: delegation token misuse, PNI suppression enforcement.

#### RFC‑2395 Personal Device Integration

**Purpose**: Device profiles, AuthorityWeight/NamespaceWeight defaults, constrained behavior. **Why**: Heterogeneous devices must interoperate. **Defines**: DeviceRole profiles, compact receipt encodings. **Profiles**: Belter slab profile, handheld profile. **Tests**: constrained receipt parsing, relay‑assisted acquisition.

#### RFC‑2396 Internamespace Gateway Behavior

**Purpose**: Gateway translation, proxying, cross‑domain mapping. **Why**: Gateways mediate incompatible namespaces. **Defines**: translation rules, policy mapping, audit obligations. **Tests**: gateway translation correctness, policy enforcement.

### Cross‑plane and Operational RFCs 2420–2449

#### RFC‑2420 Bundle Addressing Protocol

**Purpose**: Canonical bundle format carrying Authority and Namespace metadata. **Why**: Bundles are primary vehicle for DTN transfers. **Defines**: Bundle envelope, ReservationRef, ProvenancePointer fields. **Profiles**: bundle minimal, bundle with reservation metadata. **Tests**: bundle delivery and reconciliation.

#### RFC‑2421 Error Codes and Diagnostics

**Purpose**: Standard error taxonomy and forensic logging formats. **Why**: Consistent diagnostics for debugging and forensics. **Defines**: error codes, severity classes, diagnostic payloads. **Tests**: diagnostic generation and parsing.

#### RFC‑2422 Mobility Hint Block

**Purpose**: Mobility hint encoding and update cadence. **Why**: Improves routing and acquisition for moving nodes. **Defines**: MobilityHint schema, update rules. **Tests**: mobility hint usefulness in routing.

#### RFC‑2423 Caching, Deduplication and Bloom Filters

**Purpose**: Cache policies, dedup strategies, seen‑packet filters. **Why**: Prevent wasteful retransmission. **Defines**: cache eviction, bloom filter parameters. **Tests**: cache reconciliation, dedup correctness.

#### RFC‑2424 Emergency Burst Protocols

**Purpose**: High‑priority burst mechanisms and abuse controls. **Why**: Life‑safety traffic must be supported without destabilizing network. **Defines**: burst admission rules, priority mapping, audit trails. **Tests**: emergency preemption, abuse detection.

### Security, Governance, Compliance RFCs 2450–2479

#### RFC‑2450 Trust Domain Enforcement and Auditing

**Purpose**: Enforcement model for cross‑domain policy and audit obligations. **Why**: Ensures accountability across jurisdictions. **Defines**: AuditEvent schema, enforcement hooks. **Tests**: cross‑domain audit reconstruction.

#### RFC‑2451 Hardware Root and Secure Element Requirements

**Purpose**: Minimum hardware security for high‑Authority nodes. **Why**: Hardware roots reduce key compromise risk. **Defines**: secure element profiles, attestation flows. **Tests**: attestation verification, secure element failure modes.

#### RFC‑2452 Post‑Quantum Crypto Migration Plan

**Purpose**: Migration timelines and algorithm profiles for PQ readiness. **Why**: Long‑lived systems must plan migration. **Defines**: migration phases, algorithm recommendations. **Tests**: PQ handshake vectors, compatibility tests.

#### RFC‑2453 Privacy and Metadata Minimization Policy

**Purpose**: System‑wide privacy defaults and opt‑in rules. **Why**: Protect users and operations from exposure. **Defines**: default exposure levels, opt‑in mechanisms. **Tests**: privacy enforcement audits.

### Developer and Game Integration RFCs 2480–2499

#### RFC‑2480 Device Role Weights and Profiles

**Purpose**: AuthorityWeight and NamespaceWeight profiles for device classes. **Why**: Standardizes behavior and admission expectations. **Defines**: role profiles, default QoS mappings. **Tests**: role behavior conformance.

#### RFC‑2481 Minimal Viable DTN for Prototyping

**Purpose**: Lightweight DTN spec for rapid prototyping. **Why**: Enables fast iteration and playable prototypes. **Defines**: minimal bundle format, compact receipts. **Tests**: prototype DTN scenarios.

#### RFC‑2482 Mission and Scenario Generator API

**Purpose**: Procedural network generation for testing and gameplay. **Why**: Automates scenario creation. **Defines**: scenario schema, generator APIs. **Tests**: scenario reproducibility.

#### RFC‑2483 Forensics and Evidence Preservation

**Purpose**: How cached bundles, logs, and traces are preserved and validated. **Why**: Forensics are essential for accountability and gameplay. **Defines**: evidence formats, chain‑of‑custody fields. **Tests**: evidence validation and chain‑of‑custody drills.

## Profiles and Modules for Each RFC

For every RFC above, a **profile/module** must be authored rather than adding mandatory L1 fields. Example modules to author immediately:

- **Tightbeam v1 module** (TLV keys: BeamID, ReservationRef, BeamFlags).
    
- **ProxLink v1 module** (TLV keys: ProxID, ProxCaps).
    
- **PD v1 module** (TLV keys: PDHint, PDPriority mapping).
    
- **OTC v1 module** (FlightPlan manifest pointer, ReservationRef semantics).
    
- **StealthHint v1 module** (StealthClass TLV, rendezvous seed pointer).
    
- **SolTLS v1 module** (ServicePlane handshake profile).
    
- **FeedManifest v1 module** (FeedID TLV, ChunkManifest pointer).
    
- **Mesh v1 module** (CommNetID TLV, GroupJoin keys).
    

Each module RFC must include: TLV key assignments, DRE profile registry entry, privacy impact statement, canonical CBOR/JSON schema, compact wire encodings, session negotiation flow, fallback rules, and test vectors.

## Schema Catalog and Canonical Records to Author Now

Produce CBOR/JSON schemas and compact binary mappings for the following canonical records (author in the order below):

1. **L1Header** (FrameType, QoSClass, FreshnessTag, ProvenancePointer, TLVContainer, CompactAuthTag).
    
2. **ProvenancePointer** canonical form.
    
3. **BeamProfileRecord** and **PointingStateRecord**.
    
4. **ReservationReceipt** and **AcquisitionReceipt**.
    
5. **RFChannelProfileRecord** and **RFLinkQualityRecord**.
    
6. **ProxBeacon**, **ProxHandshake**, **ProxTransferDescriptor**, **ProxTransferReceipt**.
    
7. **PDServiceDescriptor**, **PDCommand**, **PDAuditEvent**, **PDAdmissionReceipt**, **PDForwardingReceipt**.
    
8. **FlightPlan**, **OTCReservation**, **OTCTrackReport**, **OTCAuditEvent**.
    
9. **FeedDescriptor**, **ChunkManifest**, **ContentDeliveryReceipt**.
    
10. **BundleEnvelope**, **ProvisionalReceipt**, **DelegationToken**, **DelegationReceipt**.
    
11. **IdentityRecord**, **NetworkCert**, **LedgerAnchor**, **AnchorReceipt**.
    
12. **PaymentReceipt (SolTLS)** and **SessionResumptionToken**.
    
13. **AuditEvent** and **EvidenceBundle** formats.
    

For each schema include: field types, required/optional, provenance block, freshness fields, compact wire mapping, and one canonical example (decoded JSON + wire bytes hex).

## Implementation Roadmap and 90‑Day Immediate Actions

**Phase 0 Days 0–7**

- Freeze **RFC‑2350** L1 header and TLV container draft. Publish as working draft.
    
- Lock ProvenancePointer canonical form.
    
- Publish profile RFC template and DRE profile registry schema.
    

**Phase 1 Days 7–30**

- Author and publish **Tightbeam v1** and **ProxLink v1** profile RFC drafts (TLV keys, schemas, test vectors).
    
- Implement TLV parser library and L1 header encoder/decoder (reference code).
    
- Start DRE profile registry service skeleton.
    

**Phase 2 Days 30–60**

- Implement Reservation relay prototype and ReservationReceipt issuance.
    
- Implement ProxLink client prototype and ProxTransferReceipt generation.
    
- Run first interop: reservation→acquisition→receipt; ProxLink flick→DTN fallback.
    

**Phase 3 Days 60–90**

- Draft **SolTLS v1** and **PD v1** profile RFCs.
    
- Run adversarial tests: RF spoofing, transponder tamper, relay betrayal.
    
- Publish operator playbooks drafts for SOS, PD handoff, unmasking.
    

**Deliverables by day 90**

- RFC‑2350 draft, Tightbeam v1 and ProxLink v1 drafts, TLV parser lib, DRE registry skeleton, reservation relay prototype, ProxLink client prototype, test harness with core scenarios.
    

## Test Suite and Certification Criteria

- **Unit vectors** for every schema (CBOR/JSON + wire bytes).
    
- **Interop scenarios**: Tightbeam reservation→acquisition→handover; ProxLink flick→partial→DTN reconciliation; SolTLS payment + ContentDeliveryReceipt pairing; OTC flight plan reservation and clearance.
    
- **Adversarial tests**: RF spoofing, transponder tamper, jamming windows, relay delegation misuse.
    
- **Forensics drills**: reconstruct incident from receipts + DRE + ledger anchors.
    
- **Certification pass/fail**: header parsing, TLV skipping, ProvenancePointer fetch, signature verification, delegation token validation, fallback behavior.
    

## Governance, Versioning, and Migration

- **Profile RFC template** mandatory for any new capability. Profiles must include privacy impact, test vectors, and DRE registry entry.
    
- **Versioning**: semver for profiles; DRE registry lists supported versions.
    
- **Deprecation**: 24‑month deprecation window for any mandatory L1 change.
    
- **Approval board**: charter a cross‑domain board for life‑safety and privacy‑sensitive profiles (PD, OTC, Stealth). Multi‑party signoff required for unmasking flows.
    

## Final Checklist to Begin Drafting the Full Corpus

- [ ] Publish RFC‑2300 canonical terminology.
    
- [ ] Publish RFC‑2350 L1 header and TLV container draft.
    
- [ ] Publish profile RFC template and DRE profile registry schema.
    
- [ ] Author Tightbeam v1 and ProxLink v1 profile RFCs.
    
- [ ] Produce canonical CBOR/JSON schemas for the top 13 records listed above.
    
- [ ] Implement TLV parser and L1 header encoder/decoder reference libs.
    
- [ ] Stand up DRE profile registry service skeleton.
    
- [ ] Implement reservation relay and ProxLink client prototypes.
    
- [ ] Run interop sprints and adversarial tests; publish results.




**RFC‑24xx — Autonomous and Delegated Network Actors**

That RFC could cover things like:

- Agent identity lifecycles.
    
- Sub‑agent spawning and teardown.
    
- Delegation chaining limits.
    
- Rate and scope constraints for automated actors.
    
- Audit expectations for non‑interactive decision systems.
    
- Failure modes unique to continuous actors.
    

Crucially, that RFC would **depend on** RFC‑2300, not modify it. If AI changes, that RFC evolves. The foundation stays put.

That’s how you keep this thing usable ten years from now.

Net result:

- §6 now clearly anticipates AI without naming it.
    
- RFC‑2300 remains timeless.
    
- You have a clean place to put agent‑specific weirdness later.
    
- And SolNet still reads like it was written by people who’ve been burned before.
    

If you want, next we can sketch the outline for that **Autonomous and Delegated Actors RFC** so it slots cleanly into the corpus without contaminating the core.


#CHANGES
### 1. Make “judgment, not optimization” explicit in one place

Right now, the idea that routing is **judgment under uncertainty** is present implicitly across DTN policy, scenario generation, and forensics — but it never gets a single declarative anchor.

That’s risky, because future implementers will instinctively optimize.

One short paragraph belongs in **RFC‑2365 (DTN Routing Policy)** or **RFC‑2360 (Layer Model)**:

- Routing decisions are locally rational, not globally optimal.
    
- Disagreement between nodes is expected.
    
- Evidence, latency, safety, and governance are tradeoffs, not absolutes.
    

This doesn’t add machinery — it prevents future RFCs from “fixing” emergent behavior.

### 2. Clarify that conformance is inferred, not reported

You’ve done the hard work to avoid reputation systems, but the documents still occasionally _sound_ like conformance might be something a node advertises.

A single tightening sentence in **RFC‑2300 (Terminology)** would lock this down:

- Conformance is inferred from observed behavior and receipts.
    
- Self‑reported state is advisory and unreliable.
    
- Silence is not negative evidence.
    

This protects you from accidental re‑introduction of trust scores later.

### 3. Call out “unreliable narrator” as a design principle

This concept emerged organically in discussion, but it’s not named anywhere in the corpus.

It should be — because it explains:

- why logs can contradict,
    
- why routers disagree,
    
- why audits are political.
    

A short subsection in **RFC‑2421 (Error Codes & Diagnostics)** or **RFC‑2483 (Forensics)** would do it:

- Logs are testimony, not truth.
    
- Contradictions are expected.
    
- Reconstruction is probabilistic.
    

That gives game designers and tool authors permission to lean into ambiguity instead of smoothing it away.

### 4. Tighten the boundary around AI / autonomous actors

You did the right thing by deferring AI to RFC‑24xx, but one more sentence would make that deferral _defensive_, not just organizational.

In **RFC‑2300** or **RFC‑2360**, explicitly state:

- Core protocol behavior must be implementable without learning systems.
    
- Autonomous actors may tune parameters but must not redefine semantics.
    

This prevents future “AI‑powered routing” proposals from creeping into the substrate.

### 5. Slightly elevate paranoia as a rational failure mode

Paranoia currently exists as an emergent outcome, which is correct — but it’s not named as _acceptable_.

A single line in **RFC‑2309 (L0 Test Suite)** or **RFC‑2482 (Scenario Generator)** would help:

- Defensive and overly conservative behavior is a valid outcome under adversarial conditions.
    

That legitimizes scenarios where the network becomes slow, fragmented, or suspicious — which is exactly the Expanse tone.

### 6. One small editorial punch: gravity as cost, not morality

Standards gravity is well defined, but occasionally reads like a normative hierarchy.

A light wording pass anywhere gravity is introduced to emphasize:

- gravity bends expectations and costs,
    
- not correctness or virtue,
    

would keep it from being misread as “inner system good, fringe bad.”


# **1. Police override controls for a station**

(_Example: Ceres Station security having override authority on local systems_)

### ✔️ **Covered in SolNet by:**

- **RFC‑2362 — Trust Domains & Authority Policy (A‑stack)**
    
- **RFC‑2368 — Revocation & Emergency Unbinding (A‑stack)**
    
- **RFC‑2393 — Local Security & ACLs (N‑stack)**
    
- **RFC‑2450 — Trust‑Domain Enforcement & Auditing (Security)**
    

### ✔️ **How it works in your architecture**

Stations, governments, and security forces are **Trust Domains**. They have:

- **AuthorityWeight**
    
- **OverridePolicy**
    
- **EmergencyUnbinding rights**
    
- **Local ACL enforcement**
    

So a “police override” is simply:

> A high‑AuthorityWeight domain asserting override rights on a local namespace or service chain.

This is _exactly_ what the A‑stack was designed for.

# **2. Pirate broadcasts**

(_Example: Belter pirate radio, unauthorized transmissions, hijacked channels_)

### ✔️ **Covered in SolNet by:**

- **RFC‑2307 — RF Propagation Subprofile (L0)**
    
- **RFC‑2308 — Media Privacy & Exposure Policy (L0)**
    
- **RFC‑2424 — Emergency Burst Protocols (Cross‑plane)**
    
- **RFC‑2451 — Hardware Root & Secure Element Requirements (Security)**
    

### ✔️ **How it works in your architecture**

Pirate broadcasts are simply:

- **unauthorized emissions**
    
- **non‑compliant RF frames**
    
- **frames lacking valid TrustTag or CompactAuthTag**
    
- **frames violating Media Exposure Policy**
    

Your system already defines:

- how unauthorized emissions are detected
    
- how they appear in forensic logs
    
- how relays treat them
    
- how devices classify them (EC‑6005, etc.)
    

So pirate broadcasts are a **first‑class irregularity** in SolNet.

# **3. Miller checking a flight profile: local cache → remote station query**

(_Example: Ceres → Pallas lookup chain_)

### ✔️ **Covered in SolNet by:**

- **RFC‑2363 — Directory & Routing Endpoints (DRE)**
    
- **RFC‑2390 — Local Namespace Resolution (N2)**
    
- **RFC‑2391 — Local Directory & Service Discovery (N3)**
    
- **RFC‑2420 — Bundle Addressing Protocol (Cross‑plane)**
    

### ✔️ **How it works in your architecture**

This is **exactly** how your DRE + Namespace Plane works:

1. **Local DRE checks local cache** (Ceres DRE checks its own Directory & Routing Endpoint)
    
2. **If not found, escalate to upstream DRE** (Ceres → Pallas → Ceres cluster → Belt cluster → etc.)
    
3. **Namespace resolution returns the flight profile** (N2/N3 resolution chain)
    

This is already baked into the architecture — you literally designed it to behave like this.

# **So are all three Expanse behaviors covered?**

**Yes.** And not only “covered,” but **cleanly mapped** to the exact layers that should handle them.

Here’s the quick mapping:

|Expanse Behavior|SolNet Layer|RFCs|
|---|---|---|
|Police override|A‑stack (Authority)|2362, 2368, 2393, 2450|
|Pirate broadcasts|L0 (RF), Security|2307, 2308, 2424, 2451|
|Flight profile lookup|DRE + Namespace|2363, 2390, 2391, 2420|

Everything fits.