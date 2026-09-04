# RFC‑2305 — Power and Duty Cycle Constraints

SolNet Standards Working Group (SSWG) Status: Informational / Foundational

## 1 Purpose

This RFC spells out how SolNet nodes are supposed to talk about power usage and duty‑cycle limits without lying to each other or accidentally cooking their own hardware. It defines required behaviors, metadata, and operational semantics for power usage and duty‑cycle constraints on SolNet transmitters and relays.

The intent is that directional and omnidirectional transmitters, phased arrays, beacons, and even those “temporary” courier rigs that never get decommissioned all expose enough information for planning, scheduling, and safe operation across wildly different deployments. It covers power classes, duty‑cycle policies, throttling and admission controls, energy‑aware propagation semantics, revocation and emergency overrides, and forensic logging to support audit and dispute resolution when someone insists “the system never told me I was out of power.”

## 2 Scope

This RFC applies to any SolNet component that transmits electromagnetic energy or controls transmit schedules, including:

- **Directional and omnidirectional radios and optical transmitters;**
    
- **Phased arrays and beam‑forming systems;**
    
- **Scheduled beacons and discovery signals;**
    
- **Relays that forward or buffer transmissions subject to duty limits;**
    
- **Couriers that physically transport powered storage or scheduled transmit windows;**
    
- **Constrained devices with strict energy budgets** (the usual Belter skiffs, wrist terminals, and “we’ll upgrade it next quarter” controllers).
    

This RFC does **not** mandate specific hardware power amplifiers, antenna designs, or regulatory frequency allocations. Those are left to local engineering, local law, local budget, and appeals to one's deity of choice. What it does define are the metadata, APIs, and behavioral semantics required so diverse devices can interoperate under shared power and duty constraints, instead of each domain pretending its own ad‑hoc spreadsheet is a standard.

## 3 Design goals

- **Predictable duty behavior:** Make transmit availability and limits explicit so scheduling and routing can avoid unexpected outages and “mysterious” blackouts that turn out to be a dead battery.
    
- **Energy awareness:** Allow devices and operators to make clear tradeoffs between latency, throughput, and energy consumption, instead of discovering the tradeoff when the lights go out.
    
- **Fairness and admission control:** Provide mechanisms to prevent resource starvation and manage contention, so one chatty node does not starve everyone else.
    
- **Safety and emergency overrides:** Define controlled mechanisms for temporary overrides in emergencies while preserving audit trails, because “we had to” is not enough without signatures.
    
- **Forensic traceability:** Ensure power and duty decisions are logged with provenance for post‑hoc analysis, blame assignment, finger pointing, job terminations and policy tuning.
    
- **Support for constrained devices:** Enable participation by devices with tight energy budgets through compact proofs and selective synchronization, rather than excluding them or pretending they can behave like full‑power sites.
    

## 4 Model overview and rationale

SolNet runs across environments where power availability ranges from “effectively infinite” to “hope the panel catches enough light this orbit.” Permanently powered Earth sites, solar‑dependent stations, reactor‑backed Martian arrays, and battery‑limited Belter skiffs all share the same logical network, but they do not share the same power assumptions.

Because of this, transmit behavior must be described as **policy plus state**:

- **Policy:** What a device is allowed to do—maximum power, duty limits, priority classes, emergency rules.
    
- **State:** What the device is actually doing or planning to do—current power draw, scheduled bursts, queued transmissions.
    

Policies are expressed as **PowerPolicyRecords** and **DutyCycleRecords**. State is expressed as **PowerStateRecords** and **DutyScheduleRecords**. Relays and schedulers use these records to plan bursts, negotiate windows, and enforce admission controls.

This separation lets higher layers plan around constraints instead of guessing. It lets constrained devices advertise minimal capabilities without being punished for it. And it gives auditors the provenance they need to reconstruct decisions after partitions, misconfigurations, or the inevitable “we never exceeded our duty limit” argument.

## 5 Terminology

For consistent usage:

- **PowerPolicyRecord:** Operator‑defined rules governing allowed transmit power, duty cycles, and override conditions.
    
- **DutyCycleRecord:** Machine‑readable description of permitted transmit windows and aggregate duty limits.
    
- **PowerStateRecord:** Current power availability, battery state, and active transmit power.
    
- **DutyScheduleRecord:** Planned transmit windows, reservations, and queued bursts.
    
- **Admission control:** Local relay or domain logic that accepts, rejects, or delays transmissions based on policy and resource state.
    
