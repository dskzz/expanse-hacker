# RFC‑2300 — SolNet Terminology & Concepts

**SolNet Standards Working Group (SSWG)** **Status:** Informational / Foundational

## Lead note on legacy names

The canonical plane names used in this document are **Location Plane** and **Service Plane**. Older deployments, archived specifications, and certain stubborn operators may still refer to these as the **Authority Plane** (Location) and the **Namespace Plane** (Service). Those aliases remain valid for interoperability and historical reference, but the canonical terminology is Location / Service. Anyone mixing the old and new names in the same deployment will get exactly the level of confusion they deserve.

## 1 Purpose

SolNet has accumulated enough terminology drift over the years that a single, stable reference is overdue. This RFC defines the vocabulary, core concepts, and primitives used across the SolNet specification suite. It establishes the canonical identifier class (UUID‑S7), the two‑plane architecture (Location and Service), the shared physical/data‑link substrate, and the device role continuum. The intent is to give every subsequent RFC a common foundation so implementers do not have to guess which meaning of “namespace” or “authority” was intended this time. Guessing has historically gone poorly.

## 2 Scope

This document covers terms, identifier classes, layer names, role weights, and the minimal behavioral expectations for edge and core entities. It does **not** define wire formats, cryptographic algorithms, or routing policies in detail; those belong to later RFCs. This RFC is normative for terminology and conceptual boundaries only. Anyone treating it as a full protocol specification will quickly discover the limits of optimism.

## 3 Core definitions

### SolNet

The interlinked, delay‑tolerant, jurisdictionally fragmented communications fabric spanning the system. It works across everything from disciplined fleet networks to improvised Belter rigs held together with tape and hope.

### UUID‑S7

The once‑hoped‑to‑be‑canonical SolNet identifier class: a 128‑bit, time‑sortable identifier compatible with UUIDv7 semantics and extended for ledger friendliness.

Implementations **MUST** support UUID‑S7 as the primary NetworkID **for ledger‑anchored identity and cross‑domain references**. Local systems **MAY** use other identifier schemes internally, but anything that needs to survive audit, reconciliation, or jurisdictional disagreement eventually gets bound to a UUID‑S7.

Anything else invites identity collisions and long nights in audit review.
### LocationChain

Left‑hand textual chain naming identity authority, trust domain, and coarse location semantics (example: `MCRC:ALPHAFLEET:DONNAGER`). LocationChain entries are paired cryptographically with UUID‑S7 anchors. This is the part of the address that tells the network who is speaking and roughly where they belong.

### ServiceChain

Right‑hand textual chain naming internal domain structure and service paths (example: `ENGINEERING:ENG‑1:Reactor`). ServiceChain resolution is local to the domain.

This is the part that tells the network what the sender is actually trying to reach. If you leak it globally, that is on you.

### Location Plane (L‑stack)

Layers and services concerned with global identity, coarse ephemeris, beaconing hints, and inter‑domain reachability. Legacy alias: **Authority Plane**, for those still living in the past.

### Service Plane (S‑stack)

Layers and services concerned with local naming, service discovery, sessions, and intra‑domain policy. Legacy alias: **Namespace Plane**, for those who enjoy ambiguity.

### Physical Substrate (L0)

The shared physical media and propagation environment: tightbeam, RF, optics, occlusion, and whatever space weather decides to contribute.

### Data‑Link Split (L1‑L / L1‑S)

A single physical frame carrying two header views: L1‑L for Location metadata and L1‑S for Service framing. This split exists because mixing global identity with local service metadata in the same header has historically produced more problems than it solved, and nobody wants to relive that experiment.

### Role Weight

Numeric or categorical attributes (LocationWeight, ServiceWeight) describing how strongly a node participates in each plane. A node that claims to be “balanced” usually means “confused.”

### PNI (Personal Namespace Identifier)

A user‑centric identifier bound to a device and optionally anchored to UUID‑S7 for trust. Useful for personal devices that do not need full Location anchoring.

### LedgerAnchor

Append‑only registry entry recording UUID‑S7 ↔ LocationChain bindings and revocations. The ledger remembers everything, including mistakes.

### TLV (Type‑Length‑Value)
A self‑describing metadata block consisting of an 8‑bit key, a length field, and a value field. TLVs extend AddressRecords without altering their base grammar.

## 4 Architectural primitives

### 4.1 Two planes, one substrate

SolNet models two orthogonal logical planes operating over a single physical substrate. The Location Plane answers _who_ and _where_; the Service Plane answers _what_ and _how to talk to it_. Both planes share L0 and the split L1 frame. Devices participate in one or both planes depending on role weight and policy. Under stress—partitions, stale data, misconfigured relays—the separation prevents local naming chaos from leaking into global routing.

### 4.2 UUID‑S7 as canonical NetworkID

UUID‑S7 is the stable identity anchor for ledger entries and cross‑domain references. Time‑sortable semantics assist ledger ordering and audit trails.

Implementations **MUST** support UUID‑S7 as the canonical NetworkID **at the point where identity is anchored, audited, or enforced across domains**. Implementations **MAY** use other identifier schemes internally or locally, provided those identifiers are explicitly bound to a UUID‑S7 when participating in ledger anchoring, provenance resolution, or cross‑domain trust.

When ledger writes are delayed, systems operate in UNVERIFIED mode with reduced privileges and explicit confidence metadata.

### 4.3 Canonical address form

Code

```
<LocationChain> // <ServiceChain>
```

The `//` boundary is mandatory. Parsers **MUST** enforce a single `//`. This prevents the all‑too‑common error of treating a local service path as a global identity. In mixed deployments, legacy aliases may appear; parsers **SHOULD** normalize them internally.

### 4.4 Role weights and device profiles

Role weights place devices on a continuum between Location‑heavy and Service‑heavy. They inform metadata exposure, hardware security requirements, and revocation impact. When a node’s advertised role weight conflicts with observed behavior, systems log AuditEvents and increase verification steps. This happens more often than anyone likes to admit, usually right before something expensive breaks.

## 4.5 UUID‑S7 Rationale

SolNet has gone through enough identity schemes over the decades that a stable, predictable anchor was overdue. UUID‑S7 is the result of that long trail of experiments, half‑finished proposals, and a few catastrophic collisions that everyone pretends never happened. The format is intentionally conservative: it keeps the parts that work, removes the parts that caused trouble, and avoids clever additions that would only age poorly in a system that spans the entire solar system.

### 4.6 Identifier pluralism and anchoring

SolNet does **not** assume that every system, device, or operator uses the same identifier scheme, and it would be a mistake to pretend otherwise. In practice, the network spans legacy infrastructure, improvised local systems, tightly controlled military environments, and personal devices that were never designed with global identity in mind. Expecting all of that to converge on a single identifier format would be optimistic in the way that usually precedes outages.

Instead, SolNet distinguishes between **local identifiers** and **canonical anchors**.

Local identifiers are whatever a domain already uses to keep itself organized. They may be UUIDv4s, serial numbers, human‑meaningful names, fleet‑specific codes, or something a Belter scribbled into firmware at 02:00 because it was good enough at the time. SolNet does not attempt to standardize these, and it does not require them to be globally unique. They are allowed to be messy, overlapping, or even contradictory, as long as they make sense inside their own domain.

UUID‑S7, by contrast, exists to serve as the **canonical anchor** when identity needs to cross domain boundaries, survive partitions, or be recorded in an append‑only ledger without ambiguity. UUID‑S7 is the identifier the ledger understands, the identifier ProvenancePointers ultimately resolve to, and the identifier used when trust, auditability, or cross‑domain enforcement is required.

The important distinction is that SolNet standardizes the **binding**, not the source identifier.

When a local identifier needs to participate in global operations, it is bound to a UUID‑S7 through explicit records such as NetworkCerts, LedgerAnchors, DelegationTokens, or other provenance‑bearing artifacts. That binding is auditable, revocable, and time‑bounded where appropriate. The local identifier itself does not need to change, and in many cases should not.

This approach allows several things to be true at once:

- A constrained personal device may operate entirely with a PNI and never mint a UUID‑S7 unless escalation or audit requires it.
    
- A legacy system may continue using its existing identifier scheme internally while exposing a UUID‑S7 anchor externally.
    
- A relay may temporarily bind a foreign identifier to a UUID‑S7 via delegation without permanently rewriting the originating system.
    
- Multiple local identifiers may legitimately map to the same UUID‑S7 over time, with the ledger preserving the history rather than pretending it never happened.
    

Operationally, this means that UUID‑S7 should be treated as the point where SolNet stops arguing about names and starts agreeing on facts. Everything before that point is local convention; everything after it is subject to ledger rules, provenance checks, and audit.

Implementations **MUST NOT** assume that the presence of a UUID‑S7 implies uniform behavior upstream, nor that the absence of one implies untrustworthiness. Instead, systems **MUST** rely on explicit bindings, freshness metadata, and provenance records to determine how much confidence to place in any given identifier at any given moment.

