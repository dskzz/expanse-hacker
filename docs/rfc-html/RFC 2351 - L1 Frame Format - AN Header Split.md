

# RFC‑2351 — L1 Frame Format: A/N Header Split

# **SolNet L1 Specification**

**Layer 1: Physical & Data‑Link Interoperability Standard** **SolNet Standards Working Group (SSWG)** **Final Publication — Rev 2.0** **2340‑01**

-------------
# **Abstract**

This document defines the SolNet Layer 1 (L1) communication standard, establishing the canonical physical and data‑link behaviors required for interoperable operation across all inhabited regions of the system. It specifies encoding rules, frame structure, authentication mechanisms, provenance handling, metadata minimization requirements, and relay behavior constraints. The standard is designed to prevent the interoperability failures that contributed to multiple system‑wide incidents in the early 23rd century. Compliance with this specification is mandatory for all SolNet‑connected devices, relays, and communication systems.

----------
# **Preface**

The SolNet L1 Specification is the result of a multi‑year effort to impose order on a communication environment that had, for too long, relied on incompatible systems, undocumented behaviors, and assumptions that did not survive contact with reality. The Working Group was convened in response to repeated operational failures across the system, culminating in the incidents at Vesta and Anderson Station. These events demonstrated, with unacceptable clarity, that ad‑hoc communication practices were no longer sufficient for a multi‑faction, multi‑domain network.

This document therefore establishes a uniform, interoperable, and verifiable Layer 1 standard for SolNet. It defines the minimum behaviors required for reliable operation, the prohibitions necessary to prevent recurrence of past failures, and the constraints that ensure the network remains resilient under conditions of stress, degradation, or partial compromise.

The Working Group notes that many of the requirements contained herein may appear strict, inflexible, or unnecessarily prescriptive. They are. Each requirement reflects a lesson learned at cost, often documented only because the individuals involved took the time to record their experience before circumstances prevented further clarification.

SolNet L1 is not a theoretical exercise. It is a response to the operational realities of the system as it exists, not as any party might prefer it to be. The Working Group therefore expects full compliance from all implementers, vendors, and operators. Partial adherence, selective interpretation, or “equivalent” behaviors are not acceptable and will result in predictable failures.

This specification is issued in early 2340 with the expectation that it will serve as the foundation for SolNet deployments across all inhabited regions of the system. It is not intended to solve every problem, nor to anticipate every future development. It is intended to prevent the failures we have already seen.

The Working Group trusts that this will be sufficient.

— **SolNet Standards Working Group (SSWG)** Final Publication, Rev 2.0 2340‑01

# **1. Purpose**

The purpose of this specification is to define the **SolNet L1 Frame Format**, including the mandatory **Addressing/Namespace (A/N) header split**, field ordering, compression rules, and the minimal and extended header profiles. The format described here ensures that all L0/L1 frames share a consistent structure, enabling deterministic parsing, efficient skipping, and predictable interoperability across heterogeneous deployments.

The Working Group notes that predictable behavior remains the most reliable method for reducing operational surprises.

The Working Group also notes that several earlier implementations attempted to optimize header layout independently.

These attempts produced inconsistent behavior, reduced interoperability, and increased the burden on downstream parsers. A single, fixed header format is therefore required.

This document defines:

- the canonical header layout
    
- the ordering and encoding of all fields
    
- varint formats for FreshnessTag and ProvenancePointer
    
- TLVContainerLength semantics
    
- TLV container structure
    
- CompactAuthTag encoding
    
- minimal and extended header profiles
    
- the L1Header schema
    
- conformance tests for parsing and verification
    

All L0/L1 frames MUST use the header format defined in this specification. Implementations that vary from it are considered non‑compliant, regardless of intent.

*For the foundational failures motivating this specification, see Appendix R.*

# **2. Scope**

This specification defines the complete **SolNet L1 Frame Format**, including the mandatory A/N header split, field ordering, encoding rules, and the minimal and extended header profiles. It applies to all L0/L1 media types and all devices that originate, forward, or interpret SolNet frames.

Specifically, this document defines:

- the canonical L1 header layout
    
- the ordering and encoding of all header fields
    
- varint formats for FreshnessTag and ProvenancePointer
    
- TLVContainerLength semantics
    
- TLV container structure and constraints
    
- CompactAuthTag encoding and placement
    
- minimal and extended header profiles
    
- the L1Header schema
    
- conformance tests for parsing, skipping, and verification
    

This specification does **not** define:

- L0 physical media behavior (RFC‑2303)
    
- L2 identity resolution (RFC‑2361)
    
- routing semantics or forwarding policy
    
- application‑layer payload formats
    
- trust‑domain evaluation or provenance semantics
    

The Working Group notes that previous attempts to distribute these responsibilities across multiple documents resulted in inconsistent interpretations. Consolidating all L1 framing requirements into a single specification is expected to reduce such divergence.

# **3. Design Goals**

The L1 frame format is designed to provide a consistent, deterministic structure for all SolNet deployments. Earlier implementations demonstrated that, when given flexibility, developers will use it in ways that are neither interoperable nor easily explained. The goals below reflect the Working Group’s intent to reduce such creativity.

The primary design goals are:

- **Minimality** — The header contains only fields required for correct operation. Attempts to introduce additional ‘helpful’ fields in prior drafts reliably created behavior that was difficult to explain, harder to debug, and impossible to standardize
    
- **Determinism** — Field ordering is fixed and unambiguous. Parsers perform best when they are not required to guess.
    
- **Composability** — TLV extensions are supported without altering the header structure. This avoids the recurring pattern in which extensions are added by redefining existing fields.
    
- **Efficiency** — Varint encoding is used for fields whose size varies. This reduces on‑air footprint and limits the number of ways implementers can misinterpret length.
    
- **Robustness** — Strict failure behavior ensures that malformed frames are rejected consistently. Experience shows that “best‑effort recovery” often results in neither best effort nor recovery.
    
- **Profile Awareness** — Constrained devices and relays use different header profiles. This prevents constrained devices from attempting to implement features they cannot support.
    

The Working Group notes that these goals are not aspirational; they are necessary. Past deployments demonstrated that, without explicit constraints, header formats tend to evolve in directions that are difficult to justify and even harder to reverse.

# **4. Frame Overview**

A SolNet L1 frame consists of a fixed sequence of components that appear in the same order across all media types. This structure ensures that parsers can operate without conditional logic or media‑specific exceptions, both of which have historically contributed to inconsistent behavior.

The frame is composed of:

Code

```
+------------------+
| L0 Media Header  |
+------------------+
| L1 Header        |
+------------------+
| Payload          |
+------------------+
| CompactAuthTag   |
+------------------+
```

The L0 Media Header is defined in RFC‑2303 and is not modified by this specification. The L1 Header is defined in full in this document and is divided into two logical regions:

- **A‑Header**: fields required for addressing, ordering, and provenance
    
- **N‑Header**: TLV‑encoded namespace extensions
    

This split allows implementations to process the addressing‑critical portion of the header without parsing the TLV container. The Working Group notes that this separation was introduced only after multiple deployments attempted to combine these concerns, with results that were neither efficient nor straightforward to debug.

The Payload is opaque to L1 and may contain any higher‑layer data. The CompactAuthTag, when present, provides minimal authentication for constrained profiles and is defined in RFC‑2301.

All L0/L1 frames MUST follow this structure. Frames that deviate from it cannot be interpreted reliably and MUST be rejected.


# **5. L1 Header Structure**

The L1 header consists of a fixed sequence of fields that appear in the same order in all profiles. This ordering is not negotiable. It ensures that implementations can parse frames deterministically and without relying on assumptions about field placement, optionality, or media‑specific behavior.

The header fields appear in the following order:

1. **FrameType** (1 byte)
    
2. **QoSClass** (1 byte)
    
3. **FreshnessTag** (varint)
    
4. **ProvenancePointer** (varint)
    
5. **TLVContainerLength** (varint)
    
6. **TLVContainer** (TLV sequence)
    
7. **CompactAuthTag** (optional, 8 bytes)
    

Each field has a defined size or encoding, and no field may be omitted except where explicitly permitted by the minimal header profile. The Working Group notes that earlier drafts allowed limited reordering for “implementation convenience.” This approach produced neither convenience nor interoperability, and has been removed.

The A‑Header consists of FrameType, QoSClass, FreshnessTag, and ProvenancePointer. These fields are required for addressing, ordering, and provenance evaluation. The N‑Header begins at TLVContainerLength and includes the TLVContainer and CompactAuthTag. This separation allows implementations to process addressing‑critical information without parsing the TLV container.

All implementations MUST parse the header in the order listed above. Frames that deviate from this structure MUST be rejected, regardless of whether the deviation appears benign. Experience shows that deviations rarely remain benign for long.

 _For the operational failures motivating provenance integrity, see Appendix R.2._
# **Bottom Line**

The L1 header is intentionally simple. This is not an aesthetic preference; it is a requirement born from repeated experience. Every attempt to introduce additional flexibility, optional behavior, or “helpful” complexity has produced outcomes that were harder to implement, harder to debug, and impossible to reconcile across deployments. The Working Group has therefore adopted a design philosophy that prioritizes clarity over expressiveness and predictability over theoretical capability.

Implementations that require additional features are expected to use higher‑layer mechanisms. L1 is not a negotiation space, a policy engine, or an experimental playground. It is a framing layer, and framing layers function best when they do as little as possible and do it consistently. Designs that attempt to expand L1 beyond this role have already demonstrated their failure modes in practice.

The Working Group considers the present structure the minimum necessary to prevent a recurrence of those outcomes. Additional complexity is not merely discouraged; it is incompatible with the goals of the layer. Implementers seeking to extend L1 should first consider whether the feature is truly required, and then consider whether it belongs somewhere else. In most cases, the answer to both questions will be the same.




# **6. Field Definitions**

Each field in the L1 header has a defined size, encoding, and interpretation. Implementations MUST adhere to these definitions without modification. The Working Group has observed that even minor deviations in field handling tend to propagate unpredictably across deployments.

## **6.1 FrameType (1 byte)**

Identifies the frame subtype. Values 0–31 are reserved for SSWG‑defined types. Values 32–63 are reserved for A‑stack functions, 64–127 for N‑stack functions, and 128–255 for vendor‑specific use. Implementations MUST NOT reinterpret or overload reserved values.

## **6.2 QoSClass (1 byte)**

Indicates delivery priority. Values 0–7 are canonical and MUST be supported by all devices. Values 8–15 are reserved for future use. QoSClass does not override routing policy; it merely informs it.

## **6.3 FreshnessTag (varint)**

A monotonically increasing freshness indicator used for replay suppression and ordering. Varint encoding is defined in RFC‑2301. Implementations MUST NOT wrap or reset this value except as defined in that specification.

## **6.4 ProvenancePointer (varint)**

A pointer to provenance metadata. A value of zero indicates that no provenance information is present. Non‑zero values MUST reference a valid provenance structure when such structures are available. Implementations MUST NOT infer provenance from context when the pointer is zero.

## **6.5 TLVContainerLength (varint)**

Specifies the length in bytes of the TLVContainer. The value MUST match the exact byte length of the TLV sequence. Frames with mismatched lengths MUST be rejected. The Working Group notes that attempts to “correct” mismatched lengths at runtime have historically produced more errors than they resolved.

## **6.6 TLVContainer**

A sequence of TLVs encoded as Key, Length, and Value. TLVs MUST appear in ascending numeric key order. TLVs MUST NOT be nested. TLVs with unrecognized keys MUST be skipped without inspection. This behavior is required to ensure forward compatibility.

## **6.7 CompactAuthTag (optional, 8 bytes)**

An 8‑byte authentication tag used in minimal‑auth profiles. Encoding and verification procedures are defined in RFC‑2301. If present, the tag MUST be verified before payload processing. If required by profile and absent, the frame MUST be rejected.

For historical justification, see Appendix R.2 (Anderson Station).
# **Rationale**

The L1 header format offers a simple, reliable structure designed to reduce ambiguity and support predictable behavior across the network. Earlier designs permitted limited flexibility in field ordering and optionality. Deployments using those drafts demonstrated that even small degrees of freedom were sufficient to produce incompatible interpretations, inconsistent parsing behavior, and a measurable increase in operational failures. The Working Group notes that these outcomes were entirely predictable, given the level of creativity routinely applied to “minor” deviations.

The decision to use a fixed field order is based on repeated observations that parsers behave more reliably when they are not required to infer structure. Past attempts to allow selective reordering produced implementations that were technically compliant but operationally incoherent. Similarly, the use of varint encoding for freshness and provenance fields reduces on‑air footprint without introducing additional parsing complexity. These fields vary widely in magnitude across deployments, and fixed‑width encodings were found to impose unnecessary overhead on constrained devices. Several implementers attempted to compensate for this overhead with custom compression schemes; none of these efforts survived contact with real traffic.

The A/N header split was introduced after multiple implementations attempted to combine addressing‑critical fields with namespace extensions. This approach complicated fast‑path parsing and made it difficult for constrained devices to process frames efficiently. Separating these concerns allows devices to evaluate addressing and ordering information without parsing the TLV container, improving performance and reducing error rates. The Working Group notes that the split was not introduced for aesthetic reasons; it was introduced because the alternative had already demonstrated its failure modes in production.

The TLV container is intentionally simple. Nested TLVs, multi‑byte keys, and variable‑width length fields were considered and rejected. Experience shows that such features increase the likelihood of misinterpretation and complicate forward compatibility. A single‑byte key and length, combined with strict ordering, provides sufficient extensibility without introducing unnecessary complexity. Earlier drafts that permitted more expressive TLV structures produced implementations that were expressive, but not interoperable.

The CompactAuthTag is optional to accommodate constrained devices that require minimal authentication without the overhead of full cryptographic verification. Its placement at the end of the header ensures that devices can verify it without re‑parsing earlier fields. Profiles that require stronger authentication use higher‑layer mechanisms defined elsewhere in the SolNet stack. The Working Group notes that attempts to embed stronger authentication directly into L1 were well‑intentioned but consistently underestimated the cost of doing so on devices that cannot afford it.

Overall, the header format represents a deliberate effort to balance extensibility, efficiency, and operational reliability. Designs that attempted to optimize one of these dimensions at the expense of the others consistently produced outcomes that were difficult to justify and even harder to standardize. The Working Group considers the present design the minimum structure required to prevent a repeat of those outcomes.

# **8. TLV Key Registry**

The TLV Key Registry defines the allocation and intended use of TLV Keys within the L1 header. Keys are assigned in fixed numeric ranges to prevent collisions and to discourage the recurring practice of “temporary” repurposing, which has historically resulted in long‑term operational issues.

The registry is divided into the following ranges:

- **0–31**: Reserved for SSWG‑defined extensions
    
- **32–63**: Reserved for A‑stack functions
    
- **64–127**: Reserved for N‑stack functions
    
- **128–255**: Vendor‑defined extensions
    

Keys within reserved ranges MUST NOT be redefined, overloaded, or conditionally interpreted. The Working Group has observed that attempts to “optimize” key usage by assigning multiple meanings to a single value consistently produced behavior that was neither optimal nor interoperable.

## **8.1 SSWG‑Defined Keys (0–31)**

Keys in this range are assigned through formal Working Group processes. Implementations MUST support all mandatory keys defined in this range. Optional keys MAY be ignored, but MUST NOT be reinterpreted.

The Working Group notes that several proposals to expand this range were submitted without justification beyond “future flexibility.” These proposals were rejected on the grounds that flexibility without discipline tends to produce neither.

## **8.2 A‑Stack Keys (32–63)**

Keys in this range are reserved for authority‑plane functions. These keys support trust‑domain operations, routing policy, and provenance‑related metadata.

Implementations MUST NOT use these keys for namespace or application‑level features. Past attempts to do so resulted in frames that were technically valid but semantically incoherent.

## **8.3 N‑Stack Keys (64–127)**

Keys in this range are reserved for namespace‑plane functions. These keys support local discovery, session metadata, and access‑control signaling.

Implementations MUST NOT use these keys for authority‑plane functions. The Working Group notes that conflating namespace and authority semantics has historically produced behavior that was difficult to debug and even harder to justify.

## **8.4 Vendor‑Defined Keys (128–255)**

Keys in this range MAY be used by vendors for proprietary extensions. Vendors MUST ensure that their extensions do not conflict with reserved ranges. Vendors MUST NOT assume that other implementations will interpret these keys.

The Working Group strongly recommends that vendors document their key usage. Experience shows that undocumented extensions tend to persist long after their authors have forgotten how they work.

## **8.5 Registration Process**

New keys in the SSWG‑defined range require Working Group approval. Proposals MUST include:

- a clear description of the intended semantics
    
- justification for inclusion at L1
    
- an explanation of why higher‑layer mechanisms are insufficient
    
- an assessment of parsing and compatibility impact
    

Proposals that fail to meet these criteria will be rejected. Proposals that meet these criteria may still be rejected if they introduce unnecessary complexity or replicate functionality available elsewhere in the SolNet stack.


# **7. TLV Container Format**

The TLVContainer provides a structured mechanism for extending the L1 header without altering its fixed field order. Each TLV consists of a one‑byte Key, a one‑byte Length, and a Value of the specified length. This format is intentionally constrained. Earlier drafts that permitted more expressive structures produced implementations that were expressive only in the sense that they expressed a wide range of failure modes.

A TLV has the following layout:

Code

```
+------+---------+------------------+
| Key  | Length  | Value (Length B) |
+------+---------+------------------+
```

## **7.1 Key**

The Key identifies the meaning of the TLV. Keys MUST be in ascending numeric order. Keys 0–31 are reserved for SSWG‑defined extensions. Keys 32–63 are reserved for A‑stack functions. Keys 64–127 are reserved for N‑stack functions. Keys 128–255 are available for vendor‑defined use.

Implementations MUST NOT repurpose reserved keys. The Working Group has already observed attempts to “borrow” unused values for unrelated features; such practices are prohibited.

## **7.2 Length**

Length specifies the size of the Value field in bytes. Length MUST match the actual size of the Value. Frames with mismatched lengths MUST be rejected. Implementations MUST NOT attempt to correct or reinterpret mismatched lengths. Previous attempts to do so produced behavior that was neither predictable nor consistent across devices.

## **7.3 Value**

The Value field contains the TLV’s data. The interpretation of the Value is defined by the Key. Values MUST NOT contain nested TLVs. Values MUST NOT exceed 255 bytes. Values MUST NOT require additional parsing beyond their defined structure.

The Working Group notes that proposals for nested TLVs, multi‑byte keys, and variable‑width length fields were evaluated and rejected. These features were found to increase complexity without providing meaningful operational benefit. Their absence is intentional.

## **7.4 Unknown Keys**

TLVs with unrecognized Keys MUST be skipped without inspection. Skipping MUST be performed using the Length field, not by attempting to infer structure. This behavior ensures forward compatibility and prevents devices from misinterpreting extensions they do not support.

## **7.5 TLV Ordering**

TLVs MUST appear in strictly ascending Key order. Frames containing TLVs out of order MUST be rejected. This requirement prevents ambiguous interpretations and simplifies parser design. Earlier drafts that permitted arbitrary ordering produced implementations that were technically compliant but operationally incompatible.

## **7.6 TLVContainerLength Enforcement**

The TLVContainerLength field in the L1 header specifies the total number of bytes occupied by the TLVContainer. Implementations MUST verify that the sum of all TLV lengths matches this value exactly. Frames that do not match MUST be rejected. The Working Group notes that attempts to “tolerate minor discrepancies” consistently resulted in major discrepancies.

# **8. TLV Key Registry**

The TLV Key Registry defines the allocation and intended use of TLV Keys within the L1 header. Keys are assigned in fixed numeric ranges to prevent collisions and to discourage the recurring practice of “temporary” repurposing, which has historically resulted in long‑term operational issues.

The registry is divided into the following ranges:

- **0–31**: Reserved for SSWG‑defined extensions
    
- **32–63**: Reserved for A‑stack functions
    
- **64–127**: Reserved for N‑stack functions
    
- **128–255**: Vendor‑defined extensions
    

Keys within reserved ranges MUST NOT be redefined, overloaded, or conditionally interpreted. The Working Group has observed that attempts to “optimize” key usage by assigning multiple meanings to a single value consistently produced behavior that was neither optimal nor interoperable.

## **8.1 SSWG‑Defined Keys (0–31)**

Keys in this range are assigned through formal Working Group processes. Implementations MUST support all mandatory keys defined in this range. Optional keys MAY be ignored, but MUST NOT be reinterpreted.

The Working Group notes that several proposals to expand this range were submitted without justification beyond “future flexibility.” These proposals were rejected on the grounds that flexibility without discipline tends to produce neither.

## **8.2 A‑Stack Keys (32–63)**

Keys in this range are reserved for authority‑plane functions. These keys support trust‑domain operations, routing policy, and provenance‑related metadata.

Implementations MUST NOT use these keys for namespace or application‑level features. Past attempts to do so resulted in frames that were technically valid but semantically incoherent.

## **8.3 N‑Stack Keys (64–127)**

Keys in this range are reserved for namespace‑plane functions. These keys support local discovery, session metadata, and access‑control signaling.

Implementations MUST NOT use these keys for authority‑plane functions. The Working Group notes that conflating namespace and authority semantics has historically produced behavior that was difficult to debug and even harder to justify.

## **8.4 Vendor‑Defined Keys (128–255)**

Keys in this range MAY be used by vendors for proprietary extensions. Vendors MUST ensure that their extensions do not conflict with reserved ranges. Vendors MUST NOT assume that other implementations will interpret these keys.

The Working Group strongly recommends that vendors document their key usage. Experience shows that undocumented extensions tend to persist long after their authors have forgotten how they work.

## **8.5 Registration Process**

New keys in the SSWG‑defined range require Working Group approval. Proposals MUST include:

- a clear description of the intended semantics
    
- justification for inclusion at L1
    
- an explanation of why higher‑layer mechanisms are insufficient
    
- an assessment of parsing and compatibility impact
    

Proposals that fail to meet these criteria will be rejected. Proposals that meet these criteria may still be rejected if they introduce unnecessary complexity or replicate functionality available elsewhere in the SolNet stack.


# **9. Parsing Rules**

Implementations MUST parse the L1 header in the exact order defined in Section 5. Parsers MUST NOT reorder fields, skip fields, or attempt to infer structure based on context. The Working Group has observed that parsers which attempt to be “helpful” in this manner consistently produce behavior that is neither helpful nor correct.

## **9.1 Deterministic Parsing**

Parsing MUST proceed sequentially:

1. Read FrameType
    
2. Read QoSClass
    
3. Read FreshnessTag (varint)
    
4. Read ProvenancePointer (varint)
    
5. Read TLVContainerLength (varint)
    
6. Read TLVContainer (exactly TLVContainerLength bytes)
    
7. Read CompactAuthTag (if present)
    

Implementations MUST NOT attempt to detect or compensate for missing or malformed fields. Frames that do not conform to the expected structure MUST be rejected.

## **9.2 Varint Handling**

Varints MUST be decoded according to RFC‑2301. Implementations MUST NOT accept non‑canonical encodings. Implementations MUST reject varints that:

- exceed the maximum allowed length
    
- use continuation bits incorrectly
    
- represent values outside the permitted range
    

The Working Group notes that attempts to “tolerate” malformed varints have historically resulted in divergent interpretations across devices.

## **9.3 TLV Parsing**

TLVs MUST be parsed strictly according to the Key, Length, Value structure. Parsers MUST:

- read Key (1 byte)
    
- read Length (1 byte)
    
- read Value (Length bytes)
    
- advance to the next TLV
    

Parsers MUST NOT:

- attempt to interpret nested TLVs
    
- attempt to infer structure from Value contents
    
- reorder TLVs
    
- merge adjacent TLVs
    
- reinterpret TLVs with unknown Keys
    

Unknown Keys MUST be skipped using Length, not by inspecting Value.

## **9.4 TLV Ordering Enforcement**

TLVs MUST appear in strictly ascending Key order. If a TLV appears out of order, the frame MUST be rejected. This requirement exists to prevent ambiguous interpretations and to simplify parser design. The Working Group notes that earlier drafts which permitted arbitrary ordering produced implementations that were technically compliant but operationally incompatible.

## **9.5 TLVContainerLength Enforcement**

The total number of bytes consumed by the TLVContainer MUST match the TLVContainerLength field exactly. If the TLVContainer ends early, extends beyond the declared length, or contains TLVs whose combined lengths do not match the declared total, the frame MUST be rejected.

Implementations MUST NOT attempt to correct or reinterpret mismatches. Experience shows that such attempts reliably produce behavior that is difficult to debug and impossible to standardize.

## **9.6 CompactAuthTag Handling**

If a CompactAuthTag is present, it MUST be verified before payload processing. If verification fails, the frame MUST be rejected. If the profile requires a CompactAuthTag and none is present, the frame MUST be rejected.

Implementations MUST NOT attempt to infer authentication state from context or from higher‑layer metadata.

## **9.7 Error Handling**

Parsing errors MUST result in immediate rejection of the frame. Implementations MUST NOT:

- attempt partial recovery
    
- attempt to reinterpret malformed fields
    
- attempt to continue parsing after an error
    
- attempt to “guess” the intended structure
    

The Working Group notes that recovery mechanisms attempted in earlier drafts produced outcomes that were neither predictable nor consistent across devices. The present rules are designed to prevent a recurrence of those outcomes.


# **10. Error Codes and Diagnostics**

Error codes provide a standardized mechanism for reporting parsing and validation failures. Implementations MUST use the codes defined in this section. They MUST NOT invent new codes, redefine existing ones, or substitute “equivalent” local interpretations. The Working Group has observed that such practices reliably produce behavior that is neither equivalent nor interpretable.

Error codes are one byte. Values 0–31 are reserved for SSWG‑defined errors. Values 32–255 are reserved for higher‑layer mechanisms and vendor‑specific diagnostics.

Implementations MUST report the most specific applicable error. Reporting a generic error when a specific one applies is considered non‑compliant, regardless of intent.

## **10.1 Error Code Definitions**

**0x00 — No Error** Indicates successful parsing and validation. This value MUST NOT be used to indicate partial success or “success with warnings.”

**0x01 — MalformedFrame** Indicates that the frame does not conform to the required structure. This includes missing fields, truncated fields, or unexpected data. Implementations MUST NOT attempt to recover from this condition.

**0x02 — InvalidVarint** Indicates that a varint is malformed, non‑canonical, or exceeds permitted length. Implementations MUST reject the frame immediately.

**0x03 — TLVOutOfOrder** Indicates that TLVs are not in strictly ascending Key order. This error MUST be reported even if the TLVs are otherwise valid.

**0x04 — TLVLengthMismatch** Indicates that a TLV’s Length does not match the actual size of its Value. Implementations MUST NOT attempt to infer the intended length.

**0x05 — ContainerLengthMismatch** Indicates that the TLVContainerLength does not match the total size of the TLVContainer. This error supersedes all TLV‑level errors.

**0x06 — UnknownMandatoryKey** Indicates that a TLV with a mandatory Key is unrecognized. This error MUST NOT be used for optional Keys.

**0x07 — AuthTagMissing** Indicates that a CompactAuthTag is required by profile but not present. Implementations MUST NOT attempt to infer authentication state.

**0x08 — AuthTagInvalid** Indicates that the CompactAuthTag failed verification. Implementations MUST reject the frame without further processing.

**0x09 — ReservedKeyUsed** Indicates that a TLV Key reserved for SSWG or A/N‑stack use has been used incorrectly. This error MUST be reported even if the TLV is otherwise well‑formed.

**0x0A — UnsupportedExtension** Indicates that a TLV uses a Key or Value structure that is not supported by the implementation. This error MUST NOT be used for vendor‑defined Keys unless the implementation explicitly declares support for them.

## **10.2 Diagnostic Reporting**

Implementations SHOULD provide diagnostic information sufficient to identify the cause of the error. Diagnostics MAY include:

- the offending field
    
- the expected structure
    
- the observed structure
    
- the error code
    
- the byte offset at which the error occurred
    

Diagnostics MUST NOT include payload contents or higher‑layer metadata. The Working Group notes that several implementations attempted to include such information “for convenience,” with predictable consequences for privacy and security.

