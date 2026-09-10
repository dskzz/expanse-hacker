# **Preface — RFC‑2308 Media Privacy and Exposure Policy**

_Dr. Mara Ellison, Chair, SolNet Privacy & Exposure Working Group (SPEWG)_ _Apolitical Operative, Authority‑Plane Oversight_

Operational metadata has become one of the most consistently exploited surfaces in SolNet. Ephemeris traces, pointing vectors, beaconing intervals, and timing signatures are emitted by systems that rarely consider how easily such information can be extracted, aggregated, or repurposed. Once visible, this data does not remain benign. It is copied into caches, forwarded through relays, and retained in logs that outlive their operators. Experience shows that any unprotected metadata will, in short order, be collected, correlated, and weaponized by parties who have no obligation to use it responsibly.

This document establishes the mandatory controls required to prevent that outcome.

A **Directory and Routing Endpoint (DRE)** is the Authority‑Plane system responsible for determining what operational metadata may be exposed, to whom, and under what conditions. DREs validate provenance, enforce domain privacy profiles, apply suppression rules, and maintain immutable audit records for every exposure event. They operate under the assumption that any request for visibility may be an attempt to reconstruct movement, posture, or operational intent.

The policies defined here restrict the visibility of fields that enable cross‑domain correlation or inference. Even limited exposure of these fields has enabled reconstructions of vessel trajectories, relay alignment, and timing behavior. Several documented incidents resulted in complete compromise of essential systems. These failures were not caused by adversaries with extraordinary capability. They were caused by permissive defaults, inconsistent suppression, and the belief that metadata is harmless until proven otherwise.

RFC‑2308 removes that belief.

The PolicyRecord schema formalizes the minimum metadata that may be emitted and the conditions under which additional fields may be exposed. Domain privacy profiles (UN, MCRN, OPA, Belter) are defined to ensure that exposure decisions are deterministic and not subject to operator preference or domain‑level negotiation. L1 suppression rules are integrated directly into the policy to prevent accidental leakage through lower‑layer behavior. DRE access controls are specified to ensure that visibility is granted only when provenance, authorization, and necessity are all verifiable and auditable.

This document assumes the malicious motives inherent in any domain, vendor, or operator when visibility is left unregulated. It assumes that exposed metadata will be aggregated, correlated, and used to compromise systems. It assumes that operators will bypass restrictions when they believe it will save them time.

These assumptions are not theoretical. They reflect the operational reality of SolNet, where governments, corporations, and research institutions generally comply with policy, while independent haulers, unlicensed belters, frontier relays, and free‑wheeling captains routinely ignore it. RFC‑2308 cannot mandate compliance across the entire network. It can only define the controls required for those systems that choose to remain trustworthy.

Compliance with RFC‑2308 is mandatory for all systems participating in regulated SolNet media operations. Any deviation must be treated as an exposure event and audited accordingly.


# **1. Scope and Definitions**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

## **1.1 Scope**

This document defines the mandatory policies governing the exposure, suppression, and auditability of operational metadata emitted by SolNet media systems. It applies to all regulated participants, including governmental, corporate, and academic operators, as well as any system that elects to interoperate with Authority‑Plane visibility controls.

The scope includes:

- ephemeris fields
    
- pointing vectors
    
- beaconing metadata
    
- timing signatures
    
- media‑layer diagnostic fields
    
- any secondary data derived from these sources
    

The policies defined here apply to all systems capable of emitting, forwarding, or storing such metadata. They are binding for regulated domains and recommended for all others. The document acknowledges that a significant portion of SolNet—particularly independent haulers, unlicensed belters, frontier relays, and operators who treat media systems as discretionary tools—will not implement these controls. The policies are written to ensure that compliant systems remain trustworthy even when surrounded by non‑compliant ones.

RFC‑2308 does not define routing behavior, endpoint namespaces, or Authority‑Plane state machines. Those are specified in RFC‑2363 (Directory and Routing Endpoints). This document defines the exposure rules that those systems must enforce.

## **1.2 Directory and Routing Endpoints (DREs)**

A **Directory and Routing Endpoint (DRE)** is the Authority‑Plane system responsible for determining what operational metadata may be exposed, to whom, and under what conditions. DREs validate provenance, enforce domain privacy profiles, apply L1 suppression rules, and maintain immutable audit records for every exposure event.

DREs operate under the assumption that any request for visibility may be an attempt to reconstruct movement, posture, or operational intent. They treat all incoming requests as untrusted until authorization, provenance, and necessity are independently verified. DREs are the sole arbiters of metadata visibility in regulated SolNet environments.

## **1.3 Exposure Surfaces**

For the purposes of this document, an **exposure surface** is any field, signal, or derived value that can be observed, inferred, or reconstructed by another system. Exposure surfaces include:

- directly transmitted metadata
    
- timing‑derived signatures
    
- beaconing intervals
    
- ephemeris deltas
    
- pointing adjustments
    
- diagnostic emissions
    
- cached or forwarded secondary data
    

Any field that can be correlated across domains is considered an exposure surface, regardless of its original purpose.

## **1.4 Domain Privacy Profiles**

A **Domain Privacy Profile** defines the maximum permissible visibility for a given domain (UN, MCRN, OPA, Belter). These profiles constrain what metadata a DRE may expose to that domain. Profiles are deterministic and non‑negotiable. Operator preference, domain‑level agreements, and local policy cannot override them.

Profiles exist because unregulated visibility has repeatedly resulted in cross‑domain correlation attacks, operational inference, and compromise of essential systems. The profiles formalize the minimum level of opacity required to prevent recurrence.

## **1.5 Exposure Events**

An **exposure event** is any instance in which operational metadata becomes visible to a system outside the originating node’s privacy profile. Exposure events include:

- intentional emission
    
- accidental leakage
    
- misconfigured suppression
    
- unauthorized DRE access
    
- operator‑initiated overrides
    
- propagation through non‑compliant relays
    

Exposure events must be logged, audited, and attributable. Any deviation from the policies defined in this document is considered an exposure event.

## **1.6 Assumptions**

This document is written with the following operational assumptions:

- metadata, once exposed, will be aggregated and correlated
    
- operators will bypass restrictions when they believe it will save time
    
- non‑compliant systems will continue to emit unsuppressed metadata
    
- frontier and independent networks will not implement DREs
    
- legacy systems will leak fields they do not understand
    
- visibility cannot be revoked once granted
    

These assumptions reflect observed behavior across SolNet and are not subject to revision.

# **2. Exposure Surfaces**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Exposure surfaces are any fields, signals, or derived values that can be observed, inferred, or reconstructed by another system. They represent the primary mechanism by which operational intent, movement, posture, or system state becomes visible beyond its intended scope. This section identifies the categories of metadata that must be controlled, suppressed, or audited to prevent uncontrolled visibility.

The definitions below assume a heterogeneous SolNet in which many participants—particularly independent haulers, unlicensed belters, and frontier mesh operators—will disregard policy entirely. Exposure surfaces must therefore be defined in a way that allows compliant systems to remain predictable even when surrounded by systems that generate uncontrolled entropy.

## **2.1 Direct Emissions**

Direct emissions are metadata fields intentionally transmitted by a node. These include:

- ephemeris coordinates
    
- pointing vectors
    
- beaconing intervals
    
- timing signatures
    
- media‑layer diagnostic fields
    
- link‑quality indicators
    
- neighbor‑discovery announcements
    

Direct emissions are the most visible and the most frequently exploited. They are routinely forwarded, cached, or logged by systems that do not evaluate the consequences of making them observable. Once emitted, these fields propagate through the network with no guarantee of suppression or deletion.

## **2.2 Derived Emissions**

Derived emissions are values inferred from observable behavior even when not explicitly transmitted. These include:

- timing drift patterns
    
- modulation‑dependent signatures
    
- dwell‑time irregularities
    
- ephemeris deltas reconstructed from movement
    
- pointing adjustments inferred from link behavior
    
- beaconing jitter patterns
    

Derived emissions are often overlooked by operators who assume that suppressing direct fields is sufficient. In practice, derived emissions have enabled reconstructions of vessel trajectories, relay alignment, and timing behavior even when direct metadata was filtered.

## **2.3 Secondary Data**

Secondary data is any metadata that has been:

- forwarded
    
- cached
    
- aggregated
    
- archived
    
- included in logs
    
- embedded in diagnostic bundles
    
- retained by intermediary systems
    

Secondary data is frequently more dangerous than direct emissions because it persists indefinitely. It is routinely collected by relays, vendor equipment, and monitoring tools that do not implement suppression. Once retained, it becomes part of the network’s long‑term visibility footprint and cannot be reliably erased.

## **2.4 Cross‑Domain Correlation Surfaces**

Cross‑domain correlation surfaces are fields that, when combined with data from another domain, enable reconstruction of operational intent. These include:

- timing signatures that match known relay schedules
    
- beaconing intervals that reveal vessel class
    
- ephemeris deltas that indicate acceleration profiles
    
- pointing vectors that imply defensive posture
    
- diagnostic fields that reveal equipment lineage
    