In short, SolNet expects identifier diversity. UUID‑S7 exists to make that diversity survivable, not to eliminate it.
### Why time‑sortable identifiers matter

SolNet is built on append‑only logs, deferred replication, and reconciliation after long partitions. Nodes go dark for hours or days, then come back and dump a backlog of events into the network. A time‑sortable identifier makes that mess survivable. The timestamp field in UUID‑S7 gives the ledger a fighting chance at reconstructing event order without relying on synchronized clocks, which are a luxury many devices do not have. Even when clocks drift, the combination of timestamp and randomness keeps ordering stable enough for audit trails and conflict resolution.

### Why the identifier stays opaque

There is a long list of things operators have tried to cram into identifiers over the years: domain names, ship IDs, antenna positions, and once even a reactor serial number. Every attempt caused more problems than it solved. UUID‑S7 is deliberately opaque. It does not leak location, authority, or operational metadata. Anything that needs to be known about a node—where it is, who runs it, what it can do—belongs in **LocationChain**, **L1‑L metadata**, or **LedgerAnchor** records. Keeping UUID‑S7 clean prevents accidental disclosure and keeps identity separate from routing and policy.

### Why location is not embedded

It is tempting to add a few bits of location into the identifier so that a UUID minted on Luna never looks like one minted on Ceres. The math does not justify it. 

The random payload in UUID‑S7 is large enough that collisions remain effectively impossible, even when thousands of devices generate IDs at the same millisecond. Embedding location would not improve uniqueness, but it would leak operational patterns, break compatibility with existing UUID tooling, and force devices to know their domain before they can generate an ID. SolNet’s architecture already has a place for location metadata, and it is not inside the identifier.

### Why the structure looks the way it does

UUID‑S7 follows the UUIDv7 model because it is predictable, well‑understood, and supported by existing libraries. The SolNet‑specific extension bits exist for future use, but they are intentionally small and tightly constrained. The goal is to keep the identifier stable for decades, not reinvent it every time a new domain wants to encode its favorite hint into the bitstream.

### How UUID‑S7 behaves under stress

SolNet assumes the worst: drifting clocks, low‑entropy devices, long partitions, and operators who forget to rotate keys. UUID‑S7 holds up under all of it. Timestamp drift affects ordering but not uniqueness. Randomness absorbs simultaneous generation events. Reconciliation rules handle out‑of‑order anchors. Opaque identifiers prevent metadata leakage. Even constrained devices can mint UUID‑S7 values offline without coordination, which is essential in a network where “offline” is a normal operating mode.

### Summary

UUID‑S7 is intentionally simple: time‑sortable, opaque, globally unique, and compatible with existing tooling. It does not encode location, authority, or policy. Those belong elsewhere in the architecture. The identifier’s job is to be stable, predictable, and boring—qualities SolNet needs more of.


## ## 5 Layer model (conceptual)

SolNet’s layer model exists because pretending everything is a clean, synchronous, well‑behaved network has never survived first contact with reality. The layers described here are not theoretical abstractions; they are fault lines. Each one exists to contain a specific class of failure so it does not cascade upward and take everything else with it.

### 5.1 L0 — Physical substrate

L0 handles propagation physics, pointing, occlusion, and power. This includes tightbeam alignment, RF behavior, optical links, interference, and whatever space weather decides to contribute without asking permission.

L0 events—solar storms, eclipses, debris fields, misaligned antennas, power brownouts—are first‑order inputs to routing and availability. They are not edge cases. They are the environment. When L0 misbehaves, everything above it suffers accordingly, and no amount of protocol elegance will make photons travel through a rock.

Higher layers are expected to treat L0 as unreliable by default. Optimistic assumptions here tend to show up later as incident reports.

### 5.2 L1 — Data‑Link (L/S split)

L1 defines a single physical frame carrying two logically distinct header regions:

- **L1‑L:** compressed UUID‑S7 hints, trust tags, coarse ephemeris, beacon descriptors, and relay capability metadata intended for Location‑plane consumers.
    
- **L1‑S:** service path hashes, service identifiers, session tokens, and QoS metadata intended for Service‑plane consumers.
    

The split exists because mixing global identity and local service metadata in the same header has historically produced more problems than it solved. When those concerns bleed together, local misconfiguration has a habit of turning into global outages.

Nodes are expected to parse only what they need. A relay concerned with reachability may ignore most of L1‑S. A service endpoint may treat L1‑L hints conservatively or not at all. Under high latency, partial parsing, or degraded conditions, nodes fall back to cached state and explicit freshness metadata rather than assuming the wire is telling the whole truth.

This is not a performance optimization. It is damage control.

### 5.3 L‑stack (Location Plane) — L2 through L5

The Location Plane is responsible for answering questions about identity, reachability, and trust across domains that do not necessarily like or trust each other.

- **L2 Identity Resolution:** Handles UUID‑S7, NetworkKeys, NetworkCerts, and LedgerAnchors. This is where local identifiers stop being opinions and start being facts, at least as far as the ledger is concerned.
    
- **L3 Directory & Reachability Endpoints:** Publishes `//info` and `//beacon` records along with coarse ephemeris hints. These endpoints are advisory, replicated, and occasionally wrong.
    
- **L4 Routing & Mobility:** Implements delay‑tolerant networking semantics, store‑and‑forward behavior, and ship‑as‑router policies. This layer assumes links will disappear without notice and plans accordingly.
    
- **L5 Trust & Policy:** Enforces cross‑domain rules, revocation, and jurisdictional constraints. This is where politics, law, and cryptography finally collide.
    

When DREs disagree—and they will—clients increase error bounds, consult multiple sources, and rely on provenance and freshness metadata to decide how much confidence to place in any given answer. Blind trust is not part of the design.

### 5.4 S‑stack (Service Plane) — S2 through S5

The Service Plane is concerned with what happens _inside_ a domain once reachability has been established. It is intentionally insulated from global identity churn so local systems can keep functioning even when the wider network is having a bad day.

- **S2 Local Service Resolution:** Maps ServiceChains to concrete endpoints using local policy.
    
- **S3 Local Directory / Service Discovery:** Advertises and discovers services within a domain, subject to local access controls.
    
- **S4 Session / Conversation Layer:** Manages session establishment, continuity, retries, and teardown across unreliable links.
    
- **S5 Local Security & ACLs:** Enforces per‑service authentication, authorization, and access control.
    

Under partitions or stale Location‑plane data, the S‑stack continues operating locally using cached state and explicit freshness rules. This is deliberate. Local services should not stop working just because a distant directory went dark or a relay misbehaved. 

### 6 Device and identity models

SolNet’s identity model assumes that not every actor on the network is a human with a keyboard, and that even when a human is involved, they are rarely the one pushing packets directly. Devices act on behalf of users, services act on behalf of organizations, and relays act on behalf of everyone when links get bad.

The identity model exists to make that delegation explicit, auditable, and survivable under failure.

#### 6.1 Device identity hierarchy

Hardware roots, DeviceKeys, Session Keys, PNIs, and delegated credentials form a layered identity chain. Each layer exists to answer a different question:

- **Hardware roots** answer whether a device is what it claims to be.
    
- **DeviceKeys** answer whether a device is still under expected control.
    
- **Session Keys** answer whether a specific interaction is current and authorized.
    
- **PNIs** answer who or what a device is acting for, without requiring global anchoring.
    
- **Delegated credentials** answer who authorized an action when the actor is not the ultimate authority.
    

Not all devices support all layers. When hardware attestation is unavailable or unreliable, systems reduce trust, shorten validity windows, and require additional provenance. This is not a failure mode; it is normal operation for large portions of the network.

#### 6.2 Registration and binding

Devices may operate unanchored, partially anchored, or fully anchored depending on role weight and policy.

- Unanchored devices rely on local identifiers and PNIs.
    
- Partially anchored devices bind identity temporarily through delegation.
    
- Fully anchored devices register NetworkCerts binding LocationChain → UUID‑S7 → NetworkKey.
    

LedgerAnchor entries are recommended for long‑lived anchors and required for high‑Location nodes. Devices that cannot or should not anchor globally are still valid participants, but their actions carry explicit confidence and scope limits.

Binding is an explicit act. Identity does not become authoritative by implication or repetition.

#### 6.3 Relay, proxy, and delegated behavior

Relays, proxies, and automated intermediaries are expected to act on behalf of other entities. This includes forwarding traffic, negotiating sessions, caching records, and issuing receipts.

When acting under delegation, intermediaries **MUST** carry DelegationTokens and emit DelegationReceipts. These records make it possible to reconstruct who authorized an action, for what scope, and for how long, even after long delays or partial failures.

Relays advertise capability via L1‑L only when policy allows. Caching uses TTL, priority, and quotas; deduplication uses seen‑filters. When relays queue, transform, or evict items due to limits, they **MUST** emit AdmissionReceipts and AuditEvents.

Silent behavior is indistinguishable from misbehavior and is treated accordingly.

#### 6.4 Non‑human and automated actors

