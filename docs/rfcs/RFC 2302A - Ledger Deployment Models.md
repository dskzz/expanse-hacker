
# RFC‑2302A — Ledger Deployment Models

_SolNet Standards Working Group (SSWG)_ _Status: Informational / Companion to RFC‑2302_

## 1 Purpose

Describe two practical ledger deployment families that satisfy the **LedgerAnchor** semantics in RFC‑2302: a **Permissioned Federation** model (federated BFT-style ledgers) and a **Hybrid Blockchain** model (permissioned core + optional public anchoring and light clients). Both are presented together so implementers can pick, mix, or evolve between them without rewriting policy every time someone invents a new consensus buzzword.

## 2 Scope

Covers architecture, consensus tradeoffs, light‑client support, revocation and emergency flows, partition and reconciliation behavior, privacy controls, APIs, and operational guidance for both models. Does not mandate a single consensus algorithm or storage engine; it maps ledger semantics from RFC‑2302 onto concrete deployment patterns and gives practical recipes for mixed environments (Belter skiff to planetary bureaucracy).

## 3 High‑level summary

- **Permissioned Federation**: small set of known operators run replicas; fast finality, controlled governance, predictable revocation; good for fleets, governments, and corps.
    
- **Hybrid Blockchain**: permissioned core for high‑trust anchors plus optional public chain anchoring for discoverability and tamper evidence; supports light clients and cross‑chain linking; good for mixed ecosystems where openness and privacy must coexist. Both models must provide signed receipts, inclusion proofs, revocation visibility, and light‑client APIs for constrained nodes.
    

## 4 Permissioned Federation Model

### 4.1 Architecture and actors

- **Replica set**: a bounded group of trusted operators (UN fleets, corp nodes, major repeaters).
    
- **Consensus**: BFT or other permissioned consensus with deterministic finality.
    
- **Clients**: DREs, ships, and gateways submit transactions to one or more replicas.
    
- **Indexers**: optional services that build queryable views for constrained nodes.
    

### 4.2 Properties and tradeoffs

- **Finality**: near‑instant and deterministic; no long reorgs.
    
- **Latency**: low for writes and reads within the federation.
    
- **Cost**: operational cost shared among operators; no per‑transaction fees.
    
- **Privacy**: good — replicas can limit public fields and support encrypted payloads.
    
- **Governance**: explicit; operators can enforce admission, rate limits, and dispute resolution.
    

### 4.3 Partition and reconciliation behavior

- **Partition tolerance**: federation prefers availability within a partitioned subset but must mark entries appended in minority partitions as _provisional_ until reconciled.
    
- **Reconciliation**: on rejoin, replicas reconcile via signed receipts and conflict markers; canonicality rules from RFC‑2302 §5 apply.
    
- **Operational rule**: high‑Authority anchors should require multi‑replica confirmation (quorum) before being advertised as TRUSTED.
    

### 4.4 Revocation and emergency unbinds

- **Revocation speed**: fast — a single quorum decision can mark an AnchorRecord revoked and propagate immediately.
    
- **Emergency unbinds**: supported with high‑trust countersignatures; audit trails mandatory.
    

### 4.5 Light clients and constrained nodes

- **Light‑client API**: provide signed inclusion proofs (Merkle or equivalent) and compact receipts.
    
- **Caching**: ships and skiffs cache relevant slices; federation publishes compact deltas for subscribers.
    

### 4.6 When to use this model

- Governmental fleets, corporate backbones, DRE clusters, and any context where a small set of operators can be trusted to run replicas and enforce policy.
    

## 5 Hybrid Blockchain Model

### 5.1 Architecture and actors

- **Permissioned core**: a federation of trusted replicas handles high‑trust anchors and fast revocation.
    
- **Public chain layer**: optional public blockchain where selected AnchorRecords (or summarized commitments) are anchored for global tamper evidence and discoverability.
    
- **Bridges / CrossCertRecords**: signed cross‑certificates link permissioned anchors to public chain transactions.
    
- **Light clients**: SPV or equivalent clients for constrained nodes to verify inclusion proofs without full replication.
    

### 5.2 Properties and tradeoffs

- **Tamper evidence**: public chain provides strong public tamper evidence for anchored records.
    
- **Discoverability**: public anchoring improves global discoverability for independent operators.
    
- **Cost & latency**: public anchoring introduces fees and longer finality; use sparingly for high‑value anchors.
    
- **Privacy**: public chain leaks metadata; mitigate with hashed indices, off‑chain encrypted payloads, or selective disclosure.
    
- **Partition behavior**: public chain cannot easily handle long DTN partitions; permissioned core handles provisional operations.
    

### 5.3 Cross‑chain linking and canonicality

- **CrossCertRecord**: permissioned AK signs a CrossCertRecord that references a public chain transaction ID and proof; ledger consumers treat cross‑certs as strong provenance when validated.
    
- **Canonical mapping**: AnchorRecord in permissioned core includes `public_anchor_ref` when published to the public chain; consumers verify both signatures and inclusion proofs.
    

### 5.4 Revocation and provisional trust

- **Provisional trust**: until public chain finality, consumers may accept permissioned‑core anchors if they have sufficient cross‑signatures or federation quorum.
    
- **Revocation visibility**: permissioned core must publish revocations immediately; public chain revocations are appended as transactions but may lag. Use out‑of‑band alerts (DRE subscriptions) for urgent revocations.
    

### 5.5 Light clients and constrained nodes

- **SPV proofs**: provide compact Merkle proofs for public chain anchors and compact receipts for permissioned core anchors.
    