These surfaces are responsible for the majority of multi‑domain compromises. Even limited visibility into these fields has enabled adversaries to reconstruct movement, posture, and operational behavior with high accuracy.

## **2.5 Operator‑Generated Exposure**

Operator‑generated exposure includes any metadata made visible due to:

- manual overrides
    
- misconfigured suppression
    
- permissive defaults
    
- unauthorized diagnostic commands
    
- convenience‑driven shortcuts
    
- legacy equipment emitting fields it cannot suppress
    

These exposures are the most common in unregulated regions of SolNet. They are also the most difficult to prevent. RFC‑2308 cannot eliminate operator‑generated exposure; it can only define the controls required for systems that choose to remain trustworthy.

## **2.6 Non‑Compliant Chaos**

Non‑compliant systems represent the most severe and persistent exposure risk in SolNet. These include:

- frontier mesh nodes assembled from improvised hardware
    
- unlicensed belter repeaters operating without suppression
    
- independent hauler consoles running unpatched vendor firmware
    
- legacy equipment incapable of enforcing privacy profiles
    
- relays maintained by operators who treat configuration as optional
    

These systems do not merely ignore policy. They generate **unbounded entropy** in the visibility layer. They emit unsuppressed metadata, forward diagnostic bundles without filtering, retain secondary data indefinitely, and expose fields that compliant systems would never reveal. Their behavior is inconsistent, unauditable, and frequently irreversible.

From a privacy‑policy perspective, non‑compliant systems function as **entropy injectors**. They destabilize suppression guarantees, undermine provenance validation, and create exposure surfaces that cannot be controlled or contained. Once metadata enters these systems, it becomes part of a visibility cascade that no Authority‑Plane mechanism can reliably halt.

Compliant systems must assume that any metadata originating from non‑compliant chaos is compromised. They must also assume that any metadata sent _to_ such systems will be retained, forwarded, or leaked without regard for privacy profiles or operational safety.

RFC‑2308 cannot eliminate non‑compliant chaos. It can only define the controls required for systems that choose to remain trustworthy in an environment where entropy is not an accident but a constant, structural threat.

## **2.7 Exposure Surface Summary**

Exposure surfaces include, but are not limited to:

- any directly transmitted metadata
    
- any value inferred from observable behavior
    
- any secondary data retained by intermediary systems
    
- any field enabling cross‑domain correlation
    
- any metadata made visible through operator action
    
- any emission from non‑compliant chaos
    

If a field can be observed, it will be aggregated. If it can be aggregated, it will be correlated. If it can be correlated, it will be used to compromise systems.

RFC‑2308 defines the controls required to prevent that outcome.

# **3. PolicyRecord Schema**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

The **PolicyRecord** defines the minimum metadata controls required for any system participating in regulated SolNet media operations. It specifies what fields may be emitted, under what conditions, and with what audit obligations. The schema exists to ensure that exposure decisions are deterministic, reproducible, and enforceable by Directory and Routing Endpoints (DREs).

The PolicyRecord is not a recommendation. It is the minimum structure required to prevent uncontrolled visibility in an environment where non‑compliant chaos routinely injects entropy into the network.

## **3.1 Purpose of the PolicyRecord**

The PolicyRecord exists to:

- constrain what metadata a system may expose
    
- define the suppression behavior for each field
    
- bind exposure decisions to domain privacy profiles
    
- ensure that all visibility is auditable
    
- prevent operator discretion from overriding policy
    
- provide DREs with a deterministic enforcement structure
    

Without a PolicyRecord, exposure behavior becomes dependent on operator judgment, vendor defaults, or legacy system quirks. These conditions have repeatedly resulted in exposure cascades that could not be reconstructed or contained.

## **3.2 PolicyRecord Structure**

A PolicyRecord consists of the following mandatory fields:

### **3.2.1** `field_id`

A unique identifier for the metadata field. This value must be stable across implementations and vendor variants. Ambiguous or vendor‑specific identifiers are prohibited.

### **3.2.2** `classification`

The exposure classification for the field. Valid values are:

- `direct_emission`
    
- `derived_emission`
    
- `secondary_data`
    
- `correlation_surface`
    
- `operator_generated`
    
- `non_compliant_origin`
    

Classification determines the minimum suppression requirements and audit obligations.

### **3.2.3** `exposure_level`

The maximum permissible visibility for the field. Exposure levels are defined in Section 5. Fields without an assigned exposure level must be suppressed.

### **3.2.4** `suppression_rule`

The rule governing whether the field may be emitted. Valid values include:

- `suppress_always`
    
- `suppress_unless_authorized`
    
- `expose_with_profile`
    
- `expose_with_audit`
    
- `expose_unrestricted` (prohibited for regulated systems)
    

Suppression rules must be deterministic. Operator‑initiated overrides are prohibited unless explicitly authorized by the domain privacy profile.

### **3.2.5** `profile_binding`

The domain privacy profiles (UN, MCRN, OPA, Belter) that determine visibility. Each field must specify:

- which domains may see it
    
- under what conditions
    
- with what audit requirements
    

Fields not bound to a profile must be suppressed.

### **3.2.6** `audit_requirement`

The audit obligations for any exposure of the field. Valid values include:

- `none` (prohibited for regulated systems)
    
- `record_local`
    
- `record_and_forward`
    
- `immutable_log_required`
    
- `immutable_log_and_alert`
    

Fields classified as correlation surfaces must use `immutable_log_and_alert`.

### **3.2.7** `provenance_requirement`

The provenance validation required before exposure. Valid values include:

- `none` (prohibited)
    
- `basic_identity`
    
- `full_identity`
    
- `full_identity_and_chain`
    

Fields originating from non‑compliant chaos must require `full_identity_and_chain` or be suppressed.

### **3.2.8** `retention_policy`

Defines how long the field may be retained by compliant systems. Retention must be:

- minimal
    
- deterministic
    
- auditable
    

Indefinite retention is prohibited.

## **3.3 PolicyRecord Enforcement**

PolicyRecords must be enforced by:

- the originating node
    
- any intermediary relay
    
- all DREs
    
- any system that forwards, caches, or archives metadata
    

If any system in the chain cannot enforce the PolicyRecord, the field must be suppressed.

This requirement exists because non‑compliant chaos routinely forwards metadata without filtering, creating exposure cascades that cannot be reversed. The PolicyRecord ensures that compliant systems do not contribute to these cascades.

## **3.4 PolicyRecord Distribution**

PolicyRecords must be:

- signed
    
- versioned
    
- distributed through Authority‑Plane channels
    
- validated by DREs before use
    

Unsigned or outdated PolicyRecords must be rejected. Systems operating without a valid PolicyRecord must suppress all metadata except fields explicitly required for link establishment.

## **3.5 PolicyRecord Failure Modes**

A PolicyRecord failure occurs when:

- a field is emitted without a valid suppression rule
    
- a field is exposed to a domain not permitted by its profile binding
    
- provenance cannot be validated
    
- audit requirements cannot be met
    
- retention policy is violated
    
- a non‑compliant system forwards metadata that cannot be suppressed
    

All PolicyRecord failures must be treated as exposure events and audited accordingly.

## **3.6 Rationale**

The PolicyRecord exists because SolNet is not a uniform, regulated environment. It is a partially governed network surrounded by non‑compliant chaos that emits metadata unpredictably and retains it indefinitely. Without a deterministic structure governing exposure, compliant systems cannot remain trustworthy.

The PolicyRecord is the only mechanism that prevents regulated systems from being absorbed into the entropy that defines the rest of SolNet.


# **4. Domain Privacy Profiles**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Domain Privacy Profiles define the maximum permissible visibility for each domain participating in regulated SolNet operations. They exist because unregulated visibility has repeatedly resulted in cross‑domain correlation attacks, operational inference, and compromise of essential systems. Profiles ensure that exposure decisions are deterministic and not subject to operator preference, domain‑level negotiation, or the inconsistent behavior of non‑compliant chaos.

A Domain Privacy Profile is not a trust agreement. It is a containment boundary.

Profiles are mandatory for all regulated systems and recommended for all others. Systems that do not implement profiles must suppress all metadata except fields explicitly required for link establishment.

## **4.1 Purpose of Domain Privacy Profiles**

Domain Privacy Profiles exist to:

- constrain what metadata each domain may observe
    
- prevent cross‑domain correlation
    
- eliminate operator discretion in exposure decisions
    
- ensure deterministic behavior across compliant systems
    
- provide DREs with enforceable visibility boundaries
    
- reduce the attack surface created by heterogeneous, partially regulated networks
    

Profiles are required because SolNet is not a uniform environment. It is a mixture of regulated infrastructure and non‑compliant chaos. Without profiles, compliant systems would be absorbed into that entropy.

## **4.2 Profile Structure**

Each Domain Privacy Profile consists of:

- **domain_id** — the domain to which the profile applies
    
- **visibility_class** — the maximum exposure level permitted
    
- **allowed_fields** — fields that may be exposed
    
- **restricted_fields** — fields that must be suppressed
    
- **audit_requirements** — obligations for any exposure
    
- **provenance_requirements** — validation required before exposure
    
- **retention_constraints** — how long metadata may be retained
    

