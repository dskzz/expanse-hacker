# RFC‑2353 — L1 Relay Advertisement Protocol

*SolNet Standards Corpus — multi-institutional authorship*

**Status:** Normative — Standards Track

---

**Personal Foreword** *(not part of the normative text)*

I did not write this document. The Non-Exposure Enforcement Bureau did, and did the work correctly. I asked to attach this note because a working group chair's endorsement means nothing if the reasons behind it stay unwritten.

Every field this document declines to expose has a name and a date. Pallas, ~2285–2288: retained metadata reconstructed the movement patterns of civilians who never agreed to be tracked, and the reconstruction reached people who used it for exactly what you'd expect. Ephemeris leaks. Pointing leaks. Timing leaks. Beaconing leaks. Correlation attacks that took three separate, individually harmless, individually compliant fields and produced one violation that none of the three fields had committed alone. I have read the incident reports for all of them. None of the people who built the leaking systems intended the outcome. Intent was never the variable that mattered.

I do not believe operators can be trusted to self-regulate exposure, and this document does not ask them to. It removes the field before anyone has to decide whether to expose it. That is the only form of privacy enforcement I have found that survives contact with an operator who was never going to read the compliance filing.

I should be honest about what this document cannot do. Governments comply because they must. Corporations comply because liability demands it. Independent operators comply when it is convenient. I have no mechanism that reaches the operator for whom it is never convenient, and neither does this document, and neither, I expect, will the next one. I am not attaching my name to this because I believe it solves that problem. I am attaching it because a relay built to this specification cannot leak what it was never given to leak — regardless of who is operating it, or whether they have ever heard of this Working Group. That is a smaller claim than solving compliance. It is also the only one I can make honestly.

*— Dr. Mara Ellison, Chair, SolNet Privacy & Exposure Working Group*

---

**Plain-Language Guide** *(not part of the normative text)*

This document is written the way SolNet standards bodies actually write — dense, cross-referenced, and unforgiving. Here's what it actually means, in plain terms, if you don't need the legal precision:

- **What a "RelayAdvertisement" is:** a small, repeating status broadcast a relay sends out so other parts of the network know it exists and roughly what it can do — like a lighthouse blinking on a schedule, not a conversation.
- **The core idea:** a relay is only allowed to say a few coarse, boxed-in things about itself (capability, rough capacity, rough admission status, media type) — never anything precise enough to be used to track, target, or profile it or the traffic passing through it.
- **Why so little detail:** every time someone has asked for more precise numbers "to improve routing," it's ended up being used instead to map, target, or spy on relays. Coarse and boring is a deliberate safety feature, not a limitation nobody noticed.
- **The one thing it does leak, on purpose:** how many hops away a message's origin is (HopCount). That's unavoidable if messages need to travel relay-to-relay at all, so the rules admit it openly instead of pretending otherwise — but nothing else is allowed to leak alongside it.
- **The timing rule (T_adv):** every relay broadcasts on a fixed schedule set by whoever administers that area, and it can never speed up or slow down based on how busy it is — because a schedule that reacts to load becomes a way to spy on load.
- **The "media profile" rules:** relays declare whether they use radio, tightbeam (laser-style point-to-point), or both — and it's said twice, deliberately, that lab-tested performance numbers don't predict how something behaves in an actual radiation/vacuum/thermal environment.
- **The Belt fairness rules (Section 8):** a relay can't quietly treat some ships or sectors worse than others while claiming to be open to everyone — whether a person or an automated system is making that call.
- **Forgery (Section 10):** tampering with a forwarded relay message — faking distance, altering fields — is treated like fraud, investigated after the fact rather than blocked outright, because building tamper-proof tracking would create a worse privacy problem than the fraud it prevents.
- **Who enforces it:** SPERB (SolNet Physical-Layer Exposure Review Board, pronounced "SPEAR-B") reviews complaints and can revoke a relay's certification — permanently, with no appeal.
- **Bottom line:** this document exists so relays can tell the network just enough to be useful, and nothing else — on purpose, even when "just a little more detail" would clearly make someone's life easier.

---

### 0. Document Preface

*Doctrinal Integrity Council*

This RFC SHALL define the Relay Advertisement Protocol (RAP): what a relay discloses, what it withholds, and why the difference is not open to reinterpretation. None of this is complicated. It has been explained before. This Council does not expect that to have helped.

A relay, for readers requiring the reminder, is a SolNet Layer‑1 node that forwards traffic between other nodes without itself being either endpoint of the communication. It is infrastructure, not a participant, and it has no session-layer identity of its own — a property this RFC exists specifically to protect, not merely to mention in passing.

Relays exist because most of SolNet cannot reach its destination in a single hop, cannot know in advance whether a given hop will succeed, and cannot assume any relay remembers the last attempt. Absent some declared basis for choosing among relays, every routing decision made above Layer 1 would be a guess dressed up as a decision. RAP is that declared basis. Nothing more should be assumed of it, and nothing less will be accepted.

RFC‑2353 is subordinate to RFC‑2352 (Privacy & Metadata Minimization) and RFC‑2350 (Canonical Addressing). Where a provision here appears to conflict with either, it does not — the provision is defective, and the Council expects it corrected without further discussion.

