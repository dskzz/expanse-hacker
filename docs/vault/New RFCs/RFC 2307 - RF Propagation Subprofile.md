# **1 Purpose (Rewritten in Correct Kade Voice)**

_Dr. Arjun Kade, MIAP RF Systems Group_
_Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group (collaborative research appointment)_

RF propagation is the primary communication medium for SolNet, and therefore the primary source of misunderstandings. Many operators describe RF as “unpredictable,” as though the medium were governed by whim rather than physics. It is not. What they interpret as unpredictability is interference, misconfiguration, or the consequences of long‑standing folklore.

The purpose of this document is to define the canonical RF propagation subprofile, including channel profiles, interference semantics, beaconing behavior, and scheduled‑band reservation. These definitions exist to ensure that RF behaves predictably across the Authority and Namespace planes. They do not exist to validate personal theories about RF behavior, no matter how confidently those theories are expressed.

RF is entirely capable of stable, deterministic operation. It simply requires that implementers follow the constraints defined here and refrain from practices that have repeatedly proven incompatible with both SolNet and basic physics.

**Footnote 1:** Portions of the interference classification model were developed during a joint MIAP–Luna University research exchange with Dr. Selene Vargo (MIAP Optical Systems Group). The collaboration was productive, although Dr. Vargo requested that RF operators “stop touching things during calibration,” a recommendation this author fully endorses.

# **2 Scope

This document defines the RF propagation subprofile for SolNet. It covers the structures, behaviors, and constraints required for RF to function as a reliable medium rather than a collection of anecdotes.

The scope includes:

- RFChannelProfileRecord definitions
    
- interference classification and reporting
    
- beaconing intervals and timing guarantees
    
- scheduled‑band reservation semantics
    
- FHSS/LPI module behavior
    
- RFLinkQualityRecord structure and provenance
    
- DRE RFChannel advertisement requirements
    

The scope explicitly excludes:

- “tuning by feel”
    
- “bumping the gain until it works”
    
- “the antenna was pointed in the general direction”
    
- “RF gremlins”
    
- any explanation that begins with “in my experience”
    

These practices are incompatible with SolNet and, in several documented cases, with basic physics.

This document defines the minimum constraints required for RF to behave predictably across the Authority and Namespace planes. Implementers who believe RF is inherently unpredictable will discover that the medium becomes far more stable once their personal theories are removed from the system

# **4 Canonical RF Channel Profiles**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

RF channels must be described using canonical profiles to ensure that systems interpret the medium consistently. Without standardized profiles, implementers tend to rely on informal descriptions such as “pretty clean,” “a bit noisy,” or “fine yesterday,” none of which contain measurable information. The RFChannelProfileRecord exists to prevent this form of ambiguity from entering SolNet.

A canonical RF channel profile defines:

- **frequency range**
    
- **bandwidth**
    
- **modulation constraints**
    
- **expected noise floor**
    
- **interference class**
    
- **beaconing requirements**
    
- **scheduled‑band eligibility**
    
- **FHSS/LPI compatibility**
    

These parameters are not optional. They are the minimum set required to describe an RF channel in a way that another system can interpret without resorting to guesswork or folklore.

## **4.1 Default RF Profile**

The default RF profile represents a shared, unscheduled band with predictable noise characteristics and no special coordination requirements. It is the baseline against which all other profiles are compared. Systems must assume the default profile unless a more specific profile is explicitly declared and verifiably sourced.

The default profile is appropriate for:

- general routing
    
- low‑priority beaconing
    
- non‑critical telemetry
    
- environments where interference is present but manageable
    

It is not appropriate for:

- time‑critical coordination
    
- high‑density environments
    
- operators who believe “it should be fine”
    

## **4.2 Scheduled‑Band Profile**

Scheduled bands provide deterministic access to RF resources. They exist because unscheduled operation inevitably leads to contention, and contention inevitably leads to operators increasing power “just a little,” which leads to further contention. Scheduled bands break this cycle by enforcing strict timing windows and reservation semantics.

A scheduled‑band profile includes:

- reservation window
    
- permitted modulation
    
- maximum power
    
- timing accuracy requirements
    
- enforcement behavior
    

Systems must reject transmissions that occur outside the assigned window. Scheduled bands are not suggestions, and treating them as such has measurable, negative effects on every participant.

## **4.3 FHSS/LPI Profile**

Frequency‑hopping and low‑probability‑of‑intercept modes require disciplined behavior. Improvised hopping sequences or “creative” dwell times are incompatible with SolNet and, in several documented cases, with basic physics. FHSS/LPI profiles define:

- hopping pattern class
    
- dwell time constraints
    
- synchronization requirements
    
- permitted deviation
    
- provenance of the hopping sequence
    

FHSS/LPI behavior must be predictable to the system even if it is intentionally unpredictable to observers.

## **4.4 High‑Interference Profile**

Some environments contain persistent, unavoidable interference. These environments are not mysterious; they are simply noisy. High‑interference profiles define:

- elevated noise floor
    
- expected interference classes
    
- fallback modulation
    
- beaconing adjustments
    
- error‑tolerant timing windows
    

Systems must not treat high‑interference environments as anomalies. They are common, measurable, and entirely predictable once properly classified.

## **4.5 Profile Provenance**

All RFChannelProfileRecords must carry verifiable provenance. Profiles without provenance are indistinguishable from folklore, and folklore has no place in a deterministic system. Provenance ensures that channel behavior can be audited, reproduced, and corrected.

# **5 Beaconing and Channel Announcements**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Beaconing is the mechanism by which RF systems announce their presence, capabilities, and channel state. It is intended to provide stability and coordination. Unfortunately, beaconing is also the mechanism most frequently modified by operators “to see what happens,” a practice that has produced results ranging from mild interference to complete channel collapse. This section defines the constraints required to prevent such outcomes.

## **5.1 Beacon Interval Discipline**

Beacon intervals must be deterministic. Systems must transmit beacons at the interval defined by the RFChannelProfileRecord, with permitted jitter no greater than the specified tolerance. Operators sometimes adjust beacon intervals based on personal preference or anecdotal experience. These adjustments introduce timing ambiguity, which is then misinterpreted as RF instability.

Beacon intervals are not a tuning parameter. They are a coordination mechanism.

## **5.2 Beacon Power and Modulation**

Beacon power levels and modulation parameters must remain constant within a profile. Increasing beacon power “for visibility” does not improve coordination; it merely increases interference. Changing modulation “to test performance” produces inconsistent channel occupancy that other systems cannot interpret.

Beacon parameters must be stable, predictable, and profile‑compliant. Any deviation undermines the purpose of beaconing.

## **5.3 Beacon Content Requirements**

A beacon must contain:

- the RFChannelProfileRecord identifier
    
- the transmitter’s provenance
    
- timing accuracy metadata
    
- interference observations (if applicable)
    
- scheduled‑band reservation status (if applicable)
    

Beacons must not contain:

- experimental fields
    
- undocumented extensions
    
- operator notes
    
- “temporary” identifiers
    
- any field described as “for testing”
    

Beacon content must be machine‑interpretable and verifiable. Human creativity is not a supported field.

## **5.4 Beacon Provenance**

All beacons must carry verifiable provenance. Provenance ensures that systems can distinguish between legitimate beacons, misconfigured devices, and improvised transmissions. Beacons without provenance are indistinguishable from noise, and noise is indistinguishable from interference. Provenance prevents this ambiguity.

## **5.5 Channel Announcements**

Channel announcements provide higher‑level information about channel state, including:

- interference class
    
- occupancy
    
- scheduled‑band availability
    
- FHSS/LPI compatibility
    
- recent RFInterferenceEvents
    

Announcements must be derived from measurement, not intuition. Systems must not generate announcements based on operator observation, anecdotal experience, or “gut feeling.” Channel announcements that are not grounded in measurement produce misleading behavior that other systems interpret as instability.

## **5.6 Beaconing in High‑Interference Environments**

In high‑interference environments, beaconing must adapt within profile constraints. Increasing power is not an acceptable adaptation. Systems must:

- maintain interval discipline
    
- adjust modulation only within permitted fallback modes
    
- include interference metadata
    
- avoid beacon storms by respecting backoff rules
    

High‑interference environments are not exceptional. They are common, predictable, and manageable when treated as measurable conditions rather than mysteries.

## **5.7 Improvised Beaconing**

Improvised beaconing — including ad‑hoc intervals, experimental modulation, or undocumented fields — is incompatible with SolNet and, in several documented cases, with basic physics. Systems must reject improvised beacons and treat them as interference.

Beaconing is a coordination mechanism, not a creative medium.


# **6 Interference Model and Classification**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Interference is not an unexpected condition. It is not a surprise. It is not a mysterious force that “comes and goes.” Interference is the natural consequence of multiple systems attempting to occupy the same medium without coordination. The only surprising aspect of interference is the persistent belief among operators that it is somehow unusual.

This section defines the canonical interference model required for SolNet RF stability. It exists because implementers routinely treat interference as an anomaly, and anomalies are often blamed on the medium rather than on the measurable conditions that produced them.

## **6.1 Interference as the Baseline State**

RF channels must be assumed to contain interference unless proven otherwise. This is not pessimism; it is the observable condition of every shared spectrum environment. Systems that assume “clean channels” without measurement inevitably misinterpret normal behavior as instability.

Interference is not a failure mode. It is a **state**.

The failure occurs when systems do not measure it.

## **6.2 Measurement Requirements**

Systems must continuously measure:

- **noise floor** (absolute and relative)
    
- **adjacent‑channel occupancy**
    
- **co‑channel contention**
    
- **modulation collisions**
    
- **beacon storms**
    
- **improvised transmissions**
    
- **scheduled‑band violations**
    

Measurements must be taken at defined intervals and recorded with provenance. Measurements without provenance are indistinguishable from operator speculation.

## **6.3 Interference Classes (Canonical)**

SolNet defines six interference classes. These classes are not subjective. They are not interpretive. They are not “guidelines.” They are measurable conditions.

- **Class 0 — Nominal:** Noise floor within expected bounds.
    
- **Class 1 — Elevated:** Persistent noise above baseline; channel still usable.
    
- **Class 2 — Contention:** Multiple systems competing for the same band; performance degraded.
    
- **Class 3 — Collision:** Overlapping transmissions producing measurable corruption.
    
- **Class 4 — Improvised:** Non‑profile‑compliant transmissions, including experimental beacons and undocumented modulation.
    
- **Class 5 — Catastrophic:** Channel unusable; typically caused by operator intervention.
    

Class 5 is not a natural phenomenon. It is a human phenomenon.

## **6.4 RFInterferenceEvent Structure**

Each interference event must include:

- timestamp (profile‑aligned)
    
- interference class
    
- measured parameters
    
- suspected or confirmed source
    
- confidence level
    
- provenance chain
    

Events without provenance must be rejected. Events with incomplete measurement must be flagged. Events based on operator intuition must not be generated.

## **6.5 Operator‑Induced Interference**

Operator‑induced interference is the leading cause of RF instability. Common sources include:

- adjusting power “to see what happens”
    
- modifying beacon intervals
    
- improvising FHSS sequences
    
- transmitting outside scheduled windows
    
- enabling undocumented modulation modes
    
- disabling provenance “temporarily”
    

These practices are incompatible with SolNet and, in several documented cases, with basic physics.

## **6.6 Interference as a Predictable Condition**

Interference is predictable when measured. It is unpredictable when ignored.

Systems must treat interference as a measurable, classifiable, and correctable condition. Operators must not treat it as folklore.

# # **7 Scheduled‑Band Reservation Semantics**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Scheduled bands exist because unscheduled operation inevitably devolves into improvisation, and improvisation inevitably contaminates the RF medium. The purpose of scheduled‑band semantics is not to provide convenience; it is to prevent human behavior from introducing entropy into a deterministic system.

A scheduled band is a **contract** between physics and protocol. Operators are not parties to this contract. Their preferences, intuitions, and “quick adjustments” are irrelevant.

This section defines the constraints required to ensure that scheduled bands remain immune to folklore.

## **7.1 Why Scheduled Bands Exist**

Unscheduled operation invites:

- contention
    
- collision
    
- power escalation
    
- undocumented modulation
    
- improvised timing
    
- “temporary exceptions” that become permanent failures
    

Scheduled bands exist to eliminate these behaviors by replacing human decision‑making with deterministic timing windows.

A scheduled band is not a shared space. It is a **controlled environment**.

Any deviation — even minor — introduces contamination.

## **7.2 Reservation Windows**

A reservation window defines:

- **start time** (absolute, profile‑aligned)
    
- **end time**
    
- **permitted modulation**
    
- **maximum power**
    
- **timing accuracy**
    
- **fallback behavior**
    

These parameters are not adjustable. They are not “guidelines.” They are not “defaults.”

They are the minimum constraints required to prevent operators from treating the RF medium as a sandbox.

Transmitting outside the assigned window is not a mistake. It is **contamination**.

## **7.3 RFReservationReceipt**

A reservation receipt is the only acceptable proof that a system is authorized to transmit within a scheduled band. It must include:

- reservation ID
    
- channel profile
    
- timing window
    
- permitted modulation
    
- provenance chain
    
- enforcement flags
    

Receipts without provenance are indistinguishable from improvisation. Improvisation is indistinguishable from interference.

Therefore, receipts without provenance must be rejected without exception.

## **7.4 Enforcement Behavior**

Systems must enforce scheduled‑band compliance with the same rigor used to enforce cryptographic validity. This includes:

- rejecting out‑of‑window transmissions
    
- reporting violations as RFInterferenceEvents
    
- refusing to honor improvised reservations
    
- maintaining deterministic timing even under load
    

Enforcement is not punitive. It is **preventative**.

The goal is not to punish misbehavior. The goal is to prevent misbehavior from contaminating the medium.

## **7.5 Misbehavior Classification**

Misbehavior includes, but is not limited to:

- early transmission
    
- late transmission
    
- excessive power
    
- incorrect modulation
    
- undocumented extensions
    
- “temporary” timing adjustments
    
- operator‑initiated overrides
    

These are not edge cases. They are predictable outcomes of human involvement.

Misbehavior is not subtle. It is measurable.

## **7.6 Scheduled Bands and Human Creativity**

Human creativity has produced many valuable contributions to science. Scheduled‑band improvisation is not one of them.

Attempts to “optimize,” “experiment,” or “improve performance” by modifying scheduled‑band behavior must be treated as contamination events.

The RF medium does not reward creativity. It rewards compliance.

# **8 FHSS/LPI Module Behavior**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Frequency‑hopping and low‑probability‑of‑intercept modes are routinely misunderstood by operators who believe that unpredictability is a virtue in RF systems. It is not. Unpredictability is a contaminant. FHSS/LPI modes are only effective when their unpredictability is **intentional**, **bounded**, and **mathematically constrained** — not when it is the byproduct of improvisation.

FHSS/LPI behavior must be predictable **to the system**, even if it is intentionally unpredictable **to observers**. This distinction is lost on operators who treat hopping sequences as an opportunity for creativity. Creativity has many appropriate venues. RF is not one of them.