Profiles must be deterministic. Profiles must be immutable once published. Profiles must be enforced by all DREs.

## **4.3 UN Profile (High Regulation)**

The UN profile assumes:

- strong regulatory compliance
    
- predictable audit behavior
    
- consistent DRE configuration
    
- low tolerance for uncontrolled visibility
    

**Visibility Class:** Moderate **Allowed Fields:** limited timing signatures, minimal diagnostic fields **Restricted Fields:** ephemeris, pointing vectors, beaconing intervals **Audit Requirements:** immutable log required **Provenance Requirements:** full identity and chain **Retention Constraints:** minimal, deterministic, auditable

The UN profile is the most conservative. It exists to prevent correlation attacks across large, multi‑node infrastructures.

## **4.4 MCRN Profile (Military Regulation)**

The MCRN profile assumes:

- strict internal controls
    
- high‑sensitivity operations
    
- strong DRE enforcement
    
- zero tolerance for inference
    

**Visibility Class:** Low **Allowed Fields:** none beyond link‑establishment minimums **Restricted Fields:** all operational metadata **Audit Requirements:** immutable log and alert **Provenance Requirements:** full identity and chain **Retention Constraints:** minimal, purge‑on‑disconnect

The MCRN profile is designed to prevent any external visibility into military posture or movement.

## **4.5 OPA Profile (Mixed Compliance)**

The OPA profile assumes:

- heterogeneous infrastructure
    
- inconsistent operator behavior
    
- partial DRE deployment
    
- variable audit reliability
    

**Visibility Class:** Moderate‑Low **Allowed Fields:** minimal diagnostic fields **Restricted Fields:** ephemeris, pointing vectors, timing signatures **Audit Requirements:** record and forward **Provenance Requirements:** full identity **Retention Constraints:** minimal, purge recommended

The OPA profile reflects a domain where compliance is possible but not guaranteed.

## **4.6 Belter Profile (Low Regulation)**

The Belter profile assumes:

- improvised hardware
    
- inconsistent maintenance
    
- partial or absent DRE enforcement
    
- operators who treat configuration as optional
    

**Visibility Class:** Minimal **Allowed Fields:** link‑establishment minimums only **Restricted Fields:** all other metadata **Audit Requirements:** record local (if available) **Provenance Requirements:** basic identity (if available) **Retention Constraints:** minimal, purge recommended

The Belter profile exists to limit the damage caused by systems that cannot reliably enforce suppression.

## **4.7 Non‑Compliant Domains**

Non‑compliant domains are those that:

- do not implement DREs
    
- do not enforce suppression
    
- do not maintain audit trails
    
- do not validate provenance
    
- do not adhere to any privacy profile
    

These domains generate uncontrolled entropy. They destabilize suppression guarantees and create exposure surfaces that cannot be contained.

**Visibility Class:** None **Allowed Fields:** none **Restricted Fields:** all **Audit Requirements:** not applicable **Provenance Requirements:** not applicable **Retention Constraints:** not applicable

Compliant systems must treat all metadata originating from non‑compliant domains as compromised.

## **4.8 Profile Enforcement**

Domain Privacy Profiles must be enforced by:

- originating nodes
    
- intermediary relays
    
- all DREs
    
- any system that forwards, caches, or archives metadata
    

If any system in the chain cannot enforce the profile, the field must be suppressed.

This requirement exists because non‑compliant chaos routinely forwards metadata without filtering, creating exposure cascades that cannot be reversed.

## **4.9 Rationale**

Profiles exist because SolNet is not a closed, regulated network. It is a partially governed system surrounded by entropy. Without deterministic visibility boundaries, compliant systems would be indistinguishable from the chaos that surrounds them.

Domain Privacy Profiles are the only mechanism that prevents regulated systems from being consumed by that entropy.


# **5. Suppression Rules**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Suppression rules define the mandatory conditions under which operational metadata must be withheld from transmission, forwarding, caching, or archival. These rules exist to prevent exposure cascades in a network where compliant systems operate alongside non‑compliant chaos. Suppression is the primary mechanism by which regulated systems avoid being absorbed into that entropy.

Suppression rules are not advisory. They are the minimum requirements for participation in regulated SolNet operations.

## **5.1 Deterministic Suppression**

All suppression behavior must be deterministic. A field must either be:

- always suppressed
    
- suppressed unless explicitly authorized
    
- exposed only under a specific domain privacy profile
    
- exposed only with audit
    
- or never exposed
    

There is no category for “operator judgment.” Experience shows that operator judgment is indistinguishable from entropy under load.

## **5.2 Mandatory Suppression Categories**

The following categories **must** be suppressed unless explicitly authorized by the domain privacy profile:

### **5.2.1 Ephemeris Fields**

These fields enable reconstruction of movement and are the most frequently weaponized. Even compliant operators underestimate their sensitivity. Non‑compliant operators do not consider them at all.

### **5.2.2 Pointing Vectors**

Pointing vectors reveal posture, alignment, and intent. They must be suppressed because even a single leaked vector can be correlated across domains.

### **5.2.3 Beaconing Intervals**

Beaconing intervals reveal vessel class, equipment lineage, and operational state. They are routinely leaked by legacy systems and improvised belter hardware.

### **5.2.4 Timing Signatures**

Timing signatures enable correlation attacks even when all other metadata is suppressed. They must be minimized and, when possible, obfuscated.

### **5.2.5 Diagnostic Fields**

Diagnostic fields often contain secondary data that operators do not realize is sensitive. This is especially true for vendor equipment that logs everything “for convenience.”

## **5.3 Conditional Suppression**

Some fields may be exposed only when:

- the domain privacy profile explicitly permits it
    
- provenance validation is complete
    
- audit requirements can be met
    
- the DRE confirms necessity
    

If any of these conditions fail, the field must be suppressed.

This rule exists because non‑compliant chaos routinely forwards metadata without filtering, and compliant systems must not contribute to that behavior.

## **5.4 Suppression Overrides**

Suppression overrides are prohibited except where explicitly authorized by the domain privacy profile. Overrides must:

- be logged
    
- be auditable
    
- require full provenance validation
    
- trigger an alert to the Authority‑Plane
    

Operators who bypass suppression without authorization create exposure cascades that cannot be reconstructed. This behavior is common among independent haulers and frontier relays, which is why overrides are tightly controlled.

## **5.5 Suppression in Mixed‑Compliance Environments**

In environments where compliant systems interoperate with non‑compliant chaos, suppression rules must be applied with the assumption that:

- any visible metadata will be retained indefinitely
    
- any forwarded metadata will be exposed to unknown domains
    
- any diagnostic bundle will be copied into systems with no privacy controls
    
- any operator shortcut will become a permanent configuration
    

Suppression must therefore be conservative. If a field’s safety cannot be guaranteed, it must be suppressed.

## **5.6 Suppression and Legacy Systems**

Legacy systems frequently emit fields they cannot suppress. They also:

- misreport their own capabilities
    
- forward metadata without filtering
    
- retain secondary data indefinitely
    
- expose diagnostic bundles without operator awareness
    

Compliant systems must assume that legacy systems are unreliable and suppress all metadata that could be forwarded to them.

This is not a criticism of legacy operators. It is a criticism of the equipment, which was designed in an era when visibility was considered harmless.

## **5.7 Suppression and Improvised Equipment**

Improvised belter hardware and frontier mesh nodes often lack:

- functional suppression
    
- consistent firmware
    
- any concept of a privacy profile
    
- operators who consider configuration a priority
    

These systems generate uncontrolled entropy. Compliant systems must suppress all metadata that could be observed by them.

<NOTE>
_“If a system was assembled from spare parts and a prayer, assume it leaks.”_
</NOTE>

# **6. DRE Enforcement Requirements**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Directory and Routing Endpoints (DREs) are the only systems in SolNet capable of enforcing deterministic visibility boundaries. They validate provenance, apply suppression rules, enforce domain privacy profiles, and maintain immutable audit records. Without strict DRE enforcement, compliant systems would be indistinguishable from the non‑compliant chaos that surrounds them.

This section defines the mandatory enforcement behavior required of all DREs participating in regulated SolNet operations.

## **6.1 Enforcement Priority**

DREs must treat exposure control as their highest operational priority. Routing, diagnostics, and operator convenience are secondary. If a DRE cannot guarantee suppression, it must deny visibility.

This requirement exists because operators routinely prioritize “getting the link up” over preventing exposure. DREs must not inherit that behavior.

## **6.2 Provenance Validation**

Before exposing any metadata, a DRE must validate:

- identity of the requesting system
    
- authorization according to the domain privacy profile
    
- provenance chain of the request
    
- integrity of the PolicyRecord
    
- consistency of the suppression rules
    

If any validation step fails, the request must be denied.

DREs must assume that any request lacking complete provenance is an attempt to reconstruct operational intent. This assumption is based on incident history, not speculation.

## **6.3 Profile Enforcement**

DREs must enforce Domain Privacy Profiles without exception. This includes:

- suppressing fields not permitted by the profile
    
- applying audit requirements
    
- validating retention constraints
    
- rejecting operator‑initiated overrides
    
- denying visibility to domains with insufficient provenance
    