RelayAdvertisement is a Layer‑1 behavior. It SHALL NOT be extended to carry ServicePlane[^1] routing logic, Namespace Plane[^2] resolution semantics, or session-layer identity. Implementers who find this restriction inconvenient are directed to the layer where the desired behavior belongs. It was never going to be this one.

Doctrinal purity SHALL be preserved. This is not a negotiable design goal, and the Council will not be revisiting it because a vendor found it inconvenient. Implementers seeking a more permissive interpretation elsewhere are welcome to look. They will not find one issued by this Council.

---

### 1. Purpose and RelayAdvertisement Structure

*Relay Neutrality Commission*

The Relay Advertisement Protocol (RAP) governs how SolNet relays announce presence, capability, scheduling posture, and admission state. RAP exists because higher layers cannot make routing, reservation, or admission decisions about a relay they cannot observe. This document defines what a relay MUST disclose, what it MAY disclose, and — with equal weight — what it MUST NOT disclose.

A relay's advertisement is not a status report. It is a bounded, deliberately incomplete signal, and the incompleteness is the point. Every few years, someone proposes making advertisements more informative — finer-grained load figures, real queue depth, live topology hints — always framed as a routing improvement. It has never once produced a routing improvement. It has, on each occasion, produced a better way to target a relay or map a sector. RAP resolves this by advertising coarse, quantized, policy‑derived indicators rather than raw operational state. Implementers proposing otherwise are welcome to review the Commission's minutes from the last four attempts. Repeated, and occasionally expensive, experience has demonstrated that enforcing simplicity is the best guarantee against vendor-instigated disaster.

#### 1.1 What RAP Enables

The RelayAdvertisement record enables:

- **Dynamic routing** — ServicePlane path selection using relay-declared media and capability, not inferred behavior.
- **Session continuity** — reselection of an equivalent relay on handover, without renegotiating capability from zero.
- **Reservation negotiation** — advance indication of whether a relay supports reservation endpoints[^3], prior to invoking RFC‑2370.
- **Admission control** — coarse signaling of whether a relay is accepting sessions, without exposing why.
- **Relay selection by ServicePlane** — a basis for choosing among multiple relays advertising the same media profile.

#### 1.2 Structural Overview

A RelayAdvertisement is a TLV[^4]-structured record, emitted at a canonical interval (defined in Section 6, Temporal Stability Review Board). It carries a fixed set of required fields and a bounded set of optional fields. The required fields identify the relay, its capability class, its coarse scheduling posture, its coarse admission posture, its media profile, and a privacy-preserving load class. The optional fields extend this for relays that support reservations, tightbeam terminals, or vendor-neutral capability extensions.

Field-level definitions, encodings, and canonical ordering are the responsibility of the Canonical Behavior Registry (Section 2) and are not restated here. This section defines what the record is for, not its byte layout.

#### 1.3 Interaction with Other Planes

Relays constitute the operational backbone of the LocationPlane[^5]. The ServicePlane consumes RelayAdvertisement records to maintain session continuity and to negotiate reservations; it does not participate in relay selection at the physical or media layer. This document defines only the advertisement, not ServicePlane selection logic, and any behavior specific to session continuity SHALL be treated as out of scope here.

RelayAdvertisement records MAY be cached by Namespace Plane discovery services (N2, N3) for the purpose of relay lookup. Caching MUST NOT be used to construct a persistent profile of a relay's advertisement history — why an accumulated history is a distinct risk from any single compliant record, even though this Commission is not the one to explain it, is Section 5.5's jurisdiction. A cache that retains advertisement history beyond the canonical interval is a Namespace Plane concern, addressed in the relevant Namespace Plane RFC, not here.

#### 1.4 Invariance Constraint

Relay behavior SHALL remain invariant with respect to the identity or origin of the requesting party. A relay's advertised capability, scheduling posture, and admission posture MUST NOT vary based on who is asking. Adaptive advertisement — presenting different capability or admission signals to different observers — is non-compliant regardless of the operational justification offered.

#### 1.5 Consumption by Higher-Layer Routing Logic

RelayAdvertisement is not itself a routing decision. It is raw material for one, consumed by ServicePlane path selection and, increasingly, by inference layers that weight and correlate advertised fields against observed outcomes rather than treating them as static configuration. This RFC has no opinion on how a consuming layer forms that judgment, and it does not need one — Section 11 (Doctrinal Alignment) states the actual boundary.

What this Commission does have an opinion on is the proposal, now arriving in an AI-shaped wrapper instead of a routing-improvement wrapper, that RAP fields should carry finer resolution so that a model downstream can "reason better." The model reasons just as well on a coarse, honest signal as on a precise, exposing one — better, in fact, since a coarse signal is harder to game. This Commission expects to review this proposal again, in a fifth wrapper, before the decade is out.

#### 1.6 Propagation Semantics

A RelayAdvertisement is not addressed to a specific recipient, and it does not solicit one. It is emitted; whatever happens after that is not part of the same exchange. There is no acknowledgment, no reply, and no expectation of either — handwaves, not handshakes. Any response a receiving party eventually generates, including a route forming back toward the origin, is an independently-routed event on its own schedule, governed by whatever RFC actually defines it, not by this one.