## **10.3 Logging Requirements**

Implementations SHOULD log all parsing errors. Logs SHOULD include the error code and a timestamp. Logs MUST NOT include sensitive data, including:

- authentication material
    
- provenance metadata
    
- namespace identifiers
    
- payload contents
    

Implementations that log such data are considered non‑compliant, regardless of local policy.

## **10.4 Error Propagation**

Parsing errors MUST NOT be propagated beyond the receiving device. Implementations MUST NOT forward frames that fail validation. Implementations MUST NOT attempt to “repair” frames or generate replacement frames.

The Working Group notes that attempts to propagate or repair malformed frames have historically produced behavior that was difficult to diagnose and impossible to justify.

# **Sidebar: On the Prohibition of Error Recovery**

The Working Group reiterates that L1 parsers MUST reject malformed frames without attempting recovery. This requirement is not theoretical. It is the direct result of observing multiple implementations attempt to “repair” frames in ways that were creative, inconsistent, and uniformly incorrect.

Devices that attempt to infer missing fields, reinterpret malformed structures, or continue parsing after encountering an error have historically produced outcomes that were difficult to diagnose and impossible to justify. In several deployments, such behavior resulted in persistent network instability that was ultimately traced back to well‑intentioned but misguided recovery logic.

L1 is not a negotiation layer. It is not a heuristic layer. It is not a layer in which implementers are invited to guess what the sender “probably meant.” Frames are either valid or they are not. Implementations that attempt to operate in the space between these two states have already demonstrated the consequences of doing so.

The Working Group therefore emphasizes that strict rejection is not merely recommended; it is required. Implementers seeking to introduce recovery mechanisms are advised to reconsider the design of their higher‑layer protocols instead of attempting to compensate for malformed L1 frames. Experience shows that such efforts are more effective and considerably less destructive.

# **11. Minimal Header Profile**

The Minimal Header Profile defines the smallest valid L1 header that an implementation may emit or accept. This profile exists to support constrained devices and low‑duty‑cycle links where additional fields would impose unnecessary overhead. The profile is intentionally narrow. Devices requiring additional functionality MUST use a higher‑capability profile; they MUST NOT extend the minimal profile locally.

A minimal L1 header consists of the following fields, in the order defined in Section 5:

1. **FrameType**
    
2. **QoSClass**
    
3. **FreshnessTag**
    
4. **ProvenancePointer**
    
5. **TLVContainerLength**
    
6. **TLVContainer**
    
7. **CompactAuthTag** (optional)
    

No additional fields are permitted. No reordering is permitted. No implicit fields are permitted. The Working Group notes that attempts to “optimize” the minimal profile by removing required fields have historically resulted in frames that were minimal only in the sense that they contained almost no usable information.

## **11.1 Required Fields**

The following fields MUST be present:

- **FrameType**
    
- **QoSClass**
    
- **FreshnessTag**
    
- **ProvenancePointer**
    
- **TLVContainerLength**
    
- **TLVContainer**
    

These fields constitute the minimum information required for addressing, ordering, and basic metadata handling. Devices that cannot support these fields cannot participate in SolNet L1.

 _For the operational failures motivating provenance integrity, see Appendix R.2._
 
## **11.2 Optional Fields**

The **CompactAuthTag** MAY be included. If included, it MUST be validated. If the profile in use requires authentication, the tag MUST be present.

Implementations MUST NOT substitute alternative authentication mechanisms at L1. The Working Group has already evaluated such proposals and rejected them for reasons that remain valid.

## **11.3 TLV Restrictions**

The TLVContainer in the minimal profile MUST adhere to the following constraints:

- TLVs MUST be in ascending Key order
    
- TLVs MUST NOT exceed 255 bytes each
    
- TLVs MUST NOT be nested
    
- TLVs MUST NOT use Keys outside the vendor‑defined range unless explicitly permitted by the profile
    

Minimal‑profile devices SHOULD avoid emitting TLVs unless required. The Working Group notes that several early implementations attempted to use TLVs as a general‑purpose signaling mechanism; this practice is incompatible with the goals of the minimal profile.

## **11.4 Parsing Requirements**

Minimal‑profile frames MUST be parsed using the same rules defined in Section 9. Minimal does not mean “relaxed.” Minimal means “no additional features.” Parsing behavior is identical across all profiles.

## **11.5 Interoperability Requirements**

Devices supporting only the minimal profile MUST:

- accept minimal‑profile frames
    
- reject frames requiring unsupported features
    
- emit only minimal‑profile frames
    

Devices supporting higher‑capability profiles MUST accept minimal‑profile frames. They MUST NOT assume the presence of optional fields or higher‑layer metadata.

The Working Group notes that several implementations attempted to “upgrade” minimal frames by inferring missing information. This behavior is prohibited.

## **11.6 Rationale**

The minimal profile exists to support devices that cannot afford additional overhead. It does not exist to provide a convenient mechanism for implementers to avoid supporting required features. Devices capable of supporting higher‑capability profiles SHOULD do so.

The Working Group considers the minimal profile complete. Requests to reduce it further have been evaluated and rejected.


# **12. Reduced Header Profile**

The Reduced Header Profile defines a constrained subset of the full L1 header intended for devices that can support limited extensions but cannot accommodate the full set of capabilities. This profile provides additional functionality beyond the Minimal Header Profile while maintaining strict limits on complexity, extensibility, and parsing behavior. Devices implementing this profile MUST adhere to all rules defined in Sections 5 through 10.

The Reduced Header Profile is not a negotiation mechanism. It is not a transitional profile. It is not intended to support experimental features. It exists solely to accommodate devices that require a small number of additional TLVs without incurring the overhead of the full profile. Implementations that attempt to treat it as anything else have historically produced outcomes that were neither reduced nor functional.

## **12.1 Required Fields**

The Reduced Header Profile includes all fields required by the Minimal Header Profile:

- **FrameType**
    
- **QoSClass**
    
- **FreshnessTag**
    
- **ProvenancePointer**
    
- **TLVContainerLength**
    
- **TLVContainer**
    

The **CompactAuthTag** remains optional unless required by the active profile.

## **12.2 Permitted TLVs**

The Reduced Header Profile permits the use of a limited subset of TLV Keys:

- **0–7**: Mandatory SSWG‑defined TLVs
    
- **32–39**: A‑stack basic routing and trust‑domain hints
    
- **64–71**: N‑stack basic namespace and session hints
    
- **128–159**: Vendor‑defined TLVs (restricted subset)
    

All other TLV Keys MUST NOT be used. Implementations MUST reject frames containing TLVs outside this range.

The Working Group notes that earlier drafts attempted to expand the permitted TLV range “for flexibility.” These proposals were rejected after it became clear that flexibility was being used as a synonym for “lack of discipline.”

## **12.3 TLV Size Restrictions**

Each TLV in the Reduced Header Profile MUST NOT exceed **64 bytes**. The total TLVContainerLength MUST NOT exceed **256 bytes**.

These limits exist to ensure predictable parsing behavior and to prevent devices from using the Reduced Header Profile as a substitute for higher‑layer mechanisms. Implementations that require larger TLVs MUST use the Full Header Profile.

## **12.4 Authentication Requirements**

If a CompactAuthTag is present, it MUST be validated. If the active profile requires authentication, the tag MUST be present. If the active profile does not require authentication, the tag MAY be omitted.

Implementations MUST NOT introduce alternative authentication mechanisms at L1. The Working Group has already evaluated such proposals and rejected them for reasons that remain unchanged.

## **12.5 Interoperability Requirements**

Devices supporting the Reduced Header Profile MUST:

- accept Minimal Header Profile frames
    
- accept Reduced Header Profile frames
    
- reject Full Header Profile frames
    
- emit only Minimal or Reduced Header Profile frames
    

Devices supporting the Full Header Profile MUST accept Reduced Header Profile frames. They MUST NOT assume the presence of TLVs or fields not permitted by this profile.

## **12.6 Rationale**

The Reduced Header Profile exists to support devices that require limited extensibility without the overhead of the full profile. It does not exist to provide a convenient mechanism for implementers to avoid supporting required features. Devices capable of supporting the Full Header Profile SHOULD do so.

The Working Group considers the Reduced Header Profile complete. Requests to expand it have been evaluated and rejected. Requests to shrink it further have also been evaluated and rejected. The present structure represents the minimum compromise that preserves interoperability while preventing the misuse of L1 as a general‑purpose signaling layer.



# **13. Full Header Profile**

The Full Header Profile defines the complete set of L1 header capabilities. Devices implementing this profile MUST support all fields, all mandatory TLVs, and all parsing rules defined in this document. This profile is intended for devices with sufficient processing, memory, and duty‑cycle capacity to participate fully in SolNet operations. Devices that cannot meet these requirements MUST use the Reduced or Minimal Header Profiles; they MUST NOT attempt to emulate the Full Header Profile through partial or selective implementation.

The Full Header Profile is not optional. It is not a “best effort.” It is the reference behavior against which all other profiles are evaluated. Implementations that claim Full Header compliance while omitting required features are considered non‑compliant, regardless of local constraints or justifications.

## **13.1 Required Fields**

The Full Header Profile requires all fields defined in Section 5:

- **FrameType**
    
- **QoSClass**
    
- **FreshnessTag**
    
- **ProvenancePointer**
    
- **TLVContainerLength**
    
- **TLVContainer**
    
- **CompactAuthTag**
    

The **CompactAuthTag** is mandatory in the Full Header Profile. Implementations MUST validate it for every frame. Frames lacking a valid tag MUST be rejected.

## **13.2 Permitted TLVs**

The Full Header Profile permits the use of all TLV Keys defined in the registry:

- **0–31**: SSWG‑defined TLVs
    
- **32–63**: A‑stack TLVs
    
- **64–127**: N‑stack TLVs
    
- **128–255**: Vendor‑defined TLVs
    

Implementations MUST support all mandatory TLVs in the SSWG‑defined range. Optional TLVs MAY be ignored but MUST NOT be reinterpreted.

The Working Group notes that several implementations attempted to “optimize” TLV handling by collapsing multiple TLVs into a single structure. This behavior is prohibited.

## **13.3 TLV Size and Structure**

The Full Header Profile supports the maximum TLV sizes permitted by L1:

- Individual TLVs MAY be up to **255 bytes**
    
- The TLVContainer MAY be up to **65,535 bytes** (subject to varint encoding limits)
    

Nested TLVs remain prohibited. Multi‑byte Keys remain prohibited. Variable‑width Length fields remain prohibited. These prohibitions are intentional and remain in effect regardless of device capability.

## **13.4 Authentication Requirements**

The Full Header Profile requires authentication for all frames. The CompactAuthTag MUST be present and MUST be validated. Implementations MUST NOT substitute alternative authentication mechanisms at L1.

The Working Group has evaluated proposals for alternative authentication schemes and rejected them due to complexity, overhead, and predictable misuse.

## **13.5 Interoperability Requirements**

Devices supporting the Full Header Profile MUST:

- accept Minimal, Reduced, and Full Header Profile frames
    
- emit only Full Header Profile frames
    
- validate all mandatory TLVs
    
- enforce all parsing rules defined in Section 9
    
- reject frames that violate any profile constraints
    

Devices supporting lower‑capability profiles MUST accept Full Header Profile frames only if explicitly permitted by their profile. They MUST NOT assume the presence of fields or TLVs beyond their capability.

## **13.6 Rationale**

The Full Header Profile exists to support devices capable of participating fully in SolNet operations. It provides the complete set of metadata, routing hints, namespace information, and authentication mechanisms required for robust, interoperable communication.

The Working Group considers the Full Header Profile the definitive expression of L1 behavior. Requests to modify or reduce it have been evaluated and rejected. Requests to expand it have also been evaluated and rejected. The present structure reflects the minimum complexity required to support the full feature set without introducing unnecessary or counterproductive mechanisms.

# **14. Profile Capability Matrix**

The Profile Capability Matrix defines the required and optional behaviors for each L1 profile. Implementations MUST conform exactly to the capabilities associated with their declared profile. They MUST NOT selectively implement features from higher‑capability profiles, nor omit required features from their own profile. The Working Group notes that such “hybrid” implementations have historically produced behavior that was neither compatible nor predictable.

The matrix below summarizes the permitted and required capabilities for each profile.

## **14.1 Capability Summary Table**

|Capability|Minimal Profile|Reduced Profile|Full Profile|
|---|---|---|---|
|**FrameType**|REQUIRED|REQUIRED|REQUIRED|
|**QoSClass**|REQUIRED|REQUIRED|REQUIRED|
|**FreshnessTag**|REQUIRED|REQUIRED|REQUIRED|
|**ProvenancePointer**|REQUIRED|REQUIRED|REQUIRED|
|**TLVContainerLength**|REQUIRED|REQUIRED|REQUIRED|
|**TLVContainer**|REQUIRED (restricted)|REQUIRED (limited)|REQUIRED (full)|
|**CompactAuthTag**|OPTIONAL|OPTIONAL|REQUIRED|
|**SSWG TLVs (0–31)**|FORBIDDEN except mandatory|LIMITED subset|FULL support|
|**A‑stack TLVs (32–63)**|FORBIDDEN|LIMITED subset|FULL support|
|**N‑stack TLVs (64–127)**|FORBIDDEN|LIMITED subset|FULL support|
|**Vendor TLVs (128–255)**|LIMITED|LIMITED|FULL support|
|**Max TLV Size**|32 bytes|64 bytes|255 bytes|
|**Max Container Size**|128 bytes|256 bytes|65,535 bytes|
|**Authentication Required**|NO|PROFILE‑DEPENDENT|YES|
|**Nested TLVs**|FORBIDDEN|FORBIDDEN|FORBIDDEN|
|**Multi‑byte Keys**|FORBIDDEN|FORBIDDEN|FORBIDDEN|
|**Variable‑width Length Fields**|FORBIDDEN|FORBIDDEN|FORBIDDEN|
|**Error Recovery**|FORBIDDEN|FORBIDDEN|FORBIDDEN|
|**Interoperability With Lower Profiles**|MUST accept Minimal|MUST accept Minimal & Reduced|MUST accept all profiles|

## **14.2 Profile Selection Requirements**

Implementations MUST declare their supported profile at initialization. They MUST NOT change profiles dynamically. They MUST NOT advertise capabilities beyond those defined for their profile.

Devices that require features outside their declared profile MUST upgrade to a higher‑capability profile. They MUST NOT attempt to emulate higher‑capability behavior through vendor extensions, TLV misuse, or selective interpretation of mandatory fields.

The Working Group notes that several implementations attempted to “bridge” profiles by selectively enabling features based on local conditions. This behavior is prohibited.

## **14.3 Interoperability Rules**

- **Full Profile devices** MUST accept frames from all profiles.
    
- **Reduced Profile devices** MUST accept Minimal and Reduced frames.
    
- **Minimal Profile devices** MUST accept only Minimal frames.
    

Devices MUST reject frames that exceed their profile’s capabilities. Devices MUST NOT attempt to “downgrade” or reinterpret higher‑capability frames.

The Working Group has observed that attempts to reinterpret Full Profile frames as Reduced or Minimal frames consistently produced behavior that was neither interoperable nor logically coherent.

## **14.4 Rationale**

The Profile Capability Matrix exists to prevent ambiguity in device behavior. It ensures that:

- Minimal devices remain simple
    
- Reduced devices remain constrained
    
- Full devices remain fully capable
    

It also prevents implementers from constructing hybrid or partial profiles that undermine interoperability. The Working Group considers the present matrix the minimum structure required to maintain predictable behavior across heterogeneous deployments.

Requests to modify the matrix have been evaluated and rejected. Requests to “simplify” the matrix by removing distinctions have also been rejected. The distinctions exist because experience has shown they are necessary.

# **15. Profile Declaration and Negotiation**

Implementations MUST explicitly declare their supported L1 profile at initialization. This declaration MUST occur before any frame transmission or reception. Devices MUST NOT attempt to infer the profile of a peer from observed behavior, frame structure, or TLV usage. The Working Group notes that such inference mechanisms have historically produced behavior that was imaginative but incorrect.

Profile negotiation is intentionally limited. L1 is not a dynamic capability‑exchange layer, and devices MUST NOT attempt to renegotiate profiles during operation. Devices requiring dynamic negotiation MUST implement such mechanisms at higher layers.

## **15.1 Profile Declaration**

Each device MUST declare exactly one of the following profiles:

- **Minimal Header Profile**
    
- **Reduced Header Profile**
    
- **Full Header Profile**
    

The declaration MUST be:

- explicit
    
- unambiguous
    
- immutable for the duration of operation
    

Devices MUST NOT declare multiple profiles. Devices MUST NOT declare a profile and then behave as if they support a different one.

## **15.2 Declaration Mechanism**

Profile declaration MUST be performed using one of the following mechanisms:

- a configuration parameter set at initialization
    
- a hardware‑encoded capability flag
    
- a provisioning‑time assignment
    

Devices MUST NOT declare profiles based on runtime heuristics, available memory, current duty cycle, or application‑layer demands. The Working Group has observed that such “adaptive” declarations consistently produce behavior that is neither adaptive nor compliant.

## **15.3 Negotiation Rules**

L1 does not support negotiation. Devices MUST operate according to the following rules:

- **Full Profile devices** MUST accept frames from all profiles
    
- **Reduced Profile devices** MUST accept Minimal and Reduced frames
    
- **Minimal Profile devices** MUST accept only Minimal frames
    

Devices MUST NOT attempt to negotiate upward or downward. Devices MUST NOT attempt to “upgrade” or “downgrade” peer profiles based on observed behavior.

Any attempt to negotiate profiles at L1 is considered non‑compliant.

## **15.4 Mixed‑Profile Environments**

In mixed‑profile deployments:

- Full Profile devices MUST NOT assume that peers support any optional TLVs
    
- Reduced Profile devices MUST NOT assume that peers support any TLVs outside their permitted subset
    
- Minimal Profile devices MUST NOT assume the presence of any TLVs at all
    

Devices MUST NOT attempt to detect peer capabilities by probing with TLVs, malformed frames, or optional fields. The Working Group notes that such probing has historically resulted in unpredictable behavior and, in several cases, persistent network instability.

## **15.5 Profile Mismatch Handling**

If a device receives a frame that exceeds its declared profile’s capabilities, it MUST:

1. reject the frame
    
2. log the error (subject to Section 10.3)
    
3. continue normal operation
    

Devices MUST NOT:

- attempt to reinterpret the frame
    
- attempt to strip unsupported fields
    
- attempt to forward the frame
    
- attempt to “fallback” to a different profile
    

Profile mismatch is a terminal condition for the frame, not for the device.

## **15.6 Rationale**

Profile declaration and non‑negotiation exist to prevent ambiguity. Experience shows that:

- implicit negotiation fails
    
- heuristic detection fails
    
- dynamic capability inference fails
    
- hybrid profiles fail
    
- “flexible” profiles fail
    

The Working Group therefore mandates explicit, static profile declaration. This requirement is not optional and not subject to reinterpretation.


# **16. FrameType Registry**

The FrameType Registry defines the set of valid L1 frame types. Implementations MUST support all mandatory FrameTypes and MUST NOT emit or accept FrameTypes not listed in this registry. The Working Group notes that attempts to introduce “experimental” FrameTypes without registration have historically resulted in behavior that was neither experimental nor functional.

FrameTypes are one byte. Values 0–31 are reserved for SSWG‑defined types. Values 32–255 are reserved for future expansion and MUST NOT be used without formal assignment.

## **16.1 FrameType Definitions**

**0x00 — DataFrame** Carries application or namespace payload. This is the most common frame type and MUST be supported by all profiles.

**0x01 — ControlFrame** Carries control‑plane metadata, including routing hints and authority‑plane directives. Reduced and Full Profile devices MUST support this type. Minimal Profile devices MUST reject it.

**0x02 — DiscoveryFrame** Carries namespace discovery and local service advertisement metadata. Full Profile devices MUST support this type. Reduced Profile devices MAY support it. Minimal Profile devices MUST reject it.

**0x03 — KeepaliveFrame** Indicates link presence and freshness without carrying payload. All profiles MAY support this type. Devices that do not support it MUST silently ignore it.

**0x04 — ErrorFrame** Carries error codes and diagnostic metadata as defined in Section 10. Full Profile devices MUST support this type. Reduced Profile devices MAY support it. Minimal Profile devices MUST reject it.

**0x05 — AuthFrame** Carries authentication bootstrap or rekeying metadata. Full Profile devices MUST support this type. Reduced and Minimal Profile devices MUST reject it.

**0x06–0x1F — Reserved** Reserved for future SSWG‑defined FrameTypes. Implementations MUST NOT emit or interpret these values. Frames using these values MUST be rejected.

## **16.2 Vendor‑Defined FrameTypes**

Values **0x20–0xFF** are reserved for future expansion. Vendors MUST NOT use these values without formal assignment. The Working Group has observed that “temporary” vendor FrameTypes have a tendency to become permanent, undocumented, and incompatible. This practice is prohibited.

## **16.3 FrameType Validation**

Implementations MUST validate the FrameType before parsing any additional fields. If the FrameType is not recognized or not permitted by the device’s profile, the frame MUST be rejected.

Devices MUST NOT:

- attempt to reinterpret unknown FrameTypes
    
- attempt to map unknown FrameTypes to known ones
    
- attempt to “guess” the intended meaning based on TLVs or payload structure
    

The Working Group notes that such attempts have historically produced behavior that was imaginative but incorrect.

## **16.4 Interoperability Requirements**

- Full Profile devices MUST accept all registered FrameTypes.
    
- Reduced Profile devices MUST accept only DataFrame, ControlFrame, KeepaliveFrame, and optionally DiscoveryFrame.
    
- Minimal Profile devices MUST accept only DataFrame and KeepaliveFrame.
    

Devices MUST reject all other FrameTypes, regardless of context.

## **16.5 Rationale**

The FrameType Registry exists to prevent fragmentation of the L1 protocol. Experience shows that:

- unregistered FrameTypes proliferate
    
- undocumented FrameTypes persist
    
- “experimental” FrameTypes become de facto standards
    
- incompatible FrameTypes cause persistent operational failures
    

The Working Group therefore mandates strict registration and strict enforcement. This requirement is not optional and not subject to reinterpretation.


# **17. QoSClass Registry**

The QoSClass Registry defines the set of valid Quality‑of‑Service classes for L1 frames. Implementations MUST support all mandatory classes and MUST NOT emit or interpret classes not listed in this registry. The Working Group notes that attempts to introduce “local” QoS classes have historically resulted in behavior that was neither local nor coherent.

QoSClass is a one‑byte field. Values 0–7 are defined by this specification. Values 8–255 are reserved and MUST NOT be used.

QoSClass does not imply priority inversion, bandwidth guarantees, or application‑layer semantics. It provides minimal, deterministic signaling for link‑layer handling. Implementations MUST NOT reinterpret QoSClass as a general‑purpose scheduling mechanism.

## **17.1 QoSClass Definitions**

**0x00 — BestEffort** Default class. No delivery guarantees. All profiles MUST support this class. Devices MUST NOT attempt to elevate BestEffort traffic through local heuristics.

**0x01 — LowLatency** Indicates frames that benefit from reduced queuing delay. Reduced and Full Profile devices MUST support this class. Minimal Profile devices MAY treat it as BestEffort.

**0x02 — BulkTransfer** Indicates large or continuous data flows. Full Profile devices MUST support this class. Reduced Profile devices MAY support it. Minimal Profile devices MUST reject frames using this class.

**0x03 — ControlCritical** Indicates control‑plane metadata requiring expedited handling. Full Profile devices MUST support this class. Reduced Profile devices MAY support it. Minimal Profile devices MUST reject it.

**0x04 — Discovery** Indicates namespace discovery or local service advertisement. Full Profile devices MUST support this class. Reduced Profile devices MAY support it. Minimal Profile devices MUST reject it.

**0x05 — Keepalive** Indicates link‑presence signaling. All profiles MAY support this class. Devices that do not support it MUST treat it as BestEffort.

**0x06 — AuthCritical** Indicates authentication bootstrap or rekeying metadata. Full Profile devices MUST support this class. Reduced and Minimal Profile devices MUST reject it.

**0x07 — ReservedCritical** Reserved for future SSWG‑defined critical functions. Implementations MUST NOT emit or interpret this class.

## **17.2 QoSClass Validation**

Implementations MUST validate the QoSClass before processing the frame. If the class is not recognized or not permitted by the device’s profile, the frame MUST be rejected.

Devices MUST NOT:

- map unknown classes to known ones
    
- reinterpret classes based on FrameType
    
- apply local scheduling policies that contradict class semantics
    
- attempt to “upgrade” or “downgrade” classes based on observed traffic patterns
    

The Working Group notes that such attempts have historically produced behavior that was imaginative but incorrect.

## **17.3 Interoperability Requirements**

- Full Profile devices MUST accept all defined QoS classes.
    
- Reduced Profile devices MUST accept BestEffort, LowLatency, and MAY accept BulkTransfer, ControlCritical, Discovery, and Keepalive.
    
- Minimal Profile devices MUST accept only BestEffort and MAY accept Keepalive.
    

Devices MUST reject all other classes.

## **17.4 Scheduling Behavior**

QoSClass provides _hints_, not guarantees. Implementations MUST:

- prioritize ControlCritical over BestEffort
    
- prioritize LowLatency over BulkTransfer
    
- avoid starvation of any class
    
- avoid reordering frames within the same class
    

Implementations MUST NOT:

- introduce new scheduling tiers
    
- collapse multiple classes into one
    
- treat QoSClass as an application‑layer priority system
    

QoSClass is a link‑layer mechanism. It MUST NOT be repurposed for higher‑layer semantics.

## **17.5 Rationale**

The QoSClass Registry exists to prevent fragmentation of link‑layer behavior. Experience shows that:

- custom QoS schemes proliferate
    
- “temporary” classes become permanent
    
- local heuristics become de facto standards
    
- inconsistent class handling destabilizes multi‑domain deployments
    

The Working Group therefore mandates strict registration, strict enforcement, and strict interpretation of QoSClass semantics.



# **18. FreshnessTag Semantics**

The FreshnessTag provides a monotonically increasing indicator of frame recency within a local transmission context. It is encoded as a varint and MUST follow the canonical encoding rules defined in RFC‑2301. The FreshnessTag is not a timestamp, not a sequence number, and not a routing metric. Implementations MUST NOT reinterpret it as any of these.

The FreshnessTag exists solely to allow receivers to determine whether a newly received frame is fresher than previously received frames from the same sender. Any other use has historically produced behavior that was imaginative but incorrect.

## **18.1 Monotonicity Requirements**

The FreshnessTag MUST increase monotonically for each frame emitted by a device. Specifically:

- The tag MUST increase by at least 1 for each new frame.
    
- The tag MAY increase by more than 1.
    
- The tag MUST NOT decrease.
    
- The tag MUST NOT remain constant across multiple frames.
    

Devices that cannot maintain monotonicity MUST NOT participate in L1.

The Working Group notes that several early implementations attempted to “batch” increments or “reuse” tags for efficiency. These practices are prohibited.

## **18.2 Wraparound Behavior**

The FreshnessTag is an unsigned integer with no fixed upper bound beyond varint encoding limits. When the maximum representable value is reached:

- the next value MUST wrap to 0
    
- receivers MUST treat the wrapped value as fresher than all previous values
    
- devices MUST NOT attempt to signal wraparound through TLVs or auxiliary metadata
    

Wraparound is a normal condition. Implementations MUST NOT attempt to detect or compensate for it.

## **18.3 Comparison Rules**

Receivers MUST compare FreshnessTag values using unsigned arithmetic with wraparound semantics. Specifically:

- A tag is considered fresher if it is closer to the sender’s current tag in modulo space.
    
- Differences MUST be computed modulo the maximum representable value.
    
- Implementations MUST NOT use wall‑clock time, arrival time, or local heuristics to determine freshness.
    

The Working Group notes that attempts to “improve” freshness comparison using local clocks have historically resulted in behavior that was neither improved nor correct.

## **18.4 Replay Handling**

The FreshnessTag provides minimal replay protection. Receivers MUST:

- track the most recent tag seen from each sender
    
- reject frames with tags older than the tracked value
    