SolNet does not assume that actors are human, interactive, or singular. Devices and services may initiate actions autonomously, operate continuously, or represent composite decision systems.

Such actors are subject to the same identity, delegation, freshness, and audit requirements as any other participant. Increased autonomy does not imply increased trust. In practice, it usually implies the opposite.

Systems interacting with automated actors **MUST** rely on explicit bindings, scope‑limited delegation, freshness metadata, and provenance records rather than assumptions about intent or correctness.

## 7 Security and privacy principles

- L1‑L exposure **SHOULD** be minimized for personal devices.
    
- High‑Location nodes **SHOULD** use hardware roots and ledger anchoring.
    
- ServiceChain **MUST NOT** be used to infer global identity.
    
- Revocation flows through L2→L5 and **SHOULD** be visible to L1 relays.
    
- Long‑lived signatures **MUST** consider post‑quantum migration.
    

Under degraded conditions, conservative defaults and multi‑party verification reduce risk.  Optimism does not.

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
    

All records **MUST** include provenance and freshness metadata. When freshness is uncertain, consumers treat records as advisory and increase verification steps.

## 9 Operational semantics and workflows

The workflows in this section are presented as detailed, step‑by‑step operational sequences. Each describes the actions taken by participating nodes, the records produced at each stage, and the expected behavior under delay, partitions, misconfiguration, and inconsistent operator practices. The intent is to make the operational flow explicit enough that implementations across different domains can behave predictably even when local conditions vary widely.

### 9.1 Identity anchoring and ledger binding

1. Operator submits a NetworkCert request with UUID‑S7 and LocationChain, including DeviceKey attestation.
    
2. Authority validates the request and checks hardware root attestations.
    
3. Authority writes a LedgerAnchor entry binding UUID‑S7 ↔ LocationChain and signs it.
    
4. Authority publishes NetworkCert and LedgerAnchor references to DREs.
    
5. Requester records the LedgerAnchor reference and emits an AuditEvent.
    

**Stress behavior:** Delayed ledger writes force UNVERIFIED mode. Conflicting anchors create audit trails that investigators later unravel.

### 9.2 Cross‑domain service discovery

1. Client issues L1‑L and L1‑S queries with freshness requirements.
    
2. DREs respond with `//info` and coarse ephemeris or beacon hints.
    
3. Client resolves ServiceChain locally and selects endpoints.
    
4. Session keys are negotiated and session state logged.
    

**Stress behavior:** Stale DRE responses require increased error bounds. Misconfigured DREs produce AuditEvents that help trace failures.

### 9.3 Delegation for constrained devices

1. Constrained device publishes a compact PowerCapabilityRecord.
    
2. Device issues a DelegationToken to a trusted relay.
    
3. Relay records the delegation and issues a DelegationReceipt.
    
4. Relay submits DutyScheduleRecords and forwards ReservationReceipts.
    
5. Device transmits during accepted windows; relay logs full AuditEvents.
    

**Stress behavior:** Compromised relays affect many devices; limited‑validity delegations reduce blast radius. Partitions require conservative fallback behavior.

## 10 Privacy, revocation, and compliance

Domains **MUST** document L1‑L exposure rules. Revocation records **MUST** be signed and propagated through L5→L4→L3→L1. Implementations **MUST** adopt UUID‑S7, enforce `//` parsing, implement L1 split semantics, support role weights, and treat ServiceChain as local.

## 11 Deployment models and examples

- **Personal communicator:** minimal L1‑L exposure; uses PNI.
    
- **Ship relay:** high LocationWeight; advertises relay capability and coarse ephemeris.
    
- **Station console:** high ServiceWeight; provides rich S‑stack services.
    

Each deployment model **SHOULD** include documented identity, delegation, and revocation policies.

## 12 APIs and interfaces

APIs expose identity resolution, DRE endpoints, service resolution, scheduling/delegation, and audit retrieval. Responses **MUST** include provenance and freshness metadata. Compact encodings **SHOULD** be supported for constrained devices.

## 13 Forensics and auditability

AuditEvents **SHOULD** reference related records to enable timeline reconstruction. Retention policies **MUST** be defined in domain PolicyRecords. Missing logs surface as audit gaps and require investigation.

## 14 Next steps and roadmap

- RFC‑2360: formal L1 header encodings.
    
- RFC‑2481: minimal DTN profile.
    
- Additional RFCs will define wire formats, cryptographic profiles, ledger APIs, and device profiles.

# Appee without breaking compatibility.
    

This structure ensures that two nodes generating UUID‑S7 values at the same moment—whether on Luna, Ceres, or a Belter skiff with a drifting clock—still produce distinct identifiers.

## Why time‑sortable identifiers matter

SolNet relies heavily on append‑only logs, deferred replication, and reconciliation after partitions. Time‑sortable identifiers:

- simplify ledger ordering
    
- reduce the need for expensive conflict resolution
    
- allow efficient range queries
    
- help reconstruct event timelines after long outages
    
- support compact proofs for constrained devices
    

Even when clocks drift, the combination of timestamp and randomness maintains ordering semantics without requiring global synchronization.


# **8. TLV Key Allocations and Registry 

TLVs are the extensibility mechanism for SolNet addressing. They are also, historically, the most reliable way for implementers to create behavior that is undocumented, incompatible, and occasionally hazardous. 

The TLV registry exists not to prevent misuse — experience shows that is impossible — but to ensure compliant systems can recognize misuse quickly enough to avoid inheriting it.

Compliant systems MUST follow this section. Non‑compliant systems will exist regardless.

## **8.0 Registry Rationale Note**

The TLV registry is a containment strategy, not a design philosophy.

Unlicensed operators, hobbyist collectives, and “temporary” deployments of unclear ownership will continue to mint TLV keys without registration, justification, or even a consistent byte order. One implementation famously used ASCII strings for keys “because it was easier.” Another used negative integers and insisted this was to be “backwards‑compatible.” The Working Group has reviewed these justifications and found them unpersuasive.

The registry is not intended to prevent such deployments — that has proven unrealistic — but to ensure compliant systems can identify them on sight and avoid reproducing their behavior.

Compliant implementations MUST treat unregistered TLVs as non‑existent. They MUST NOT attempt to interpret, coerce, or “repair” them. Repair attempts have historically revealed the folly of optimism.

## **8.1 TLV Key Registry Overview**

TLV keys are unsigned integers in the range 0–255. This range is fixed. It is not a suggestion, a guideline, or an invitation to innovate. Experience shows that expanding the range would only encourage further experimentation.

The registry is partitioned as follows:

|Range|Allocation|Notes|
|---|---|---|
|**0–15**|L0 Media Metadata|BeamID, ProxID, CommNetID, GroupID. These keys are not available for repurposing, even if “no one is using them right now.”|
|**16–63**|L1‑AWG Assigned|Addressing‑relevant metadata only. Not for device moods, firmware astrology, or “quick hacks.”|
|**64–95**|Cross‑Plane Reserved|Coordination with A‑stack and N‑stack. Implementers MUST NOT guess semantics. They will guess anyway.|
|**96–127**|SSWG Reserved|Future standards‑track use. Not for vendor experiments, even if the vendor insists it is “just internal.”|
|**128–191**|Vendor‑Specific|MAY appear on private networks. WILL appear on public networks. Compliant systems MUST ignore them without comment.|
|**192–255**|Experimental|MUST NOT appear in production. Historically treated as optional. It is not optional.|

The Working Group notes that several vendors have treated the registry as a “general‑purpose metadata bucket.” This behavior is non‑compliant and remains a leading cause of outages that were both predictable and preventable.

## **8.2 Canonical L1 TLV Keys**

The following TLV keys are defined for use in L1 AddressRecords:

|Key|Name|Meaning|
|---|---|---|
|3|BeamID|L0 directional beam identifier|
|4|ProxID|Proximity or local‑cell identifier|
|5|CommNetID|Communication network identifier|
|6|GroupID|Logical grouping identifier|
|20|SessionHint|Advisory session selector|
|21|PrivacyHint|Advisory privacy preference|
|22|RoutingHint|Advisory routing preference (non‑authoritative)|
|23|DeviceClass|Device role classification|
|24|MediaProfile|L0 media subprofile indicator|

Keys 3–6 are inherited from L0 and MUST NOT be redefined. Attempts to redefine them have historically produced outages that were both predictable and preventable.

## **8.3 TLV Value Constraints**

TLVValue MUST conform to the canonical format defined by its key. It MUST NOT contain whitespace, nested TLVs, or creative reinterpretations of ASCII.

TLVValue MUST NOT exceed 255 bytes. Implementations that exceed this limit are encouraged to reconsider their design choices.

## **8.4 Ordering Rules**

TLVs MUST appear in ascending TLVKey order. This rule exists because unordered TLVs have repeatedly caused resolvers to behave in ways that defy explanation.

LocationChain TLVs MUST appear after BareTokens and before ProvenancePointer. ServiceChain TLVs MUST appear after BareTokens. TLVs MUST NOT appear after ProvenancePointer.