- **Emergency override:** Temporarily elevated permissions to exceed normal limits under documented conditions.
    
- **Energy budget:** The available energy resource for a device over a defined interval.
    
- **Throttling:** Active reduction of transmit power or duty to meet policy or conserve energy.
    
- **AuditEvent:** Signed log entry recording policy decisions, overrides, evictions, and significant power events.
  
- **Duty Limit** A duty limit is a **quantitative cap** on transmission time or transmission energy within a specified rolling window. It is expressed in a **DutyCycleRecord** and enforced by relays, schedulers, and the device itself.
	A duty limit always includes three elements:

	- **Interval definition** — the time window over which usage is measured (e.g., “per hour”, “per 10‑minute block”, “per orbital daylight cycle”).
	    
	- **Maximum allowed duty** — the fraction or duration of that interval the device may transmit (e.g., “10% per hour”, “30 seconds per 5 minutes”).
	    
	- **Scope of enforcement** — whether the limit applies to all transmissions, only high‑power transmissions, or only specific traffic classes.
	    
	This gives the network a predictable way to reason about when a node can transmit and when it must remain silent.

These terms are used throughout. Implementations SHOULD resist the urge to rename them in their own APIs unless they enjoy confusing their operators.

## 6 Power classes and capability metadata

Implementations MUST publish capability metadata so peers and schedulers can plan transmissions without guessing how fragile a given node is.

Each node’s **PowerCapabilityRecord** MUST include:

- **PowerClass:** A categorical label summarizing typical behavior, for example:
    
    - Class‑A: continuous high power;
        
    - Class‑B: scheduled high power;
        
    - Class‑C: intermittent low power;
        
    - Class‑D: constrained battery, intermittent, low-power, unstable. This class is also known as "Point and pray"
        
- **PeakPower:** Maximum instantaneous transmit power (in watts or a normalized unit). This is the “do not exceed” value unless you enjoy replacing hardware.
    
- **SustainedPower:** Recommended continuous power for extended operation, where “extended” means “long enough that thermal and energy limits matter.”
    
- **DutyLimit:** Maximum fraction of time allowed to transmit over a defined interval (for example, 10% per hour). This is the aggregate duty constraint, not just a suggestion.
    
- **EnergyCapacity:** Stored energy available (in joules or normalized unit) and expected recharge characteristics (for example, solar, reactor, trickle charge).
    
- **PowerPolicyRef:** Reference to the domain’s PowerPolicyRecord that defines how these capabilities are actually used.
    

These fields MUST be present in PowerCapabilityRecords and exposed via APIs. Peers use them to decide whether to route bulk replication through a node, schedule bursts, or prefer courier transfer. A node that advertises Class‑D with tiny EnergyCapacity SHOULD not be the default path for everyone’s ledger sync.

## 7 Duty cycle semantics and scheduling

Duty cycles are expressed as explicit windows and aggregate limits, because “we’ll just eyeball it” does not scale.

- **Windowed duty:** DutyScheduleRecords define discrete windows with start time, end time, and permitted power levels. Implementations MUST support overlapping windows with a defined priority resolution mechanism (for example, higher priority window wins, or most restrictive limit wins), as specified in the PowerPolicyRecord.
    
- **Aggregate limits:** DutyCycleRecords define aggregate constraints such as “no more than X seconds of high‑power transmission per Y interval.” Implementations MUST enforce these aggregates across all windows, not just per window, so clever scheduling does not accidentally violate thermal or regulatory limits.
    
- **Reservation model:** Nodes MAY reserve future windows with relays or schedulers by submitting DutyScheduleRecords. These reservations are advisory until accepted. A scheduler that accepts a reservation MUST sign a **ReservationReceipt** indicating the accepted window, permitted power, and priority. Until that receipt exists, the reservation is just a request.
    
- **Preemption and priority:** PowerPolicyRecords define priority classes (for example, control traffic, safety channels, bulk replication, background sync). Higher priority reservations MAY preempt lower priority ones, subject to policy and signed AuditEvents documenting the preemption. This prevents low‑value traffic from blocking critical transmissions when energy is tight.
    
- **Throttling behavior:** When limits are approached, devices MUST reduce power or duty according to local policy. Throttling actions MUST be logged as AuditEvents, including the reason (aggregate limit, local safety, policy change) and the affected DutyScheduleRecords.
    

These scheduling semantics allow planners to trade latency for energy: bulk replication can be deferred to low‑cost windows, while urgent control traffic can request higher priority windows. In practice, this means the ledger sync waits while the life‑support alarm gets through.