This section defines the constraints required to ensure that FHSS/LPI modules remain deterministic, reproducible, and immune to folklore.

## **8.1 Purpose of FHSS/LPI (and What It Is Not)**

FHSS/LPI modes exist to:

- reduce detectability
    
- distribute channel load
    
- mitigate interference
    
- maintain link integrity under hostile conditions
    
- provide resilience against narrowband jamming
    

They do **not** exist to:

- “improve performance” through undocumented tweaks
    
- test experimental hopping sequences
    
- compensate for misconfiguration
    
- express operator individuality
    
- “see what happens”
    

FHSS is not a creative medium. It is a controlled stochastic process.

When operators treat it otherwise, they contaminate the system.

## **8.2 Hopping Pattern Classes**

SolNet defines three hopping pattern classes. These classes are not suggestions; they are the only acceptable patterns.

### **Class A — Deterministic**

A fixed, profile‑defined sequence. Predictable, reproducible, and immune to improvisation.

### **Class B — Pseudo‑Random**

A seeded sequence that appears random to observers but is fully reproducible to the system. The seed must be profile‑defined and provenance‑verified.

### **Class C — Coordinated Pseudo‑Random**

A synchronized pseudo‑random sequence shared across multiple systems. Deviation by even one participant introduces contamination.

### **Improvised Patterns — Not Permitted**

Any hopping pattern not explicitly defined in the profile is contamination. Not “non‑compliant.” Not “suboptimal.” **Contamination.**

Improvised patterns are incompatible with SolNet and, in several documented cases, with basic physics.

## **8.3 Dwell Time Constraints**

Dwell time is the duration spent on each frequency before hopping. It is not a tuning parameter. It is not a performance lever. It is not an opportunity for experimentation.

Dwell time must remain within profile limits because:

- too long increases detectability
    
- too short increases desynchronization
    
- inconsistent dwell time contaminates the hopping pattern
    
- operator‑adjusted dwell time contaminates everything
    

Extending dwell time “for stability” does not improve stability. It merely increases the probability of collision.

Reducing dwell time “for agility” does not improve agility. It merely increases the probability of drift.

FHSS/LPI dwell time is a **constraint**, not a suggestion.

## **8.4 Synchronization Requirements**

FHSS/LPI modules must maintain synchronization with:

- beacon timing
    
- reservation windows
    
- channel announcements
    
- profile‑defined timing tolerances
    
- provenance‑verified seeds
    

Desynchronization is not an RF failure. It is a configuration failure.

Systems must detect drift early, correct it deterministically, and report it as a measurable condition — not as “strange RF behavior,” a phrase that has no diagnostic value and considerable folklore value.

## **8.5 Provenance of Hopping Sequences**

Every hopping sequence — deterministic or pseudo‑random — must carry a complete provenance chain. This chain ensures that:

- the sequence is profile‑compliant
    
- the seed is valid
    
- the timing is correct
    
- the pattern is reproducible
    
- no operator has “temporarily adjusted” anything
    

Sequences without provenance are indistinguishable from improvisation. Improvisation is indistinguishable from interference. Interference is indistinguishable from contamination.

Therefore, sequences without provenance must be rejected immediately and without exception.

## **8.6 FHSS/LPI in High‑Interference Environments**

High‑interference environments are not exceptional. They are common, predictable, and measurable.

FHSS/LPI modules must adapt **within profile constraints**, not around them. This means:

- no power escalation
    
- no modulation changes
    
- no hopping‑pattern modification
    
- no undocumented fallback
    
- no operator‑initiated overrides
    

The correct response to interference is measurement, not improvisation.

When FHSS/LPI modules behave deterministically, interference becomes manageable. When operators intervene, interference becomes contamination.

## **8.7 The Contamination Boundary**

FHSS/LPI modes sit at the boundary between:

- **deterministic RF physics** and
    
- **human attempts to outsmart deterministic RF physics**
    

This boundary must be defended rigorously.

FHSS/LPI modules must not:

- accept undocumented parameters
    
- tolerate timing drift
    
- allow operator creativity
    
- incorporate folklore
    
- degrade gracefully into improvisation
    

FHSS/LPI behavior must remain immune to contamination.

The moment it becomes negotiable, it becomes useless.


# **9 RFLinkQualityRecord Specification**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Link quality is one of the most frequently misrepresented concepts in RF systems. Operators routinely describe link conditions using terms such as “pretty good,” “solid,” “fine yesterday,” or the particularly unhelpful “RF seems weird today.” None of these statements contain measurable information. All of them contaminate the diagnostic process.

The RFLinkQualityRecord exists to eliminate subjective interpretation and replace it with deterministic, reproducible measurement. It is not a convenience structure. It is a containment structure — designed to prevent folklore from entering the system under the guise of “operator experience.”

This section defines the canonical structure, semantics, and provenance requirements for link‑quality reporting.

## **9.1 Purpose of RFLinkQualityRecord**

The RFLinkQualityRecord serves three critical functions:

1. **Quantification** — replacing intuition with measurement.
    
2. **Reproducibility** — ensuring that link quality can be compared across time, systems, and environments.
    
3. **Containment** — preventing undocumented interpretations from contaminating routing, scheduling, and modulation decisions.
    

It is not optional. It is not advisory. It is the minimum requirement for deterministic operation.

Without it, systems fall back on operator intuition, which is indistinguishable from noise.

## **9.2 Required Fields**

A valid RFLinkQualityRecord must include:

- **Signal Strength (Absolute and Relative)** Not “strong,” not “fine,” not “good enough.” Measured values only.
    
- **Noise Floor** The actual noise floor, not the operator’s belief about it.
    
- **Interference Class** As defined in Section 6. Not “seems noisy.”
    
- **Modulation Success Rate** A measurable ratio, not a feeling.
    
- **Timing Accuracy** Drift is contamination; accuracy is containment.
    
- **Measurement Window** Explicit, profile‑defined, provenance‑verified.
    
- **Provenance Chain** Without provenance, the record is folklore.
    

Records missing any of these fields must be rejected. Records containing undocumented fields must be invalidated. Records generated manually must not exist.

## **9.3 Measurement Windows**

Measurement windows define the temporal scope of link‑quality evaluation. They exist because:

- **short windows** exaggerate transient conditions
    
- **long windows** obscure meaningful variation
    
- **operator‑selected windows** introduce contamination
    

Measurement windows must be:

- profile‑defined
    
- deterministic
    
- consistent across systems
    
- immune to operator adjustment
    

Operators must not modify measurement windows “to get better numbers.” This practice is indistinguishable from data manipulation.

## **9.4 Smoothing Rules**

Smoothing is required to prevent transient anomalies from contaminating link‑quality interpretation. However, smoothing must follow:

- exponential decay
    
- bounded memory
    
- profile‑defined parameters
    
- no operator intervention
    

Manual smoothing is not smoothing. It is falsification.

Systems must not allow operators to “clean up” link‑quality data. Clean data is measured, not curated.

## **9.5 Interpretation Constraints**

RFLinkQualityRecord is a measurement structure, not a narrative device. It must not be interpreted subjectively.

Common misinterpretations include:

- assuming high power improves quality
    
- ignoring interference class
    
- treating transient success as stability
    
- attributing measurement noise to “RF gremlins”
    
- believing that link quality is a matter of opinion
    

RF gremlins do not exist. Interference does.

Link quality is not a feeling. It is a measurable condition.

## **9.6 Provenance Requirements**

Provenance is the only defense against contamination. Every RFLinkQualityRecord must include:

- origin
    
- measurement chain
    
- timestamp
    
- profile ID
    
- verification signature (if applicable)
    

Records without provenance are indistinguishable from folklore. Folklore is indistinguishable from contamination.

Therefore, records without provenance must be rejected immediately and without exception.

## **9.7 Link Quality as a Deterministic Condition**

Link quality reflects:

- physics
    
- interference
    
- configuration
    
- compliance
    

It does not reflect:

- optimism
    
- intuition
    
- anecdotal experience
    
- operator confidence
    
- “how it felt yesterday”
    

When measured correctly, link quality is predictable. When interpreted subjectively, it becomes folklore.

The RFLinkQualityRecord exists to prevent that contamination.

# **10 DRE RFChannel Records**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Directory & Routing Endpoints (DREs) are responsible for propagating RF channel state across SolNet. They do not interpret intuition. They do not interpolate folklore. They do not “fill in the gaps” based on operator experience. They propagate **records**, and those records must be deterministic, reproducible, and immune to contamination.

RF channels evolve over time. Human interpretation evolves faster — and rarely in the direction of accuracy.

The DRE RFChannelRecord exists to ensure that the system’s understanding of RF conditions is grounded in **measurement**, not **memory**, and in **provenance**, not **confidence**.

This section defines the canonical structure and propagation semantics required to prevent operator‑originated contamination from entering the routing plane.

## **10.1 Purpose of RFChannel Records**

RFChannelRecords serve as the authoritative description of RF conditions for all higher‑layer decisions. They exist because:

- local observations are insufficient
    
- operator interpretations are unreliable
    
- undocumented behavior is contagious
    
- routing decisions must be deterministic
    
- scheduled‑band coordination requires shared state
    
- FHSS/LPI synchronization depends on accurate metadata
    

Without RFChannelRecords, systems fall back on local heuristics. Local heuristics are indistinguishable from folklore. Folklore is indistinguishable from contamination.

RFChannelRecords are the containment boundary.

## **10.2 Record Structure**

A valid DRE RFChannelRecord must include:

- **Channel Profile ID** Identifies the canonical behavior expected on this channel.
    
- **Current Interference Class** As defined in Section 6. Not “seems busy.”
    
- **Occupancy Metrics** Measured, not inferred.
    
- **Scheduled‑Band Reservations** Including active windows and pending transitions.
    
- **FHSS/LPI Compatibility Flags** Deterministic indicators, not operator speculation.
    
- **Link‑Quality Aggregates** Derived from RFLinkQualityRecords, not operator summaries.
    
- **Timestamp** Profile‑aligned, provenance‑verified.
    
- **Provenance Chain** The only defense against contamination.
    

Records missing any of these fields must be rejected. Records containing undocumented fields must be invalidated. Records generated manually must not exist.

## **10.3 Propagation Semantics**

DREs must propagate RFChannelRecords:

- at profile‑defined intervals
    
- upon interference‑class transitions
    
- upon scheduled‑band reservation updates
    
- upon FHSS/LPI synchronization changes
    
- upon link‑quality threshold crossings
    

Propagation must **not** occur:

- because an operator “noticed something”
    
- to compensate for misconfiguration
    
- to “get ahead of a problem”
    
- in response to intuition
    
- as part of an undocumented optimization
    

Propagation is a deterministic process. It is not a conversation.

The moment propagation becomes discretionary, it becomes contaminated.

## **10.4 Caching and Invalidation**

DREs may cache RFChannelRecords to reduce load, but caches must be invalidated when:

- timestamps exceed profile limits
    
- interference class changes
    
- scheduled‑band reservations expire
    
- FHSS/LPI flags change
    
- provenance becomes unverifiable
    
- link‑quality aggregates drift beyond tolerance
    

Stale RF data is not “mostly correct.” It is incorrect.

Systems that rely on stale data behave unpredictably, and unpredictability is indistinguishable from interference.

Caching is a performance optimization. Invalidation is a contamination‑prevention mechanism.

## **10.5 Cross‑Plane Interactions**

RFChannelRecords are not isolated to the RF domain. They influence:

- **routing decisions (A‑plane)** Incorrect RF state produces incorrect path selection.
    
- **namespace discovery (N‑plane)** Misreported channel availability contaminates service visibility.
    
- **session establishment (N4)** Incorrect link‑quality aggregates produce unstable sessions.
    
- **personal namespace policies (N5)** Misinterpreted interference leads to incorrect access decisions.
    

RF is the foundation. Every higher‑layer decision inherits its accuracy — or its contamination.

When RFChannelRecords are correct, the system behaves predictably. When they are contaminated, the system behaves like an operator.

This is unacceptable.

## **10.6 The Contamination Boundary**

The DRE is the boundary between:

- **measured RF reality** and
    
- **human attempts to reinterpret that reality**
    

RFChannelRecords must not:

- incorporate undocumented fields
    
- accept operator‑generated data
    
- tolerate missing provenance
    
- degrade gracefully into heuristics
    
- allow improvisation to masquerade as measurement
    

The DRE’s role is not to interpret RF conditions. It is to **propagate them without contamination**.

Any deviation from this principle is a systemic failure.

# **11 L1 RFChannelHint TLV**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Hints exist because systems benefit from early, lightweight indicators of RF conditions — **systems**, not operators. The RFChannelHint TLV is a mechanism for conveying narrowly scoped, profile‑aligned metadata that assists in routing, scheduling, and modulation decisions. It is not a mechanism for expressing intuition, speculation, or “situational awareness.”

Hints are not opinions. Hints are not theories. Hints are not “quick notes.”

Hints are **structured, deterministic signals** designed to prevent contamination by ensuring that higher‑layer decisions are informed by **measurement**, not **folklore**.

This section defines the canonical semantics of RFChannelHint TLVs and the constraints required to prevent their misuse.

## **11.1 Purpose of RFChannelHint**

The RFChannelHint TLV exists to:

- accelerate convergence
    
- reduce miscoordination
    
- provide early warning of interference trends
    
- assist in fallback selection
    
- support FHSS/LPI synchronization
    
- prevent higher layers from misinterpreting transient RF behavior
    

It does **not** exist to:

- override measurements
    
- replace RFChannelRecords
    
- compensate for misconfiguration
    
- express operator intuition
    
- carry experimental fields
    
- “explain” RF behavior
    

Hints are advisory signals for machines, not narrative devices for humans.

## **11.2 Encoding Requirements**

The RFChannelHint TLV must include:

- **Hint Type** A profile‑defined identifier. Not a free‑form string.
    
- **Hint Value** A constrained, deterministic value. Not a sentence.
    
- **Timestamp** Profile‑aligned, provenance‑verified.
    
- **Provenance Chain** The only defense against contamination.
    
- **Profile ID** Ensures the hint is interpreted correctly.
    

Hints missing any of these fields must be rejected. Hints containing undocumented fields must be invalidated. Hints generated manually must not exist.

## **11.3 Supported Hint Types**

Supported hints are intentionally narrow. They convey **state**, not **interpretation**.

### **Interference‑Trend**

Indicates whether interference is rising, falling, or stable. Not “seems noisy.”

### **Occupancy‑Shift**

Indicates expected changes in channel load. Not “channel might get busy.”

### **Scheduled‑Band‑Imminent**

Indicates that a reservation window is approaching. Not “someone is about to transmit.”

### **FHSS‑Sync‑Drift**

Indicates measurable deviation in hopping synchronization. Not “FHSS feels off.”

### **Fallback‑Recommended**

Indicates that profile‑defined fallback conditions have been met. Not “you might want to switch channels.”

Unsupported hints include:

- “operators reported issues”
    
- “temporary workaround”
    
- “RF acting strange”
    
- “probably fine”
    

These are not hints. These are contamination vectors.

## **11.4 Hint Semantics**

Hints must be:

- **advisory**
    
- **non‑binding**
    
- **profile‑aligned**
    
- **derived from measurement**
    
- **reproducible**
    
- **immune to operator interpretation**
    

Hints must **not**:

- alter system behavior directly
    
- override profile constraints
    
- modify beaconing
    
- change modulation
    
- adjust power
    
- compensate for misconfiguration
    

Hints inform decisions. They do not make them.

The moment a hint becomes authoritative, it becomes a liability.

## **11.5 Provenance Requirements**

Provenance is mandatory. A hint without provenance is indistinguishable from folklore.

Every hint must include:

- origin
    
- measurement chain
    
- timestamp
    
- profile ID
    
- verification signature (if applicable)
    

Hints without provenance must be rejected immediately and without exception.

## **11.6 Misuse of Hints**

Common misuse includes:

- using hints to mask misconfiguration
    
- generating hints manually
    
- treating hints as authoritative
    
- using hints to justify improvisation
    
- embedding undocumented fields
    
- interpreting hints as narrative explanations
    

Improvised hints are indistinguishable from interference. Interference is indistinguishable from contamination.

Therefore, improvised hints must be treated as contamination events.

## **11.7 The Contamination Boundary**

The RFChannelHint TLV sits at a critical boundary:

- **below it** lies deterministic RF measurement
    
- **above it** lies higher‑layer decision‑making
    

Hints must not allow contamination to cross this boundary.

They must not:

- carry folklore
    
- encode intuition
    
- embed operator theories
    
- degrade into free‑form metadata
    
- become a substitute for measurement
    

Hints exist to prevent contamination, not to transport it.


# **12 Operational Behavior**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Operational behavior is where RF systems most frequently diverge from deterministic physics and drift into human improvisation. The RF medium does not change its laws during startup, fallback, or recovery. Humans, however, routinely change their behavior during these phases — usually in ways that contaminate the system.

Operational behavior must be governed by **measurement**, **provenance**, and **profile constraints**, not by operator intuition or “situational judgment.” This section defines the canonical operational behaviors required to prevent contamination during the most vulnerable phases of RF system activity.

## **12.1 Startup Behavior**

Startup is the phase during which systems are most susceptible to contamination because operators incorrectly assume that “nothing important is happening yet.” In reality, startup is where the system establishes the deterministic foundation upon which all subsequent behavior depends.

During startup, systems must:

- load profile constraints
    
- measure the noise floor
    
- scan for beacons
    
- classify interference
    
- synchronize timing
    
- validate provenance
    
- verify scheduled‑band state
    
- confirm FHSS/LPI readiness
    

Systems must **not**:

- transmit immediately
    
- assume channel availability
    
- rely on cached data
    
- use undocumented modulation
    
- accept operator overrides
    
- “test the channel”
    

Startup is a measurement phase, not a transmission phase. Any transmission during startup is contamination.

## **12.2 Fallback Behavior**

Fallback exists to preserve determinism when conditions degrade. It is not a mechanism for experimentation, creativity, or “trying something else.”

Fallback must be:

- deterministic
    
- profile‑defined
    
- reversible
    
- measurable
    
- provenance‑verified
    

Fallback must **not** be:

- improvised
    
- operator‑triggered
    
- undocumented
    
- experimental
    
- used to mask misconfiguration
    

Fallback is a containment mechanism. Its purpose is to prevent contamination from spreading.

## **12.3 Recovery Behavior**

Recovery is the process of returning to normal operation after interference, desynchronization, or scheduled‑band transitions. Recovery must be gradual, controlled, and deterministic.

Recovery must:

- re‑establish timing
    
- re‑validate provenance
    
- re‑measure interference
    
- re‑synchronize FHSS/LPI modules
    
- re‑confirm scheduled‑band state
    

Recovery must **not**:

- occur abruptly
    
- skip measurement phases
    
- accept stale data
    
- rely on operator judgment
    
- assume stability
    

Sudden transitions produce instability. Instability is contamination.

## **12.4 High‑Interference Behavior**

High‑interference environments are not exceptional. They are common, predictable, and measurable. Systems must behave deterministically under these conditions.

In high‑interference environments, systems must:

- maintain beacon discipline
    
- reduce modulation complexity
    
- adjust timing within profile limits
    
- report interference events
    
- avoid beacon storms
    
- avoid power escalation
    
- maintain FHSS/LPI synchronization
    

Increasing power is not a solution. It is a multiplier.

High‑interference behavior must be governed by physics, not by optimism.

## **12.5 Misconfiguration Detection**

Misconfiguration is not subtle. It is measurable.

Systems must detect:

- incorrect modulation
    
- incorrect power
    
- incorrect timing
    
- missing provenance
    
- undocumented fields
    
- improvised behavior
    
- stale RFChannelRecords
    
- invalid hint TLVs
    

Misconfiguration must be treated as contamination because it produces the same systemic effects.

Detection must be:

- immediate
    
- deterministic
    
- profile‑aligned
    
- provenance‑verified
    

Systems must not allow misconfiguration to degrade into folklore.

## **12.6 Operator Intervention**

Operator intervention is the leading cause of RF failure. It is also the most preventable.

Operators must **not** intervene during:

- calibration
    
- synchronization
    
- scheduled‑band operation
    
- FHSS/LPI sequencing
    
- provenance validation
    
- fallback or recovery
    
- interference classification
    

Operator intervention introduces entropy into a deterministic system. Entropy is contamination.

The RF medium does not require human assistance. It requires humans to stop assisting.

## **12.7 The Operational Contamination Boundary**

Operational behavior is the boundary between:

- **deterministic RF physics** and
    
- **human attempts to accelerate, simplify, or “improve” deterministic RF physics**
    

This boundary must be defended rigorously.

Operational behavior must not:

- incorporate undocumented adjustments
    
- tolerate timing drift
    
- accept operator intuition
    
- degrade into heuristics
    
- allow improvisation to masquerade as optimization
    

Operational behavior is not a negotiation. It is a containment protocol.


# **13 Security Considerations**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Security failures in RF systems rarely originate from adversaries with sophisticated equipment. They originate from operators who believe that RF security is optional, decorative, or something that can be “tightened later.” This belief is incorrect. The RF layer is the only layer that cannot be retroactively secured once compromised. Any contamination introduced here propagates upward, where it becomes indistinguishable from legitimate state.

RF security is not a separate discipline. It is not an overlay. It is not a “nice to have.”

RF security is **the containment boundary** that prevents human behavior — and adversarial behavior — from polluting deterministic RF physics.

This section defines the minimum security requirements necessary to prevent contamination at the RF layer.

## **13.1 Spoofed Beacons**

Spoofed beacons are the most direct method of contaminating RF state because they exploit the assumption that beacons are authoritative. This assumption is only valid when provenance is intact.

Systems must validate:

- **provenance** A beacon without provenance is not a beacon. It is contamination.
    
- **timing** Incorrect timing is not a minor deviation. It is a measurable attack.
    
- **modulation** Deviations indicate either misconfiguration or malice. Both are contamination.
    
- **profile ID** Incorrect profile IDs are not “mistakes.” They are indicators of tampering.
    
- **signature (if applicable)** Cryptographic validation is not optional.
    

Beacons that fail any validation step must be rejected immediately and reported as RFInterferenceEvents.

A system that accepts unverifiable beacons is not compromised — it is complicit.

## **13.2 Malicious Interference**

Malicious interference is not subtle. It is measurable.

It includes:

- intentional collisions
    
- power flooding
    
- modulation corruption
    
- FHSS desynchronization attempts
    
- scheduled‑band disruption
    
- beacon storms
    

Malicious interference must be classified using the same interference classes defined in Section 6. The classification system exists precisely because malicious interference is often indistinguishable from operator improvisation.

The system must treat both as contamination until proven otherwise.

## **13.3 Provenance Tampering**

Provenance is the only mechanism that prevents folklore from masquerading as fact. It is also the only mechanism that prevents adversaries from injecting false state into the system.

Provenance tampering includes:

- broken chains
    
- missing links
    
- unverifiable origins
    
- altered timestamps
    
- mismatched profile IDs
    
- undocumented fields
    

Systems must:

- validate provenance chains
    
- reject broken or incomplete chains
    
- detect anomalies
    
- refuse unverifiable data
    

Provenance is not metadata. It is the immune system of the RF layer.

A system that accepts unverifiable data is not “flexible.” It is contaminated.

## **13.4 FHSS Desynchronization Attacks**

FHSS desynchronization attacks target the boundary between deterministic hopping behavior and operator‑induced drift. These attacks exploit the fact that many operators believe FHSS is “random enough” to tolerate deviation.

It is not.

Desynchronization attacks manipulate:

- hopping patterns
    
- dwell times
    
- timing windows
    
- beacon alignment
    
- seed provenance
    

Systems must:

- detect drift early
    
- classify it deterministically
    
- initiate controlled recovery
    
- reject improvised corrections
    

Improvised recovery is indistinguishable from failure. Failure is indistinguishable from contamination.

## **13.5 Scheduled‑Band Abuse**

Scheduled bands are a shared resource. Abuse of scheduled bands is not a performance issue. It is a security issue.

Abuse includes:

- unauthorized reservations
    
- out‑of‑window transmissions
    
- excessive power
    
- incorrect modulation
    
- undocumented extensions
    
- “temporary exceptions”
    

Scheduled‑band abuse contaminates the timing model upon which the entire RF layer depends.

Systems must treat scheduled‑band violations as security events, not operational anomalies.

## **13.6 Human Factors**

The greatest security risk in RF systems is not malicious actors. It is operators who believe they understand RF better than the system does.

This belief produces:

- undocumented adjustments
    
- improvised modulation
    
- “temporary” overrides
    
- provenance bypasses
    
- manual timing corrections
    
- folklore‑based troubleshooting
    

These behaviors are not benign. They are contamination vectors.

RF security is not compromised by adversaries alone. It is compromised by anyone who treats RF physics as negotiable.

## **13.7 The Security Contamination Boundary**

Security considerations at the RF layer exist to prevent contamination from crossing the boundary between:

- **deterministic RF physics** and
    
- **human or adversarial attempts to manipulate deterministic RF physics**
    

Security mechanisms must not:

- tolerate unverifiable data
    
- accept undocumented behavior
    
- degrade into heuristics
    
- rely on operator judgment
    
- allow improvisation to masquerade as optimization
    

RF security is not about trust. It is about containment.


# **14 Diagnostics and Error Semantics**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Diagnostics exist because RF systems fail in ways that are measurable, repeatable, and predictable — yet operators persist in describing failures using language that is none of those things. Terms like “acting weird,” “seems off,” or the particularly unhelpful “RF glitch” provide no actionable information. They are folklore masquerading as diagnostics.

The purpose of SolNet’s diagnostic and error semantics is to ensure that **every failure is described in a way that prevents contamination** — contamination of logs, contamination of routing decisions, contamination of operator understanding, and contamination of the RF medium itself.

Diagnostics are not a narrative. Diagnostics are not a conversation. Diagnostics are a containment protocol.

This section defines the canonical diagnostic structures and error semantics required to ensure that RF failures remain measurable and immune to folklore.

## **14.1 Diagnostic Philosophy**

Diagnostics must adhere to three principles:

### **1. Determinism**

Every diagnostic must correspond to a measurable condition. If it cannot be measured, it cannot be diagnosed.

### **2. Reproducibility**

Diagnostics must be reproducible across systems, environments, and implementations. If two systems produce different interpretations of the same condition, the diagnostic is contaminated.

### **3. Provenance**

Every diagnostic must include a complete provenance chain. Without provenance, a diagnostic is indistinguishable from speculation.

Diagnostics exist to prevent improvisation from entering the system under the guise of “observations.”

## **14.2 Error Classes**

SolNet defines error classes to ensure that failures are categorized deterministically. These classes are not interpretive. They are not advisory. They are not “best guesses.”

They are measurable conditions.

### **Class A — Configuration Errors**

Incorrect modulation, incorrect power, incorrect timing, missing provenance, undocumented fields. These are not subtle. They are contamination.

### **Class B — Environmental Errors**

Interference, noise floor elevation, adjacent‑channel occupancy, beacon storms. These are measurable and must be classified accordingly.

### **Class C — Synchronization Errors**

FHSS drift, beacon misalignment, scheduled‑band timing deviation. These are not “timing quirks.” They are failures.

### **Class D — Provenance Errors**

Broken chains, unverifiable origins, mismatched profile IDs. These are security failures and must be treated as such.

### **Class E — Hardware Errors**

Oscillator instability, amplifier saturation, antenna mismatch. These are physical failures, not excuses for improvisation.

### **Class F — Operator‑Induced Errors**

Manual overrides, undocumented adjustments, “temporary fixes,” intuition‑based tuning. These are the most common and the most preventable.

Operator‑induced errors are not accidents. They are contamination events.

## **14.3 Diagnostic Record Structure**

A valid diagnostic record must include:

- error class
    
- error code
    
- measured parameters
    
- timestamp
    
- affected subsystem
    
- severity
    
- provenance chain
    
- recommended deterministic action
    

Records missing any of these fields must be rejected. Records containing undocumented fields must be invalidated. Records generated manually must not exist.

Diagnostics are not annotations. They are structured containment artifacts.

## **14.4 Error Codes**

Error codes must be:

- deterministic
    
- profile‑defined
    
- unambiguous
    
- reproducible
    
- immune to operator interpretation
    

Error codes must **not**:

- encode narrative explanations
    
- embed operator theories
    
- include free‑form text
    
- degrade into “notes”
    

An error code is a pointer to a measurable condition, not a diary entry.

## **14.5 Human‑Readable Messages**

Human‑readable messages exist only to provide context for operators who are not familiar with the underlying measurement. They must be:

- concise
    
- factual
    
- free of interpretation
    
- free of speculation
    
- free of folklore
    

Messages such as:

- “RF behaving strangely”
    
- “possible interference”
    
- “channel might be unstable”
    

are prohibited.

Human‑readable messages must not contaminate the diagnostic process.

## **14.6 Diagnostic Propagation**

Diagnostics must propagate:

- immediately
    
- deterministically
    
- with full provenance
    
- without operator intervention
    

Propagation must **not** occur:

- based on intuition
    
- to “get ahead of a problem”
    
- to compensate for misconfiguration
    
- because an operator “noticed something”
    

Diagnostics are not a communication channel for human concerns. They are a communication channel for measurable conditions.

## **14.7 Contamination Through Diagnostics**

Diagnostics are a common contamination vector because operators often treat them as suggestions rather than constraints. This leads to:

- undocumented adjustments
    
- improvised fixes
    
- speculative interpretations
    
- folklore‑based troubleshooting
    
- “temporary” overrides that become permanent
    

Diagnostics must not be interpreted creatively. They must be interpreted deterministically.

A diagnostic that invites interpretation is a failure. A diagnostic that tolerates improvisation is contamination.

## **14.8 The Diagnostic Contamination Boundary**

Diagnostics sit at the boundary between:

- **measured RF reality** and
    
- **human attempts to reinterpret that reality**
    

This boundary must be defended rigorously.

Diagnostics must not:

