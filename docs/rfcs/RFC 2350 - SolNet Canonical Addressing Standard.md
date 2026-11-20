# **RFC‑2350 — SolNet Canonical Addressing Standard**

**SolNet Standards Working Group — L1 Addressing Working Group (SSWG‑L1‑AWG)** **Custodian:** Canonical Address Registrar (CAR) **Status:** Standards‑Track **Layer:** L1 Data‑Link **Revision:** 1.0 **Date:** 2046‑04

# **0. Preface (SSWG‑L1‑AWG Statement)**

This document defines the canonical grammar for SolNet Data‑Link addressing. The Working Group notes, without surprise, that implementers continue to invent incompatible delimiter rules, implicit coercions, and “helpful” parser heuristics. RFC‑2350 exists to eliminate such creativity.

The `<LocationChain>//<ServiceChain>` form is the only permitted structure. The delimiter is fixed. Whitespace is forbidden. Canonical ordering is mandatory. Implementations that deviate from this specification produce undefined behavior and are non‑compliant at CL‑3 or higher.

The Canonical Address Registrar (CAR) maintains exclusive authority over delimiter semantics, TLV key allocations, and grammar stability. Errata that attempt to redefine the delimiter or introduce alternative separators will not be considered.

## **0.1 Terminology Reconciliation Note**

Earlier SolNet drafts and several legacy deployments refer to the two halves of the canonical address as the **Authority Plane** (left side) and the **Namespace Plane** (right side). These terms are deprecated.

RFC‑2350 standardizes the terminology as:

- **LocationChain (L1‑L)** — formerly “Authority Plane”
    
- **ServiceChain (L1‑S)** — formerly “Namespace Plane”
    

The semantics are unchanged; only the names are corrected for clarity and consistency with RFC‑2300 (Terminology & Concepts) and RFC‑2360 (Layer Model).

Implementations MUST treat the legacy terms as synonyms for the canonical terms but MUST NOT emit them in new records, logs, or wire formats.

# **1. Scope**

RFC‑2350 defines:

- the canonical `<LocationChain>//<ServiceChain>` grammar
    
- the semantics of the `//` delimiter
    
- TrustTag, QoSClass, FreshnessTag, and ProvenancePointer fields
    
- TLV key allocations for L1‑relevant L0 metadata (BeamID, ProxID, CommNetID, GroupID)
    
- the canonical AddressRecord structure
    
- the ProvenancePointer binary format
    
- resolution precedence rules
    
- varint and TLV encoding requirements
    
- parser and resolver test requirements
    

RFC‑2350 does **not** define:

- routing behavior (RFC‑2363)
    
- identity semantics (RFC‑2361)
    
- namespace resolution (RFC‑2390+)
    
- session behavior (RFC‑2392)
    
- media‑specific addressing (L0 subprofiles)
    

These are out of scope and remain the responsibility of their respective working groups.



# **2. Terminology**

The following terms are used normatively throughout this document. All terms inherit their global definitions from RFC‑2300 unless explicitly refined here.

**Address** — A canonical `<LocationChain>//<ServiceChain>` identifier. **LocationChain (L1‑L)** — Ordered sequence of location hints, proximity identifiers, or media‑specific TLVs. **ServiceChain (L1‑S)** — Ordered sequence of service identifiers, session hints, or application selectors. **BareToken** — A non‑TLV ASCII token with no whitespace and no delimiter characters. **TrustTag** — Compact indicator of trust domain or authority context. **FreshnessTag** — Varint expressing temporal freshness. **ProvenancePointer** — Canonical reference to the authoritative origin of the address. **TLV Key** — Registry‑allocated identifier for L1‑relevant metadata. **Canonical Form** — The only permitted wire encoding for a given structure. **CAR** — Canonical Address Registrar; custodian of delimiter and grammar stability.

# **3. Canonical Grammar Overview**

The canonical address grammar is:

Code

```
<LocationChain> "//" <ServiceChain>
```

Where:

- `<LocationChain>` MUST NOT be empty
    
- `<ServiceChain>` MAY be empty
    
- `//` is the only permitted delimiter
    
- no whitespace is permitted anywhere
    
- TLV‑encoded elements MUST appear in canonical order
    
- BareTokens MUST NOT contain `/` or `//`
    
- implementations MUST NOT infer missing elements
    

The full grammar is defined in Section 4.


# **4. Full Grammar Definition**

This section defines the complete canonical grammar for SolNet L1 addresses. The grammar is normative. Implementations MUST parse exactly as specified. Heuristics, contextual inference, and “best‑effort” parsing are prohibited.

