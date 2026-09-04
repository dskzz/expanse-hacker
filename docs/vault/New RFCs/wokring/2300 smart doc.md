 ### RFC‑2300 — SolNet Terminology and Concepts (Updated)

**Status:** Informational / Foundational **Working group:** SolNet Standards Working Group (SSWG)

This document is the canonical vocabulary and conceptual foundation for the SolNet RFC corpus. It is normative for terminology, address form, identifier class, plane boundaries, role weights, and the minimal extension model used by all module RFCs. The text below preserves the original RFC‑2300 content and appends the TLV/profile extension model, ProvenancePointer and FreshnessClass definitions, minimal L1 header hooks, canonical record skeletons, test vectors, and DRE profile registry requirements so RFC‑2300 can serve as the single authoritative memory for the project.

### 1 Purpose and scope

Define the vocabulary, identifier class (UUID‑S7), two‑plane architecture (Location Plane and Service Plane), canonical address grammar (`<LocationChain>//<ServiceChain>`), role weights, and minimal operational primitives. This RFC does **not** specify wire encodings for all records (those live in profile RFCs) but does lock the extension mechanism and canonical pointer/freshness formats used across the corpus.

### 2 Core definitions (preserved)

- **SolNet:** the interlinked, delay‑tolerant, jurisdictionally fragmented communications fabric.
    
- **UUID‑S7:** canonical 128‑bit, time‑sortable identifier for domain anchors and long‑lived entities. Implementations **MUST** use UUID‑S7 for ledger anchors and cross‑domain references.
    
- **LocationChain:** left‑hand chain naming authority and coarse location (e.g., `MCRC:ALPHAFLEET:DONNAGER`).
    
- **ServiceChain:** right‑hand chain naming local service paths (e.g., `ENGINEERING:ENG‑1:Reactor`).
    
- **Location Plane (L‑stack):** identity, coarse ephemeris, DREs, and inter‑domain reachability.
    
- **Service Plane (S‑stack):** local naming, discovery, sessions, and ACLs.
    
- **Physical Substrate (L0):** tightbeam, RF, optics, occlusion, and propagation effects.
    
- **Data‑Link Split (L1‑L / L1‑S):** single frame with two header views: L1‑L for Location metadata and L1‑S for Service framing.
    
- **Role Weight:** numeric attributes (LocationWeight, ServiceWeight) describing node participation in each plane.
    
- **PNI (Personal Namespace Identifier):** user‑centric identifier bound to a device; optional ledger anchoring.
    
- **LedgerAnchor:** append‑only registry entry binding UUID‑S7 ↔ LocationChain and revocations.
    

### 3 Architectural primitives (preserved)

- Two orthogonal logical planes operate over a single physical substrate: Location answers _who/where_; Service answers _what/how_.
    
- UUID‑S7 is time‑sortable and opaque; it does not embed location or authority.
    
- Canonical address form is `<LocationChain>//<ServiceChain>`; the `//` boundary is mandatory. Parsers **MUST** enforce a single `//`.
    
- Role weights inform metadata exposure, hardware security requirements, and revocation impact.
    

### 4 Addendum: TLV and Profile Extension Model (new normative material)

**Rationale:** L0/L1 must remain minimal and stable. Optional capabilities and domain‑specific hooks are exposed via a single L1 TLV container and versioned profile RFCs registered in the DRE profile registry.

**Key rules**

- **TLV container only:** All optional on‑air hints and feature flags **MUST** be carried inside the L1 TLV container (see RFC‑2350 for header layout). No new mandatory L1 fields are permitted.
    
- **Key space partitioning:** reserve ranges to avoid collisions and simplify discovery:
    
    - `0x00–0x1F` — Core hooks (ProvenancePointer, EmergencyLevel).
        
    - `0x20–0x5F` — L0 subprofiles (BeamID, ProxID).
        
    - `0x60–0x8F` — L1 hints and group IDs (CommNetID, GroupID).
        
    - `0x90–0xFF` — Experimental/vendor extensions.
        
- **Unknown TLVs:** Receivers **MUST** skip unknown TLVs silently and log them locally for audit.
    
- **Profile registration:** A profile **MUST** be registered in the DRE profile registry (`//profiles/<name>/v<semver>`) before being used on‑air. Registry entry includes TLV keys, schema URL, privacy statement, and test vectors.
    
- **Session negotiation:** Profile versions are negotiated at the ServicePlane session level; TLVs are valid only after negotiation or when advertised by a DRE/relay.
    

**Implementation note:** The TLV container is intentionally compact; profile RFCs define TLV payload schemas and compact encodings for constrained devices.

### 5 ProvenancePointer canonical form (new normative material)