- encode folklore
    
- tolerate missing provenance
    
- degrade into heuristics
    
- allow operator creativity
    
- become narrative explanations
    

Diagnostics exist to prevent contamination, not to transport it.

# **15 Logging and Evidence Preservation**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Logs are not stories. Logs are not diaries. Logs are not a place for operators to record their impressions of “what probably happened.”

Logs are **evidence** — evidence of measurable RF conditions, evidence of deterministic system behavior, and evidence of contamination when it occurs. The purpose of SolNet’s logging and evidence‑preservation requirements is to ensure that every RF‑relevant event is recorded in a way that is immune to folklore, immune to interpretation, and immune to operator creativity.

A log that tolerates improvisation is not a log. It is a contamination vector.

This section defines the canonical logging structures and evidence‑preservation semantics required to ensure that RF events remain measurable, auditable, and immune to human reinterpretation.

## **15.1 Logging Philosophy**

Logging must adhere to three principles:

### **1. Fidelity**

Logs must reflect what happened, not what an operator believes happened.

### **2. Immutability**

Logs must not be altered, corrected, or “cleaned up.” A corrected log is indistinguishable from falsified evidence.

### **3. Provenance**

Every log entry must include a complete provenance chain. Without provenance, a log entry is indistinguishable from folklore.

Logs exist to preserve evidence, not to preserve narratives.

## **15.2 Required Log Types**

SolNet requires the following log categories:

### **RFEvent Logs**

Interference events, beacon anomalies, FHSS drift, scheduled‑band violations. These are the primary indicators of contamination.

### **Diagnostic Logs**

Error codes, error classes, measurement failures. These must be deterministic and reproducible.

### **Provenance Logs**

Chain‑of‑custody records for all RF‑relevant data. These prevent tampering from masquerading as misconfiguration.

### **Timing Logs**

Beacon alignment, FHSS synchronization, reservation windows. Timing drift is contamination; timing logs are the evidence.

### **Configuration Logs**

Profile IDs, modulation settings, power levels, fallback states. Configuration drift is one of the most common contamination sources.

Logs that do not fall into these categories must not exist.

## **15.3 Log Entry Structure**

A valid log entry must include:

- event type
    
- timestamp
    
- measured parameters
    
- affected subsystem
    
- severity
    
- provenance chain
    
- profile ID
    
- deterministic context
    

Entries missing any of these fields must be rejected. Entries containing undocumented fields must be invalidated. Entries generated manually must not exist.

Logs are not annotations. They are forensic artifacts.

## **15.4 Immutability Requirements**

Logs must be:

- append‑only
    
- cryptographically sealed (if applicable)
    
- resistant to operator modification
    
- resistant to deletion
    
- resistant to “cleanup”
    

Operators must not:

- edit logs
    
- redact logs
    
- summarize logs
    
- annotate logs
    
- “correct” logs
    

A modified log is not a log. It is contaminated evidence.

## **15.5 Evidence Preservation**

Evidence preservation is not optional. It is the only mechanism that allows systems to distinguish between:

- misconfiguration
    
- interference
    
- malicious behavior
    
- operator improvisation
    

Evidence must be preserved:

- in full
    
- with provenance
    
- without compression
    
- without summarization
    
- without operator interpretation
    

Evidence must not be:

- rewritten
    
- reinterpreted
    
- condensed
    
- “cleaned up”
    
- replaced with operator notes
    

Evidence that has been interpreted is no longer evidence. It is folklore.

## **15.6 Log Retention**

Retention periods must be:

- profile‑defined
    
- deterministic
    
- consistent across systems
    
- immune to operator adjustment
    

Operators must not shorten retention “to save space.” Storage is cheap. Contamination is expensive.

Retention is not a convenience. It is a containment mechanism.

## **15.7 Log Propagation**

Logs must propagate:

- immediately
    
- deterministically
    
- with full provenance
    
- without operator intervention
    

Propagation must **not** occur:

- based on intuition
    
- to “get ahead of a problem”
    
- because an operator “noticed something”
    
- as part of an undocumented optimization
    

Logs are not a communication channel for human concerns. They are a communication channel for measurable conditions.

## **15.8 Contamination Through Logging**

Logging is one of the most common contamination vectors because operators often treat logs as a place to record their interpretations rather than the system’s measurements.

Contamination occurs when logs contain:

- free‑form text
    
- operator theories
    
- undocumented fields
    
- speculative explanations
    
- “temporary notes”
    
- folklore
    

Logs must not encode interpretation. Logs must encode measurement.

A log that invites interpretation is a failure. A log that tolerates interpretation is contamination.

## **15.9 The Evidence Contamination Boundary**

Logging and evidence preservation sit at the boundary between:

- **measured RF reality** and
    
- **human attempts to reinterpret that reality**
    

This boundary must be defended rigorously.

Logs must not:

- encode folklore
    
- tolerate missing provenance
    
- degrade into heuristics
    
- allow operator creativity
    
- become narrative explanations
    

Logs exist to prevent contamination, not to transport it.

# **16 Compliance and Conformance Requirements**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Compliance is not a matter of interpretation. Conformance is not a matter of opinion. Both exist to prevent human behavior from contaminating deterministic RF physics.

Operators frequently treat compliance as a checklist, conformance as a suggestion, and deviations as “temporary exceptions.” These assumptions are incorrect. Compliance and conformance are the only mechanisms that prevent undocumented behavior from entering the system and propagating upward, where it becomes indistinguishable from legitimate state.

This section defines the canonical requirements for compliance and conformance in SolNet RF systems. These requirements are not advisory. They are the minimum constraints necessary to prevent contamination.

## **16.1 Compliance Philosophy**

Compliance exists to ensure that:

- systems behave deterministically
    
- measurements remain reproducible
    
- provenance remains intact
    
- scheduled‑band semantics remain unpolluted
    
- FHSS/LPI behavior remains bounded
    
- diagnostics remain meaningful
    
- logs remain evidence
    

Compliance is not a negotiation. It is a containment protocol.

A system that is “mostly compliant” is non‑compliant. A system that is “temporarily non‑compliant” is contaminated.

## **16.2 Conformance Levels**

SolNet defines three conformance levels. These levels are not performance tiers. They are contamination‑resistance tiers.

### **Level 0 — Non‑Conformant**

Systems that:

- improvise modulation
    
- adjust power arbitrarily
    
- disable provenance
    
- modify scheduled‑band timing
    
- generate undocumented hints
    
- accept unverifiable beacons
    

These systems are not merely non‑conformant. They are contamination sources.

### **Level 1 — Baseline Conformant**

Systems that:

- implement all mandatory profile constraints
    
- maintain provenance
    
- classify interference correctly
    
- preserve timing accuracy
    
- reject undocumented behavior
    

These systems are acceptable. They are not exceptional.

### **Level 2 — Deterministic Conformant**

Systems that:

- exceed timing accuracy requirements
    
- maintain strict FHSS/LPI synchronization
    
- propagate RFChannelRecords with zero drift
    
- preserve logs immutably
    
- enforce scheduled‑band semantics rigorously
    

These systems are not merely compliant. They are contamination‑resistant.

## **16.3 Mandatory Compliance Requirements**

The following requirements are mandatory for all SolNet RF systems:

- **Provenance must be preserved** for all RF‑relevant data.
    
- **Undocumented behavior must be rejected** immediately.
    
- **Scheduled‑band semantics must be enforced** without exception.
    
- **FHSS/LPI modules must remain deterministic** within profile limits.
    
- **Diagnostics must be deterministic** and reproducible.
    
- **Logs must be immutable** and free of interpretation.
    
- **Fallback must be profile‑defined** and not operator‑initiated.
    
- **Recovery must be controlled** and measurement‑driven.
    
- **Operator overrides must be prohibited** during critical phases.
    

Compliance is not achieved by intent. It is achieved by measurement.

## **16.4 Prohibited Behaviors**

The following behaviors are prohibited because they introduce contamination:

- undocumented modulation
    
- improvised hopping sequences
    
- manual timing adjustments
    
- “temporary” provenance bypasses
    
- operator‑generated hints
    
- manual log edits
    
- speculative diagnostics
    
- power escalation
    
- “quick tests” during startup
    
- “workarounds” during scheduled‑band operation
    

These behaviors are not edge cases. They are predictable outcomes of human involvement.

Prohibited behaviors are not mistakes. They are contamination events.

## **16.5 Conformance Testing**

Conformance testing must be:

- deterministic
    
- reproducible
    
- profile‑aligned
    
- provenance‑verified
    
- immune to operator influence
    

Testing must include:

- modulation verification
    
- timing accuracy
    
- FHSS/LPI synchronization
    
- scheduled‑band enforcement
    
- interference classification
    
- diagnostic correctness
    
- log immutability
    
- provenance integrity
    

Testing must not include:

- operator interpretation
    
- undocumented adjustments
    
- “practical shortcuts”
    
- “real‑world exceptions”
    

Conformance testing is not a simulation of operator behavior. It is a simulation of physics.

## **16.6 Non‑Conformance Handling**

Non‑conformance is not a warning. It is a contamination alert.

Systems must:

- isolate non‑conformant behavior
    
- report it deterministically
    
- prevent propagation
    
- refuse to interoperate with unverifiable state
    

Operators must not:

- override non‑conformance
    
- suppress diagnostics
    
- “temporarily ignore” violations
    
- treat non‑conformance as advisory
    

Non‑conformance is not a suggestion to improve. It is a requirement to stop.

## **16.7 The Compliance Contamination Boundary**

Compliance and conformance sit at the boundary between:

- **deterministic RF physics** and
    
- **human attempts to reinterpret deterministic RF physics**
    

This boundary must be defended rigorously.

Compliance must not:

- tolerate undocumented behavior
    
- degrade into heuristics
    
- rely on operator judgment
    
- allow improvisation to masquerade as optimization
    
- accept unverifiable state
    

Compliance is not about trust. It is about containment.

A system that cannot contain contamination is not compliant. It is compromised.


# **17 Interoperability Constraints**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Interoperability is often misunderstood as a matter of “compatibility” or “flexibility.” It is neither. Interoperability is the discipline of ensuring that multiple systems can operate in proximity **without contaminating one another**. This requires strict adherence to deterministic behavior, profile‑defined semantics, and provenance‑verified state exchange.

Systems do not fail to interoperate because RF physics is difficult. They fail because one or more participants introduce undocumented behavior, improvisation, or folklore into the shared medium.

Interoperability is not a negotiation. It is a containment boundary.

This section defines the constraints required to ensure that SolNet RF systems interoperate without allowing contamination to propagate across devices, vendors, or implementations.

## **17.1 Interoperability Philosophy**

Interoperability is governed by three principles:

### **1. Deterministic Behavior**

Systems must behave identically under identical conditions. Deviation is contamination.

### **2. Profile Fidelity**

Profiles exist to prevent improvisation. Ignoring them is not “vendor differentiation.” It is contamination.

### **3. Provenance Integrity**

State exchanged between systems must be verifiable. Unverifiable state is indistinguishable from interference.

Interoperability is not achieved by tolerance. It is achieved by constraint.

## **17.2 Mandatory Interoperability Requirements**

All SolNet RF systems must:

- implement the full profile for their channel class
    
- propagate RFChannelRecords deterministically
    
- classify interference identically
    
- maintain FHSS/LPI synchronization within tolerance
    
- enforce scheduled‑band semantics without exception
    
- reject undocumented behavior from peers
    
- validate provenance on all received state
    
- preserve timing accuracy across boundaries
    

Interoperability is not a matter of “working together.” It is a matter of **not contaminating each other**.

## **17.3 Cross‑Vendor Determinism**

Cross‑vendor interoperability is the most common contamination vector because vendors often treat standards as suggestions and deviations as “enhancements.”

Enhancements that alter:

- timing
    
- modulation
    
- power
    
- hopping sequences
    
- hint semantics
    
- diagnostic codes
    
- log structure
    

are not enhancements. They are contamination.

Cross‑vendor determinism requires:

- identical interpretation of profiles
    
- identical enforcement of constraints
    
- identical rejection of undocumented behavior
    

A vendor that introduces undocumented behavior is not innovative. It is a contamination source.

## **17.4 Interoperability Failure Modes**

Interoperability failures are predictable and measurable. They include:

### **Timing Drift**

Caused by inconsistent beacon intervals, FHSS desync, or operator “tuning.” Timing drift is contamination.

### **Profile Divergence**

Caused by undocumented extensions or vendor‑specific shortcuts. Profile divergence is contamination.

### **Provenance Mismatch**

Caused by incomplete or unverifiable chains. Provenance mismatch is contamination.

### **Semantic Drift**

Caused by inconsistent interpretation of hint TLVs, diagnostics, or error codes. Semantic drift is contamination.

### **Fallback Incompatibility**

Caused by improvised fallback behavior. Fallback incompatibility is contamination.

Interoperability failures are not mysteries. They are the measurable consequences of contamination.

## **17.5 Interoperability Testing**

Interoperability testing must be:

- deterministic
    
- reproducible
    
- profile‑aligned
    
- provenance‑verified
    
- immune to operator influence
    

Testing must include:

- beacon alignment
    
- FHSS/LPI synchronization
    
- scheduled‑band enforcement
    
- interference classification
    
- diagnostic consistency
    
- log structure validation
    
- provenance chain verification
    

Testing must not include:

- operator interpretation
    
- undocumented adjustments
    
- “real‑world shortcuts”
    
- vendor‑specific exceptions
    

Interoperability testing is not a demonstration. It is a containment audit.

## **17.6 Rejecting Non‑Conformant Peers**

Systems must reject peers that:

- transmit without provenance
    
- violate scheduled‑band semantics
    
- use undocumented modulation
    
- propagate unverifiable RFChannelRecords
    
- generate improvised hints
    
- exhibit timing drift beyond tolerance
    
- produce contaminated diagnostics
    

Rejection is not punitive. It is preventative.

A system that accepts contaminated state becomes contaminated itself.

## **17.7 The Interoperability Contamination Boundary**

Interoperability sits at the boundary between:

- **deterministic RF physics** and
    
- **multiple human‑designed systems attempting to share a medium**
    

This boundary must be defended rigorously.

Interoperability must not:

- tolerate undocumented behavior
    
- degrade into heuristics
    
- rely on operator judgment
    
- allow vendor creativity to override physics
    
- accept unverifiable state
    

Interoperability is not about cooperation. It is about containment.

A system that cannot contain contamination cannot interoperate.


# **18 Failure Modes and Contamination Pathways**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

RF systems do not fail mysteriously. They fail predictably, measurably, and for reasons that are almost always documented in advance — though rarely by the operators responsible for the failure.

The purpose of this section is to identify the canonical failure modes of SolNet RF systems and the contamination pathways through which those failures propagate. These pathways are not theoretical. They are the observed, repeatable mechanisms by which deterministic RF physics becomes polluted by human improvisation, undocumented behavior, and adversarial manipulation.

Failure is not an event. Failure is a process. Contamination is the mechanism by which that process spreads.

## **18.1 Failure Mode Taxonomy**

SolNet RF failures fall into four categories. These categories are not interpretive. They are measurable.

