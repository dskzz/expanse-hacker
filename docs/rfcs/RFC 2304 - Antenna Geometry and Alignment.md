# RFC‑2304 — Antenna Geometry and Alignment

_SolNet Standards Working Group (SSWG)_ _Status: Informational / Foundational_

## 1 Purpose

This RFC explains how SolNet participants are supposed to describe, control, and coordinate antenna geometry and alignment for directional links. In other words: when two nodes want to talk over a narrow beam instead of spraying power everywhere, this is how they agree on where to point and how to keep pointing there.

It specifies the coordinate systems and reference frames, the records that describe antenna mounting and beam shape, the alignment state and control loops, the beaconing and ephemeris behavior, and the operational workflows needed to keep links usable across everything from a Belter skiff with a half‑calibrated dish to a Martian phased array that came with a 400‑page manual.

The goal is to give every node a consistent way to say “this is where I am pointing” and “this is where I think you are,” so higher‑level propagation and routing layers can rely on directional links without reverse‑engineering every local implementation. The document assumes that many operators will run with minimal calibration, intermittent maintenance, and varying levels of discipline, so it emphasizes explicit metadata and observable behavior instead of wishful thinking.

## 2 Scope

This specification applies to any SolNet component that:

- **Operates a directional antenna or phased array** for radio or optical communication, whether it is bolted to a station, strapped to a skiff, or buried in a Martian bunker.
    
- **Consumes or produces alignment‑related metadata**, such as geometry, state, or ephemeris.
    
- **Participates in alignment control loops**, including tracking, pointing, and beam steering.
    
- **Exposes alignment state** to other SolNet components for planning, monitoring, or forensics.
    

It covers:

- coordinate systems and reference frames;
    
- antenna geometry description;
    
- alignment state and control records;
    
- beaconing and ephemeris exchange;
    
- alignment quality metrics and reporting;
    
- workflows for establishing, maintaining, and re‑acquiring links.
    

It does **not** mandate specific antenna hardware, servo designs, modulation schemes, or physical‑layer encoding. Those are left to local engineering, budgets, and whatever regulatory mess applies. This RFC focuses on the logical model and metadata required for interoperability so that, at least on paper, a Belter retrofit and a Martian Navy array can talk about alignment in the same language.

## 3 Design goals

- **Interoperable geometry description:** Provide a common way to describe antenna orientation and beam shape so that different platforms can coordinate without guessing how someone else mounted their dish.
    
- **Delay‑tolerant alignment:** Support alignment decisions based on stale or delayed ephemeris and state, with clear indication of uncertainty, because nothing in SolNet updates on time everywhere.
    
- **Observable alignment quality:** Expose alignment quality and confidence so higher layers can react to degraded links instead of discovering them by watching throughput die.
    
- **Minimal assumptions about discipline:** Tolerate misconfigured, poorly calibrated, or rarely maintained systems by making their behavior explicit rather than implicit. If an operator is sloppy, the records should show it.
    
- **Support for constrained platforms:** Allow small devices and low‑budget installations to participate using simplified models and light‑weight metadata, instead of pretending every node has a full‑time alignment engineer.
    
- **Forensic traceability:** Record alignment decisions and state changes so link failures and disputes can be reconstructed after the fact, when everyone suddenly cares what the logs say.
    

## 4 Model overview and rationale

Directional links in SolNet are established by two or more nodes that must agree, within some tolerance, on where to point their antennas and when. This is complicated by:

- relative motion (ships drifting, stations rotating, planets spinning);
    
- imperfect sensors and clocks;
    
- local control loops with different update rates and latencies;
    
- intermittent or delayed ephemeris updates, especially in the outer system.
    

To manage this, SolNet defines:

- a set of **reference frames** and coordinate systems;
    
- **AntennaGeometryRecords** that describe physical mounting and beam characteristics;
    
- **AlignmentStateRecords** that describe current pointing, error estimates, and confidence;
    