## 8 Admission control and relay behavior

Relays sit in the middle of contention and are expected to behave like accountable gatekeepers, not mysterious black boxes.

- **Admission checks:** On submission, relays MUST evaluate incoming transmissions or reservations against local PowerPolicyRecords, current PowerStateRecords, and DutyCycleRecords. Relays MAY reject, accept, or queue transmissions. In all cases, the relay MUST sign an **AdmissionReceipt** indicating:
    
    - whether the item was accepted, queued, or rejected;
        
    - any assigned window or priority;
        
    - the rationale for rejection or queuing, if applicable.
        
- **Queue management:** Relays MUST implement eviction policies for queued transmissions. Evictions MUST be logged as AuditEvents with rationale (for example, low energy, higher priority preemption, expired reservation). This prevents “silent drops” that no one can explain later.
    
- **Rate limiting:** Relays SHOULD implement rate limits per origin, per destination, and per PowerClass to prevent starvation and abuse. A single misconfigured node SHOULD NOT be able to consume all duty windows just because it can shout the loudest.
    
- **Authenticated enforcement:** Relays MUST authenticate submitters and verify signatures on policy references and overrides to prevent spoofed EmergencyOverrideRecords or forged PowerPolicyRefs.
    
- **Forwarding under constraints:** When full payload forwarding is deferred due to duty limits, relays SHOULD still forward inclusion proofs and minimal metadata where possible. This allows constrained nodes to verify that their records are at least accepted and queued, even if the full data has not yet propagated.
    

These behaviors ensure relays act as predictable, auditable components rather than random failure points that everyone blames when something goes wrong.

## 9 Energy‑aware propagation semantics

Propagation semantics must reflect energy constraints, not pretend every node has a reactor.

- **Best‑effort with energy awareness:** The network provides best‑effort forwarding, but routing and replication decisions MUST consider power and duty metadata. Implementations SHOULD prefer low‑energy paths for non‑urgent data, even if those paths are slightly longer in hop count, to avoid draining constrained nodes unnecessarily.
    
- **Deferred replication:** Large bulk transfers SHOULD be scheduled for windows with available energy or moved to couriered storage when energy costs are prohibitive. A Belter skiff with a marginal battery SHOULD NOT be asked to push a full ledger snapshot in the middle of a dark transit if a courier can carry it cheaper.
    
- **Provisional acceptance:** When a relay accepts a record but cannot forward it immediately due to duty limits, it MUST issue a signed **ProvisionalReceipt** indicating queued status and an expected forwarding window or condition. Consumers MUST treat such records as provisional until replication receipts confirm propagation. This makes the “we have it, but we haven’t sent it yet” state explicit.
    
- **Energy‑based prioritization:** PowerPolicyRecords define how to prioritize traffic under constrained energy, including emergency channels that MAY be exempt from normal limits. Policies SHOULD be explicit about which traffic can override energy constraints and under what conditions.
    

These semantics let higher layers make explicit tradeoffs between immediacy and energy cost, instead of discovering after the fact that a critical node went offline because it spent all its power on gossip traffic.

## 10 Revocation, emergency overrides, and safety controls

Controlled overrides are necessary, but they must be auditable and bounded, not “trust me, it was important.”

- **EmergencyOverrideRecords:** Domains MAY define emergency conditions under which normal duty limits can be temporarily exceeded. Each EmergencyOverrideRecord MUST be authorized, signed, and include:
    
    - a validity interval;
        
    - the scope of the override (which nodes, which PowerClasses, which traffic classes);
        
    - a rationale.
        
- **Two‑party confirmation:** For high‑impact overrides (for example, system‑wide elevated power for life‑safety channels), implementations SHOULD require multi‑party confirmation, such as an operator signature plus a domain authority signature. The combined signatures produce an active **EmergencyOverrideReceipt**.
    
- **Automatic safety cutoffs:** Devices MUST implement local safety cutoffs (thermal limits, battery depletion thresholds) that cannot be overridden remotely. When a cutoff triggers, the device MUST log an AuditEvent and MAY refuse further transmissions regardless of external overrides. Attempts to push a device past its physical limits SHOULD be visible in the logs.
    
- **Revocation:** PowerPolicyRecords and EmergencyOverrideRecords MUST be revocable. Revocations produce signed **RevocationReceipts** and MUST be propagated to affected nodes. Revocations do not retroactively invalidate prior signed receipts, but they do affect future scheduling and enforcement. A node that continues to act on a revoked override is misconfigured or misbehaving, and the logs SHOULD make that obvious.
    