**Format:**

Code

```
<DRE‑ID>:<record‑hash‑hex>:<short‑timestamp>
```

**Example:** `DRE1:9f3a7b:20260326T1631Z`

**Semantics**

- **DRE‑ID:** authoritative DRE identifier (DRE registry entry).
    
- **record‑hash‑hex:** canonical hash (e.g., SHA‑256 truncated per profile rules) of the referenced CBOR record.
    
- **short‑timestamp:** compact UTC creation time (YYYYMMDDThhmmZ or similar canonical form).
    

**Fetch semantics**

- `GET /dres/<LocationChain>//info` resolves a ProvenancePointer to the CBOR record and returns an optional `LedgerPointer` when an anchor exists.
    
- Receivers **MUST** treat a ProvenancePointer as **advisory** until ledger verification completes; provisional receipts are allowed but must be reconciled per reconciliation rules.
    

**Implementation constraints**

- ProvenancePointer must be compact enough to fit in a TLV varint field when used as a pointer.
    
- DREs **MUST** support pointer resolution and return `LedgerPointer` when an anchor exists.
    

### 6 FreshnessClass enumeration (new normative material)

**Purpose:** Standardize freshness semantics so receivers make consistent trust decisions.

**Values and default windows**

- **Immediate** — control frames and life‑safety commands; TTL: seconds.
    
- **Short** — tactical telemetry and reservations; TTL: minutes.
    
- **Medium** — session metadata and short logs; TTL: hours.
    
- **Long** — archival records and non‑urgent logs; TTL: days/weeks.
    
- **Persistent** — ledger‑anchored records; TTL governed by ledger retention policy.
    

**Usage rules**

- Every record **MUST** include a `FreshnessClass` and a `created` timestamp.
    
- Receivers **MUST** downgrade confidence when `created` is older than the class window and emit an `AuditEvent` when acting on stale records.
    
- Profiles may define narrower windows for domain‑specific needs; those windows **MUST** be published in the DRE profile registry.
    

### 7 Minimal L1 header hooks (reference for RFC‑2350)

**Locked minimal header fields (order and sizes):**

- **FrameType** (1 byte) — control/data/beacon/emergency.
    
- **QoSClass** (1 byte) — numeric priority mapping.
    
- **FreshnessTag** (1 byte) — maps to `FreshnessClass`.
    
- **ProvenancePointer** (varint) — compact pointer form.
    
- **TLVContainerLength** (varint) + **TLVContainer** (bytes).
    
- **CompactAuthTag** (varint + bytes) — MAC or short signature.
    

**Parsing rules**

- If `ProvenancePointer` present, treat frame as **provisional** until verification.
    
- TLV container **MUST** be parsed only after minimal header validation; unknown TLVs skipped.
    
- Receivers **MUST** log unknown TLVs for audit and may report them to indexers.
    

### 8 Canonical record skeletons (appendix entries)

Add these canonical skeletons to RFC‑2300 Appendix so downstream RFCs can reference them. Each skeleton includes provenance and freshness blocks.

**LocationChainRecord**

json

```
{
  "uuid_s7":"<uuid-s7>",
  "location_chain":"MCRC:ALPHAFLEET:DONNAGER",
  "authority_weight": 90,
  "provenance": {"pointer":"DRE1:9f3a7b:20260326T1631Z","signer":"authority://mcrc","signature":"..."},
  "freshness":{"created":"2026-03-26T16:31Z","class":"Short","confidence":0.92}
}
```

**ServiceChainRecord**

json

```
{
  "service_chain":"ENGINEERING:ENG-1:Reactor",
  "service_descriptor_pointer":"DRE1:ab12cd:20260326T1600Z",
  "namespace_weight": 40,
  "freshness":{"created":"2026-03-26T16:00Z","class":"Medium","confidence":0.85}
}
```

**FreshnessBlock**

json

```
{"created":"2026-03-26T16:31Z","freshness_class":"Short","confidence_score":0.92}
```

**ProvenanceBlock**

json

```
{"provenance_pointer":"DRE1:9f3a7b:20260326T1631Z","signer_id":"authority://mcrc","signature":"..."}
```

Include canonical CBOR encodings for these skeletons in the appendix (CBOR hex examples provided in profile RFCs).

### 9 Canonical examples (illustrative wire bytes and decoded payloads)

**1. Tightbeam Reservation request (decoded CBOR)**

json

```
{
  "action":"reserve",
  "beam_caps":["optical-10mrad"],
  "power_budget_w":1200,
  "start":"2026-03-26T16:40Z",
  "end":"2026-03-26T16:45Z",
  "provenance":"DRE1:9f3a7b:20260326T1631Z"
}
```