- **EphemerisRecords** and **BeaconRecords** that provide predicted and observed positions;
    
- workflows for **initial acquisition**, **tracking**, and **re‑acquisition**.
    

The rationale is to separate “how the hardware moves” from “how the network reasons about pointing.” Implementations can use simple or complex control loops, but they MUST expose enough metadata for peers and higher layers to understand the state of a link and make safe decisions under delay and uncertainty. The network cannot assume that every operator has calibrated their platform this week, or even this year, so the model is designed to surface uncertainty instead of hiding it.

## 5 Terminology

- **Platform:** Physical object hosting one or more antennas (ship, station, buoy, ground site, corporate relay, etc.).
    
- **Reference frame:** Coordinate system used to express positions and orientations (e.g., platform‑fixed, local horizon, inertial).
    
- **Antenna geometry:** Description of how an antenna is mounted on a platform and how its beam is oriented relative to a reference frame.
    
- **Alignment state:** Current pointing direction, error estimates, and confidence for an antenna or beam.
    
- **Ephemeris:** Predicted position and motion of a platform over time.
    
- **Beacon:** Signal transmitted to assist in acquisition and tracking.
    
- **Alignment controller:** Local control loop that drives actuators or beam steering to achieve desired pointing.
    
- **Alignment tolerance:** Acceptable angular error for a given link and modulation scheme.
    
- **Alignment policy:** Local rules for when to attempt acquisition, tracking, or re‑acquisition.
    

These terms are used consistently throughout the RFC. Implementations SHOULD avoid inventing local synonyms in their APIs and logs unless they enjoy confusing their own operators.

## 6 Coordinate systems and reference frames

### 6.1 Reference frames

Implementations MUST support at least the following reference frames:

- **Platform‑fixed frame (PF):** Coordinates expressed relative to the platform’s body axes (e.g., roll, pitch, yaw). This is the “what the hardware thinks is forward” frame.
    
- **Local horizon frame (LH):** Coordinates expressed relative to local “up” and horizon, when applicable (e.g., ground sites, large stations with a defined “down”).
    
- **Inertial frame (IN):** Coordinates expressed in a shared inertial reference (e.g., solar system barycentric or equivalent), used for ephemeris and long‑range planning.
    

Each frame MUST be identified by a **FrameID** and documented in a **FrameDefinitionRecord**. Platforms MAY define additional frames (e.g., turret‑fixed, array‑fixed, sensor‑fixed) as long as they provide transformations to at least one of the standard frames. This allows other systems to interpret pointing vectors without knowing every mechanical detail of the platform.

### 6.2 Transformations

Platforms MUST maintain transformations between their local frames (e.g., PF ↔ IN, PF ↔ LH where applicable). These transformations MAY be approximate and MAY be based on delayed or noisy sensor data, but the implementation MUST expose:

- the time at which the transformation was last updated;
    
- an estimate of the transformation error;
    
- the source of the underlying sensor or ephemeris data.
    

This allows peers and higher layers to understand when a platform’s notion of “where I am pointing” may be unreliable. A platform that has not updated its PF ↔ IN transform in days SHOULD NOT be treated the same as one that updates it every few seconds, and the metadata MUST make that difference visible.

## 7 Antenna geometry description

### 7.1 AntennaGeometryRecord

Each directional antenna or beam‑forming array MUST be described by an **AntennaGeometryRecord** that includes:

- **PlatformID and AntennaID;**
    
- **reference frame** in which the antenna boresight is defined;
    
- **fixed offsets** (azimuth, elevation, roll) from the platform frame;
    
- **beamwidth** (main lobe) and approximate sidelobe characteristics;
    
- **mechanical or electronic steering limits;**
    
- **update rate and latency** of the local alignment controller.
    

This record allows peers and planning systems to understand what an antenna can physically do and how narrow or forgiving its beam is. A wide, forgiving beam on a cheap Belter rig will behave very differently from a tight Martian array, and higher layers SHOULD be able to see that without reading a maintenance log.