These controls balance the need for urgent action with the requirement for accountability. When someone claims “we had no choice but to override,” the records SHOULD show who decided that and for how long.


## What “signature” means in this context
In SolNet RFCs, **“signature” always means a cryptographic signature**, not a handwritten name, not a rubber‑stamp approval, and not a vague “operator OK.” It refers to a verifiable, machine‑checkable digital signature produced by a keypair that is part of the SolNet authority and identity model.

A signature is a **cryptographic attestation** created with a private key belonging to:

- a platform (device‑level key),
    
- an operator identity (operator key),
    
- a domain authority (domain‑level key), or
    
- a higher‑authority anchor (depending on the trust domain).
    

The corresponding public keys are published through the SolNet identity and authority layers (RFC‑2361, RFC‑2362, RFC‑2368), so any node can verify that:

- the signature is valid,
    
- the signer is who they claim to be,
    
- the signer had the authority to issue the record, and
    
- the record has not been tampered with.
    

This is the same signature model used for receipts, ledger entries, revocations, and cross‑domain attestations.

## Why signatures are required for overrides

Emergency overrides are one of the few places where SolNet explicitly allows a node to break its own rules. That makes them dangerous if not tightly controlled.

A **signed EmergencyOverrideRecord** proves:

- _who_ authorized the override,
    
- _when_ it was authorized,
    
- _what_ the override permits,
    
- _how long_ it is valid, and
    
- _which authority keys_ were involved.
    

Without cryptographic signatures, an override would be indistinguishable from a forged message or a misconfigured relay.

## What “two‑party confirmation” means

When the RFC says:

> “operator signature plus a domain authority signature”

it means **two independent cryptographic signatures**, each produced by a different keypair with different authority levels.

The combined signatures form the **EmergencyOverrideReceipt**, which is itself a signed object. Nodes verify:

- both signatures are valid,
    
- both signers are authorized for override approval,
    
- the override parameters match the signed content, and
    
- the override has not been revoked.
    

This is SolNet’s equivalent of a two‑key launch system: no single operator, relay, or compromised device can unilaterally push the network into high‑power mode.
## 11 Forensics and audit logging

Power decisions must be reconstructable after the fact, because that is when everyone suddenly cares about the details.

- **AuditEvent structure:** AuditEvents MUST include:
    - actor identity (node, operator, or automated system);
        
    - timestamp;
        
    - referenced records (PowerPolicyRecord, DutyScheduleRecord, AdmissionReceipt, etc.);
        
    - decision rationale (for example, “preempted by higher priority,” “aggregate limit exceeded,” “safety cutoff triggered”);
        
    - signatures.  SEE ABOVE NOTE ON SIGNATURES!!
        
- **Retention policy:** Domains MUST define retention windows for power and duty logs in PolicyRecords. Critical events (emergency overrides, safety cutoffs, large‑scale throttling) SHOULD be retained longer than routine scheduling noise.
    
- **Correlation:** AuditEvents SHOULD reference related PowerStateRecords, DutyScheduleRecords, and AdmissionReceipts to enable timeline reconstruction. Investigators SHOULD be able to follow a chain from “this transmission failed” back to “this reservation was preempted” or “this node was out of energy.”
    
- **Tamper evidence:** Audit logs MUST be signed and, where possible, anchored to external commitments (for example, public anchors or cross‑domain attestations) to provide tamper evidence. A domain that quietly edits its logs after the fact SHOULD be detectable.
    
Forensics enable dispute resolution and help operators tune policies to real‑world conditions instead of theoretical models that assume perfect behavior.

## 12 Constrained devices and compact proofs

Constrained devices need to participate without drowning in their own telemetry.
- **Compact PowerState:** Constrained devices MAY publish compact PowerStateRecords that summarize energy capacity and duty limits without full telemetry. For example, a device might expose “low, medium, high” energy states instead of exact joules, along with a simple DutyLimit.
    
- **Delegated scheduling:** Constrained devices MAY delegate scheduling to trusted relays. Delegations MUST be recorded with provenance and MAY include signed delegation tokens that specify scope and validity. The relay then acts as the device’s scheduler, submitting DutyScheduleRecords on its behalf.
    
- **Proofs for acceptance:** When a constrained device requests a high‑cost window (for example, for critical control traffic), it MUST provide compact proofs of necessity, such as a signed control intent or reference to a higher‑priority policy. Relays MAY require additional confirmation before granting such reservations, especially when energy is tight.
    