Grouping TLVs by “semantic category” instead of numeric order is non‑compliant, regardless of how tidy it looks in logs.

## **8.5 Vendor‑Specific TLVs**

Vendor‑specific TLVs (128–191):

- MAY be used on private networks
    
- WILL appear on public networks
    
- MUST NOT conflict with SSWG semantics
    
- MUST NOT be interpreted by non‑vendor devices
    
- MUST NOT be used to bypass canonical fields
    

Compliant systems MUST ignore vendor TLVs without comment. Experience shows that commenting only encourages further misuse.

## **8.6 Experimental TLVs**

Experimental TLVs (192–255):

- MAY be used in controlled testbeds
    
- MUST NOT appear in production
    
- MUST NOT be relied upon for interoperability
    
- MUST NOT be used as a shortcut for standards‑track features
    

The Working Group notes that “pilot deployments” are frequently mislabeled as testbeds. This does not make them testbeds.

## **8.7 Unrecognized TLVs**

Unrecognized TLVs:

- MUST be ignored
    
- MUST NOT cause resolution failure
    
- MUST NOT be interpreted
    
- MAY be logged as warnings at operator discretion
    

Implementations MUST NOT attempt to infer meaning from TLVKey or TLVValue patterns. Inference has historically produced results that were both imaginative and incorrect.

## **8.8 Invalid TLV Forms**

The following TLV forms are invalid and MUST be rejected:

- malformed braces
    
- non‑numeric keys
    
- keys outside 0–255
    
- nested TLVs
    
- TLVs after ProvenancePointer
    
- TLVs out of ascending order
    
- TLVs exceeding maximum length
    
- use of reserved keys without authorization
    

Implementations MUST reject invalid TLVs without attempting repair. Repair attempts have historically revealed the limits of optimism.

## **8.9 Registry Governance**

The Canonical Address Registrar (CAR):

- maintains the TLV registry
    
- allocates new keys
    
- retires deprecated keys
    
- resolves conflicts
    
- publishes errata
    
- enforces compliance
    

Requests for new TLV keys MUST include a complete specification, canonical value format, justification, and security considerations. Requests lacking these elements will be returned without comment, as experience shows that comment does not improve the next submission.


# **9. Error Handling and Diagnostics 

Error handling in SolNet L1 is intentionally simple. This simplicity is not a design limitation; it is a defensive measure. Experience shows that complex error semantics invite creativity, and creativity in error handling has historically produced outages that were both predictable and preventable.

Compliant implementations MUST follow the rules in this section. Non‑compliant implementations will follow their own rules, often with great confidence and little success.

## **9.1 General Principles**

When an AddressRecord cannot be parsed, validated, or interpreted, the correct behavior is:

1. **Stop.**
    
2. **Fail.**
    
3. **Report the failure.**
    
4. **Do not attempt repair.**
    

Implementations MUST NOT:

- guess
    
- infer
    
- reinterpret
    
- “fix”
    
- or otherwise attempt to salvage malformed input
    

Repair attempts have historically revealed the limits of optimism.

The Working Group notes that several early implementations attempted “best‑effort recovery.” These systems produced behavior that was imaginative, incorrect, and difficult to diagnose.

## **9.2 Categories of Errors**

Errors fall into the following categories:

### **9.2.1 Structural Errors**

These include:

- malformed braces
    
- missing BareTokens
    
- misplaced ProvenancePointer
    
- TLVs out of order
    
- TLVs after ProvenancePointer
    
- nested TLVs
    
- non‑numeric TLV keys
    
- negative TLV keys (regardless of justification)
    

Structural errors MUST cause immediate failure. Systems MUST NOT attempt to interpret partially valid structures.

### **9.2.2 Semantic Errors**

These include:

- invalid TLV values
    
- values exceeding maximum length
    
- values that violate canonical format
    
- advisory hints used as authoritative directives
    

Semantic errors MUST cause failure unless the specification explicitly defines fallback behavior.

### **9.2.3 Registry Violations**

These include:

- use of reserved keys
    
- vendor keys on public networks
    
- experimental keys in production
    
- unregistered TLVs
    

Registry violations MUST NOT be interpreted. Compliant systems MUST ignore them and proceed if possible.

The Working Group notes that ignoring registry violations is not an endorsement of the behavior. It is a survival strategy.

## **9.3 Diagnostic Behavior**

Diagnostics exist to assist operators, not to encourage implementers.

Implementations SHOULD:

- log structural errors
    
- log semantic errors
    
- log registry violations
    
- include enough context to identify the source
    
- avoid including sensitive metadata
    

Implementations MUST NOT:

- attempt to “explain” the error
    
- speculate about intent
    
- provide advice
    
- include stack traces in public logs
    

Experience shows that verbose diagnostics often reveal more about the system than the error.

## **9.4 Advisory vs. Authoritative Errors**

Some fields are advisory. Some are authoritative. Confusing the two has historically produced behavior that was both surprising and incorrect.

### **Advisory fields include:**

- SessionHint
    
- PrivacyHint
    
- RoutingHint
    

Advisory fields MAY be ignored. They MUST NOT cause failure.

### **Authoritative fields include:**

- BareTokens
    
- ProvenancePointer
    
- all structural elements
    
- all canonical TLVs
    

Authoritative fields MUST be validated. Failure to validate MUST cause failure.

The Working Group notes that several implementations have treated advisory fields as authoritative “for convenience.” This behavior is non‑compliant and has not produced the intended results.

## **9.5 Handling Stale or Conflicting Metadata**

Stale metadata is expected. Conflicting metadata is common. Deceptive metadata is rare but dangerous.

Implementations MUST:

- treat stale metadata as advisory
    
- treat conflicting metadata as failure
    
- treat deceptive metadata as a security event
    

A platform that admits “this metadata is approximate and old” is still more trustworthy than one that insists it is precise while drifting.

## **9.6 Observed Failure Modes**

The following failure modes have been observed in the field:

- resolvers that reorder TLVs “for readability”
    
- resolvers that treat advisory hints as routing directives
    
- resolvers that ignore ProvenancePointer entirely
    
- resolvers that attempt to repair malformed TLVs
    
- resolvers that treat vendor keys as authoritative
    
- resolvers that treat negative TLV keys as “extended range”
    
- resolvers that silently drop structural errors
    

These behaviors are non‑compliant. They are also common.

The Working Group has no further comment.

## **9.7 SSWG Summary**

> **“When the address is wrong, fail.** **When the metadata is wrong, fail.** **When the TLVs are wrong, fail.** **Guessing does not improve outcomes.”**


# **10. Security Considerations 

Security in SolNet L1 is intentionally narrow. L1 does not authenticate, authorize, encrypt, or validate identity. It does not attempt to detect deception, prevent misuse, or enforce trust boundaries. These responsibilities belong to higher layers that are better equipped, better informed, and less resource‑constrained.

L1’s security model is simple:

> **“Do not lie about structure.** **Do not lie about provenance.** **Everything else is someone else’s problem.”**

This simplicity is not a limitation. It is a survival strategy.

## **10.1 Structural Integrity as a Security Boundary**

L1’s only hard security boundary is **structural correctness**.

Malformed AddressRecords MUST be rejected. Malformed TLVs MUST be rejected. Misordered fields MUST be rejected. Missing mandatory elements MUST be rejected.

Experience shows that accepting malformed input does not improve interoperability. It merely expands the attack surface.

The Working Group notes that several early implementations attempted “lenient parsing.” These systems were compromised in ways that were both predictable and preventable.

## **10.2 ProvenancePointer and Trust**

ProvenancePointer is advisory, not authoritative. It provides a hint about where the AddressRecord originated, not a guarantee.

Implementations MUST treat ProvenancePointer as:

- **informational**,
    
- **non‑binding**,
    
- and **potentially stale**.
    

A ProvenancePointer that claims to originate from a trusted source MAY be correct. It MAY also be copied, forged, replayed, or guessed.

The Working Group has observed all four behaviors in the field.

## **10.3 TLVs as an Attack Surface**

TLVs expand functionality. They also expand the number of ways an attacker can attempt to confuse, mislead, or exhaust a resolver.

Attackers have historically attempted:

- oversized TLV values
    
- recursive TLV structures
    
- negative TLV keys
    
- vendor keys masquerading as canonical keys
    
- canonical keys with non‑canonical formats
    
- TLVs placed after ProvenancePointer
    
- TLVs designed to trigger fallback logic
    

Compliant systems MUST ignore unrecognized TLVs and MUST reject invalid ones. Attempting to interpret or repair malformed TLVs has not produced positive outcomes.

## **10.4 Stale, Conflicting, and Deceptive Metadata**

Stale metadata is expected. Conflicting metadata is common. Deceptive metadata is rare but dangerous.

Implementations MUST:

- treat stale metadata as advisory
    
- treat conflicting metadata as failure
    
- treat deceptive metadata as a security event
    