### 7.2 Beam models

Implementations SHOULD provide a simple beam model (for example, main lobe half‑power beamwidth and approximate gain vs. angle) sufficient for link budget estimation and alignment tolerance calculation. More complex models MAY be used locally but need not be exposed in full detail. The point is not to publish every lobe and null, but to give enough information that other systems can estimate whether a given alignment error is survivable.

## 8 Alignment state and quality

### 8.1 AlignmentStateRecord

The current pointing and quality of an antenna MUST be expressed in an **AlignmentStateRecord**, which includes:

- **AntennaID and PlatformID;**
    
- **target identifier** (peer PlatformID or abstract pointing target);
    
- **desired pointing vector** (in a specified reference frame);
    
- **actual pointing vector** (as measured or estimated);
    
- **estimated angular error** between desired and actual;
    
- **confidence level** in the error estimate;
    
- **timestamp** of the last update;
    
- **alignment mode** (idle, acquisition, tracking, re‑acquisition).
    

This record is the primary way for peers and higher layers to understand whether a link is likely to be usable at a given moment. A platform that reports “tracking, low error, high confidence” SHOULD be treated differently from one that reports “acquisition, unknown error, low confidence,” and the AlignmentStateRecord MUST make that distinction explicit.

### 8.2 Quality metrics

Implementations SHOULD expose additional quality metrics, such as:

- received signal strength or SNR;
    
- bit error rate (BER) or frame error rate (FER);
    
- tracking loop stability indicators.
    

These metrics MAY be approximate and MAY be updated at a lower rate than the control loop, but they provide important context for routing and application behavior. A link that is technically aligned but running at high BER is not the same as a clean link, and higher layers SHOULD be able to see that before they schedule critical traffic over it.

## 9 Ephemeris and beaconing

### 9.1 EphemerisRecords

Platforms that move relative to their peers SHOULD publish **EphemerisRecords** describing their predicted position and velocity over time in an inertial frame. Each record MUST include:

- PlatformID;
    
- time interval for which the ephemeris is valid;
    
- position and velocity functions or samples;
    
- reference frame;
    
- source of the ephemeris (onboard sensors, external service, manual input);
    
- estimated error bounds.
    

Ephemeris MAY be coarse for low‑budget platforms and more precise for well‑equipped installations. Consumers MUST treat ephemeris as advisory and account for its stated error. A platform that admits “this ephemeris is approximate and old” is still better than one that pretends to be precise when it is not.

### 9.2 BeaconRecords

Platforms MAY transmit **BeaconRecords** or beacon signals to assist in acquisition and tracking. A BeaconRecord describes:

- frequency or wavelength;
    
- modulation used for identification;
    
- expected duty cycle;
    
- intended coverage region or pointing direction;
    
- associated PlatformID and AntennaID.
    

Beacons are especially useful when ephemeris is stale or absent, or when local alignment controllers need a signal to lock onto. They are also a convenient way to advertise “I am here” to anyone listening, which is why policies around beacon use SHOULD be explicit and conservative in sensitive environments.

## 10 Alignment control loops

### 10.1 Local controllers

Each platform is responsible for its own alignment controller. This controller:

- consumes desired pointing vectors and ephemeris;
    
- drives actuators or beam steering;
    
- updates AlignmentStateRecords;
    
- reacts to beacon observations and signal quality metrics.
    

Controllers MAY be simple (for example, periodic repositioning based on ephemeris) or complex (for example, continuous tracking with Kalman filters and sensor fusion). The RFC does not prescribe algorithms, but it requires that the observable state be exposed consistently so that other systems can understand what the controller is doing, even if they do not know how it is implemented.

### 10.2 Control loop timing

Implementations MUST document:

- the nominal update rate of the alignment controller;
    
- the latency between a change in desired pointing and the corresponding change in actual pointing;
    
- any known dead zones or mechanical constraints.
    