- **Hybrid verification**: constrained nodes verify permissioned receipts first; if public proof exists, verify that too for extra assurance.
    

### 5.6 When to use this model

- Mixed ecosystems where some actors demand public tamper evidence or global discoverability, but others require fast revocation and privacy controls.
    

## 6 Practical tradeoffs (table)

|Concern|Permissioned Federation|Hybrid Blockchain|
|---|---|---|
|Finality|Fast, deterministic|Fast in core; public finality slower|
|Cost|Operational (no per‑tx fees)|Public chain fees for anchored txs|
|Privacy|High (controlled fields)|Lower unless encrypted/off‑chain|
|Partition tolerance|Better for DTN (with provisional markers)|Core handles partitions; public chain lags|
|Discoverability|Limited to federation|Global via public anchoring|
|Governance|Clear operator control|Mixed; public chain governance adds complexity|

## 7 Interop patterns and APIs

Both models must implement the RFC‑2302 API surface with these extensions:

- **AppendRecord(record, target_replicas[])** → LedgerEntryID, signed receipt, provisional flag.
    
- **GetProof(LedgerEntryID, proof_type)** → inclusion proof; `proof_type` = `core`, `public` (if anchored).
    
- **Subscribe(filter, delivery_mode)** → stream of records and revocations; `delivery_mode` supports push and pull for DTN constraints.
    
- **CrossCertPublish(AnchorRecordID, public_tx_ref)** → CrossCertRecord creation and signed receipt.
    
- **ProvisionalFlag semantics**: receipts include `provisional_until` and `provenance` fields so consumers can decide trust thresholds.
    

Constrained nodes must be able to request **compact deltas** and **light‑client proofs** rather than full records.

## 8 Partition handling and reconciliation rules

- **Local append policy**: nodes may append AnchorRecords locally (e.g., ship creates a provisional anchor) but must mark them `LOCAL_ORIGIN` and `PROVISIONAL`.
    
- **Conflict detection**: on reconnection, replicas exchange signed receipts and apply RFC‑2302 conflict resolution. Conflicts are recorded as AuditEvents and may require human adjudication.
    
- **Grace windows**: define explicit grace windows for provisional anchors (e.g., 24–72 hours) after which unresolved conflicts escalate to CONFLICT state.
    
- **Automated heuristics**: prefer anchors with cross‑cert chains, earlier timestamps, and higher trust provenance; do not silently prefer one textual AuthorityChain over another without anchors and signatures.
    

## 9 Privacy controls and selective disclosure

- **Hashed indices**: store hashed AuthorityChain values in public records; provide authenticated channels to reveal cleartext to authorized consumers.
    
- **Encrypted payloads**: allow AnchorRecords to carry encrypted blobs accessible only to auditors or trust domain keys.
    
- **Redaction pointers**: support redaction metadata recorded as AuditEvents rather than deleting history; redaction must be auditable.
    

## 10 Security considerations (model‑specific)

- **Permissioned federation**: protect replica keys, enforce replica authentication, and guard against insider collusion. Implement admission controls and rate limits to prevent spam.
    
- **Hybrid blockchain**: protect bridge keys and cross‑cert agents; be explicit about how reorgs affect canonicality; avoid relying solely on public chain finality for urgent revocations.
    
- **Both**: AK compromise is catastrophic; require hardware roots for high‑Authority anchors and clear emergency unbind procedures.
    

## 11 Example workflows

### 11.1 Register domain (permissioned federation)

1. Operator generates AK in HR.
    
2. Create AnchorRecord, sign with AK, append to federation replicas.
    
3. Receive signed receipts from quorum; mark anchor as TRUSTED.
    
4. DRE publishes `//info` referencing LedgerEntryID.
    

### 11.2 Register domain with public anchoring (hybrid)

1–3 as above. 4. Submit a compact commitment (hash of AnchorRecord) to public chain as a transaction. 5. Publish CrossCertRecord linking AnchorRecordID ↔ public_tx_ref. 6. Constrained nodes verify either federation receipts or public proof depending on policy.

### 11.3 Revocation during partition

- Node appends RevocationRecord locally and broadcasts; DREs mark anchor as PROVISIONAL_REVOKED until quorum or public confirmation; emergency unbinds use out‑of‑band alerts to speed action.
    

## 12 Operational guidance and best practices

- **High‑Authority anchors**: require multi‑replica confirmation and optional public anchoring for auditability.
    
- **Small operators**: use permissioned federation membership or rely on cross‑certs from trusted operators rather than public chain fees.
    
- **Personal devices**: avoid direct public anchoring; use device assertions signed by domain AK and optional ledger registration only for long‑lived devices.
    
- **DREs**: subscribe to relevant ledger filters and publish compact deltas for ships and skiffs.
    
- **Testing**: simulate long DTN partitions and rejoin scenarios; verify conflict handling and audit trails.
    

## 13 Recommendation

Adopt a **hybrid default**: run a permissioned federation for high‑trust anchors and governance, and offer optional public anchoring for selected records that benefit from global tamper evidence. Provide robust light‑client proofs and out‑of‑band revocation channels so constrained and partitioned nodes can operate safely without waiting for public finality.

## 14 Next steps and companion work

- Draft a **Permissioned Federation Implementation Guide**: replica auth, BFT config, admission controls, and operational runbooks.
    
- Draft a **Hybrid Bridge Spec**: CrossCertRecord formats, bridge security, and reorg handling.
    
- Define **light‑client APIs** and compact proof formats for constrained devices (ships, skiffs, wrist terminals).
    
- Create test suites that simulate DTN partitions, reorgs, and emergency unbinds