A platform that admits “this metadata is approximate and old” is still more trustworthy than one that insists it is precise while drifting.

## **10.5 Denial‑of‑Service Considerations**

L1 resolvers operate under tight resource constraints. Attackers may attempt to exploit this by:

- flooding resolvers with oversized AddressRecords
    
- generating excessive TLVs
    
- using deeply nested or repetitive structures
    
- forcing repeated fallback attempts
    
- exploiting vendor‑specific TLVs to trigger slow paths
    

Implementations MUST:

- enforce maximum sizes
    
- enforce maximum TLV counts
    
- enforce strict ordering
    
- fail fast on malformed input
    

Failing fast is not merely an optimization. It is a security requirement.

## **10.6 Misuse of Advisory Fields**

Advisory fields (SessionHint, PrivacyHint, RoutingHint) are not security controls. They are not trust signals. They are not policy directives.

Treating advisory fields as authoritative has historically produced behavior that was surprising, incorrect, and occasionally exploitable.

Implementations MUST NOT:

- route based solely on advisory hints
    
- infer trust from advisory hints
    
- enforce policy based on advisory hints
    

Advisory fields are suggestions. Some suggestions are better than others. None are guarantees.

## **10.7 Observed Security Failures**

The following security failures have been observed in the field:

- resolvers accepting malformed TLVs “for compatibility”
    
- resolvers trusting ProvenancePointer without verification
    
- resolvers treating vendor keys as authoritative
    
- resolvers attempting to repair invalid structures
    
- resolvers ignoring maximum lengths
    
- resolvers attempting to interpret ASCII TLV keys
    
- resolvers accepting negative TLV keys “for backwards‑compatibility”
    

These behaviors are non‑compliant. They are also common.

The Working Group has no further comment.

## **10.8 SSWG Summary**

> **“L1 cannot prevent deception.** **It can prevent confusion.** **Confusion is the more common failure.”**


# **11. Interoperability Requirements 

Interoperability is the primary purpose of SolNet L1. It is also the area where implementers have demonstrated the greatest creativity, often to the detriment of the systems involved. This section defines the minimum behaviors required for two independently developed implementations to exchange AddressRecords without confusion, corruption, or unexpected optimism.

Compliant systems MUST follow these rules. Non‑compliant systems will continue to exist, and compliant systems MUST be able to survive their presence.

## **11.1 Structural Interoperability**

Two systems are structurally interoperable when they agree on:

- the grammar of AddressRecords
    
- the placement of BareTokens
    
- the ordering of TLVs
    
- the position of ProvenancePointer
    
- the absence of nested structures
    
- the interpretation of canonical TLV keys
    

If any of these elements diverge, interoperability fails. Experience shows that attempting to compensate for divergence does not improve outcomes.

Implementations MUST NOT:

- reorder TLVs
    
- reinterpret BareTokens
    
- relocate ProvenancePointer
    
- merge LocationChain and ServiceChain
    
- introduce new structural elements
    

These behaviors have been observed in the field. They did not produce positive results.

## **11.2 Semantic Interoperability**

Semantic interoperability requires that two systems interpret canonical fields in the same way.

Implementations MUST:

- treat advisory hints as advisory
    
- treat authoritative fields as authoritative
    
- treat canonical TLVs as defined
    
- treat vendor TLVs as opaque
    
- treat experimental TLVs as non‑existent
    

Implementations MUST NOT:

- infer meaning from vendor TLVs
    
- treat advisory hints as routing directives
    
- reinterpret canonical TLVs “for convenience”
    
- treat experimental TLVs as stable
    

The Working Group notes that several implementations have attempted to “optimize” semantics. These optimizations have not improved interoperability.

## **11.3 Version Interoperability**

SolNet L1 is designed to be version‑agnostic. AddressRecords MUST include no version field, and implementations MUST NOT introduce one.

Interoperability across versions is achieved through:

- strict structural rules
    
- strict TLV ordering
    
- strict canonical semantics
    
- strict failure behavior
    

Implementations MUST NOT:

- embed version identifiers in TLVs
    
- infer version from field presence
    
- negotiate version through advisory hints
    

Experience shows that version negotiation at L1 produces more confusion than clarity.

## **11.4 Interoperability With Non‑Compliant Systems**

Non‑compliant systems will appear on public networks. They will:

- use unregistered TLVs
    
- use negative TLV keys
    
- use ASCII TLV keys
    
- reorder TLVs
    
- omit ProvenancePointer
    
- include multiple ProvenancePointers
    
- exceed maximum lengths
    
- embed application data in TLVs
    
- treat advisory hints as authoritative
    

Compliant systems MUST:

- ignore unrecognized TLVs
    
- reject invalid structures
    
- fail fast on malformed input
    
- avoid attempting repair
    
- avoid attempting inference
    

The Working Group notes that several implementations have attempted to “bridge” compliant and non‑compliant systems. These bridges have historically become single points of failure.

## **11.5 Interoperability Under Degradation**

Interoperability MUST be maintained under:

- partial data loss
    
- stale metadata
    
- conflicting metadata
    
- missing advisory fields
    
- missing vendor fields
    
- missing experimental fields
    

Implementations MUST:

- treat missing advisory fields as neutral
    
- treat missing vendor fields as irrelevant
    
- treat missing experimental fields as expected
    
- treat stale metadata as advisory
    
- treat conflicting metadata as failure
    

A platform that admits “this metadata is approximate and old” is still more interoperable than one that insists it is precise while drifting.

## **11.6 Interoperability Across Factions**

SolNet L1 MUST interoperate across:

- jury‑rigged Belter skiffs
    
- Martian orbital nuke arrays
    
- Earth‑side systems waiting on approval signatures
    

These platforms differ in:

- hardware capability
    
- software maturity
    
- operational discipline
    
- tolerance for ambiguity
    
- tolerance for failure
    

Interoperability is achieved not by accommodating these differences, but by enforcing the same structural and semantic rules across all platforms.

The Working Group notes that attempts to “optimize” for any one faction have historically reduced interoperability for the others.

## **11.7 Observed Interoperability Failures**

The following interoperability failures have been observed in the field:

- TLVs reordered “for readability”
    
- advisory hints treated as authoritative
    
- vendor TLVs treated as canonical
    
- ProvenancePointer ignored entirely
    
- ProvenancePointer duplicated
    
- negative TLV keys accepted “for compatibility”
    
- ASCII TLV keys interpreted as “extended format”
    
- experimental TLVs used in production
    
- fallback logic triggered recursively
    

These behaviors are non‑compliant. They are also common.

The Working Group has no further comment.


# **12. Operational Behavior**

Operational behavior defines how compliant systems behave during normal operation, degraded operation, and transitional states. These rules exist because experience shows that implementers will otherwise make assumptions that are optimistic, undocumented, or incompatible with the rest of the network.

Compliant systems MUST follow the behaviors described in this section. Non‑compliant systems will behave according to their own internal logic, and compliant systems MUST be able to survive their presence.

## **12.1 Normal Operation**

During normal operation, a compliant resolver MUST:

- parse AddressRecords strictly
    
- validate structural elements
    
- validate canonical TLVs
    
- ignore unrecognized TLVs
    
- apply advisory hints only as advisory
    
- apply authoritative fields as authoritative
    
- preserve TLV ordering
    
- preserve BareToken ordering
    
- preserve ProvenancePointer position
    

Normal operation is defined as “the system is functioning as designed.” This definition excludes systems that are functioning as implemented.

## **12.2 Degraded Operation**

Degraded operation occurs when:

- metadata is stale
    
- metadata is incomplete
    
- advisory hints are missing
    
- vendor TLVs are present
    
- experimental TLVs are present
    
- ProvenancePointer is absent
    
- ProvenancePointer is unverifiable
    

In degraded operation, implementations MUST:

- treat stale metadata as advisory
    
- treat missing metadata as neutral
    
- treat conflicting metadata as failure
    
- treat unverifiable provenance as untrusted
    
- continue processing if structural integrity is intact
    

Degraded operation is expected. It is not an error condition. It is the normal state of many real deployments.

## **12.3 Transitional Operation**

Transitional operation occurs when:

- a resolver is updating internal state
    
- a resolver is switching media profiles
    
- a resolver is switching routing domains
    
- a resolver is applying new policy
    
- a resolver is recovering from failure
    

During transitional operation, implementations MUST:

- maintain structural correctness
    
- maintain TLV ordering
    
- maintain canonical semantics
    
- avoid emitting partial or inconsistent AddressRecords
    
- avoid emitting records with mixed policy states
    

The Working Group notes that several implementations have attempted to emit “best‑effort transitional records.” These records were neither best nor effort.

## **12.4 Behavior Under Load**

Under load, compliant systems MUST:

- continue to enforce structural rules
    
- continue to enforce TLV rules
    
- continue to reject malformed input
    
- continue to ignore unrecognized TLVs
    
- avoid fallback logic that increases load
    
- avoid recursive fallback logic entirely
    

Implementations MUST NOT:

- relax validation
    
- relax ordering
    