These provisions let low‑power devices participate without exposing full telemetry or overburdening their resources, while still giving the rest of the network enough information to treat them sensibly.

## 13 Privacy and data minimization

Power and energy metadata can reveal operational patterns: when a node is active, when it is vulnerable, when it is likely unattended. That is useful for planning and also useful for anyone with bad intentions.

- **Minimal exposure:** Implementations SHOULD expose only the metadata necessary for scheduling and routing. Detailed telemetry (fine‑grained power draw, exact battery curves) MAY be restricted to authorized parties.
    
- **Aggregated reporting:** Domains MAY publish aggregated duty statistics rather than per‑device logs to reduce exposure. For example, “this station used 60% of its duty budget this shift” instead of “this specific antenna transmitted at these exact times.”
    
- **Access controls:** APIs exposing PowerStateRecords and DutyScheduleRecords MUST enforce access control and authentication. Not every node needs to know exactly when a critical relay is at low battery.
    

Privacy choices MUST be explicit and documented in PolicyRecords so that operators and auditors understand what is exposed and why.

## 14 Record types and required fields

Key record types and required fields are as follows. All MUST include standard SolNet provenance fields (origin, timestamps, signatures) and freshness metadata.

- **PowerCapabilityRecord (MUST):**
    
    - PlatformID;
        
    - PowerClass;
        
    - PeakPower;
        
    - SustainedPower;
        
    - EnergyCapacity;
        
    - PowerPolicyRef.
        
- **PowerPolicyRecord (MUST):**
    
    - PolicyID;
        
    - domain rules for duty;
        
    - priority classes;
        
    - emergency conditions;
        
    - revocation rules.
        
- **DutyCycleRecord (MUST):**
    
    - interval definition;
        
    - aggregate limits;
        
    - window definitions;
        
    - priority mapping.
        
- **DutyScheduleRecord (MUST):**
    
    - ReservationID;
        
    - requester identity;
        
    - start and end times;
        
    - permitted power;
        
    - ReservationReceipt (if accepted).
        
- **PowerStateRecord (MUST):**
    
    - PlatformID;
        
    - current power draw;
        
    - battery state;
        
    - thermal state;
        
    - timestamp.
        
- **AdmissionReceipt / ReservationReceipt / ProvisionalReceipt / RevocationReceipt (MUST):**
    
    - signed receipts documenting decisions, including actor, timestamp, referenced records, and outcome.
        
- **AuditEvent (MUST):**
    
    - actor;
        
    - timestamp;
        
    - referenced records;
        
    - rationale;
        
    - signature.
        

These records form the backbone of power and duty observability. If they are missing or incomplete, operators will be guessing instead of managing.

## 15 APIs and interfaces

APIs SHOULD support the following operations:

- **Querying capabilities and state:** Query PowerCapabilityRecords and PowerStateRecords for a given PlatformID, with provenance and freshness metadata included in responses.
    
- **Submitting schedules and reservations:** Submit DutyScheduleRecords to relays or schedulers and receive ReservationReceipts indicating acceptance, queuing, or rejection.
    
- **Monitoring decisions:** Subscribe to AdmissionReceipts and AuditEvents for monitoring, so operators can see when reservations are preempted, throttled, or evicted.
    
- **Managing overrides:** Publish and revoke EmergencyOverrideRecords, receiving EmergencyOverrideReceipts and RevocationReceipts as confirmation.
    
- **Forensic retrieval:** Retrieve historical AuditEvents and related receipts for forensic analysis, subject to access control and retention policies.
    

Responses MUST include provenance and freshness metadata. APIs SHOULD support compact encodings for constrained devices, so they can participate without burning half their duty budget on metadata.

## 16 Operational workflows and examples

The workflows in this section are presented as detailed, step‑by‑step operational sequences. Each describes the actions taken by participating nodes, the records produced at each stage, and the expected behavior under delay, partitions, misconfiguration, and inconsistent operator practices. The intent is to make the operational flow explicit enough that implementations across different domains can behave predictably even when local conditions vary widely.

### 16.1 Scheduled burst replication under duty limits

**Scenario:** An originator wants to perform a bulk replication (for example, ledger sync) but must respect local duty limits and energy constraints.

1. **Originator evaluates cost:**
    
    - The originator inspects its own **PowerCapabilityRecord** to understand its PowerClass, PeakPower, SustainedPower, DutyLimit, and EnergyCapacity.
        
    - It then reads its current **PowerStateRecord** to see actual battery state, current power draw, and thermal state.
        
    - Based on these, the originator determines an acceptable power level and duration for the replication burst that will not violate local safety or policy.
        