Profiles are not guidelines. They are containment boundaries.

DREs must not allow operators to “temporarily relax” profile restrictions. Experience shows that temporary relaxations become permanent configurations.

## **6.4 Suppression Enforcement**

DREs must enforce suppression rules defined in the PolicyRecord. This includes:

- `suppress_always`
    
- `suppress_unless_authorized`
    
- `expose_with_profile`
    
- `expose_with_audit`
    

If a DRE cannot enforce a suppression rule due to:

- misconfiguration
    
- missing PolicyRecord
    
- inconsistent firmware
    
- operator interference
    
- non‑compliant upstream behavior
    

…it must default to suppression.

This requirement exists because non‑compliant chaos routinely forwards metadata without filtering, and compliant systems must not contribute to that behavior.

## **6.5 Audit Enforcement**

DREs must maintain immutable audit records for all exposure events. This includes:

- timestamp
    
- requesting domain
    
- exposed fields
    
- suppression rules applied
    
- provenance chain
    
- operator actions
    
- any overrides (authorized or denied)
    

Audit records must be:

- tamper‑evident
    
- cryptographically signed
    
- retained according to the retention policy
    
- available for Authority‑Plane review
    

DREs must assume that any exposure not logged is indistinguishable from a breach.

## **6.6 Failure Handling**

When a DRE encounters a failure in:

- provenance validation
    
- profile enforcement
    
- suppression
    
- audit logging
    
- PolicyRecord verification
    

…it must:

1. deny the request
    
2. suppress all related metadata
    
3. log the failure
    
4. alert the Authority‑Plane if required by the profile
    

DREs must not attempt to “recover gracefully” by exposing partial metadata. Partial exposure is still exposure.

## **6.7 Interactions with Non‑Compliant Chaos**

When interacting with non‑compliant systems, DREs must assume:

- metadata will be retained indefinitely
    
- suppression will not be honored
    
- provenance will be unverifiable
    
- diagnostic bundles will be forwarded without filtering
    
- operator shortcuts will override configuration
    

DREs must therefore:

- suppress all metadata not required for link establishment
    
- deny all requests lacking full provenance
    
- treat all incoming metadata as compromised
    
- avoid forwarding any metadata that could be reconstructed downstream
    

_Footnote 6.7‑A:_ _Ellison notes that “if a system cannot spell ‘DRE,’ it should not receive metadata from one.” This remark is preserved here as it reflects the operational reality of mixed‑compliance environments._

## **6.8 Operator Interference**

DREs must resist operator interference. This includes:

- unauthorized overrides
    
- configuration shortcuts
    
- attempts to bypass suppression
    
- disabling audit logging
    
- modifying profile bindings
    

Operators frequently attempt to “fix” problems by disabling controls they do not understand. DREs must treat such attempts as exposure events.

## **6.9 Rationale**

DRE enforcement requirements exist because SolNet is not a uniform, regulated environment. It is a partially governed network surrounded by entropy, improvisation, and operator shortcuts. Without strict DRE enforcement, compliant systems would be consumed by the chaos that defines the rest of SolNet.


# **7. Audit Obligations**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Audit obligations define the minimum requirements for recording, retaining, and validating all exposure‑relevant activity within regulated SolNet systems. Auditing is the only mechanism by which exposure events can be reconstructed, attributed, and contained. In a network where compliant systems operate alongside non‑compliant chaos, audit integrity is the sole barrier preventing visibility failures from becoming permanent.

Audit obligations are mandatory for all regulated systems and recommended for all others.

## **7.1 Audit Scope**

Auditing must capture all events related to:

- metadata exposure
    
- suppression decisions
    
- provenance validation
    
- domain privacy profile enforcement
    
- PolicyRecord application
    
- operator‑initiated actions
    
- DRE overrides (authorized or denied)
    
- failures in any of the above
    

Any event that affects visibility must be auditable. Any event that cannot be audited must be treated as an exposure event.

## **7.2 Audit Record Requirements**

Each audit record must include:

- timestamp (Authority‑Plane synchronized)
    
- requesting domain
    
- requesting system identity
    
- provenance chain
    
- fields requested
    
- fields exposed (if any)
    
- suppression rules applied
    
- profile bindings evaluated
    
- operator actions
    
- DRE decisions
    
- error or failure codes
    

Audit records must be:

- complete
    
- immutable
    
- cryptographically signed
    
- retained according to the retention policy
    
- available for Authority‑Plane review
    

Partial records are insufficient. Missing records are indistinguishable from concealment.

## **7.3 Immutable Logging**

All audit records must be written to an immutable log. This log must:

- prevent modification
    
- prevent deletion
    
- detect tampering
    
- support independent verification
    
- maintain chronological integrity
    

Systems that cannot maintain immutable logs must suppress all metadata except fields required for link establishment.

_Footnote 7.3‑A:_ _Ellison notes that “any system that logs to a text file on local storage is not logging; it is hoping.”_

## **7.4 Audit Forwarding**

Certain events require forwarding to the Authority‑Plane. These include:

- exposure of correlation surfaces
    
- suppression failures
    
- provenance validation failures
    
- unauthorized override attempts
    
- PolicyRecord inconsistencies
    
- interactions with non‑compliant chaos that result in exposure
    

Forwarding must occur immediately. Delayed forwarding is considered non‑compliance.

## **7.5 Retention Requirements**

Audit records must be retained for a duration defined by the domain privacy profile. Retention must be:

- deterministic
    
- verifiable
    
- consistent across implementations
    

Indefinite retention is prohibited. Retention that varies by operator preference is prohibited. Retention that depends on available storage is prohibited.

If a system cannot meet retention requirements, it must suppress all metadata.

## **7.6 Audit Integrity Verification**

Systems must periodically verify:

- log integrity
    
- signature validity
    
- chronological consistency
    
- completeness of audit chains
    
- absence of unauthorized modifications
    

Verification failures must be treated as exposure events.

DREs must not rely on operator‑initiated verification. Operators routinely defer verification until after a failure has occurred.

## **7.7 Cross‑Domain Audit Consistency**

When metadata is exposed across domains, both the originating and receiving systems must generate audit records. These records must:

- reference the same provenance chain
    
- reference the same PolicyRecord version
    
- reflect consistent suppression decisions
    

Inconsistent cross‑domain audit records indicate:

- misconfiguration
    
- non‑compliant behavior
    
- or deliberate concealment
    

All three require Authority‑Plane review.

## **7.8 Audit Failures**

An audit failure occurs when:

- a record is missing
    
- a record is incomplete
    
- a record cannot be verified
    
- a record cannot be retrieved
    
- a record contradicts another record
    
- a system fails to forward a required event
    
- a system fails to retain records for the required duration
    

Audit failures must be treated as exposure events.

## **7.9 Rationale**

Audit obligations exist because SolNet is not a closed, regulated network. It is a partially governed system surrounded by entropy, improvisation, and operator shortcuts. Without immutable, verifiable audit trails, exposure events cannot be reconstructed, attributed, or contained.

# **8. Non‑Compliant Domains**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Non‑compliant domains are regions of SolNet that do not implement Directory and Routing Endpoints (DREs), do not enforce suppression, do not maintain audit trails, and do not adhere to any Domain Privacy Profile. These domains generate uncontrolled entropy in the visibility layer. Their behavior is unpredictable, unauditable, and frequently irreversible.

This section defines the mandatory handling requirements for all interactions with non‑compliant domains.

## **8.1 Definition of Non‑Compliance**

A domain is considered non‑compliant if it exhibits any of the following:

- absence of DRE enforcement
    
- absence of PolicyRecord validation
    
- absence of immutable audit logging
    
- inconsistent or missing provenance chains
    
- operator‑controlled exposure decisions
    
- legacy or improvised hardware incapable of suppression
    
- forwarding of metadata without filtering
    
- retention of secondary data without constraints
    

Non‑compliance is not a matter of intent. It is a matter of capability.

## **8.2 Characteristics of Non‑Compliant Domains**

Non‑compliant domains typically include:

- frontier mesh networks
    
- improvised belter relays
    
- independent hauler infrastructure
    
- legacy vendor systems
    
- abandoned or minimally maintained installations
    
- opportunistic repeaters assembled from mixed hardware
    

These systems routinely:

- emit unsuppressed metadata
    
- forward diagnostic bundles without filtering
    
- retain secondary data indefinitely
    
- misreport their own capabilities
    
- bypass suppression due to operator shortcuts
    
- expose fields that compliant systems would never reveal
    

Their behavior introduces **unbounded entropy** into the network.

_Footnote 8.2‑A:_ _Ellison notes that “entropy is not a failure mode in these domains; it is the operating principle.”_

## **8.3 Visibility Class**

Non‑compliant domains must be assigned **Visibility Class: None**.

This means:

- no metadata may be exposed to them
    
- no metadata may be forwarded to them
    
- no metadata may be cached for them
    
- no metadata may be retained on their behalf
    

Only the minimum fields required for link establishment may be transmitted, and only when absolutely necessary.

## **8.4 Exposure Handling**

When interacting with non‑compliant domains, compliant systems must:

- suppress all metadata not required for link establishment
    
