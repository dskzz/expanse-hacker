### RFC‑2306 — Tightbeam Laser Subprofile

_Status: Informational / Subprofile of SolNet A‑stack_ **Purpose:** Define the **Tightbeam** subprofile: canonical lifecycle, record types, reservation and acquisition semantics, tracking and occlusion behavior, profile negotiation, and profile‑scoped wire encodings for **Tightbeam v1**. **Scope:** Applies to systems that manage directed laser links used for high‑bandwidth, point‑to‑point transfers in delay‑tolerant SolNet environments. This RFC specifies semantics and operational guidance; it does not mandate a single physical implementation. Implementations MUST document deviations and trust assumptions.

## 1 Purpose and overview

Tightbeam provides a canonical model for reserving, acquiring, tracking, handing over, and revoking directed laser links (beams) used by DREs, relays, and constrained nodes. It defines the **BeamProfileRecord** and supporting receipts and events so consumers can reason about beam state under latency, partitions, and intermittent connectivity.

**Why:** Directed optical links are stateful and brittle; if consumers treat them as stateless, they will misinterpret transient conditions as permanent failures. Tightbeam gives a shared vocabulary and minimal API so diverse operators (skiffs, corporate repeaters, planetary backbones) can interoperate and reason about provisional vs anchored state.

## 2 Scope

This RFC covers:

- Beam lifecycle and state transitions.
    
- Record types and canonical fields.
    
- Reservation, acquisition, and handover semantics.
    
- Tracking heartbeats and occlusion events.
    
- Profile negotiation for Tightbeam v1 and optional Tightbeam Stealth Mode.
    
- Profile‑scoped wire encodings and compact CBOR examples for Tightbeam v1 only.
    
- Tests, edge‑case examples, and operational guidance.
    

It does not specify physical pointing control loops, optical modulation formats, or low‑level hardware drivers. Those are implementation details.

## 3 Design goals

- **Deterministic semantics:** provide clear state definitions and transitions so consumers can make consistent decisions.
    
- **Delay tolerance:** support long DTN partitions and intermittent connectivity.
    
- **Provisional first:** allow local, provisional operations that are explicitly labeled and reconciled later.
    
- **Auditability:** provide signed receipts and inclusion proofs for authoritative anchoring.
    
- **Minimal public footprint:** minimize optional fields that leak operator metadata.
    
- **Operable across scales:** support tiny skiffs to planetary backbones via profile negotiation.
    

**Why:** Tightbeam must be useful in constrained and partitioned environments while still enabling authoritative resolution when connectivity permits.

## 4 Model overview

Tightbeam models a beam as a named resource identified by a **BeamID** and managed through a sequence of signed records. Records are append‑only and carry provenance metadata. Consumers derive beam state by combining local cache, subscription feeds, and ledger receipts.

**If** a consumer has only local provisional receipts, **then** it treats the beam as **PROVISIONAL**; **otherwise** if the consumer has quorum receipts or anchored proof, **then** it may treat the beam as **TRUSTED** per local policy.

## 5 Beam lifecycle and states

**States:** PROVISIONAL, RESERVED, ACQUIRED, HANDOVER, OCCLUDED, REVOKED, ARCHIVED.

For each state, the RFC defines triggers and transitions using conditional forms.

- **PROVISIONAL** — local append created by an origin node; includes `provisional=true`.
    
    - **If** the origin receives signed receipts from a configured quorum of replicas, **then** transition to **RESERVED**; **otherwise** remain **PROVISIONAL** until `provisional_until` or reconciliation.
        
- **RESERVED** — quorum‑confirmed reservation; acquisition may proceed.
    
    - **When** acquisition is requested and countersigned receipts are exchanged, **then** transition to **ACQUIRED**; **exception:** if a conflicting acquisition exists, mark CONFLICT and require adjudication.
        