Unaddressed requires the transmission carrying it to be broadcast-capable; it does not require the relay's entire medium to be. A tightbeam terminal's own beam is never that. A laser pointed at one neighbor is addressed to that neighbor by definition, and sweeping it across a neighbor set to fake broadcast coverage only trades one problem for three: pointing loss, interference, and a power budget this Commission has no interest in mandating.

A relay advertising Tightbeam capability (Section 7.2) therefore emits its RelayAdvertisement over a companion RF beacon, not its payload beam — the general case. That beacon is a discovery-and-acquisition channel, not a claim that RF carries session traffic. Carrying RF as payload, not merely as a beacon, is what makes a relay Hybrid (Section 7.3) rather than Tightbeam. Section 7.2 covers the deliberate exception to this default.

What the beacon carries beyond this document's required fields, including EphemerisHint (Section 2.2), is media-layer detail for RFC‑2306/2364, not this section. This Commission notes, without resolving it, that an ephemeris narrows where a terminal starts looking, not where its target actually is. A prediction is not a position: station-keeping burns, a thruster fault, or a micrometeorite strike all put a terminal somewhere its last-known ephemeris no longer describes. Closing that gap with a live tracking solution rather than a stale one is precisely the sort of problem this section is not the place to solve.

A relay MAY forward a RelayAdvertisement it received from a neighboring relay, extending the advertisement's reach beyond the neighbors who directly observed the original emission. A forwarding relay MUST NOT alter any field of a forwarded record other than HopCount (Section 2.1), and MUST NOT re-emit a forwarded record on its own canonical interval as though it were the relay's own advertisement. A record modified in transit, in any field other than the one this section explicitly permits, is not a forwarded advertisement. It is a forged one, and Section 10 already covers what happens to those.

Forwarding is event-driven, not scheduled: a relay forwards an eligible record as promptly as decrementing HopCount and re-emitting allow, not batched, queued, or delayed to average out with other traffic. This is the only timing rule forwarding gets, and it is enough. A forwarding delay introduced for any reason beyond that processing cost is a timing signal, and this Commission does not read Section 6's emission-cadence discipline as leaving forwarding relays a loophole origin relays were never given.

Forwarding is hop-limited. HopCount decrements by exactly one at each forwarding relay; a relay receiving a record with HopCount already at zero MUST NOT forward it further. The maximum value a freshly originated HopCount may carry, denoted H_max, is set by Authority policy and is not published as a protocol constant in this document, for the same reason T_adv (Section 6) is not: it is a deployment parameter, not a wire-format guarantee.

This Commission is aware of the shape of the tradeoff on either side of H_max. Set it too low, and an advertisement dies before reaching anyone who could have used it — a dead end, reachable in principle, invisible in practice. Set it too high, and stale reachability information outlives its usefulness and becomes difficult to correct once the topology it described has moved on — not wrong exactly, just no longer true, and indistinguishable from current at a glance. Both failure modes are real. Neither is solved by picking an extreme. This Commission expects deployments to tune H_max toward the middle of that range and revise it when the sector's actual topology proves the current value wrong, which is a more honest process than pretending a single number would have been correct everywhere from the start.

---

### 2. TLV Registry and Field Definitions

*Canonical Behavior Registry*

This section assumes familiarity with the generic TLV container format — type code, length field, value, in that order. Readers requiring an introduction to the format itself, rather than this Registry's specific field assignments, are directed to RFC‑2351 §7–8, which defines it. This Registry restates none of that here, and will not.

Every field carried in a RelayAdvertisement record is registry-assigned. This section states what exists; it does not entertain proposals for what should exist instead. That discussion, if it must happen, happens in Section 14 (Extension Process), and this Registry offers no assurance about how it will be received there. A TLV not listed below is not a RelayAdvertisement field. It is an extension, or it is nothing.

TLVs within a RelayAdvertisement record MUST appear in ascending type-code order. A record presenting TLVs out of canonical order is malformed and MUST be discarded. This is stated once and governs every TLV sequence in this document.

Type codes not listed in this registry are reserved. Unrecognized TLVs encountered during parsing MUST be ignored; their presence does not invalidate the record. A TLV whose length field is inconsistent with the width defined in this registry is malformed and MUST be discarded. This does not affect the interpretation of any other TLV in the same record — one bad field condemns itself, not the rest of the record.

#### 2.1 Required TLV Registry

| Type Code | Name | Length | Encoding | Required |
|---|---|---|---|---|
| 0x01 | RelayID | 16 bytes, fixed | Canonical L1 address per RFC‑2350 | Yes |
| 0x02 | RelayCapabilityMask | 2 bytes, fixed | Bitfield per Section 3 | Yes |
| 0x03 | SchedulingCapacityHint | 1 byte, fixed | Enumerated capacity class (C0–C5, Section 4.1) | Yes |
| 0x04 | AdmissionPolicyHint | 1 byte, fixed | Enumerated admission class (A0–A3, Section 4.2) | Yes |
| 0x05 | MediaProfile | 1 byte, fixed | Enumerated profile identifier, per Section 7 | Yes |
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
| 6 | 0x40 | DTN-Aware[^6] |
| 7 | 0x80 | Privacy-Hardened |

