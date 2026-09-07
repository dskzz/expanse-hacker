# RFC‑2353 — L1 Relay Advertisement Protocol

*SolNet Standards Corpus — multi-institutional authorship*

**Status:** Normative (working draft — not yet graduated to `docs/vault/New RFCs/`, which
currently still holds the earlier ~24-line stub. Graduate only with the user's explicit
sign-off, per the repo's surgical-corrections-only rule for that folder.)

---

### 0. Document Preface

*Doctrinal Integrity Council*

This RFC SHALL define the Relay Advertisement Protocol (RAP): what a relay discloses, what it withholds, and why the difference is not open to reinterpretation. None of this is complicated. It has simply been explained before, to people who did not want to hear it.

A relay, for readers requiring the reminder, is a SolNet Layer‑1 node that forwards traffic between other nodes without itself being either endpoint of the communication. It is infrastructure, not a participant, and it has no session-layer identity of its own — a property this RFC exists specifically to protect, not merely to mention in passing.

Relays exist because most of SolNet cannot reach its destination in a single hop, cannot know in advance whether a given hop will succeed, and cannot assume any relay remembers the last attempt. Absent some declared basis for choosing among relays, every routing decision made above Layer 1 would be a guess dressed up as a decision. RAP is that declared basis. Nothing more should be assumed of it, and nothing less will be accepted.

RFC‑2353 is subordinate to RFC‑2352 (Privacy & Metadata Minimization) and RFC‑2350 (Canonical Addressing). Where a provision here appears to conflict with either, it does not — the provision is defective, and the Council expects it corrected without further discussion.

RelayAdvertisement is a Layer‑1 behavior. It SHALL NOT be extended to carry ServicePlane routing logic, Namespace Plane resolution semantics, or session-layer identity. Implementers who find this restriction inconvenient are directed to the layer where the desired behavior belongs. It was never going to be this one.

Doctrinal purity SHALL be preserved. This is not a negotiable design goal, and the Council will not be revisiting it because a vendor found it inconvenient. Implementers seeking a more permissive interpretation elsewhere are welcome to look. They will not find one issued by this Council.

---

### 1. Purpose and RelayAdvertisement Structure

*Relay Neutrality Commission*

The Relay Advertisement Protocol (RAP) governs how SolNet relays announce presence, capability, scheduling posture, and admission state. RAP exists because higher layers cannot make routing, reservation, or admission decisions about a relay they cannot observe. This document defines what a relay MUST disclose, what it MAY disclose, and — with equal weight — what it MUST NOT disclose.

A relay's advertisement is not a status report. It is a bounded, deliberately incomplete signal, and the incompleteness is the point. Every few years, someone proposes making advertisements more informative — finer-grained load figures, real queue depth, live topology hints — always framed as a routing improvement. It has never once produced a routing improvement. It has, on each occasion, produced a better way to target a relay or map a sector. RAP resolves this by advertising coarse, quantized, policy‑derived indicators rather than raw operational state. Implementers proposing otherwise are welcome to review the Commission's minutes from the last four attempts. Repeated, and occasionally expensive, experience has demonstrated that enforcing simplicity is the best guarantee against vendor-instigated disaster.

#### 1.1 What RAP Enables

The RelayAdvertisement record enables:

- **Dynamic routing** — ServicePlane[^1] path selection using relay-declared media and capability, not inferred behavior.
- **Session continuity** — reselection of an equivalent relay on handover, without renegotiating capability from zero.
- **Reservation negotiation** — advance indication of whether a relay supports reservation endpoints, prior to invoking RFC‑2370.
- **Admission control** — coarse signaling of whether a relay is accepting sessions, without exposing why.
- **Relay selection by ServicePlane** — a basis for choosing among multiple relays advertising the same media profile.

#### 1.2 Structural Overview

A RelayAdvertisement is a TLV-structured record, emitted at a canonical interval (defined in Section 6, Temporal Stability Review Board). It carries a fixed set of required fields and a bounded set of optional fields. The required fields identify the relay, its capability class, its coarse scheduling posture, its coarse admission posture, its media profile, and a privacy-preserving load class. The optional fields extend this for relays that support reservations, tightbeam terminals, or vendor-neutral capability extensions.

Field-level definitions, encodings, and canonical ordering are the responsibility of the Canonical Behavior Registry (Section 2) and are not restated here. This section defines what the record is for, not its byte layout.

#### 1.3 Interaction with Other Planes

Relays constitute the operational backbone of the LocationPlane[^2]. The ServicePlane consumes RelayAdvertisement records to maintain session continuity and to negotiate reservations; it does not participate in relay selection at the physical or media layer. This document defines only the advertisement, not ServicePlane selection logic, and any behavior specific to session continuity SHALL be treated as out of scope here.

RelayAdvertisement records MAY be cached by Namespace Plane[^3] discovery services (N2, N3) for the purpose of relay lookup. Caching MUST NOT be used to construct a persistent profile of a relay's advertisement history. A cache that retains advertisement history beyond the canonical interval is a Namespace Plane concern, addressed in the relevant Namespace Plane RFC, not here.

#### 1.4 Invariance Constraint

Relay behavior SHALL remain invariant with respect to the identity or origin of the requesting party. A relay's advertised capability, scheduling posture, and admission posture MUST NOT vary based on who is asking. Adaptive advertisement — presenting different capability or admission signals to different observers — is non-compliant regardless of the operational justification offered.

#### 1.5 Consumption by Higher-Layer Routing Logic

RelayAdvertisement is not itself a routing decision. It is raw material for one, consumed by ServicePlane path selection and, increasingly, by inference layers that weight and correlate advertised fields against observed outcomes rather than treating them as static configuration. This RFC has no opinion on how a consuming layer forms that judgment, and it does not need one — Section 11 (Doctrinal Alignment) states the actual boundary. What this Commission does have an opinion on is the proposal, now arriving in an AI-shaped wrapper instead of a routing-improvement wrapper, that RAP fields should carry finer resolution so that a model downstream can "reason better." The model reasons just as well on a coarse, honest signal as on a precise, exposing one — better, in fact, since a coarse signal is harder to game. This Commission expects to review this proposal again, in a fifth wrapper, before the decade is out.

#### 1.6 Propagation Semantics

A RelayAdvertisement is not addressed to a specific recipient, and it does not solicit one. It is emitted; whatever happens after that is not part of the same exchange. There is no acknowledgment, no reply, and no expectation of either — handwaves, not handshakes. Any response a receiving party eventually generates, including a route forming back toward the origin, is an independently-routed event on its own schedule, governed by whatever RFC actually defines it, not by this one.

A relay MAY forward a RelayAdvertisement it received from a neighboring relay, extending the advertisement's reach beyond the neighbors who directly observed the original emission. A forwarding relay MUST NOT alter any field of a forwarded record other than HopCount (Section 2.1), and MUST NOT re-emit a forwarded record on its own canonical interval as though it were the relay's own advertisement. A record modified in transit, in any field other than the one this section explicitly permits, is not a forwarded advertisement. It is a forged one, and Section 10 already covers what happens to those.

Forwarding is hop-limited. HopCount decrements by exactly one at each forwarding relay; a relay receiving a record with HopCount already at zero MUST NOT forward it further. The maximum value a freshly originated HopCount may carry, denoted H_max, is set by Authority policy and is not published as a protocol constant in this document, for the same reason T_adv (Section 6) is not: it is a deployment parameter, not a wire-format guarantee.

This Commission is aware of the shape of the tradeoff on either side of H_max. Set it too low, and an advertisement dies before reaching anyone who could have used it — a dead end, reachable in principle, invisible in practice. Set it too high, and stale reachability information outlives its usefulness and becomes difficult to correct once the topology it described has moved on — not wrong exactly, just no longer true, and indistinguishable from current at a glance. Both failure modes are real. Neither is solved by picking an extreme. This Commission expects deployments to tune H_max toward the middle of that range and revise it when the sector's actual topology proves the current value wrong, which is a more honest process than pretending a single number would have been correct everywhere from the start.

---

### 2. TLV Registry and Field Definitions

*Canonical Behavior Registry*

Every field carried in a RelayAdvertisement record is registry-assigned. This section states what exists; it does not entertain proposals for what should exist instead. That discussion, if it must happen, happens in Section 14 (Extension Process), and this Registry offers no assurance about how it will be received there. A TLV not listed below is not a RelayAdvertisement field. It is an extension, or it is nothing.

TLVs within a RelayAdvertisement record MUST appear in ascending type-code order. A record presenting TLVs out of canonical order is malformed and MUST be discarded. This is stated once and governs every TLV sequence in this document.

Type codes not listed in this registry are reserved. Unrecognized TLVs encountered during parsing MUST be ignored; their presence does not invalidate the record. A TLV whose length field is inconsistent with the width defined in this registry is malformed and MUST be discarded. This does not affect the interpretation of any other TLV in the same record — one bad field condemns itself, not the rest of the record.

#### 2.1 Required TLV Registry

| Type Code | Name | Length | Encoding | Required |
|---|---|---|---|---|
| 0x01 | RelayID | 16 bytes, fixed | Canonical L1 address per RFC‑2350 | Yes |
| 0x02 | RelayCapabilityMask | 2 bytes, fixed | Bitfield per Section 3 | Yes |
| 0x03 | SchedulingCapacityHint | 1 byte, fixed | Enumerated capacity class (C0–C5) | Yes |
| 0x04 | AdmissionPolicyHint | 1 byte, fixed | Enumerated admission class (A0–A3) | Yes |
| 0x05 | MediaProfile | 1 byte, fixed | Enumerated profile identifier | Yes |
| 0x06 | RelayLoadClass | 1 byte, fixed | Enumerated load class (LOW/MED/HIGH) | Yes |
| 0x0A | HopCount | 1 byte, fixed | Unsigned integer, decremented per forwarding hop (Section 1.6) | Yes |

Seven rows, seven required TLVs. A RelayAdvertisement record missing any one of them is not partially compliant. It is invalid in its entirety and MUST be discarded on that basis alone.

RelayLoadClass admits exactly three values: LOW, MED, HIGH. Table 2.1 was exhaustive on this point the last three times an implementer asked whether a fourth value could be accommodated for "finer granularity." It could not then, and it cannot now.

RelayID (0x01) is opaque to every component except those responsible for its assignment and verification under RFC‑2350. It does not encode vendor lineage, hardware class, manufacturing batch, or deployment environment, and this Registry will not entertain a submission that attempts to smuggle any of the four in under a different field name. RelayID is fixed as the first TLV in every RelayAdvertisement, regardless of which optional TLVs are present or absent.

HopCount (0x0A) is a plain unsigned integer, not a coarse-quantized class like the six fields above it. This is not an inconsistency. A hop count decremented by discrete relays is already the coarsest a whole-number counter can be; further quantizing it would only obscure how many hops remain without changing what the field is doing. This Registry sees no reason to smooth a value for the sake of matching a pattern that does not apply to it.

#### 2.2 Optional TLV Registry

| Type Code | Name | Length | Encoding | Required |
|---|---|---|---|---|
| 0x07 | ReservationSupport | 1 byte, fixed | Boolean flag, per RFC‑2370 | No |
| 0x08 | CapabilityExtensions | 4 bytes, fixed | Vendor-neutral extension mask, registry-assigned | No |
| 0x09 | EphemerisHint | 8 bytes, fixed | Tightbeam terminal hint, per RFC‑2306/2364 | No |

Absence of an optional TLV is not a negative assertion. A relay omitting ReservationSupport has declared nothing on the matter — not even "no." Receivers requiring a determination MUST query the reservation endpoint directly, per RFC‑2370. This Registry will not resolve that ambiguity by adding a fourth boolean state.

#### 2.3 Field Width Discipline

Every field in this registry is fixed-width. There are no variable-length fields in Sections 2.1–2.2, and none may be introduced into them without a new RFC — not a revision, not an erratum — a new RFC. Fixed width is what makes canonical ordering and malformed-record detection possible without a content-aware parser. A vendor proposing variable-length encoding "for efficiency" has misread the purpose of this registry and is directed back to the first sentence of this section.

All numeric fields use unsigned integer encoding in network byte order. Bitmasks are encoded least-significant-bit first within each byte. This registry does not define string fields, and it will not define one to accommodate a vendor's preferred debugging format, however reasonably the request is framed.

#### 2.4 Canonical Wire Example

The following illustrates a minimal conforming RelayAdvertisement containing only required TLVs, in canonical order. Values are illustrative and do not correspond to an assigned RelayID.

```
01 10 [16 bytes: RelayID]
02 02 [2 bytes: RelayCapabilityMask]
03 01 [1 byte: SchedulingCapacityHint = C2]
04 01 [1 byte: AdmissionPolicyHint = A2]
05 01 [1 byte: MediaProfile = RF]
06 01 [1 byte: RelayLoadClass = MED]
0A 01 [1 byte: HopCount = H_max]
```

Each entry follows Type–Length–Value order. Length fields are informational for parser convenience only; they MUST match the fixed width defined in this registry and MUST NOT be used to justify a differently sized value. A length field disagreeing with the registry-defined width indicates a malformed record, not a permitted variant.

---

### 3. Capability Masks

*Canonical Behavior Registry*

RelayCapabilityMask (TLV 0x02) is a 2-byte bitfield defined by Table 3.1. Bit position determines meaning, and meaning does not vary by media, vendor, or deployment. A relay that sets a bit not defined in Table 3.1, before that bit has been registered as an extension, has produced a malformed capability mask — not an early implementation of a future feature.

**Table 3.1 — Core Capability Bits**

| Bit | Value | Meaning |
|---|---|---|
| 0 | 0x01 | RF Relay |
| 1 | 0x02 | Tightbeam Terminal |
| 2 | 0x04 | Hybrid Relay |
| 3 | 0x08 | Scheduling Relay |
| 4 | 0x10 | Reservation-Capable |
| 5 | 0x20 | Mobility-Aware |
| 6 | 0x40 | DTN-Aware |
| 7 | 0x80 | Privacy-Hardened |

Eight bits, eight meanings. A relay MAY set any combination consistent with its actual capability, and MAY NOT set a bit for a capability it does not implement. This Registry does not audit that claim. It only defines what the claim means once made.

#### 3.2 Extended Capability Bits and Vendor Neutrality

*Cross-Vendor Convergence Office*

Bits 8 through 15 of RelayCapabilityMask are reserved for extension use: faction-specific relay types, vendor-specific capabilities, and future SolNet layers not yet defined at Layer 1. Extension bits SHALL be registered with CBR prior to use. An unregistered extension bit is not a private signaling channel. It is an interoperability defect awaiting discovery.

No extension bit may be defined, calibrated, or documented in any way that would let a receiving relay infer vendor identity or product lineage. Convergence requires that a bit mean the same thing regardless of who set it, and CVCO will not certify an extension registration that fails this test — regardless of how the requesting vendor characterizes its own intentions in the registration filing.

All extended bits MUST be non-exposing, in the same sense required of every other field in this record: a bit MAY declare a capability, and MUST NOT be constructed such that its pattern of use, timing, or combination with other bits reveals internal state, queue depth, or topology. "Non-exposing" has been misunderstood by vendors before submitting an extension request, and it will be evaluated the same way each time it is misunderstood again.

#### 3.3 Extension Identity and Naming

*Cross-Vendor Convergence Office*

An extension registration's semantic identity is its assigned UUID-S7, not the name attached to the filing. Names exist for human documentation only; they carry no interpretive weight and MUST NOT be relied upon by any implementation for parsing, matching, or trust decisions. A vendor is free to name a registered extension whatever it likes. Convergence is unaffected either way, because convergence was never going to depend on what something is called. This Office has noted, more than once, that naming choices in prior filings appeared selected for their marketing value rather than their descriptive accuracy, and observes only that the distinction is now, and remains, irrelevant to conformance.

---

### 4. Scheduling Capacity & Admission Policy Hints

*Relay Neutrality Commission*

Both fields in this section answer the same underlying question: is this relay usable right now? Neither answers the question anyone actually wants answered — how usable, by whom, and why not. That gap is intentional. A precise answer to either would let an observer reconstruct queue depth, session count, or peer preference from the outside, and this Commission has reviewed enough proposed "improvements" to this section to know exactly where that leads.

#### 4.1 Scheduling Capacity Classes

| Class | Meaning |
|---|---|
| C0 | No Capacity |
| C1 | Limited |
| C2 | Moderate |
| C3 | Ample |
| C4 | High |
| C5 | Unrestricted |

These classes are policy-derived, not state-derived. C3 does not mean "more available slots than C2 by some fixed quantity." It means the relay's configured policy currently places it in the C3 band. The ordinal relationship between classes is the only guarantee this Registry makes; the magnitude behind it is not specified and MUST NOT be inferred.

**Update rules:**

- If a relay's SchedulingCapacityHint would change due to a policy update, then the relay MUST wait until the next canonical interval (Section 6) to emit the new value; it MUST NOT emit an out-of-cycle advertisement to reflect the change early. Exception: none within this section. Early emission is itself a timing signal, and this section will not grant an exception that TSRB would only have to close later.
- If a relay's computed classification would vary based on short-term traffic conditions, then the relay MUST discard that computation and re-derive the class from policy inputs stable across the canonical interval. SchedulingCapacityHint reflecting instantaneous load is not a more accurate hint. It is a leak with a table lookup attached.
- SchedulingCapacityHint MUST NOT be derived from, or made to correlate with, queue depth, peer identity, or scheduling backlog, under any calibration method.

#### 4.2 Admission Policy Classes

| Class | Meaning |
|---|---|
| A0 | Closed |
| A1 | Restricted |
| A2 | Open |
| A3 | Preferential (e.g., reserved sessions) |

Admission decisions are made by the ServicePlane, by reservation endpoints (RFC‑2370), and by relay scheduling logic. AdmissionPolicyHint does not make the decision. It states, coarsely, where the decision currently lands.

- When a relay's admission class is A0 or A1, the hint conveys that condition; it MUST NOT convey why. The relay MUST NOT expose session count, capacity threshold, or the identity of any peer whose presence affected the classification.
- If a relay's admission class changes, then the new value is emitted at the next canonical interval, per the same non-early-emission rule as Section 4.1. Admission state is not exempt from that constraint merely because it is more interesting to an observer than scheduling capacity.

Every proposal to make AdmissionPolicyHint more granular arrives with a routing justification. Every implementation of that granularity has instead produced a peer-preference map. This Commission has stopped asking why that keeps happening and started simply declining the proposal on submission.

#### 4.3 Interaction with Reservation Negotiation

SchedulingCapacityHint and AdmissionPolicyHint are advance signals only. A relay advertising C3/A2 has not guaranteed that a subsequent reservation request under RFC‑2370 will succeed — it has indicated that a request is not obviously futile. Reservation endpoints MAY decline a request from a relay advertising favorable hints, and that decline is not a contradiction of the advertisement. The advertisement was never a commitment. It was a coarse filter for where to spend a negotiation attempt.

---

### 5. Minimization Constraints

*Non-Exposure Enforcement Bureau*

RelayAdvertisement, correctly implemented, permits inference of exactly one thing: that a relay exists and holds a stated set of coarse properties. Any implementation permitting inference of anything beyond that has produced an exposure event, whether or not the implementer categorizes it that way.

A RelayAdvertisement record generated under high load SHALL be structurally and byte-for-byte identical in format to one generated under idle conditions. The only permitted difference is in the enumerated class values Sections 4 and 7 allow fields to carry, and even that is bound by the update constraints those sections impose. Structural stability is not a style preference. An implementation whose record layout varies with operational state has created a side channel, regardless of whether any single field appears compliant in isolation.

This Bureau maintains the following non-exhaustive list of prohibited inferences:

| Field | Prohibited Inference | Governing Section |
|---|---|---|
| RelayLoadClass | Queue depth, instantaneous utilization | 4.1 |
| AdmissionPolicyHint | Session count, peer-specific decisions | 4.2 |
| SchedulingCapacityHint | Scheduling backlog | 4.1 |
| RelayCapabilityMask / CapabilityExtensions | Vendor identity, hardware lineage | 3.2 |
| Advertisement emission timing | Load correlation via timing analysis | 6 |
| Record structure or length | Operational state via structural variation | 5 (this section) |

The list is non-exhaustive because enumerating every method of extracting forbidden information would take longer than closing the extraction points, and because a method not yet invented is not automatically permitted just for lacking a name on this list.

An implementation found deriving any of the above — whether by direct field inspection, statistical correlation across multiple advertisements, or timing analysis — has committed an exposure violation and SHALL be referred for certification review under Section 12. This Bureau does not require that the derivation succeed to open a review. Attempting it is sufficient.

Namespace Plane caching of RelayAdvertisement records (Section 1.3) remains subject to this section in full. A cache is not exempt from minimization requirements because it did not generate the record itself.

#### 5.5 Applicability to Inferential and Learned Analysis

*Non-Exposure Enforcement Bureau*

The prohibitions in this section apply without regard to the sophistication of the analysis attempting to defeat them. A statistical model, a trained classifier, or any other inferential method applied to a sequence of RelayAdvertisement records is held to the same standard as a human analyst with a spreadsheet: if the output permits recovery of queue depth, session count, or vendor lineage, the implementation that produced the underlying records has committed an exposure violation, regardless of how much computation was required to extract it. This Bureau does not grant exemptions for methods it finds impressive.

#### 5.6 HopCount as a Disclosed, Structural Exception

HopCount (Section 2.1) is exempted from the general prohibition on inferable operational state, and this Bureau states that exemption plainly rather than pretending the field does not do what it does. A relay observing HopCount values across multiple advertisements from different points of origin can, with enough patience, reconstruct a coarse map of relative distances within the sector. That is not a defect this Bureau failed to catch. It is the mechanism working as designed — a RelayAdvertisement cannot propagate hop by hop without some field recording how many hops it has already traveled, and a field that records that necessarily discloses it to anyone counting.

This exemption is narrow and does not extend by implication to any other field in this record. HopCount discloses distance. It does not disclose identity, load, capability, or admission state, and an implementation using HopCount correlation to infer any of those has exceeded what this exception covers and has committed an exposure violation under this section like any other. This Bureau permits one leak because the alternative is a protocol that cannot propagate at all. It does not, on that basis, permit a second.

---

### 6. Timing & Interval Rules

*Temporal Stability Review Board*

The canonical interval, denoted T_adv, is the fixed period at which a RelayAdvertisement record is emitted. Its value is set by Authority policy, not selected by individual relays, vendors, or deployments. This section does not publish a numeric value for T_adv, because T_adv is not a protocol constant — it is a per-deployment policy parameter, and this Board declines to imply otherwise by printing a number that implementers would treat as one.

**Emission rules:**

- If a relay's next scheduled emission would occur before T_adv has elapsed since the prior emission, then the relay MUST delay emission until T_adv has elapsed. Exception: initial advertisement upon provisioning or network rejoin, per Section 8.
- When T_adv has elapsed, emission follows; exception: a relay in a DTN partition with no reachable peer, which MAY defer emission until connectivity is restored without that deferral constituting non-compliance.
- Emission cadence MUST NOT vary with load, admission state, or scheduling capacity. A relay experiencing congestion and a relay experiencing none SHALL emit on identical schedules. Anything else converts the schedule itself into a signal Section 5 already prohibits other fields from carrying.

An advertisement issued even slightly ahead of schedule is not a rounding error. It is a data point. This Board has reviewed cases in which a consistent early-emission pattern, aggregated over enough cycles, reconstructed a load curve the relay's other fields were specifically designed not to reveal. The interval exists to prevent exactly this, and it does not stop preventing it just because the deviation was small. No other institution in this corpus appears to share this Board's concern for what a few dozen milliseconds can reveal over time. This Board finds that, if anything, confirms the point.

Jitter, where introduced for purposes unrelated to this protocol (e.g., collision avoidance at the media layer), MUST be independent of any state this document requires to remain hidden. Jitter correlated with load is not jitter. It is RelayLoadClass, delivered through a side door.

---

### 7. Media Profiles (RF, Tightbeam, Hybrid)

*Environmental Neutrality Assessment Group*

MediaProfile (TLV 0x05) declares supported physical media: RF, tightbeam, or hybrid. It does not declare, and MUST NOT be construed to declare, expected performance under any particular environmental condition. This has been noted elsewhere in this document. It is noted again here, in the section whose entire purpose is making sure it doesn't get forgotten.

#### 7.1 RF Relay Profile

The RF Relay Profile uses RF media with standard scheduling, and assumes environmental neutrality under nominal atmospheric and free-space conditions. RF propagation degrades under solar interference and heavy particulate environments; this profile does not encode that degradation, and implementers relying on MediaProfile alone to predict RF performance have skipped a step this Group already told them not to skip.

#### 7.2 Tightbeam Terminal Profile

The Tightbeam Terminal Profile uses tightbeam media, carries ephemeris hints (EphemerisHint, Section 2.2), and is reservation-heavy and mobility-aware. Tightbeam alignment is sensitive to thermal drift and vibration in ways RF is not. A terminal certified under one thermal regime and deployed under another has not been under-tested by a small margin. It has not been tested for its actual operating environment at all.

#### 7.3 Hybrid Relay Profile

The Hybrid Relay Profile combines RF and tightbeam with multi-media scheduling and extended capability mask usage (Section 3.2). A hybrid relay's failure modes are the union of 7.1 and 7.2, not their average. Certification testing that exercises RF and tightbeam separately, but never both under simultaneous environmental stress, has certified two relays that happen to share a chassis.

**Reminder (this Group will repeat this in the Appendix as well):** test in the environmental conditions of intended deployment, not in a climate-controlled lab. Vacuum, thermal cycling, and radiation exposure affect RF propagation and tightbeam alignment differently, and a MediaProfile whose certification did not account for this has not been tested. It has been assumed. This Group does not certify assumptions.

---

### 8. Operational Considerations for Sparse Topologies

*Operational Relay Authority*

In sparse-topology Belt sectors, relay contact isn't continuous, and pretending otherwise in this section wouldn't help anybody out here. When relay rejoins network after gap — spin-shift, occlusion, DTN partition, whatever cause — it MAY emit one initial RelayAdvertisement outside canonical interval, to get visible again fast. After that, it hold to T_adv same as every other relay. That exception belong to relays coming back online, not to relays looking for excuse to update more than policy allow.

Admission fairness: AdmissionPolicyHint and RelayCapabilityMask MUST NOT bias against low-band nodes, older hardware, or nodes from particular sector. Relay pass what come, fair-share. Relay quietly favoring high-capability peer while advertising A2 (Open) to everyone else isn't degrading graceful — that's lying by omission. Lying still is.

Hybrid relays in spin-shift zones SHALL degrade smooth, not sharp. Sudden tightbeam drop makes whole sector go dark if RF fallback isn't standing ready *before* drop, not scrambled together after. Operators plan for that ahead of time, same as always — you plan for break before break come.

Vacuum drift hits RF and tightbeam chains different ways, and hybrid relay serving both media has to account for both — not just whichever medium vendor happened to test more.

#### 8.5 Fair Treatment Under Automated Admission Logic

*Operational Relay Authority*

Same rule hold when hand on admission logic isn't person no more. Relay letting some model quietly favor certain peer while advertising A2 to rest, that's still lying by omission. Machine lying still is. Authority don't care if person or process pick favorite; result same, sector still shut out. You build logic, you answer for what it do.

---

### 9. Vendor Neutrality Requirements

*Cross-Vendor Convergence Office*

This Office's jurisdiction is not limited to capability masks (Section 3.2). It extends to every field in this record where a vendor might reasonably believe a small deviation would go unnoticed. It would not.

Convergence testing SHALL verify that two conforming implementations from different vendors, presented with identical inputs, produce byte-identical RelayAdvertisement records — excepting only RelayID, which is per-relay by design (Section 2.1). Any divergence beyond that exception indicates non-conformance, regardless of whether the divergence affects interoperability in the vendor's own testing.

No vendor documentation, marketing material, or configuration default MAY imply that a field in this record behaves differently, more precisely, or more favorably on that vendor's hardware than the registry defines. Convergence is not a target implementers approach. It is a requirement they either meet or do not.

---

### 10. Security and Exposure Notes

*Non-Exposure Enforcement Bureau*

This section addresses exposure and integrity risks beyond the field-level minimization already covered in Section 5.

Three threat categories are considered: (a) passive observation of advertisement patterns to infer state that Section 5 already prohibits leaking directly; (b) a spoofed or replayed advertisement presented by a party other than the relay it purports to describe; (c) selective forwarding or suppression of advertisements by an intermediate cache.

For (b): RelayID alone does not provide origin authentication. An implementation relying on RelayAdvertisement for admission or routing decisions without a separate authentication mechanism at a higher layer has misapplied this record. RAP is a capability and posture disclosure. It is not an identity assertion, and treating it as one is the implementer's error, not this document's gap.

For (c): Namespace Plane caches (Section 1.3) that selectively suppress or delay advertisements from specific relays introduce a bias vector functionally equivalent to the admission-fairness violations Section 8 already addresses at the relay level. This Bureau considers cache-level suppression an exposure and fairness concern in equal measure, and will treat it as such regardless of which layer's document eventually specifies its remedy.

A fourth category is considered here for the first time: (d) a forwarding relay altering HopCount outside the decrement rule Section 1.6 defines. Decrementing by more than one, or by less than one, or not at all, is not a timing anomaly or a rounding choice. It is a forged record under Section 1.6's own terms, whether the intent was to kill an advertisement's reach early or to extend it past what H_max was configured to allow. This Bureau does not distinguish between the two motives for the purpose of certification review; both produce a record that no longer reports what actually happened at that hop, and that is the only fact this Bureau requires to open a case.

#### 10.4 Reliability Assessment Is Not This Document's Concern

*Non-Exposure Enforcement Bureau*

Whether a relay's advertised posture correlates with its actual behavior over time is a real question, and an implementation attempting to answer it through sustained observation across many advertisements and outcomes is doing legitimate work. Treating a single RelayAdvertisement, or a short run of them, as sufficient evidence of anything is not. This Bureau has reviewed enough incident reports beginning with "the relay had always advertised A2, so we assumed" to consider that specific failure pattern closed. The inference belongs elsewhere. Building reliance on this record instead of on that inference is this document's boundary, not this document's gap.

---

### 11. Doctrinal Alignment Notes

*Doctrinal Integrity Council*

This document does not introduce new doctrine. It applies existing doctrine to a Layer‑1 advertisement mechanism, and a reader surprised by that application has not read RFC‑2352 or RFC‑2360 with sufficient attention.

The invariance doctrine requires that observable protocol behavior not vary with unstated internal conditions. Sections 4 through 7 satisfy this requirement field by field. Section 5 satisfies it at the structural level. Together they satisfy it completely, which is the only acceptable outcome. The Council notes this once, here, rather than section by section — repeating it there would imply the possibility of a partial pass. There is no partial pass.

Section 5.6's disclosed exception for HopCount does not weaken this conclusion. A doctrine that pretended a hop-limited propagation mechanism could exist without a hop counter would be lying about arithmetic, not preserving purity. Acknowledging a structural necessity is not the same defect as tolerating an avoidable one, and this Council trusts the distinction is not the sort of thing it will need to explain twice.

Where this RFC references RFC‑2370 (Reservation Negotiation) or RFC‑2306/2364 (Tightbeam), those documents govern their own domains. This RFC does not reinterpret them. Any apparent conflict is a defect in this document, correctable, and not evidence that either referenced document requires revision to accommodate this one's convenience.

#### 11.4 Boundary With Inferential and Automated Routing Systems

*Doctrinal Integrity Council*

Higher-layer routing logic, including systems that learn preference or confidence from observed outcomes, MAY consume RelayAdvertisement fields as one input among others. Such systems SHALL NOT alter RelayAdvertisement emission, parsing, or interpretation at Layer 1, regardless of what they conclude. The distinction is the same one this Council has already drawn between observation and participation: a system may watch this layer as closely as it likes. It does not get to edit what it is watching. Readers who require a historical justification for this position are directed to the record of automated systems that, in the previous century, were permitted exactly this kind of latitude and used it to redefine the semantics they were meant to observe. The record is not subtle, and this Council has long since stopped expecting it to be read before the question is asked again anyway. It sees no reason to restate it a second time regardless.

---

### 12. SPERB Procedural Rules

*SolNet Physical‑Layer Exposure Review Board*

Conformance to this RFC is subject to review by this Board. Review may be initiated upon certification application, upon complaint, or at this Board's own discretion; no distinction in outcome attaches to which of the three initiated it.

A finding of non-compliance under Sections 2 through 10 SHALL result in one of the following, at this Board's determination: (a) a compliance notice with a remediation period, for a first-instance, correctable defect; or (b) immediate revocation of certification, for exposure violations under Section 5 or Section 10, for a repeated defect following a prior compliance notice, or for any attempt to characterize a violation as a "feature" in vendor-facing documentation.

Revocation is a terminal action. It is not appealable to this Board, and this Board does not maintain a process for making it so.

This Board is named the SolNet Physical‑Layer Exposure Review Board, abbreviated SPERB and pronounced SPEAR‑B. Documentation, correspondence, or certification filings that render this pronunciation as "Sperb" will not be rejected on that basis alone, but this Board reserves the right to note the error in its response, every time, for as long as the error continues.

---

### 13. Test Vectors and Parsing Tests

#### 13.1 Advertisement Parsing Tests

*Canonical Behavior Registry*

A conforming parser MUST be tested against, at minimum: (a) a record with all required TLVs in canonical order — MUST parse successfully; (b) a record missing one required TLV — MUST be rejected as invalid, per Section 2.1; (c) a record with TLVs out of ascending order — MUST be rejected as malformed, per Section 2; (d) a record containing one unrecognized type code — MUST parse successfully, ignoring only the unrecognized TLV, per Section 2; (e) a record containing one TLV with an incorrect length field — MUST discard that TLV and successfully parse the remainder, per Section 2; (f) a record with all seven required TLVs, including HopCount, in canonical order — MUST parse successfully, restated separately from case (a) because a Registry update that changes a required field count invalidates every existing conformance suite silently, and this Registry does not trust "the old suite still probably works" as a testing philosophy.

Six cases. A parser passing five of six has not mostly passed — it has failed whichever case it failed, and Table 2.1 does not grade on a curve.

#### 13.2 Admission and Scheduling Decision Tests

*Relay Neutrality Commission*

Given a set of RelayAdvertisement records with varying SchedulingCapacityHint and AdmissionPolicyHint values, a conforming ServicePlane implementation MUST: select among C3–C5/A2–A3 relays preferentially for new sessions; treat C0/A0 relays as unavailable for new sessions regardless of any other advertised capability; and fall back to a lower-capacity relay only when no relay advertising sufficient capacity is reachable. If a selection implementation weights any factor not derivable from the advertised TLVs — inferred load, historical performance, peer reputation — that weighting is out of scope for this RFC and MUST NOT be represented as RAP-conformant behavior. This Commission has reviewed "peer reputation" as a selection factor before. It did not improve routing then either.

#### 13.3 Minimization Tests

*Non-Exposure Enforcement Bureau*

A conforming implementation SHALL be tested for the absence of the following, not merely the presence of the required fields: correlation between RelayLoadClass transitions and externally observable traffic events; correlation between advertisement emission timing and load, per Section 6; and recoverability of vendor identity from RelayCapabilityMask or CapabilityExtensions bit patterns across a sample of advertisements from different vendors. A test suite verifying only that required TLVs are present and correctly typed has verified structure. It has not verified compliance, and this Bureau does not consider the two equivalent.

#### 13.4 Propagation and Forwarding Tests

*Relay Neutrality Commission + Non-Exposure Enforcement Bureau*

A conforming relay implementing forwarding (Section 1.6) MUST be tested against, at minimum: (a) forwarding a record with HopCount decremented by exactly one — MUST succeed and MUST NOT alter any other field; (b) receiving a record with HopCount already at zero — MUST NOT forward it under any circumstance; (c) a record whose HopCount has been incremented rather than decremented relative to its previously observed emission — MUST be treated as forged under Section 10(d); (d) a record whose HopCount has decreased by more than one at a single hop — MUST be treated as forged under Section 10(d); (e) a record forwarded with any field other than HopCount altered from its original emission — MUST be treated as forged under Section 10(d), regardless of whether the altered field's new value is independently well-formed.

Cases (c) through (e) exist because a well-formed lie is still a lie. This Bureau has no interest in whether a forged record parses cleanly. It has already failed the test that matters.

---

## Appendices

### Appendix A — Rationale

*Doctrinal Integrity Council*

This appendix explains why RAP takes the shape it does. It is non-normative. A reader who requires this appendix to accept the normative sections has not been persuaded by anything else in this document, and this Council does not expect an appendix to succeed where thirteen sections did not.

RAP is minimal because a relay's advertised state is the one thing every layer above it is tempted to over-trust. The less a relay says, the less there is to over-trust. This is not an accident of drafting economy; it is the entire design principle. Every optional field this document does not define was considered and rejected on this basis, not overlooked.

RAP is one-way because a confirmed exchange implies a relationship, and RAP does not describe one. A relay advertising capability is not entering into an agreement with whoever reads the advertisement. It is speaking into a channel that happens to have listeners. Section 1.6's hop-limited propagation preserves that indifference at every hop: forwarding is a courtesy the network extends to reachability, not a chain of individually-negotiated relationships between relays.

RAP is coarse because precision is a liability disguised as a feature. Every enumerated class in this document (SchedulingCapacityHint, AdmissionPolicyHint, RelayLoadClass — HopCount excepted, for the reason given in Section 5.6) was chosen to answer exactly the question a consuming layer needs answered and no other question. A field that additionally answers questions nobody asked has not been generous. It has exposed something.

None of this required originality. It required declining, repeatedly, to add anything that was not required.

### Appendix B — Formal Proof Sketch

*Doctrinal Integrity Council + Non-Exposure Enforcement Bureau*

This appendix is non-normative and does not constitute a formal verification. It sketches, informally, why the field set defined in Section 2 does not permit reconstruction of any state this document prohibits disclosing, beyond the single disclosed exception in Section 5.6.

**Claim:** For any RelayAdvertisement record R, an observer with access to an arbitrary number of instances of R, and to no other information, cannot recover queue depth, session count, peer identity, vendor identity, or hardware lineage, and can recover only relative hop-distance from R's point of origin.

**Sketch:** Every field in R other than HopCount is drawn from a finite, registry-fixed enumeration (Section 2.1, Section 3.1) whose boundaries are policy-derived, not state-derived (Section 4.1, Section 4.2). A finite enumeration with policy-derived boundaries carries, by construction, no more information than the boundary itself specifies — an observer who recovers the class value has recovered the class, and nothing behind it, because nothing behind it was encoded in the first place. This holds independent of sample size: correlating one thousand instances of a three-valued class recovers, at most, the same three values with more confidence, not a fourth value or the field's underlying cause.

RelayID (Section 2.1) is opaque by registry mandate and carries no structure an observer could decompose. CapabilityExtensions (Section 3.2) is bound by the same non-exposing constraint as the core mask and by the UUID-S7 identity rule (Section 3.3), which severs any link between a bit's registered meaning and any human-readable or vendor-suggestive label.

HopCount is the one field this sketch cannot close. Its value is, by the propagation model in Section 1.6, a direct linear function of hop-distance from origin. No enumeration bound applies to it, and none could without breaking the field's only purpose. Section 5.6 already states this plainly rather than let this appendix discover it.

**Conclusion (informal):** the field set is closed under the minimization doctrine (Section 5) with exactly one disclosed, load-bearing exception. This Bureau considers that an acceptable place for a proof sketch to stop, since a proof sketch that also closed the one gap this document deliberately left open would be proving something false.

### Appendix C — Test Vector Overview

*Canonical Behavior Registry + Relay Neutrality Commission*

This appendix indexes the test vectors required by Section 13. It does not define new tests; a test suite implementing Section 13 in full has already satisfied this appendix, and a test suite that has not implemented Section 13 in full is not made compliant by reading this appendix instead.

| Vector Set | Defined In | Covers |
|---|---|---|
| Parsing conformance | Section 13.1 | Canonical ordering, required-field completeness, unrecognized-TLV tolerance, malformed-length handling |
| Admission and scheduling decisions | Section 13.2 | ServicePlane relay selection under varying capacity/admission classes |
| Minimization | Section 13.3 | Absence of load, timing, and vendor-identity correlation |
| Propagation and forwarding | Section 13.4 | HopCount decrement discipline, forgery detection under Section 10(d) |

A vendor may organize its own internal test harness however it likes. This Registry organizes this appendix by section number because that is the one organizing principle guaranteed not to go stale when a vendor reorganizes theirs.

*Operational Relay Authority — field note:* Test lab pass all four, sector still eat relay alive first winter, ya. Table tell you what to test. Table not tell you sector where relay actually sit — that ENAG job, that Authority job, table just table.

### Appendix D — Deployment Guidance

*Operational Relay Authority*

Pick H_max for sector you actually have, not sector you wish you had. Dense cluster near station, low H_max fine — everything close, hop don't need travel far to matter. Deep Belt, sparse relay chain strung out over million kilometer, H_max too low mean advertisement die a few hop out and half the sector never see it exist at all. No table in Appendix C tell you which sector you in. You out there. You know.

Watch H_max after storm season too. Topology that hold steady all year can lose three relay to a bad conjunction and suddenly your old H_max don't reach where it used to. Authority say again — tune it to what is, not what was.

*Environmental Neutrality Assessment Group*

Deployment guidance is not a substitute for Section 7's requirements; it is what implementers ask for after failing to follow Section 7's requirements and wanting a shorter document to blame instead. Test the media profile in the vacuum, thermal cycle, and radiation environment of actual intended deployment. This has been said in Section 7. It is said again here because deployment guidance that omitted it would not be guidance.

*Relay Neutrality Commission*

A relay's advertised capability MUST be configured to match what the relay can actually sustain, not what its hardware specification claims under laboratory conditions. This Commission has reviewed enough post-incident reports attributing a capacity mismatch to "the spec sheet said" to note, once, that the spec sheet is not this document, and this document is not obligated to defer to it.

### Appendix E — Security Considerations

*Non-Exposure Enforcement Bureau*

This appendix consolidates the exposure and forgery risks already stated individually in Sections 5, 5.6, and 10. It adds no new prohibition. It exists because an implementer reviewing this document section by section may fail to notice that these risks compound, and this Bureau has found that failure to notice compounding risk is, itself, a compounding risk.

In order of what this Bureau has found implementers most reliably get wrong, worst first:

1. Treating RelayID as an authentication credential (Section 10(b)) — the single most common failure this Bureau has reviewed, and the one most implementers are most confident they have not made.
2. Structural or timing side channels introduced by operational-state-dependent record variation (Section 5) — subtle, rarely intentional, and rarely caught by a test suite that only checks field values rather than record shape.
3. HopCount tampering (Section 10(d)) — the newest category in this document's history, and already, per this Bureau's early review, the fastest-growing one.
4. Assuming a single advertisement, or a short run of them, establishes reliability (Section 10.4) — not an exposure violation in itself, but the failure mode most likely to make an implementer stop looking for the other three.

This Bureau does not rank these by theoretical severity. It ranks them by how often it has actually had to open a case.

### Appendix F — Known Non-Compliant Patterns

*Non-Exposure Enforcement Bureau*

**The Quantized Leak.** A vendor implementation mapped RelayLoadClass to LOW/MED/HIGH correctly, then logged the underlying raw utilization value locally "for diagnostics only." A subsequent firmware update exposed that diagnostic log through an unrelated debug interface. The class value itself never left compliance. The number it was supposed to replace did, because a device that stores what it wasn't supposed to know will eventually find a door for it. This Bureau does not consider "for diagnostics only" a defense. It never has.

**The Helpful Cache.** A Namespace Plane cache implementation began annotating cached RelayAdvertisement records with a locally-computed "reliability score" derived from advertisement consistency over time, intending it as a convenience for downstream queries. The annotation was never part of the record. It was also, functionally, exactly the kind of inference Section 10.4 already tells implementers to perform elsewhere and not attach to this record. Convenience and compliance are not the same axis, and this Bureau has stopped being surprised at how often that needs restating.

*Relay Neutrality Commission*

**The Optimistic Capacity Class.** More than one vendor has shipped a relay that advertises SchedulingCapacityHint based on theoretical maximum throughput rather than sustained, policy-derived capacity, on the theory that the difference is "close enough in practice." It is not close enough in practice. It is close enough to get a ServicePlane implementation to select a relay that then cannot deliver, which is a worse outcome for everyone than an honest C2 would have been. This Commission has seen this exact justification before. It was wrong then too.

### Appendix G — Historical Context

*Doctrinal Integrity Council*

Before RAP, relay capability was communicated informally, inconsistently, and, in a majority of documented cases, not at all — a ServicePlane implementation either guessed at a relay's suitability from prior experience or discovered it empirically, mid-session, by failing. Neither approach scaled, and both produced routing decisions that were indistinguishable, after the fact, from luck. This document exists because "it worked last time" is not a protocol.

*Operational Relay Authority*

Before RAP, everybody build own way to say what relay do. One sector use signal strength as stand-in for everything — capacity, admission, load, all one number, nobody agree what number mean. Next sector over use something else entire. Ship come through, ship guess wrong, ship lose cargo or lose contact, and everybody call it bad luck 'cause nobody wrote down what actually happen.

RAP not fix everything out here. Storm still come, relay still die, sector still go quiet sometime with no warning. What RAP fix is smaller, but it matter: now when relay say C2, every relay everywhere mean same thing by C2. That alone save more cargo than any signal-strength trick ever did.

### Appendix H — SPERB Procedural Rules

*SolNet Physical‑Layer Exposure Review Board*

**H.1 Scope.** This appendix defines procedural rules governing this Board's review of RAP implementations, supplementing the summary already given in Section 12.

**H.2 Review Procedures.** Certification applications, complaints, and Board-initiated reviews are handled under an identical procedure regardless of origin, per Section 12. Applications alleging non-compliance under Section 10(d) (HopCount tampering) SHALL include the full observed sequence of HopCount values across hops, not a single sample; a single sample cannot distinguish tampering from ordinary propagation and this Board will not open a case on one.

**H.3 Audit Procedures.** Audits of deployed relay populations SHALL sample RelayAdvertisement emissions across at least one full canonical interval and SHALL include at least one forwarding relay, where a candidate for audit forwards traffic at all. An audit that samples only origin advertisements has not audited propagation, regardless of what its final report claims to have found.

**H.4 Enforcement Procedures.** Corrective directives, compliance notices, and revocation notices under Section 12 are issued by this Board and are not delegable to any sub-bureau acting independently. A sub-bureau identifying a violation refers it to this Board; it does not resolve it unilaterally, however confident it is in the finding.

**H.5 Communication Protocols.** All formal correspondence regarding RAP conformance SHALL use terminology as defined in this document and, where a term originates elsewhere, as defined in the shared corpus glossary (`solnet-glossary.md`).

**H.6 Naming and Formal Address Requirements.** All formal correspondence SHALL refer to this Board as SPERB, pronounced SPEAR‑B. Informal or phonetic contractions are discouraged and SHALL NOT appear in conformance claims, certification requests, or audit submissions.

### Appendix I — Implementation Notes

**I.1 Scope.** *Operational Relay Authority.* This appendix give practical note for implementing relay in physical, non-simulation deployment — not lab, not test bench, actual sector.

**I.2 Hardware Considerations.** *Environmental Neutrality Assessment Group.* Implementations SHALL ensure timing and emission hardware conforms to the canonical interval discipline of Section 6 under the full range of thermal and power conditions the deployment will actually see, not the range the bench happened to have available that week.

**I.3 Forwarding Relay Considerations.** *Operational Relay Authority.* Relay that forward — not just originate — need buffer enough to hold record long enough to decrement and re-emit without drift creeping into timing Section 6 already forbid. Cheap relay skip this, buffer too small, drop record under load 'stead of forward it clean. That not compliant fallback. That just failure wearing compliant clothes.

**I.4 Sector Topology Considerations.** *Operational Relay Authority.* H_max (Section 1.6) is a policy parameter, not a hardware one, but hardware still constrain what policy is realistic — relay with weak buffer, weak power budget, can't reliably forward at all, no matter what H_max sector authority pick. Know your hardware 'fore you promise your policy.

**I.5 Update and Maintenance Considerations.** *Environmental Neutrality Assessment Group.* Firmware updates MUST NOT alter emission timing, TLV ordering, or HopCount decrement behavior. An update that "improves" any of the three has not improved this protocol. It has left it.

### Appendix J — Organizational Structure

*SolNet Physical‑Layer Exposure Review Board*

**J.1 Scope.** This appendix defines the internal organizational bodies of SPERB relevant to RAP conformance. Full organizational detail is maintained in RFC-2352 Appendix J; this appendix restates only the bodies with direct RAP jurisdiction, correctly lettered.

**J.2 Directorate of Emission Neutrality (DEN).** Maintains the canonical Layer-1 emission profile RAP inherits. Not directly cited elsewhere in this document, since RAP's own emission discipline is Section 6's, not a fresh grant from DEN — but DEN's doctrine is upstream of Section 6 regardless.

**J.3 Non-Exposure Enforcement Bureau (NEEB).** Authors Sections 5, 5.6, and 10 of this document. Investigates exposure events and Section 10(d) forgery findings.

**J.4 Canonical Behavior Registry (CBR).** Authors Section 2 and Section 13.1 of this document. Maintains the authoritative TLV registry RAP's field set is drawn from.

**J.5 Cross-Vendor Convergence Office (CVCO).** Authors Sections 3.2, 3.3, and 9 of this document. Certifies extension registrations and vendor-convergence testing.

**J.6 Temporal Stability Review Board (TSRB).** Authors Section 6 of this document. Reviews canonical-interval compliance and timing-correlation findings.

**J.7 Environmental Neutrality Assessment Group (ENAG).** Authors Section 7 and Appendix I.2/I.5 of this document. Validates media-profile invariance under environmental variation.

**J.8 Relay Neutrality Commission (RNC).** Authors Sections 1, 1.5, 1.6, 4, and 13.2 of this document. Reviews relay-behavior conformance and forwarding discipline.

**J.9 Doctrinal Integrity Council (DIC).** Authors Sections 0, 11, and Appendices A and B of this document. Reviews cross-RFC doctrinal alignment.

**J.10 Registry of Canonical Terminology (RCT).** Not directly cited in this document's body; maintains the shared corpus glossary (`solnet-glossary.md`) this document footnotes into.

**J.11 Compliance Revocation Authority (CRA).** Not directly cited in this document's body; exercises the revocation authority Section 12 describes this Board as holding, where revocation is the disposition reached.

### Appendix K — Authorship

**K.1 Editorial Authority.** This document was prepared under the multi-institutional authorship model established for the SolNet Standards Corpus. Authorship reflects institutional roles rather than individual identity, per the convention already established for RFC‑2352.

**K.2 Primary Authors.**

- **Relay Neutrality Commission (RNC)** — relay behavior, forwarding neutrality, propagation semantics, admission policy hints.
- **Canonical Behavior Registry (CBR)** — TLV registry, capability masks, canonical advertisement structure, HopCount field definition.
- **Non-Exposure Enforcement Bureau (NEEB)** — prevention of queue-depth, peer-identity, and topology leakage; disclosure and scoping of the HopCount exception.
- **Doctrinal Integrity Council (DIC)** — invariance doctrine alignment, non-violation of RFC‑2352 and RFC‑2360, reconciliation of disclosed exceptions against doctrine.

**K.3 Contributing Bodies.**

- **Temporal Stability Review Board (TSRB)** — interval rules, timing-exposure review.
- **Environmental Neutrality Assessment Group (ENAG)** — RF/tightbeam environmental-state leakage review, deployment guidance.
- **Cross-Vendor Convergence Office (CVCO)** — vendor-identity encoding review in capability masks and extension registrations.
- **Operational Relay Authority (OPRA)** — sparse-topology and Belt-sector operational guidance, admission-fairness review.

**K.4 Custodian of Record.** The Canonical Behavior Registry (CBR) maintains the authoritative TLV registry and capability mask definitions referenced throughout this document.

---
---

**Editorial Notes (non-normative)**

[^1]: **ServicePlane** — the SolNet layer responsible for session continuity, reservation negotiation, and relay selection based on advertised capability. It consumes Layer‑1 data such as RelayAdvertisement, but does not itself perform relay selection at the physical or media layer.
[^2]: **LocationPlane** — the SolNet layer comprising the physical relay infrastructure itself: the relays, their supported media, and their Layer‑1 behavior. RelayAdvertisement is a LocationPlane artifact.
[^3]: **Namespace Plane** — the SolNet layer responsible for naming and discovery (e.g., N2 Local Namespace, N3 Service Discovery). It may cache LocationPlane data such as RelayAdvertisement for lookup purposes, but remains subject to the minimization constraints of Section 5 in doing so.

*For terms shared across multiple SolNet RFCs (DTN, canonical interval, Authority, invariance doctrine, referenced RFC numbers), see the shared corpus glossary (`solnet-glossary.md`).*

---

<!-- 2026-09-07: Appendices A-K written, per the ownership map in
     rfc-2353-design-notes.md. Note on Appendix J: this document uses correct J.1-J.11
     lettering for SPERB's sub-bureau list, unlike the real RFC-2352 canonical text,
     which uses leftover C.1-C.11 prefixes in its own Appendix J (a real, already-
     flagged corpus defect -- see db/CORPUS-INDEX.md's RFC-2352 entry and
     docs/NEXT-STEPS.md Track A2). Not called out inside the RFC text itself since an
     in-universe document has no reason to reference another document's typo -- noting
     it here instead so the contrast isn't read as a fluke next time someone reads
     both appendices side by side.

     Sec 13.4 (RNC + NEEB) added alongside the appendices to close the test-vector
     gap flagged in the previous commit -- HopCount-specific propagation/forgery
     cases. Sec 13.1 also picked up a sixth case (f) for the seven-required-TLV count
     change, in CBR's own voice, closing that residual gap too. Nothing in Sec 13 is
     now known-stale. -->

<!-- 2026-09-06 additions applied: §1.5 (RNC), §3.3 (CVCO), §5.5 (NEEB), §8.5 (OPRA),
     §10.4 (NEEB), §11.4 (DIC) -- see chat log / commit message for the source doctrine
     each pulls from (AI-routing doc, RULES.md canon, Conformance Trust doc). -->

<!-- 2026-09-06 follow-up tweaks: §8.5 rewritten for stricter article-dropping and the
     "[X] is" tautology-closer ("machine lying still is", not "machine-made lying is
     lying just the same"); §11.4 lightly sharpened for DIC's active public-contempt
     trait (not just weary condescension). Both traits are now recorded in
     voices/voice_profiles/SPERB Sub-Bureau Voices.md so future sections start from
     the sharpened cards, not the original ones. -->

<!-- 2026-09-06 consistency pass: §8 body (pre-dating the 8.5 addition) retrofitted
     with the stricter article-dropping rule, and given its own "[X] is" tautology
     callback ("Lying still is") echoing 8.5's "Machine lying still is" -- deliberate
     internal rhyme between the two, not a coincidence.

     Voice-intensity review: most sections were already close to their card's ceiling
     (ENAG's §7 in particular is already at the edge the Calibration Note allows --
     three separate reminders within one section -- and was left untouched on
     purpose). Three sections were genuinely underplaying their own tic and got a
     one-sentence bump (~10-15%, not a rewrite):
       - §0 (DIC): added a closing dismissal after the "not negotiable" line --
         "Implementers seeking a more permissive interpretation elsewhere are welcome
         to look. They will not find one issued by this Council."
       - §6 (TSRB): added a persecution-complex line after the load-curve
         reconstruction example -- "No other institution in this corpus appears to
         share this Board's concern... This Board finds that, if anything, confirms
         the point."
       - §13.2 (RNC): added a failure-history callback -- "This Commission has
         reviewed 'peer reputation' as a selection factor before. It did not improve
         routing then either." -- reinforces the same grudge already established in
         §1 and §4 without introducing a new one. -->

<!-- 2026-09-07 corpus-wide flag, not yet actioned: same article-dropping and
     tautology-closer discipline now locked for OPRA has NOT been checked against
     any other document in the corpus that uses OPRA (none currently do -- OPRA is
     new to RFC-2353 -- but worth remembering if OPRA gets reused elsewhere). -->

<!-- 2026-09-07 propagation-model gap closed. New required TLV: HopCount (0x0A,
     Sec 2.1), plus Sec 1.6 (RNC, the propagation model itself -- one-way,
     hop-limited, "handwaves not handshakes", H_max as an unpublished Authority
     policy parameter matching T_adv's treatment), Sec 5.6 (NEEB, discloses that
     HopCount necessarily leaks relative distance -- a narrow, named exception, not
     an opening for others), Sec 11 addendum (DIC, reconciles the exception against
     its own earlier "satisfies it completely" claim), and Sec 10 category (d)
     (NEEB, HopCount tampering as a forgery, closing Sec 1.6's forward-reference).
     Canonical wire example in Sec 2.4 updated to include the new required field.
     Sec 13 test vectors NOT yet updated with HopCount-specific cases -- see
     rfc-2353-design-notes.md's "Known residual gap" note. -->
