# RFC‑2300 — SolNet Terminology & Concepts

**SolNet Standards Working Group (SSWG)** **Status:** Informational / Foundational

## Lead note on legacy names

The canonical plane names used in this document are **Location Plane** and **Service Plane**. Older deployments, archived specifications, and certain stubborn operators may still refer to these as the **Authority Plane** (Location) and the **Namespace Plane** (Service). Those aliases remain valid for interoperability and historical reference, but the canonical terminology is Location / Service.

Anyone mixing the old and new names in the same deployment will get exactly the level of confusion they deserve, and probably deserve the outage that follows.

## 1 Purpose

SolNet has accumulated enough terminology drift over the years that a single, stable reference is overdue. This RFC defines the vocabulary, core concepts, and primitives used across the SolNet specification suite. It establishes the canonical identifier class (UUID‑S7), the two‑plane architecture (Location and Service), the shared physical and data‑link substrate, and the device role continuum.

The intent is simple: give every subsequent RFC a common foundation so implementers do not have to guess which meaning of “namespace” or “authority” was intended this time. Guessing has historically gone poorly.

## 2 Scope

This document covers terms, identifier classes, layer names, role weights, and the minimal behavioral expectations for edge and core entities. It does **not** define wire formats, cryptographic algorithms, or routing policies in detail; those belong to later RFCs.

This RFC is normative for terminology and conceptual boundaries only. Anyone treating it as a full protocol specification will quickly discover the limits of optimism, usually during integration testing.

## 3 Core definitions

### SolNet

The interlinked, delay‑tolerant, jurisdictionally fragmented communications fabric spanning the system. It operates across everything from disciplined fleet networks to improvised Belter rigs held together with tape, hope, and whatever firmware version happened to be on hand.

### UUID‑S7

The canonical SolNet identifier class: a 128‑bit, time‑sortable identifier compatible with UUIDv7 semantics and extended for ledger friendliness. Implementations **MUST** treat UUID‑S7 as the primary NetworkID for domain anchors and long‑lived entities.

Anything else invites identity collisions, reconciliation nightmares, and long nights in audit review explaining why two ships now think they are the same object.

### LocationChain

Left‑hand textual chain naming identity authority, trust domain, and coarse location semantics (example: `MCRC:ALPHAFLEET:DONNAGER`). LocationChain entries are paired cryptographically with UUID‑S7 anchors.

This is the part of the address that tells the network who is speaking and roughly where they belong. It is not a routing table, and it is not a service path, no matter how tempting that might be.

### ServiceChain

Right‑hand textual chain naming internal domain structure and service paths (example: `ENGINEERING:ENG‑1:Reactor`). ServiceChain resolution is local to the domain.

This is the part that tells the network what the sender is actually trying to reach. If you leak it globally, that is on you.

### Location Plane (L‑stack)

Layers and services concerned with global identity, coarse ephemeris, beaconing hints, and inter‑domain reachability. Legacy alias: **Authority Plane**, for those still living in the past.

### Service Plane (S‑stack)

Layers and services concerned with local naming, service discovery, sessions, and intra‑domain policy. Legacy alias: **Namespace Plane**, for those who enjoy ambiguity.

### Physical Substrate (L0)

The shared physical media and propagation environment: tightbeam, RF, optics, occlusion, and whatever space weather decides to contribute that day.

### Data‑Link Split (L1‑L / L1‑S)

A single physical frame carrying two header views: L1‑L for Location metadata and L1‑S for Service framing. This split exists because mixing global identity with local service metadata in the same header has historically produced more problems than it solved, and nobody wants to relive that experiment.

### Role Weight

Numeric or categorical attributes (LocationWeight, ServiceWeight) describing how strongly a node participates in each plane. A node that claims to be “balanced” usually means “confused,” and should be treated accordingly.

### PNI (Personal Namespace Identifier)