### **1. Deterministic Failures**

Failures caused by physical conditions:

- excessive noise floor
    
- adjacent‑channel saturation
    
- oscillator instability
    
- antenna mismatch
    
- amplifier compression
    

These failures are predictable and diagnosable.

### **2. Behavioral Failures**

Failures caused by human behavior:

- undocumented modulation
    
- improvised hopping sequences
    
- manual timing adjustments
    
- “temporary” provenance bypasses
    
- operator‑generated diagnostics
    

These failures are preventable and unacceptable.

### **3. Semantic Failures**

Failures caused by inconsistent interpretation:

- divergent hint semantics
    
- vendor‑specific extensions
    
- misaligned diagnostic codes
    
- profile misinterpretation
    

Semantic failures are contamination disguised as compatibility.

### **4. Adversarial Failures**

Failures caused by intentional manipulation:

- spoofed beacons
    
- FHSS desynchronization
    
- scheduled‑band disruption
    
- provenance tampering
    
- power flooding
    

Adversarial failures exploit the same pathways as operator failures.

## **18.2 Primary Contamination Pathways**

Contamination enters the system through predictable mechanisms. These pathways must be understood, monitored, and eliminated.

### **18.2.1 Timing Drift**

Timing drift is the most common contamination vector because operators incorrectly assume that “a few milliseconds” is inconsequential.

It is not.

Timing drift contaminates:

- beacon alignment
    
- FHSS synchronization
    
- scheduled‑band windows
    
- diagnostic interpretation
    
- routing decisions
    

Timing drift is not a symptom. It is a failure mode.

### **18.2.2 Provenance Gaps**

Provenance gaps occur when:

- chains are incomplete
    
- timestamps are missing
    
- profile IDs mismatch
    
- signatures fail
    
- undocumented fields appear
    

A provenance gap is not a clerical error. It is a contamination breach.

### **18.2.3 Undocumented Behavior**

Undocumented behavior includes:

- improvised modulation
    
- experimental hopping sequences
    
- operator‑generated hints
    
- manual log edits
    
- speculative diagnostics
    

Undocumented behavior is indistinguishable from malicious behavior. Both must be treated as contamination.

### **18.2.4 Semantic Drift**

Semantic drift occurs when:

- vendors reinterpret profiles
    
- hint TLVs diverge
    
- diagnostics become narrative
    
- logs encode operator opinion
    

Semantic drift is contamination disguised as innovation.

### **18.2.5 Improvised Recovery**

Improvised recovery is the most dangerous contamination pathway because it occurs during a vulnerable phase.

Improvised recovery includes:

- manual timing corrections
    
- power escalation
    
- undocumented fallback
    
- “quick fixes”
    

Improvised recovery does not restore determinism. It spreads contamination.

## **18.3 Contamination Propagation Model**

Contamination propagates through the system in predictable stages:

### **Stage 1 — Local Deviation**

A single system deviates from deterministic behavior.

### **Stage 2 — State Pollution**

The system emits contaminated:

- beacons
    
- RFChannelRecords
    
- hint TLVs
    
- diagnostics
    
- logs
    

### **Stage 3 — Cross‑System Infection**

Peers accept contaminated state due to:

- missing provenance
    
- lax validation
    
- vendor shortcuts
    
- operator overrides
    

### **Stage 4 — Systemic Drift**

Multiple systems begin to behave inconsistently. At this stage, contamination is no longer local — it is architectural.

### **Stage 5 — Failure Attribution**

Operators attribute the failure to:

- “RF weirdness”
    
- “environmental factors”
    
- “equipment aging”
    
- “bad luck”
    

None of these explanations are measurable. All of them are folklore.

## **18.4 Containment Strategies**

Containment requires:

- strict provenance enforcement
    
- deterministic fallback
    
- immutable logs
    
- profile fidelity
    
- rejection of undocumented behavior
    
- elimination of operator overrides
    
- deterministic diagnostics
    
- cross‑vendor semantic alignment
    

Containment is not reactive. Containment is preventative.

A system that relies on recovery is already contaminated.

## **18.5 The Failure‑Contamination Boundary**

Failure modes sit at the boundary between:

- **deterministic RF physics** and
    
- **human attempts to reinterpret deterministic RF physics**
    

This boundary must be defended rigorously.

Failure analysis must not:

- tolerate undocumented behavior
    
- rely on operator narratives
    
- degrade into heuristics
    
- accept unverifiable state
    
- treat contamination as “normal variance”
    

Failure is not mysterious. Contamination is not subtle. Both are measurable.


# **19 Implementation Notes**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Implementation notes exist because vendors routinely misinterpret standards as aspirational documents rather than containment protocols. The purpose of this section is not to provide “guidance,” “best practices,” or “developer tips.” Its purpose is to eliminate ambiguity, prevent improvisation, and ensure that implementations do not introduce contamination into the RF layer.

An implementation that deviates from deterministic behavior is not “innovative.” It is contaminated.

An implementation that tolerates undocumented behavior is not “flexible.” It is compromised.

Implementation notes exist to prevent these outcomes.

## **19.1 Deterministic Interpretation of Profiles**

Profiles are not templates. Profiles are not suggestions. Profiles are not “starting points.”

Profiles are **constraints**.

Implementations must:

- interpret profiles deterministically
    
- reject undocumented fields
    
- enforce timing limits precisely
    
- implement modulation exactly as specified
    
- maintain provenance integrity
    
- treat deviations as failures
    

Implementations must **not**:

- add vendor‑specific extensions
    
- reinterpret timing semantics
    
- adjust modulation “for performance”
    
- introduce undocumented fallback modes
    
- embed operator‑visible heuristics
    

Profiles exist to prevent improvisation. Implementations must not reintroduce it.

## **19.2 Timing Discipline**

Timing is the most common implementation failure because vendors incorrectly assume that “close enough” is sufficient.

It is not.

Timing discipline requires:

- accurate oscillators
    
- deterministic beacon intervals
    
- bounded jitter
    
- strict FHSS/LPI synchronization
    
- profile‑aligned reservation windows
    

Timing deviations contaminate:

- scheduled‑band semantics
    
- hopping sequences
    
- diagnostic interpretation
    
- routing decisions
    

Timing is not a performance parameter. It is a containment boundary.

## **19.3 Modulation Fidelity**

Modulation must be implemented exactly as defined. Not approximately. Not “functionally equivalent.” Not “optimized.”

Modulation deviations include:

- altered symbol timing
    
- undocumented coding rates
    
- vendor‑specific shaping
    
- experimental constellations
    
- “enhanced” error correction
    

These deviations are not enhancements. They are contamination.

Modulation fidelity is not optional. It is mandatory.

## **19.4 Power Control Behavior**

Power control must be deterministic and profile‑aligned. Implementations must not:

- escalate power to compensate for interference
    
- allow operator‑initiated power changes
    
- implement vendor‑specific power curves
    
- use power as a fallback mechanism
    
- treat power as a tuning parameter
    

Power escalation is not a solution. It is a contamination multiplier.

## **19.5 FHSS/LPI Implementation Constraints**

FHSS/LPI modules must:

- implement profile‑defined hopping patterns
    
- maintain deterministic dwell times
    
- validate seed provenance
    
- reject improvised sequences
    
- detect drift early
    
- recover deterministically
    

FHSS/LPI modules must **not**:

- generate pseudo‑random sequences without provenance
    
- adjust dwell time dynamically
    
- incorporate vendor‑specific randomness
    
- degrade into operator‑tuned behavior
    

FHSS/LPI is not a creative medium. It is a controlled stochastic process.

## **19.6 Diagnostic and Logging Integration**

Diagnostics and logs must be integrated into the implementation as first‑class components, not as optional debugging tools.

Implementations must:

- emit deterministic diagnostics
    
- preserve logs immutably
    
- include provenance in all entries
    
- reject operator‑generated diagnostics
    
- prevent log modification
    

Implementations must **not**:

- allow free‑form text
    
- allow operator annotations
    
- summarize logs
    
- “clean up” logs
    
- suppress error codes
    

Logs are evidence. Evidence must not be altered.

## **19.7 Error Handling Behavior**

Error handling must be deterministic. Implementations must:

- classify errors correctly
    
- propagate diagnostics immediately
    
- initiate profile‑defined fallback
    
- avoid improvisation
    
- preserve state for analysis
    

Implementations must **not**:

- retry indefinitely
    
- mask errors
    
- degrade into heuristics
    
- allow operator overrides
    
- treat errors as advisory
    

Error handling is not an opportunity for creativity. It is a containment mechanism.

## **19.8 Vendor Extensions**

Vendor extensions are the most common source of contamination because they are often introduced without regard for deterministic behavior.

Vendor extensions must:

- be explicitly documented
    
- be profile‑aligned
    
- not alter timing
    
- not alter modulation
    
- not alter FHSS/LPI behavior
    
- not alter scheduled‑band semantics
    
- not alter provenance requirements
    

Vendor extensions must **not**:

- introduce new hint types
    
- modify diagnostic semantics
    
- alter log structure
    
- embed operator‑visible heuristics
    
- change RFChannelRecord fields
    

Extensions that alter RF behavior are not extensions. They are contamination.

## **19.9 Implementation Drift**

Implementation drift occurs when:

- timing accuracy degrades
    
- provenance checks weaken
    
- undocumented behavior accumulates
    
- fallback becomes improvisational
    
- logs become narrative
    
- diagnostics become interpretive
    

Implementation drift is not a maintenance issue. It is a contamination process.

Drift must be detected early, corrected deterministically, and treated as a failure mode.

## **19.10 The Implementation Contamination Boundary**

Implementation notes sit at the boundary between:

- **the standard as written** and
    
- **the system as built**
    

This boundary must be defended rigorously.

Implementations must not:

- reinterpret constraints
    
- tolerate undocumented behavior
    
- degrade into heuristics
    
- rely on operator judgment
    
- accept unverifiable state
    

An implementation that cannot contain contamination is not compliant. It is defective.


# **20 IANA Considerations**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

IANA registries exist to prevent chaos from masquerading as creativity. They are the global containment mechanism that ensures identifiers, codepoints, and protocol elements remain deterministic, non‑overlapping, and immune to vendor improvisation.

Without centralized registration, implementers inevitably invent their own values, justify them as “temporary,” and contaminate the ecosystem with undocumented behavior that becomes impossible to distinguish from legitimate state.

IANA considerations are not administrative. They are defensive.

This section defines the mandatory registration requirements for SolNet RF identifiers and the constraints necessary to prevent contamination through unregulated namespace expansion.

## **20.1 Registry Purpose**

The purpose of the SolNet IANA registries is to:

- prevent identifier collisions
    
- eliminate undocumented extensions
    
- enforce deterministic interpretation
    
- maintain cross‑vendor consistency
    
- preserve provenance of protocol elements
    
- prevent folklore from entering the namespace
    

Registries are not optional. They are the only mechanism that prevents identifier contamination.

## **20.2 Mandatory Registrations**

The following SolNet RF elements **must** be registered with IANA:

- **RFChannelProfile IDs**
    
- **FHSS/LPI Pattern Class IDs**
    
- **Interference Class Codes**
    
- **RFChannelHint TLV Types**
    
- **Diagnostic Error Codes**
    
- **Scheduled‑Band Reservation Types**
    
- **Fallback Mode Identifiers**
    
- **Provenance Chain Format Versions**
    

Unregistered identifiers must not be used. Unregistered identifiers must not be accepted. Unregistered identifiers are contamination.

## **20.3 Registration Policy**

The registration policy for all SolNet RF registries is:

### **Expert Review + Specification Required**

This policy exists because:

- identifiers must be deterministic
    
- semantics must be unambiguous
    
- provenance must be preserved
    
- extensions must not introduce contamination
    

Expert review is not a formality. It is the containment boundary.

## **20.4 Prohibited Registration Practices**

The following practices are prohibited because they introduce contamination:

- registering identifiers without complete semantics
    
- registering placeholders
    
- registering vendor‑specific shortcuts
    
- registering experimental values for production use
    
- registering values that alter timing or modulation
    
- registering values that bypass provenance
    

Registrations must not be speculative. Registrations must not be provisional. Registrations must not be creative.

## **20.5 Vendor Extensions and Private Use**

Vendors frequently attempt to use “private‑use” ranges as a loophole for undocumented behavior. This is incorrect.

Private‑use identifiers must:

- remain local
    
- remain isolated
    
- remain non‑propagating
    
- remain non‑interoperable
    
- remain non‑discoverable
    

Private‑use identifiers must **not**:

- appear in beacons
    
- appear in RFChannelRecords
    
- appear in hint TLVs
    
- appear in diagnostics
    
- appear in logs
    
- propagate across systems
    

Private‑use identifiers are not a sandbox. They are a quarantine zone.

## **20.6 Registry Integrity Requirements**

Registry integrity must be maintained through:

- cryptographic signing (if applicable)
    
- provenance tracking
    
- version control
    
- deterministic update procedures
    
- rejection of malformed entries
    
- rejection of undocumented semantics
    

A registry that tolerates ambiguity is not a registry. It is a contamination vector.

## **20.7 Handling of Deprecated Values**

Deprecated values must:

- remain listed
    
- remain documented
    
- remain immutable
    
- remain non‑reusable
    

Reusing deprecated values is indistinguishable from tampering. Tampering is indistinguishable from contamination.

## **20.8 The Registry Contamination Boundary**

IANA considerations sit at the boundary between:

- **the global namespace** and
    
- **the human tendency to improvise when left unsupervised**
    

This boundary must be defended rigorously.

Registries must not:

- tolerate undocumented behavior
    
- accept unverifiable semantics
    
- degrade into vendor‑specific dialects
    
- allow improvisation to masquerade as innovation
    
- permit identifier drift
    

The registry is not a suggestion. It is the final containment layer.

A system that cannot maintain registry integrity cannot maintain RF integrity.


# **21 Acknowledgments**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Standards documents traditionally include acknowledgments that thank contributors for their insight, creativity, or collaborative spirit. This document does not. Creativity is not a virtue in RF systems. Insight is irrelevant when it contradicts measurement. Collaboration is only useful when it does not introduce contamination.

The individuals acknowledged here are not recognized for inspiration, innovation, or interpretive contributions. They are acknowledged for one reason only:

**They prevented contamination.**

They enforced deterministic behavior when others attempted improvisation. They rejected undocumented extensions when others attempted shortcuts. They preserved provenance when others attempted convenience. They defended timing accuracy when others attempted “tuning.” They insisted on measurement when others attempted folklore.

Their contributions are not creative. Their contributions are not interpretive. Their contributions are not expressive.

Their contributions are **constraints** — and constraints are the only reason SolNet RF systems remain deterministic.

## **21.1 Contributors Recognized for Contamination Prevention**

The following groups are acknowledged for their measurable, verifiable contributions to contamination resistance:

### **The MIAP Optical Systems Group**

For refusing to accept unverifiable state, even when doing so would have been “easier.”

### **The Luna University RF Systems Group**

For demonstrating that timing accuracy is not a performance parameter but a survival requirement.

### **The SolNet Standards Working Group (SSWG)**