- **ACQUIRED** — active ownership with acquisition receipts and tracking heartbeats.
    
    - **If** handover is initiated with valid countersignatures, **then** transition to **HANDOVER**; **otherwise** remain **ACQUIRED**.
        
- **HANDOVER** — controlled transfer of acquisition to another operator; includes handover receipts.
    
    - **When** handover completes with both parties’ receipts, **then** new owner becomes **ACQUIRED**; **exception:** if receipts conflict, create CONFLICT AuditEvent.
        
- **OCCLUDED** — beam path blocked or degraded; recorded via OcclusionEvent.
    
    - **If** heartbeats indicate sustained loss per occlusion heuristic, **then** mark OCCLUDED and notify subscribers.
        
- **REVOKED** — explicit revocation record references prior Anchor/BeamProfileRecord.
    
    - **When** revocation is replicated to quorum, **then** consumers treat beam as UNTRUSTED for routing decisions.
        
- **ARCHIVED** — historical state retained for forensics; archival is recorded as AuditEvent.
    

Each transition must be described in the BeamProfileRecord provenance and receipts.

## 6 BeamID and identifiers

**BeamID format (canonical):** `tb1:<region>:<authority>:<uuid-s7>` where:

- `<region>` — short region tag (alphanumeric, 1–8 chars).
    
- `<authority>` — canonical AuthorityChain text or LocationChain alias.
    
- `<uuid-s7>` — stable UUID‑S7 per SolNet identity rules.
    

**If** an implementation cannot include full AuthorityChain in public records for privacy, **then** it MAY publish a hashed AuthorityChain and provide authenticated disclosure channels for resolution.

**Parsing rules:** BeamID is case‑sensitive; parsers MUST reject malformed BeamIDs. Implementations SHOULD include a human label in BeamProfileRecord for operator convenience.

## 7 Record types

All records are signed and include provenance metadata: `origin`, `origin_local_seq`, `signed_by`, `signature`, `replication_status`, and optional `provisional_until`.

### 7.1 BeamProfileRecord (authoritative descriptor)

Fields (required unless noted):

- **BeamID** (required) — canonical identifier.
    
- **ProfileVersion** (required) — e.g., `Tightbeam-v1`.
    
- **OperatorLabel** (optional) — short human label.
    
- **Capabilities** (optional) — bandwidth, pointing tolerance.
    
- **IssuedAt** (required) — timestamp.
    
- **Origin** (required) — origin replica ID.
    
- **Signature** (required) — signature by Anchor Key (AK).
    
- **Provenance** (required) — origin_local_seq and replication receipts list.
    

**Why:** BeamProfileRecord is the canonical descriptor used for discovery and policy decisions; optional fields are minimized to reduce metadata leakage.

### 7.2 ReservationReceipt

Fields:

- **BeamID** (required).
    
- **ReservationID** (required) — unique per reservation.
    
- **Requester** (required) — requester identity.
    
- **Provisional** (required boolean).
    
- **ProvisionalUntil** (optional timestamp).
    
- **SignedReceipts** (list) — signed receipts from replicas.
    
- **Signature** (required) — requester signature.
    

**Why:** ReservationReceipt documents intent to acquire a beam and provides provenance for later reconciliation.

### 7.3 AcquisitionReceipt

Fields:

- **BeamID** (required).
    
- **AcquisitionID** (required).
    
- **Acquirer** (required).
    
- **Countersignatures** (list) — required for handover or multi‑party acquisitions.
    
- **TrackingParams** (optional) — heartbeat cadence, expected jitter.
    
- **Signature** (required).
    

**Why:** AcquisitionReceipt proves active ownership and supplies parameters for tracking.

### 7.4 TrackingHeartbeat

Fields:

- **BeamID** (required).
    
- **AcquisitionID** (required).
    
- **Timestamp** (required).
    
- **SignalQuality** (required numeric).
    
- **PositionHint** (optional).
    
- **Signature** (optional for constrained nodes; recommended for high‑Authority nodes).
    