- relax canonical semantics
    
- accept malformed input “temporarily”
    
- defer validation to later stages
    

Experience shows that relaxing validation under load does not improve throughput. It merely accelerates failure.

## **12.5 Behavior Under Partial Failure**

Partial failure includes:

- intermittent connectivity
    
- intermittent power
    
- partial data corruption
    
- partial metadata loss
    
- partial resolver state loss
    

Implementations MUST:

- fail fast on malformed structures
    
- retry only when retrying is meaningful
    
- avoid retry storms
    
- avoid exponential backoff loops that never converge
    
- avoid caching invalid records
    

A resolver that admits “I do not know” is more reliable than one that insists it does.

## **12.6 Behavior With Mixed‑Compliance Peers**

Mixed‑compliance environments are expected on public networks. These environments include:

- compliant systems
    
- non‑compliant systems
    
- partially compliant systems
    
- systems that claim compliance but are not
    
- systems that believe they are compliant but are not
    
- systems that have never read the specification
    

Compliant systems MUST:

- ignore unrecognized TLVs
    
- reject invalid structures
    
- avoid interpreting vendor TLVs
    
- avoid interpreting experimental TLVs
    
- avoid inferring semantics from patterns
    
- avoid attempting to “correct” peer behavior
    

The Working Group notes that several implementations have attempted to “improve” non‑compliant peers. These attempts have not improved interoperability.

## **12.7 Observed Operational Failures**

The following operational failures have been observed in the field:

- resolvers that reorder TLVs “for readability”
    
- resolvers that emit partial AddressRecords during state transitions
    
- resolvers that treat advisory hints as authoritative
    
- resolvers that treat vendor TLVs as canonical
    
- resolvers that relax validation under load
    
- resolvers that attempt to repair malformed input
    
- resolvers that cache invalid records
    
- resolvers that retry indefinitely
    
- resolvers that treat negative TLV keys as “extended range”
    

These behaviors are non‑compliant. They are also common.

The Working Group has no further comment.


# **13. Conformance Requirements**

This section defines the requirements for conformance to the SolNet L1 Addressing Standard. Conformance is not a matter of interpretation, preference, or implementation strategy. It is a matter of meeting the mandatory behaviors described in this document.

A system that does not meet these requirements is non‑compliant, regardless of intent, justification, or operational history.

## **13.1 Conformance Levels**

There are two conformance levels:

### **13.1.1 Full Conformance**

A system is fully conformant if it:

- implements the complete AddressRecord grammar
    
- enforces all structural rules
    
- enforces TLV ordering
    
- enforces TLV validity
    
- enforces canonical semantics
    
- rejects malformed input
    
- ignores unrecognized TLVs
    
- preserves ProvenancePointer position
    
- preserves BareToken ordering
    
- preserves TLV ordering
    
- adheres to all error‑handling rules
    
- adheres to all interoperability rules
    
- adheres to all operational behavior rules
    

Full conformance is required for systems operating on public networks.

### **13.1.2 Partial Conformance**

A system is partially conformant if it:

- implements the AddressRecord grammar
    
- enforces structural correctness
    
- enforces canonical TLV semantics
    
- rejects malformed input
    

…but does not implement all advisory behaviors, operational behaviors, or optional TLVs.

Partial conformance is acceptable for private networks, testbeds, and controlled environments. It is not acceptable for public networks.

## **13.2 Non‑Conformance**

A system is non‑conformant if it:

- reorders TLVs
    
- reorders BareTokens
    
- relocates ProvenancePointer
    
- introduces new structural elements
    
- interprets unrecognized TLVs
    
- accepts malformed input
    
- attempts to repair malformed input
    
- treats advisory fields as authoritative
    
- treats vendor TLVs as canonical
    
- uses negative TLV keys
    
- uses ASCII TLV keys
    
- uses experimental TLVs in production
    
- exceeds maximum TLV lengths
    
- embeds nested TLVs
    
- embeds application data in TLVs
    

These behaviors have been observed in the field. They are non‑compliant regardless of justification.

## **13.3 Conformance Claims**

A system claiming conformance MUST:

- specify whether it is fully or partially conformant
    
- specify which optional features are implemented
    
- specify which canonical TLVs are supported
    
- specify any vendor‑specific TLVs used
    
- specify any experimental TLVs used (testbeds only)
    

A system claiming full conformance MUST NOT:

- redefine canonical TLVs
    
- reinterpret canonical semantics
    
- introduce new structural elements
    
- modify the AddressRecord grammar
    

The Working Group notes that several systems have claimed conformance while failing to meet these requirements. These claims were incorrect.

## **13.4 Conformance Testing**

Conformance testing MUST verify:

- structural correctness
    
- TLV ordering
    
- TLV validity
    
- canonical semantics
    
- error handling
    
- interoperability behavior
    
- operational behavior
    

Conformance testing MUST include:

- valid examples
    
- invalid examples
    
- boundary cases
    
- malformed TLVs
    
- unrecognized TLVs
    
- vendor TLVs
    
- experimental TLVs
    
- stale metadata
    
- conflicting metadata
    

Conformance testing MUST NOT rely on:

- inference
    
- heuristics
    
- vendor documentation
    
- “expected behavior”
    
- “common practice”
    

Experience shows that “common practice” is rarely compliant.

## **13.5 Conformance and Future Revisions**

Future revisions of this specification MAY:

- add new canonical TLVs
    
- deprecate existing TLVs
    
- clarify semantics
    
- refine error handling
    
- refine operational behavior
    

Future revisions MUST NOT:

- alter the AddressRecord grammar
    
- alter TLV ordering rules
    
- alter ProvenancePointer placement
    
- alter BareToken semantics
    

These elements are load‑bearing and cannot be changed without breaking interoperability.

# **14. Document Maintenance and Revision Process**

This specification is a living document. It will evolve as operational experience accumulates, as new use cases emerge, and as implementers discover new and inventive ways to misinterpret the existing text. This section defines the process by which revisions, clarifications, and errata are introduced.

Compliant systems MUST track revisions to this specification. Non‑compliant systems will continue to behave according to their own internal logic.

## **14.1 Working Group Authority**

The SolNet Standards Working Group (SSWG):

- maintains this specification
    
- publishes revisions
    
- issues errata
    
- allocates canonical TLV keys
    
- deprecates obsolete features
    
- resolves semantic ambiguities
    
- adjudicates registry conflicts
    

The Working Group is the sole authority for normative changes. Vendor documentation, field practice, and community consensus are not normative sources.

## **14.2 Revision Types**

Revisions fall into three categories:

### **14.2.1 Editorial Revisions**

Editorial revisions:

- correct typographical errors
    
- clarify ambiguous phrasing
    
- reorganize text for readability
    
- update examples
    
- update references
    

Editorial revisions MUST NOT alter normative behavior.

### **14.2.2 Clarifying Revisions**

Clarifying revisions:

- refine semantics
    
- resolve ambiguities
    
- specify previously underspecified behavior
    

Clarifying revisions MAY affect implementations but MUST NOT contradict previously normative behavior.

### **14.2.3 Normative Revisions**

Normative revisions:

- introduce new canonical TLVs
    
- deprecate existing TLVs
    
- modify operational rules
    
- modify interoperability rules
    
- modify error‑handling rules
    

Normative revisions MUST be versioned and published as new major releases.

Normative revisions MUST NOT:

- alter the AddressRecord grammar
    
- alter TLV ordering rules
    
- alter ProvenancePointer placement
    
- alter BareToken semantics
    

These elements are load‑bearing and cannot be changed without breaking interoperability.

## **14.3 Errata Process**

Errata are published when:

- the specification contains an error
    
- the specification contradicts itself
    
- the specification contradicts observed canonical behavior
    
- the specification is misinterpreted in a consistent and predictable way
    

Errata MAY:

- clarify intent
    
- correct mistakes
    
- restrict behavior
    
- forbid previously ambiguous behavior
    

Errata MUST NOT introduce new features.

Implementers MUST track errata. Failure to do so has historically produced behavior that was both surprising and incorrect.

## **14.4 Deprecation Process**

Features MAY be deprecated when:

- they are no longer used
    
- they are replaced by more robust mechanisms
    
- they have proven unsafe
    
- they have proven incompatible with future development
    

Deprecation does not imply removal. Deprecated features MUST continue to be recognized but SHOULD NOT be used in new deployments.

The Working Group notes that several deprecated features have remained in active use for years. This is not an endorsement.

## **14.5 Publication and Distribution**

Revisions to this specification MUST be published:

- in the canonical repository
    
- with a unique revision identifier
    
- with a complete changelog
    
- with updated registry tables
    
- with updated examples
    

Implementers MUST NOT rely on unofficial copies, vendor summaries, or community‑maintained documents.

Experience shows that unofficial documents are frequently incomplete, outdated, or incorrect.

## **14.6 Implementer Responsibilities**

Implementers MUST:

- track revisions
    
- track errata
    
- track registry updates
    
- update their systems accordingly
    