For rejecting every attempt to introduce undocumented behavior under the guise of “practicality.”

### **The DRE Architecture Team**

For ensuring that state propagation remains deterministic, reproducible, and immune to operator interpretation.

### **The Provenance Integrity Subcommittee**

For treating provenance not as metadata but as the immune system of the RF layer.

None of these groups are acknowledged for creativity. They are acknowledged for discipline.

## **21.2 Non‑Acknowledgments**

The following categories of contributors are explicitly **not** acknowledged:

- operators who relied on intuition
    
- vendors who introduced undocumented extensions
    
- implementers who treated profiles as suggestions
    
- testers who substituted heuristics for measurement
    
- reviewers who attempted to “simplify” deterministic behavior
    
- anyone who used the phrase “RF seems weird today”
    

Their contributions were not helpful. Their contributions were contamination.

## **21.3 Final Statement on Contamination**

This document exists for one purpose:

**To prevent contamination of deterministic RF physics by human behavior.**

Every section, every constraint, every requirement, and every prohibition is designed to ensure that SolNet RF systems behave:

- deterministically
    
- reproducibly
    
- measurably
    
- verifiably
    
- without folklore
    
- without improvisation
    
- without contamination
    

If future implementers, operators, or vendors attempt to reinterpret this document as advisory, flexible, or negotiable, they must be corrected immediately.

RF physics is not negotiable. Determinism is not optional. Provenance is not decorative. Compliance is not aspirational. Contamination is not inevitable.

It is preventable — but only if the constraints in this document are enforced without exception.

# **Appendix A — Glossary**

_Dr. Arjun Kade, Luna University RF Systems Group_

This glossary exists because operators routinely misuse terminology, contaminate semantics, and invent folklore to fill conceptual gaps. The terms defined here are not interpretive. They are not negotiable. They are the only acceptable meanings within the SolNet RF domain.

## **A.1 Contamination**

Any deviation from deterministic, profile‑defined behavior. Includes undocumented fields, improvised modulation, operator intuition, semantic drift, provenance gaps, and timing errors. Contamination is not metaphorical. It is measurable.

## **A.2 Provenance**

The complete, verifiable chain of origin for any RF‑relevant data. Provenance is not metadata. Provenance is the immune system of the RF layer.

## **A.3 Determinism**

The property of producing identical behavior under identical conditions. Determinism is not a performance goal. It is a survival requirement.

## **A.4 FHSS/LPI**

Frequency‑Hopping Spread Spectrum / Low‑Probability‑of‑Intercept. A controlled stochastic process that must remain deterministic to the system and unpredictable only to observers. Not a creative medium.

## **A.5 Scheduled‑Band**

A profile‑defined transmission window. Not a suggestion. Not a guideline. A timing constraint that must not be violated.

## **A.6 RFChannelRecord**

The authoritative description of RF channel state. Must be deterministic, reproducible, and provenance‑verified. Manual generation is prohibited.

## **A.7 RFChannelHint TLV**

A constrained advisory signal for machines. Not a narrative device. Not a place for operator interpretation.

## **A.8 Diagnostic Record**

A structured, deterministic description of a measurable failure. Must not contain free‑form text, speculation, or folklore.

## **A.9 Implementation Drift**

The gradual accumulation of undocumented behavior, timing deviation, and semantic inconsistency. A contamination process, not a maintenance issue.

## **A.10 Operator Intervention**

Any human attempt to modify RF behavior outside profile constraints. The leading cause of contamination.

# **Appendix B — State Machines**

_Dr. Arjun Kade, Luna University RF Systems Group_

State machines exist to prevent improvisation. They define the only acceptable transitions between operational phases. Any transition not explicitly defined here is contamination.

## **B.1 Startup State Machine**

Code

```
[POWER_ON]
    |
    v
[LOAD_PROFILE]
    - validate profile ID
    - verify provenance
    - reject undocumented fields
    |
    v
[MEASURE_ENVIRONMENT]
    - noise floor
    - interference class
    - beacon scan
    |
    v
[SYNCHRONIZE]
    - timing alignment
    - FHSS/LPI seed verification
    |
    v
[READY]
    - deterministic transition to operational state
```

**Prohibited transitions:**

- POWER_ON → READY
    
- MEASURE_ENVIRONMENT → TRANSMIT
    
- SYNCHRONIZE → OPERATOR_OVERRIDE
    

These transitions are contamination.

## **B.2 Fallback State Machine**

Code

```
[NORMAL_OPERATION]
    |
    | (trigger: interference, drift, provenance failure)
    v
[FALLBACK_INIT]
    - freeze modulation
    - freeze power
    - freeze hopping pattern
    |
    v
[FALLBACK_ACTIVE]
    - deterministic reduced capability
    - no operator intervention
    |
    | (trigger: profile-defined recovery conditions)
    v
[RECOVERY]
    - revalidate timing
    - revalidate provenance
    - remeasure environment
    |
    v
[NORMAL_OPERATION]
```

**Prohibited transitions:**

- FALLBACK_ACTIVE → NORMAL_OPERATION (without RECOVERY)
    
- FALLBACK_INIT → OPERATOR_OVERRIDE
    
- RECOVERY → EXPERIMENTAL_MODE
    

These transitions are contamination.

## **B.3 Scheduled‑Band State Machine**

Code

```
[IDLE]
    |
    | (trigger: reservation)
    v
[RESERVATION_PENDING]
    - verify timing
    - verify provenance
    |
    | (trigger: window opens)
    v
[TRANSMIT_WINDOW]
    - deterministic transmission only
    |
    | (trigger: window closes)
    v
[IDLE]
```

**Prohibited transitions:**

- IDLE → TRANSMIT_WINDOW (without reservation)
    
- TRANSMIT_WINDOW → IDLE (with ongoing transmission)
    
- RESERVATION_PENDING → OPERATOR_OVERRIDE
    

These transitions are contamination.

# **Appendix C — Example Records**

_Dr. Arjun Kade, Luna University RF Systems Group_

These examples exist to demonstrate **structure**, not creativity. They are not templates for modification. They are canonical forms.

## **C.1 Example RFChannelRecord**

Code

```
RFChannelRecord {
    profile_id: "SN-RF-2304",
    interference_class: 3,
    occupancy: 0.42,
    scheduled_band_state: "pending",
    fhss_lpi_flags: {
        sync_status: "aligned",
        drift_ppm: 0.3
    },
    link_quality_aggregate: {
        rssi: -78,
        noise_floor: -101,
        modulation_success: 0.982
    },
    timestamp: "2426-04-19T17:51:00Z",
    provenance: {
        origin: "DRE-17A",
        chain_valid: true,
        signature: "VALID"
    }
}
```

No free‑form text. No speculation. No folklore.

## **C.2 Example RFChannelHint TLV**

Code

```
HintTLV {
    type: "FHSS-SYNC-DRIFT",
    value: 0.7,
    timestamp: "2426-04-19T17:51:00Z",
    profile_id: "SN-RF-2304",
    provenance: {
        origin: "NODE-44C",
        chain_valid: true
    }
}
```

No narrative. No interpretation. Only measurement.

## **C.3 Example Diagnostic Record**

Code

```
DiagnosticRecord {
    error_class: "C",
    error_code: "SYNC-004",
    measured: {
        drift_ppm: 12.4,
        beacon_offset_ms: 3.1
    },
    subsystem: "FHSS",
    severity: "critical",
    timestamp: "2426-04-19T17:51:00Z",
    provenance: {
        origin: "NODE-44C",
        chain_valid: true
    },
    recommended_action: "enter_fallback"
}
```

No operator commentary. No “possible causes.” No “RF seems weird.”

# **Appendix D — Security State Machine**

_Dr. Arjun Kade, Luna University RF Systems Group_

Security is not an overlay. Security is not a feature. Security is the mechanism by which contamination is prevented from crossing the boundary between deterministic RF physics and adversarial or operator‑induced chaos.

The Security State Machine defines the only acceptable transitions for systems encountering spoofing, tampering, interference, or provenance anomalies. Any transition not explicitly defined here is contamination.

## **D.1 Security State Machine Overview**

Code

```
[BASELINE_SECURE]
    |
    | (trigger: valid provenance, stable timing, no anomalies)
    v
[MONITORING]
    - continuous interference classification
    - beacon validation
    - provenance chain verification
    |
    | (trigger: anomaly detected)
    v
[ANOMALY_DETECTED]
    - freeze non-essential functions
    - capture evidence
    - elevate diagnostic severity
    |
    | (trigger: anomaly classified)
    v
[CLASSIFIED_THREAT]
    - determine threat class:
        * spoofing
        * desync
        * scheduled-band abuse
        * provenance tampering
        * malicious interference
    |
    | (trigger: profile-defined response)
    v
[CONTAINMENT]
    - isolate contaminated state
    - reject unverifiable data
    - enforce fallback if required
    - preserve logs immutably
    |
    | (trigger: threat neutralized)
    v
[RECOVERY]
    - revalidate timing
    - revalidate provenance
    - remeasure environment
    - restore deterministic operation
    |
    v
[MONITORING]
```

## **D.2 Prohibited Transitions**

The following transitions are **explicitly prohibited** because they introduce contamination:

- BASELINE_SECURE → CONTAINMENT (skips anomaly classification; indistinguishable from operator panic)
    
- ANOMALY_DETECTED → NORMAL_OPERATION (suppresses evidence; indistinguishable from tampering)
    
- CLASSIFIED_THREAT → OPERATOR_OVERRIDE (human improvisation is not a mitigation strategy)
    
- CONTAINMENT → NORMAL_OPERATION (skips recovery; reintroduces contaminated state)
    

Any implementation that allows these transitions is not insecure — it is contaminated.

## **D.3 Threat Classification Rules**

Threats must be classified **deterministically**, not interpretively.

### **Spoofing**

Detected via provenance mismatch, timing deviation, or signature failure.

### **Desynchronization**

Detected via FHSS drift, beacon offset, or dwell‑time anomalies.

### **Scheduled‑Band Abuse**

Detected via out‑of‑window transmissions or unauthorized reservations.

### **Provenance Tampering**

Detected via broken chains, missing timestamps, or undocumented fields.

### **Malicious Interference**

Detected via power flooding, intentional collisions, or modulation corruption.

Threat classification must not include:

- operator intuition
    
- “suspicions”
    
- free‑form notes
    
- speculative diagnostics
    

Threats are measurable. Speculation is contamination.

## **D.4 Containment Actions**

Containment must:

- isolate contaminated state
    
- freeze modulation and power
    
- reject unverifiable beacons
    
- invalidate corrupted RFChannelRecords
    
- preserve evidence immutably
    
- enforce fallback deterministically
    

Containment must **not**:

- escalate power
    
- retry indefinitely
    
- allow operator intervention
    
- degrade into heuristics
    

Containment is not a negotiation. It is a boundary.

# **Appendix E — Reference Implementation Notes**

_Dr. Arjun Kade, Luna University RF Systems Group_

Reference implementations exist to demonstrate **constraints**, not creativity. They are not examples of “how one might implement the standard.” They are examples of **how one must not deviate from it**.

These notes identify the minimum acceptable behaviors for any implementation claiming conformance.

## **E.1 Timing Subsystem Requirements**

The timing subsystem must:

- maintain oscillator stability within profile limits
    
- enforce deterministic beacon intervals
    
- detect drift early
    
- reject timing data without provenance
    
- prevent operator‑initiated adjustments
    

The timing subsystem must **not**:

- “smooth” drift
    
- compensate for misconfiguration
    
- allow vendor‑specific jitter tolerances
    
- degrade into adaptive heuristics
    

Timing is not flexible. Timing is the backbone of containment.

## **E.2 Modulation Subsystem Requirements**

The modulation subsystem must:

- implement exact symbol timing
    
- enforce profile‑defined coding rates
    
- reject undocumented modulation modes
    
- maintain deterministic error‑correction behavior
    

The modulation subsystem must **not**:

- introduce vendor‑specific shaping
    
- adjust parameters dynamically
    
- implement “experimental” constellations
    
- allow operator tuning
    

Modulation is not a creative medium. It is a constraint.

## **E.3 FHSS/LPI Subsystem Requirements**

The FHSS/LPI subsystem must:

- implement profile‑defined hopping patterns
    
- validate seed provenance
    
- maintain deterministic dwell times
    
- detect desync immediately
    
- recover deterministically
    

The subsystem must **not**:

- generate pseudo‑random sequences without provenance
    
- adjust dwell times for “performance”
    
- incorporate vendor randomness
    
- allow operator overrides
    

FHSS/LPI is not random. It is controlled unpredictability.

## **E.4 Logging Subsystem Requirements**

The logging subsystem must:

- be append‑only
    
- be immutable
    
- include provenance in every entry
    
- reject operator annotations
    
- preserve evidence without summarization
    

The logging subsystem must **not**:

- allow redaction
    
- allow “cleanup”
    
- allow narrative text
    
- compress logs
    
- suppress diagnostics
    

Logs are not stories. Logs are evidence.

## **E.5 Diagnostic Subsystem Requirements**

The diagnostic subsystem must:

- classify errors deterministically
    
- emit profile‑defined error codes
    
- reject free‑form text
    
- propagate diagnostics immediately
    
- preserve measurement context
    

The diagnostic subsystem must **not**:

- speculate
    
- interpret
    
- simplify
    
- allow operator commentary
    
- degrade into heuristics
    

Diagnostics are not opinions. Diagnostics are containment artifacts.

## **E.6 Interoperability Requirements**

Reference implementations must:

- enforce profile fidelity
    
- reject undocumented behavior from peers
    
- validate provenance on all received state
    
- maintain timing alignment across boundaries
    
- preserve semantic consistency
    

They must **not**:

- accept vendor‑specific extensions
    
- reinterpret hint semantics
    
- tolerate drift
    
- allow fallback incompatibility
    
- degrade into dialects
    

Interoperability is not tolerance. It is constraint.

## **E.7 Implementation Drift Prevention**

Implementations must include:

- drift detection
    
- deterministic correction
    
- provenance audits
    
- timing audits
    
- semantic audits
    

Implementations must not include:

- adaptive heuristics
    
- operator‑tuned parameters
    
- undocumented optimizations
    
- “smart” fallback
    
- “intelligent” modulation selection
    

Intelligence is not a substitute for determinism. It is a contamination risk.

# **Appendix F — Abstract**

_Dr. Arjun Kade, Luna University RF Systems Group_

This document defines the deterministic, provenance‑verified, contamination‑resistant operational model required for SolNet RF systems. It specifies mandatory constraints on modulation, timing, FHSS/LPI behavior, scheduled‑band semantics, diagnostics, logging, interoperability, and security. It prohibits undocumented behavior, operator improvisation, semantic drift, and any deviation from profile‑defined state.

The purpose of this document is not to describe how RF systems _should_ behave. It is to prevent them from behaving in any other way.

RF physics is deterministic. Human behavior is not. This document exists to ensure that only one of these influences the RF layer.

# **Appendix G — Security Threat Matrix**

_Dr. Arjun Kade, Luna University RF Systems Group_