This information is important when planning links that require tight timing or when coordinating multiple platforms with different control characteristics. A slow, high‑latency controller on an old station will not behave like a fast, low‑latency controller on a modern warship, and higher layers SHOULD not assume they do.

## 11 Alignment policies and tolerances

### 11.1 PolicyRecords

Each domain or operator SHOULD define **AlignmentPolicyRecords** that specify:

- acceptable alignment error for different link types and data classes;
    
- conditions under which acquisition should be attempted;
    
- conditions under which tracking should be maintained or dropped;
    
- re‑acquisition strategies after loss of lock.
    

Policies MAY vary widely: a high‑bandwidth Martian military link may require tight tolerances and aggressive tracking, while a low‑priority news feed link may tolerate larger errors and slower re‑acquisition. The important part is that the policy be explicit and recorded, so that behavior can be predicted and audited instead of guessed.

### 11.2 Tolerance calculation

Alignment tolerance SHOULD be derived from:

- beamwidth and sidelobe characteristics;
    
- link budget and modulation scheme;
    
- expected ephemeris error;
    
- platform motion and control loop latency.
    

Implementations MAY precompute tolerances for common link types and store them in policy records. This avoids recalculating the same numbers every time a link is planned and makes it easier for operators to understand why a particular tolerance was chosen.

## 12 Record types

This RFC introduces or relies on the following record types:

- **FrameDefinitionRecord:** defines a reference frame and its relationship to others.
    
- **AntennaGeometryRecord:** describes antenna mounting and beam characteristics.
    
- **AlignmentStateRecord:** describes current pointing and quality.
    
- **EphemerisRecord:** describes predicted platform motion.
    
- **BeaconRecord:** describes beacon parameters.
    
- **AlignmentPolicyRecord:** describes local alignment rules and tolerances.
    
- **AlignmentEventRecord:** logs significant alignment events (acquisition, loss of lock, re‑acquisition, policy overrides).
    

All records MUST include standard SolNet provenance fields (origin, timestamps, signatures) so they can be audited and correlated with other network events. When a link fails at the worst possible time, these records are what investigators will read while everyone insists “it was working fine yesterday.”

## 13 APIs and interfaces

Implementations SHOULD expose APIs for:

- querying current AlignmentStateRecords for a given AntennaID or PlatformID;
    
- retrieving AntennaGeometryRecords and FrameDefinitionRecords;
    
- subscribing to AlignmentEventRecords for monitoring;
    
- retrieving EphemerisRecords and BeaconRecords relevant to a given region or link;
    
- updating local AlignmentPolicyRecords (subject to authorization).
    

APIs MAY be implemented over existing SolNet messaging and query mechanisms. Responses MUST include provenance and freshness metadata so consumers can judge whether the information is current enough for their purposes. A stale AlignmentStateRecord from three hours ago SHOULD NOT be treated as equivalent to one updated thirty seconds ago, and the API MUST make that distinction visible.

## 14 Security considerations

- **Authentication:** All alignment‑related records (geometry, state, ephemeris, beacons, policies) MUST be signed by the originating platform or authority.
    
- **Authorization:** Updates to AlignmentPolicyRecords and AntennaGeometryRecords MUST be restricted to authorized entities.
    
- **Integrity:** AlignmentStateRecords and EphemerisRecords SHOULD be protected against tampering in transit.
    
- **Privacy:** Ephemeris and alignment data can reveal operational patterns. Domains MAY restrict access to detailed records and provide coarser summaries to untrusted parties.
    
- **Resilience:** Consumers SHOULD avoid relying on a single source of ephemeris or alignment data for critical decisions when multiple sources are available.
    

Security in this context is about making sure that alignment decisions are based on trustworthy information and that sensitive operational details are not exposed unnecessarily. A platform that publishes precise ephemeris to everyone is convenient for alignment and very convenient for anyone planning to watch or interfere with it.

## 15 Operational workflows and examples