A user‑centric identifier bound to a device and optionally anchored to UUID‑S7 for trust. Useful for personal devices that do not need full Location anchoring and should not be pretending otherwise.

### LedgerAnchor

Append‑only registry entry recording UUID‑S7 ↔ LocationChain bindings and revocations. The ledger remembers everything, including mistakes, and it does not forget just because an operator wishes it would.

## 4 Architectural primitives

### 4.1 Two planes, one substrate

SolNet models two orthogonal logical planes operating over a single physical substrate. The Location Plane answers _who_ and _where_. The Service Plane answers _what_ and _how to talk to it_.

Both planes share L0 and the split L1 frame. Devices participate in one or both planes depending on role weight and policy. Under stress—partitions, stale data, misconfigured relays—the separation prevents local naming chaos from leaking into global routing. This separation exists because experience says it has to.

### 4.2 UUID‑S7 as canonical NetworkID

UUID‑S7 is the stable identity anchor for ledger entries and cross‑domain references. Time‑sortable semantics assist ledger ordering and audit trails.

Implementations **MUST** preserve 128‑bit compatibility while allowing SolNet extension bits. When ledger writes are delayed, systems operate in UNVERIFIED mode with reduced privileges and explicit confidence metadata. Pretending otherwise just makes the eventual reconciliation louder.

### 4.3 Canonical address form

Code

```
<LocationChain> // <ServiceChain>
```

The `//` boundary is mandatory. Parsers **MUST** enforce a single `//`. This prevents the all‑too‑common error of treating a local service path as a global identity.

In mixed deployments, legacy aliases may appear; parsers **SHOULD** normalize them internally and move on with their lives.

### 4.4 Role weights and device profiles

Role weights place devices on a continuum between Location‑heavy and Service‑heavy. They inform metadata exposure, hardware security requirements, and revocation impact.

When a node’s advertised role weight conflicts with observed behavior, systems log AuditEvents and increase verification steps. This happens more often than anyone likes to admit, usually right before something expensive breaks.

## 4.5 UUID‑S7 rationale

SolNet has gone through enough identity schemes over the decades that a stable, predictable anchor was overdue. UUID‑S7 is the result of that long trail of experiments, half‑finished proposals, and a few catastrophic collisions that everyone pretends never happened.

The format is intentionally conservative. It keeps the parts that work, removes the parts that caused trouble, and avoids clever additions that would only age poorly in a system that spans the entire solar system.

### Why time‑sortable identifiers matter

SolNet is built on append‑only logs, deferred replication, and reconciliation after long partitions. Nodes go dark for hours or days, then come back and dump a backlog of events into the network.

A time‑sortable identifier makes that mess survivable. The timestamp field in UUID‑S7 gives the ledger a fighting chance at reconstructing event order without relying on synchronized clocks, which are a luxury many devices do not have. Even when clocks drift, the combination of timestamp and randomness keeps ordering stable enough for audit trails and conflict resolution.

### Why the identifier stays opaque

There is a long list of things operators have tried to cram into identifiers over the years: domain names, ship IDs, antenna positions, and once even a reactor serial number. Every attempt caused more problems than it solved.

UUID‑S7 is deliberately opaque. It does not leak location, authority, or operational metadata. Anything that needs to be known about a node—where it is, who runs it, what it can do—belongs in **LocationChain**, **L1‑L metadata**, or **LedgerAnchor** records. Keeping UUID‑S7 clean prevents accidental disclosure and keeps identity separate from routing and policy.

### Why location is not embedded

It is tempting to add a few bits of location into the identifier so that a UUID minted on Luna never looks like one minted on Ceres. The math does not justify it.

The random payload in UUID‑S7 is large enough that collisions remain effectively impossible, even when thousands of devices generate IDs at the same millisecond. Embedding location would not improve uniqueness, but it would leak operational patterns, break compatibility with existing UUID tooling, and force devices to know their domain before they can generate an ID. SolNet already has a place for location metadata, and it is not inside the identifier.