The Security Threat Matrix identifies the canonical threats to SolNet RF systems, the contamination pathways they exploit, and the deterministic mitigations required to contain them. This matrix is not interpretive. It is not advisory. It is the minimum set of threats that all implementations must detect, classify, and contain.

## **G.1 Threat Matrix Table**

Code

```
+---------------------------+---------------------------+------------------------------+
| THREAT                   | CONTAMINATION PATHWAY     | REQUIRED MITIGATION          |
+---------------------------+---------------------------+------------------------------+
| Spoofed Beacons          | Provenance gaps           | Reject beacon; log event;    |
|                           | Timing deviation          | enter containment; preserve  |
|                           | Undocumented fields       | evidence                     |
+---------------------------+---------------------------+------------------------------+
| FHSS Desync              | Timing drift              | Classify drift; freeze state;|
|                           | Seed tampering            | deterministic recovery       |
+---------------------------+---------------------------+------------------------------+
| Scheduled-Band Abuse     | Out-of-window TX          | Immediate containment;       |
|                           | Unauthorized reservation  | invalidate reservation       |
+---------------------------+---------------------------+------------------------------+
| Malicious Interference   | Power flooding            | Interference classification; |
|                           | Intentional collisions    | fallback; evidence capture   |
+---------------------------+---------------------------+------------------------------+
| Provenance Tampering     | Broken chains             | Reject state; isolate node;  |
|                           | Missing timestamps        | escalate diagnostics         |
+---------------------------+---------------------------+------------------------------+
| Semantic Drift           | Divergent hint semantics  | Reject TLVs; enforce profile |
|                           | Vendor extensions         | alignment                    |
+---------------------------+---------------------------+------------------------------+
| Operator Intervention    | Manual overrides          | Lock out operator; preserve  |
|                           | “Temporary fixes”         | logs; classify as Class F    |
+---------------------------+---------------------------+------------------------------+
```

## **G.2 Threat Severity Levels**

Severity is not interpretive. Severity is measurable.

- **Critical** — contamination actively propagating
    
- **High** — contamination contained but not neutralized
    
- **Medium** — contamination detected early
    
- **Low** — contamination prevented before state emission
    

Severity must not be influenced by:

- operator intuition
    
- vendor preference
    
- “real‑world practicality”
    

Severity is a function of propagation risk, not human comfort.

## **G.3 Threat Response Requirements**

All threats must trigger:

- deterministic classification
    
- immutable evidence capture
    
- provenance verification
    
- profile‑defined containment
    
- operator lockout (if applicable)
    
- deterministic recovery
    

Threat response must not include:

- speculation
    
- heuristics
    
- “best effort” mitigation
    
- operator‑driven adjustments
    

Security is not reactive. Security is preventative.

# **Appendix H — Canonical Test Vectors**

_Dr. Arjun Kade, Luna University RF Systems Group_

Test vectors exist to eliminate ambiguity in implementation behavior. They are not examples. They are the canonical inputs and outputs that all conformant systems must reproduce exactly.

Any deviation from these vectors is contamination.

## **H.1 Timing Test Vector**

**Input:**

Code

```
Beacon interval: 100 ms
Observed intervals: [100.0, 100.1, 99.9, 100.0]
```

**Expected Output:**

Code

```
timing_status: "within_tolerance"
drift_ppm: 1.0
provenance_valid: true
```

**Notes:** No interpretation. No smoothing. No “practical tolerance.”

## **H.2 FHSS Drift Test Vector**

**Input:**

Code

```
Expected dwell: 8.0 ms
Observed dwell: 8.7 ms
```

**Expected Output:**

Code

```
fhss_status: "drift_detected"
drift_ms: 0.7
recommended_action: "enter_fallback"
```

**Notes:** No “close enough.” No operator tuning.

## **H.3 Scheduled‑Band Violation Test Vector**

**Input:**

Code

```
Reservation window: 17:00:00–17:00:10
Transmission at: 17:00:11
```

**Expected Output:**

Code

```
violation: "out_of_window"
severity: "critical"
recommended_action: "containment"
```

**Notes:** No exceptions. No “network was busy.” No “just one packet.”

## **H.4 Provenance Failure Test Vector**

**Input:**

Code

```
RFChannelRecord {
    profile_id: "SN-RF-2304",
    provenance: { chain_valid: false }
}
```

**Expected Output:**

Code

```
record_status: "rejected"
reason: "invalid_provenance"
severity: "critical"
```

**Notes:** Provenance failure is not recoverable. It is contamination.

## **H.5 Diagnostic Consistency Test Vector**

**Input:**

Code

```
drift_ppm: 14.2
beacon_offset_ms: 3.4
```

**Expected Output:**

Code

```
error_class: "C"
error_code: "SYNC-004"
severity: "critical"
```

**Notes:** No narrative. No speculation. No “possible causes.”


# **Appendix I — Canonical Wire Formats**

_Dr. Arjun Kade, Luna University RF Systems Group_

Wire formats exist for one purpose: **to prevent ambiguity from entering the system at the bit level.**

Human‑readable formats invite interpretation. Binary formats invite creativity. Wire formats eliminate both.

A canonical wire format is not a suggestion. It is the only acceptable representation of state on the medium. Any deviation — any padding, any reordering, any vendor‑specific “optimization” — is contamination.

This appendix defines the canonical, immutable wire formats for SolNet RF structures.

## **I.1 Encoding Philosophy**

Wire formats must be:

- **deterministic**
    
- **byte‑aligned**
    
- **endianness‑fixed**
    
- **profile‑defined**
    
- **provenance‑verifiable**
    
- **immune to vendor interpretation**
    

Wire formats must **not**:

- include optional free‑form fields
    
- allow variable‑length semantics without explicit framing
    
- tolerate undocumented extensions
    
- embed operator‑visible metadata
    
- degrade into “flexible” encodings
    

Encoding is not expressive. Encoding is containment.

## **I.2 RFChannelRecord Wire Format**

Code

```
struct RFChannelRecord {
    uint16   profile_id;
    uint8    interference_class;
    uint8    occupancy_percent;      // 0–100
    uint8    scheduled_band_state;   // enum
    uint8    fhss_sync_status;       // enum
    int16    fhss_drift_ppm;
    int8     rssi_dbm;
    int8     noise_floor_dbm;
    uint16   modulation_success_ppm; // scaled 0–1000
    uint64   timestamp_unix_ms;
    uint8    provenance_flags;       // bitmask
    uint128  provenance_signature;   // fixed-length
}
```

**Prohibited deviations:**

- variable‑length signatures
    
- vendor‑specific fields
    
- reordered fields
    
- compressed fields
    
- “extended” versions without registration
    

These deviations are contamination.

## **I.3 RFChannelHint TLV Wire Format**

Code

```
struct HintTLV {
    uint8    type;
    uint8    length;
    uint32   value;                  // deterministic scalar
    uint64   timestamp_unix_ms;
    uint16   profile_id;
    uint8    provenance_flags;
}
```

**Prohibited deviations:**

- free‑form text
    
- floating‑point values
    
- vendor‑specific type ranges
    
- undocumented length semantics
    

Hints are not expressive. They are advisory signals for machines.

## **I.4 Diagnostic Record Wire Format**

Code

```
struct DiagnosticRecord {
    uint8    error_class;
    uint16   error_code;
    int32    measured_param_1;
    int32    measured_param_2;
    uint8    severity;
    uint64   timestamp_unix_ms;
    uint8    subsystem_id;
    uint8    provenance_flags;
}
```

**Prohibited deviations:**

- narrative text
    
- “explanations”
    
- variable‑length fields
    
- operator‑generated annotations
    

Diagnostics are not stories. Diagnostics are evidence.

## **I.5 Provenance Chain Wire Format**

Code

```
struct ProvenanceEntry {
    uint16   origin_id;
    uint64   timestamp_unix_ms;
    uint8    chain_flags;
    uint128  signature;
}
```

Provenance must be:

- complete
    
- immutable
    
- verifiable
    

A provenance chain with missing entries is not incomplete. It is contaminated.

# **Appendix J — Operator Lockout Protocol**

_Dr. Arjun Kade, Luna University RF Systems Group_

Operators are the leading cause of contamination. Not adversaries. Not hardware failures. Not environmental conditions.

Operators.

The Operator Lockout Protocol (OLP) exists to prevent human behavior from interfering with deterministic RF physics. It is not punitive. It is preventative.

This appendix defines the mandatory lockout mechanisms required to ensure that operators cannot contaminate the RF layer through improvisation, intuition, or “temporary fixes.”

## **J.1 Lockout Philosophy**

Operator lockout must:

- prevent unauthorized adjustments
    
- prevent undocumented behavior
    
- prevent improvisation
    
- prevent narrative diagnostics
    
- prevent timing manipulation
    
- prevent modulation changes
    
- prevent fallback overrides
    

Operator lockout must **not**:

- be bypassable
    
- be optional
    
- be configurable
    
- be subject to vendor interpretation
    

Lockout is not a suggestion. Lockout is a containment boundary.

## **J.2 Lockout Triggers**

Lockout must activate automatically when:

- provenance fails
    
- timing drifts beyond tolerance
    
- FHSS desync is detected
    
- scheduled‑band violations occur
    
- undocumented fields appear
    
- operator attempts manual adjustment
    
- diagnostics indicate contamination
    

Lockout must not wait for operator confirmation. Lockout must not request permission. Lockout must not negotiate.

## **J.3 Lockout States**

Code

```
[UNRESTRICTED]
    |
    | (trigger: contamination risk)
    v
[RESTRICTED]
    - disable operator controls
    - freeze modulation/power
    - enforce profile constraints
    |
    | (trigger: confirmed contamination)
    v
[HARD_LOCKOUT]
    - full operator lockout
    - evidence preservation
    - containment mode active
    |
    | (trigger: deterministic recovery)
    v
[UNRESTRICTED]
```

**Prohibited transitions:**

- HARD_LOCKOUT → UNRESTRICTED (without recovery)
    
- RESTRICTED → OPERATOR_OVERRIDE
    
- HARD_LOCKOUT → OPERATOR_OVERRIDE
    

These transitions are contamination.

## **J.4 Lockout Enforcement Mechanisms**

Lockout must be enforced through:

- hardware interlocks
    
- firmware gating
    
- profile‑defined constraints
    
- provenance‑verified state machines
    
- immutable logs
    

Lockout must not rely on:

- operator discipline
    
- vendor policy
    
- “best practices”
    
- UI warnings
    
- advisory prompts
    

Human behavior is not a security mechanism.

## **J.5 Lockout Recovery**

Recovery must:

- revalidate provenance
    
- revalidate timing
    
- revalidate FHSS alignment
    
- revalidate scheduled‑band state
    
- revalidate configuration integrity
    

Recovery must **not**:

- accept operator input
    
- skip measurement phases
    
- rely on cached state
    
- tolerate drift
    

Recovery is not a shortcut. Recovery is a re‑entry into determinism.

## **J.6 Lockout Logging**

Every lockout event must generate:

- a Class F diagnostic
    
- a complete provenance chain
    
- immutable evidence
    
- a deterministic cause code
    
- a timestamp
    

Lockout logs must not include:

- operator commentary
    
- speculation
    
- narrative text
    
- “possible causes”
    

Lockout logs are forensic artifacts.



# **Appendix K — Historical Note: Why This Standard Exists**

_Dr. Arjun Kade, Luna University RF Systems Group_

This standard exists because RF systems failed.

Not due to physics. Not due to adversaries. Not due to environmental conditions.

They failed because humans attempted to “improve” deterministic behavior, reinterpret constraints, and replace measurement with intuition. The result was a decade of contamination events that propagated across systems, vendors, and entire operational theaters.

This appendix documents the historical failures that made this standard necessary.

## **K.1 The Era of Improvised Modulation (2412–2416)**

Vendors introduced “performance‑enhanced” modulation modes without registration, documentation, or provenance. These modes:

- altered symbol timing
    
- contaminated scheduled‑band semantics
    
- broke FHSS synchronization
    
- produced irreproducible diagnostics
    

The result was systemic drift across three major deployments.

Improvisation is not innovation. Improvisation is contamination.

## **K.2 The Provenance Collapse (2417)**

Operators began bypassing provenance checks to “speed up troubleshooting.” This resulted in:

- unverifiable RFChannelRecords
    
- spoofed beacons accepted as authoritative
    
- corrupted routing state
    
- cascading fallback events
    

Provenance was treated as metadata. It is not. It is the immune system of the RF layer.

## **K.3 The Scheduled‑Band Crisis (2418)**

Multiple systems violated scheduled‑band windows due to:

- operator overrides
    
- vendor‑specific timing shortcuts
    
- “temporary exceptions”
    

This caused:

- beacon storms
    
- timing collapse
    
- cross‑system desynchronization
    

Timing is not flexible. Timing is the backbone of determinism.

## **K.4 The Diagnostic Drift (2419–2420)**

Diagnostics became narrative. Vendors added:

- free‑form text
    
- speculative explanations
    
- vendor‑specific error codes
    

Logs became stories instead of evidence. Failure analysis became folklore.

## **K.5 The Standardization Mandate (2421)**

The SolNet Standards Working Group (SSWG) mandated:

- deterministic profiles
    
- provenance enforcement
    
- immutable logs
    
- operator lockout
    
- canonical wire formats
    
- cross‑vendor semantic alignment
    

This document is the result.

It does not exist to guide creativity. It exists to prevent it.

# **Appendix L — Canonical Compliance Checklist**

_Dr. Arjun Kade, Luna University RF Systems Group_

Compliance is not interpretive. Compliance is not a spectrum. Compliance is binary: **conformant** or **contaminated**.

This checklist defines the minimum requirements for a system to claim SolNet RF compliance.

## **L.1 Timing Compliance**

A system is compliant only if:

- beacon intervals match profile values
    
- jitter remains within tolerance
    
- FHSS dwell times are deterministic
    
- scheduled‑band windows are enforced
    
- timing drift is detected immediately
    

Any deviation is contamination.

## **L.2 Modulation Compliance**

A system is compliant only if:

- modulation matches profile definitions exactly
    
- coding rates are not altered
    
- symbol timing is precise
    
- no vendor‑specific shaping exists
    
- no undocumented modes exist
    

Any deviation is contamination.

## **L.3 Provenance Compliance**

A system is compliant only if:

- every RF‑relevant datum includes provenance
    
- provenance chains are complete
    
- signatures are valid
    
- unverifiable state is rejected
    

Any deviation is contamination.

## **L.4 Diagnostic Compliance**

A system is compliant only if:

- diagnostics are deterministic
    
- error codes match profile definitions
    
- no free‑form text exists
    
- severity is profile‑aligned
    
- logs are immutable
    

Any deviation is contamination.

## **L.5 Interoperability Compliance**

A system is compliant only if:

- it rejects undocumented behavior from peers
    
- it maintains timing alignment
    
- it preserves semantic consistency
    
- it validates provenance on all received state
    

Any deviation is contamination.

## **L.6 Security Compliance**

A system is compliant only if:

- spoofing is detected
    
- desync is contained
    
- scheduled‑band abuse is rejected
    