2. **Reservation request:**
    
    - The originator constructs a **DutyScheduleRecord** specifying the desired window (start and end times), requested power level, and priority class.
        
    - It submits this DutyScheduleRecord to a relay or scheduler responsible for the relevant link.
        
    - This submission produces a signed **ReservationRequest** (often just the DutyScheduleRecord plus the originator’s signature), which the relay will evaluate.
        
3. **Relay admission check:**
    
    - The relay evaluates the ReservationRequest against local **PowerPolicyRecords**, current **DutyCycleRecords**, and any already queued reservations.
        
    - The relay decides whether to accept, queue, or reject the request.
        
    - The relay issues a signed **ReservationReceipt** indicating:
        
        - acceptance with a specific window and permitted power; or
            
        - queuing with an expected window or condition; or
            
        - rejection with a rationale (for example, “aggregate limit exceeded,” “higher priority traffic reserved”).
            
4. **Originator confirmation and planning:**
    
    - If the reservation is accepted, the originator updates its local DutyScheduleRecord with the ReservationReceipt and schedules the replication burst accordingly.
        
    - If the reservation is queued, the originator may choose to wait for the indicated window, lower the requested power or priority and resubmit, or decide to move the data via courier instead.
        
    - If the reservation is rejected, the originator SHOULD either adjust its request (for example, smaller burst, lower power) or choose an alternate path or time.
        
5. **Burst execution:**
    
    - At the scheduled window, the originator transmits the replication burst at the permitted power level.
        
    - The relay monitors aggregate duty usage against its DutyCycleRecords and local PowerPolicyRecords.
        
    - If aggregate limits are approached during the burst, the relay MAY throttle the originator (for example, by requesting reduced rate or temporarily pausing forwarding) and MUST log **ThrottlingAuditEvents** documenting the action and rationale.
        
6. **Replication receipts and forwarding:**
    
    - Core replicas that receive and append the replicated data issue their own replication receipts (outside this RFC’s scope but referenced by propagation semantics).
        
    - If the relay had to defer forwarding due to duty limits, it issues **ProvisionalReceipts** when records are accepted and queued, and **ForwardingReceipts** when they are actually forwarded.
        
    - These receipts allow the originator and auditors to distinguish between “accepted but queued” and “fully propagated.”
        
7. **Post‑event logging and analysis:**
    
    - All actors (originator, relay, core replicas) log **AuditEvents** for key actions: reservation acceptance, throttling, successful forwarding, evictions, and any policy overrides.
        
    - Operators can later correlate ReservationReceipts, ProvisionalReceipts, ForwardingReceipts, and AuditEvents to reconstruct what happened during the burst.
        

**Behavior under stress:**

- **Delay and partitions:** If network partitions or delays prevent the originator from receiving a ReservationReceipt in time, the originator MUST NOT assume acceptance. It SHOULD either retry the reservation, request a lower‑cost window, or fall back to opportunistic forwarding at lower power. Blindly transmitting at full power without a confirmed reservation is a policy violation and SHOULD be visible in AuditEvents.
    
- **Misconfiguration:** Misconfigured PowerPolicyRecords or DutyCycleRecords that overcommit windows will result in relays having to evict queued transmissions or throttle active bursts. These actions generate AuditEvents that reveal the conflict and give operators something concrete to fix.
    
- **Unreliable operators:** Operators who manually override policies to “just get this one burst through” SHOULD generate explicit AuditEvents and, ideally, temporary policy overrides. If they do not, the resulting inconsistencies between observed behavior and recorded policy will show up in forensics.
    

### 16.2 Emergency override for life‑safety channel

**Scenario:** A life‑safety or critical control channel needs to transmit immediately, even if that means exceeding normal duty limits.

1. **Trigger detection:**
    
    - An emergency condition is detected by an authorized actor—this may be a human operator, an automated monitor, or a higher‑level control system.
        
    - The actor prepares an **EmergencyOverrideRecord** that includes:
        
        - the rationale (for example, “life‑support failure alarm,” “collision avoidance command”);
            
        - the validity interval (start and end times, or conditions);
            
        - the required elevated power or duty parameters;
            
        - the scope (which nodes, which links, which traffic classes).
            
2. **Multi‑party authorization:**
    
    - For high‑impact overrides, the system SHOULD require a second signature from a domain authority or equivalent.
        
    - Once the required signatures are collected, the system produces an active **EmergencyOverrideReceipt**, which is a signed confirmation that the override is valid and in effect for the specified interval and scope.
        