- document their conformance level
    
- document their supported TLVs
    
- document any vendor‑specific TLVs used
    

Implementers MUST NOT:

- claim conformance to outdated revisions
    
- claim conformance while ignoring errata
    
- claim conformance while redefining canonical semantics
    

The Working Group notes that several systems have claimed conformance while failing to meet these requirements. These claims were incorrect.



# **15. Registry and Allocation Procedures**

This section defines the procedures for allocating, modifying, and retiring TLV keys and related registry entries. These procedures exist to prevent fragmentation, duplication, and the emergence of incompatible dialects. Experience shows that without a formal process, incompatible dialects emerge immediately.

Compliant systems MUST follow the registry rules defined in this section. Non‑compliant systems will continue to allocate keys according to their own internal logic.

## **15.1 Registry Authority**

The Canonical Address Registrar (CAR):

- maintains the TLV registry
    
- allocates new TLV keys
    
- retires deprecated TLV keys
    
- resolves conflicts
    
- publishes registry updates
    
- publishes errata
    
- adjudicates disputes
    
- enforces compliance
    

CAR is the sole authority for registry changes. Vendor documentation, field practice, and community consensus are not normative sources.

## **15.2 Allocation Categories**

TLV keys are allocated according to the following categories:

- **0–15**: L0 Media Metadata (fixed)
    
- **16–63**: L1‑AWG Assigned
    
- **64–95**: Cross‑Plane Reserved
    
- **96–127**: SSWG Reserved
    
- **128–191**: Vendor‑Specific
    
- **192–255**: Experimental
    

These ranges are fixed. They are not guidelines, suggestions, or opportunities for innovation.

## **15.3 Allocation Requests**

Requests for new TLV keys MUST include:

- a complete specification
    
- canonical value format
    
- justification for inclusion
    
- security considerations
    
- interoperability considerations
    
- operational considerations
    
- failure‑mode analysis
    

Requests lacking these elements will be returned without comment. Experience shows that comment does not improve the next submission.

## **15.4 Allocation Criteria**

CAR evaluates allocation requests according to:

- necessity
    
- clarity
    
- interoperability impact
    
- security impact
    
- operational impact
    
- potential for misuse
    
- potential for confusion
    

Requests that introduce ambiguity, complexity, or opportunities for creative interpretation will be rejected.

Requests that duplicate existing semantics will be rejected.

Requests that attempt to redefine existing semantics will be rejected.

## **15.5 Vendor‑Specific Allocations**

Vendor‑specific TLVs (128–191):

- MAY be allocated by vendors
    
- MUST NOT conflict with canonical semantics
    
- MUST NOT be interpreted by non‑vendor systems
    
- MUST NOT be used to bypass canonical fields
    
- MUST NOT be used on public networks
    

Vendor allocations MUST be documented. Undocumented vendor allocations have historically produced behavior that was both surprising and incorrect.

## **15.6 Experimental Allocations**

Experimental TLVs (192–255):

- MAY be used in controlled testbeds
    
- MUST NOT appear in production
    
- MUST NOT be relied upon for interoperability
    
- MUST NOT be treated as stable
    

Experimental allocations MUST be clearly marked as experimental. Experience shows that implementers frequently forget this requirement.

## **15.7 Deprecation and Retirement**

A TLV key MAY be deprecated when:

- it is no longer used
    
- it has been replaced by a more robust mechanism
    
- it has proven unsafe
    
- it has proven incompatible with future development
    

Deprecated keys MUST continue to be recognized but SHOULD NOT be used in new deployments.

A TLV key MAY be retired when:

- it is unsafe
    
- it is actively harmful
    
- it cannot be supported without breaking interoperability
    

Retired keys MUST NOT appear in new AddressRecords.

## **15.8 Conflict Resolution**

Conflicts occur when:

- two parties attempt to allocate the same key
    
- a vendor allocation overlaps with canonical semantics
    
- an experimental key leaks into production
    
- a key is used inconsistently across deployments
    

CAR resolves conflicts according to:

- canonical precedence
    
- registry history
    
- operational impact
    
- security impact
    

The Working Group notes that several conflicts have been resolved by simply rejecting all parties’ proposals. This approach has proven effective.

## **15.9 Publication of Registry Updates**

Registry updates MUST be published:

- in the canonical repository
    
- with a unique revision identifier
    
- with a complete changelog
    
- with updated allocation tables
    
- with updated examples (if applicable)
    

Implementers MUST track registry updates. Failure to do so has historically produced behavior that was both imaginative and incorrect.


# **Appendix A — TLV Examples**

This appendix provides illustrative examples of valid and invalid TLV usage. These examples are non‑normative. They exist to demonstrate correct structure, highlight common errors, and document behaviors observed in the field.

Compliant systems MUST follow the normative rules in Sections 3–12. These examples are provided for clarity only.

## **A.1 Valid TLV Examples**

### **A.1.1 Simple LocationChain With a Single TLV**

Code

```
LocationChain:
  BareToken: "mars"
  TLV: {3: "beam-7"}
  ProvenancePointer: <hash>
```

**Notes:**

- TLV key 3 (BeamID) is canonical.
    
- TLV appears before ProvenancePointer.
    
- Ordering is correct.
    
- Structure is valid.
    

### **A.1.2 ServiceChain With Multiple TLVs in Correct Order**

Code

```
ServiceChain:
  BareToken: "telemetry"
  TLV: {20: "low-latency"}
  TLV: {23: "sensor"}
```

**Notes:**

- Keys 20 and 23 are canonical.
    
- TLVs appear in ascending numeric order.
    
- Advisory hints are used correctly.
    

### **A.1.3 LocationChain With Multiple TLVs and ProvenancePointer**

Code

```
LocationChain:
  BareToken: "belt"
  TLV: {4: "cell-19"}       # ProxID
  TLV: {24: "laser-tight"}  # MediaProfile
  ProvenancePointer: <hash>
```

**Notes:**

- TLVs are in ascending order (4, then 24).
    
- ProvenancePointer appears last.
    
- Structure is compliant.
    

### **A.1.4 Vendor-Specific TLV in a Private Network**

Code

```
ServiceChain:
  BareToken: "diagnostics"
  TLV: {130: "vendor-mode-3"}
```

**Notes:**

- Key 130 is in the vendor range (128–191).
    
- Compliant systems ignore it without comment.
    
- Valid only in private networks.
    

## **A.2 Invalid TLV Examples**

### **A.2.1 ASCII Key**

Code

```
TLV: {"FOO": "bar"}
```

**Why invalid:**

- Keys MUST be numeric (0–255).
    
- ASCII keys are non‑compliant.
    
- This form has been observed in the field.
    

### **A.2.2 Negative Key**

Code

```
TLV: {-7: "boost"}
```

**Why invalid:**

- Keys MUST be unsigned integers.
    
- Negative keys are non‑compliant.
    
- The implementer insisted this was “backwards‑compatible.”
    
- It was not.
    

### **A.2.3 TLVs Out of Order**

Code

```
TLV: {24: "laser-tight"}
TLV: {4: "cell-19"}
```

**Why invalid:**

- TLVs MUST appear in ascending numeric order.
    
- Reordering TLVs “for readability” is non‑compliant.
    

### **A.2.4 TLV After ProvenancePointer**

Code

```
ProvenancePointer: <hash>
TLV: {20: "low-latency"}
```

**Why invalid:**

- No TLVs may appear after ProvenancePointer.
    
- This error has produced resolver behavior that defies explanation.
    

### **A.2.5 Oversized TLV Value**

Code

```
TLV: {23: "<256-byte-string>"}
```

**Why invalid:**

- TLVValue MUST NOT exceed 255 bytes.
    
- Oversized values are rejected.
    

### **A.2.6 Nested TLVs**

Code

```
TLV: {20: {4: "cell-19"}}
```

**Why invalid:**

- TLVs MUST NOT contain nested TLVs.
    
- This structure is non‑compliant regardless of justification.
    

## **A.3 Observed-In-The-Wild Examples**

These examples are included for operator awareness. They are not compliant and MUST NOT be reproduced.

### **A.3.1 The Belter Clunker TLV**

Code

```
TLV: {-1: "boost"}
```

**Observed behavior:**

- Used on a jury‑rigged skiff.
    
- Operator insisted negative keys were “extended range.”
    
- Resolver accepted it.
    
- Network did not.
    

### **A.3.2 The Martian Over-Engineered TLV**

Code

```
TLV: {22: "routing-hint:{priority=7,window=3,burst=2}"}
```

**Observed behavior:**

- Encoded a full configuration object inside a TLVValue.
    
- Violated canonical format.
    
- Required a custom parser.
    
- Broke interoperability.
    

### **A.3.3 The Earth-Side Approval Chain TLV**

Code

```
TLV: {5: "commnet-12-approved-by-ops-approved-by-legal-approved-by-risk"}
```

**Observed behavior:**

- Value exceeded recommended length.
    
- Contained operational metadata unrelated to addressing.
    