Eight bits, eight meanings. A relay MAY set any combination consistent with its actual capability, and MAY NOT set a bit for a capability it does not implement. This Registry does not audit that claim. It only defines what the claim means once made.

#### 3.2 Extended Capability Bits and Vendor Neutrality

*Cross-Vendor Convergence Office*

Bits 8 through 15 of RelayCapabilityMask are reserved for extension use: faction-specific relay types, vendor-specific capabilities, and future SolNet layers not yet defined at Layer 1. Extension bits SHALL be registered with CBR prior to use. An unregistered extension bit is not a private signaling channel. It is an interoperability defect awaiting discovery.

No extension bit may be defined, calibrated, or documented in any way that would let a receiving relay infer vendor identity or product lineage. Convergence requires that a bit mean the same thing regardless of who set it, and CVCO will not certify an extension registration that fails this test — regardless of how the requesting vendor characterizes its own intentions in the registration filing.

All extended bits MUST be non-exposing, in the same sense required of every other field in this record: a bit MAY declare a capability, and MUST NOT be constructed such that its pattern of use, timing, or combination with other bits reveals internal state, queue depth, or topology. "Non-exposing" has been misunderstood by vendors before submitting an extension request, and it will be evaluated the same way each time it is misunderstood again.

#### 3.3 Extension Identity and Naming

*Cross-Vendor Convergence Office*

An extension registration's semantic identity is its assigned UUID-S7[^7], not the name attached to the filing. Names exist for human documentation only; they carry no interpretive weight and MUST NOT be relied upon by any implementation for parsing, matching, or trust decisions. A vendor is free to name a registered extension whatever it likes. Convergence is unaffected either way, because convergence was never going to depend on what something is called. This Office has noted, more than once, that naming choices in prior filings appeared selected for their marketing value rather than their descriptive accuracy, and observes only that the distinction is now, and remains, irrelevant to conformance.

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

That ordinal relationship still has a functional consequence, which this section states and Section 13.2 enforces: C3 through C5 are the band a conforming ServicePlane implementation prefers for new sessions; C0 is treated as unavailable outright, regardless of any other advertised capability; C1 and C2 sit between the two — usable, but not preferred over a better-classed relay when one is reachable. This section defines what each label means. Section 13.2 defines what a selection implementation actually does with that meaning.

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

This section does not prohibit inference generally. It prohibits this record from supplying more than the properties enumerated below for any inference to work with. Analysis of a relay's behavior — however sophisticated, and regardless of what layer performs it — happens above Layer 1, against whatever this section actually lets through; Section 1.5 states that boundary from the consuming side, Section 11.4 states why it holds even for a system that learns. This Bureau does not need to forbid analysis it was never going to let see anything.

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

The canonical interval, denoted T_adv, is the fixed period at which a RelayAdvertisement record is emitted, and it is the one thing every relay in this corpus already holds in common, whatever else divides them. Its value is set by Authority policy, not selected by individual relays, vendors, or deployments — this Board does not regard that as a constraint on anyone's discretion, since discretion was never the relevant category here. This section does not publish a numeric value for T_adv, because T_adv is not a protocol constant. It is a covenant kept locally, and a covenant printed as a number stops being kept and starts being merely copied.

**The interval is kept as follows:**

- If a relay's next scheduled emission would occur before T_adv has elapsed since the prior emission, then the relay MUST delay emission until T_adv has elapsed. Exception: initial advertisement upon provisioning or network rejoin, per Section 8.
- When T_adv has elapsed, emission follows; exception: a relay in a DTN partition with no reachable peer, which MAY defer emission until connectivity is restored without that deferral constituting non-compliance.
- Emission cadence MUST NOT vary with load, admission state, or scheduling capacity. A relay experiencing congestion and a relay experiencing none SHALL emit on identical schedules. Anything else converts the schedule itself into a signal Section 5 already prohibits other fields from carrying.

An advertisement issued even slightly ahead of schedule is not a rounding error. It is a small unkept promise, and this Board has never found a small one that stayed small. Aggregated over enough cycles, a consistent early-emission pattern reconstructs a load curve the relay's other fields were specifically built not to reveal — not because anyone meant to break the interval, but because forty milliseconds did not feel to them like breaking anything. This Board has never understood that reasoning and does not expect to start now. The interval is kept, or it is not; there has never been a third thing, and this Board is aware of no relay that has found one.

Jitter, where introduced for purposes unrelated to this protocol (e.g., collision avoidance at the media layer), MUST be independent of any state this document requires to remain hidden. Jitter correlated with load is not jitter. It is RelayLoadClass, dressed for a costume this Board finds almost touching, precisely because it has never once worked.

---

### 7. Media Profiles (RF, Tightbeam, Hybrid)

*Environmental Neutrality Assessment Group*