3. **Relay enforcement:**
    
    - Relays receiving the EmergencyOverrideRecord or EmergencyOverrideReceipt validate the signatures and check that the override applies to their domain and links.
        
    - Relays update their local DutyCycleRecords and PowerPolicyRecords in memory to permit elevated transmissions for the override interval and scope.
        
    - Relays log an **AuditEvent** recording the override, including the actors, signatures, scope, and validity interval.
        
4. **Safety monitoring at devices:**
    
    - Devices subject to the override still enforce local safety cutoffs (thermal limits, battery depletion thresholds).
        
    - If a device determines that complying with the override would violate its safety limits, it MUST refuse the override, log an AuditEvent, and MAY notify upstream controllers that it cannot safely comply.
        
    - This prevents remote overrides from physically damaging hardware, even if the paperwork is in order.
        
5. **Transmission under override:**
    
    - During the validity interval, affected devices and relays treat the override as active policy.
        
    - Life‑safety or critical control traffic is transmitted at the elevated power or duty levels permitted by the override, subject to local safety constraints.
        
    - Normal traffic may be throttled or deferred to make room, and such actions SHOULD be logged as AuditEvents referencing the active override.
        
6. **Revocation and post‑audit:**
    
    - When the override expires or is explicitly revoked, a **RevocationReceipt** is issued and propagated to affected nodes.
        
    - Relays and devices revert to normal PowerPolicyRecords and DutyCycleRecords.
        
    - Post‑event audits correlate EmergencyOverrideReceipts, RevocationReceipts, transmissions, and safety events to verify that the override was used appropriately and only for its intended scope and duration.
        

**Behavior under stress:**

- **Partitions and delay:** In partitions, overrides may not propagate to all affected nodes. Local policies SHOULD define fallback behavior, such as allowing local operators to apply temporary overrides with limited scope and later reconcile with domain policy when connectivity returns. All such local overrides MUST be logged as AuditEvents.
    
- **Misconfiguration or abuse:** Attempts to bypass multi‑party authorization or to extend overrides beyond their intended scope MUST be logged and SHOULD be flagged for investigation. Inconsistent override records across domains will show up in forensics as conflicting EmergencyOverrideRecords and RevocationReceipts.
    
- **Unreliable operators:** Operators who repeatedly trigger overrides for non‑emergency traffic will leave a clear trail of EmergencyOverrideRecords and AuditEvents. Domains that care about this sort of thing can act accordingly.
    

### 16.3 Constrained device delegation and compact scheduling

**Scenario:** A constrained device with limited energy and minimal processing delegates scheduling to a more capable relay while still participating in SolNet.

1. **Capability advertisement:**
    
    - The constrained device publishes a compact **PowerCapabilityRecord** indicating its PlatformID, PowerClass (typically Class‑C or Class‑D), PeakPower, a simple DutyLimit, and EnergyCapacity.
        
    - It may omit fine‑grained details but MUST provide enough information for peers to understand that it is energy‑limited and should not be treated like a full‑power relay.
        
2. **Delegation token request:**
    
    - The device selects a trusted relay (often a nearby station or domain relay) and issues a signed delegation token indicating that the relay is authorized to act as its scheduler for certain traffic classes or time intervals.
        
    - The relay records this delegation and issues a **DelegationReceipt** (a type of AuditEvent or receipt) confirming the scope and validity of the delegation.
        
3. **Relay schedules on behalf of the device:**
    
    - Acting under the delegation, the relay submits **DutyScheduleRecords** on behalf of the constrained device, requesting windows and power levels appropriate to the device’s capabilities and policies.
        
    - The relay receives **ReservationReceipts** from upstream schedulers or other relays and stores them, associating each with the delegated device.
        
    - The relay forwards relevant ReservationReceipts or **ProvisionalReceipts** to the device in a compact form, so the device knows when it is allowed to transmit.
        
4. **Execution and verification:**
    
    - The constrained device transmits during accepted windows at the permitted power levels, using the information provided by the relay.
        
    - The device logs minimal **AuditEvents** (for example, “transmission executed under ReservationID X at time Y”) to record its actions without consuming excessive storage.
        
    - The relay logs full AuditEvents for scheduling, forwarding, and any throttling or evictions that affect the delegated device.
        
5. **Revocation of delegation:**
    
    - The device or the domain may revoke the delegation at any time, for example if the relay is no longer trusted or if policies change.
        
    - Revocation produces a signed **RevocationReceipt** that is logged by both the device (if possible) and the relay.
        
    - After revocation, the relay MUST stop scheduling on behalf of the device, and any pending DutyScheduleRecords SHOULD be canceled or updated.
        