### How UUID‑S7 behaves under stress

SolNet assumes the worst: drifting clocks, low‑entropy devices, long partitions, and operators who forget to rotate keys. UUID‑S7 holds up under all of it.

Timestamp drift affects ordering but not uniqueness. Randomness absorbs simultaneous generation events. Reconciliation rules handle out‑of‑order anchors. Opaque identifiers prevent metadata leakage. Even constrained devices can mint UUID‑S7 values offline without coordination, which is essential in a network where “offline” is a normal operating mode.

## 5 Layer model (conceptual)

### 5.1 L0 — Physical substrate

Handles propagation physics, pointing, occlusion, and power. L0 events—solar storms, eclipses, debris fields—are first‑order inputs to routing and availability. When L0 misbehaves, everything above it suffers accordingly, and no amount of protocol elegance will save you.

### 5.2 L1 — Data‑Link (L/S split)

A single frame carries two header regions:

- **L1‑L:** compressed UUID‑S7 hints, trust tags, coarse ephemeris, beacon descriptors, relay capability.
    
- **L1‑S:** service path hashes, service IDs, session tokens, QoS.
    

Nodes parse only what they need. Under high latency or partial parsing, nodes fall back to cached L1‑S state and treat L1‑L hints conservatively. This is not paranoia; it is experience.

### 5.3 L‑stack (Location Plane) — L2..L5

- **L2 Identity Resolution:** UUID‑S7, NetworkKey, NetworkCert, LedgerAnchor.
    
- **L3 Directory & Reachability Endpoints:** publish `//info` and `//beacon` plus coarse ephemeris hints.
    
- **L4 Routing & Mobility:** DTN semantics, store‑and‑forward, ship‑as‑router policies.
    
- **L5 Trust & Policy:** cross‑domain enforcement, revocation, jurisdictional rules.
    

When DREs disagree, clients increase error bounds and verify with multiple sources. Trust, but verify, and then verify again.

### 5.4 S‑stack (Service Plane) — S2..S5

- **S2 Local Service Resolution**
    
- **S3 Local Directory / Service Discovery**
    
- **S4 Session / Conversation Layer**
    
- **S5 Local Security & ACLs**
    

Under partitions, the S‑stack continues operating locally even when L‑stack information is stale. This is by design, not an accident.

## 6 Device and identity models

### 6.1 Device identity hierarchy

Hardware roots, DeviceKeys, Session Keys, and PNIs form the identity chain. When hardware attestation is unavailable, systems reduce trust and require additional provenance. This is not punishment; it is risk management.

### 6.2 Registration and binding

Devices may operate unanchored or be registered with a NetworkCert binding LocationChain → UUID‑S7 → NetworkKey. LedgerAnchor entries are recommended for long‑lived anchors and required for high‑Location nodes.

### 6.3 Relay and cache behavior

Relays advertise capability via L1‑L only when policy allows. Caching uses TTL, priority, and quotas; deduplication uses seen‑filters.

When relays queue or evict items due to limits, they **MUST** emit AdmissionReceipts and AuditEvents. Silent drops are how investigations start.

## 7 Security and privacy principles

- L1‑L exposure **SHOULD** be minimized for personal devices.
    
- High‑Location nodes **SHOULD** use hardware roots and ledger anchoring.
    
- ServiceChain **MUST NOT** be used to infer global identity.
    
- Revocation flows through L2→L5 and **SHOULD** be visible to L1 relays.
    
- Long‑lived signatures **MUST** consider post‑quantum migration.
    

Under degraded conditions, conservative defaults and multi‑party verification reduce risk. Optimism does not.

## 8 Record types and canonical fields

Canonical record types include:

- FrameDefinitionRecord
    
- PowerCapabilityRecord
    
- AntennaGeometryRecord
    
- AntennaAlignmentStateRecord
    
- PowerPolicyRecord / DutyCycleRecord
    