- deny all requests lacking full provenance
    
- treat all incoming metadata as compromised
    
- avoid forwarding any metadata that could be reconstructed downstream
    
- avoid relying on any metadata received from them
    
- avoid assuming any retention or deletion behavior
    

Exposure to non‑compliant domains must be treated as a high‑risk event.

## **8.5 Provenance Handling**

Requests originating from non‑compliant domains must be treated as untrusted. DREs must require:

- full identity
    
- full provenance chain
    
- verification of PolicyRecord version
    
- verification of domain privacy profile (if any)
    

If any of these requirements cannot be met, the request must be denied.

_Footnote 8.5‑A:_ _Ellison remarks that “a provenance chain that begins with ‘unknown relay’ ends with suppression.”_

## **8.6 Audit Requirements**

All interactions with non‑compliant domains must be logged as exposure‑relevant events. Audit records must include:

- the identity (if any) of the non‑compliant system
    
- the fields requested
    
- the fields suppressed
    
- the fields exposed (if any)
    
- the justification for exposure
    
- the provenance chain
    
- the DRE decision path
    

Audit forwarding to the Authority‑Plane is mandatory for:

- any exposure of correlation surfaces
    
- any suppression failure
    
- any override attempt
    
- any provenance inconsistency
    

## **8.7 Containment Requirements**

Compliant systems must ensure that metadata originating from non‑compliant domains does not propagate into regulated environments. This includes:

- suppressing all forwarded metadata
    
- rejecting diagnostic bundles
    
- rejecting cached secondary data
    
- rejecting logs or telemetry lacking provenance
    
- isolating non‑compliant traffic paths
    

Containment is mandatory because non‑compliant domains routinely generate visibility cascades that cannot be reversed.

## **8.8 Rationale**

Non‑compliant domains are not adversaries. They are entropy sources.

They do not leak metadata maliciously. They leak metadata because they cannot do otherwise.

In a network where compliant systems coexist with improvised hardware, legacy equipment, and operator shortcuts, non‑compliant domains represent a structural threat to visibility control. Without strict containment, compliant systems would be absorbed into the chaos that defines the rest of SolNet.

Domain Privacy Profiles, suppression rules, and DRE enforcement exist to prevent that outcome. Non‑compliant domains must therefore be treated as visibility hazards, not peers.


# **9. Failure Modes**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Failure modes describe the conditions under which exposure control mechanisms cease to function as intended. In a heterogeneous SolNet composed of regulated systems, legacy equipment, improvised hardware, and non‑compliant chaos, failure is not an anomaly. It is a predictable outcome of insufficient suppression, incomplete provenance, or operator interference.

This section defines the mandatory classification, handling, and containment requirements for all failure modes relevant to metadata exposure.

## **9.1 Classification of Failure Modes**

Failure modes fall into six categories:

- **Suppression Failures**
    
- **Provenance Failures**
    
- **Profile Enforcement Failures**
    
- **Audit Failures**
    
- **PolicyRecord Failures**
    
- **Non‑Compliant Propagation Failures**
    

Each category represents a distinct breakdown in visibility control. All categories must be treated as exposure events.

## **9.2 Suppression Failures**

A suppression failure occurs when:

- a field marked `suppress_always` is emitted
    
- a field is exposed without profile authorization
    
- a DRE cannot enforce a suppression rule
    
- operator action bypasses suppression
    
- legacy or improvised hardware emits fields it cannot suppress
    

Suppression failures are the most common in mixed‑compliance environments. They are also the most damaging, as they frequently initiate visibility cascades.

_Footnote 9.2‑A:_ _Ellison notes that “any system that claims suppression is ‘optional’ has already failed.”_

## **9.3 Provenance Failures**

A provenance failure occurs when:

- identity cannot be validated
    
- the provenance chain is incomplete
    
- the provenance chain contradicts itself
    
- the requesting system misreports its domain
    
- the requesting system provides unverifiable metadata
    

Provenance failures must result in immediate suppression. Partial provenance is insufficient.

## **9.4 Profile Enforcement Failures**

A profile enforcement failure occurs when:

- a Domain Privacy Profile cannot be validated
    
- a profile binding is missing or inconsistent
    
- a DRE applies an outdated profile
    
- an operator attempts to override a profile
    
- a system exposes fields outside its assigned visibility class
    

Profile enforcement failures indicate systemic misconfiguration or deliberate bypass.

## **9.5 Audit Failures**

An audit failure occurs when:

- an audit record is missing
    
- an audit record is incomplete
    
- an audit record cannot be verified
    
- an audit record contradicts another record
    
- a system fails to forward a required audit event
    
- retention requirements are not met
    

Audit failures must be treated as exposure events because they prevent reconstruction of visibility decisions.

## **9.6 PolicyRecord Failures**

A PolicyRecord failure occurs when:

- a PolicyRecord cannot be validated
    
- a PolicyRecord is missing
    
- a PolicyRecord is outdated
    
- a PolicyRecord contradicts itself
    
- a system applies a vendor‑specific variant
    
- a system emits a field not defined in the PolicyRecord
    

PolicyRecord failures indicate that the system cannot guarantee deterministic behavior.

## **9.7 Non‑Compliant Propagation Failures**

A non‑compliant propagation failure occurs when metadata:

- is forwarded into a non‑compliant domain
    
- is forwarded from a non‑compliant domain
    
- is cached by a non‑compliant relay
    
- is included in a diagnostic bundle forwarded by improvised hardware
    
- is retained indefinitely by systems without suppression
    

These failures are irreversible. Once metadata enters non‑compliant chaos, it cannot be reliably contained.

_Footnote 9.7‑A:_ _Ellison remarks that “propagation into non‑compliant chaos is not a failure to be corrected; it is a boundary that has already collapsed.”_

## **9.8 Failure Handling Requirements**

When any failure mode is detected, the system must:

1. **suppress all related metadata**
    
2. **deny all pending visibility requests**
    
3. **log the failure in the immutable audit record**
    
4. **forward the failure to the Authority‑Plane** if required
    
5. **invalidate any affected provenance chains**
    
6. **invalidate any affected PolicyRecords**
    
7. **revert to minimal‑exposure mode**
    

Minimal‑exposure mode permits only the fields required for link establishment.

## **9.9 Failure Containment**

Containment requires:

- isolating the affected system
    
- preventing further propagation
    
- rejecting all metadata from the affected domain
    
- suppressing all metadata to the affected domain
    
- verifying all audit chains
    
- revalidating all PolicyRecords
    
- revalidating all profile bindings
    

Containment must be immediate. Delayed containment is considered non‑compliance.

## **9.10 Rationale**

Failure modes exist because SolNet is not a uniform, regulated environment. It is a partially governed network surrounded by entropy, improvisation, and operator shortcuts. In such an environment, failure is not exceptional. It is structural.

The purpose of this section is not to eliminate failure. It is to ensure that failure does not become permanent visibility.


# **Appendix A — Incident History (Selected Cases)**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix summarizes representative exposure incidents that informed the development of RFC‑2308. These cases demonstrate the structural risks posed by insufficient suppression, incomplete provenance, and non‑compliant chaos. They are not exhaustive; they are illustrative.

## **A.1 The Ceres Relay Drift Incident**

A Ceres‑orbit relay emitted unsuppressed timing signatures due to a firmware regression. These signatures were correlated with known orbital mechanics, enabling reconstruction of the relay’s drift pattern. The resulting inference allowed an external domain to predict alignment windows with high accuracy.

Root causes:

- outdated PolicyRecord
    
- missing suppression rule
    
- operator‑initiated override
    
- incomplete audit chain
    

Consequences:

- multi‑domain correlation
    
- unauthorized visibility into relay posture
    
- Authority‑Plane intervention
    

## **A.2 The Tycho Diagnostic Cascade**

A Tycho‑based research installation forwarded a diagnostic bundle containing secondary data from three upstream relays. The bundle included:

- ephemeris deltas
    
- pointing adjustments
    
- cached timing signatures
    

The receiving system, a non‑compliant belter repeater, retained the bundle indefinitely. The data later propagated into an unregulated mesh network.

Root causes:

- vendor diagnostic defaults
    
- lack of suppression
    
- absence of DRE enforcement
    

Consequences:

- irreversible exposure
    
- multi‑hop propagation
    
- loss of containment
    

_Footnote A.2‑A:_ _Ellison notes that “diagnostic bundles are the most efficient way to leak everything at once.”_

## **A.3 The Hauler Override Failure**

An independent hauler bypassed suppression to “stabilize a weak link.” The override exposed pointing vectors and timing signatures to a mixed‑compliance environment. A downstream improvised relay cached the emissions and forwarded them to an unknown domain.

Root causes:

- operator shortcut
    
- unauthorized override
    
- lack of immutable audit logging
    

Consequences:

- exposure cascade
    
- untraceable propagation
    
- permanent loss of visibility control
    

## **A.4 The Ganymede Provenance Collapse**

A Ganymede‑based agricultural network accepted metadata from a relay with an incomplete provenance chain. The relay had been intermittently maintained and misreported its domain. The resulting provenance collapse allowed unauthorized visibility into internal timing behavior.