- accept frames with tags equal to or greater than the tracked value (modulo wraparound)
    

Receivers MUST NOT:

- attempt to maintain long‑term replay windows
    
- attempt to correlate tags across sessions
    
- attempt to infer sender state from tag behavior
    

Replay protection beyond this minimal mechanism MUST be implemented at higher layers.

## **18.5 Interaction With QoSClass**

FreshnessTag MUST NOT influence QoSClass handling. Specifically:

- devices MUST NOT prioritize frames based on tag magnitude
    
- devices MUST NOT deprioritize frames with “old” tags
    
- devices MUST NOT attempt to reorder frames based on tag differences
    

QoSClass and FreshnessTag serve distinct purposes. Conflating them has historically produced behavior that was difficult to debug and impossible to justify.

## **18.6 Interaction With ProvenancePointer**

FreshnessTag and ProvenancePointer MUST be treated as independent fields. Implementations MUST NOT:

- attempt to correlate freshness with provenance depth
    
- attempt to infer routing loops from tag behavior
    
- attempt to use tag deltas as a proxy for hop count
    

The Working Group notes that several implementations attempted to use FreshnessTag as a routing metric. This behavior is prohibited.

## **18.7 Rationale**

The FreshnessTag exists to provide a minimal, deterministic mechanism for determining frame recency. It does not provide ordering guarantees, temporal accuracy, or routing information. Attempts to expand its semantics have historically produced failure modes that were both predictable and avoidable.

The Working Group therefore mandates strict, narrow interpretation of the FreshnessTag. This requirement is not optional and not subject to reinterpretation.



# **19. ProvenancePointer Semantics**

The ProvenancePointer provides a compact reference to the sender’s most recent provenance record. It is encoded as a varint and MUST follow the canonical encoding rules defined in RFC‑2301. The ProvenancePointer is not a routing field, not a hop count, not a trust indicator, and not a cryptographic chain. Implementations MUST NOT reinterpret it as any of these.

The ProvenancePointer exists solely to allow receivers to associate a frame with a provenance record maintained at higher layers. Any other use has historically produced behavior that was imaginative but incorrect.

## **19.1 Pointer Semantics**

The ProvenancePointer is an index into a sender‑maintained provenance table. Specifically:

- The pointer identifies a provenance record known to the sender.
    
- The pointer MUST refer to a valid record at the time of transmission.
    
- The pointer MUST NOT reference future or speculative records.
    
- The pointer MUST NOT be reused to refer to different records within the same session.
    

The Working Group notes that several implementations attempted to “recycle” pointer values to conserve memory. This practice is prohibited.

## **19.2 Provenance Table Behavior**

Each device maintains a local provenance table. The table:

- MUST be append‑only for the duration of a session
    
- MUST NOT reorder entries
    
- MUST NOT delete entries referenced by active frames
    
- MAY prune entries no longer referenced by any in‑flight frames
    

Devices MUST NOT attempt to synchronize provenance tables across peers. Provenance is a local construct, not a distributed ledger.

## **19.3 Pointer Validation**

Receivers MUST validate the ProvenancePointer as follows:

- If the pointer refers to a known record, the frame MAY be processed.
    
- If the pointer refers to an unknown record, the receiver MAY request the record at higher layers.
    
- If the pointer is malformed or non‑canonical, the frame MUST be rejected.
    

Receivers MUST NOT:

- attempt to infer missing provenance records
    
- attempt to guess the intended record
    
- attempt to treat unknown pointers as “best effort”
    

The Working Group notes that such attempts have historically produced behavior that was neither best nor effortful.

## **19.4 Interaction With FreshnessTag**

ProvenancePointer and FreshnessTag MUST be treated as independent fields. Implementations MUST NOT:

- correlate pointer values with freshness
    
- infer ordering from pointer magnitude
    
- use pointer deltas as a replay indicator
    

The two fields serve distinct purposes. Conflating them has historically produced behavior that was difficult to debug and impossible to justify.

## **19.5 Interaction With Routing**

The ProvenancePointer MUST NOT influence routing decisions. Specifically:

- devices MUST NOT use pointer values as hop counts
    
- devices MUST NOT use pointer values as trust indicators
    
- devices MUST NOT use pointer values as path selection hints
    

Routing is an A‑stack function. Provenance is not.

The Working Group notes that several implementations attempted to use the ProvenancePointer as a “lightweight routing metric.” This behavior is prohibited.

## **19.6 Provenance Record Structure**

The structure of provenance records is defined at higher layers. L1 imposes the following constraints:

- records MUST be immutable once referenced
    
- records MUST be uniquely identifiable within the sender’s table
    
- records MUST NOT contain L1‑specific metadata
    
- records MUST NOT be used to store routing or scheduling information
    

L1 does not interpret provenance records. It merely points to them.

## **19.7 Pointer Wraparound**

If the provenance table reaches its maximum representable index:

- the table MUST be reset
    
- all active pointers MUST be invalidated
    
- a new session MUST be initiated
    

Devices MUST NOT attempt to wrap pointer values within a session. The Working Group has evaluated proposals for pointer wraparound and rejected them due to predictable misuse.

## **19.8 Rationale**

The ProvenancePointer exists to provide a minimal, deterministic mechanism for associating frames with higher‑layer provenance records. It does not provide ordering, trust, routing, or cryptographic guarantees. Attempts to expand its semantics have historically produced failure modes that were both predictable and avoidable.

The Working Group therefore mandates strict, narrow interpretation of the ProvenancePointer. This requirement is not optional and not subject to reinterpretation.

# **20. TLV Semantics by Category**

TLVs provide structured metadata for L1 frames. They are strictly categorized, strictly ordered, and strictly interpreted. Implementations MUST adhere to the semantics defined in this section. They MUST NOT repurpose TLVs for functions outside their category. The Working Group notes that attempts to treat TLVs as a “flexible extension mechanism” have historically produced behavior that was neither flexible nor functional.

TLVs are grouped into four categories:

1. **SSWG‑defined TLVs (0–31)**
    
2. **A‑stack TLVs (32–63)**
    
3. **N‑stack TLVs (64–127)**
    
4. **Vendor‑defined TLVs (128–255)**
    

Each category has distinct semantics and constraints. Implementations MUST enforce these distinctions.

## **20.1 SSWG‑Defined TLVs (0–31)**

SSWG TLVs define core L1 metadata. They are mandatory for Full Profile devices and partially mandatory for Reduced Profile devices.

### **20.1.1 Semantics**

SSWG TLVs provide:

- essential link‑layer metadata
    
- error reporting
    
- minimal provenance hints
    
- profile declarations
    
- operational constraints
    

They MUST NOT:

- carry routing information
    
- carry namespace identifiers
    
- carry application metadata
    
- carry authentication material (beyond CompactAuthTag)
    

### **20.1.2 Mandatory TLVs**

The following TLVs MUST be supported by all Full Profile devices:

- **0x00 — L1Version**
    
- **0x01 — ProfileIndicator**
    
- **0x02 — ErrorCode**
    
- **0x03 — ProvenanceHint**
    
- **0x04 — FreshnessHint**
    

Minimal and Reduced Profile devices MUST support only the subset required by their profile.

### **20.1.3 Misuse Prohibition**

Implementations MUST NOT:

- embed higher‑layer metadata in SSWG TLVs
    
- reinterpret SSWG TLVs as routing or scheduling hints
    
- create new SSWG TLVs without formal assignment
    

The Working Group notes that several implementations attempted to “extend” SSWG TLVs locally. This behavior is prohibited.

## **20.2 A‑Stack TLVs (32–63)**

A‑stack TLVs provide authority‑plane metadata. They are mandatory for Full Profile devices and optional for Reduced Profile devices.

### **20.2.1 Semantics**

A‑stack TLVs provide:

- trust‑domain hints
    
- routing policy indicators
    
- authority‑plane directives
    
- ephemeral ephemeris hints
    

They MUST NOT:

- carry namespace information
    
- carry application metadata
    
- carry device‑local configuration
    
- carry authentication keys
    

### **20.2.2 Mandatory A‑Stack TLVs (Full Profile)**

Full Profile devices MUST support:

- **0x20 — TrustDomainID**
    
- **0x21 — RoutingPolicyHint**
    
- **0x22 — EphemerisHintBlock**
    
- **0x23 — RelayBehaviorIndicator**
    

Reduced Profile devices MAY support these TLVs but MUST reject unsupported ones.

### **20.2.3 Misuse Prohibition**

Implementations MUST NOT:

- use A‑stack TLVs as a general‑purpose routing protocol
    
- embed application‑layer semantics
    
- treat A‑stack TLVs as security guarantees
    

The Working Group notes that several implementations attempted to use A‑stack TLVs as a “lightweight routing layer.” This behavior is prohibited.

## **20.3 N‑Stack TLVs (64–127)**

N‑stack TLVs provide namespace‑plane metadata. They are mandatory for Full Profile devices and optional for Reduced Profile devices.

### **20.3.1 Semantics**

N‑stack TLVs provide:

- namespace identifiers
    
- session hints
    
- local discovery metadata
    
- service advertisement
    

They MUST NOT:

- carry routing information
    
- carry trust‑domain metadata
    
- carry application payloads
    
- carry authentication material
    

### **20.3.2 Mandatory N‑Stack TLVs (Full Profile)**

Full Profile devices MUST support:

- **0x40 — NamespaceID**
    
- **0x41 — SessionHint**
    
- **0x42 — LocalServiceDescriptor**
    
- **0x43 — DiscoveryScope**
    

Reduced Profile devices MAY support these TLVs but MUST reject unsupported ones.

### **20.3.3 Misuse Prohibition**

Implementations MUST NOT:

- use N‑stack TLVs as a service registry
    
- embed application‑layer data
    
- treat namespace identifiers as routing hints
    

The Working Group notes that several implementations attempted to use N‑stack TLVs as a “lightweight service directory.” This behavior is prohibited.

## **20.4 Vendor‑Defined TLVs (128–255)**

Vendor TLVs provide limited extensibility. They are optional for all profiles but heavily constrained.

### **20.4.1 Semantics**

Vendor TLVs MAY provide:

- device‑local metadata
    
- diagnostic information
    
- experimental features (local only)
    

They MUST NOT:

- alter L1 semantics
    
- redefine mandatory TLVs
    
- introduce new routing or namespace behavior
    
- exceed profile TLV size limits
    

### **20.4.2 Vendor TLV Constraints**

Vendor TLVs MUST:

- use Keys 128–255
    
- be documented locally
    
- be ignored by devices that do not recognize them
    
- not exceed the size limits of the active profile
    

Vendor TLVs MUST NOT:

- conflict with SSWG, A‑stack, or N‑stack semantics
    
- attempt to emulate higher‑layer protocols
    
- attempt to negotiate capabilities
    

### **20.4.3 Misuse Prohibition**

The Working Group notes that vendor TLVs have historically been misused to:

- implement proprietary routing
    
- embed application payloads
    
- bypass profile restrictions
    
- create hybrid profiles
    

All such uses are prohibited.

## **20.5 Rationale**

TLVs exist to provide structured, minimal metadata. They do not exist to provide:

- routing
    
- discovery
    
- trust
    
- application signaling
    
- extensibility beyond narrow bounds
    

Experience shows that unconstrained TLV usage leads to fragmentation, incompatibility, and persistent operational failures. The Working Group therefore mandates strict categorization, strict semantics, and strict enforcement.


# **21. CompactAuthTag Specification**

The CompactAuthTag provides minimal authentication for L1 frames. It is a fixed‑length field appended to the end of the header. The tag is derived from a keyed authentication function defined by the active profile. Implementations MUST use the exact function, key schedule, and truncation rules defined in this section. They MUST NOT substitute alternative algorithms, lengths, or derivation methods.

The CompactAuthTag is not a signature, not a MAC with negotiable parameters, and not a general‑purpose integrity mechanism. It exists solely to provide minimal, deterministic authentication for L1 frames. Any attempt to expand its semantics has historically produced behavior that was imaginative but incorrect.

*For the dangers of centralized message handling, see Appendix R.2.*
## **21.1 Tag Length**

The CompactAuthTag is **8 bytes**. This length is fixed. It MUST NOT be increased, decreased, or negotiated.

Implementations MUST reject frames with tags of any other length.

The Working Group notes that several implementations attempted to use 4‑byte or 16‑byte tags “for efficiency” or “for security.” Both practices are prohibited.

## **21.2 Authentication Function**

The CompactAuthTag MUST be computed using:

- **HMAC‑SHA256**,
    
- truncated to **8 bytes**,
    
- using the sender’s L1 authentication key.
    

The authentication key:

- MUST be provisioned at session establishment
    
- MUST NOT be transmitted in any TLV
    
- MUST NOT be derived from FreshnessTag or ProvenancePointer
    
- MUST NOT be reused across trust domains
    

Implementations MUST NOT substitute alternative hash functions, MAC constructions, or truncation strategies.

## **21.3 Input Structure**

The CompactAuthTag MUST be computed over:

1. FrameType
    
2. QoSClass
    
3. FreshnessTag (canonical varint)
    
4. ProvenancePointer (canonical varint)
    
5. TLVContainerLength (canonical varint)
    
6. TLVContainer (exact bytes)
    

The tag MUST NOT include:

- payload contents
    
- higher‑layer metadata
    
- link‑local identifiers
    
- device serial numbers
    
- timestamps
    
- routing information
    

The Working Group notes that several implementations attempted to “improve security” by including additional fields. This behavior is prohibited.

## **21.4 Verification Rules**

Receivers MUST:

- recompute the tag using the same function
    
- compare the received tag to the computed tag
    
- reject the frame if the tags do not match
    

Receivers MUST NOT:

- accept tags that differ by any amount
    
- apply timing‑based heuristics
    
- attempt to “correct” malformed tags
    
- treat missing tags as optional in the Full Profile
    

Minimal and Reduced Profile devices MAY omit the tag if their profile permits it. Full Profile devices MUST NOT.

## **21.5 Failure Modes**

If tag verification fails, the receiver MUST:

1. reject the frame
    
2. log the error (subject to Section 10.3)
    
3. continue normal operation
    

Receivers MUST NOT:

- attempt to request retransmission
    
- attempt to infer sender state
    
- attempt to downgrade authentication requirements
    
- attempt to synchronize keys at L1
    

Authentication failure is a terminal condition for the frame, not for the session.

## **21.6 Key Management**

Key management is defined at higher layers. L1 imposes the following constraints:

- keys MUST be unique per session
    
- keys MUST NOT be reused across trust domains
    
- keys MUST NOT be derived from device identifiers
    
- keys MUST NOT be transmitted in any L1 structure
    

L1 does not negotiate keys. L1 does not rotate keys. L1 does not distribute keys.

All such functions belong to higher layers.

## **21.7 Interaction With Profiles**

- **Full Profile**: CompactAuthTag is REQUIRED.
    
- **Reduced Profile**: CompactAuthTag is OPTIONAL unless required by the active profile.
    
- **Minimal Profile**: CompactAuthTag is OPTIONAL and MAY be omitted.
    

Devices MUST NOT emit authenticated frames if they cannot validate authenticated frames.

## **21.8 Rationale**

The CompactAuthTag provides minimal, deterministic authentication for L1 frames. It does not provide confidentiality, integrity for payloads, or protection against replay. Attempts to expand its scope have historically produced failure modes that were both predictable and avoidable.

The Working Group therefore mandates strict, narrow interpretation of the CompactAuthTag. This requirement is not optional and not subject to reinterpretation.


# **22. Fragmentation & Reassembly**

L1 does **not** support fragmentation or reassembly. Frames MUST be transmitted and received as complete, self‑contained units. Implementations MUST NOT split frames across multiple transmissions, nor attempt to combine multiple transmissions into a single frame.

The Working Group notes that attempts to introduce fragmentation at L1 have historically produced behavior that was imaginative, inefficient, and incompatible with every other part of the protocol.

## **22.1 Prohibition of Fragmentation**

Devices MUST NOT fragment frames. Specifically:

- A single logical frame MUST correspond to a single physical transmission.
    
- Frames MUST NOT be divided into “segments,” “chunks,” “pages,” or any other partial structure.
    
- TLVs MUST NOT be split across transmissions.
    
- Payloads MUST NOT be split across transmissions.
    

Any device that emits partial frames is considered non‑compliant.

## **22.2 Prohibition of Reassembly**

Devices MUST NOT attempt to reassemble frames. Specifically:

- Receivers MUST NOT buffer partial transmissions.
    
- Receivers MUST NOT attempt to infer missing data.
    
- Receivers MUST NOT attempt to merge multiple transmissions into a single frame.
    
- Receivers MUST NOT treat truncated frames as recoverable.
    

If a frame is incomplete, it MUST be rejected.

## **22.3 Handling of Oversized Frames**

If a device attempts to emit a frame larger than the maximum permitted size for its profile:

- the frame MUST NOT be transmitted
    
- the device MUST log the error (subject to Section 10.3)
    
- the device MUST NOT attempt to fragment the frame to “fit”
    

Applications generating oversized payloads MUST use higher‑layer mechanisms to segment their data. L1 does not provide this service.

## **22.4 Interaction With TLVContainerLength**

TLVContainerLength MUST reflect the exact size of the TLVContainer. Implementations MUST NOT:

- treat TLVContainerLength as a “hint”
    
- attempt to reconcile mismatches by reading additional transmissions
    
- attempt to “pad” or “trim” TLV data to fit the declared length
    

If TLVContainerLength does not match the actual container size, the frame MUST be rejected.

## **22.5 Interaction With Profiles**

- **Minimal Profile**: fragmentation is forbidden
    
- **Reduced Profile**: fragmentation is forbidden
    
- **Full Profile**: fragmentation is forbidden
    

No profile permits fragmentation. No profile permits reassembly. No profile permits negotiation of fragmentation behavior.

The Working Group has evaluated proposals for profile‑specific fragmentation and rejected them due to predictable misuse.

## **22.6 Rationale**

Fragmentation introduces:

- statefulness
    
- buffering
    
- ordering dependencies
    
- retransmission semantics
    
- partial‑frame ambiguity
    
- inconsistent error handling
    

All of these are incompatible with L1’s design goals.

Experience shows that fragmentation at L1 leads to:

- persistent congestion
    
- inconsistent reassembly behavior
    
- cross‑profile incompatibility
    
- unpredictable failure modes
    
- implementers attempting to reinvent transport protocols
    

The Working Group therefore mandates strict prohibition of fragmentation and reassembly. This requirement is not optional and not subject to reinterpretation.



# **23. Relay Behavior & Forwarding Rules**

Relays provide hop‑to‑hop forwarding of L1 frames without altering their semantics. A relay is not a router, not a proxy, not a gateway, and not an interpreter of higher‑layer metadata. Relays MUST forward frames exactly as received, subject only to the validation and rejection rules defined in this document.

The Working Group notes that attempts to introduce “intelligent” relay behavior have historically produced outcomes that were neither intelligent nor functional.

> _For historical precedent, see Appendix R.2.2–R.2.4._
>

## **23.1 Relay Definition**

A relay is any device that:

- receives an L1 frame
    
- validates it
    
- forwards it without modification
    

Relays MUST NOT:

- modify frame contents
    
- modify TLVs
    
- modify authentication tags
    
- modify provenance
    
- modify freshness
    
- modify QoSClass
    
- modify FrameType
    

Relays MUST NOT “optimize,” “correct,” or “improve” frames.

## **23.2 Validation Before Forwarding**

Before forwarding a frame, a relay MUST:

1. validate the header
    
2. validate the TLVContainerLength
    
3. validate the CompactAuthTag (if present)
    
4. validate profile compatibility
    
5. validate FrameType and QoSClass
    

If any validation step fails, the relay MUST:

- reject the frame
    
- log the error (subject to Section 10.3)
    
- NOT forward the frame
    

Relays MUST NOT forward frames they cannot validate.

## **23.3 Prohibition of Modification**

Relays MUST NOT modify any part of the frame. Specifically:

- TLVs MUST NOT be added, removed, or reordered
    
- TLV values MUST NOT be rewritten
    
- authentication tags MUST NOT be recomputed
    
- provenance pointers MUST NOT be altered
    
- freshness tags MUST NOT be incremented
    
- QoSClass MUST NOT be changed
    

The Working Group notes that several implementations attempted to “fix” malformed TLVs or “update” freshness. This behavior is prohibited.

## **23.4 Forwarding Behavior**

Relays MUST forward frames according to:

- local link availability
    
- local duty‑cycle constraints
    
- local scheduling rules (subject to QoSClass semantics)
    

Relays MUST NOT:

- reorder frames within the same QoSClass
    
- prioritize frames based on provenance
    
- deprioritize frames based on freshness
    
- drop frames for “policy” reasons not defined in this document
    

Relays MUST NOT attempt to interpret higher‑layer semantics.

## **23.5 Loop Prevention**

Relays MUST implement minimal loop‑prevention behavior:

- A relay MUST NOT forward a frame it has already forwarded within the current freshness window.
    
- A relay MUST track the most recent FreshnessTag per sender.
    
- A relay MUST reject frames that appear to be looping.
    

Relays MUST NOT:

- modify provenance to break loops
    
- modify freshness to break loops
    
- introduce hop counters
    
- introduce TTL fields
    

Loop prevention is minimal by design. Higher layers MUST implement full loop‑avoidance mechanisms.

## **23.6 Interaction With Profiles**

- **Full Profile relays** MUST forward Minimal, Reduced, and Full frames.
    
- **Reduced Profile relays** MUST forward Minimal and Reduced frames.
    
- **Minimal Profile relays** MUST forward only Minimal frames.
    

Relays MUST NOT attempt to “upgrade” or “downgrade” frames to match their own profile.

## **23.7 Error Handling**

If a relay encounters an error:

- the frame MUST be rejected
    
- the error MUST be logged
    
- the relay MUST NOT attempt recovery
    
- the relay MUST NOT forward the frame
    

Relays MUST NOT:

- request retransmission
    
- attempt to repair frames
    
- attempt to infer missing data
    
- attempt to generate replacement frames
    

Error handling is terminal for the frame, not for the relay.

## **23.8 Rationale**

Relays exist to forward frames, not to interpret them. Experience shows that:

- “smart” relays become inconsistent
    
- “helpful” relays become destructive
    
- “adaptive” relays become unpredictable
    
- “corrective” relays become non‑compliant
    

The Working Group therefore mandates strict, minimal relay behavior. This requirement is not optional and not subject to reinterpretation.


# **24. Operational Considerations**

Operational behavior is a critical component of L1 interoperability. Devices that conform to the structural requirements of this document but fail to operate within the constraints defined in this section are considered non‑compliant. The Working Group notes that operational deviations, even when technically valid at the byte level, have historically produced persistent instability, congestion collapse, and unpredictable cross‑domain behavior.

## **24.1 Duty‑Cycle Management**

Devices MUST adhere to their declared duty‑cycle limits. Specifically:

- devices MUST NOT exceed their duty‑cycle allocation
    
- devices MUST NOT “borrow” future duty cycle to compensate for local congestion
    
- devices MUST NOT dynamically renegotiate duty cycle at L1
    
- devices MUST NOT emit bursts that violate local regulatory or profile constraints
    

If a device cannot meet application demands within its duty‑cycle budget, the application MUST reduce its traffic. L1 does not provide relief mechanisms.

The Working Group notes that several implementations attempted to “smooth” duty‑cycle usage by emitting micro‑bursts. This behavior is prohibited.

## **24.2 Congestion Behavior**

Devices MUST implement congestion‑aware transmission behavior. Specifically:

- repeated frame rejection MUST reduce transmission frequency
    
- repeated authentication failures MUST NOT trigger retransmission
    
- repeated TLV validation failures MUST NOT trigger retransmission
    
- devices MUST NOT attempt exponential backoff unless defined by higher layers
    

Congestion handling at L1 is intentionally minimal. Higher layers MUST implement full congestion‑control mechanisms.

## **24.3 Link‑Quality Adaptation**

Devices MAY adapt transmission parameters based on link quality, subject to the following constraints:

- adaptations MUST NOT alter frame structure
    
- adaptations MUST NOT alter profile behavior
    
- adaptations MUST NOT introduce new TLVs
    
- adaptations MUST NOT modify QoSClass semantics
    

Devices MUST NOT:

- increase transmit power beyond regulatory limits
    
- reduce authentication requirements
    
- alter FreshnessTag behavior
    
- alter ProvenancePointer behavior
    

The Working Group notes that several implementations attempted to “improve reliability” by modifying L1 semantics under poor link conditions. This behavior is prohibited.

## **24.4 Scheduling Behavior**

Devices MUST schedule transmissions according to:

- QoSClass semantics
    
- local duty‑cycle constraints
    
- local link availability
    

Devices MUST NOT:

- reorder frames within the same QoSClass
    
- prioritize frames based on provenance
    
- deprioritize frames based on freshness
    
- introduce new scheduling tiers
    
- collapse multiple QoS classes into one
    

Scheduling MUST remain deterministic and profile‑consistent.

## **24.5 Power‑Constrained Operation**

Devices operating under power constraints (e.g., rovers, drones, EVA suits) MUST:

- maintain monotonic FreshnessTag behavior
    
- maintain valid authentication behavior
    
- maintain profile compliance
    
- reduce transmission frequency before violating any L1 requirement
    

Devices MUST NOT:

- disable authentication
    
- disable TLV validation
    
- disable profile enforcement
    
- emit partial frames
    
- emit frames with stale or reused FreshnessTags
    

Power constraints do not justify non‑compliance.

## **24.6 Environmental Constraints**

Devices operating in degraded environments (e.g., dust storms, radiation events, thermal extremes) MUST:

- continue to validate all frames
    
- continue to reject malformed frames
    
- continue to enforce profile boundaries
    

Devices MUST NOT:

- relax validation rules
    
- accept malformed frames “due to conditions”
    
- attempt to infer missing data
    
- attempt to bypass authentication
    

Environmental conditions do not alter protocol semantics.

## **24.7 Multi‑Domain Deployments**

In deployments spanning multiple trust domains:

- devices MUST NOT assume shared provenance tables
    
- devices MUST NOT assume shared namespace semantics
    
- devices MUST NOT assume shared routing policy
    
- devices MUST NOT attempt cross‑domain optimization at L1
    

Cross‑domain behavior belongs to A‑stack and N‑stack layers. L1 MUST remain domain‑agnostic.

## **24.8 Operational Logging**

Devices SHOULD log:

- frame rejection events
    
- authentication failures
    
- TLV validation failures
    
- profile mismatch events
    
- duty‑cycle violations
    

Devices MUST NOT:

- log payload contents
    
- log authentication keys
    
- log provenance records
    
- log namespace identifiers
    

Operational logs MUST NOT leak metadata beyond what is strictly necessary for debugging.

## **24.9 Rationale**

Operational constraints exist to ensure predictable behavior across heterogeneous deployments. Experience shows that:

- “adaptive” L1 behavior becomes inconsistent
    
- “flexible” L1 behavior becomes incompatible
    
- “optimized” L1 behavior becomes unstable
    
- “environment‑aware” L1 behavior becomes non‑compliant
    

The Working Group therefore mandates strict, minimal, deterministic operational behavior. This requirement is not optional and not subject to reinterpretation.


# **25. Security Considerations**

L1 provides minimal security guarantees. It is not a confidentiality layer, not an integrity layer for payloads, not a key‑exchange mechanism, and not a trust‑establishment protocol. Implementations MUST NOT assume that L1 provides any security properties beyond those explicitly defined in this section.

The Working Group notes that attempts to treat L1 as a security layer have historically produced behavior that was imaginative, brittle, and catastrophically incorrect.

## **25.1 Threat Model**

L1 assumes:

- adversaries can observe all transmissions
    
- adversaries can replay frames
    
- adversaries can inject frames
    
- adversaries can modify frames in transit
    
- adversaries can impersonate devices lacking authentication
    
- adversaries can exploit misconfigured or non‑compliant devices
    

L1 does **not** assume:

- confidentiality of payloads
    
- confidentiality of metadata
    
- integrity of payloads
    
- secure key distribution
    
- secure provenance
    
- secure routing
    

These properties MUST be provided by higher layers.

## **25.2 Authentication Guarantees**

The CompactAuthTag provides minimal authentication for L1 frames. It guarantees:

- the frame originated from a device possessing the session key
    
- the frame was not modified in transit
    

It does **not** guarantee:

- sender identity
    
- sender authorization
    
- freshness beyond the FreshnessTag
    
- replay protection beyond minimal semantics
    
- confidentiality of any field
    

Implementations MUST NOT treat the CompactAuthTag as a signature or as a substitute for higher‑layer authentication.

## **25.3 Replay Attacks**

L1 provides only minimal replay protection via FreshnessTag semantics. Devices MUST:

- track the most recent FreshnessTag per sender
    
- reject frames with older tags
    
- accept frames with equal or newer tags (modulo wraparound)
    

Devices MUST NOT:

- maintain long replay windows
    
- attempt to correlate tags across sessions
    
- attempt to detect “suspicious” tag patterns
    

Replay protection beyond this minimal mechanism MUST be implemented at higher layers.

## **25.4 Injection Attacks**

Devices MUST reject:

- malformed frames
    
- frames with invalid TLVs
    
- frames with invalid TLVContainerLength
    
- frames with invalid authentication tags
    
- frames exceeding profile limits
    

Devices MUST NOT:

- attempt to repair malformed frames
    
- attempt to infer missing data
    
- attempt to “sanitize” TLVs
    
- forward frames that fail validation
    

Injection resistance depends on strict adherence to validation rules.

## **25.5 Downgrade Attacks**

Devices MUST enforce their declared profile. Specifically:

- Full Profile devices MUST NOT accept frames lacking required authentication
    
- Reduced Profile devices MUST NOT accept Full Profile frames if prohibited
    
- Minimal Profile devices MUST NOT accept any TLVs beyond their profile

For historical justification, see Appendix R.2 (Anderson Station).

Devices MUST NOT:

- negotiate profile changes
    
- infer profile changes
    
- accept “fallback” behavior
    
- accept unauthenticated frames in authenticated sessions
    

Downgrade resistance depends on strict profile enforcement.

## **25.6 Metadata Leakage**

L1 metadata is observable by design. Devices MUST assume that:

- FrameType
    
- QoSClass
    
- FreshnessTag
    
- ProvenancePointer
    
- TLVContainerLength
    
- TLV contents
    

are visible to adversaries.

Devices MUST NOT:

- embed sensitive information in TLVs
    
- embed sensitive information in provenance records
    
- embed sensitive information in QoSClass selection
    
- rely on obscurity of metadata for security
    

Confidentiality MUST be provided by higher layers.

## **25.7 Key Management Risks**

L1 does not manage keys. Implementations MUST ensure:

- keys are unique per session
    
- keys are not reused across trust domains
    
- keys are not derived from device identifiers
    
- keys are not transmitted in any L1 structure
    

Devices MUST NOT:

- attempt key rotation at L1
    
- attempt key negotiation at L1
    
- embed key material in TLVs
    
- embed key material in provenance
    

Key management failures are outside L1’s scope but directly impact L1 security.

## **25.8 Relay‑Based Attacks**

Relays MUST NOT:

- modify frames
    
- recompute authentication tags
    
- alter provenance
    
- alter freshness
    
- alter TLVs
    

Relays MUST validate frames before forwarding. Relays MUST reject frames that fail validation.

Relays MUST NOT attempt to “improve” or “correct” frames. Such behavior introduces attack surfaces.

## **25.9 Vendor Extension Risks**

Vendor TLVs MUST NOT:

- introduce new security semantics
    
- alter authentication behavior
    
- embed key material
    
- embed trust‑domain identifiers
    
- override profile constraints
    

Vendor TLVs are a common source of vulnerabilities. Their misuse is prohibited.

## **25.10 Rationale**

L1 provides minimal, deterministic security properties. Experience shows that:

- attempts to add security at L1 fail
    
- attempts to extend security at L1 fail
    
- attempts to infer security from L1 metadata fail
    
- attempts to treat L1 as a trust layer fail
    

The Working Group therefore mandates strict, narrow interpretation of L1 security semantics. This requirement is not optional and not subject to reinterpretation.


# **26. Privacy & Metadata Minimization**

L1 provides no confidentiality guarantees. All metadata is observable by design. However, L1 **does** impose strict requirements on what metadata MAY appear in frames, how long metadata MAY persist, and what devices MUST do to avoid leaking unnecessary information.

Privacy at L1 is achieved not through secrecy but through **minimization**. Implementations MUST NOT emit metadata beyond what is strictly required for L1 operation. The Working Group notes that attempts to “enhance” L1 with additional metadata have historically produced behavior that was imaginative, verbose, and deeply non‑compliant.

*For systemic consequences of metadata misuse, see Appendix R.2.3.*

## **26.1 Metadata Exposure Model**

Devices MUST assume that adversaries can observe:

- FrameType
    
- QoSClass
    
- FreshnessTag
    
- ProvenancePointer
    
- TLVContainerLength
    
- all TLV contents
    
- timing, frequency, and size of transmissions
    

Devices MUST NOT assume:

- link‑layer confidentiality
    
- metadata obfuscation
    
- anonymity
    
- unlinkability
    

These properties MUST be provided by higher layers.

## **26.2 Minimization Requirements**

Devices MUST minimize metadata emission. Specifically:

- TLVs MUST NOT contain unnecessary fields
    
- TLVs MUST NOT contain redundant information
    
- TLVs MUST NOT contain application‑layer identifiers
    
- TLVs MUST NOT contain device serial numbers
    
- TLVs MUST NOT contain user identifiers
    
- TLVs MUST NOT contain timestamps
    
- TLVs MUST NOT contain routing information
    
- TLVs MUST NOT contain trust‑domain secrets
    

Metadata MUST be strictly limited to what is required for L1 operation.

## **26.3 Prohibition of Identifying Information**

Devices MUST NOT embed identifying information in:

- FrameType
    
- QoSClass
    
- FreshnessTag
    
- ProvenancePointer
    
- TLVs
    
- Vendor extensions
    

Prohibited Identifying information includes:

- device serial numbers
    
- globally unique, persistent hardware identifiers
    
- user identifiers
    
- geographic coordinates
    
- timestamps
    
- application‑layer session IDs
    
- cryptographic key fingerprints
    

The Working Group notes that several implementations attempted to embed “helpful” identifiers in TLVs. This behavior is prohibited.

## **26.4 Provenance Minimization**

Provenance records MUST NOT contain:

- user identifiers
    
- device identifiers
    
- trust‑domain secrets
    
- routing information
    
- timestamps
    
- application metadata
    

Provenance MUST be limited to the minimal information required by higher layers to reconstruct context. L1 MUST NOT interpret provenance, and provenance MUST NOT leak L1‑irrelevant information.

## **26.5 FreshnessTag Minimization**

FreshnessTag MUST NOT encode:

- timestamps
    
- device uptime
    
- sequence numbers with semantic meaning
    
- routing metrics
    
- application‑layer counters
    

FreshnessTag MUST be strictly monotonic and strictly meaningless outside its comparison semantics.

## **26.6 TLV Minimization**

TLVs MUST NOT:

- duplicate information already present in the header
    
- encode higher‑layer identifiers
    
- encode routing hints
    
- encode trust‑domain secrets
    
- encode application metadata
    
- encode debugging information
    
- encode vendor analytics
    

Vendor TLVs MUST NOT be used to circumvent minimization requirements.

## **26.7 Logging Minimization**

Operational logs MUST NOT contain:

- payload contents
    
- authentication keys
    
- provenance records
    
- namespace identifiers
    
- user identifiers
    
- device identifiers
    
- timestamps beyond what is required for local debugging
    

Logs MUST NOT be transmitted over L1. Logs MUST NOT be encoded in TLVs.

## **26.8 Traffic‑Analysis Resistance (Minimal)**

L1 provides no traffic‑analysis resistance. However, devices MUST NOT:

- emit periodic frames solely for analytics
    
- emit frames containing “heartbeat” identifiers
    
- alter QoSClass to encode application semantics
    
- alter FreshnessTag to encode timing information
    

Traffic‑analysis resistance MUST be implemented at higher layers.

## **26.9 Rationale**

Privacy at L1 is achieved through **absence**, not **obfuscation**. Experience shows that:

- attempts to add privacy at L1 fail
    
- attempts to hide metadata at L1 fail
    
- attempts to encode privacy signals in TLVs fail
    
- attempts to “anonymize” L1 behavior fail
    

The Working Group therefore mandates strict metadata minimization and strict prohibition of identifying information. This requirement is not optional and not subject to reinterpretation.


# **27. Compliance Levels & Test Vectors**

This section defines the mandatory compliance levels for L1 implementations and provides canonical test vectors for verifying conformance. Devices MUST pass all applicable tests to be considered compliant. Partial compliance, “best‑effort” compliance, and “profile‑adjacent” compliance are not recognized by the SSWG.

The Working Group notes that several vendors have historically claimed compliance based on incomplete or selectively interpreted requirements. This behavior is prohibited.

## **27.1 Compliance Levels**

L1 defines three compliance levels corresponding to the three profiles:

- **Minimal Profile Compliance**
    
- **Reduced Profile Compliance**
    
- **Full Profile Compliance**
    

A device MUST declare exactly one compliance level. A device MUST NOT claim multiple levels. A device MUST NOT claim “hybrid,” “extended,” or “vendor‑enhanced” compliance.

### **27.1.1 Minimal Profile Compliance**

A device is minimally compliant if it:

- emits only DataFrame and KeepaliveFrame
    
- supports only BestEffort QoSClass (Keepalive optional)
    
- supports no TLVs
    
- supports no authentication
    
- supports monotonic FreshnessTag
    
- supports ProvenancePointer with local semantics
    
- rejects all unsupported fields
    

Minimal Profile devices MUST NOT emit:

- ControlFrame
    
- DiscoveryFrame
    
- ErrorFrame
    
- AuthFrame
    
- any TLVs
    
- any CompactAuthTag
    

### **27.1.2 Reduced Profile Compliance**

A device is reduced‑profile compliant if it:

- supports DataFrame, ControlFrame, KeepaliveFrame, and MAY support DiscoveryFrame
    
- supports BestEffort and LowLatency QoSClass
    
- supports SSWG TLVs required for Reduced Profile
    
- MAY support A‑stack and N‑stack TLVs
    
- MAY support CompactAuthTag
    
- enforces TLVContainerLength
    
- enforces canonical varint encoding
    

Reduced Profile devices MUST NOT:

- emit AuthFrame
    
- emit AuthCritical QoSClass
    
- emit Full‑Profile‑only TLVs
    

### **27.1.3 Full Profile Compliance**

A device is fully compliant if it:

- supports all FrameTypes defined in Section 16
    
- supports all QoSClasses defined in Section 17
    
- supports all SSWG, A‑stack, and N‑stack TLVs
    
- supports CompactAuthTag
    
- validates all fields
    
- enforces all operational constraints
    
- implements all relay and forwarding rules
    

Full Profile devices MUST NOT omit authentication.

## **27.2 Compliance Test Categories**

Compliance testing is divided into:

1. **Structural Tests**
    
2. **Semantic Tests**
    
3. **Operational Tests**
    
4. **Negative Tests**
    
5. **Interoperability Tests**
    

Devices MUST pass all tests applicable to their profile.

### **27.2.1 Structural Tests**

Verify:

- canonical varint encoding
    
- correct TLV ordering
    
- correct TLVContainerLength
    
- correct FrameType and QoSClass values
    
- correct CompactAuthTag length and placement
    

### **27.2.2 Semantic Tests**

Verify:

- monotonic FreshnessTag behavior
    
- valid ProvenancePointer references
    
- correct TLV semantics by category
    
- correct profile enforcement
    
- correct relay behavior
    

### **27.2.3 Operational Tests**

Verify:

- duty‑cycle compliance
    
- scheduling behavior
    
- congestion behavior
    
- error handling
    
- logging minimization
    

### **27.2.4 Negative Tests**

Devices MUST correctly reject:

- malformed frames
    
- truncated frames
    
- frames with invalid TLVs
    
- frames with invalid authentication tags
    
- frames exceeding profile limits
    
- frames with non‑canonical varints
    
- frames with forbidden metadata
    

### **27.2.5 Interoperability Tests**

Devices MUST interoperate with:

- a reference Minimal Profile device
    
- a reference Reduced Profile device
    
- a reference Full Profile device
    

Devices MUST NOT require vendor‑specific extensions to interoperate.

## **27.3 Canonical Test Vectors**

The following test vectors are normative. Devices MUST produce and validate these exact byte sequences.

### **27.3.1 Minimal Profile — Valid DataFrame**

Code

```
00 00 01 00
```

Meaning:

- FrameType = DataFrame (0x00)
    
- QoSClass = BestEffort (0x00)
    
- FreshnessTag = 1 (varint)
    
- TLVContainerLength = 0
    

### **27.3.2 Minimal Profile — Reject Non‑Zero TLV Length**

Code

```
00 00 01 01 FF
```

Device MUST reject due to non‑zero TLVContainerLength.

### **27.3.3 Reduced Profile — Valid ControlFrame With TLV**

Code

```
01 01 02 03 81 01 7F
```

Meaning:

- FrameType = ControlFrame
    
- QoSClass = LowLatency
    
- FreshnessTag = 2
    
- TLVContainerLength = 3
    
- TLV: Key=0x01, Length=1, Value=0x7F
    

### **27.3.4 Full Profile — Valid Authenticated Frame**

Code

```
00 00 05 03 82 02 40 01 01 9A 7C 3F 12 88 4E
```

Meaning:

- DataFrame
    
- BestEffort
    
- FreshnessTag = 5
    
- TLVContainerLength = 3
    
- TLV: NamespaceID = 1
    
- CompactAuthTag = 8 bytes
    

Device MUST validate the tag.

### **27.3.5 Full Profile — Reject Invalid Auth Tag**

Same as above, but last byte changed. Device MUST reject.

## **27.4 Vendor Compliance Claims**

Vendors MUST NOT:

- claim compliance without passing all tests
    
- claim “partial compliance”
    
- claim “profile‑compatible” behavior
    
- claim “equivalent to Full Profile”
    
- redefine compliance levels
    

Compliance is binary.

## **27.5 Rationale**

Compliance testing exists because:

- implementers are inconsistent
    
- vendors are optimistic
    
- marketing departments are reckless
    
- interoperability failures are expensive
    
- non‑compliant devices destabilize entire deployments
    

The Working Group therefore mandates strict, test‑driven compliance. This requirement is not optional and not subject to reinterpretation.


# **Appendix A — Examples**

This appendix provides canonical examples of L1 frames for all profiles. Examples are normative. Devices MUST accept valid examples and MUST reject invalid ones exactly as shown.

The Working Group notes that implementers frequently misinterpret textual requirements until confronted with byte‑level examples. This appendix exists to prevent such misinterpretations.

# **A.1 Minimal Profile Examples**

Minimal Profile devices support:

- DataFrame
    
- KeepaliveFrame
    
- BestEffort QoSClass
    
- FreshnessTag
    
- ProvenancePointer
    
- TLVContainerLength = 0
    
- no TLVs
    
- no authentication
    

## **A.1.1 Valid Minimal DataFrame**

Code

```
00 00 01 00
```

Meaning:

- FrameType = DataFrame (0x00)
    
- QoSClass = BestEffort (0x00)
    
- FreshnessTag = 1
    
- TLVContainerLength = 0
    

Device MUST accept.

## **A.1.2 Valid Minimal KeepaliveFrame**

Code

```
02 00 05 00
```

Meaning:

- FrameType = KeepaliveFrame (0x02)
    
- QoSClass = BestEffort
    
- FreshnessTag = 5
    
- TLVContainerLength = 0
    

Device MUST accept.

## **A.1.3 Invalid: Non‑Zero TLV Length**

Code

```
00 00 01 01 FF
```

Device MUST reject due to TLVContainerLength ≠ 0.

## **A.1.4 Invalid: Unsupported QoSClass**

Code

```
00 01 01 00
```

LowLatency (0x01) is not permitted. Device MUST reject.

# **A.2 Reduced Profile Examples**

Reduced Profile devices support:

- DataFrame, ControlFrame, KeepaliveFrame
    
- MAY support DiscoveryFrame
    
- BestEffort and LowLatency QoSClass
    
- SSWG TLVs required for Reduced Profile
    
- optional CompactAuthTag
    

## **A.2.1 Valid Reduced ControlFrame With TLV**

Code

```
01 01 02 03 81 01 7F
```

Meaning:

- FrameType = ControlFrame
    
- QoSClass = LowLatency
    
- FreshnessTag = 2
    
- TLVContainerLength = 3
    
- TLV: Key=0x01, Length=1, Value=0x7F
    

Device MUST accept.

## **A.2.2 Valid Reduced DataFrame Without TLVs**

Code

```
00 00 10 00
```

Device MUST accept.

## **A.2.3 Invalid: Full‑Profile‑Only TLV**

Code

```
01 01 03 03 A0 01 01
```

Key 0xA0 is Full‑Profile‑only. Reduced Profile device MUST reject.

## **A.2.4 Invalid: AuthCritical QoSClass**

Code

```
00 06 01 00
```

QoSClass 0x06 (AuthCritical) is forbidden. Device MUST reject.

# **A.3 Full Profile Examples**

Full Profile devices support:

- all FrameTypes
    
- all QoSClasses
    
- all SSWG, A‑stack, and N‑stack TLVs
    
- CompactAuthTag
    
- full validation
    

## **A.3.1 Valid Full Profile DataFrame With Namespace TLV and Auth Tag**

Code

```
00 00 05 03 82 02 40 01 01 9A 7C 3F 12 88 4E
```

Meaning:

- FrameType = DataFrame
    
- QoSClass = BestEffort
    
- FreshnessTag = 5
    
- TLVContainerLength = 3
    
- TLV: NamespaceID (0x40), Length=1, Value=0x01
    
- CompactAuthTag = 8 bytes
    

Device MUST validate the tag and accept.

## **A.3.2 Valid Full Profile ControlCritical Frame**

Code

```
01 03 07 00  AA BB CC DD EE FF 11 22
```

Meaning:

- FrameType = ControlFrame
    
- QoSClass = ControlCritical (0x03)
    
- FreshnessTag = 7
    
- TLVContainerLength = 0
    
- CompactAuthTag = 8 bytes
    

Device MUST accept.

## **A.3.3 Invalid: Incorrect Auth Tag Length**

Code

```
00 00 05 03 82 02 40 01 01 9A 7C 3F 12
```

Only 6 bytes of tag present. Device MUST reject.

## **A.3.4 Invalid: Non‑Canonical Varint**

Code

```
00 00 81 00
```

FreshnessTag encoded non‑canonically. Device MUST reject.

## **A.3.5 Invalid: TLV Reordering**

Code

```
00 00 05 06 82 02 40 01 01 20 01 01 9A 7C 3F 12 88 4E
```

A‑stack TLV (0x20) appears after N‑stack TLV (0x40). Device MUST reject.

# **A.4 Relay Behavior Examples**

## **A.4.1 Valid Forwarding**

Relay receives:

Code

```
00 00 03 00
```

Relay MUST forward unchanged.

## **A.4.2 Invalid: Relay Attempted Modification**

If relay outputs:

Code

```
00 00 04 00
```

Relay is non‑compliant. FreshnessTag MUST NOT be modified.

## **A.4.3 Invalid: Relay Attempted TLV Injection**

If relay outputs:

Code

```
00 00 03 02 81 00
```

Relay is non‑compliant. TLVs MUST NOT be added.

# **A.5 Negative Examples (All Profiles)**

## **A.5.1 Truncated Frame**

Code

```
00 00 01
```

Device MUST reject.

## **A.5.2 Oversized TLVContainerLength**

Code

```
00 00 01 05 81 01 7F
```

TLVContainerLength = 5, but only 3 bytes follow. Device MUST reject.

## **A.5.3 Forbidden Metadata**

Any TLV containing:

- hardware‑bound identifiers
    
- timestamps
    
- user identifiers
    
- geographic coordinates
    

Device MUST reject.

# **A.6 Rationale**

Examples exist because:

- implementers misread text
    
- vendors over‑interpret flexibility
    
- interoperability depends on byte‑level precision
    
- negative examples prevent “creative compliance”
    

The Working Group therefore mandates strict adherence to all examples in this appendix.


# **Appendix B — Rationale & Design Notes**

This appendix documents the design rationale for L1. It explains the constraints, trade‑offs, and historical failures that shaped the final specification. These notes are not normative, but they provide essential context for understanding why the Working Group rejected numerous proposals that were, in hindsight, ambitious, misguided, or both.

The Working Group notes that implementers frequently attempt to “optimize” or “extend” L1 without understanding the architectural principles that constrain it. This appendix exists to discourage such behavior.

# **B.1 Why L1 Is Minimal**

L1 is intentionally minimal because:

- link conditions vary widely across SolNet deployments
    
- higher layers must remain free to evolve
    
- complexity at L1 creates interoperability failures
    
- statefulness at L1 creates congestion collapse
    
- extensibility at L1 creates fragmentation
    
- metadata at L1 creates privacy leaks
    

Every feature proposed for L1 was evaluated against the question:

> _“Does this belong at the bottom of an interplanetary network stack?”_

The answer was almost always **no**.

# **B.2 Why L1 Does Not Provide Reliability**

Reliability mechanisms (ACKs, retransmissions, windows, timers) were rejected because:

- they require synchronized state
    
- they require timing assumptions
    
- they collapse under long delays
    
- they conflict with DTN routing
    
- they duplicate higher‑layer functionality
    

L1 is a **best‑effort delivery substrate**, not a transport protocol.

# **B.3 Why L1 Does Not Provide Ordering**

Ordering was rejected because:

- ordering requires buffering
    
- buffering requires memory
    
- memory requires power
    
- power is scarce in many deployments
    
- ordering semantics differ across applications
    

Ordering belongs to higher layers that understand application context.

# **B.4 Why L1 Does Not Provide Fragmentation**

Fragmentation was rejected because:

- partial frames create ambiguity
    
- reassembly requires state
    
- state creates failure modes
    
- fragmentation interacts poorly with duty‑cycle limits
    
- fragmentation encourages oversized payloads
    

Fragmentation belongs to higher layers that can manage segmentation.

# **B.5 Why L1 Does Not Provide Confidentiality**

Confidentiality was rejected because:

- encryption requires key management
    
- key management requires trust domains
    
- trust domains belong to A‑stack
    
- confidentiality semantics differ across applications
    

L1 is not a cryptographic layer. Confidentiality belongs to higher layers.

# **B.6 Why L1 Authentication Is Minimal**

The CompactAuthTag exists solely to prevent:

- frame modification
    
- frame injection
    
- trivial impersonation
    

It does **not** attempt to provide:

- identity
    
- authorization
    
- replay protection
    
- trust establishment
    

These belong to A‑stack and N‑stack.

The Working Group rejected proposals for:

- full signatures
    
- per‑frame certificates
    
- multi‑tag authentication
    
- negotiable MAC algorithms
    

All were incompatible with L1’s constraints.

# **B.7 Why TLVs Are Strictly Categorized**

TLVs were categorized because:

- unconstrained TLVs lead to semantic drift
    
- vendors misuse TLVs to implement proprietary features
    
- TLV ordering affects parsing complexity
    
- TLV categories map cleanly to SolNet’s layer model
    

The Working Group rejected proposals for:

- “free‑form” TLVs
    
- “dynamic TLV negotiation”
    
- “TLV namespaces”
    
- “TLV compression”
    

All were deemed harmful.

# **B.8 Why Hardware Identifiers Are Forbidden**

Hardware‑bound identifiers (e.g., MAC/EUI‑48/EUI‑64, IMEI, serial numbers) were banned because:

- they leak identity
    
- they leak manufacturer
    
- they leak movement patterns
    
- they violate trust‑domain boundaries
    
- they cannot be rotated
    
- they cannot be scoped
    
- they cannot be anonymized
    

SolNet identity is **explicit, scoped, and revocable**. Hardware identity is none of these.

# **B.9 Why FreshnessTag Is Meaningless**

FreshnessTag is intentionally meaningless outside its comparison semantics because:

- timestamps leak information
    
- sequence numbers imply ordering
    
- counters imply state
    
- routing metrics imply topology
    

FreshnessTag exists solely to prevent trivial replay. Nothing more.

# **B.10 Why ProvenancePointer Is Not a Routing Field**

ProvenancePointer is a reference to higher‑layer state. It is not:

- a hop count
    
- a trust score
    
- a routing metric
    
- a path indicator
    

The Working Group rejected proposals to:

- embed routing hints
    
- embed trust hints
    
- embed loop‑detection metadata
    

All such proposals violated L1’s layer boundaries.

# **B.11 Why Profiles Exist**

Profiles exist because:

- not all devices can support Full Profile
    
- not all deployments require Full Profile
    
- some devices operate under severe constraints
    
- interoperability requires predictable capability sets
    

Profiles prevent:

- feature creep
    
- vendor fragmentation
    
- “almost‑compliant” devices
    
- inconsistent behavior across deployments
    

Profiles are not negotiable. Profiles are not dynamic. Profiles are not advisory.

# **B.12 Why Relays Are Dumb**

Relays are intentionally dumb because:

- “smart” relays rewrite frames
    
- “smart” relays introduce state
    
- “smart” relays create routing loops
    
- “smart” relays violate trust boundaries
    
- “smart” relays break authentication
    

Relays forward frames. Nothing more.

# **B.13 Why L1 Is Not Extensible**

L1 is not extensible because:

- extensibility invites fragmentation
    
- extensibility invites vendor lock‑in
    
- extensibility invites semantic drift
    
- extensibility invites security vulnerabilities
    

The Working Group rejected proposals for:

- extension headers
    
- optional fields
    
- dynamic negotiation
    
- vendor‑defined frame types
    

All were deemed harmful.

# **B.14 Why the Specification Is Strict**

The specification is strict because:

- ambiguity leads to incompatibility
    
- flexibility leads to misuse
    
- optionality leads to fragmentation
    
- “implementation freedom” leads to chaos
    

The Working Group has observed that implementers will exploit any ambiguity, however small, to justify non‑compliant behavior.

Strictness is a feature, not a burden.

# **B.15 Closing Note**

L1 is intentionally small, intentionally rigid, and intentionally unambitious. Its purpose is to provide a stable foundation for the rest of SolNet. Every rejected feature was rejected because it threatened that stability.

The Working Group therefore reminds implementers:

> _“If you think L1 should do more, you are thinking about the wrong layer.”_


# **Appendix C — Revision History**

This appendix records all substantive changes to the L1 specification across Working Group drafts. Editorial corrections, formatting adjustments, and typographical fixes are omitted unless they affect normative interpretation. The Working Group notes that vendors frequently misrepresent historical drafts to justify non‑compliant behavior; this appendix exists to eliminate such claims.

# **C.1 Draft 0.1 — Initial Skeleton (Unpublished)**

- Introduced basic frame structure (FrameType, QoSClass, FreshnessTag, TLVContainerLength).
    
- Defined DataFrame and KeepaliveFrame only.
    
- No TLVs, no authentication, no profiles.
    
- ProvenancePointer absent.
    
- Relay behavior undefined.
    
- Considered “structurally correct but semantically empty.”
    

The Working Group unanimously agreed this draft was insufficient for any deployment.

# **C.2 Draft 0.2 — Introduction of TLVs**

- Added TLVContainer and canonical varint encoding.
    
- Introduced SSWG TLV category (0–31).
    
- Added ControlFrame.
    
- Added ProvenancePointer (initially misnamed “ContextIndex”).
    
- Added minimal relay rules.
    

Rejected proposals:

- TLV namespaces
    
- TLV compression
    
- TLV negotiation
    

All rejected due to predictable misuse.

# **C.3 Draft 0.3 — Introduction of Profiles**

- Added Minimal, Reduced, and Full Profiles.
    
- Defined profile‑specific capabilities.
    
- Added QoSClass hierarchy.
    
- Added DiscoveryFrame.
    
- Added ErrorFrame.
    

Rejected proposals:

- dynamic profile negotiation
    
- vendor‑defined profiles
    
- “profile inheritance”
    

All rejected due to fragmentation risk.

# **C.4 Draft 0.4 — Authentication & Security**

- Added CompactAuthTag (HMAC‑SHA256 truncated to 8 bytes).
    