The grammar is expressed using the restricted ABNF subset maintained by the Canonical Address Registrar (CAR). Where ABNF and canonical ordering conflict, canonical ordering prevails.

## **4.1 Top‑Level Structure**

Code

```
Address          = LocationChain "//" ServiceChain
```

Constraints:

- `LocationChain` MUST contain at least one element.
    
- `ServiceChain` MAY be empty but MUST be syntactically present.
    
- The delimiter `//` MUST appear exactly once.
    
- No whitespace is permitted anywhere in the Address.
    
- No implicit coercion of missing elements is permitted.
    
- Implementations MUST NOT attempt to “repair” malformed addresses.
    

## **4.2 LocationChain**

Code

```
LocationChain    = LocationElement *( "/" LocationElement )
```

Rules:

- Elements MUST appear in canonical order:
    
    1. BareTokens
        
    2. TLVs
        
    3. ProvenancePointer (if present)
        
- TLVs MUST use registry‑assigned keys.
    
- Duplicate TLVs are prohibited unless explicitly allowed by their key definition.
    
- LocationChain MUST NOT be empty.
    

## **4.3 ServiceChain**

Code

```
ServiceChain     = [ ServiceElement *( "/" ServiceElement ) ]
```

Rules:

- ServiceChain MAY be empty, but the `//` delimiter MUST still be present.
    
- Elements MUST appear in canonical order:
    
    1. BareTokens
        
    2. TLVs
        
    3. Session selectors (if present)
        
- ServiceChain MUST NOT contain ProvenancePointer.
    

## **4.4 Elements**

Code

```
LocationElement  = BareToken / TLV / ProvenancePointer
ServiceElement   = BareToken / TLV
```

Notes:

- ProvenancePointer is restricted to LocationChain.
    
- TLVs MUST NOT appear before BareTokens.
    
- BareTokens MUST NOT contain `/` or `//`.
    

## **4.5 BareToken**

Code

```
BareToken        = 1*( ALPHA / DIGIT / "-" / "_" / "." )
```

Restrictions:

- BareTokens MUST NOT contain `/`, `//`, whitespace, or control characters.
    
- BareTokens MUST NOT be interpreted as TLVs or ProvenancePointers.
    
- BareTokens MUST NOT be coerced into numeric or structured types.
    

## **4.6 TLV Encoding**

Code

```
TLV              = "{" TLVKey ":" TLVValue "}"
TLVKey           = 1*DIGIT
TLVValue         = 1*( ALPHA / DIGIT / "-" / "_" / "." )
```

Rules:

- TLVKey MUST be a registry‑assigned integer.
    
- TLVValue MUST conform to the canonical form defined by its key.
    
- TLVs MUST appear in ascending TLVKey order.
    
- TLVs MUST NOT be nested.
    
- TLVs MUST NOT appear after ProvenancePointer.
    

## **4.7 ProvenancePointer**

Code

```
ProvenancePointer = "@" 1*( ALPHA / DIGIT / "-" / "_" / "." )
```

Rules:

- ProvenancePointer MUST appear at most once.
    
- If present, it MUST be the final element of LocationChain.
    
- ProvenancePointer MUST NOT appear in ServiceChain.
    
- The pointer MUST resolve to a valid ProvenanceRecord (RFC‑2363).
    

## **4.8 Delimiter Rules**

Code

```
Delimiter        = "//"
```

Rules:

- The delimiter MUST appear exactly once.
    
- The delimiter MUST NOT be escaped, quoted, or substituted.
    
- The delimiter MUST NOT appear inside BareTokens, TLVs, or ProvenancePointer.
    
- Implementations MUST NOT interpret `/` as equivalent to `//`.
    

## **4.9 Canonical Ordering Summary**

Within each chain:

1. **BareTokens** (zero or more)
    
2. **TLVs** (zero or more, ascending TLVKey order)
    
3. **ProvenancePointer** (LocationChain only, at most one)
    

Any deviation from this ordering renders the Address non‑canonical.

## **4.10 Invalid Forms (Non‑Exhaustive)**

The following forms are invalid and MUST be rejected:

- missing delimiter: `a/b/c`
    
- multiple delimiters: `a/b//c/d//e`
    
- whitespace: `a / b // c`
    
- TLVs out of order: `{5:x}/{3:y}`
    
- ProvenancePointer in ServiceChain: `a/b//@origin`
    
- nested TLVs: `{3:{4:x}}`
    
- implicit empty LocationChain: `//service`
    

The Working Group declines to enumerate all invalid forms, as implementers have demonstrated unlimited creativity in producing them.