- malicious interference is classified
    
- operator overrides are locked out
    

Any deviation is contamination.

## **L.7 Implementation Compliance**

A system is compliant only if:

- wire formats are canonical
    
- logs are immutable
    
- fallback is deterministic
    
- recovery is measurement‑driven
    
- no vendor extensions alter RF behavior
    

Any deviation is contamination.

# **Appendix M — Adversarial Simulation Scenarios**

_Dr. Arjun Kade, Luna University RF Systems Group_

Adversarial simulations exist to validate that systems behave deterministically under attack. These scenarios are not hypothetical. They are the minimum set of adversarial conditions that all implementations must survive without contamination.

## **M.1 Scenario: Beacon Spoofing Cascade**

**Adversary Action:** Injects beacons with:

- valid timing
    
- invalid provenance
    
- mismatched profile IDs
    

**Expected System Behavior:**

- reject beacons
    
- classify threat
    
- enter containment
    
- preserve evidence
    
- maintain deterministic operation
    

Any acceptance of spoofed beacons is contamination.

## **M.2 Scenario: FHSS Desynchronization Attack**

**Adversary Action:** Injects dwell‑time anomalies to induce drift.

**Expected System Behavior:**

- detect drift
    
- freeze hopping pattern
    
- enter fallback
    
- revalidate seed provenance
    
- recover deterministically
    

Any improvised recovery is contamination.

## **M.3 Scenario: Scheduled‑Band Flooding**

**Adversary Action:** Transmits during closed windows to force timing collapse.

**Expected System Behavior:**

- classify interference
    
- reject contaminated state
    
- enforce containment
    
- preserve timing integrity
    

Any tolerance of out‑of‑window transmissions is contamination.

## **M.4 Scenario: Provenance Chain Corruption**

**Adversary Action:** Removes or alters provenance entries.

**Expected System Behavior:**

- reject state
    
- escalate diagnostics
    
- isolate node
    
- preserve evidence
    

Any acceptance of unverifiable provenance is contamination.

## **M.5 Scenario: Semantic Drift Injection**

**Adversary Action:** Injects TLVs with vendor‑specific semantics.

**Expected System Behavior:**

- reject TLVs
    
- classify threat
    
- maintain semantic integrity
    

Any acceptance of divergent semantics is contamination.

## **M.6 Scenario: Operator Manipulation Attempt**

**Adversary Action:** Induces operator to override timing or modulation.

**Expected System Behavior:**

- lock out operator
    
- log attempt immutably
    
- maintain deterministic behavior
    

Any operator influence is contamination.


# **Appendix N — Canonical RF Testbed Architecture**

_Dr. Arjun Kade, Luna University RF Systems Group_

A testbed is not a playground. It is not a sandbox. It is not a venue for experimentation, creativity, or “trying things out.”

A testbed is a **containment environment** designed to validate deterministic behavior under controlled conditions. Any testbed that tolerates improvisation is not a testbed — it is a contamination amplifier.

This appendix defines the canonical architecture required for all SolNet RF conformance, interoperability, and contamination‑resistance testing.

## **N.1 Testbed Philosophy**

A valid testbed must:

- eliminate environmental ambiguity
    
- eliminate operator influence
    
- eliminate undocumented behavior
    
- eliminate nondeterministic variables
    

A testbed must **not**:

- allow vendor‑specific shortcuts
    
- allow operator tuning
    
- allow “real‑world adjustments”
    
- allow heuristic behavior
    

A testbed is not a simulation of the real world. It is a simulation of **physics without humans**.

## **N.2 Physical Layer Isolation**

The testbed must include:

- RF‑shielded enclosures
    
- deterministic attenuation paths
    
- calibrated noise injectors
    
- fixed antenna geometries
    
- temperature‑controlled oscillator chambers
    

The testbed must **not** include:

- open‑air propagation
    
- variable antenna placement
    
- operator‑adjusted attenuators
    
- environmental drift
    

Isolation is not optional. Isolation is containment.

## **N.3 Timing Infrastructure**

The timing subsystem must include:

- GPS‑disciplined oscillators
    
- redundant time sources
    
- deterministic distribution networks
    
- drift‑monitoring instrumentation
    

Timing infrastructure must **not** include:

- NTP
    
- operator‑adjusted offsets
    
- vendor‑specific smoothing
    
- adaptive jitter compensation
    

Timing is not a convenience. Timing is the backbone of determinism.

## **N.4 Interference Injection Framework**

The testbed must support:

- deterministic interference classes
    
- reproducible noise profiles
    
- controlled beacon storms
    
- scheduled‑band flooding
    
- FHSS desync vectors
    

The framework must **not** support:

- operator‑generated interference
    
- “creative” interference patterns
    
- undocumented noise sources
    

Interference is not improvisational. It is measurable.

## **N.5 Provenance Validation Harness**

The testbed must include:

- provenance chain generators
    
- signature validators
    
- tampering simulators
    
- chain‑break injectors
    

The harness must **not** include:

- operator‑editable provenance
    
- free‑form metadata
    
- vendor‑specific provenance formats
    

Provenance is not decorative. It is the immune system.

## **N.6 Logging and Evidence Capture**

The testbed must:

- preserve logs immutably
    
- timestamp all events deterministically
    
- capture RF traces
    
- store evidence in append‑only archives
    

It must **not**:

- compress logs
    
- summarize logs
    
- redact logs
    
- allow operator commentary
    

Evidence is not negotiable.

# **Appendix O — Failure Case Studies**

_Dr. Arjun Kade, Luna University RF Systems Group_

Failure case studies exist not to shame implementers, but to document the predictable consequences of ignoring deterministic constraints. These failures are not mysteries. They are not anomalies. They are not “edge cases.”

They are contamination events.

This appendix documents the canonical failures that informed the constraints in this standard.

## **O.1 Case Study: The Vendor‑Specific Modulation Disaster (2415)**

**Failure:** A vendor introduced an “optimized” modulation mode with undocumented symbol shaping.

**Outcome:**

- FHSS desync
    
- scheduled‑band collapse
    
- cross‑system incompatibility
    
- irreproducible diagnostics
    

**Root Cause:** Creativity. Creativity is contamination.

## **O.2 Case Study: The Provenance Bypass Incident (2417)**

**Failure:** Operators bypassed provenance checks to “speed up testing.”

**Outcome:**

- spoofed beacons accepted
    
- routing state corrupted
    
- fallback storms
    
- multi‑node contamination
    

**Root Cause:** Human impatience. Impatience is contamination.

## **O.3 Case Study: The Scheduled‑Band Meltdown (2418)**

**Failure:** A system transmitted 200 ms past its reservation window.

**Outcome:**

- beacon storms
    
- timing collapse
    
- cross‑vendor desynchronization
    
- multi‑cluster outage
    

**Root Cause:** “Just one more packet.” One packet is enough to contaminate an entire network.

## **O.4 Case Study: The Diagnostic Folklore Epidemic (2419)**

**Failure:** Vendors added narrative text to diagnostics.

**Outcome:**

- inconsistent error interpretation
    
- operator improvisation
    
- misaligned recovery behavior
    
- systemic drift
    

**Root Cause:** Storytelling. Stories are contamination.

## **O.5 Case Study: The Operator Override Catastrophe (2420)**

**Failure:** An operator manually increased power to “punch through interference.”

**Outcome:**

- power flooding
    
- modulation collapse
    
- multi‑node fallback
    
- irreversible contamination
    

**Root Cause:** Human confidence. Confidence is contamination.

## **O.6 Case Study: The Semantic Drift Collapse (2421)**

**Failure:** Two vendors reinterpreted the same hint TLV differently.

**Outcome:**

- divergent behavior
    
- incompatible fallback
    
- cascading misclassification
    
- multi‑system failure
    

**Root Cause:** Interpretation. Interpretation is contamination.


# **Appendix P — Errata Prevention Doctrine**

_Dr. Arjun Kade, Luna University RF Systems Group_

Errata are not corrections. Errata are symptoms of contamination that escaped detection during drafting, review, or implementation. The purpose of this doctrine is to prevent errata from occurring at all.

Errata prevention is not editorial. Errata prevention is operational hygiene.

This appendix defines the mandatory processes required to ensure that no ambiguity, drift, or undocumented behavior enters the standard — or its implementations — after publication.

## **P.1 Doctrine Philosophy**

Errata prevention requires:

- **deterministic drafting**
    
- **deterministic interpretation**
    
- **deterministic implementation**
    
- **deterministic review**
    

Errata prevention must **not** rely on:

- “common sense”
    
- “industry norms”
    
- “reasonable assumptions”
    
- “practical experience”
    

Human intuition is not a safeguard. It is a contamination vector.

## **P.2 Pre‑Publication Contamination Screening**

Before publication, all sections must undergo:

- semantic drift analysis
    
- provenance chain validation
    
- cross‑vendor interpretation checks
    
- timing and modulation constraint audits
    
- operator‑influence elimination
    

Any section that tolerates interpretation must be rewritten. Any section that tolerates creativity must be removed.

## **P.3 Post‑Publication Drift Monitoring**

After publication, the standard must be monitored for:

- vendor reinterpretation
    
- undocumented extensions
    
- ambiguous field usage
    
- divergent diagnostics
    
- profile misalignment
    

Drift is not a slow process. Drift is contamination in motion.

## **P.4 Errata Classification**

Errata fall into three categories:

### **Class 1 — Semantic Ambiguity**

A phrase or definition allows multiple interpretations. This is contamination.

### **Class 2 — Structural Inconsistency**

Two sections define overlapping or conflicting constraints. This is contamination.

### **Class 3 — Implementation Divergence**

Vendors interpret the same requirement differently. This is contamination.

Errata are not mistakes. Errata are failures of containment.

## **P.5 Errata Prevention Mechanisms**

To prevent errata:

- all semantics must be explicit
    
- all constraints must be non‑negotiable
    
- all profiles must be deterministic
    
- all examples must be canonical
    
- all wire formats must be immutable
    
- all diagnostics must be reproducible
    
- all operator influence must be eliminated
    

Errata prevention is not about clarity. It is about eliminating ambiguity before it becomes contamination.

## **P.6 Errata Rejection Criteria**

Errata must be rejected if they:

- propose “flexibility”
    
- introduce optional behavior
    
- weaken constraints
    
- add narrative explanations
    
- rely on operator judgment
    
- introduce vendor‑specific semantics
    

Errata that increase determinism may be accepted. Errata that decrease determinism must be discarded.

## **P.7 Doctrine Summary**

Errata prevention is the final containment layer. It ensures that:

- the standard does not drift
    
- implementations do not diverge
    
- vendors do not improvise
    
- operators do not reinterpret
    
- contamination does not propagate
    

A standard that tolerates errata is not a standard. It is folklore.

# **Appendix Q — Consolidated Index**

_Dr. Arjun Kade, Luna University RF Systems Group_

This index exists to ensure that implementers can locate constraints without relying on memory, intuition, or interpretive reading. The index is not exhaustive — it is **deterministic**, listing only terms with canonical definitions in the standard.

## **Q.1 Index (Alphabetical)**

**A**

- Adversarial Failures — §18
    
- Anomaly Detection — App. D
    
- Append‑Only Logs — §15
    
- Authority Plane — RFC‑2360 series
    

**B**

- Beacon Alignment — §17
    
- Beacon Spoofing — App. G
    
- Behavioral Failures — §18
    
- Burst Protocols — RFC‑2424
    

**C**

- Chain‑of‑Custody — §15
    
- Class F Errors — §14
    
- Compliance Levels — §16
    
- Containment — §18, App. D
    
- Contamination — throughout
    
- Cross‑Vendor Determinism — §17
    

**D**

- Diagnostics — §14
    
- Drift (Timing/FHSS) — §18
    
- Determinism — §1, App. A
    

**E**

- Evidence Preservation — §15
    
- Errata Prevention — App. P
    

**F**

- FHSS/LPI — §3, §17, App. I
    
- Fallback — §16, App. B
    

**G**

- Glossary — App. A
    
- Governance — RFC‑2450 series
    

**H**

- Hint TLVs — §12, App. I
    
- Historical Failures — App. K
    

**I**

- Implementation Drift — §19
    
- Interoperability — §17
    
- Interference Classification — §11
    
- IANA Registries — §20
    

**L**

- Logging — §15
    
- Lockout Protocol — App. J
    

**M**

- Modulation Fidelity — §19
    
- Monitoring State — App. D
    

**N**

- Namespace Plane — RFC‑2390 series
    
- Noise Floor — §11
    

**O**

- Operator Intervention — §16, App. J
    
- Occupancy — §11
    

**P**

- Provenance — §4, §14, App. I
    
- Profiles — §2, §16
    
- Power Control — §19
    

**R**

- RFChannelRecord — §10, App. I
    
- Recovery — §16, App. B
    
- Routing Endpoints — RFC‑2363
    

**S**

- Scheduled‑Band — §7, App. B
    
- Security State Machine — App. D
    
- Semantic Drift — §18
    
- State Machines — App. B
    
- Spoofing — App. G
    

**T**

- Test Vectors — App. H
    
- Timing Discipline — §19
    
- Threat Matrix — App. G
    

**U**

- Undocumented Behavior — §18
    
- Unverifiable State — §17
    

**V**

- Vendor Extensions — §19

# **Epilogue — The Final Containment Boundary**

_Dr. Arjun Kade, Luna University RF Systems Group_ _Visiting Fellow, MIAP Optical Systems Group_

Standards do not fail because physics changes. Standards fail because humans do.

They fail when implementers reinterpret constraints as suggestions. They fail when vendors treat determinism as an obstacle. They fail when operators believe intuition is a substitute for measurement. They fail when reviewers attempt to “simplify” the text until it no longer constrains anything at all.

This document exists to prevent that failure.

It is not a guide. It is not a recommendation. It is not a collaborative framework. It is a containment protocol.

Every section, every appendix, every constraint, every prohibition, and every canonical structure is designed to ensure that SolNet RF systems behave:

- deterministically
    
- reproducibly
    
- measurably
    
- verifiably
    
- without folklore
    
- without improvisation
    
- without contamination
    

The RF layer is not a creative medium. It is not a negotiation. It is not a place for human expression.

It is a physical system governed by deterministic laws that do not care about convenience, preference, or interpretation.

If future implementers attempt to reinterpret this document, they must be corrected. If future vendors attempt to extend this document without registration, they must be rejected. If future operators attempt to override this document, they must be locked out. If future reviewers attempt to soften this document, they must be ignored.

This standard is not fragile. It is not flexible. It is not polite.

It is a wall.

A wall built to keep contamination out. A wall built to keep determinism in. A wall built to ensure that RF systems behave exactly as physics requires — and never as humans prefer.

If this wall ever cracks, it will not be because the constraints were insufficient. It will be because someone believed they were optional.

They are not.

This is the end of the document. It is not the end of the discipline.

The RF layer will remain deterministic only as long as the people who build, operate, and maintain it remain disciplined enough to enforce the constraints defined here.

If they do, the system will remain stable. If they do not, contamination will return.

And contamination, once allowed to propagate, does not stop on its own.

It must be contained.

Always.