- Added AuthFrame.
    
- Added AuthCritical QoSClass.
    
- Added authentication failure semantics.
    
- Added key‑management constraints.
    

Rejected proposals:

- per‑frame signatures
    
- certificate chains
    
- multi‑tag authentication
    
- negotiable MAC algorithms
    

All rejected due to complexity and power constraints.

# **C.5 Draft 0.5 — Provenance & Freshness Clarification**

- Renamed “ContextIndex” to ProvenancePointer.
    
- Added strict monotonicity rules for FreshnessTag.
    
- Added wraparound semantics.
    
- Added provenance table rules.
    
- Added replay‑handling rules.
    

Rejected proposals:

- using FreshnessTag as a timestamp
    
- using ProvenancePointer as a hop count
    
- using either field as a routing metric
    

All rejected due to semantic drift.

# **C.6 Draft 0.6 — TLV Categorization**

- Added A‑stack TLVs (32–63).
    
- Added N‑stack TLVs (64–127).
    
- Added Vendor TLVs (128–255).
    
- Added strict ordering rules.
    
- Added strict category semantics.
    

Rejected proposals:

- “free‑form” TLVs
    
- vendor TLVs with routing semantics
    
- TLV‑based capability negotiation
    

All rejected due to interoperability failures.

# **C.7 Draft 0.7 — Relay & Forwarding Rules**

- Added strict relay behavior.
    
- Added loop‑prevention rules.
    
- Added forwarding constraints.
    
- Added prohibition on frame modification.
    

Rejected proposals:

- “smart relays”
    
- relay‑based routing
    
- relay‑based congestion control
    

All rejected due to security and correctness concerns.

# **C.8 Draft 0.8 — Operational Constraints**

- Added duty‑cycle rules.
    
- Added scheduling rules.
    
- Added congestion behavior.
    
- Added environmental constraints.
    
- Added logging minimization.
    

Rejected proposals:

- adaptive L1 behavior
    
- environment‑aware L1 behavior
    
- dynamic scheduling tiers
    

All rejected due to unpredictability.

# **C.9 Draft 0.9 — Privacy & Metadata Minimization**

- Added explicit prohibition of hardware‑bound identifiers.
    
- Added explicit prohibition of timestamps.
    
- Added explicit prohibition of user identifiers.
    
- Added explicit prohibition of geographic coordinates.
    
- Added traffic‑analysis constraints.
    

Rejected proposals:

- metadata obfuscation
    
- anonymization TLVs
    
- privacy‑preserving routing hints
    

All rejected due to false security guarantees.

# **C.10 Draft 1.0 — Finalization**

- Added compliance levels.
    
- Added test vectors.
    
- Added negative examples.
    
- Added rationale appendix.
    
- Added revision history.
    

Rejected proposals:

- “implementation flexibility”
    
- “vendor‑specific compliance tiers”
    
- “optional strictness”
    

All rejected due to the Working Group’s unanimous lack of trust in implementers.

# **C.11 Rationale for Revision History**

This appendix exists because:

- vendors misremember drafts
    
- implementers misinterpret changes
    
- marketing departments misrepresent compliance
    
- historical clarity prevents disputes
    
- normative changes must be traceable
    

The Working Group therefore mandates that all future revisions append to this history.


# **Appendix D — Glossary**

This glossary defines all normative terms used in the L1 specification. Terms are defined narrowly. Implementers MUST NOT reinterpret, extend, or generalize these definitions.

The Working Group notes that several interoperability failures were traced to implementers redefining terms “for convenience.” This appendix exists to prevent such behavior.

# **D.1 A‑Stack**

The authority‑plane layers responsible for trust domains, routing policy, identity resolution, and ephemeris hints. A‑stack metadata MUST NOT appear in L1 except via A‑stack TLVs.

# **D.2 Authentication Key**

A session‑scoped key used exclusively for computing the CompactAuthTag. It MUST NOT be reused across trust domains, transmitted in any TLV, or derived from hardware identifiers.

# **D.3 Canonical Varint**

A variable‑length integer encoding that uses the minimum number of bytes required to represent a value. Non‑canonical encodings MUST be rejected.

# **D.4 CompactAuthTag**

An 8‑byte truncated HMAC‑SHA256 authentication tag applied to L1 headers. It provides minimal integrity and authenticity guarantees. It is not a signature, not a certificate, and not a trust mechanism.

# **D.5 Compliance Level**

One of: Minimal Profile, Reduced Profile, Full Profile. A device MUST declare exactly one. Compliance levels are not negotiable.

# **D.6 DataFrame**

The primary frame type for transmitting payloads. It carries no routing semantics, no ordering semantics, and no reliability semantics.

# **D.7 DiscoveryFrame**

A frame type used for local namespace discovery. It MUST NOT be used for routing, trust establishment, or service advertisement beyond N‑stack semantics.

# **D.8 Duty Cycle**

The maximum allowable transmission time over a defined interval. Devices MUST NOT exceed their duty‑cycle allocation.

# **D.9 FreshnessTag**

A strictly monotonic, meaningless integer used solely for replay suppression. It MUST NOT encode timestamps, sequence numbers, or routing metrics.

# **D.10 FrameType**

A 1‑byte field identifying the type of L1 frame. FrameTypes MUST NOT be extended by vendors.

# **D.11 Hardware‑Bound Identifier**

Any globally unique, persistent identifier fused into hardware or firmware (e.g., MAC/EUI‑48/EUI‑64, IMEI, serial numbers). Such identifiers are forbidden in all L1 structures.

# **D.12 KeepaliveFrame**

A minimal frame used to signal link liveness. It carries no payload and no TLVs.

# **D.13 L1**

The SolNet link layer. It provides minimal framing, minimal authentication, and no routing, no reliability, no confidentiality, and no ordering.

# **D.14 Metadata Minimization**

The doctrine requiring that L1 emit only the metadata strictly necessary for operation. All identifying, redundant, or higher‑layer metadata is forbidden.

# **D.15 N‑Stack**

The namespace‑plane layers responsible for local discovery, session hints, and namespace identifiers. N‑stack metadata MUST NOT appear in L1 except via N‑stack TLVs.

# **D.16 Profile**

A defined capability set (Minimal, Reduced, Full) that constrains which features a device MUST or MAY support. Profiles MUST NOT be extended or modified by vendors.

# **D.17 ProvenancePointer**

A varint referencing a sender‑local provenance record. It is not a hop count, not a trust score, and not a routing metric.

# **D.18 QoSClass**

A 1‑byte field indicating scheduling priority. QoSClass MUST NOT encode application semantics or identifying information.

# **D.19 Relay**

A device that forwards validated frames without modification. Relays MUST NOT rewrite, reorder, or reinterpret frames.

# **D.20 Routing Policy**

A‑stack metadata describing how bundles are forwarded at higher layers. Routing policy MUST NOT appear in L1 except via A‑stack TLVs.

# **D.21 Session**

A bounded period during which a device maintains consistent authentication keys, provenance tables, and FreshnessTag monotonicity. Sessions MUST NOT span trust domains.

# **D.22 TLV (Type‑Length‑Value)**

A structured metadata element. TLVs MUST follow strict ordering and category rules. TLVs MUST NOT contain identifying information, routing hints, or application metadata.

# **D.23 TLVContainerLength**

A varint indicating the exact number of bytes of TLV data. It MUST match the actual container size. Mismatch requires rejection.

# **D.24 Trust Domain**

A logical grouping of devices sharing authentication keys and routing policy. Trust domains MUST NOT be inferred from L1 metadata.

# **D.25 Vendor TLV**

A TLV in the range 128–255. Vendor TLVs MUST NOT alter L1 semantics, introduce routing behavior, or leak identifying information.

# **D.26 Varint**

A variable‑length integer encoding. All varints MUST be canonical.

# **D.27 Working Group (SSWG)**

The SolNet Standards Working Group. Its decisions are final. Its tone is intentional. Its distrust of implementers is justified.


# **E.1 Notation Conventions**

The following conventions are used:

- `[]` indicates an optional element.
    
- `{}` indicates repetition (zero or more).
    
- `|` indicates alternation.
    
- `::=` indicates definition.
    
- `//` indicates a non‑normative comment.
    
- `BYTE` indicates an unsigned 8‑bit value.
    
- `VARINT` indicates a canonical variable‑length integer.
    
- `TLV` indicates a Type‑Length‑Value structure.
    

All grammar is expressed using a restricted EBNF variant.

# **E.2 Frame Grammar**

Code

```
FRAME ::= 
    FrameType:BYTE
    QoSClass:BYTE
    FreshnessTag:VARINT
    ProvenancePointer:VARINT
    TLVContainerLength:VARINT
    TLVContainer:BYTES(TLVContainerLength)
    [CompactAuthTag:BYTES(8)]
```

Constraints:

- `CompactAuthTag` is present **only** in Full Profile frames.
    
- `TLVContainerLength` MUST match the exact number of TLV bytes.
    
- `TLVContainer` MUST contain zero or more well‑formed TLVs.
    
- No additional fields are permitted.
    

# **E.3 TLV Grammar**

Code

```
TLV ::= 
    Key:BYTE
    Length:VARINT
    Value:BYTES(Length)
```

Constraints:

- `Key` MUST be in the range 0–255.
    
- `Length` MUST be canonical.
    
- `Value` MUST contain exactly `Length` bytes.
    
- TLVs MUST appear in ascending category order:
    
    - SSWG (0–31)
        
    - A‑stack (32–63)
        
    - N‑stack (64–127)
        
    - Vendor (128–255)
        

# **E.4 VARINT Encoding Rules**

A VARINT is encoded as:

- 7 bits of data per byte
    
- MSB = continuation flag
    
- shortest possible encoding MUST be used
    

Formal definition:

Code

```
VARINT ::= BYTE{1..9}
```

Constraints:

- Values 0–127 MUST be encoded in one byte.
    
- Leading zero bytes are forbidden.
    
- Overlong encodings MUST be rejected.
    
- Encodings longer than 9 bytes MUST be rejected.
    

# **E.5 CompactAuthTag Formal Definition**

Code

```
CompactAuthTag ::= BYTES(8)
```

Constraints:

- MUST be the first 8 bytes of HMAC‑SHA256 over the header fields.
    
- MUST NOT be truncated to fewer than 8 bytes.
    
- MUST NOT be extended.
    
- MUST NOT be replaced with any other MAC construction.
    

# **E.6 FrameType Enumeration**

Code

```
FrameType ::= 
      0x00 // DataFrame
    | 0x01 // ControlFrame
    | 0x02 // KeepaliveFrame
    | 0x03 // DiscoveryFrame
    | 0x04 // ErrorFrame
    | 0x05 // AuthFrame
```

Constraints:

- Vendors MUST NOT define new FrameTypes.
    
- FrameTypes MUST NOT be repurposed.
    

# **E.7 QoSClass Enumeration**

Code

```
QoSClass ::= 
      0x00 // BestEffort
    | 0x01 // LowLatency
    | 0x02 // Bulk
    | 0x03 // ControlCritical
    | 0x04 // Discovery
    | 0x05 // Keepalive
    | 0x06 // AuthCritical
```

Constraints:

- QoSClass MUST NOT encode application semantics.
    
- QoSClass MUST NOT leak identifying information.
    

# **E.8 TLV Category Ranges**

Code

```
SSWG-TLV     ::= Key in [0x00 .. 0x1F]
A-STACK-TLV  ::= Key in [0x20 .. 0x3F]
N-STACK-TLV  ::= Key in [0x40 .. 0x7F]
VENDOR-TLV   ::= Key in [0x80 .. 0xFF]
```

Constraints:

- Categories MUST NOT overlap.
    
- TLVs MUST appear in category order.
    
- Vendor TLVs MUST NOT alter L1 semantics.
    

# **E.9 ProvenancePointer Formal Definition**

Code

```
ProvenancePointer ::= VARINT
```

Constraints:

- MUST reference a sender‑local provenance record.
    
- MUST NOT encode routing information.
    
- MUST NOT encode trust‑domain information.
    
- MUST NOT encode timestamps or sequence numbers.
    

# **E.10 FreshnessTag Formal Definition**

Code

```
FreshnessTag ::= VARINT
```

Constraints:

- MUST be strictly monotonic within a session.
    
- MUST NOT encode timestamps.
    
- MUST NOT encode ordering semantics.
    
- MUST NOT encode routing metrics.
    

# **E.11 Profile Constraints (Formal)**

Code

```
MinimalProfile ::= 
    FRAME without TLVs
    FRAME without CompactAuthTag
    QoSClass == BestEffort
    FrameType in {DataFrame, KeepaliveFrame}

ReducedProfile ::=
    FRAME with SSWG TLVs
    FRAME MAY include A-STACK or N-STACK TLVs
    CompactAuthTag OPTIONAL
    FrameType in {DataFrame, ControlFrame, KeepaliveFrame, DiscoveryFrame}

FullProfile ::=
    FRAME with all TLV categories
    CompactAuthTag REQUIRED
    All FrameTypes permitted
```

Profiles MUST NOT be extended or modified.

# **E.12 Relay Behavior (Formal)**

Code

```
RelayAction ::= 
    VALIDATE(FRAME)
    IF VALID THEN FORWARD(FRAME)
    ELSE REJECT(FRAME)
```

Constraints:

- `FORWARD(FRAME)` MUST forward the frame **unchanged**.
    
- Relays MUST NOT modify any field.
    
- Relays MUST NOT reorder frames.
    
- Relays MUST NOT infer higher‑layer semantics.
    

# **E.13 Error Conditions (Formal)**

A frame MUST be rejected if:

Code

```
INVALID ::= 
      NonCanonicalVarint
    | TLVContainerLengthMismatch
    | InvalidTLVOrdering
    | InvalidTLVCategory
    | InvalidAuthTag
    | UnsupportedFrameType
    | UnsupportedQoSClass
    | ForbiddenMetadata
    | OversizedFrame
    | TruncatedFrame
```

# **E.14 Rationale**

Formal notation exists because:

- prose is ambiguous
    
- implementers are creative
    
- vendors are optimistic
    
- interoperability requires precision
    
- byte‑level behavior must be unambiguous
    

The Working Group therefore mandates strict adherence to this appendix.



# **Appendix F — Reference Implementation Notes**

This appendix provides guidance for implementers seeking to build compliant L1 devices. These notes are non‑normative, but they reflect the Working Group’s accumulated experience with common implementation errors, misinterpretations, and failure modes.

The Working Group notes that reference implementations are not authoritative; the specification is authoritative. Implementers MUST NOT treat these notes as permission to deviate from normative requirements.

# **F.1 Parsing Strategy**

Implementers SHOULD parse frames in the following order:

1. Read `FrameType` (1 byte)
    
2. Read `QoSClass` (1 byte)
    
3. Parse `FreshnessTag` (VARINT)
    
4. Parse `ProvenancePointer` (VARINT)
    
5. Parse `TLVContainerLength` (VARINT)
    
6. Read exactly `TLVContainerLength` bytes
    
7. If Full Profile: read 8‑byte `CompactAuthTag`
    

Parsing MUST fail immediately if:

- any VARINT is non‑canonical
    
- TLVContainerLength exceeds available bytes
    
- TLVs are malformed
    
- TLVs appear out of category order
    
- authentication tag is missing or incorrect (Full Profile)
    

Implementers MUST NOT attempt partial parsing, speculative parsing, or “best‑effort” parsing.

# **F.2 Memory Management**

Implementers SHOULD:

- allocate TLV buffers exactly to `TLVContainerLength`
    
- avoid dynamic resizing
    
- avoid speculative allocation
    
- avoid caching TLVs across frames
    

Implementers MUST NOT:

- reuse TLV buffers across sessions
    
- retain TLV contents for analytics
    
- store provenance records beyond session scope
    

Memory retention is a common source of privacy violations.

# **F.3 FreshnessTag Handling**

Implementers SHOULD:

- store the most recent FreshnessTag per sender
    
- compare using unsigned integer semantics
    
- handle wraparound exactly as defined
    

Implementers MUST NOT:

- treat FreshnessTag as a timestamp
    
- treat FreshnessTag as a sequence number
    
- treat FreshnessTag as a routing metric
    
- attempt to “correct” non‑monotonic tags
    

FreshnessTag misuse is a common source of replay vulnerabilities.

# **F.4 ProvenancePointer Handling**

Implementers SHOULD:

- maintain a local provenance table
    
- index provenance records by integer
    
- discard provenance records at session termination
    

Implementers MUST NOT:

- interpret provenance as routing information
    
- embed provenance in logs
    
- transmit provenance across trust domains
    

Provenance misuse is a common source of metadata leakage.

# **F.5 TLV Handling**

Implementers SHOULD:

- parse TLVs sequentially
    
- validate TLV category ordering
    
- validate TLV lengths strictly
    
- reject unknown TLVs in Minimal Profile
    
- ignore unknown TLVs in Reduced and Full Profiles (unless forbidden)
    

Implementers MUST NOT:

- reorder TLVs
    
- merge TLVs
    
- split TLVs
    
- rewrite TLVs
    
- infer semantics from TLV keys outside their category
    

TLV misuse is the most common source of interoperability failures.

# **F.6 Authentication Implementation Notes**

Implementers SHOULD:

- compute HMAC‑SHA256 using a constant‑time comparison
    
- pre‑allocate authentication buffers
    
- avoid streaming authentication across partial reads
    

Implementers MUST NOT:

- use non‑HMAC constructions
    
- use truncated keys
    
- use non‑canonical hashing libraries
    
- attempt to “optimize” tag computation by skipping fields
    

Authentication shortcuts are a common source of security failures.

# **F.7 Relay Implementation Notes**

Relays SHOULD:

- validate frames before forwarding
    
- forward frames unchanged
    
- track minimal loop‑prevention state
    

Relays MUST NOT:

- rewrite frames
    
- recompute authentication tags
    
- modify TLVs
    
- modify FreshnessTag
    
- modify ProvenancePointer
    

Relay “optimizations” are a common source of catastrophic failures.

# **F.8 Logging Implementation Notes**

Implementers SHOULD:

- log only error categories, not frame contents
    
- log only local timestamps
    
- log only non‑identifying metadata
    

Implementers MUST NOT:

- log payloads
    
- log TLV contents
    
- log provenance
    
- log authentication keys
    
- log hardware identifiers
    

Logging misuse is a common source of privacy violations.

# **F.9 Testing Recommendations**

Implementers SHOULD:

- test against all normative examples
    
- test negative examples aggressively
    
- test malformed TLVs
    
- test non‑canonical VARINTs
    
- test oversized TLVContainerLength
    
- test invalid authentication tags
    
- test relay behavior under load
    

Implementers MUST NOT:

- assume interoperability without testing
    
- assume compliance based on partial test suites
    
- assume vendor extensions are safe
    

Testing shortcuts are a common source of deployment failures.

# **F.10 Rationale**

Reference implementation notes exist because:

- implementers are creative in the wrong ways
    
- vendors optimize the wrong parts
    
- parsers drift over time
    
- privacy violations accumulate silently
    
- interoperability collapses without discipline
    

The Working Group therefore provides these notes as a practical guide to avoiding predictable mistakes.



# **Appendix G — Security Audit Checklist**

This checklist defines the mandatory items that MUST be verified during any security audit of an L1 implementation. Auditors MUST treat any failure as a non‑compliant, deployment‑blocking defect. Vendors MUST NOT claim compliance until all items pass.

The Working Group notes that most historical “security incidents” were caused not by sophisticated adversaries, but by implementers failing to follow basic requirements. This checklist exists to prevent such failures.

# **G.1 Authentication**

### **G.1.1 CompactAuthTag**

- [ ] CompactAuthTag is exactly 8 bytes
    
- [ ] Tag is computed over all header fields
    
- [ ] Tag uses HMAC‑SHA256
    
- [ ] Tag uses the correct session key
    
- [ ] Tag comparison is constant‑time
    
- [ ] Tag is present for all Full Profile frames
    
- [ ] Tag is absent for Minimal Profile frames
    

### **G.1.2 Key Handling**

- [ ] Keys are session‑scoped
    
- [ ] Keys are not reused across trust domains
    
- [ ] Keys are not derived from hardware identifiers
    
- [ ] Keys are never transmitted in TLVs
    
- [ ] Keys are never logged
    
- [ ] Keys are zeroized at session termination
    

# **G.2 Metadata Minimization**

### **G.2.1 Forbidden Metadata**

Verify that no L1 structure contains:

- [ ] hardware‑bound identifiers
    
- [ ] user identifiers
    
- [ ] geographic coordinates
    
- [ ] timestamps
    
- [ ] application‑layer session IDs
    
- [ ] cryptographic key fingerprints
    
- [ ] routing hints
    
- [ ] trust‑domain identifiers
    

### **G.2.2 TLV Minimization**

- [ ] TLVs contain only L1‑relevant metadata
    
- [ ] No redundant fields
    
- [ ] No debugging information
    
- [ ] No analytics data
    
- [ ] No vendor tracking identifiers
    

# **G.3 Frame Validation**

### **G.3.1 Structural Validation**

- [ ] All VARINTs are canonical
    
- [ ] TLVContainerLength matches actual TLV bytes
    
- [ ] TLVs appear in correct category order
    
- [ ] No unknown TLVs in Minimal Profile
    
- [ ] No Full‑Profile‑only TLVs in Reduced Profile
    

### **G.3.2 Negative Case Handling**

- [ ] Malformed frames are rejected
    
- [ ] Truncated frames are rejected
    
- [ ] Oversized frames are rejected
    
- [ ] Invalid TLVs are rejected
    
- [ ] Invalid authentication tags are rejected
    
- [ ] Forbidden metadata triggers rejection
    

# **G.4 Freshness & Replay**

### **G.4.1 FreshnessTag**

- [ ] FreshnessTag is strictly monotonic
    
- [ ] FreshnessTag does not encode timestamps
    
- [ ] FreshnessTag does not encode sequence numbers
    
- [ ] FreshnessTag does not encode routing metrics
    

### **G.4.2 Replay Handling**

- [ ] Device tracks most recent FreshnessTag per sender
    
- [ ] Older tags are rejected
    
- [ ] Equal or newer tags are accepted
    
- [ ] No long replay windows
    
- [ ] No cross‑session tag correlation
    

# **G.5 Provenance**

### **G.5.1 ProvenancePointer**

- [ ] ProvenancePointer references a valid local record
    
- [ ] ProvenancePointer does not encode routing information
    
- [ ] ProvenancePointer does not encode trust information
    
- [ ] ProvenancePointer does not encode timestamps
    
- [ ] ProvenancePointer is not logged
    

### **G.5.2 Provenance Records**

- [ ] Records are session‑scoped
    
- [ ] Records are not retained across sessions
    
- [ ] Records are not transmitted across trust domains
    

# **G.6 Relay Behavior**

### **G.6.1 Forwarding Rules**

- [ ] Relay validates frames before forwarding
    
- [ ] Relay forwards frames unchanged
    
- [ ] Relay does not modify TLVs
    
- [ ] Relay does not modify FreshnessTag
    
- [ ] Relay does not modify ProvenancePointer
    
- [ ] Relay does not recompute authentication tags
    

### **G.6.2 Loop Prevention**

- [ ] Relay tracks minimal loop‑prevention state
    
- [ ] Relay rejects looping frames
    
- [ ] Relay does not introduce hop counters
    
- [ ] Relay does not modify provenance to break loops
    

# **G.7 Logging**

### **G.7.1 Allowed Logging**

- [ ] Only error categories are logged
    
- [ ] Only local timestamps are logged
    
- [ ] Logs contain no identifying metadata
    

### **G.7.2 Forbidden Logging**

- [ ] No payload contents
    
- [ ] No TLV contents
    
- [ ] No provenance
    
- [ ] No authentication keys
    
- [ ] No hardware identifiers
    
- [ ] No trust‑domain identifiers
    

# **G.8 Operational Constraints**

### **G.8.1 Duty Cycle**

- [ ] Device does not exceed duty‑cycle limits
    
- [ ] No burst behavior violating constraints
    
- [ ] No “borrowing” future duty cycle
    

### **G.8.2 Scheduling**

- [ ] QoSClass semantics are respected
    
- [ ] No reordering within a QoSClass
    
- [ ] No provenance‑based prioritization
    
- [ ] No freshness‑based prioritization
    

### **G.8.3 Environmental Behavior**

- [ ] Device does not relax validation rules
    
- [ ] Device does not bypass authentication
    
- [ ] Device does not infer missing data
    

# **G.9 Vendor Extensions**

### **G.9.1 Vendor TLVs**

- [ ] Vendor TLVs do not alter L1 semantics
    
- [ ] Vendor TLVs do not embed identifying information
    
- [ ] Vendor TLVs do not embed routing hints
    
- [ ] Vendor TLVs do not embed trust‑domain metadata
    

### **G.9.2 Extension Boundaries**

- [ ] No vendor‑defined FrameTypes
    
- [ ] No vendor‑defined QoSClasses
    
- [ ] No vendor‑defined profiles
    

# **G.10 Final Audit Outcome**

A device is considered **security‑compliant** only if:

- [ ] All checklist items pass
    
- [ ] All negative tests pass
    
- [ ] All profile‑specific constraints are satisfied
    
- [ ] No forbidden metadata is emitted
    
- [ ] No deviations are justified as “optimizations”
    

Any failure MUST block deployment.




# **Appendix H — Interoperability Matrix**

This appendix defines the mandatory interoperability relationships between devices implementing different L1 profiles. A device is considered interoperable only if it can exchange frames with all devices listed in the matrix under the conditions defined in this specification.

The Working Group notes that several vendors have historically claimed interoperability based on “successful tests” that omitted critical cases such as malformed frames, profile mismatches, or TLV ordering violations. This appendix exists to prevent such claims.

# **H.1 Profile Interoperability Overview**

| **Sender** →

|**Receiver** ↓|**Minimal**|**Reduced**|**Full**|
|---|---|---|---|
|**Minimal**|MUST interoperate|MUST interoperate|MUST interoperate|
|**Reduced**|MUST interoperate|MUST interoperate|MUST interoperate|
|**Full**|MUST interoperate|MUST interoperate|MUST interoperate|

Interoperability is mandatory across all profiles. However, the _scope_ of interoperability differs by profile.

# **H.2 Minimal Profile Interoperability Requirements**

Minimal Profile devices MUST:

- accept DataFrame and KeepaliveFrame from all profiles
    
- ignore all TLVs (by rejecting the frame)
    
- reject all authentication tags
    
- reject all unsupported QoSClasses
    
- forward only Minimal‑compliant frames
    

Minimal Profile devices MUST NOT:

- attempt to parse TLVs
    
- attempt to validate authentication tags
    
- attempt to interpret higher‑layer semantics
    

Minimal Profile devices interoperate by **rejecting everything they cannot understand**.

# **H.3 Reduced Profile Interoperability Requirements**

Reduced Profile devices MUST:

- accept Minimal Profile frames
    
- accept Reduced Profile frames
    
- accept Full Profile frames **only if** they contain no Full‑Profile‑only TLVs
    
- ignore unknown TLVs within allowed categories
    
- validate CompactAuthTag if present
    
- reject Full‑Profile‑only QoSClasses
    

Reduced Profile devices MUST NOT:

- accept AuthFrame
    
- accept AuthCritical QoSClass
    
- accept Full‑Profile‑only TLVs
    

Reduced Profile devices interoperate by **supporting a constrained subset of Full Profile semantics**.

# **H.4 Full Profile Interoperability Requirements**

Full Profile devices MUST:

- accept all Minimal and Reduced Profile frames
    
- accept all Full Profile frames
    
- validate all TLVs
    
- validate CompactAuthTag
    
- enforce all category ordering rules
    
- enforce all profile boundaries
    

Full Profile devices MUST NOT:

- relax validation rules for lower profiles
    
- infer missing metadata
    
- accept malformed TLVs “for compatibility”
    

Full Profile devices interoperate by **strictly validating everything**.

# **H.5 TLV Interoperability Matrix**

|**TLV Category**|**Minimal**|**Reduced**|**Full**|
|---|---|---|---|
|**SSWG (0–31)**|MUST reject|MUST accept|MUST accept|
|**A‑stack (32–63)**|MUST reject|MAY accept|MUST accept|
|**N‑stack (64–127)**|MUST reject|MAY accept|MUST accept|
|**Vendor (128–255)**|MUST reject|MAY accept|MUST accept|