# **5. Canonical AddressRecord Structure**

This section defines the canonical binary and logical structure of the AddressRecord. The AddressRecord is the authoritative representation of an Address for storage, transmission, hashing, and provenance operations. The textual grammar defined in Section 4 is a human‑readable projection of this structure; the AddressRecord is the normative form.

Implementations MUST construct, store, and transmit AddressRecords exactly as specified. Partial serialization, field omission, and “lazy” decoding are prohibited.

## **5.1 AddressRecord Overview**

An AddressRecord consists of the following fields, in canonical order:

1. **LocationChain**
    
2. **ServiceChain**
    
3. **TrustTag**
    
4. **QoSClass**
    
5. **FreshnessTag**
    
6. **ProvenancePointer** (optional)
    
7. **TLVContainer** (zero or more TLVs)
    

All fields are mandatory unless explicitly marked optional. Fields MUST appear in the order listed above. Implementations MUST NOT reorder fields for convenience, compression, or “optimization.”

The Working Group notes that several early implementations attempted to reorder fields based on perceived access frequency. This behavior is non‑compliant.

## **5.2 Binary Encoding**

All AddressRecords MUST use the canonical varint‑prefixed binary encoding defined in RFC‑2301 and RFC‑2302. Each field is encoded as:

Code

```
Field = VarintLength || FieldBytes
```

Where:

- **VarintLength** is the length of FieldBytes
    
- **FieldBytes** is the canonical encoding of the field
    
- zero‑length fields are prohibited unless explicitly permitted
    

Implementations MUST NOT use alternative length encodings, fixed‑width prefixes, or implicit termination.

## **5.3 LocationChain Encoding**

Code

```
LocationChain = VarintCount || LocationElement[0] || ... || LocationElement[n]
```

Rules:

- VarintCount MUST equal the number of LocationElements.
    
- Elements MUST appear in canonical order (BareTokens → TLVs → ProvenancePointer).
    
- ProvenancePointer, if present, MUST be the final element.
    
- LocationChain MUST contain at least one element.
    

The Working Group declines to accept proposals allowing empty LocationChains, as such proposals universally rely on implicit inference, which is prohibited.

## **5.4 ServiceChain Encoding**

Code

```
ServiceChain = VarintCount || ServiceElement[0] || ... || ServiceElement[n]
```

Rules:

- VarintCount MAY be zero.
    
- Elements MUST appear in canonical order (BareTokens → TLVs).
    
- ServiceChain MUST NOT contain ProvenancePointer.
    

## **5.5 TrustTag**

Code

```
TrustTag = 1-byte unsigned integer
```

Rules:

- Values 0–15 are reserved for Trust Domains defined in RFC‑2362.
    
- Values 16–255 are allocated by the CAR.
    
- Implementations MUST NOT infer trust level from address structure or origin.
    

## **5.6 QoSClass**

Code

```
QoSClass = 1-byte unsigned integer
```

Rules:

- Values 0–7 are defined in RFC‑2351.
    
- Values 8–255 are reserved.
    
- QoSClass MUST NOT be repurposed for priority, routing hints, or congestion signaling.
    

## **5.7 FreshnessTag**

Code

```
FreshnessTag = Varint
```

Rules:

- Expresses temporal freshness in canonical varint form.
    
- MUST be monotonic within a given ProvenancePointer context.
    
- MUST NOT be interpreted as a timestamp.
    

The Working Group notes that implementers repeatedly attempt to treat FreshnessTag as a timestamp. This behavior is incorrect.

## **5.8 ProvenancePointer**

Code

```
ProvenancePointer = VarintLength || PointerBytes
```

Rules:

- Optional.
    
- If present, MUST reference a valid ProvenanceRecord (RFC‑2363).
    
- MUST NOT appear in ServiceChain.
    
- MUST NOT appear more than once.
    

## **5.9 TLVContainer**

Code

```
TLVContainer = VarintCount || TLV[0] || ... || TLV[n]
```

Rules:

- TLVs MUST appear in ascending TLVKey order.
    
- TLVs MUST NOT be nested.
    
- TLVs MUST NOT duplicate keys unless explicitly allowed by the key definition.
    
- TLVs MUST NOT appear before ProvenancePointer.
    

## **5.10 Invalid AddressRecord Forms**

The following forms are invalid and MUST be rejected:

- missing VarintLength prefixes
    
- TLVs out of canonical order
    
- ProvenancePointer appearing before TLVs
    
- multiple ProvenancePointers
    
- zero‑length LocationChain
    
- implicit or inferred field values
    
- reordered fields
    