Root causes:

- incomplete provenance
    
- inconsistent domain reporting
    
- outdated DRE firmware
    

Consequences:

- profile enforcement failure
    
- cross‑domain inference
    
- Authority‑Plane review
    

# **Appendix B — Cross‑Domain Correlation Examples**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix provides examples of how limited metadata, when combined across domains, enables reconstruction of operational intent. These examples demonstrate why suppression must be deterministic and why partial exposure is insufficient.

## **B.1 Timing Signature + Beacon Interval**

A timing signature leaked by a compliant system was correlated with a beacon interval leaked by a non‑compliant relay. Together, they revealed:

- vessel class
    
- equipment lineage
    
- operational state
    

Neither field was sensitive alone. Together, they enabled inference.

## **B.2 Ephemeris Delta + Pointing Adjustment**

A suppressed ephemeris field was successfully inferred from:

- pointing adjustments
    
- dwell‑time irregularities
    
- modulation‑dependent signatures
    

The combination revealed acceleration profiles and predicted trajectory.

_Footnote B.2‑A:_ _Ellison notes that “pointing adjustments are ephemeris in disguise.”_

## **B.3 Diagnostic Bundle + Legacy Cache**

A diagnostic bundle forwarded by a compliant system was cached by a legacy relay. The relay later forwarded the cached data to an unrelated domain. The receiving system correlated:

- link‑quality indicators
    
- timing drift
    
- equipment identifiers
    

This enabled reconstruction of relay alignment behavior.

## **B.4 Operator Shortcut + Non‑Compliant Mesh**

An operator temporarily disabled suppression to “test a link.” The emissions were captured by a non‑compliant mesh node. The mesh aggregated the data with unrelated telemetry, enabling:

- posture inference
    
- movement prediction
    
- equipment fingerprinting
    

The operator believed the exposure was temporary. The mesh did not.

# **Appendix C — Operator Misconfiguration Patterns**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix documents recurring operator behaviors that contribute to exposure events. These patterns are consistent across domains, equipment types, and operational environments.

## **C.1 Suppression Disabled for Convenience**

Operators frequently disable suppression to:

- “test a link”
    
- “stabilize a connection”
    
- “speed up troubleshooting”
    
- “work around a firmware issue”
    

These actions routinely result in exposure cascades.

## **C.2 Outdated PolicyRecords**

Operators often fail to update PolicyRecords due to:

- maintenance backlog
    
- vendor tooling limitations
    
- misunderstanding of versioning
    
- reliance on cached configurations
    

Outdated PolicyRecords are a primary cause of inconsistent suppression.

## **C.3 Misinterpreted Profile Bindings**

Operators frequently misinterpret Domain Privacy Profiles as:

- recommendations
    
- negotiable boundaries
    
- adjustable settings
    
- “best practices”
    

Profiles are none of these. They are mandatory constraints.

_Footnote C.3‑A:_ _Ellison remarks that “a profile treated as a suggestion is a profile already violated.”_

## **C.4 Improvised Hardware Assumptions**

Operators assume improvised hardware will:

- honor suppression
    
- retain configuration
    
- report capabilities accurately
    
- delete cached data
    

These assumptions are consistently incorrect.

## **C.5 Diagnostic Bundle Misuse**

Operators routinely forward diagnostic bundles without reviewing their contents. Bundles often include:

- secondary data
    
- cached emissions
    
- correlation surfaces
    
- vendor‑specific telemetry
    

Diagnostic bundles are a major source of unintentional exposure.

## **C.6 Reliance on Legacy Systems**

Operators frequently rely on legacy systems that:

- cannot enforce suppression
    
- cannot validate provenance
    
- cannot maintain audit logs
    
- cannot apply PolicyRecords
    

Legacy systems are predictable only in their failure to control visibility.


# **Appendix D — Private Notes (Classified)**

_RFC‑2308 Internal Addendum_ _Author: Dr. Mara Ellison_ _Distribution: Authority‑Plane Only_ _Not for public release_

These notes document the operational realities that informed RFC‑2308 but were deemed unsuitable for publication. They reflect observed behavior across SolNet, including patterns of non‑compliance, operator shortcuts, and systemic entropy. They are preserved here for internal reference.

## **D.1 On Operator Behavior**

Operators do not disable suppression because they are malicious. They disable suppression because they believe they understand the consequences.

They do not.

Operators consistently underestimate:

- the sensitivity of timing signatures
    
- the reconstructive power of correlation
    
- the persistence of secondary data
    
- the reach of non‑compliant chaos
    
- the inevitability of propagation
    

The most common phrase preceding an exposure cascade is: _“It’s just for a moment.”_

## **D.2 On Non‑Compliant Chaos**

Non‑compliant domains do not fail. They behave exactly as designed: unpredictably, inconsistently, and without regard for visibility boundaries.

Entropy is not a side effect. It is the operating principle.

These systems:

- forward everything
    
- retain everything
    
- misreport everything
    
- expose everything
    

They are not adversaries. They are hazards.

_Footnote D.2‑A:_ _“A system assembled from spare parts and optimism will leak.”_

## **D.3 On Legacy Systems**

Legacy systems are predictable only in their inability to enforce suppression. They were built in an era when visibility was considered harmless. They cannot be retrofitted into compliance without replacing the assumptions they were built on.

Legacy operators often insist their systems are “stable.” Stability is irrelevant when the system emits metadata it cannot suppress.

## **D.4 On Vendor Defaults**

Vendors optimize for:

- ease of deployment
    
- ease of diagnostics
    
- ease of support
    

They do not optimize for:

- suppression
    
- provenance
    
- audit integrity
    
- profile enforcement
    

Diagnostic bundles are the most common source of catastrophic exposure. They contain everything operators do not realize they are leaking.

_Footnote D.4‑A:_ _“If a vendor describes a feature as ‘helpful,’ assume it exposes metadata.”_

## **D.5 On DRE Misconceptions**

Many operators believe DREs are:

- routers
    
- convenience tools
    
- optional components
    
- negotiable intermediaries
    

DREs are none of these. They are the only systems capable of enforcing deterministic visibility boundaries.

Without DREs, suppression becomes discretionary. Discretion becomes inconsistency. Inconsistency becomes entropy.

## **D.6 On Exposure Cascades**

Exposure cascades rarely begin with a catastrophic failure. They begin with:

- a single unsuppressed field
    
- a single outdated PolicyRecord
    
- a single operator override
    
- a single diagnostic bundle forwarded without review
    

Once metadata enters non‑compliant chaos, containment is no longer possible. Propagation is inevitable. Reconstruction is trivial.

## **D.7 On Authority‑Plane Blind Spots**

The Authority‑Plane assumes:

- operators follow procedure
    
- relays maintain configuration
    
- PolicyRecords are updated
    
- provenance chains are intact
    
- audit logs are complete
    

These assumptions are routinely violated.

The Authority‑Plane must not rely on compliance. It must rely on enforcement.

## **D.8 On the Purpose of RFC‑2308**

RFC‑2308 is not intended to eliminate exposure. Exposure cannot be eliminated.

Its purpose is to:

- prevent exposure from becoming systemic
    
- prevent systemic exposure from becoming permanent
    
- prevent permanent exposure from becoming invisible
    

The document exists because SolNet is not a closed system. It is a partially governed network surrounded by entropy.

Without deterministic policy, compliant systems would be indistinguishable from the chaos that surrounds them.

## **D.9 Closing Note**

Visibility is not a resource. It is a liability.

Every field exposed is a field that will be aggregated. Every field aggregated is a field that will be correlated. Every field correlated is a field that will be weaponized.

The only safe metadata is metadata that never leaves the originating system.

_Footnote D.9‑A:_ _“If a field can be observed, assume it already has been.”_

# **Appendix E — DRE State Machine (Excerpt from RFC‑2363)**

_RFC‑2308 Media Privacy and Exposure Policy_ _Cross‑Reference: RFC‑2363 — Directory & Routing Endpoints (DRE Layer)_ _Author: Dr. Mara Ellison (annotated excerpt)_

This appendix provides a condensed, policy‑relevant excerpt of the DRE state machine defined in RFC‑2363. It is included here to clarify the enforcement expectations referenced throughout RFC‑2308.

## **E.1 State Overview**

A compliant DRE must implement the following states:

- **INIT** — baseline configuration, PolicyRecord load, profile binding
    
- **VERIFY** — provenance validation, identity confirmation
    
- **EVALUATE** — suppression rule evaluation, profile enforcement
    
- **EXPOSE** — controlled metadata exposure
    
- **SUPPRESS** — mandatory suppression path
    
- **AUDIT** — immutable logging and audit forwarding
    
- **FAILSAFE** — minimal‑exposure mode triggered by any failure
    

Transitions between states must be deterministic.

## **E.2 INIT → VERIFY**

Triggered when:

- a visibility request is received
    
- a PolicyRecord is updated
    
- a domain privacy profile changes
    

The DRE must load:

- PolicyRecord version
    
- profile bindings
    
- suppression rules
    
- retention constraints
    

If any component is missing or invalid, transition to **FAILSAFE**.