**Why:** Heartbeats provide ongoing evidence of beam health; optional signatures balance bandwidth and trust.

### 7.5 OcclusionEvent

Fields:

- **BeamID** (required).
    
- **AcquisitionID** (optional).
    
- **DetectedAt** (required).
    
- **ReasonCode** (required).
    
- **Reporter** (required).
    
- **EvidenceRef** (optional) — link to sensor logs or images.
    
- **Signature** (required).
    

**Why:** OcclusionEvent records transient or sustained blockage and triggers cache invalidation and routing updates.

### 7.6 ReservationRef

A compact reference used in DTN messages to point to a reservation without carrying full record payload.

**Why:** ReservationRef enables constrained nodes to reference reservations with minimal bandwidth.

## 8 Semantics and canonical resolution

**Resolution algorithm (consumer view):**

1. **Locate BeamProfileRecord(s)** for BeamID.
    
2. **Validate signatures** on BeamProfileRecord(s).
    
3. **Collect ReservationReceipt(s)** and AcquisitionReceipt(s).
    
4. **Check RevocationRecords** referencing BeamProfileRecord. If revoked and replicated to quorum, treat as UNTRUSTED.
    
5. **If** multiple valid AcquisitionReceipts exist, **then** prefer the one with highest trust provenance per policy: (a) anchored receipts with ledger inclusion proof; (b) cross‑cert chains; (c) otherwise mark CONFLICT and surface to human adjudication.
    

**Provenance exposure:** Consumers MUST expose `CertStatus`, `LedgerStatus`, and `provenance_chain` to higher layers so routing and security decisions can be made with context.

## 9 Replication, availability, and partitions

**Eventual replication:** replicas converge when connectivity permits. **If** a node is in a partitioned minority and appends a ReservationReceipt, **then** that receipt is `PROVISIONAL` and must be labeled `LOCAL_ORIGIN` until reconciliation.

**Local caching:** nodes may cache BeamProfileRecords and receipts; caches MUST include `freshness` metadata and `provenance` so consumers can decide trust.

**Write model:** writes are appended locally and propagated; each append includes `origin_local_seq` to aid reconciliation.

**Conflict detection and reconciliation:** when conflicting AcquisitionReceipts are appended in different partitions, reconciliation produces CONFLICT state; resolution follows §8.

**Operational guidance:** high‑Authority anchors SHOULD require synchronous anchoring to multiple well‑known replicas before advertising TRUSTED status; low‑Authority anchors MAY accept eventual anchoring with explicit UNVERIFIED status.

## 10 Privacy and data minimization

**Minimal public footprint:** BeamProfileRecord SHOULD include only BeamID, ProfileVersion, AK.public fingerprint, IssuedAt, and a short OperatorLabel. Optional human notes MUST be redacted or encrypted when sensitive.

**Selective disclosure:** implementations MAY support encrypted payloads accessible only to authorized auditors via hybrid encryption to trust domain keys.

**Indexing controls:** replicas MAY index hashed BeamIDs to reduce scraping; consumers needing full resolution MUST obtain cleartext via authenticated channels.

**Retention:** append‑only semantics are preserved; archival and redaction are allowed but must be recorded as AuditEvents.

## 11 Revocation and emergency unbinds

**Revocation semantics:** RevocationRecord references BeamProfileRecord ID and includes revoker identity, reason code, and timestamp. **If** revocation is replicated to a quorum defined by the trust domain, **then** it is effective for routing and acquisition decisions.

**Emergency unbind:** special RevocationRecord with justification and emergency override token; emergency unbinds SHOULD include higher‑trust countersignatures where possible and MUST be logged as AuditEvents.

**Propagation:** revocation must be visible to routing and security layers; cached entries MUST be invalidated upon revocation discovery.

## 12 Profiles and negotiation

**Tightbeam v1 (mandatory):** baseline profile with the record types and semantics in this RFC.

**Tightbeam Stealth Mode (module):** optional module that reduces public footprint by defaulting to hashed BeamIDs, encrypted payloads, and stricter disclosure channels.