The Working Group declines to enumerate all invalid binary forms, as implementers have demonstrated unlimited creativity in producing them.

# **6. ProvenancePointer Binary Format**

The ProvenancePointer provides a canonical reference to the authoritative origin of an Address. It is optional but, when present, MUST conform exactly to the structure defined in this section. Implementations MUST NOT substitute alternative pointer formats, implicit references, or context‑derived origins.

The ProvenancePointer is not a timestamp, not a hash of the Address, and not a routing hint. It is a strict reference to a ProvenanceRecord as defined in RFC‑2363.

## **6.1 Structure**

The ProvenancePointer is encoded as:

Code

```
ProvenancePointer = VarintLength || PointerBytes
```

Where:

- **VarintLength** — canonical varint specifying the length of PointerBytes
    
- **PointerBytes** — canonical encoding of the pointer target
    

The ProvenancePointer MUST appear at most once and MUST be the final element of the LocationChain.

## **6.2 PointerBytes Format**

Code

```
PointerBytes = PointerType || PointerValue
```

Where:

- **PointerType** — 1‑byte unsigned integer
    
- **PointerValue** — type‑specific canonical encoding
    

PointerType values:

|Value|Meaning|
|---|---|
|0x00|Reserved (MUST NOT be used)|
|0x01|DirectRecordHash|
|0x02|LedgerEntryRef|
|0x03|DRERecordRef|
|0x04–0x7F|Reserved for SSWG allocation|
|0x80–0xFF|Vendor‑specific (MUST NOT appear on public networks)|

Implementations MUST reject PointerType values not explicitly permitted.

## **6.3 DirectRecordHash (PointerType = 0x01)**

Code

```
PointerValue = HashAlgorithm || HashBytes
```

Rules:

- **HashAlgorithm** — 1‑byte unsigned integer (see RFC‑2301)
    
- **HashBytes** — canonical hash output for the algorithm
    
- HashBytes MUST match the hash of a valid ProvenanceRecord
    

Implementations MUST NOT accept truncated hashes, partial hashes, or hashes of non‑canonical forms.

## **6.4 LedgerEntryRef (PointerType = 0x02)**

Code

```
PointerValue = LedgerID || EntryIndex
```

Where:

- **LedgerID** — varint identifying the ledger (RFC‑2302)
    
- **EntryIndex** — varint identifying the entry within the ledger
    

Rules:

- LedgerID MUST reference a known ledger
    
- EntryIndex MUST reference a valid entry
    
- Implementations MUST NOT infer ledger identity from network context
    

The Working Group notes that several early implementations attempted to “guess” the ledger based on device location. This behavior is non‑compliant.

## **6.5 DRERecordRef (PointerType = 0x03)**

Code

```
PointerValue = DREID || RecordIndex
```

Where:

- **DREID** — varint identifying the Directory & Routing Endpoint (RFC‑2363)
    
- **RecordIndex** — varint identifying the record within the DRE
    

Rules:

- DREID MUST reference a reachable DRE
    
- RecordIndex MUST reference a valid ProvenanceRecord
    
- Implementations MUST NOT treat DRE references as routing hints
    

## **6.6 Canonical Ordering and Placement**

The ProvenancePointer:

- MUST appear at most once
    
- MUST appear only in the LocationChain
    
- MUST appear after all BareTokens and TLVs
    
- MUST NOT appear in the ServiceChain
    
- MUST NOT be followed by any TLVs
    

Any violation renders the Address non‑canonical.

## **6.7 Invalid ProvenancePointer Forms**

The following forms are invalid and MUST be rejected:

- missing VarintLength prefix
    
- zero‑length PointerBytes
    
- multiple ProvenancePointers
    
- ProvenancePointer appearing before TLVs
    
- ProvenancePointer appearing in ServiceChain
    
- PointerType = 0x00
    
- PointerType in vendor range (0x80–0xFF) on public networks
    
- PointerValue not matching the expected structure for its PointerType
    
Implementations encountering malformed ProvenancePointers MUST reject them without attempting repair. Historical attempts to “interpret intent” have produced inconsistent and non‑compliant behavior and MUST NOT be repeated.

# **7. Resolution Precedence Rules**

Resolution precedence defines the deterministic order in which an Address is interpreted, validated, and resolved. Implementations MUST follow these rules exactly. Heuristics, contextual inference, and “best‑match” behavior are prohibited.

Resolution precedence applies to:

- parsing
    
- TLV interpretation
    
- ProvenancePointer dereferencing
    
- chain evaluation
    
- DRE lookup (RFC‑2363)
    
- namespace escalation (RFC‑2390+)
    