- PowerStateRecord / DutyScheduleRecord
    
- NetworkCert / LedgerAnchor
    
- DelegationToken / DelegationReceipt
    
- AuditEvent
    

All records **MUST** include provenance and freshness metadata. When freshness is uncertain, consumers treat records as advisory and increase verification steps. Acting confidently on stale data is how incidents happen.

## 9 Operational semantics and workflows

The workflows in this section are presented as detailed, step‑by‑step operational sequences. Each describes the actions taken by participating nodes, the records produced at each stage, and the expected behavior under delay, partitions, misconfiguration, and inconsistent operator practices. The intent is to make the operational flow explicit enough that implementations across different domains can behave predictably even when local conditions vary widely.

### 9.1 Identity anchoring and ledger binding

1. An operator submits a NetworkCert request containing a UUID‑S7, LocationChain, and DeviceKey attestation.
    
2. The authority validates the request, including hardware root attestations where available.
    
3. The authority writes a LedgerAnchor entry binding UUID‑S7 to the LocationChain and signs it.
    
4. The authority publishes NetworkCert and LedgerAnchor references to DREs.
    
5. The requester records the LedgerAnchor reference locally and emits an AuditEvent.
    

**Behavior under stress:** Delayed ledger writes force UNVERIFIED mode. Conflicting anchors generate audit trails that investigators later unravel, usually with coffee.

### 9.2 Cross‑domain service discovery

1. A client issues L1‑L and L1‑S queries with explicit freshness requirements.
    
2. DREs respond with `//info` records and coarse ephemeris or beacon hints.
    
3. The client resolves the ServiceChain locally and selects candidate endpoints.
    
4. Session keys are negotiated and session state is logged.
    

**Behavior under stress:** Stale DRE responses increase error bounds. Misconfigured DREs produce AuditEvents that help trace failures back to their source.

### 9.3 Delegation for constrained devices

1. A constrained device publishes a compact PowerCapabilityRecord.
    
2. The device issues a DelegationToken to a trusted relay.
    
3. The relay records the delegation and issues a DelegationReceipt.
    
4. The relay submits DutyScheduleRecords and forwards ReservationReceipts on behalf of the device.
    
5. The device transmits during accepted windows while the relay logs full AuditEvents.
    

**Behavior under stress:** Compromised relays affect many devices; limited‑validity delegations reduce blast radius. Partitions require conservative fallback behavior and patience.

## 10 Privacy, revocation, and compliance

Domains **MUST** document L1‑L exposure rules. Revocation records **MUST** be signed and propagated through L5→L4→L3→L1.

Implementations **MUST** adopt UUID‑S7, enforce `//` parsing, implement L1 split semantics, support role weights, and treat ServiceChain as local. Deviations will be noticed.

## 11 Deployment models and examples

- **Personal communicator:** minimal L1‑L exposure; uses PNI.
    
- **Ship relay:** high LocationWeight; advertises relay capability and coarse ephemeris.
    
- **Station console:** high ServiceWeight; provides rich S‑stack services.
    

Each deployment model **SHOULD** include documented identity, delegation, and revocation policies. “We’ll figure it out later” is not a policy.

## 12 APIs and interfaces

APIs expose identity resolution, DRE endpoints, service resolution, scheduling and delegation, and audit retrieval. Responses **MUST** include provenance and freshness metadata. Compact encodings **SHOULD** be supported for constrained devices, because not everyone has a rack of servers.

## 13 Forensics and auditability

AuditEvents **SHOULD** reference related records to enable timeline reconstruction. Retention policies **MUST** be defined in domain PolicyRecords.

Missing logs surface as audit gaps and require investigation. Silence is not evidence of correctness.

## 14 Next steps and roadmap

- RFC‑2360 defines formal L1 header encodings.
    
- RFC‑2481 defines the minimal DTN profile.
    
- Additional RFCs define wire formats, cryptographic profiles, ledger APIs, and device profiles.