**Header hex (illustrative):** `02 05 02 8F 03 20 07 ... <TLV payload> ... 40 AB CD` _(FrameType=0x02, QoSClass=0x05, FreshnessTag=0x02, ProvenancePointer varint, TLV container length, TLV payload, CompactAuthTag)_

**2. ProxBeacon TLV payload (decoded)**

json

```
{"ProxID":"0x1f2a","ServiceCaps":["filePush"],"TTL":8,"TrustHint":"unverified"}
```

**Wire bytes (illustrative):** `1F 2A 01 08 00`

> Note: these hex examples are illustrative; canonical CBOR and compact encodings for each profile are published in the profile RFCs and the schema repository.

### 10 Test vectors and validation scenarios (appendix)

Add the following test vectors to the RFC‑2300 test appendix and reference them from RFC‑2309:

**Grammar tests**

- Valid: `MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG-1:Reactor`
    
- Invalid: missing `//`, multiple `//`, malformed components.
    
- Normalization: case insensitivity and redundant separator stripping.
    

**Freshness tests**

- Record created at `T0` with `Short` class; at `T0 + 2×ShortWindow` receiver must downgrade confidence and emit `AuditEvent`.
    

**ProvenancePointer tests**

- Pointer resolves to CBOR record and ledger anchor present → final acceptance.
    
- Pointer fetch fails (DRE unreachable) → treat as provisional and reconcile later.
    

**TLV parsing tests**

- Unknown TLV keys are skipped and logged.
    
- TLV container length mismatch triggers `ErrorCode` and `AuditEvent`.
    

**Interoperability scenarios**

- Reservation issued during ledger partition; reconcile after anchor appears.
    
- ProxLink flick with relay escalation: sender obtains `DelegationToken`, relay issues `DelegationReceipt`, final anchor optional.
    

### 11 DRE profile registry requirements (appendix)

**Registry fields (required)**

- `profile` (string) and `version` (semver)
    
- `tlv_keys` (array of `{key, name, description}`)
    
- `schema` (URL to CBOR/JSON schema)
    
- `privacy` (impact statement)
    
- `test_vectors` (URL or embedded examples)
    
- `governance` flags (`life_safety`, `stealth_sensitive`, etc.)
    

**Registration policy**

- Profiles that affect life‑safety or stealth **MUST** include governance signoff and be flagged in the registry.
    
- Registry **MUST** be queryable via `GET /profiles` and `GET /profiles/<name>/v<semver>`.
    
- DREs **MUST** publish supported profile versions in `//info` responses.
    

**Example registry entry**

json

```
{
  "profile":"tightbeam",
  "version":"1.0.0",
  "tlv_keys":[{"key":"0x20","name":"BeamID"},{"key":"0x21","name":"ReservationRef"}],
  "schema":"https://dres.example/profiles/tightbeam/v1/schema.json",
  "privacy":"BeamProfile exposure restricted; default suppression",
  "governance":{"life_safety":true}
}
```

### 12 Operator playbook snippets (appendix)

**Identity anchoring quick flow**

1. Generate UUID‑S7 and DeviceKey.
    
2. Submit NetworkCert request with hardware attestation.
    
3. Wait for LedgerAnchor; operate in UNVERIFIED mode until anchor confirmed.
    
4. Emit `AuditEvent` on anchor receipt.
    

**Provisional receipt reconciliation**

1. On receiving `ProvisionalReceipt`, log locally and mark action provisional.
    
2. Attempt DRE fetch for ProvenancePointer.
    
3. If ledger anchor appears within `provisional_window`, convert to final receipt and emit `AdmissionReceipt`.
    
4. If reconciliation fails before expiry, escalate to operator and emit `PDAuditEvent`.
    

### 13 Migration, compatibility, and governance notes

- RFC‑2300 text is preserved; the additions above are normative appendices. Do not remove or alter the original language without a 24‑month deprecation window and cross‑domain approval.
    
- Legacy aliases (Authority/Namespace) remain supported for interoperability; parsers **SHOULD** normalize to Location/Service internally.
    
- Any change to the canonical address grammar or UUID‑S7 rules requires multi‑party approval and a published migration plan.
    

### 14 Next steps (actionable deliverables referenced from RFC‑2300)

- Publish RFC‑2350 draft (L1 header and TLV container) referencing the TLV rules and minimal header hooks above.
    
- Publish ProvenancePointer and FreshnessClass CBOR schema files in the schema repository and add canonical CBOR examples.
    
- Publish the DRE profile registry schema and register initial profiles (tightbeam v1, proxlink v1, provenance‑pointer).
    
- Add the test vectors above to the L0 test harness and reference them from RFC‑2309.