- Broke downstream systems expecting short identifiers.
    

### **A.3.4 The Vendor “Just Internal” TLV That Leaked**

Code

```
TLV: {150: "internal-mode-7"}
```

**Observed behavior:**

- Appeared on public networks.
    
- Misinterpreted by multiple resolvers.
    
- Caused routing divergence.
    
- Vendor documentation described this as “unexpected.”
    

### **A.3.5 The Experimental TLV That Became Mission-Critical**

Code

```
TLV: {200: "proto-route-3"}
```

**Observed behavior:**

- Used in a testbed.
    
- Later used in production “temporarily.”
    
- Never removed.
    
- Now relied upon by multiple deployments.
    
- Non‑compliant in every respect.


# **Appendix B — Full ABNF Grammar**

This appendix provides the complete ABNF grammar for SolNet L1 AddressRecords. This grammar is normative. Whitespace is not permitted unless explicitly defined.

Code

```
; ================================
;  Core AddressRecord Structure
; ================================

AddressRecord     = LocationChain [ServiceChain] [ProvenancePointer]

LocationChain     = 1*(BareToken / TLV) ProvenancePointer
ServiceChain      = 1*(BareToken / TLV)

ProvenancePointer = "@" HashValue

; ================================
;  Bare Tokens
; ================================

BareToken         = 1*(ALPHA / DIGIT / "-" / "_")

; ================================
;  TLV Structure
; ================================

TLV               = "{" TLVKey ":" TLVValue "}"

TLVKey            = 1*3DIGIT
                   ; 0–255 inclusive
                   ; Leading zeros permitted but not required

TLVValue          = 1*TLVChar
                   ; Maximum length: 255 bytes

TLVChar           = ALPHA / DIGIT / "-" / "_" / "." / "/"
                   ; Printable ASCII subset
                   ; No whitespace permitted

; ================================
;  Hash / Provenance
; ================================

HashValue         = 1*(ALPHA / DIGIT)
                   ; Encoding defined by higher-layer spec

; ================================
;  Ordering Rules (Informative)
; ================================
; TLVs MUST appear in ascending TLVKey order.
; TLVs MUST appear before ProvenancePointer.
; BareTokens MUST appear before TLVs.
; These constraints are normative but not expressible in ABNF.
```

# **Notes (Non‑Normative)**

These notes do _not_ appear in the grammar block, but they clarify intent:

- **ABNF cannot express ordering constraints**, so the rules in Sections 3, 7, and 8 remain authoritative.
    
- **TLVKey is numeric**, but ABNF treats it as a digit sequence; enforcement of the 0–255 range is semantic, not syntactic.
    
- **TLVValue length limits** are enforced by implementations, not ABNF.
    
- **HashValue format** is intentionally underspecified at L1.

# **Appendix C — Canonical TLV Key Table**

This appendix provides a frozen copy of the canonical TLV key allocations at the time of publication. The live registry maintained by CAR is authoritative.

## **C.1 TLV Key Allocation Ranges**

|Range|Allocation Category|Notes|
|---|---|---|
|**0–15**|L0 Media Metadata|Fixed; inherited from L0.|
|**16–63**|L1‑AWG Assigned|Addressing‑relevant metadata only.|
|**64–95**|Cross‑Plane Reserved|Coordination with A‑stack and N‑stack.|
|**96–127**|SSWG Reserved|Future standards‑track use.|
|**128–191**|Vendor‑Specific|Private networks only.|
|**192–255**|Experimental|Testbeds only; MUST NOT appear in production.|

## **C.2 Canonical TLV Keys (Publication Snapshot)**

|Key|Name|Description|
|---|---|---|
|**3**|BeamID|L0 directional beam identifier.|
|**4**|ProxID|Proximity or local‑cell identifier.|
|**5**|CommNetID|Communication network identifier.|
|**6**|GroupID|Logical grouping identifier.|
|**20**|SessionHint|Advisory session selector.|
|**21**|PrivacyHint|Advisory privacy preference.|
|**22**|RoutingHint|Advisory routing preference (non‑authoritative).|
|**23**|DeviceClass|Device role classification.|
|**24**|MediaProfile|L0 media subprofile indicator.|

## **C.3 Reserved Keys (Publication Snapshot)**

### **C.3.1 Cross‑Plane Reserved (64–95)**

These keys are reserved for coordination with A‑stack and N‑stack. No assignments at publication time.

### **C.3.2 SSWG Reserved (96–127)**

These keys are reserved for future standards‑track use. No assignments at publication time.

## **C.4 Vendor‑Specific Keys (128–191)**

Vendor‑specific keys MAY be used on private networks. They MUST NOT be interpreted by non‑vendor systems. No vendor allocations are included in this appendix.

## **C.5 Experimental Keys (192–255)**

Experimental keys MAY be used in controlled testbeds. They MUST NOT appear in production. No experimental allocations are included in this appendix.

## **C.6 Registry Change Note**

This appendix reflects the registry state at publication time. Future revisions, errata, and registry updates MAY modify these allocations. Implementers MUST consult the live registry for authoritative values.

# **Appendix D — Rationale Notes**

This appendix provides non‑normative rationale for major design decisions in the SolNet L1 Addressing Standard. These notes document operational experience, historical failures, and constraints that shaped the final form of the specification. They are included to assist implementers, auditors, and future Working Groups.

## **D.1 Structural Simplicity**

The AddressRecord grammar is intentionally simple. Earlier drafts attempted more expressive structures, including nested chains, optional subfields, and multi‑level provenance. These designs increased ambiguity, reduced interoperability, and encouraged implementers to introduce undocumented extensions.

The final grammar reflects the minimum structure required for reliable operation.

## **D.2 TLV Ordering**

TLV ordering rules exist because unordered TLVs produced inconsistent resolver behavior across platforms. Some resolvers sorted TLVs lexicographically, others numerically, and others preserved input order. This divergence caused failures that were difficult to diagnose.

Ascending numeric order was selected as the least ambiguous rule.

## **D.3 ProvenancePointer Placement**

ProvenancePointer appears last because earlier placements created ambiguity about which fields were authoritative. Resolvers disagreed on whether TLVs after ProvenancePointer were valid, advisory, or erroneous.

Placing ProvenancePointer last removes this ambiguity.

## **D.4 Advisory vs. Authoritative Fields**

Advisory fields were introduced to support optimization without affecting correctness. Earlier drafts attempted to use advisory fields as routing directives. This approach produced inconsistent behavior and created opportunities for misuse.

Advisory fields are now strictly advisory.

## **D.5 Vendor and Experimental Ranges**

Vendor and experimental ranges exist to contain non‑standard behavior. Experience shows that without explicit containment, vendors will introduce new semantics into canonical ranges, and experimental features will leak into production.

These ranges are not intended to encourage experimentation. They are intended to isolate it.

## **D.6 Failure Behavior**

Strict failure behavior was adopted after multiple attempts at “best‑effort recovery” produced unpredictable results. Implementations that attempted to repair malformed input often introduced new errors or masked the original cause.

Fail‑fast behavior is required for reliability.

## **D.7 Registry Governance**

The registry exists to prevent fragmentation. Earlier deployments without registry oversight produced incompatible dialects that could not interoperate.

Centralized governance is required to maintain a coherent ecosystem.

## **D.8 Stability of Load‑Bearing Elements**

Certain elements — AddressRecord grammar, TLV ordering, BareToken semantics, ProvenancePointer placement — are load‑bearing. Changing them would break interoperability across all existing deployments.

These elements are fixed for the lifetime of the standard.

# **Appendix E — Change Log**

This appendix records changes made between revisions of the SolNet L1 Addressing Standard. It is non‑normative but required for traceability.

## **E.1 Revision 1.0 (Initial Publication)**

- Introduced AddressRecord grammar.
    
- Defined LocationChain and ServiceChain structures.
    
- Defined ProvenancePointer semantics.
    
- Introduced TLV encoding rules.
    
- Established TLV key allocation ranges.
    
- Added canonical TLV keys (3, 4, 5, 6, 20, 21, 22, 23, 24).
    
- Defined error‑handling requirements.
    
- Defined security considerations.
    
- Defined interoperability requirements.
    
- Defined operational behavior.
    
- Defined conformance levels.
    
- Established registry and allocation procedures.
    
- Added Appendix A (Examples).
    
- Added Appendix B (ABNF Grammar).
    
- Added Appendix C (Canonical TLV Table).
    
- Added Appendix D (Rationale Notes).
    
- Added Appendix E (Change Log).
    

## **E.2 Future Revisions**

Future revisions MAY:

- add new canonical TLVs
    
- deprecate existing TLVs
    
- refine advisory semantics
    
- refine operational behavior
    
- clarify ambiguous text
    

Future revisions MUST NOT:

- alter the AddressRecord grammar
    
- alter TLV ordering rules
    
- alter ProvenancePointer placement
    
- alter BareToken semantics
    

These elements are load‑bearing and cannot be changed without breaking interoperability.