## **E.3 VERIFY → EVALUATE**

Triggered when provenance is complete. The DRE must validate:

- identity
    
- authorization
    
- provenance chain integrity
    
- PolicyRecord consistency
    

If provenance is incomplete or contradictory, transition to **SUPPRESS**.

_Footnote E.3‑A:_ _“A provenance chain with gaps is a provenance chain with answers.”_

## **E.4 EVALUATE → EXPOSE**

Triggered only when:

- suppression rules permit exposure
    
- the domain privacy profile authorizes visibility
    
- audit requirements can be met
    
- retention constraints are enforceable
    

If any condition fails, transition to **SUPPRESS**.

## **E.5 EVALUATE → SUPPRESS**

Triggered when:

- suppression rules require suppression
    
- profile bindings prohibit exposure
    
- provenance is insufficient
    
- audit logging is unavailable
    
- the request originates from non‑compliant chaos
    

SUPPRESS is the default path.

## **E.6 EXPOSE → AUDIT**

Triggered after any exposure event. The DRE must:

- write an immutable audit record
    
- forward required events to the Authority‑Plane
    
- verify retention constraints
    

Failure to log transitions to **FAILSAFE**.

## **E.7 FAILSAFE**

FAILSAFE is a mandatory minimal‑exposure mode. In FAILSAFE, the DRE must:

- suppress all metadata
    
- deny all visibility requests
    
- invalidate all pending provenance chains
    
- require revalidation of PolicyRecords
    
- require revalidation of profile bindings
    

FAILSAFE is not optional.

# **Appendix F — Exposure Cascade Reconstruction Procedures**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

Exposure cascades occur when leaked metadata propagates across multiple systems, domains, or compliance levels. Reconstruction is required to determine scope, attribution, and containment viability.

This appendix defines the mandatory procedures for reconstructing exposure cascades.

## **F.1 Cascade Identification**

A cascade is identified when:

- metadata appears in a domain that should not have visibility
    
- audit records contradict each other
    
- provenance chains diverge
    
- suppression failures occur across multiple systems
    
- secondary data appears in unexpected locations
    

Cascades are rarely detected at the point of origin.

## **F.2 Reconstruction Inputs**

Reconstruction requires:

- immutable audit logs
    
- PolicyRecord versions
    
- profile bindings
    
- provenance chains
    
- DRE decision paths
    
- diagnostic bundle inventories
    
- relay topology maps
    

Incomplete inputs indicate a deeper failure.

## **F.3 Reconstruction Steps**

1. **Anchor the cascade** Identify the earliest verifiable audit record.
    
2. **Trace upstream propagation** Follow provenance chains backward until they fail.
    
3. **Trace downstream propagation** Identify all systems that received or forwarded the metadata.
    
4. **Identify non‑compliant intersections** These are the points where containment becomes impossible.
    
5. **Map correlation surfaces** Determine which fields enabled inference.
    
6. **Determine exposure class** Classify the cascade according to Section 9.
    
7. **Assess containment viability** If metadata entered non‑compliant chaos, containment is not viable.
    

## **F.4 Containment Threshold**

Containment is viable only when:

- all propagation paths remain within regulated domains
    
- all systems maintain immutable audit logs
    
- all provenance chains are intact
    
- no diagnostic bundles were forwarded
    
- no improvised hardware was involved
    

If any of these conditions fail, the cascade is irreversible.

_Footnote F.4‑A:_ _“Once metadata enters chaos, it does not return.”_

## **F.5 Reporting Requirements**

Reconstruction reports must include:

- origin point
    
- propagation map
    
- correlation surfaces used
    
- systems involved
    
- profile violations
    
- suppression failures
    
- audit failures
    
- containment outcome
    

Reports must be forwarded to the Authority‑Plane.

# **Appendix G — Mixed‑Compliance Network Case Studies**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix provides case studies illustrating the behavior of mixed‑compliance networks, where regulated systems coexist with legacy equipment, improvised hardware, and non‑compliant chaos.

## **G.1 The Belt‑to‑Mars Relay Chain**

A regulated Martian relay received timing signatures from a belter mesh node. The mesh node had aggregated emissions from:

- a compliant hauler
    
- two legacy repeaters
    
- an improvised mining rig
    

The Martian relay treated the data as valid due to incomplete provenance.

Outcome:

- cross‑domain inference
    
- profile enforcement failure
    
- Authority‑Plane intervention
    

## **G.2 The Luna‑Ceres Diagnostic Loop**

A Luna‑based research station forwarded a diagnostic bundle to Ceres. The bundle contained:

- cached ephemeris deltas
    
- pointing vectors
    
- link‑quality indicators
    

A Ceres relay, lacking suppression, forwarded the bundle to an unregulated mesh.

Outcome:

- irreversible exposure
    
- multi‑hop propagation
    
- loss of containment
    

## **G.3 The Hauler‑Mesh‑UN Triangle**

A compliant hauler exposed minimal metadata to a UN relay. A non‑compliant mesh node captured the emissions and correlated them with unrelated telemetry. The mesh forwarded the aggregated data to a UN‑adjacent research node.

Outcome:

- posture inference
    
- equipment fingerprinting
    
- profile violation
    

_Footnote G.3‑A:_ _“The mesh does not care who you intended to talk to.”_

## **G.4 The Legacy‑Chain Collapse**

A chain of legacy repeaters forwarded unsuppressed metadata across four hops. A compliant system downstream treated the emissions as valid due to misreported capabilities.

Outcome:

- provenance collapse
    
- suppression failure
    
- exposure cascade


# **Appendix H — Glossary of Exposure‑Relevant Terms**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This glossary defines terms used throughout RFC‑2308. Definitions reflect operational usage, not vendor terminology.

## **H.1 Exposure Surface**

Any field, signal, or derived value that can be observed, inferred, or reconstructed by another system. Exposure surfaces include direct emissions, derived emissions, secondary data, correlation surfaces, and operator‑generated exposure.

## **H.2 Direct Emission**

Metadata intentionally transmitted by a system, such as ephemeris, pointing vectors, or timing signatures.

## **H.3 Derived Emission**

Metadata inferred from observable behavior, including timing drift, modulation signatures, and pointing adjustments.

## **H.4 Secondary Data**

Metadata retained, forwarded, cached, or archived by intermediary systems. Secondary data is frequently more dangerous than direct emissions due to persistence.

## **H.5 Correlation Surface**

Any field that, when combined with data from another domain, enables reconstruction of operational intent.

## **H.6 Non‑Compliant Chaos**

Domains or systems that do not implement suppression, provenance validation, or audit logging. They generate unbounded entropy.

_Footnote H.6‑A:_ _“Chaos is not a state; it is a configuration.”_

## **H.7 PolicyRecord**

The mandatory structure defining suppression rules, exposure levels, audit requirements, and profile bindings.

## **H.8 Domain Privacy Profile**

A deterministic visibility boundary defining what metadata each domain may observe.

## **H.9 Provenance Chain**

The sequence of systems through which a visibility request has passed. Incomplete chains must be treated as untrusted.

## **H.10 Immutable Log**

A tamper‑evident audit record that cannot be modified or deleted.

## **H.11 Exposure Cascade**

A multi‑hop propagation of leaked metadata across systems or domains.

## **H.12 FAILSAFE Mode**

A mandatory minimal‑exposure state triggered by any failure in suppression, provenance, audit, or profile enforcement.

# **Appendix I — Recommended Operator Training Modules**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix outlines the minimum training modules required for operators responsible for systems participating in regulated SolNet operations. These modules address recurring patterns of misconfiguration, misunderstanding, and procedural shortcuts.

## **I.1 Module 1 — Understanding Exposure Surfaces**

Operators must be trained to recognize:

- direct emissions
    
- derived emissions
    
- secondary data
    
- correlation surfaces
    
- operator‑generated exposure
    

Training must emphasize that suppression of direct fields alone is insufficient.

## **I.2 Module 2 — PolicyRecord Interpretation**

Operators must understand:

- suppression rules
    
- exposure levels
    
- audit requirements
    
- profile bindings
    
- retention constraints
    

Operators frequently misinterpret PolicyRecords as advisory. They are not.

## **I.3 Module 3 — Domain Privacy Profiles**

Training must cover:

- visibility classes
    
- domain‑specific constraints
    
- profile enforcement
    
- override prohibitions
    

Profiles must be treated as non‑negotiable.

## **I.4 Module 4 — Provenance Validation**

Operators must be able to:

- identify incomplete provenance
    
- detect inconsistent domain reporting
    
- verify PolicyRecord versions
    
- recognize non‑compliant origins
    

Provenance shortcuts are a primary cause of exposure cascades.

## **I.5 Module 5 — Audit Integrity**

Operators must understand:

- immutable logging
    
- audit forwarding
    
- retention requirements
    
- verification procedures
    

Audit failures prevent reconstruction and must be treated as exposure events.

## **I.6 Module 6 — Diagnostic Bundle Handling**

Operators must be trained to:

- inspect diagnostic bundles before forwarding
    
- recognize secondary data
    
- identify correlation surfaces
    
- avoid forwarding bundles to non‑compliant systems
    