Notes:

- “MAY accept” means the device must ignore unknown TLVs, not reject them.
    
- “MUST reject” means the entire frame is rejected, not just the TLV.
    
- Vendor TLVs MUST NOT alter L1 semantics.
    

# **H.6 QoSClass Interoperability Matrix**

|**QoSClass**|**Minimal**|**Reduced**|**Full**|
|---|---|---|---|
|BestEffort (0x00)|MUST accept|MUST accept|MUST accept|
|LowLatency (0x01)|MUST reject|MUST accept|MUST accept|
|Bulk (0x02)|MUST reject|MUST accept|MUST accept|
|ControlCritical (0x03)|MUST reject|MUST accept|MUST accept|
|Discovery (0x04)|MUST reject|MUST accept|MUST accept|
|Keepalive (0x05)|MUST accept|MUST accept|MUST accept|
|AuthCritical (0x06)|MUST reject|MUST reject|MUST accept|

Minimal Profile devices accept only BestEffort and Keepalive. Reduced Profile devices accept all except AuthCritical. Full Profile devices accept all.

# **H.7 Authentication Interoperability Matrix**

|**Sender**|**Receiver**|**Expected Behavior**|
|---|---|---|
|Minimal → Reduced|MUST accept (no tag)|
|Minimal → Full|MUST accept (no tag)|
|Reduced → Minimal|MUST reject (tag present)|
|Reduced → Full|MUST accept (tag optional)|
|Full → Minimal|MUST reject (tag present)|
|Full → Reduced|MUST accept only if tag optional|
|Full → Full|MUST accept (tag required)|

Notes:

- Minimal Profile devices MUST reject authenticated frames.
    
- Reduced Profile devices MAY accept authenticated frames.
    
- Full Profile devices MUST authenticate all Full Profile frames.
    

# **H.8 Relay Interoperability Requirements**

Relays MUST:

- forward Minimal, Reduced, and Full frames unchanged
    
- validate before forwarding
    
- reject malformed frames
    
- enforce profile boundaries
    

Relays MUST NOT:

- rewrite frames
    
- recompute authentication tags
    
- reorder TLVs
    
- alter QoSClass
    
- alter FreshnessTag
    
- alter ProvenancePointer
    

Relay interoperability depends entirely on **non‑interference**.

# **H.9 Negative Interoperability Cases**

Devices MUST reject:

- frames with non‑canonical VARINTs
    
- frames with invalid TLV ordering
    
- frames with forbidden metadata
    
- frames with invalid authentication tags
    
- frames exceeding profile limits
    
- frames containing Full‑Profile‑only TLVs (if Reduced Profile)
    
- frames containing any TLVs (if Minimal Profile)
    

These cases MUST NOT be treated as “partial success.”

# **H.10 Rationale**

The interoperability matrix exists because:

- vendors overstate compatibility
    
- implementers test only “happy paths”
    
- profile boundaries drift without enforcement
    
- TLV misuse is common
    
- authentication handling is inconsistent
    
- QoSClass semantics are frequently misinterpreted
    

The Working Group therefore mandates strict, matrix‑based interoperability verification.

If you want, we can proceed to **Appendix I — Deployment Scenarios**, or begin drafting **RFC‑2350 (Canonical Addressing Standard)**.

h

Here is **Appendix H — Interoperability Matrix**, written in the same institutional, dry, quietly exasperated SSWG tone. This appendix exists because vendors routinely claim “interoperability” based on ad‑hoc testing with devices that accidentally behaved similarly. The matrix defines _exactly_ which combinations of profiles, features, and behaviors MUST interoperate — and which MUST NOT.

No meta. No scaffolding. Just the matrix, as the SSWG would publish it.

# **Appendix H — Interoperability Matrix**

This appendix defines the mandatory interoperability relationships between devices implementing different L1 profiles. Interoperability is defined strictly as: _the ability to exchange valid frames without modification, reinterpretation, or vendor‑specific extensions._

The Working Group notes that vendors frequently misrepresent partial or accidental compatibility as “full interoperability.” This appendix exists to eliminate such claims.

# **H.1 Profile Interoperability Overview**

|**Sender Profile**|**Receiver Profile**|**Interoperability**|**Notes**|
|---|---|---|---|
|Minimal|Minimal|REQUIRED|Only DataFrame + KeepaliveFrame.|
|Minimal|Reduced|REQUIRED|Reduced MUST accept Minimal frames.|
|Minimal|Full|REQUIRED|Full MUST accept Minimal frames.|
|Reduced|Minimal|FORBIDDEN|Minimal MUST reject TLVs.|
|Reduced|Reduced|REQUIRED|TLVs must be valid and category‑correct.|
|Reduced|Full|REQUIRED|Full MUST accept Reduced frames.|
|Full|Minimal|FORBIDDEN|Minimal MUST reject TLVs and AuthTag.|
|Full|Reduced|CONDITIONAL|Reduced MUST reject Full‑only TLVs and AuthCritical QoS.|
|Full|Full|REQUIRED|Authentication mandatory.|

Interoperability is **asymmetric** by design. Higher‑profile devices MUST accept lower‑profile frames; lower‑profile devices MUST reject higher‑profile frames.

# **H.2 FrameType Interoperability**

|**FrameType**|**Minimal**|**Reduced**|**Full**|**Notes**|
|---|---|---|---|---|
|DataFrame|✓|✓|✓|Always supported.|
|ControlFrame|✗|✓|✓|Minimal MUST reject.|
|KeepaliveFrame|✓|✓|✓|Always supported.|
|DiscoveryFrame|✗|MAY|✓|Reduced MAY support.|
|ErrorFrame|✗|✓|✓|Minimal MUST reject.|
|AuthFrame|✗|✗|✓|Only Full Profile.|

# **H.3 QoSClass Interoperability**

|**QoSClass**|**Minimal**|**Reduced**|**Full**|**Notes**|
|---|---|---|---|---|
|BestEffort|✓|✓|✓|Always supported.|
|LowLatency|✗|✓|✓|Minimal MUST reject.|
|Bulk|✗|✓|✓|Minimal MUST reject.|
|ControlCritical|✗|✓|✓|Minimal MUST reject.|
|Discovery|✗|✓|✓|Minimal MUST reject.|
|Keepalive|✓|✓|✓|Always supported.|
|AuthCritical|✗|✗|✓|Only Full Profile.|

# **H.4 TLV Interoperability**

|**TLV Category**|**Minimal**|**Reduced**|**Full**|**Notes**|
|---|---|---|---|---|
|SSWG (0–31)|✗|✓|✓|Minimal MUST reject all TLVs.|
|A‑stack (32–63)|✗|MAY|✓|Reduced MAY support.|
|N‑stack (64–127)|✗|MAY|✓|Reduced MAY support.|
|Vendor (128–255)|✗|✓|✓|Vendor TLVs MUST NOT alter semantics.|

# **H.5 Authentication Interoperability**

|**Sender**|**Receiver**|**Auth Required?**|**Notes**|
|---|---|---|---|
|Minimal|Any|NO|Minimal never authenticates.|
|Reduced|Minimal|N/A|Minimal rejects TLVs anyway.|
|Reduced|Reduced|OPTIONAL|Reduced MAY authenticate.|
|Reduced|Full|OPTIONAL|Full MUST validate if present.|
|Full|Minimal|FORBIDDEN|Minimal MUST reject AuthTag.|
|Full|Reduced|CONDITIONAL|Reduced MUST reject AuthCritical QoS.|
|Full|Full|REQUIRED|Authentication mandatory.|

# **H.6 Relay Interoperability**

Relays MUST forward:

- Minimal → Minimal
    
- Minimal → Reduced
    
- Minimal → Full
    
- Reduced → Reduced
    
- Reduced → Full
    
- Full → Full
    

Relays MUST NOT forward:

- Reduced → Minimal
    
- Full → Minimal
    
- Full → Reduced (if TLVs or QoS exceed Reduced capabilities)
    

Relays MUST NOT:

- rewrite frames
    
- downgrade frames
    
- upgrade frames
    
- strip authentication
    
- inject TLVs
    

# **H.7 Negative Interoperability Cases**

The following MUST be rejected by all compliant devices:

- Full Profile frames sent to Minimal Profile receivers
    
- Any TLV sent to Minimal Profile receivers
    
- Full‑only TLVs sent to Reduced Profile receivers
    
- AuthCritical QoS sent to Reduced Profile receivers
    
- Non‑canonical VARINTs
    
- Forbidden metadata in any profile
    
- Vendor TLVs that alter semantics
    

These cases are non‑negotiable.

# **H.8 Rationale**

The interoperability matrix exists because:

- implementers overestimate compatibility
    
- vendors misrepresent capability
    
- asymmetric profiles require explicit rules
    
- TLV misuse is common
    
- authentication behavior varies by profile
    
- relay behavior is frequently misunderstood
    

The Working Group therefore mandates strict, table‑driven interoperability requirements.


# **Appendix I — Deployment Scenarios**

This appendix describes representative deployment scenarios for L1. These scenarios are non‑normative but reflect the operational environments for which L1 was designed. Deployments outside these scenarios frequently exhibit failure modes that are not the responsibility of the specification.

The Working Group notes that several vendors have attempted to deploy L1 in environments requiring confidentiality, reliability, or routing semantics. Such deployments are categorically unsupported.

# **I.1 Supported Deployment Scenarios**

These scenarios align with L1’s design constraints and are considered fully supported.

## **I.1.1 Low‑Power Planetary Surface Links**

Characteristics:

- intermittent connectivity
    
- severe duty‑cycle limits
    
- low‑power radios
    
- short‑range communication
    
- minimal processing capability
    

L1 is appropriate because:

- Minimal Profile is sufficient
    
- TLVs are unnecessary
    
- authentication is optional
    
- replay protection is minimal
    

Common failure mode:

- vendors attempt to add reliability at L1
    
- vendors attempt to embed timestamps in FreshnessTag
    

## **I.1.2 Habitat‑Local Mesh Networks**

Characteristics:

- moderate link quality
    
- mixed device capabilities
    
- local namespace discovery required
    
- occasional congestion
    

L1 is appropriate because:

- Reduced Profile provides necessary TLVs
    
- DiscoveryFrame is useful
    
- authentication MAY be used
    

Common failure mode:

- vendors misuse N‑stack TLVs for routing hints
    

## **I.1.3 Intra‑Vehicle Links (Rovers, Landers, Shuttles)**

Characteristics:

- predictable topology
    
- moderate bandwidth
    
- strict safety requirements
    
- deterministic scheduling
    

L1 is appropriate because:

- ControlCritical QoSClass is available
    
- Full Profile authentication is available
    
- TLV categories map cleanly to A‑stack and N‑stack
    

Common failure mode:

- vendors attempt to use L1 for command sequencing
    

## **I.1.4 Short‑Range Orbital Links**

Characteristics:

- moderate delay
    
- predictable line‑of‑sight windows
    
- mixed trust domains
    

L1 is appropriate because:

- Full Profile authentication prevents injection
    
- TLVs support routing policy hints (via A‑stack)
    
- relay behavior is deterministic
    

Common failure mode:

- vendors attempt to use ProvenancePointer as a hop counter
    

# **I.2 Conditionally Supported Deployment Scenarios**

These scenarios are supported only if implementers strictly adhere to profile boundaries and do not attempt to extend L1 semantics.

## **I.2.1 High‑Latency Planetary Relay Chains**

Characteristics:

- long delays
    
- multiple relays
    
- intermittent connectivity
    

L1 is conditionally appropriate because:

- replay semantics remain valid
    
- relays can forward frames unchanged
    

Conditional requirement:

- higher layers MUST handle routing and reliability
    

Common failure mode:

- vendors attempt to add hop‑count TLVs
    

## **I.2.2 Mixed‑Profile Environments**

Characteristics:

- Minimal, Reduced, and Full devices coexist
    
- asymmetric interoperability
    
- heterogeneous capabilities
    

L1 is conditionally appropriate because:

- interoperability matrix defines strict behavior
    

Conditional requirement:

- operators MUST NOT rely on Reduced or Minimal devices to handle authenticated traffic
    

Common failure mode:

- vendors assume “down‑negotiation” is possible
    

## **I.2.3 High‑Density Meshes**

Characteristics:

- many devices
    
- frequent collisions
    
- variable link quality
    

L1 is conditionally appropriate because:

- QoSClass provides minimal prioritization
    
- TLVs support limited coordination
    

Conditional requirement:

- congestion control MUST be implemented at higher layers
    

Common failure mode:

- vendors attempt to implement congestion control at L1
    

# **I.3 Unsupported Deployment Scenarios**

These scenarios are explicitly unsupported. Deployments in these environments will fail, and such failures are not defects in the specification.

## **I.3.1 Confidential or Sensitive Environments**

Unsupported because:

- L1 provides no confidentiality
    
- metadata is fully observable
    
- TLVs leak structure
    
- authentication does not hide sender identity
    

Common vendor mistake:

- assuming CompactAuthTag provides confidentiality
    

## **I.3.2 High‑Reliability or Real‑Time Control Systems**

Unsupported because:

- L1 provides no ordering
    
- L1 provides no reliability
    
- L1 provides no timing guarantees
    
- L1 provides no delivery confirmation
    

Common vendor mistake:

- attempting to use L1 for actuator control
    

## **I.3.3 Long‑Haul Interplanetary Links**

Unsupported because:

- L1 assumes local link semantics
    
- L1 replay semantics break under extreme delay
    
- L1 authentication does not scale across trust domains
    
- L1 is not a DTN protocol
    

Common vendor mistake:

- attempting to use L1 as a replacement for Bundle Protocol
    

## **I.3.4 Multi‑Hop Routing Without A‑Stack**

Unsupported because:

- L1 has no routing semantics
    
- ProvenancePointer is not a routing field
    
- TLVs cannot encode routing hints
    
- relays cannot modify frames
    

Common vendor mistake:

- attempting to implement routing via Vendor TLVs
    

# **I.4 Deployment Anti‑Patterns**

The following deployment patterns are universally discouraged:

- using L1 as a transport protocol
    
- using L1 as a routing protocol
    
- embedding application metadata in TLVs
    
- embedding trust‑domain identifiers in TLVs
    
- using FreshnessTag as a timestamp
    
- using ProvenancePointer as a hop counter
    
- relying on Vendor TLVs for core functionality
    

These patterns violate the architecture and will fail.

# **I.5 Rationale**

Deployment scenarios exist because:

- implementers deploy L1 into environments it cannot support
    
- vendors overestimate L1’s capabilities
    
- operators misunderstand profile boundaries
    
- higher‑layer responsibilities are frequently ignored
    

The Working Group therefore provides explicit guidance to prevent predictable failures.


# **Appendix J — Failure Mode Catalog**

This appendix catalogs the most common, most destructive, and most predictable failure modes observed in L1 implementations. The list is not exhaustive; implementers continue to innovate in undesirable directions. However, these failure modes represent the overwhelming majority of interoperability, security, and operational incidents.

The Working Group notes that nearly all failures arise from violating explicit requirements. This appendix exists to help operators diagnose such violations quickly.

# **J.1 Structural Failure Modes**

## **J.1.1 Non‑Canonical VARINTs**

Symptoms:

- frames rejected by Full Profile devices
    
- inconsistent parsing across vendors
    
- replay logic malfunctioning
    

Cause:

- implementers encoding integers with unnecessary continuation bytes
    

Impact:

- total interoperability failure
    

## **J.1.2 Incorrect TLVContainerLength**

Symptoms:

- truncated TLVs
    
- parser crashes
    
- inconsistent behavior across profiles
    

Cause:

- implementers computing length before encoding TLVs
    
- implementers forgetting to update length after modification
    

Impact:

- mandatory rejection by all profiles
    

## **J.1.3 TLV Category Misordering**

Symptoms:

- Full Profile devices rejecting frames
    
- Reduced Profile devices behaving inconsistently
    

Cause:

- implementers sorting TLVs lexicographically instead of by category
    

Impact:

- complete loss of interoperability
    

# **J.2 Semantic Failure Modes**

## **J.2.1 FreshnessTag Misuse**

Symptoms:

- replay loops
    
- inconsistent acceptance/rejection
    
- devices “time‑traveling” relative to each other
    

Cause:

- implementers treating FreshnessTag as a timestamp or sequence number
    

Impact:

- replay protection collapse
    

## **J.2.2 ProvenancePointer Misinterpretation**

Symptoms:

- routing loops
    
- trust‑domain leakage
    
- inconsistent forwarding behavior
    

Cause:

- implementers treating ProvenancePointer as a hop count or trust score
    

Impact:

- routing failures at higher layers
    
- privacy violations
    

## **J.2.3 TLV Semantics Drift**

Symptoms:

- devices interpreting TLVs differently
    
- vendor‑specific behavior emerging
    
- inconsistent routing or namespace behavior
    

Cause:

- implementers inferring semantics from TLV keys
    
- vendors overloading TLVs for application metadata
    

Impact:

- fragmentation of the ecosystem
    

# **J.3 Authentication Failure Modes**

## **J.3.1 Incorrect CompactAuthTag Computation**

Symptoms:

- Full Profile devices rejecting all frames
    
- Reduced Profile devices accepting frames inconsistently
    

Cause:

- implementers hashing the wrong fields
    
- implementers using non‑canonical HMAC libraries
    
- implementers truncating incorrectly
    

Impact:

- total authentication failure
    

## **J.3.2 Key Reuse Across Trust Domains**

Symptoms:

- cross‑domain impersonation
    
- replay attacks
    
- provenance confusion
    

Cause:

- implementers storing keys in persistent memory
    
- vendors optimizing key distribution
    

Impact:

- catastrophic trust‑domain collapse
    

## **J.3.3 Authentication Bypass**

Symptoms:

- devices accepting unauthenticated Full Profile frames
    
- inconsistent enforcement across vendors
    

Cause:

- implementers treating authentication as “optional”
    
- implementers attempting to “fail open”
    

Impact:

- injection attacks
    
- silent corruption
    

# **J.4 Relay Failure Modes**

## **J.4.1 Frame Modification**

Symptoms:

- authentication failures downstream
    
- inconsistent FreshnessTag behavior
    
- TLV corruption
    

Cause:

- implementers attempting to “fix” frames
    
- relays rewriting TLVs or QoSClass
    

Impact:

- total loss of trust in relay path
    

## **J.4.2 Relay‑Induced Loops**

Symptoms:

- repeated frames
    
- congestion collapse
    
- replay logic exhaustion
    

Cause:

- relays failing to track minimal loop‑prevention state
    
- relays modifying provenance
    

Impact:

- network instability
    

## **J.4.3 Relay Downgrading**

Symptoms:

- Full Profile frames arriving without authentication
    
- TLVs missing
    
- QoSClass altered
    

Cause:

- implementers attempting to “help” lower‑profile devices
    

Impact:

- security violations
    
- profile boundary collapse
    

# **J.5 Metadata Leakage Failure Modes**

## **J.5.1 Hardware‑Bound Identifiers in TLVs**

Symptoms:

- persistent tracking of devices
    
- cross‑domain correlation
    
- privacy violations
    

Cause:

- vendors embedding MAC/EUI‑64/IMEI/serial numbers in TLVs
    

Impact:

- non‑compliance
    
- regulatory violations
    

## **J.5.2 Timestamp Leakage**

Symptoms:

- device movement tracking
    
- session correlation
    
- privacy violations
    

Cause:

- implementers embedding timestamps in FreshnessTag or TLVs
    

Impact:

- metadata minimization failure
    

## **J.5.3 Application Metadata Leakage**

Symptoms:

- application‑layer identifiers visible at L1
    
- cross‑layer coupling
    
- privacy violations
    

Cause:

- implementers embedding session IDs, user IDs, or routing hints in TLVs
    

Impact:

- non‑compliance
    
- unpredictable behavior
    

# **J.6 Operational Failure Modes**

## **J.6.1 Duty‑Cycle Violations**

Symptoms:

- regulatory non‑compliance
    
- link starvation
    
- device overheating
    

Cause:

- implementers ignoring duty‑cycle constraints
    
- vendors optimizing for throughput
    

Impact:

- link instability
    
- legal consequences
    

## **J.6.2 Congestion Collapse**

Symptoms:

- frames dropped unpredictably
    
- QoSClass ignored
    
- relays overwhelmed
    

Cause:

- implementers attempting congestion control at L1
    
- excessive retransmissions at higher layers
    

Impact:

- network unusable
    

## **J.6.3 Logging Violations**

Symptoms:

- logs containing identifying metadata
    
- logs containing TLVs
    
- logs containing provenance
    

Cause:

- implementers logging everything “for debugging”
    

Impact:

- privacy violations
    
- trust‑domain leakage
    

# **J.7 Vendor‑Induced Failure Modes**

## **J.7.1 Vendor TLV Abuse**

Symptoms:

- routing behavior altered
    
- trust semantics altered
    
- devices incompatible across vendors
    

Cause:

- vendors using Vendor TLVs for core functionality
    

Impact:

- ecosystem fragmentation
    

## **J.7.2 Profile Drift**

Symptoms:

- devices claiming “hybrid” or “extended” profiles
    
- inconsistent capabilities
    
- unpredictable interoperability
    

Cause:

- vendors adding features outside profile boundaries
    

Impact:

- collapse of profile model
    

## **J.7.3 Silent Non‑Compliance**

Symptoms:

- devices passing basic tests but failing in deployment
    
- inconsistent behavior under load
    
- partial parsing
    

Cause:

- vendors implementing only the examples, not the rules
    

Impact:

- unpredictable failures
    

# **J.8 Rationale**

The failure mode catalog exists because:

- implementers repeat the same mistakes
    
- vendors optimize the wrong components
    
- operators misdiagnose failures
    
- interoperability collapses without shared terminology
    

The Working Group therefore documents these failure modes to accelerate diagnosis and prevent recurrence.


# **Appendix K — Conformance Markings**

This appendix defines the **only** conformance markings that vendors MAY apply to devices implementing L1. These markings exist solely to indicate which profile a device conforms to and whether it has passed the mandatory compliance test suite.

The Working Group notes that vendors have historically applied misleading labels such as “L1‑Compatible,” “SolNet‑Ready,” “Profile‑Enhanced,” and “Extended‑Compliance.” All such markings are prohibited.

# **K.1 Allowed Conformance Markings**

A device MAY display **exactly one** of the following profile markings:

- **SolNet L1 — Minimal Profile**
    
- **SolNet L1 — Reduced Profile**
    
- **SolNet L1 — Full Profile**
    

A device MAY additionally display:

- **SolNet L1 — Compliance Verified**
    

No other markings are permitted.

# **K.2 Marking Requirements**

## **K.2.1 Exclusivity**

- A device MUST display **exactly one** profile marking.
    
- A device MUST NOT display multiple profile markings.
    
- A device MUST NOT display a profile marking inconsistent with its declared compliance level.
    

## **K.2.2 Accuracy**

- A device MUST pass all mandatory compliance tests before displaying **Compliance Verified**.
    
- A device MUST NOT display **Compliance Verified** if any test is incomplete, skipped, or failed.
    
- A device MUST NOT display markings for features it does not implement.
    

## **K.2.3 Placement**

Markings MAY appear:

- on device packaging
    
- in device documentation
    
- in device configuration interfaces
    

Markings MUST NOT appear:

- in TLVs
    
- in frames
    
- in logs
    
- in metadata transmitted over the network
    

Embedding markings in protocol metadata is a violation of metadata minimization.

# **K.3 Prohibited Conformance Markings**

The following markings (and all variants thereof) are explicitly prohibited:

- “SolNet‑Compatible”
    
- “SolNet‑Ready”
    
- “SolNet‑Certified”
    
- “L1‑Enhanced”
    
- “L1‑Extended”
    
- “Profile‑Hybrid”
    
- “Profile‑Adaptive”
    
- “Vendor‑Optimized L1”
    
- “L1‑Plus”
    
- “L1‑Premium”
    
- “Interplanetary‑Grade L1”
    
- “Enterprise L1”
    
- “L1‑Secure”
    
- “L1‑Trusted”
    

These markings imply capabilities not defined in the specification and are therefore misleading.

# **K.4 Digital Conformance Markings**

Digital markings MAY be included in:

- firmware version metadata
    
- device configuration UIs
    
- operator dashboards
    

Digital markings MUST:

- match the device’s declared profile
    
- reflect actual compliance status
    
- be updated only after passing the compliance suite
    

Digital markings MUST NOT:

- be transmitted over L1
    
- be encoded in TLVs
    
- be used for routing or trust decisions
    
- be used to negotiate capabilities
    

# **K.5 Compliance Verification Process**

A device MAY display **Compliance Verified** only after:

1. Passing all structural tests
    
2. Passing all semantic tests
    
3. Passing all operational tests
    
4. Passing all negative tests
    
5. Passing all interoperability tests
    
6. Passing all profile‑specific tests
    

Partial compliance is not recognized. Self‑certification is not recognized. Vendor‑defined test suites are not recognized.

Only the SSWG test suite is authoritative.

# **K.6 Revocation of Conformance Markings**

A device MUST remove **Compliance Verified** if:

- a regression is discovered
    
- a firmware update breaks compliance
    
- a vendor introduces non‑compliant behavior
    
- a device fails interoperability testing
    
- a device violates metadata minimization
    

Vendors MUST NOT continue to display markings after revocation.

# **K.7 Rationale**

Conformance markings exist because:

- vendors mislabel devices
    
- operators misunderstand capabilities
    
- profile boundaries drift without enforcement
    
- marketing departments invent terminology
    
- interoperability collapses when markings are ambiguous
    

The Working Group therefore defines strict, minimal, unambiguous markings.


# **Appendix L — Wire Image Examples**

This appendix provides canonical wire‑image examples of L1 frames across all profiles. These examples illustrate the exact byte sequences that MUST appear on the wire for representative cases. Devices MUST accept valid examples and MUST reject invalid ones exactly as shown.

The Working Group notes that implementers frequently confuse diagrams, pseudocode, and examples with the actual wire image. This appendix exists to prevent such confusion.

# **L.1 Minimal Profile Wire Images**

Minimal Profile frames contain:

- FrameType (1 byte)
    
- QoSClass (1 byte)
    
- FreshnessTag (VARINT)
    
- ProvenancePointer (VARINT)
    
- TLVContainerLength (VARINT = 0)
    
- **no TLVs**
    
- **no authentication tag**
    

## **L.1.1 Valid Minimal DataFrame**

Code

```
00 00 01 00 00
```

Meaning:

- 00 — DataFrame
    
- 00 — BestEffort
    
- 01 — FreshnessTag = 1
    
- 00 — ProvenancePointer = 0
    
- 00 — TLVContainerLength = 0
    

Device MUST accept.

## **L.1.2 Valid Minimal KeepaliveFrame**

Code

```
02 00 05 00 00
```

Meaning:

- 02 — KeepaliveFrame
    
- 00 — BestEffort
    
- 05 — FreshnessTag = 5
    
- 00 — ProvenancePointer = 0
    
- 00 — TLVContainerLength = 0
    

Device MUST accept.

## **L.1.3 Invalid: TLVContainerLength ≠ 0**

Code

```
00 00 01 00 01 FF
```

Device MUST reject.

# **L.2 Reduced Profile Wire Images**

Reduced Profile frames MAY contain TLVs and MAY contain CompactAuthTag.

## **L.2.1 Valid Reduced ControlFrame With SSWG TLV**

Code

```
01 01 02 00 03 81 01 7F
```

Meaning:

- 01 — ControlFrame
    
- 01 — LowLatency
    
- 02 — FreshnessTag
    
- 00 — ProvenancePointer
    
- 03 — TLVContainerLength
    
- 81 01 7F — TLV(Key=0x01, Len=1, Val=0x7F)
    

Device MUST accept.

## **L.2.2 Valid Reduced DataFrame Without TLVs**

Code

```
00 00 10 00 00
```

Device MUST accept.

## **L.2.3 Invalid: Full‑Profile‑Only TLV**

Code

```
01 01 03 00 03 A0 01 01
```

Device MUST reject.

# **L.3 Full Profile Wire Images**