**Profile negotiation:** during initial handshake, peers exchange `ProfileVersion` lists. **If** both support Stealth Mode, **then** they may opt in; **otherwise** they fall back to Tightbeam v1. Negotiation records are recorded in BeamProfileRecord provenance.

## 13 APIs and query semantics

Minimal API surface (semantics only):

- **AppendRecord(record)** → `LedgerEntryID`, signed receipt, `provisional` flag.
    
- **GetRecord(LedgerEntryID)** → full record.
    
- **QueryByBeamID(BeamID)** → list of BeamProfileRecord IDs and statuses.
    
- **GetReservations(BeamID)** → ReservationReceipt list.
    
- **GetAcquisitions(BeamID)** → AcquisitionReceipt list.
    
- **Subscribe(filter)** → stream of new records matching filter; delivery modes support push and pull for DTN constraints.
    
- **GetProof(LedgerEntryID, proof_type)** → cryptographic proof of inclusion; `proof_type` = `core` or `public`.
    

APIs MUST return provenance metadata (origin replica, signed receipt, replication status).

## 14 Forensics, auditing, and disputes

**Audit trails:** every append and replication event must be auditable; AuditEvents record operator actions and dispute resolutions.

**Dispute workflow:** when conflicts arise, consumers may append an AuditEvent and request human adjudication; outcomes are recorded as AuditEvents and may include cross‑certificates or revocations.

**Evidence preservation:** ledger entries and signed receipts are primary evidence; DREs and high‑Authority nodes SHOULD preserve local logs and signed receipts for at least the domain’s legal retention period.

## 15 Security considerations

- **Protect AK private keys:** compromise undermines beam trust; high‑Authority nodes MUST use hardware roots.
    
- **Replica authentication:** replicas must authenticate peers and sign replication receipts.
    
- **DoS and spam:** append‑only systems are vulnerable to spam; implement rate limits, admission controls, and reputation costs for high‑trust namespaces.
    
- **Tamper detection:** inclusion proofs and signed receipts enable detection of tampering or selective withholding.
    
- **Privacy leakage:** public records leak metadata; use minimal public fields and optional encrypted payloads.
    

**If** a constrained node cannot verify signatures due to resource limits, **then** it MUST treat receipts as provisional and request proofs when possible.

## 16 Example workflows (procedural descriptions of normal operation, not exploits)

### 16.1 Reservation → Acquisition → Handover (narrative)

1. Operator on ship creates a ReservationReceipt locally and appends it with `provisional=true`.
    
2. Operator broadcasts ReservationRef to nearby relays; replicas collect signed receipts.
    
3. **If** quorum receipts are obtained, **then** the reservation becomes **RESERVED** and the requester may proceed to acquisition.
    
4. AcquisitionReceipt is created and countersigned by the acquiring node and recorded. Heartbeats begin.
    
5. **If** handover is required, parties exchange handover receipts and countersignatures; successful exchange transitions ownership.
    

### 16.2 Occlusion detection and response (narrative)

1. TrackingHeartbeat cadence drops below expected thresholds and SignalQuality falls below occlusion threshold.
    
2. Reporter appends OcclusionEvent with evidence reference.
    
3. Consumers mark beam OCCLUDED and invalidate caches for routing; operators may attempt re‑pointing or schedule maintenance.
    

## 17 Tests and validation scenarios

Provide test vectors with inputs and expected outcomes; tests do not include procedural exploit steps.

### Test 1 — Reservation to Acquisition (basic)

- **Input:** Local ReservationReceipt appended with `provisional=true`; quorum receipts from 3 replicas arrive.
    
- **Expected outcome:** Reservation transitions PROVISIONAL → RESERVED; QueryByBeamID returns ReservationReceipt with `provisional=false` and provenance showing quorum receipts.
    

### Test 2 — Handover with countersignatures