The following workflows describe typical alignment‑related operations. Each is written as a detailed, step‑by‑step narrative, as if explaining to a junior engineer who has to run this in a Belter dock at 03:00 with half the tools missing. The sequence of actions, the records produced, and the behavior under delay, partitions, misconfiguration, and unreliable operators are all made explicit.

### 15.1 Initial link acquisition between two platforms

**Scenario:** Two platforms want to establish a directional link for the first time or after a long idle period.

1. **Geometry and frames published:**
    
    - Each platform publishes its **AntennaGeometryRecords** and **FrameDefinitionRecords** into the relevant SolNet directory or configuration store.
        
    - These records describe how antennas are mounted, which reference frames they use, and how to interpret pointing vectors.
        
    - If a platform fails to publish these records, peers MUST assume that any alignment information it provides is incomplete or unreliable.
        
2. **Ephemeris exchange:**
    
    - Each platform retrieves the other’s **EphemerisRecords** from a directory, prior exchange, or a trusted relay.
        
    - If ephemeris is missing, obviously stale, or marked with large error bounds, the platform notes higher uncertainty in its planning and MAY adjust its acquisition strategy (for example, wider search patterns, longer beacon windows).
        
    - In partitioned conditions, a platform MAY have to proceed with only its own ephemeris and a cached copy of the peer’s last known state.
        
3. **Desired pointing calculation:**
    
    - Using its own ephemeris and the peer’s ephemeris, each platform computes a **desired pointing vector** in its local frame for the planned acquisition time.
        
    - The platform stores this vector in its local alignment controller and updates its **AlignmentStateRecord** with `mode = acquisition`, including the desired vector, the reference frame, and the planned acquisition time.
        
    - If the platform’s frame transformations are known to be approximate, it SHOULD increase its internal error estimates and reflect that in the AlignmentStateRecord’s confidence fields.
        
4. **Beacon scheduling (optional):**
    
    - One or both platforms schedule beacon transmissions according to their **BeaconRecords**.
        
    - Beacons are configured to be broad enough to assist acquisition even with moderate pointing error, which may mean temporarily widening the beam or increasing duty cycle within policy limits.
        
    - In environments with many nearby platforms (e.g., crowded stations), beacon parameters SHOULD be chosen to minimize interference and confusion.
        
5. **Controller activation:**
    
    - At the planned time, each platform’s alignment controller drives the antenna toward the desired pointing vector, using its current frame transformations and ephemeris.
        
    - The controller updates the **AlignmentStateRecord** with the actual pointing vector, the estimated angular error, and the current mode.
        
    - If actuator limits or mechanical constraints prevent reaching the desired vector, the controller MUST record this in the AlignmentStateRecord and SHOULD emit an **AlignmentEventRecord** describing the constraint.
        
6. **Signal detection and refinement:**
    
    - Once a platform detects the peer’s signal or beacon, it refines its pointing based on signal strength, tracking algorithms, and any available quality metrics (SNR, BER, etc.).
        
    - The **AlignmentStateRecord** transitions to `mode = tracking`, and error estimates are reduced as the controller converges.
        
    - If the platform fails to detect a signal within a policy‑defined window, it MAY adjust its search pattern or fall back to a broader acquisition strategy.
        
7. **Link establishment:**
    
    - When both platforms report alignment error within policy tolerance and sufficient signal quality, higher layers treat the link as established.
        
    - Routing and propagation components may now schedule traffic over the link, taking into account any residual error and quality metrics.
        
    - An **AlignmentEventRecord** SHOULD be logged to mark successful acquisition, including the final error, confidence, and any deviations from planned behavior.
        

**Behavior under stress:**

- Under long latency or poor ephemeris, acquisition may require wider initial search patterns, longer beacon windows, and more conservative error estimates.
    
- In partitions, platforms may operate on stale peer ephemeris and MUST reflect this in their confidence and error bounds.
    