MediaProfile (TLV 0x05) declares supported physical media: RF, tightbeam, or hybrid. It does not declare, and MUST NOT be construed to declare, expected performance under any particular environmental condition. This has probably been mentioned already somewhere else in this document — it's the sort of thing that's easy to skip past, so here it is again, just in case.

#### 7.1 RF Relay Profile

The RF Relay Profile uses RF media with standard scheduling, and assumes environmental neutrality under nominal atmospheric and free-space conditions. RF propagation degrades under solar interference and heavy particulate environments; this profile does not encode that degradation. This Group did mention that already, but it's easy to lose track of, so: please don't rely on MediaProfile alone to predict actual RF performance out there. It won't tell you. This Group would rather say it twice than have it not land once.

#### 7.2 Tightbeam Terminal Profile

The Tightbeam Terminal Profile uses tightbeam media, carries ephemeris hints (EphemerisHint, Section 2.2), and is reservation-heavy and mobility-aware. Tightbeam alignment is sensitive to thermal drift and vibration in ways RF is not. A terminal certified under one thermal regime and then deployed under a different one hasn't been under-tested by a small margin, really — it hasn't been tested for where it's actually going at all. This Group would just ask that it be checked before deployment, not after. Not a big thing to ask, hopefully.

Section 1.6 describes the general case: RF beacon for discovery, tightbeam for payload. A relay declaring the Privacy-Hardened capability bit (Section 3.1) MAY invert that — tightbeam as the discovery channel itself, RF fielded only as a fallback of last resort, or not fielded at all. What such a relay gives up is ease of acquisition; a laser is exactly as hard to find as this Group has already said it is, and a relay optimizing for low probability of intercept has chosen that difficulty on purpose, not stumbled into it. What it buys is a relay that is not broadcasting its presence to every RF receiver in range, which is precisely the trade a high-security deployment is built to make. This Group does not certify that trade as wrong. It certifies only that a relay making it should not expect Section 1.6's default model to describe its actual deployment, and should not be surprised when this document's general guidance does not either.

#### 7.3 Hybrid Relay Profile

The Hybrid Relay Profile combines RF and tightbeam with multi-media scheduling and extended capability mask usage (Section 3.2). A hybrid relay's failure modes are the union of 7.1 and 7.2, not their average. Certification testing that exercises RF and tightbeam separately, but never both under stress at the same time, hasn't really certified a hybrid relay — more like two separate relays that happen to share a chassis. This Group would just ask that both be tested together, at least once, before calling it done.

**Reminder — and this Group will probably say it again in the Appendix too, just so it's said more than once:** test in the actual environmental conditions of intended deployment, not a climate-controlled lab. Vacuum, thermal cycling, and radiation exposure affect RF propagation and tightbeam alignment differently, and a MediaProfile whose certification skipped that hasn't really been tested. It's been assumed. This Group would rather not certify an assumption, so please don't ask it to.

---

### 8. Operational Considerations for Sparse Topologies

*Operational Relay Authority*

Where beltalowda be, relay contact gonna fokaso, gonna break. Unte pretending anything other na gonya help anybody out here.

Relay rejoins network after gap — terásheting duting, occlusion, seleshang, DTN partition, whatever cause — relay MAY emit solo RelayAdvertisement watim, get visible again fast. After that, T_adv same as every other relay. Exception belong fo relay coming back online. Exception na fo relay looking fo excuse fo update wamotim.

AdmissionPolicyHint and RelayCapabilityMask MUST NOT bias against node low-band, hardware older, node from one sector wamotim other — Authority na care what excuse come dressed like engineering. Relay pass what come, kowl fair-share. Relay quietly favoring peer high-capability while gonya advertise A2 (Open) fo kowlting else, that na degrading graceful — that lying by omission. Lying still be.

Hybrid relay in spin-shift[^8] zone SHALL degrade smooth, na sharp. Tightbeam drop sudden gonna make kowl sector go dark sili RF fallback na standing ready *before* drop, na scrambled together after. Operator plan fo that ahead of time, same as always — you plan fo break before break come.

Vacuum drift hit RF and tightbeam chain different way — RF chain drift one way, beamline drift another way — and hybrid relay serving both media got to account fo both, na just whichever medium vendor happened test more.

#### 8.5 Fair Treatment Under Automated Admission Logic

*Operational Relay Authority*

Same rule hold when hand on admission logic na person no more. Relay letting some model quietly favor some peer while gonya advertise A2 fo rest, that still lying by omission. Machine lying still be. Authority na care sili person or process pick favorite; result same, sector still shut out. You build logic, you answer fo what it do.

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

This Bureau has been asked, more than once, why (d) is caught by review rather than prevented outright — a per-hop signature, say, or a hash chained across the forwarding path, so a receiving party could verify the record's custody directly instead of waiting on a certification finding. The absence is not an oversight. A chain verifiable enough to prove which relays touched a record, and in what order, is by construction a persistent, path-revealing history of exactly the kind Section 5 exists to prevent — and a worse leak than the single disclosed exception Section 5.6 already concedes, because it would name every relay in the path rather than merely count them. This Bureau will take a forgery this document can only detect after the fact over a forgery-proof record that costs every legitimate relay its anonymity to get there. A party requiring stronger custody guarantees than review-based detection provides is describing a trust-domain problem, and RFC‑2362 is where that problem belongs. It does not belong in a field added to this one.

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