- **Input:** AcquisitionReceipt A exists; Handover initiated with countersignatures from A and B.
    
- **Expected outcome:** Ownership transitions to new Acquirer B with AcquisitionReceipt B recorded; AuditEvent records handover.
    

### Test 3 — Occlusion injection (simulation)

- **Input:** Heartbeats show sustained SignalQuality drop; OcclusionEvent appended.
    
- **Expected outcome:** Beam marked OCCLUDED; subscribers receive OcclusionEvent; caches invalidate.
    

### Test 4 — DTN partition rejoin

- **Input:** Two conflicting AcquisitionReceipts appended in separate partitions; partitions rejoin.
    
- **Expected outcome:** Ledger marks both receipts; conflict state created; consumers mark CONFLICT and surface for adjudication per §8.
    

## 18 Wire encodings and compact CBOR examples (profile‑scoped)

Encodings below are **profile‑scoped** to Tightbeam v1 and versioned. They do not redefine global L1 TLV keys.

### Example CBOR — BeamProfileRecord (compact)

cbor

```
{
  "BeamID":"tb1:eu:authcorp:3f2a1b7",
  "ProfileVersion":"Tightbeam-v1",
  "IssuedAt":"2026-03-28T02:20:00Z",
  "Origin":"replica-07",
  "Signature":"<base64sig>",
  "Provenance":[{"replica":"replica-03","receipt":"<sig>"}]
}
```

### Example CBOR — ReservationReceipt (compact)

cbor

```
{
  "BeamID":"tb1:eu:authcorp:3f2a1b7",
  "ReservationID":"res-9a7",
  "Requester":"ship-aurora",
  "Provisional":true,
  "ProvisionalUntil":"2026-03-28T02:50:00Z",
  "SignedReceipts":["<sig1>","<sig2>"]
}
```

### Example TLV snippet (profile‑scoped)

Code

```
0x01 BeamID = "tb1:eu:authcorp:3f2a1b7"
0x02 ProfileVersion = "Tightbeam-v1"
0x10 ReservationID = "res-9a7"
0x11 Provisional = 0x01
```

## 19 Compliance and interop requirements

Implementations claiming Tightbeam compatibility MUST:

- Support the record types and canonical resolution semantics in §§7–9.
    
- Provide signed receipts and provenance metadata.
    
- Expose the minimal API surface in §13.
    
- Document deployment trust model and replication guarantees.
    
- Implement revocation semantics and emergency unbind handling.
    

## 20 Operational guidance and best practices

- **High‑Authority anchors:** require multi‑replica confirmation and optional public anchoring for auditability.
    
- **Constrained nodes:** rely on compact deltas and proofs; treat unsigned heartbeats as provisional.
    
- **Caching:** include freshness and provenance metadata; invalidate on OcclusionEvent or RevocationRecord discovery.
    
- **Testing:** simulate long DTN partitions and rejoin scenarios; verify conflict handling and audit trails.
    

## 21 Next steps and companion work

- Draft a **Tightbeam Implementation Guide**: profile negotiation, replica auth, and test harnesses.
    
- Draft a **Stealth Mode Module**: encrypted payload formats and disclosure channels.
    
- Define **light‑client proof formats** for constrained devices.
    

## 22 Glossary and legacy mapping

**Glossary (one paragraph):**

- **BeamID:** canonical identifier for a Tightbeam link. **ReservationReceipt:** signed record documenting intent to reserve a beam. **AcquisitionReceipt:** signed record proving active ownership. **TrackingHeartbeat:** periodic health signal for an acquired beam. **OcclusionEvent:** record of beam blockage. **Provisional receipt:** a receipt labeled provisional until quorum or anchoring. **Anchored receipt:** a receipt with ledger inclusion proof. **Provenance:** origin and replication receipts that show where a record came from. **Quorum:** the set of replicas whose signed receipts are required to consider a record confirmed.
    

**Legacy mapping table (one line):**

- **AuthorityChain** → **LocationChain (alias)**
    