- Misconfigured geometry or stale frame definitions will manifest as persistent alignment errors and repeated acquisition failures, which can be diagnosed by examining AlignmentStateRecords and AlignmentEventRecords over time.
    

### 15.2 Tracking and maintaining alignment during relative motion

**Scenario:** Two platforms have established a link and now need to keep it aligned while they move relative to each other.

1. **Continuous ephemeris updates:**
    
    - Platforms periodically update their **EphemerisRecords** based on new sensor data or external services.
        
    - Each update includes revised error estimates and validity intervals.
        
    - If ephemeris updates are delayed or unavailable (for example, during a partition), the platform MUST continue to use the last known ephemeris but SHOULD increase its internal error estimates over time.
        
2. **Desired pointing updates:**
    
    - The alignment controller recomputes **desired pointing vectors** as relative positions change, using the latest ephemeris and frame transformations.
        
    - These updates are reflected in **AlignmentStateRecords** with new desired vectors, timestamps, and updated error estimates.
        
    - If the platform detects that its frame transformations are degrading (for example, due to sensor drift), it SHOULD adjust its confidence levels accordingly.
        
3. **Control loop adjustments:**
    
    - The controller adjusts actuators or beam steering to follow the desired pointing, subject to mechanical limits and latency.
        
    - It monitors signal quality metrics (SNR, BER, FER) and adjusts gains, tracking parameters, or search patterns as needed to maintain lock.
        
    - If the controller detects oscillations or instability, it SHOULD log an **AlignmentEventRecord** and MAY fall back to a more conservative control mode.
        
4. **Quality monitoring:**
    
    - The platform logs **AlignmentEventRecords** when alignment error approaches tolerance limits or when signal quality degrades beyond policy thresholds.
        
    - Operators or automated systems may adjust **AlignmentPolicyRecords** in response, for example by relaxing tolerances for non‑critical traffic or tightening them for high‑priority links.
        
    - Monitoring systems SHOULD correlate alignment events with traffic performance to detect patterns of degradation.
        
5. **Policy‑driven decisions:**
    
    - If alignment error exceeds policy thresholds for a sustained period, the platform MAY drop tracking and revert to acquisition mode, logging an AlignmentEventRecord to document the transition.
        
    - For high‑priority links, policies may allow more aggressive tracking and re‑acquisition attempts, including increased beacon use or temporary relaxation of other constraints.
        
    - In heavily loaded or bureaucratically constrained environments, policy changes may lag behind conditions, and this lag SHOULD be visible in the event and policy records.
        

**Behavior under stress:**

- In the presence of partitions or delayed ephemeris, tracking may rely more heavily on local sensors and less on external updates, increasing uncertainty.
    
- Poorly maintained platforms may exhibit oscillatory or unstable tracking, visible as frequent AlignmentEventRecords and fluctuating error estimates.
    
- Misconfigured policies can cause platforms to either cling to marginal links too long or drop them too quickly, both of which can be diagnosed by correlating policy records, alignment events, and traffic logs.
    

### 15.3 Re‑acquisition after loss of lock

**Scenario:** A platform loses lock on a peer due to motion, interference, misalignment, or operator error and needs to re‑acquire the link.

1. **Loss detection:**
    
    - A platform detects loss of lock when signal quality drops below a configured threshold or when alignment error exceeds tolerance for a policy‑defined duration.
        
    - The platform updates its **AlignmentStateRecord** to reflect the loss (for example, `mode = re‑acquisition`) and logs an **AlignmentEventRecord** documenting the transition from tracking to re‑acquisition, including the observed error and quality metrics at the time of loss.
        
2. **Search pattern selection:**
    
    - Based on the last known pointing, ephemeris error, and local **AlignmentPolicyRecords**, the platform selects a search pattern (for example, spiral, raster, or sector sweep) around the last known target direction.
        
    - The pattern parameters (step size, dwell time, coverage region) are stored locally and MAY be logged in an AlignmentEventRecord for diagnostics.
        
    - If ephemeris is known to be stale or highly uncertain, the platform SHOULD choose a wider search region and MAY adjust its expectations for re‑acquisition time.
        