The rules in this section override any conflicting behavior in local implementations.

## **7.1 Precedence Overview**

Resolution proceeds in the following canonical order:

1. **Syntactic validation** (Section 4)
    
2. **Canonical ordering verification**
    
3. **LocationChain evaluation**
    
4. **ServiceChain evaluation**
    
5. **TLV interpretation**
    
6. **ProvenancePointer dereference**
    
7. **DRE resolution**
    
8. **Namespace escalation**
    

Implementations MUST NOT reorder these steps.

The Working Group notes that several early implementations attempted to evaluate ServiceChain elements before LocationChain validation. This behavior is non‑compliant.

## **7.2 Syntactic Validation (Step 1)**

Before any semantic interpretation occurs, the Address MUST be validated against the grammar in Section 4.

Rules:

- malformed addresses MUST be rejected immediately
    
- no partial evaluation is permitted
    
- no fallback behavior is permitted
    
- no inference of missing elements is permitted
    

If syntactic validation fails, resolution MUST terminate.

## **7.3 Canonical Ordering Verification (Step 2)**

After syntactic validation, implementations MUST verify canonical ordering:

- BareTokens → TLVs → ProvenancePointer (LocationChain only)
    
- BareTokens → TLVs (ServiceChain)
    
- TLVs in ascending TLVKey order
    

Any deviation renders the Address non‑canonical and MUST be rejected.

## **7.4 LocationChain Evaluation (Step 3)**

LocationChain MUST be evaluated before ServiceChain.

Rules:

- BareTokens are interpreted first
    
- TLVs are interpreted second
    
- ProvenancePointer (if present) is interpreted last
    
- no inference of missing location information is permitted
    

LocationChain evaluation MUST NOT depend on ServiceChain content.

## **7.5 ServiceChain Evaluation (Step 4)**

ServiceChain evaluation occurs only after LocationChain evaluation completes successfully.

Rules:

- BareTokens are interpreted first
    
- TLVs are interpreted second
    
- ProvenancePointer MUST NOT appear
    
- ServiceChain MUST NOT influence LocationChain interpretation
    

Implementations MUST NOT reorder chain evaluation based on “expected usage patterns.”

## **7.6 TLV Interpretation (Step 5)**

TLVs MUST be interpreted strictly according to their registry definitions.

Rules:

- TLVs MUST NOT override BareTokens
    
- TLVs MUST NOT override ProvenancePointer
    
- TLVs MUST NOT introduce implicit semantics
    
- TLVs MUST NOT be interpreted out of order
    

TLVs that conflict with canonical ordering MUST be rejected.

## **7.7 ProvenancePointer Dereference (Step 6)**

If a ProvenancePointer is present, it MUST be dereferenced after all chain and TLV evaluation.

Rules:

- dereferencing MUST NOT occur before TLV interpretation
    
- dereferencing MUST NOT be skipped
    
- dereferencing MUST NOT be deferred to higher layers
    
- dereferencing MUST NOT be treated as a routing hint
    

If dereferencing fails, resolution MUST terminate.

## **7.8 DRE Resolution (Step 7)**

After ProvenancePointer dereference (if present), the Address MAY be submitted to a Directory & Routing Endpoint (RFC‑2363).

Rules:

- DRE resolution MUST NOT occur before ProvenancePointer dereference
    
- DRE resolution MUST NOT reorder chain interpretation
    
- DRE resolution MUST NOT infer missing fields
    
- DRE resolution MUST NOT modify the Address
    

If the DRE returns no result, resolution proceeds to namespace escalation.

## **7.9 Namespace Escalation (Step 8)**

If DRE resolution fails or returns no authoritative result, namespace escalation MAY occur according to RFC‑2390+.

Rules:

- escalation MUST NOT occur before DRE resolution
    
- escalation MUST NOT modify the Address
    
- escalation MUST NOT infer missing ProvenancePointer values
    
- escalation MUST NOT bypass syntactic or canonical validation
    

Escalation is the final step. If escalation fails, resolution terminates.

## **7.10 Invalid Resolution Behaviors**

The following behaviors are invalid and MUST be rejected:

- evaluating ServiceChain before LocationChain
    
- interpreting TLVs before BareTokens
    
- dereferencing ProvenancePointer before TLVs
    
- skipping ProvenancePointer dereference
    
- treating ProvenancePointer as a routing hint
    
- inferring missing elements
    
- reordering resolution steps for “performance”
    
- attempting resolution on non‑canonical addresses
    

The Working Group declines to enumerate all invalid behaviors, as implementers have demonstrated unlimited creativity in producing them.