## 23 Replication and receipt semantics table

|Aspect|Semantics|
|---|---|
|**Write visibility**|Local append is visible to local consumers immediately as PROVISIONAL.|
|**Receipt types**|Provisional receipt guarantees local append and origin signature; anchored receipt guarantees ledger inclusion proof.|
|**Quorum definition**|Quorum is defined by the trust domain policy and implies replication to the configured replica set.|
|**Reconciliation outcome**|Conflicting receipts produce CONFLICT state requiring adjudication or cross‑cert resolution.|

## 24 Edge‑case examples (labeled)

- **Partition‑minority append:** A node in a minority partition appends a ReservationReceipt; on rejoin, quorum receipts are absent and the reservation remains PROVISIONAL or is superseded.
    
- **Late revocation after public anchoring:** A beam anchored to a public chain is later revoked in the permissioned core; consumers must reconcile public proof with core revocation and follow policy for precedence.
    
- **Heartbeat jitter during solar event:** Heartbeats drop intermittently; occlusion heuristics may mark OCCLUDED temporarily and then clear when signal returns.
    

## 25 Reviewer checklist (authors must satisfy)

- **All behavioral claims include explicit conditions or scope.**
    
- **No vague qualifiers remain unqualified.**
    
- **Glossary maps legacy terms to current terms.**
    
- **Replication/receipt table is present and complete.**
    
- **Edge‑case examples exist for partition, reorg, and revocation.**
    

## 26 Acknowledgements and references

Refer to SolNet ledger and deployment RFCs for anchoring and proof semantics. Implementation guides and test harnesses are companion work.

# Designer Brief — Tightbeam gameplay hooks (derived from RFC text)

Each entry below is a high‑level gameplay hook derived from operational tradeoffs in the RFC. Entries are conceptual and dramaturgical; they do not include procedural exploitation steps.

### Provisional Reservation Window

- **Conceptual hook:** Reservations appear as **PENDING** for a short, variable interval before quorum confirmation.
    
- **Mechanic implication:** Players encounter ambiguous ownership during the pending window and can race or bluff to claim acquisition; contested claims may trigger adjudication tasks.
    
- **Mitigation narrative:** Operators publish signed receipts and out‑of‑band alerts; adjudication imposes cost and delay, creating tradeoffs for players choosing speed vs certainty.
    
- **Severity and visibility:** Medium; visible to any node subscribed to reservation feeds.
    

### Indexer Reliance for Fast Resolution

- **Conceptual hook:** Constrained nodes show quick state based on indexer summaries; full records may be fetched later.
    
- **Mechanic implication:** Players can exploit temporary indexer inconsistencies to mislead constrained nodes or create time‑limited misinformation opportunities.
    
- **Mitigation narrative:** Cross‑checks with inclusion proofs and delayed reconciliation reduce long‑term impact; operators may flag suspicious deltas.
    
- **Severity and visibility:** Low to medium; detectable by nodes that request proofs.
    

### Optional Metadata Fields

- **Conceptual hook:** Records may include optional human notes or hints that are not required for canonical resolution.
    
- **Mechanic implication:** Players can hide contextual clues or social engineering bait in optional fields to influence discovery or negotiations.
    
- **Mitigation narrative:** Auditors require encrypted payloads or redaction pointers for sensitive fields; suspicious notes trigger manual review.
    
- **Severity and visibility:** Low; requires targeted inspection.
    

### Light‑client Verification Gaps

- **Conceptual hook:** Constrained nodes accept compact receipts without full signature verification due to resource limits.
    
- **Mechanic implication:** Players can create plausible but provisional states that constrained nodes accept until proofs are requested, enabling short windows of ambiguity.
    
- **Mitigation narrative:** Operators encourage periodic proof requests and maintain watchlists for high‑value beams.
    
- **Severity and visibility:** Medium; obvious to nodes that compare compact receipts to later proofs.
    