3. **Beacon coordination (if available):**
    
    - The platform MAY request the peer to increase beacon duty cycle, widen its beam, or adjust its own search behavior temporarily, according to policy and higher‑layer messaging.
        
    - These requests and responses SHOULD be logged as events or policy overrides, especially when they deviate from normal operating procedures.
        
    - In partitioned conditions, such coordination may not be possible, and the platform MUST rely solely on its own search pattern.
        
4. **Search execution:**
    
    - The alignment controller executes the selected search pattern, stepping the antenna through the defined pointing positions and updating **AlignmentStateRecords** with current pointing, estimated error, and `mode = re‑acquisition`.
        
    - At each step, the controller monitors for the peer’s signal or beacon. If a signal is detected, the controller transitions back to tracking mode, refines the pointing, and logs an AlignmentEventRecord marking successful re‑acquisition.
        
    - If the search pattern completes without detection, the controller MAY repeat the pattern, expand the search region, or escalate according to policy.
        
5. **Timeout and fallback:**
    
    - If re‑acquisition fails within a policy‑defined time or after a configured number of attempts, the platform MAY abandon the attempt and mark the link as unavailable in its local routing and planning systems.
        
    - Higher layers may reroute traffic, schedule a later acquisition attempt, or notify operators.
        
    - An AlignmentEventRecord SHOULD document the failure, including search parameters, ephemeris state, and any policy overrides that occurred.
        

**Behavior under stress:**

- Under high relative motion or poor ephemeris, re‑acquisition may be frequent and may require larger search regions and more aggressive beacon use.
    
- Misconfigured policies can cause platforms to waste time searching in regions where the peer is unlikely to be, or to give up too early, both of which can be diagnosed by correlating ephemeris, alignment events, and link availability over time.
    
- Unreliable operators may override policies ad‑hoc; such overrides SHOULD be visible in AlignmentEventRecords and policy logs.
    

### 15.4 Constrained device participation in alignment

**Scenario:** A constrained device (for example, a small skiff terminal or embedded controller) participates in directional links without full ephemeris and alignment logic.

1. **Simplified geometry:**
    
    - The constrained device publishes a minimal **AntennaGeometryRecord** with coarse beamwidth, limited steering information, and a single local reference frame.
        
    - It may rely on approximate orientation (for example, “forward relative to hull”) rather than precise platform‑fixed axes.
        
    - This record still MUST include enough information for peers to understand the device’s basic pointing capabilities and limitations.
        
2. **Assisted ephemeris:**
    
    - The device retrieves **EphemerisRecords** from a nearby relay, directory, or more capable platform rather than computing them locally.
        
    - It records the source and freshness of this ephemeris in its local state and MAY expose this information in its AlignmentStateRecord or related metadata.
        
    - If ephemeris is missing or stale, the device SHOULD treat its own alignment confidence as low and reflect that in its records.
        
3. **Guided pointing:**
    
    - A more capable platform (for example, a station relay) provides the device with a recommended **desired pointing vector** and timing for acquisition, based on its own ephemeris and geometry.
        
    - The device’s alignment controller uses this vector as its desired pointing and updates its **AlignmentStateRecord** with `mode = acquisition`, the recommended vector, and any local error estimates.
        
    - If the device cannot reach the recommended pointing due to mechanical limits, it MUST record this in its state.
        
4. **Local verification:**
    
    - The device monitors basic signal quality metrics (for example, simple RSSI or link up/down status) and updates a simplified AlignmentStateRecord.
        
    - It may not compute detailed angular error estimates but can still report success or failure of acquisition and tracking, along with timestamps and mode transitions.
        
    - When the device detects loss of lock, it SHOULD follow a simplified re‑acquisition policy or request assistance from the guiding platform.
        