**Behavior under stress:**

- **Relay compromise or misconfiguration:** If the relay is compromised or misconfigured, many constrained devices may be affected at once, since they rely on it for scheduling. Delegations MUST include provenance and limited validity to reduce the blast radius. Forensics can identify such events by correlating DelegationReceipts, ReservationReceipts, and widespread anomalies in constrained device behavior.
    
- **Partitions:** In partitions, the relay may be unable to obtain new reservations for the device. It SHOULD fall back to local policies, possibly using cached DutyCycleRecords or default low‑duty behavior, and MUST log AuditEvents indicating degraded scheduling.
    
- **Unreliable operators:** Operators who assign delegations casually or fail to revoke them when trust changes will see that reflected in long‑lived DelegationReceipts and inconsistent scheduling behavior. Again, the logs will tell the story.
    

## 17 Security considerations

Security here is about making sure power and duty decisions are made by the right entities, for the right reasons, and are visible afterward.

- **Authentication and authorization:** All policy changes, reservations, overrides, delegations, and receipts MUST be signed and authenticated. Nodes MUST verify signatures before acting on PowerPolicyRecords, DutyCycleRecords, EmergencyOverrideRecords, and DelegationTokens.
    
- **Least privilege:** Delegations and overrides SHOULD be narrowly scoped and time‑limited. A relay that can schedule for every device forever is a single point of failure waiting to happen.
    
- **Tamper evidence:** AuditEvents and receipts SHOULD be anchored to external commitments where possible, so attempts to rewrite history are detectable.
    
- **Denial of service:** Admission controls, rate limits, and per‑origin quotas are required to mitigate abuse. A node that floods the scheduler with high‑priority reservations SHOULD be throttled and logged.
    
- **Privacy:** Power metadata can reveal operational patterns. Access controls and aggregation are recommended to avoid giving every observer a free operations dashboard.
    
- **Resilience:** Systems SHOULD avoid single points of failure for scheduling and authorization. Multi‑party confirmation and distributed logging improve robustness when (not if) something fails.
    

## 18 Compliance and interoperability requirements

Implementations claiming compliance with RFC‑2305 MUST:

- publish **PowerCapabilityRecords** and **PowerPolicyRecords** for their nodes;
    
- enforce **DutyCycleRecords** and produce **ReservationReceipts** and **AdmissionReceipts** for scheduling decisions;
    
- log **AuditEvents** for reservations, throttling, overrides, delegations, and revocations;
    
- support compact encodings for constrained devices where appropriate;
    
- document emergency override procedures and revocation semantics in their PolicyRecords.
    

These requirements ensure predictable behavior across diverse deployments, from over‑engineered Martian arrays to barely‑maintained Belter rigs and everything in between.

## 19 Forensics, auditing, and dispute resolution

Forensics is where all the careful logging pays off.

- **Retention:** AuditEvents, receipts, and state records MUST be retained per domain policy. Critical events SHOULD have longer retention than routine noise.
    
- **Correlation:** Investigations SHOULD correlate ReservationReceipts, AdmissionReceipts, PowerStateRecords, DutyScheduleRecords, and AuditEvents to reconstruct timelines. This allows investigators to answer questions like “why did this transmission not go out?” with something better than “we don’t know.”
    
- **Visibility of revocations and overrides:** Revocations and overrides MUST be visible in logs and linked to the affected transmissions. A domain that cannot show when and why it exceeded its own duty limits has a policy problem, not a technical one.
    

## 20 Next steps and companion specifications

- **RFC‑2303 — Physical Media & Propagation:** Integrates duty semantics with propagation rules, so power and duty constraints are considered alongside link classification and store‑and‑forward behavior.
    
- **RFC‑2361 — Layer Model:** Maps power and duty records into the broader SolNet stack, clarifying how they interact with routing, application layers, and authority structures.
    
- **Implementation guides:** Provide templates for PowerPolicyRecords, DutyScheduleRecord formats, and compact encodings for constrained devices, so operators do not have to invent their own half‑compatible versions.
    
- **Tooling:** Reference schedulers and audit collectors for operators who would rather run tested tools than write their own from scratch at 02:00 during a power event.
    

If all of this is implemented even halfway correctly, most power‑related outages will at least be predictable, explainable, and fixable—if not entirely avoidable. That is about as good as SolNet ever gets.