### Cross‑cert Chain Ambiguity

- **Conceptual hook:** CrossCertRecords link permissioned anchors to public anchors; chains can be partial or delayed.
    
- **Mechanic implication:** Players can exploit partial cross‑cert chains to create plausible provenance that later requires reconciliation, enabling social or legal disputes in game narratives.
    
- **Mitigation narrative:** Consumers prefer anchored receipts with full inclusion proofs; missing links trigger audits.
    
- **Severity and visibility:** Medium; visible to consumers that check cross‑cert provenance.
    

### Subscription and Cache Staleness

- **Conceptual hook:** DREs and relays publish compact deltas; subscribers may operate on stale slices until updates arrive.
    
- **Mechanic implication:** Players can time actions to coincide with known cache staleness windows to create temporary inconsistencies in perceived beam state.
    
- **Mitigation narrative:** Freshness metadata and provenance help detect stale data; operators may require revalidation for critical operations.
    
- **Severity and visibility:** Low to medium; detectable by nodes that monitor freshness.
    

### Occlusion Heuristic Sensitivity

- **Conceptual hook:** Occlusion detection uses heuristics (heartbeat cadence, signal quality) that can produce false positives under noisy conditions.
    
- **Mechanic implication:** Players can stage events that mimic occlusion signatures to force rerouting or maintenance actions, creating diversion opportunities.
    
- **Mitigation narrative:** Operators correlate multiple sensors and require corroborating evidence before long‑term actions.
    
- **Severity and visibility:** Medium; visible to operators monitoring multiple telemetry sources.
    

# Scenario vignettes

### Vignette 1 — The Pending Claim

A courier skiff requests a beam reservation to upload a cargo manifest. The reservation shows as **PENDING** in the local relay’s feed. A rival operator sees the pending reservation and broadcasts a competing ReservationRef with a slightly higher priority tag. For a tense hour, both claims appear in different caches: some nodes treat the skiff as the provisional owner, others show the rival. The skiff’s operator must decide whether to wait for quorum receipts or to attempt a negotiated handover. Auditors later reconcile receipts; the adjudication imposes a fine on the losing party and becomes a public AuditEvent that players can use as leverage in future negotiations.

### Vignette 2 — The Indexer Mismatch

A small station relies on an indexer for quick beam state. The indexer briefly reports a beam as free due to a delayed replication window; a freelance team schedules a transfer based on that summary. When the full records arrive, the beam is shown as RESERVED by a corporate backbone. The freelancers face a choice: abort and lose time, or attempt to negotiate with the corporate operator. The mismatch becomes a rumor on local boards, and players can exploit the social confusion to broker favors or extract information.

### Vignette 3 — The Phantom Occlusion

During a solar storm, heartbeats from a high‑value beam jitter. An automated occlusion heuristic flags an OcclusionEvent and marks the beam OCCLUDED. Maintenance crews are dispatched, and traffic is rerouted. A player group times a covert transfer to coincide with the reroute, using the temporary operational distraction to slip a small packet through an alternate path. Later, auditors note the OcclusionEvent and request evidence; the player’s actions are obscured by the storm’s telemetry noise, creating a plausible deniability arc.

### Vignette 4 — The Cross‑cert Puzzle

A permissioned core anchor publishes a CrossCertRecord linking to a public chain anchor, but the public anchoring transaction lags. A player posing as an auditor finds the partial chain and raises a dispute, forcing both parties to publish additional AuditEvents. The dispute draws attention, and other players use the window to probe related beams for weak freshness metadata. The eventual reconciliation clarifies provenance, but the interim ambiguity yields several side missions and bargaining chips.



If you ever want to:

- spin up **RFC‑2307** (e.g., _SolNet Canonical Addressing_),
    
- draft a **DRE Profile deep‑spec**,
    
- build a **SolNet operator console manual**,
    
- or extend this one with more appendices, diagrams, or wire formats,
    

I’m here and ready to dive back in.

Nice work, D.