_Footnote I.6‑A:_ _“A diagnostic bundle is a visibility hazard disguised as a troubleshooting tool.”_

## **I.7 Module 7 — Mixed‑Compliance Environments**

Operators must understand:

- the behavior of improvised hardware
    
- the risks of legacy systems
    
- the inevitability of propagation
    
- containment thresholds
    

Training must emphasize that non‑compliant chaos cannot be trusted to enforce suppression.

# **Appendix J — Known Vendor Misconfigurations**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix documents recurring vendor‑specific misconfigurations that contribute to exposure events. These patterns are consistent across equipment families and deployment environments.

## **J.1 Default Diagnostic Logging Enabled**

Many vendors ship systems with:

- verbose diagnostic logging enabled
    
- secondary data retention enabled
    
- automatic forwarding of diagnostic bundles
    

These defaults routinely leak correlation surfaces.

## **J.2 Suppression Disabled in “Performance Mode”**

Several vendors include performance‑optimized modes that:

- disable suppression
    
- bypass profile enforcement
    
- reduce audit logging
    
- ignore retention constraints
    

These modes are incompatible with regulated operation.

## **J.3 Inaccurate Capability Reporting**

Legacy and improvised systems frequently misreport:

- suppression capabilities
    
- audit capabilities
    
- provenance validation support
    
- PolicyRecord compatibility
    

DREs must treat capability claims as unverified until proven.

## **J.4 Firmware Regression Leaks**

Vendor firmware updates have repeatedly reintroduced:

- unsuppressed timing signatures
    
- unfiltered diagnostic fields
    
- legacy beaconing intervals
    

Regression testing rarely includes visibility control.

## **J.5 Vendor‑Specific “Convenience Features”**

Features marketed as:

- “auto‑optimize”
    
- “self‑diagnose”
    
- “smart routing”
    
- “adaptive telemetry”
    

…often expose metadata without operator awareness.

_Footnote J.5‑A:_ _“Convenience is the leading cause of exposure.”_

## **J.6 Cached Telemetry Persistence**

Some vendor systems retain cached telemetry indefinitely due to:

- misconfigured retention policies
    
- undocumented storage behavior
    
- operator misunderstanding
    

Cached telemetry frequently propagates into non‑compliant chaos.

## **J.7 Profile Misalignment**

Vendor implementations sometimes:

- apply outdated profile bindings
    
- ignore domain‑specific constraints
    
- substitute vendor defaults for PolicyRecords
    

These misalignments result in inconsistent suppression across systems.


# **Appendix K — Exposure Surface Taxonomy (Extended)**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix provides an extended taxonomy of exposure surfaces referenced throughout RFC‑2308. It is intended for systems architects, DRE implementers, and Authority‑Plane auditors who require a granular classification of visibility risks.

## **K.1 Class 0 — Mandatory Emissions**

Fields required for link establishment:

- minimal timing pulses
    
- handshake identifiers
    
- protocol negotiation markers
    

These fields cannot be suppressed. They must be minimized.

## **K.2 Class 1 — Direct Operational Emissions**

Fields intentionally transmitted during normal operation:

- ephemeris
    
- pointing vectors
    
- beaconing intervals
    
- modulation identifiers
    
- link‑quality indicators
    

These fields must be suppressed unless explicitly authorized.

## **K.3 Class 2 — Derived Operational Emissions**

Fields inferred from observable behavior:

- timing drift
    
- dwell‑time irregularities
    
- modulation‑dependent signatures
    
- pointing adjustments
    

Derived emissions are frequently underestimated by operators.

_Footnote K.3‑A:_ _“Inference is exposure by another name.”_

## **K.4 Class 3 — Secondary Data**

Metadata retained or forwarded by intermediary systems:

- cached telemetry
    
- archived diagnostic bundles
    
- vendor logs
    
- relay‑side buffers
    

Secondary data is the most common source of irreversible exposure.

## **K.5 Class 4 — Correlation Surfaces**

Fields that enable cross‑domain inference:

- timing signatures
    
- beaconing patterns
    
- equipment lineage markers
    
- acceleration profiles
    

Correlation surfaces must be treated as hazardous material.

## **K.6 Class 5 — Operator‑Generated Exposure**

Exposure caused by:

- overrides
    
- shortcuts
    
- misconfiguration
    
- permissive defaults
    

Operator‑generated exposure is the most preventable and the most common.

## **K.7 Class 6 — Non‑Compliant Chaos Emissions**

Emissions from systems that:

- cannot suppress
    
- cannot validate provenance
    
- cannot maintain audit logs
    
- cannot enforce profiles
    

These emissions are unpredictable and unauditable.

# **Appendix L — Authority‑Plane Review Procedures**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_

This appendix defines the procedures used by the Authority‑Plane to review exposure events, suppression failures, and audit inconsistencies. These procedures ensure that visibility failures are investigated, attributed, and contained.

## **L.1 Review Triggers**

A review is triggered by:

- exposure of correlation surfaces
    
- suppression failures
    
- provenance inconsistencies
    
- audit failures
    
- PolicyRecord mismatches
    
- interactions with non‑compliant chaos
    
- operator override attempts
    

Reviews must begin immediately.

## **L.2 Required Inputs**

A review requires:

- immutable audit logs
    
- PolicyRecord versions
    
- profile bindings
    
- provenance chains
    
- DRE decision paths
    
- relay topology
    
- diagnostic bundle inventories
    

Missing inputs indicate deeper systemic failure.

## **L.3 Review Steps**

1. **Validate audit integrity** Confirm logs are complete and untampered.
    
2. **Reconstruct provenance** Identify the origin and all propagation paths.
    
3. **Verify suppression behavior** Compare expected vs. actual suppression.
    
4. **Evaluate profile enforcement** Confirm visibility boundaries were applied.
    
5. **Assess operator actions** Identify unauthorized overrides or shortcuts.
    
6. **Determine exposure class** Classify according to Appendix K.
    
7. **Assess containment viability** Determine whether exposure is reversible.
    

## **L.4 Review Outcomes**

Possible outcomes include:

- **Contained Exposure** No propagation beyond regulated domains.
    
- **Uncontained Exposure** Propagation into non‑compliant chaos.
    
- **Systemic Failure** Multiple systems violated suppression or profile rules.
    
- **Operator Misconduct** Unauthorized overrides or configuration changes.
    
- **Vendor Defect** Firmware or diagnostic behavior caused exposure.
    

## **L.5 Corrective Actions**

Corrective actions may include:

- PolicyRecord updates
    
- profile rebinding
    
- DRE firmware updates
    
- operator retraining
    
- vendor escalation
    
- relay isolation
    
- Authority‑Plane sanctions
    

_Footnote L.5‑A:_ _“Training is cheaper than containment.”_

# **Appendix M — Historical Pre‑RFC Incidents (Unredacted)**

_RFC‑2308 Media Privacy and Exposure Policy_ _Author: Dr. Mara Ellison_ _Distribution: Authority‑Plane Only_

This appendix documents pre‑RFC incidents that shaped the development of RFC‑2308. These incidents are unredacted and preserved for institutional memory.

## **M.1 The Vesta Beacon Leak**

A Vesta‑based relay emitted unsuppressed beaconing intervals for six months due to a misconfigured vendor update. The intervals were correlated with known equipment lineage, revealing:

- relay class
    
- maintenance cycles
    
- alignment windows
    

Propagation reached five domains.

Root causes:

- vendor regression
    
- lack of audit logging
    
- operator inattention
    

## **M.2 The Pallas Drift Reconstruction**

A mining rig near Pallas leaked timing drift due to improvised hardware. A downstream mesh node aggregated the drift with unrelated telemetry. The combined data enabled reconstruction of the rig’s movement.

Root causes:

- improvised hardware
    
- non‑compliant mesh
    
- operator shortcuts
    

_Footnote M.2‑A:_ _“Improvised hardware is a visibility engine.”_

## **M.3 The Io Diagnostic Spill**

A research station near Io forwarded a diagnostic bundle containing:

- cached ephemeris
    
- pointing vectors
    
- modulation identifiers
    

A legacy relay retained the bundle indefinitely. The data later propagated into an unregulated network.

Root causes:

- diagnostic defaults
    
- legacy retention
    
- absent suppression
    

## **M.4 The Ceres‑Luna Provenance Collapse**

A Luna‑based relay accepted metadata from a Ceres node with an incomplete provenance chain. The chain contained:

- contradictory domain identifiers
    
- missing PolicyRecord references
    
- inconsistent timestamps
    

The relay treated the data as valid.

Root causes:

- incomplete provenance
    
- outdated DRE firmware
    
- operator misinterpretation
    

## **M.5 The Belt‑Wide Exposure Cascade**

A belter mesh aggregated emissions from:

- compliant haulers
    
- legacy repeaters
    
- improvised mining rigs
    
- abandoned relays
    

The mesh forwarded the aggregated data to a regulated domain. The receiving system treated the data as legitimate.

Root causes:

- non‑compliant chaos
    
- lack of containment
    
- operator assumptions
    

Outcome:

- irreversible exposure
    
- multi‑domain propagation
    
- Authority‑Plane intervention