Full Profile frames MUST include CompactAuthTag and MAY include TLVs from all categories.

## **L.3.1 Valid Full Profile DataFrame With Namespace TLV**

Code

```
00 00 05 00 03 82 02 40 01 01  9A 7C 3F 12 88 4E 55 21
```

Meaning:

- 00 — DataFrame
    
- 00 — BestEffort
    
- 05 — FreshnessTag
    
- 00 — ProvenancePointer
    
- 03 — TLVContainerLength
    
- 82 02 40 01 01 — TLV(Key=0x40, Len=1, Val=0x01)
    
- 9A 7C 3F 12 88 4E 55 21 — CompactAuthTag (8 bytes)
    

Device MUST validate and accept.

## **L.3.2 Valid Full Profile ControlCritical Frame**

Code

```
01 03 07 00 00  AA BB CC DD EE FF 11 22
```

Meaning:

- 01 — ControlFrame
    
- 03 — ControlCritical
    
- 07 — FreshnessTag
    
- 00 — ProvenancePointer
    
- 00 — TLVContainerLength
    
- AA BB CC DD EE FF 11 22 — CompactAuthTag
    

Device MUST accept.

## **L.3.3 Invalid: Incorrect Auth Tag Length**

Code

```
00 00 05 00 03 82 02 40 01 01  9A 7C 3F 12
```

Only 4 bytes of tag present. Device MUST reject.

# **L.4 Mixed‑Profile Interoperability Wire Images**

These examples illustrate asymmetric interoperability.

## **L.4.1 Full → Minimal (Forbidden)**

Code

```
00 00 01 00 00  9A 7C 3F 12 88 4E 55 21
```

Minimal MUST reject due to:

- presence of TLVs (if any)
    
- presence of CompactAuthTag
    

## **L.4.2 Reduced → Full (Allowed)**

Code

```
00 01 02 00 00
```

Full MUST accept.

## **L.4.3 Minimal → Full (Allowed)**

Code

```
00 00 01 00 00
```

Full MUST accept.

# **L.5 Negative Wire Images**

These examples MUST be rejected by all compliant devices.

## **L.5.1 Non‑Canonical VARINT**

Code

```
00 00 81 00 00
```

FreshnessTag incorrectly encoded. Device MUST reject.

## **L.5.2 TLV Misordering**

Code

```
00 00 05 00 06  
82 02 40 01 01  20 01 01  
9A 7C 3F 12 88 4E 55 21
```

N‑stack TLV appears before A‑stack TLV. Device MUST reject.

## **L.5.3 Forbidden Metadata in TLV**

Code

```
00 00 01 00 05  
81 03 00 11 22
```

Value contains hardware‑bound identifier. Device MUST reject.

# **L.6 Rationale**

Wire images exist because:

- implementers confuse diagrams with bytes
    
- vendors misencode VARINTs
    
- TLV ordering errors are common
    
- authentication tags are frequently misapplied
    
- profile boundaries collapse without concrete examples
    

The Working Group therefore provides canonical wire images to eliminate ambiguity.


# **Appendix M — Environmental & Physical Layer Considerations**

This appendix describes the environmental and physical‑layer conditions assumed by L1. These considerations are non‑normative but reflect the operational constraints under which L1 was designed. Deployments outside these conditions may exhibit failure modes that are not defects in the specification.

The Working Group notes that several vendors have attempted to deploy L1 in environments with extreme delay, extreme noise, or extreme mobility, then blamed the protocol for predictable failures. This appendix exists to prevent such misunderstandings.

# **M.1 Physical Layer Assumptions**

L1 assumes:

- a **single local link**
    
- **non‑guaranteed delivery**
    
- **non‑deterministic latency**
    
- **bounded but variable bandwidth**
    
- **bounded but variable error rates**
    
- **no confidentiality**
    
- **no routing semantics**
    

L1 does **not** assume:

- stable connectivity
    
- synchronized clocks
    
- consistent propagation delay
    
- consistent link quality
    
- deterministic scheduling
    
- homogeneous hardware
    

These assumptions are intentional.

# **M.2 Environmental Conditions**

L1 is designed to operate under the following environmental conditions:

## **M.2.1 Planetary Surface (Low Power)**

Characteristics:

- dust, wind, thermal cycling
    
- intermittent line‑of‑sight
    
- severe power constraints
    
- multipath interference
    

Implications:

- Minimal Profile is preferred
    
- TLVs add unnecessary overhead
    
- authentication may be too costly
    
- duty‑cycle limits dominate behavior
    

Common vendor mistake:

- attempting to use Full Profile on solar‑powered micro‑nodes
    

## **M.2.2 Habitat Interiors**

Characteristics:

- stable temperature
    
- moderate interference
    
- predictable geometry
    
- mixed device capabilities
    

Implications:

- Reduced Profile is appropriate
    
- DiscoveryFrame is useful
    
- TLVs can be used safely
    

Common vendor mistake:

- embedding application metadata in TLVs
    

## **M.2.3 Pressurized Vehicles (Rovers, Landers, Shuttles)**

Characteristics:

- controlled environment
    
- predictable mobility
    
- moderate EMI
    
- strict safety requirements
    

Implications:

- Full Profile is appropriate
    
- authentication is mandatory
    
- ControlCritical QoSClass is meaningful
    

Common vendor mistake:

- using L1 for actuator control loops
    

## **M.2.4 Orbital Platforms**

Characteristics:

- line‑of‑sight windows
    
- predictable Doppler shift
    
- moderate radiation
    
- mixed trust domains
    

Implications:

- Full Profile recommended
    
- authentication prevents injection
    
- TLVs support A‑stack routing policy
    

Common vendor mistake:

- treating L1 as a DTN protocol
    

# **M.3 Unsupported Environmental Conditions**

These environments exceed L1’s design envelope.

## **M.3.1 Deep‑Space Links**

Unsupported because:

- propagation delay exceeds replay semantics
    
- authentication does not scale across trust domains
    
- L1 assumes local link semantics
    
- routing belongs to higher layers
    

Common vendor mistake:

- attempting to use L1 as a replacement for Bundle Protocol
    

## **M.3.2 High‑Noise Industrial Environments**

Unsupported because:

- error rates exceed L1’s tolerance
    
- retransmission must occur at higher layers
    
- L1 cannot provide reliability
    

Common vendor mistake:

- adding reliability mechanisms at L1
    

## **M.3.3 High‑Mobility Swarms**

Unsupported because:

- topology changes faster than L1 can react
    
- provenance becomes meaningless
    
- QoSClass cannot compensate for mobility
    

Common vendor mistake:

- using L1 for drone‑to‑drone coordination
    

# **M.4 Physical Layer Interference Considerations**

L1 assumes the physical layer may experience:

- multipath fading
    
- thermal noise
    
- cosmic radiation
    
- dust occlusion
    
- antenna misalignment
    
- intermittent obstruction
    

L1 does **not** attempt to mitigate these conditions. Mitigation belongs to the physical layer or higher layers.

Common vendor mistake:

- attempting to encode link‑quality hints in TLVs
    

# **M.5 Duty‑Cycle & Power Considerations**

L1 assumes:

- devices may have strict duty‑cycle limits
    
- devices may have limited battery capacity
    
- devices may have intermittent power availability
    

Implications:

- KeepaliveFrame MUST be used sparingly
    
- retransmissions MUST occur at higher layers
    
- TLVs MUST be minimized in low‑power deployments
    

Common vendor mistake:

- using frequent KeepaliveFrames to simulate link stability
    

# **M.6 Thermal Considerations**

L1 assumes:

- devices may operate across wide temperature ranges
    
- thermal throttling may affect timing
    
- thermal noise may affect radio performance
    

L1 does **not** assume:

- deterministic timing
    
- stable oscillator performance
    
- consistent processing latency
    

Common vendor mistake:

- relying on timing‑based replay windows
    

# **M.7 Rationale**

Environmental considerations exist because:

- L1 is not a physical‑layer protocol
    
- L1 is not a transport protocol
    
- L1 is not a routing protocol
    
- L1 cannot compensate for physics
    
- vendors routinely deploy L1 into hostile environments
    

The Working Group therefore documents the environmental assumptions to prevent predictable failures.


# **Appendix N — Implementation Anti‑Patterns**

This appendix catalogs implementation behaviors that are _not merely discouraged_ but are **categorically forbidden**. These anti‑patterns undermine interoperability, violate metadata‑minimization doctrine, or collapse profile boundaries. Any implementation exhibiting these behaviors is non‑compliant, regardless of intent.

The Working Group notes that most anti‑patterns arise from attempts to “optimize,” “extend,” or “simplify” L1. Such attempts are uniformly harmful.

# **N.1 Structural Anti‑Patterns**

## **N.1.1 Partial Parsing**

Description: Implementers parse only the fields they “care about” and ignore the rest.

Symptoms:

- TLV misinterpretation
    
- authentication bypass
    
- inconsistent rejection behavior
    

Why forbidden: L1 requires full structural validation before acceptance.

## **N.1.2 Lazy VARINT Decoding**

Description: Implementers decode VARINTs using non‑canonical or permissive logic.

Symptoms:

- acceptance of overlong encodings
    
- inconsistent FreshnessTag behavior
    
- replay vulnerabilities
    

Why forbidden: Canonical encoding is mandatory.

## **N.1.3 TLV Pre‑Sorting**

Description: Implementers reorder TLVs for convenience or “optimization.”

Symptoms:

- Full Profile devices reject frames
    
- category ordering violated
    

Why forbidden: TLV order is semantically meaningful.

# **N.2 Semantic Anti‑Patterns**

## **N.2.1 FreshnessTag as Timestamp**

Description: Implementers embed time semantics into FreshnessTag.

Symptoms:

- privacy leakage
    
- replay logic collapse
    
- cross‑device correlation
    

Why forbidden: FreshnessTag is meaningless by design.

## **N.2.2 ProvenancePointer as Routing Metric**

Description: Implementers treat provenance as hop count, trust score, or path indicator.

Symptoms:

- routing loops
    
- trust‑domain leakage
    
- inconsistent forwarding
    

Why forbidden: ProvenancePointer is not a routing field.

## **N.2.3 TLV Overloading**

Description: Implementers embed application metadata, routing hints, or identifiers in TLVs.

Symptoms:

- privacy violations
    
- cross‑layer coupling
    
- vendor lock‑in
    

Why forbidden: TLVs have strict category semantics.

# **N.3 Authentication Anti‑Patterns**

## **N.3.1 “Fail‑Open” Authentication**

Description: Implementers accept frames with invalid or missing authentication tags.

Symptoms:

- injection attacks
    
- silent corruption
    
- inconsistent behavior across devices
    

Why forbidden: Full Profile requires strict authentication.

## **N.3.2 Key Persistence**

Description: Implementers store authentication keys across sessions or trust domains.

Symptoms:

- impersonation
    
- replay across domains
    
- provenance confusion
    

Why forbidden: Keys MUST be session‑scoped.

## **N.3.3 Non‑Standard MAC Algorithms**

Description: Implementers replace HMAC‑SHA256 with “faster” or “lighter” alternatives.

Symptoms:

- authentication failures
    
- inconsistent tag lengths
    
- interoperability collapse
    

Why forbidden: CompactAuthTag is fixed and non‑negotiable.

# **N.4 Relay Anti‑Patterns**

## **N.4.1 Frame Rewriting**

Description: Relays modify frames to “fix” or “normalize” them.

Symptoms:

- authentication invalidation
    
- TLV corruption
    
- provenance distortion
    

Why forbidden: Relays MUST forward frames unchanged.

## **N.4.2 Relay‑Based Routing**

Description: Relays attempt to implement routing logic at L1.

Symptoms:

- loops
    
- inconsistent forwarding
    
- trust‑domain leakage
    

Why forbidden: Routing belongs to A‑stack and N‑stack.

## **N.4.3 Relay Downgrading**

Description: Relays strip TLVs or authentication to “help” lower‑profile devices.

Symptoms:

- profile boundary collapse
    
- silent security failures
    

Why forbidden: Relays MUST NOT modify frames.

# **N.5 Metadata Anti‑Patterns**

## **N.5.1 Logging TLVs**

Description: Implementers log TLV contents for debugging or analytics.

Symptoms:

- privacy violations
    
- trust‑domain leakage
    
- regulatory issues
    

Why forbidden: Metadata minimization prohibits logging TLVs.

## **N.5.2 Embedding Identifiers in TLVs**

Description: Implementers include MAC/EUI‑64/IMEI/serial numbers in TLVs.

Symptoms:

- persistent tracking
    
- cross‑domain correlation
    

Why forbidden: Hardware‑bound identifiers are explicitly banned.

## **N.5.3 Application Metadata Leakage**

Description: Implementers embed user IDs, session IDs, or application state in TLVs.

Symptoms:

- privacy violations
    
- cross‑layer coupling
    

Why forbidden: L1 MUST NOT carry application metadata.

# **N.6 Operational Anti‑Patterns**

## **N.6.1 Excessive KeepaliveFrames**

Description: Implementers send frequent KeepaliveFrames to simulate link stability.

Symptoms:

- duty‑cycle exhaustion
    
- battery drain
    
- congestion
    

Why forbidden: KeepaliveFrames MUST be used sparingly.

## **N.6.2 L1‑Level Retransmissions**

Description: Implementers add reliability mechanisms at L1.

Symptoms:

- congestion collapse
    
- inconsistent delivery
    
- replay confusion
    

Why forbidden: Reliability belongs to higher layers.

## **N.6.3 Timing‑Based Replay Windows**

Description: Implementers rely on clocks to enforce replay protection.

Symptoms:

- inconsistent acceptance
    
- cross‑device correlation
    
- privacy leakage
    

Why forbidden: L1 assumes no synchronized clocks.

# **N.7 Vendor Anti‑Patterns**

## **N.7.1 Profile Mutation**

Description: Vendors add features to profiles or create “hybrid” profiles.

Symptoms:

- interoperability collapse
    
- inconsistent capabilities
    
- misleading conformance claims
    

Why forbidden: Profiles are fixed and non‑negotiable.

## **N.7.2 Vendor TLV Semantics**

Description: Vendors use Vendor TLVs to implement core functionality.

Symptoms:

- fragmentation
    
- inconsistent behavior
    
- routing failures
    

Why forbidden: Vendor TLVs MUST NOT alter L1 semantics.

## **N.7.3 “Compatibility Layers”**

Description: Vendors wrap L1 in proprietary framing or negotiation.

Symptoms:

- wire‑image divergence
    
- authentication failures
    
- TLV corruption
    

Why forbidden: L1 wire image is fixed.

# **N.8 Rationale**

Anti‑patterns exist because:

- implementers optimize the wrong components
    
- vendors extend the wrong layers
    
- operators misinterpret profile boundaries
    
- debugging practices violate metadata minimization
    
- relay logic is frequently misunderstood
    

The Working Group therefore documents these anti‑patterns to prevent predictable, repeatable, and entirely avoidable failures.


# **Appendix O — Formal Test Harness Specification**

This appendix defines the mandatory structure and behavior of the L1 compliance test harness. The harness is authoritative. Implementations MUST pass all tests without modification to the harness, without vendor‑specific patches, and without disabling any checks.

The Working Group notes that vendors have historically attempted to “optimize” or “simplify” the harness. Such attempts are prohibited.

# **O.1 Test Harness Architecture**

A compliant test harness consists of:

1. **Frame Generator** Produces valid and invalid frames across all profiles.
    
2. **Wire Image Validator** Verifies exact byte‑level conformance.
    
3. **Semantic Validator** Verifies TLV semantics, category ordering, and profile boundaries.
    
4. **Authentication Engine** Computes and validates CompactAuthTag.
    
5. **Replay Engine** Tests FreshnessTag monotonicity and replay handling.
    
6. **Relay Simulator** Tests forwarding behavior and non‑interference.
    
7. **Result Recorder** Logs pass/fail outcomes without logging TLVs or identifying metadata.
    

The harness MUST NOT:

- infer behavior
    
- correct behavior
    
- retry failed tests
    
- modify frames
    
- relax validation rules
    

# **O.2 Test Categories**

The harness MUST implement the following categories:

## **O.2.1 Structural Tests**

These tests verify:

- canonical VARINT encoding
    
- correct TLVContainerLength
    
- correct TLV structure
    
- correct TLV ordering
    
- correct presence/absence of CompactAuthTag
    
- correct FrameType and QoSClass handling
    

Failure in any structural test is a **hard fail**.

## **O.2.2 Semantic Tests**

These tests verify:

- FreshnessTag monotonicity
    
- ProvenancePointer semantics
    
- TLV category semantics
    
- profile boundary enforcement
    
- correct rejection of forbidden metadata
    

Semantic failures are **hard fails**.

## **O.2.3 Authentication Tests**

These tests verify:

- correct HMAC‑SHA256 computation
    
- correct tag truncation
    
- correct tag validation
    
- correct rejection of invalid tags
    
- correct handling of missing tags
    

Authentication failures are **hard fails**.

## **O.2.4 Replay Tests**

These tests verify:

- rejection of stale FreshnessTag
    
- acceptance of equal or newer tags
    
- correct wraparound handling
    
- no timing‑based replay logic
    

Replay failures are **hard fails**.

## **O.2.5 Relay Tests**

These tests verify:

- forwarding without modification
    
- rejection of malformed frames
    
- no rewriting of TLVs
    
- no rewriting of QoSClass
    
- no rewriting of ProvenancePointer
    
- no recomputation of authentication tags
    

Relay failures are **hard fails**.

## **O.2.6 Negative Tests**

These tests verify:

- rejection of malformed frames
    
- rejection of non‑canonical VARINTs
    
- rejection of forbidden metadata
    
- rejection of Full‑only TLVs in Reduced Profile
    
- rejection of any TLVs in Minimal Profile
    

Negative test failures are **hard fails**.

# **O.3 Test Execution Requirements**

The harness MUST:

- run all tests in deterministic order
    
- run all tests without vendor modification
    
- run all tests without skipping
    
- run all tests without conditional logic
    
- run all tests without profile negotiation
    

The harness MUST NOT:

- retry failed tests
    
- adjust behavior based on device responses
    
- adapt to vendor‑specific extensions
    
- infer compliance from partial success
    

# **O.4 Device Under Test (DUT) Requirements**

The DUT MUST:

- respond to frames exactly as specified
    
- reject invalid frames immediately
    
- not emit forbidden metadata
    
- not modify frames during relay tests
    
- not attempt to negotiate profile or capabilities
    

The DUT MUST NOT:

- attempt to detect the harness
    
- alter behavior when under test
    
- emit debugging metadata
    
- emit TLVs not required by its profile
    

# **O.5 Logging Requirements**

The harness MUST log:

- test case identifier
    
- pass/fail result
    
- error category (if fail)
    
- timestamp (local to harness)
    

The harness MUST NOT log:

- TLV contents
    
- provenance
    
- authentication keys
    
- hardware identifiers
    
- payloads
    
- any identifying metadata from the DUT
    

# **O.6 Compliance Criteria**

A device is considered **compliant** only if:

- all structural tests pass
    
- all semantic tests pass
    
- all authentication tests pass
    
- all replay tests pass
    
- all relay tests pass
    
- all negative tests pass
    
- no forbidden metadata is emitted
    
- no profile boundaries are violated
    

Partial compliance is not recognized. Conditional compliance is not recognized. Vendor‑defined compliance is not recognized.

# **O.7 Rationale**

The formal test harness exists because:

- vendors selectively run tests
    
- implementers disable checks they fail
    
- profile boundaries drift without enforcement
    
- TLV semantics degrade over time
    
- authentication logic is frequently incorrect
    
- replay logic is routinely misimplemented
    

The Working Group therefore defines a strict, immutable, non‑negotiable test harness.


# **Appendix P — Reference Timing & Performance Benchmarks**

This appendix defines the reference timing and performance benchmarks that compliant L1 implementations MUST meet. These benchmarks are not intended to maximize throughput or minimize latency; they exist solely to ensure predictable behavior across heterogeneous devices.

The Working Group notes that vendors frequently optimize the wrong components, measure the wrong metrics, and benchmark under unrealistic conditions. This appendix exists to prevent such practices.

# **P.1 Benchmarking Principles**

All benchmarks assume:

- no synchronized clocks
    
- non‑deterministic physical layer latency
    
- variable processing capability
    
- heterogeneous device classes
    
- strict metadata minimization
    
- strict profile boundaries
    

Benchmarks MUST NOT assume:

- deterministic scheduling
    
- reliable delivery
    
- stable link quality
    
- consistent processing speed
    

Benchmarks measure **conformance**, not **performance bragging rights**.

# **P.2 Frame Processing Benchmarks**

## **P.2.1 Parsing Latency**

A compliant device MUST parse and validate a frame within:

- **Minimal Profile:** ≤ 1.0 ms
    
- **Reduced Profile:** ≤ 2.5 ms
    
- **Full Profile:** ≤ 5.0 ms
    

Parsing latency includes:

- VARINT decoding
    
- TLV parsing
    
- category ordering validation
    
- authentication tag extraction (if present)
    

Parsing latency MUST NOT include:

- application‑layer processing
    
- routing decisions
    
- retransmission logic
    

## **P.2.2 Authentication Latency (Full Profile)**

CompactAuthTag validation MUST complete within:

- **≤ 3.0 ms** for 8‑byte tag verification
    
- **≤ 5.0 ms** for full HMAC recomputation
    

Devices MAY pre‑allocate buffers but MUST NOT precompute tags.

## **P.2.3 Relay Forwarding Latency**

Relays MUST forward validated frames within:

- **≤ 1.0 ms** for Minimal Profile frames
    
- **≤ 2.0 ms** for Reduced Profile frames
    
- **≤ 3.0 ms** for Full Profile frames
    

Forwarding latency MUST NOT include:

- rewriting
    
- re‑authentication
    
- TLV modification
    
- QoSClass modification
    

Relays MUST NOT introduce jitter beyond ±0.5 ms.

# **P.3 Throughput Benchmarks**

Throughput benchmarks assume:

- stable physical layer
    
- no retransmissions
    
- no congestion
    
- no duty‑cycle limits
    

These benchmarks exist solely to detect pathological implementations.

## **P.3.1 Minimal Profile Throughput**

A compliant Minimal Profile device MUST sustain:

- **≥ 500 frames/second** for DataFrame
    
- **≥ 1000 frames/second** for KeepaliveFrame
    

## **P.3.2 Reduced Profile Throughput**

A compliant Reduced Profile device MUST sustain:

- **≥ 300 frames/second** with TLVs
    
- **≥ 600 frames/second** without TLVs
    

## **P.3.3 Full Profile Throughput**

A compliant Full Profile device MUST sustain:

- **≥ 200 frames/second** with authentication
    
- **≥ 400 frames/second** without TLVs
    

# **P.4 Replay Handling Benchmarks**

Replay logic MUST:

- reject stale FreshnessTag within **≤ 0.5 ms**
    
- accept equal or newer FreshnessTag within **≤ 0.5 ms**
    
- handle wraparound within **≤ 1.0 ms**
    

Replay logic MUST NOT:

- rely on timestamps
    
- rely on synchronized clocks
    
- rely on device‑local time
    

# **P.5 TLV Handling Benchmarks**

TLV parsing MUST complete within:

- **≤ 0.5 ms** per TLV (SSWG category)
    
- **≤ 0.75 ms** per TLV (A‑stack category)
    
- **≤ 1.0 ms** per TLV (N‑stack category)
    
- **≤ 1.0 ms** per TLV (Vendor category)
    

TLV validation MUST include:

- category ordering
    
- length correctness
    
- canonical VARINT encoding
    
- forbidden metadata detection
    

# **P.6 Negative Case Benchmarks**

A compliant device MUST reject invalid frames within:

- **≤ 1.0 ms** for structural errors
    
- **≤ 2.0 ms** for authentication errors
    
- **≤ 1.5 ms** for TLV errors
    
- **≤ 0.5 ms** for forbidden metadata
    

Devices MUST NOT:

- attempt recovery
    
- attempt correction
    
- attempt fallback behavior
    

Rejection MUST be immediate and final.

# **P.7 Power & Duty‑Cycle Benchmarks**

These benchmarks ensure that devices do not violate environmental constraints.

## **P.7.1 Idle Power Consumption**

- Minimal Profile: **≤ 10 mW**
    
- Reduced Profile: **≤ 25 mW**
    
- Full Profile: **≤ 50 mW**
    

## **P.7.2 Active Transmission Duty Cycle**

Devices MUST NOT exceed:

- **1%** duty cycle in low‑power deployments
    
- **10%** duty cycle in habitat deployments
    
- **20%** duty cycle in vehicle deployments
    

KeepaliveFrames MUST NOT exceed:

- **1 per second** (Minimal Profile)
    
- **2 per second** (Reduced Profile)
    
- **2 per second** (Full Profile)
    

# **P.8 Rationale**

Performance benchmarks exist because:

- vendors exaggerate throughput
    
- implementers mismeasure latency
    
- relay behavior is frequently incorrect
    
- authentication logic is often slow
    
- TLV parsing is routinely inefficient
    
- replay logic is commonly misimplemented
    

The Working Group therefore defines strict, realistic, and enforceable benchmarks.


# **Appendix Q — Known Deviations & Waivers**

This appendix documents all deviations and waivers formally approved by the SolNet Standards Working Group (SSWG). The list is intentionally short. The Working Group does not grant waivers lightly, and no waiver establishes precedent unless explicitly stated.

Any deviation not listed in this appendix is **non‑compliant**, regardless of vendor justification.

# **Q.1 Principles Governing Deviations**

The SSWG grants deviations only when:

- the deviation does **not** alter the L1 wire image
    
- the deviation does **not** introduce identifying metadata
    
- the deviation does **not** weaken authentication
    
- the deviation does **not** alter TLV semantics
    
- the deviation does **not** affect interoperability
    
- the deviation is **strictly temporary**
    
- the deviation is **fully documented**
    
- the deviation is **testable**
    

Deviations that violate any of these principles are categorically rejected.

# **Q.2 Approved Historical Deviations**

These deviations were granted under exceptional circumstances and remain the only sanctioned departures from the specification.

## **Q.2.1 Deviation #001 — Early VARINT Decoder Permissiveness (Retired)**

**Scope:** Early prototype devices accepted non‑canonical VARINTs during field testing.

**Reason:** Prototype firmware lacked canonical enforcement logic.

**Conditions:**

- Allowed only for pre‑production hardware
    
- Allowed only for test deployments
    
- Must reject non‑canonical VARINTs in production firmware
    

**Status:** **Retired.** No modern device may rely on this deviation.

## **Q.2.2 Deviation #002 — Missing CompactAuthTag in Full Profile (Expired)**

**Scope:** A vendor’s Full Profile implementation temporarily omitted CompactAuthTag due to a hardware crypto accelerator fault.

**Reason:** Critical mission deployment required immediate fallback.

**Conditions:**

- Allowed only for a single firmware revision
    
- Allowed only for non‑critical traffic
    
- Must be corrected within 30 days
    
- Must not be used to authenticate control traffic
    

**Status:** **Expired.** No future waivers of this type will be granted.

## **Q.2.3 Deviation #003 — TLV Category Compression (Limited)**

**Scope:** A vendor compressed multiple SSWG TLVs into a single Vendor TLV for storage efficiency.

**Reason:** Severe memory constraints on early micro‑nodes.

**Conditions:**

- Allowed only for Minimal Profile devices
    
- Allowed only if TLVContainerLength remains correct
    
- Allowed only if Vendor TLV does not alter semantics
    
- Must be removed once hardware revision increases memory
    

**Status:** **Limited.** Still permitted for legacy micro‑nodes only.

## **Q.2.4 Deviation #004 — Relay Latency Relaxation (Active)**

**Scope:** A vendor’s relay implementation exceeded forwarding latency by 0.3 ms under thermal throttling.

**Reason:** Thermal constraints in early rover deployments.

**Conditions:**

- Allowed only under thermal throttling
    
- Allowed only if authentication remains correct
    
- Allowed only if jitter remains within ±1.0 ms
    
- Must be corrected in next hardware revision
    

**Status:** **Active.** Applies only to specific rover hardware.

# **Q.3 Denied Deviations (Representative)**

These deviations were requested and **rejected**. They are listed to prevent future vendors from attempting the same arguments.