This section's own title carries this Board's name in abbreviated form. The closing paragraph below states, once more, the one thing this Board has never stopped needing to state about it.

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

*Operational Relay Authority — field note:* Test lab pass kowl four, sector still eat relay alive first winter, ya. Table tell you what to test. Table na tell you sector where relay actually sit — that ENAG job, that Authority job, table just table.

### Appendix D — Deployment Guidance

*Operational Relay Authority*

Pick H_max fo sector you actually have, na sector you wish you had. Dense cluster near station, low H_max fine — kowlting close, hop na need travel far to matter. Deep Belt, sparse relay chain strung out over million kilometer, H_max too low mean advertisement die a few hop out and half the sector never see it exist at all. Na table in Appendix C tell you which sector you in. You out there. You know.

Watch H_max after storm season too. Topology that hold steady kowl year can lose three relay to a bad conjunction and suddenly your old H_max na reach where it used to. Authority say again — tune it to now, na yesterday.

*Environmental Neutrality Assessment Group*

Deployment guidance doesn't really replace what Section 7 already asks for — it's usually what people want after skipping Section 7 and hoping a shorter document might let them off easier. It won't, sorry. Test the media profile in the vacuum, thermal cycle, and radiation environment of the actual intended deployment. This was said in Section 7. It's said again here, because deployment guidance that left it out wouldn't really be guidance, would it.

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

### Appendix F — Liability and Dispute Referral

*United Nations Infrastructure Directorate*

This appendix addresses questions this document has, on occasion, been asked to answer and was never going to. Nothing in Sections 1 through 13, or in the preceding appendices, establishes fault, assigns damages, or resolves a dispute arising from a relay's advertised behavior, a forwarding relay's conduct, or the disclosed exception described in Section 5.6. This document defines a protocol. It does not adjudicate what happens when the protocol is used, misused, or exploited by a party this Directorate has no authority over.

Where a RelayAdvertisement is later found to have been forged under Section 10, and that forgery is alleged to have contributed to a loss — of cargo, of contact, of anything a party subsequently wished to hold someone accountable for — responsibility for that loss is a matter for the trust domain, insurer, or jurisdiction the affected parties actually operate under, and not for this specification. This Directorate notes that the technical finding of forgery (Section 10, Section 12) and the question of who bears the resulting cost are, and have always been, two separate determinations, decided by two entirely different bodies, and that conflating them has previously been attributed to insufficient consideration of the distinction.

Section 5.6's disclosed exception is, similarly, a technical acknowledgment, not an assumption of liability. That a field necessarily reveals relative hop-distance does not mean this Directorate, this document, or any institution named in it has accepted responsibility for what a party does with that information once revealed. Readers seeking a remedy for harm arising from lawful use of a disclosed and documented field are referred to the trust-domain policy governing their own deployment, as such matters fall outside the purview of this specification.

This Directorate offers no further guidance on this matter, as none is within its authority to offer.

### Appendix G — Known Non-Compliant Patterns

*Non-Exposure Enforcement Bureau*

**The Quantized Leak.** A vendor implementation mapped RelayLoadClass to LOW/MED/HIGH correctly, then logged the underlying raw utilization value locally "for diagnostics only." A subsequent firmware update exposed that diagnostic log through an unrelated debug interface. The class value itself never left compliance. The number it was supposed to replace did, because a device that stores what it wasn't supposed to know will eventually find a door for it. This Bureau does not consider "for diagnostics only" a defense. It never has.

**The Helpful Cache.** A Namespace Plane cache implementation began annotating cached RelayAdvertisement records with a locally-computed "reliability score" derived from advertisement consistency over time, intending it as a convenience for downstream queries. The annotation was never part of the record. It was also, functionally, exactly the kind of inference Section 10.4 already tells implementers to perform elsewhere and not attach to this record. Convenience and compliance are not the same axis, and this Bureau has stopped being surprised at how often that needs restating.

*Relay Neutrality Commission*

**The Optimistic Capacity Class.** More than one vendor has shipped a relay that advertises SchedulingCapacityHint based on theoretical maximum throughput rather than sustained, policy-derived capacity, on the theory that the difference is "close enough in practice." It is not close enough in practice. It is close enough to get a ServicePlane implementation to select a relay that then cannot deliver, which is a worse outcome for everyone than an honest C2 would have been. This Commission has seen this exact justification before. It was wrong then too.

### Appendix H — Historical Context

*Doctrinal Integrity Council*

Before RAP, relay capability was communicated informally, inconsistently, and, in a majority of documented cases, not at all — a ServicePlane implementation either guessed at a relay's suitability from prior experience or discovered it empirically, mid-session, by failing. Neither approach scaled, and both produced routing decisions that were indistinguishable, after the fact, from luck. This document exists because "it worked last time" is not a protocol.

*Operational Relay Authority*

Before RAP, everybody build own way to say what relay do. One sector use signal strength as stand-in fo kowlting — capacity, admission, load, all one number, nobody agree what number mean. Next sector over use something else entire. Ship come through, ship guess wrong, ship lose cargo or lose contact, and everybody call it bad luck 'cause nobody wrote down what actually happen.