5. **Policy constraints:**
    
    - For critical operations (for example, control channels, financial transactions, or safety‑related traffic), the device’s policies MAY require confirmation from a trusted authority (such as a Directory & Routing Endpoint) before treating a link as usable.
        
    - These policies SHOULD be recorded in AlignmentPolicyRecords or equivalent configuration and SHOULD be visible to operators and auditors.
        
    - In low‑budget or lightly managed environments, such policies may be minimal, and the resulting risk profile SHOULD be understood by anyone relying on those devices.
        

**Behavior under stress:**

- Constrained devices are particularly sensitive to stale or incorrect guidance, since they lack the resources to cross‑check ephemeris or alignment independently.
    
- In partitions, they may continue to operate on outdated recommendations longer than is ideal, which SHOULD be visible in their state and event records.
    
- Misconfigured or overloaded guiding platforms can mislead many constrained devices at once, a pattern that can be detected by correlating failures across multiple devices.
    

## 16 Privacy and data minimization

Operators SHOULD minimize the exposure of detailed ephemeris and alignment data to parties that do not need it. Coarse summaries or aggregated statistics MAY be provided instead, especially to untrusted or external consumers. Access to fine‑grained records SHOULD be controlled and audited, particularly for platforms whose movement patterns are sensitive (for example, military assets, high‑value corporate relays, or politically sensitive installations).

At the same time, operators MUST balance privacy with the need for interoperability and forensics. Hiding all useful data makes alignment harder and investigations impossible; exposing everything makes tracking trivial. This RFC does not dictate that balance but requires that whatever choice is made be explicit and documented.

## 17 Compliance and interoperability requirements

Implementations claiming compliance with RFC‑2304 MUST:

- support at least the standard reference frames (PF, LH, IN) and document any additional frames via FrameDefinitionRecords;
    
- publish AntennaGeometryRecords for directional antennas;
    
- maintain and expose AlignmentStateRecords for active antennas and links;
    
- support EphemerisRecords or equivalent mechanisms when relative motion is significant;
    
- implement AlignmentPolicyRecords or equivalent configuration for alignment behavior;
    
- log AlignmentEventRecords for significant state changes (acquisition, loss of lock, re‑acquisition, policy overrides).
    

These requirements ensure that different platforms can coordinate alignment even when their internal implementations differ, their budgets are not comparable, and their operators have very different ideas about “good enough.”

## 18 Forensics, auditing, and dispute resolution

Alignment‑related records (geometry, state, ephemeris, events) SHOULD be retained according to domain policy. In the event of disputes (for example, link unavailability, missed commitments, alleged interference, or accusations of deliberate misalignment), investigators can reconstruct:

- whether platforms attempted acquisition or tracking at the relevant times;
    
- whether ephemeris or geometry was misconfigured or stale;
    
- whether alignment policies were followed, overridden, or ignored;
    
- how alignment state evolved leading up to the incident.
    

Consistent logging and provenance are essential for resolving such disputes. Without them, every failure will be blamed on “space weather” or “the other guy’s equipment,” and no one will be able to prove otherwise.

## 19 Next steps and companion specifications

- **RFC‑2303 — Physical Media & Propagation:** defines how alignment interacts with propagation, store‑and‑forward behavior, and link classification.
    
- **RFC‑2361 — Layer Model:** integrates alignment metadata into the broader SolNet stack, including routing and application layers.
    
- **RFC‑23xx — Link Budget and Modulation Profiles (future):** will define how alignment tolerances relate to modulation and coding schemes, making it easier to plan links end‑to‑end.
    
- **Implementation guides:** recommended patterns for small platforms, high‑precision arrays, and mixed‑discipline environments, including examples for Belter skiffs, Martian military installations, and large Earth‑side bureaucratic networks.
    

These companion documents and guides will refine how alignment fits into the overall SolNet architecture and provide concrete examples for operators who prefer working from patterns rather than from first principles.