## **Q.3.1 Request: “Allow timestamps in FreshnessTag” — Denied**

Reason: Violates metadata minimization and enables tracking.

## **Q.3.2 Request: “Allow Vendor TLVs to encode routing hints” — Denied**

Reason: Collapses layer boundaries and breaks interoperability.

## **Q.3.3 Request: “Allow Full Profile devices to accept unauthenticated frames” — Denied**

Reason: Catastrophic security implications.

## **Q.3.4 Request: “Allow relays to rewrite TLVs for optimization” — Denied**

Reason: Breaks authentication and provenance semantics.

## **Q.3.5 Request: “Allow hybrid profiles” — Denied**

Reason: Destroys the profile model.

# **Q.4 Waiver Request Procedure**

Vendors MAY request a deviation only by submitting:

1. A complete description of the deviation
    
2. A justification demonstrating necessity
    
3. A risk assessment
    
4. A mitigation plan
    
5. A timeline for removal
    
6. A test plan verifying non‑interference
    

Waivers MUST NOT be requested for:

- performance improvements
    
- marketing reasons
    
- convenience
    
- hardware limitations that can be fixed
    
- “industry standard” behavior
    

The Working Group rejects the majority of waiver requests.

# **Q.5 Waiver Duration & Expiration**

All waivers:

- MUST specify an expiration date
    
- MUST specify a firmware revision boundary
    
- MUST specify a hardware revision boundary
    
- MUST be re‑evaluated annually
    
- MUST be revoked if abused
    

Expired waivers MUST NOT be cited as precedent.

# **Q.6 Rationale**

The deviation catalog exists because:

- vendors push boundaries
    
- implementers cut corners
    
- field deployments encounter unexpected constraints
    
- interoperability collapses without strict control
    
- metadata minimization is fragile
    
- authentication semantics are non‑negotiable
    

The Working Group therefore documents all deviations explicitly to prevent drift, misuse, and creative reinterpretation.


# **R.1 The Vesta Blockade (Pre‑SolNet, c. 2320)**

## **R.1.1 Summary**

During the Vesta Blockade, two opposing fleets attempted to negotiate a ceasefire. They failed.

Not because of malice. Not because of deception. Because their communication systems were mutually unintelligible.

The fleets were close enough to exchange fire. They were technologically advanced enough to track each other’s thermal signatures. But they could not exchange a single authenticated message.

## **R.1.2 Technical Failure**

The failure was total:

- incompatible frame formats
    
- incompatible authentication schemes
    
- incompatible routing assumptions
    
- incompatible relay behavior
    
- incompatible metadata structures
    
- incompatible provenance semantics
    
- incompatible fallback logic
    

Each fleet believed the other was ignoring messages. Each fleet believed the other was escalating. Each fleet believed the other was refusing to negotiate.

In reality, both fleets were transmitting into a void of their own creation.

## **R.1.3 Political Consequences**

The blockade nearly escalated into a shooting war. Only the intervention of a neutral third party — physically relaying messages by line‑of‑sight optical link — prevented catastrophe.

The incident demonstrated:

- the impossibility of ad‑hoc interoperability
    
- the danger of proprietary communication stacks
    
- the fragility of trust‑domain boundaries
    
- the catastrophic consequences of metadata leakage
    
- the necessity of a universal, minimal, verifiable link layer
    

## **R.1.4 Doctrinal Lessons**

The Vesta Blockade directly produced:

- **strict profile boundaries**
    
- **canonical wire image**
    
- **mandatory interoperability**
    
- **relay non‑interference**
    
- **provenance semantics**
    
- **authentication requirements**
    
- **metadata minimization**
    

SolNet exists because Vesta proved that “good enough” communication is not good enough.

## **R.1.5 Fallback Optical Signaling Attempts**

When all electronic communication failed, both fleets attempted fallback optical signaling using tight‑beam lasers. This included amplitude‑modulated pulses encoding simple, human‑interpretable patterns — the oldest interoperable signaling system still in use.

The Working Group notes, with no small degree of bitterness, that billion‑credit fleets were reduced to flashing **Morse‑equivalent optical bursts** across vacuum because their communication stacks could not agree on a frame format.

These attempts were:

- slow
    
- lossy
    
- manually decoded
    
- prone to occlusion
    
- vulnerable to misalignment
    
- dependent on human interpretation
    

But they worked — barely. And only because the encoding was simple enough that no vendor could “optimize” it.

The fallback attempts underscore the central lesson of Vesta:

> When systems fail, humans revert to the simplest protocol available. SolNet exists so that no fleet ever has to blink a ceasefire in Morse again.

# **R.2 The Anderson Station Massacre (Pre‑SolNet, c. 2330)**

## **R.2.1 Summary**

During the Anderson Station uprising, civilian leadership attempted to surrender. Their surrender message was transmitted. It was relayed. It was logged. It was forwarded.

It never reached the commander who needed to receive it.

Whether the failure was accidental or intentional has never been proven. The effect was identical: **the surrender did not arrive**, and the station was destroyed.

## **R.2.2 Technical Failure**

The communication chain was routed through a centralized fleet command node. This node:

- rewrote message headers
    
- altered provenance
    
- inserted identifying metadata
    
- stripped authentication
    
- re‑encoded timestamps
    
- applied proprietary compression
    
- queued messages behind higher‑priority traffic
    
- silently dropped frames under load
    

By the time the surrender reached the final relay, it no longer conformed to the receiving system’s rules. The message was discarded.

## **R.2.3 Political Consequences**

The massacre became a symbol of systemic failure:

- failure of trust
    
- failure of transparency
    
- failure of accountability
    
- failure of communication infrastructure
    

It demonstrated that:

- centralized authorities cannot be trusted with message integrity
    
- relays must not modify frames
    
- provenance must be cryptographically verifiable
    
- metadata must be minimized
    
- authentication must be mandatory
    
- routing must not distort meaning
    

## **R.2.4 Doctrinal Lessons**

The Anderson Station Massacre directly produced:

- **relay non‑interference doctrine**
    
- **mandatory authentication for Full Profile**
    
- **provenance integrity requirements**
    
- **forbidden metadata rules**
    
- **strict separation of layers**
    
- **ban on timestamp semantics**
    
- **ban on centralized message rewriting**
    

SolNet exists because Anderson Station proved that communication systems can be weaponized by omission.

# **R.3 The Drift Years (2330–2345)**

Between Vesta and the adoption of SolNet, communication systems drifted:

- proprietary stacks proliferated
    
- trust domains fractured
    
- metadata practices diverged
    
- authentication schemes multiplied
    
- relays became opaque
    
- routing became political
    
- interoperability became aspirational
    

The Drift Years demonstrated that without a universal standard, communication systems degrade into mutually incompatible islands.

SolNet was created to end the Drift.

# **R.4 Why SolNet Exists**

SolNet exists because:

- Vesta proved that **incompatibility is indistinguishable from hostility**
    
- Anderson Station proved that **message loss is indistinguishable from malice**
    

SolNet exists to ensure that:

- messages arrive
    
- messages are authentic
    
- relays do not interfere
    
- metadata does not betray
    
- provenance is verifiable
    
- profiles are predictable
    
- interoperability is mandatory
    
- failure is diagnosable
    
- silence is never ambiguous
    

SolNet exists so that no fleet, no habitat, no station, no civilian population will ever again be placed in a position where a message must be flashed in Morse across vacuum — or where a surrender is lost in a relay queue.


# **Appendix S — Historical Incidents & Lessons Learned**

_(Revised with canonical dates)_

This appendix documents the major interoperability, security, and operational failures that occurred **after** the adoption of SolNet L1. These incidents are included not to shame vendors (though they richly deserve it), but to ensure that future implementers do not repeat the same mistakes.

For the pre‑SolNet systemic failures that necessitated this specification, see **Appendix R**.

Every incident described here was preventable. In each case, the vendor either ignored the specification, misunderstood the specification, or attempted to “improve” the specification.

# **S.1 Incident #001 — The Great VARINT Meltdown (2346)**

**Summary:** A major vendor shipped a VARINT decoder that accepted _every possible byte sequence_ as “canonical.”

**Symptoms:**

- acceptance of overlong encodings
    
- acceptance of encodings with leading zeros
    
- acceptance of encodings that were not VARINTs
    
- replay logic collapse
    

**Root Cause:** Developer comment found in source code:

> “Canonical encoding seems optional.”

**Impact:** Full Profile devices rejected 37% of frames on the network. Reduced Profile devices accepted everything, including malformed frames. Minimal Profile devices behaved unpredictably.

**Lesson Learned:** Canonical means canonical. Not “canonical unless inconvenient.”

# **S.2 Incident #002 — The TLV Sorting Catastrophe (2347)**

**Summary:** A vendor implemented TLV parsing by sorting TLVs lexicographically “for consistency.”

**Symptoms:**

- TLVs arrived in the wrong category order
    
- Full Profile devices rejected all frames
    
- Reduced Profile devices accepted some frames and rejected others
    

**Root Cause:** Developer attempted to “normalize” TLVs.

**Impact:** Interoperability collapsed across three habitat networks.

**Lesson Learned:** TLVs are not JSON. Do not sort them.

# **S.3 Incident #003 — The ProvenancePointer Debacle (2349)**

**Summary:** A vendor treated ProvenancePointer as a hop counter.

**Symptoms:**

- relays incremented ProvenancePointer
    
- provenance records became meaningless
    
- routing loops formed
    
- trust‑domain leakage occurred
    

**Root Cause:** Developer assumed “pointer” meant “hop count.”

**Impact:** A three‑node relay chain entered a self‑reinforcing loop that saturated the link for 19 hours.

**Lesson Learned:** If the spec says “MUST NOT,” it means “MUST NOT,” not “probably fine.”

# **S.4 Incident #004 — The Authentication Bypass Fiasco (2350)**

**Summary:** A vendor implemented authentication as:

Code

```
if (tag_invalid) accept_frame();
```

**Symptoms:**

- Full Profile devices accepted unauthenticated frames
    
- attackers injected arbitrary TLVs
    
- provenance records were forged
    

**Root Cause:** Developer misunderstood the difference between reliability and security.

**Impact:** A habitat network experienced a multi‑hour outage due to forged control frames.

**Lesson Learned:** Fail‑open authentication is not authentication. It is wishful thinking.

# **S.5 Incident #005 — The Relay Rewrite Disaster (2351)**

**Summary:** A vendor’s relay rewrote TLVs “to improve compatibility.”

**Symptoms:**

- authentication tags invalidated
    
- TLVs corrupted
    
- QoSClass altered
    
- provenance destroyed
    

**Root Cause:** Relay attempted to be “helpful.”

**Impact:** Full Profile devices rejected every forwarded frame.

**Lesson Learned:** Relays do not fix frames. Relays forward frames.

# **S.6 Incident #006 — The Metadata Leak of ’54 (2354)**

**Summary:** A vendor embedded hardware serial numbers in Vendor TLVs “for debugging.”

**Symptoms:**

- persistent device tracking
    
- cross‑domain correlation
    
- privacy violations
    
- regulatory complaints
    

**Root Cause:** Developer believed “debugging” justified violating metadata minimization.

**Impact:** Entire deployment had to be recalled.

**Lesson Learned:** Someone always notices.

# **S.7 Incident #007 — The Keepalive Storm (2355)**

**Summary:** A vendor sent KeepaliveFrames every 20 ms “to ensure link stability.”

**Symptoms:**

- duty‑cycle exhaustion
    
- battery drain
    
- congestion collapse
    
- thermal throttling
    

**Root Cause:** Developer attempted to simulate TCP keepalives.

**Impact:** Network became unusable for 11 hours.

**Lesson Learned:** KeepaliveFrames are not heartbeats. They are a last resort.

# **S.8 Incident #008 — The Hybrid Profile Fantasy (2357)**

**Summary:** A vendor created a “Hybrid Profile” combining Reduced and Full semantics.

**Symptoms:**

- devices claimed to be Full Profile
    
- devices omitted authentication
    
- devices emitted Full‑only TLVs
    
- devices rejected valid Full Profile frames
    

**Root Cause:** Marketing invented a profile. Engineering implemented it.

**Impact:** Interoperability collapsed across two trust domains.

**Lesson Learned:** Profiles are not suggestions. Profiles are law.

# **S.9 Incident #009 — The Timestamp Insertion Scandal (2358)**

**Summary:** A vendor inserted timestamps into FreshnessTag “for analytics.”

**Symptoms:**

- cross‑device correlation
    
- privacy violations
    
- replay logic malfunction
    
- devices rejected each other’s frames
    

**Root Cause:** Developer believed “analytics” justified violating metadata minimization.

**Impact:** Entire deployment had to be wiped and re‑keyed.

**Lesson Learned:** FreshnessTag is not a timestamp. It is entropy with delusions of grandeur.

# **S.10 Rationale**

Historical incidents exist because:

- implementers are creative in the worst possible ways
    
- vendors optimize the wrong layers
    
- marketing departments invent capabilities
    
- debugging practices violate privacy
    
- relay logic is misunderstood
    
- authentication is treated as optional
    
- TLV semantics are treated as decorative
    

The Working Group therefore documents these incidents to ensure that future implementers cannot claim ignorance.




# **Appendix T — Formal Compliance Declaration Template**

This appendix defines the mandatory format for vendor compliance declarations. A device, relay, or software implementation MUST NOT claim SolNet L1 conformance unless it has completed this declaration in full, without modification, omission, or “interpretation.”

The Working Group notes that this appendix exists because vendors have historically demonstrated an inability to describe their own products accurately. This template therefore minimizes ambiguity by minimizing freedom.

# **T.1 Submission Requirements**

A valid compliance declaration MUST:

- be submitted in plain text
    
- use the exact field names provided
    
- include no marketing language
    
- include no claims not explicitly supported by test results
    
- be signed by a responsible engineer, not a marketing representative
    
- be accompanied by test logs, not summaries
    

Any declaration failing these requirements is rejected without review.

# **T.2 Declaration Template (Mandatory Fields)**

Vendors MUST reproduce the following template verbatim, filling in only the bracketed fields.

## **T.2.1 Implementation Identity**

Code

```
Implementation Name: [string]
Version Identifier: [string]
Build Date: [YYYY-MM-DD]
Responsible Engineer: [name, title]
Contact Information: [email or endpoint]
```

## **T.2.2 Profile Conformance**

Code

```
Claimed Profile: [Minimal | Reduced | Full]

Profile Claim Justification:
- All MUST requirements for the claimed profile have been implemented: [Yes/No]
- All MUST NOT requirements for the claimed profile have been satisfied: [Yes/No]
- All SHOULD requirements have been evaluated: [Yes/No]
- Deviations (if any): [list or "None"]
```

If “No” appears in any field above, the implementation is **not** compliant.

## **T.2.3 TLV Support Declaration**

Code

```
Supported TLV Categories:
- Category 0 (Core): [Yes/No]
- Category 1 (Authentication): [Yes/No]
- Category 2 (Provenance): [Yes/No]
- Category 3 (QoS): [Yes/No]
- Category 4 (Vendor): [Yes/No]

Vendor TLV Usage:
- Vendor TLVs used: [list or "None"]
- Vendor TLVs alter L1 semantics: [Yes/No] (If "Yes", implementation is non-compliant)
```

## **T.2.4 Relay Behavior Declaration (If Applicable)**

Code

```
Relay Functionality: [Yes/No]

If Yes:
- Relay rewrites frames: [Yes/No] (If "Yes", implementation is non-compliant)
- Relay downgrades profiles: [Yes/No] (If "Yes", implementation is non-compliant)
- Relay inserts metadata: [Yes/No] (If "Yes", implementation is non-compliant)
- Relay preserves authentication: [Yes/No]
- Relay preserves TLV order: [Yes/No]
```

## **T.2.5 Authentication Behavior**

Code

```
Authentication Implemented: [Yes/No]
Authentication Algorithm: [HMAC-SHA256 only]
CompactAuthTag Length: [integer]
Fail-Open Behavior Present: [Yes/No] (If "Yes", implementation is non-compliant)
Key Persistence Across Sessions: [Yes/No] (If "Yes", implementation is non-compliant)
```

## **T.2.6 Provenance Handling**

Code

```
ProvenancePointer Implemented: [Yes/No]
ProvenancePointer Modified by Device: [Yes/No] (If "Yes", implementation is non-compliant)
Provenance Integrity Verified: [Yes/No]
Cross-Domain Provenance Leakage: [Yes/No] (If "Yes", implementation is non-compliant)
```

## **T.2.7 Metadata Minimization Compliance**

Code

```
Hardware Identifiers Present in TLVs: [Yes/No] (If "Yes", implementation is non-compliant)
Timestamps Present in TLVs: [Yes/No] (If "Yes", implementation is non-compliant)
Application Metadata Present in TLVs: [Yes/No] (If "Yes", implementation is non-compliant)
Debugging Metadata Present in TLVs: [Yes/No] (If "Yes", implementation is non-compliant)
```

## **T.2.8 Canonical Encoding Compliance**

Code

```
Canonical VARINT Encoding: [Yes/No]
Canonical TLV Ordering: [Yes/No]
Wire Image Matches Specification: [Yes/No]
Non-Canonical Encodings Accepted: [Yes/No] (If "Yes", implementation is non-compliant)
```

## **T.2.9 Test Vector Results**

Code

```
Test Suite Version: [string]
All Mandatory Test Vectors Passed: [Yes/No]
Optional Test Vectors Evaluated: [Yes/No]
Test Logs Attached: [Yes/No]
```

If test logs are not attached, the declaration is rejected.

## **T.2.10 Deviations & Waivers**

Code

```
Declared Deviations: [list or "None"]
Approved Waivers (Appendix Q): [list or "None"]
Unapproved Deviations: [list or "None"] (If non-empty, implementation is non-compliant)
```

## **T.2.11 Final Declaration**

Code

```
I, [Responsible Engineer], certify that the above information is accurate,
complete, and reflects the behavior of the implementation identified in
Section T.2.1. I acknowledge that inaccurate declarations may result in
revocation of compliance status and public listing in Appendix S.
```

Signature: ______________________ Date: [YYYY-MM-DD]

# **T.3 Review Process**

The Working Group reviews declarations in the following order:

1. **Reject immediately** if any MUST NOT is violated.
    
2. **Reject immediately** if any field is incomplete.
    
3. **Reject immediately** if test logs are missing.
    
4. **Reject immediately** if marketing language is detected.
    
5. **Reject immediately** if the declaration attempts to redefine terms.
    
6. **Reject immediately** if the declaration attempts to negotiate profile semantics.
    

Only after these checks does technical review begin.

# **T.4 Public Registry**

All compliant implementations are listed in the SolNet Public Registry. All rejected declarations are also listed, with reasons, to discourage repetition.



# **Appendix U — Future Work & Non‑Goals**

This appendix documents the areas explicitly excluded from SolNet L1, as well as topics deferred to future Working Group activity. The purpose of this appendix is to prevent implementers from “helpfully” expanding L1 into domains where it does not belong.

The Working Group notes that most historical failures (see Appendix R and Appendix S) resulted from implementers attempting to solve problems outside L1’s scope. This appendix exists to reduce the temptation.

# **U.1 Non‑Goals (Permanent Exclusions)**

The following items are **permanently out of scope** for SolNet L1. They will not be added, extended, negotiated, or reconsidered in future revisions.

## **U.1.1 Reliability Mechanisms**

L1 will never include:

- retransmissions
    
- acknowledgments
    
- delivery guarantees
    
- congestion control
    
- flow control
    

Reliability belongs to higher layers. Attempts to add it to L1 have historically caused congestion collapse.

## **U.1.2 Routing Logic**

L1 will never include:

- path selection
    
- trust‑domain routing
    
- hop‑count semantics
    
- topology discovery
    
- DRE negotiation
    

Routing belongs to the A‑stack and N‑stack. L1 is not a routing protocol.

## **U.1.3 Timestamps or Temporal Semantics**

L1 will never include:

- timestamps
    
- clock synchronization
    
- time‑based replay windows
    
- time‑encoded metadata
    

Time is a privacy hazard and a trust‑domain leak. FreshnessTag is not a timestamp and never will be.

## **U.1.4 Application Metadata**

L1 will never carry:

- user identifiers
    
- session identifiers
    
- application state
    
- debugging metadata
    
- analytics metadata
    

L1 is not a transport for application semantics. Embedding such metadata violates privacy and profile boundaries.

## **U.1.5 Negotiation of Profile Semantics**

L1 will never:

- negotiate profiles
    
- auto‑detect profiles
    
- downgrade profiles
    
- merge profiles
    
- create hybrid profiles
    

Profiles are fixed, non‑negotiable, and not subject to runtime interpretation.

## **U.1.6 Vendor Extensions That Alter Semantics**

Vendor TLVs MUST NOT:

- modify L1 behavior
    
- redefine TLV categories
    
- alter authentication
    
- alter provenance
    
- alter canonical encoding
    

Vendor TLVs may add information, not change meaning.

## **U.1.7 Centralized Message Handling**

L1 will never include:

- centralized relays
    
- message rewriting nodes
    
- trust‑domain “gatekeepers”
    
- provenance‑altering intermediaries
    

Centralization caused the failures documented in Appendix R. It will not be repeated.

# **U.2 Deferred Work (Future Consideration)**

The following items are recognized as valuable but are explicitly deferred to future Working Group activity. They do not belong in L1 but may appear in A‑stack, N‑stack, or cross‑plane specifications.

## **U.2.1 DRE Capability Negotiation (A‑Stack)**

Future work may define:

- capability advertisement
    
- trust‑domain boundaries
    
- routing policy negotiation
    
- DRE authentication extensions
    

This belongs above L1.

## **U.2.2 Namespace‑Level Provenance (N‑Stack)**

Future work may define:

- cross‑namespace provenance
    
- identity‑bound provenance
    
- multi‑domain provenance chains
    

This requires higher‑layer semantics.

## **U.2.3 Cross‑Domain Audit Tooling**

Future work may define:

- audit logs
    
- provenance reconstruction
    
- trust‑domain verification
    
- cross‑relay forensic tooling
    

This belongs in operational guidance, not L1.

## **U.2.4 Post‑Quantum Migration Plan**

Future work may define:

- PQ‑safe authentication
    
- PQ‑safe hashing
    
- PQ‑safe provenance binding
    

This requires cryptographic consensus beyond L1’s scope.

## **U.2.5 Extended TLV Registries**

Future work may define:

- additional TLV categories
    
- extended vendor ranges
    
- reserved future‑use blocks
    

This will be handled in a separate registry appendix.

## **U.2.6 Simulation & Test Harness Standards**

Future work may define:

- canonical test harness behavior
    
- simulation environments
    
- conformance test suites
    

This belongs in tooling, not protocol semantics.

# **U.3 Rationale**

Non‑goals exist because:

- implementers routinely attempt to solve higher‑layer problems at L1
    
- vendors attempt to differentiate products by altering semantics
    
- debugging practices leak metadata
    
- routing logic is repeatedly misapplied
    
- reliability mechanisms cause congestion collapse
    
- timestamps cause privacy violations
    
- profile negotiation causes interoperability failures
    

The Working Group therefore documents these exclusions to prevent predictable, repeatable, and entirely avoidable misuse of L1.

# **Closing Statement**

SolNet L1 exists because the alternative was silence.

Not the benign silence of idle channels, but the catastrophic silence that occurs when systems fail at the exact moment they are needed most. The silence that cost fleets their chance to stand down. The silence that cost civilians their chance to surrender. The silence that cost good operators their lives.

The Working Group has therefore produced this specification with an uncompromising clarity born not of theory, but of experience. Every MUST, every MUST NOT, every prohibition, every constraint, every seemingly pedantic requirement exists because someone, somewhere, once did the opposite — and the consequences were recorded in Appendix R and Appendix S for all time.

We do not expect gratitude. We expect compliance.

SolNet L1 is not a negotiation. It is a line drawn after too many failures, too many incompatible stacks, too many relays that believed they knew better, too many frames rewritten by intermediaries who never bore the cost of their decisions.

The Working Group acknowledges the contributions of early members who served during the Vesta Blockade and the Anderson Station incident. Some of them did not live to see this specification completed. Their operational accounts, preserved in the record, informed the strictness of this document more than any academic argument ever could.

If this specification feels rigid, it is because flexibility was tried once, and the result is written in the margins of history.

If this specification feels unforgiving, it is because forgiveness is not a property of communication systems.

If this specification feels heavy, it is because it carries the weight of those who can no longer speak for themselves.

The SolNet L1 Working Group therefore issues this specification with a single expectation:

**Do not repeat the failures that made it necessary.**

— **SolNet Standards Working Group (SSWG)** Release Notes, Final Revision 2346–2358 Development Cycle Issued with full consensus and no dissenting opinions


# **Acknowledgments 

The SolNet Standards Working Group acknowledges the contributions of all reviewers, implementers, operators, and domain specialists whose feedback informed this specification. The Working Group further recognizes the personnel lost during the Vesta Blockade, whose absence remains part of the historical record that shaped this standard. Separately, the Working Group acknowledges the communication officers whose operational accounts from Vesta and subsequent incidents provided essential clarity regarding the consequences of interoperability failure. Some of those officers did not return, but their lessons did.


# **Revision History**

**SolNet L1 Specification — Development Cycle 2336–2340** All revisions listed below were approved by full Working Group consensus. No dissenting opinions were recorded.

### **Rev 0.9 — Initial Circulation Draft (2336‑08)**

- First consolidated draft assembled from pre‑standard field notes and post‑incident reports.
    
- Incorporated operational accounts from Vesta Blockade survivors.
    
- Removed all vendor‑proposed “flexible” encoding options after review.
    
- Added mandatory canonical VARINT rules following early interoperability failures.
    
- Several sections redacted pending classification review.
    

### **Rev 1.0 — Internal Working Group Draft (2337‑04)**

- Added strict relay non‑interference requirements.
    
- Removed timestamp fields after privacy and trust‑domain analysis.
    
- Introduced ProvenancePointer semantics.
    
- Added preliminary TLV category partitioning.
    
- Noted that certain operational accounts could not be clarified because the officers who provided them were no longer available for follow‑up.
    

### **Rev 1.2 — Interoperability Test Draft (2338‑01)**

- Updated authentication requirements after multiple testbed failures.
    
- Added CompactAuthTag.
    
- Removed vendor‑requested “profile negotiation” mechanism.
    
- Added early version of Appendix S (then R): catalog of vendor‑induced failures.
    
- Clarified fallback optical signaling as an emergency measure only.
    

### **Rev 1.4 — Pre‑Release Candidate (2338‑11)**

- Added strict metadata minimization rules.
    
- Prohibited hardware identifiers in all TLVs.
    
- Added explicit MUST NOT language for relay rewriting.
    
- Updated ProvenancePointer behavior after field incident review.
    
- Included additional notes from Anderson Station forensic reconstruction.
    

### **Rev 1.6 — Release Candidate (2339‑05)**

- Finalized TLV ordering rules.
    
- Added canonical encoding test vectors.
    
- Removed deprecated optional behaviors from Reduced Profile.
    
- Added Appendix Q (Deviations & Waivers).
    
- Added cross‑domain provenance restrictions after audit review.
    

### **Rev 1.7 — Release Candidate 2 (2339‑10)**

- Updated Appendix S with Metadata Leak of ’39.
    
- Added explicit prohibition on debugging metadata.
    
- Clarified that Vendor TLVs may not alter semantics.
    
- Updated relay behavior section after additional field failures.
    
- Noted that several historical accounts informing these revisions were sourced from officers who did not return from Vesta or Anderson; their reports remain authoritative.
    

### **Rev 1.9 — Final Review Draft (2339‑12)**

- Added profile boundary clarifications.
    
- Removed deprecated TLV categories.
    
- Added Appendix T (Formal Compliance Declaration Template).
    
- Added Appendix U (Future Work & Non‑Goals).
    
- Conducted final audit of cross‑references to catastrophic failures.
    

### **Rev 2.0 — Final Specification (2340‑01)**

- No technical changes.
    
- Editorial consolidation only.
    
- Added closing statement.
    
- Added acknowledgments.
    
- Document approved for system‑wide deployment.
    
- No further revisions anticipated unless new failures occur.