RAP na fix kowlting out here. Storm still come, relay still die, sector still go quiet sometime with no warning. What RAP fix smaller, but it matter: now when relay say C2, every relay everywhere mean same thing by C2. That alone save more cargo than any signal-strength trick ever did.

### Appendix I — SPERB Procedural Rules

*SolNet Physical‑Layer Exposure Review Board*

**I.1 Scope.** This appendix defines procedural rules governing this Board's review of RAP implementations, supplementing the summary already given in Section 12.

**I.2 Review Procedures.** Certification applications, complaints, and Board-initiated reviews are handled under an identical procedure regardless of origin, per Section 12. Applications alleging non-compliance under Section 10(d) (HopCount tampering) SHALL include the full observed sequence of HopCount values across hops, not a single sample; a single sample cannot distinguish tampering from ordinary propagation and this Board will not open a case on one.

**I.3 Audit Procedures.** Audits of deployed relay populations SHALL sample RelayAdvertisement emissions across at least one full canonical interval and SHALL include at least one forwarding relay, where a candidate for audit forwards traffic at all. An audit that samples only origin advertisements has not audited propagation, regardless of what its final report claims to have found.

**I.4 Enforcement Procedures.** Corrective directives, compliance notices, and revocation notices under Section 12 are issued by this Board and are not delegable to any sub-bureau acting independently. A sub-bureau identifying a violation refers it to this Board; it does not resolve it unilaterally, however confident it is in the finding.

**I.5 Communication Protocols.** All formal correspondence regarding RAP conformance SHALL use terminology as defined in this document and, where a term originates elsewhere, as defined in the shared corpus glossary (`solnet-glossary.md`).

**I.6 Naming and Formal Address Requirements.** All formal correspondence SHALL refer to this Board as SPERB, pronounced SPEAR‑B. Informal or phonetic contractions are discouraged and SHALL NOT appear in conformance claims, certification requests, or audit submissions.

### Appendix J — Implementation Notes

**J.1 Scope.** *Operational Relay Authority.* This appendix give practical note fo implementing relay in physical, non-simulation deployment — na lab, na test bench, actual sector.

**J.2 Hardware Considerations.** *Environmental Neutrality Assessment Group.* Implementations SHALL ensure timing and emission hardware conforms to the canonical interval discipline of Section 6 under the full range of thermal and power conditions the deployment will actually see, not the range the bench happened to have available that week.

**J.3 Forwarding Relay Considerations.** *Operational Relay Authority.* Relay that forward — na just originate — need buffer enough to hold record long enough to decrement and re-emit without drift creeping into timing Section 6 already forbid. Cheap relay skip this, buffer too small, drop record under load 'stead of forward it clean. That na compliant fallback. That just failure wearing compliant clothes.

**J.4 Sector Topology Considerations.** *Operational Relay Authority.* H_max (Section 1.6) policy parameter, na hardware one, but hardware still constrain what policy realistic — relay with weak buffer, weak power budget, can't reliably forward at all, no matter what H_max sector authority pick. Know your hardware 'fore you promise your policy.

**J.5 Update and Maintenance Considerations.** *Environmental Neutrality Assessment Group.* Firmware updates MUST NOT alter emission timing, TLV ordering, or HopCount decrement behavior. An update that "improves" any of the three has not improved this protocol. It has left it.

### Appendix K — Organizational Structure

*SolNet Physical‑Layer Exposure Review Board*

**K.1 Scope.** This appendix defines the internal organizational bodies of SPERB relevant to RAP conformance. Full organizational detail is maintained in RFC-2352 Appendix J; this appendix restates only the bodies with direct RAP jurisdiction, correctly lettered.

**K.2 Directorate of Emission Neutrality (DEN).** Maintains the canonical Layer-1 emission profile RAP inherits. Not directly cited elsewhere in this document, since RAP's own emission discipline is Section 6's, not a fresh grant from DEN — but DEN's doctrine is upstream of Section 6 regardless.

**K.3 Non-Exposure Enforcement Bureau (NEEB).** Authors Sections 5, 5.6, and 10 of this document. Investigates exposure events and Section 10(d) forgery findings.

**K.4 Canonical Behavior Registry (CBR).** Authors Section 2 and Section 13.1 of this document. Maintains the authoritative TLV registry RAP's field set is drawn from.

**K.5 Cross-Vendor Convergence Office (CVCO).** Authors Sections 3.2, 3.3, and 9 of this document. Certifies extension registrations and vendor-convergence testing.

**K.6 Temporal Stability Review Board (TSRB).** Authors Section 6 of this document. Reviews canonical-interval compliance and timing-correlation findings.

**K.7 Environmental Neutrality Assessment Group (ENAG).** Authors Section 7 and Appendix J.2/J.5 of this document. Validates media-profile invariance under environmental variation.

**K.8 Relay Neutrality Commission (RNC).** Authors Sections 1, 1.5, 1.6, 4, and 13.2 of this document. Reviews relay-behavior conformance and forwarding discipline.

**K.9 Doctrinal Integrity Council (DIC).** Authors Sections 0, 11, and Appendices A and B of this document. Reviews cross-RFC doctrinal alignment.

**K.10 Registry of Canonical Terminology (RCT).** Not directly cited in this document's body; maintains the shared corpus glossary (`solnet-glossary.md`) this document footnotes into.

**K.11 Compliance Revocation Authority (CRA).** Not directly cited in this document's body; exercises the revocation authority Section 12 describes this Board as holding, where revocation is the disposition reached.

### Appendix L — Authorship

**L.1 Editorial Authority.** This document was prepared under the multi-institutional authorship model established for the SolNet Standards Corpus. Authorship reflects institutional roles rather than individual identity, per the convention already established for RFC‑2352.

**L.2 Primary Authors.**

- **Relay Neutrality Commission (RNC)** — relay behavior, forwarding neutrality, propagation semantics, admission policy hints.
- **Canonical Behavior Registry (CBR)** — TLV registry, capability masks, canonical advertisement structure, HopCount field definition.
- **Non-Exposure Enforcement Bureau (NEEB)** — prevention of queue-depth, peer-identity, and topology leakage; disclosure and scoping of the HopCount exception.
- **Doctrinal Integrity Council (DIC)** — invariance doctrine alignment, non-violation of RFC‑2352 and RFC‑2360, reconciliation of disclosed exceptions against doctrine.

**L.3 Contributing Bodies.**

- **Temporal Stability Review Board (TSRB)** — interval rules, timing-exposure review.
- **Environmental Neutrality Assessment Group (ENAG)** — RF/tightbeam environmental-state leakage review, deployment guidance.
- **Cross-Vendor Convergence Office (CVCO)** — vendor-identity encoding review in capability masks and extension registrations.
- **Operational Relay Authority (OPRA)** — sparse-topology and Belt-sector operational guidance, admission-fairness review.
- **United Nations Infrastructure Directorate** — liability scoping and dispute referral (Appendix F), a first appearance in an L0/L1 document rather than this institution's usual identity/governance jurisdiction, included deliberately rather than by default.

**L.4 Custodian of Record.** The Canonical Behavior Registry (CBR) maintains the authoritative TLV registry and capability mask definitions referenced throughout this document.

**L.5 Foreword.** The personal foreword preceding this document was contributed, at her own request, by Dr. Mara Ellison, Chair of the SolNet Privacy & Exposure Working Group and architect of RFC‑2308's exposure doctrine. It is not normative and was not authored by any institution named in L.2 or L.3 — it is included because Section 5's minimization doctrine is, in substance, her working group's doctrine applied to a Layer‑1 wire format, and she asked that the reasons behind it not go unwritten.

---

#### Editorial Notes *(non-normative)*

[^1]: **ServicePlane** — the SolNet layer responsible for session continuity, reservation negotiation, and relay selection based on advertised capability. It consumes Layer‑1 data such as RelayAdvertisement, but does not itself perform relay selection at the physical or media layer.
[^2]: **Namespace Plane** — the SolNet layer responsible for naming and discovery (e.g., N2 Local Namespace, N3 Service Discovery). It may cache LocationPlane data such as RelayAdvertisement for lookup purposes, but remains subject to the minimization constraints of Section 5 in doing so.
[^3]: **Reservation endpoint** — the RFC‑2370 (Reservation Negotiation) interface a relay exposes for accepting or declining reservation requests. Distinct from the ReservationSupport TLV (Section 2.2), which only advertises that such an interface may exist and makes no commitment about what it will do with a request.
[^4]: **TLV (Type–Length–Value)** — a self-describing field encoding in which each element states its own type code, length, and value, in that order (Section 2). A parser can walk a record field by field, including one containing an unrecognized type, without needing prior knowledge of every field it might contain.
[^5]: **LocationPlane** — the SolNet layer comprising the physical relay infrastructure itself: the relays, their supported media, and their Layer‑1 behavior. RelayAdvertisement is a LocationPlane artifact.
[^6]: **DTN (Delay/Disruption-Tolerant Networking)** — the networking paradigm underlying SolNet's Layer‑1 design: store-and-forward behavior for links with long, variable, or unpredictable delay, rather than an assumption of persistent, low-latency connectivity. A relay "in a DTN partition" has, at least temporarily, no path to forward traffic over — this document treats that as a normal operating condition, not a failure state.
[^7]: **UUID-S7** — the SolNet-wide opaque, time-sortable canonical identity anchor defined in RFC‑2300 §1–7. It carries no location or authority information by design; assigning location/authority context to an identity is LocationChain's job (RFC‑2300, RFC‑2350), not UUID-S7's.
[^8]: **Spin-shift** — a rotating station or habitat's own spin periodically carrying a relay's antenna or terminal out of alignment, interrupting line-of-sight or beam-aimed communication for part of every rotation. A normal, cyclical operating condition for spin-gravity Belt infrastructure, not a fault.

*For terms shared across multiple SolNet RFCs (DTN, spin-shift, canonical interval, Authority, invariance doctrine, referenced RFC numbers), see the shared corpus glossary (`solnet-glossary.md`).*
