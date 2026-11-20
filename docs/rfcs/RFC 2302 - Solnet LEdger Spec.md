# RFC‑2302 — SolNet Ledger Specification

_SolNet Standards Working Group (SSWG)_ _Status: Informational / Foundational_

## 1 Purpose

Define the **LedgerAnchor**: a slow, append‑only, replicated registry that records authoritative bindings between **AuthorityChain**, **UUID‑S7**, and public keys; records revocations and audit events; and provides the canonical source of global uniqueness for SolNet. This RFC describes ledger semantics, entry types, replication and conflict rules, privacy tradeoffs, and a pragmatic API surface suitable for everything from a pirate skiff to a planetary bureaucracy.

## 2 Scope

Covers conceptual ledger design and operational rules required by other SolNet RFCs (notably RFC‑2350 and RFC‑2361). This is _not_ a prescription for a single implementation: multiple ledger technologies and trust models are acceptable so long as they meet the properties below. Wire formats, consensus algorithms, and storage engines are left to implementers and later companion RFCs.

## 3 Design Goals (what the ledger must actually do)

- **Authoritative uniqueness:** provide a durable, auditable record that a given UUID‑S7 is bound to a specific AuthorityChain and Anchor Key.
    
- **Append‑only auditability:** every change is recorded; history is preserved for forensics.
    
- **Practical replication:** tolerate high latency, partitioning, and intermittent connectivity.
    
- **Conflict clarity:** when two parties claim the same textual AuthorityChain, ledger entries and signatures determine canonical identity.
    
- **Privacy‑aware:** minimize leakage of sensitive metadata while preserving auditability.
    
- **Operable by anyone:** support centralized, federated, and permissioned deployments so a Belter skiff and a corporate backbone can both participate.
    
- **Revocation first class:** revocations must be discoverable and actionable by routing and security layers.
    

## 4 Ledger Model Overview

The ledger is a **replicated, append‑only log** of signed records. Each record is a self‑contained, signed object with a stable identifier (LedgerEntryID). Records are immutable once appended. Implementations may use blockchains, distributed logs, or federated append‑only stores; the spec cares about semantics, not the underlying consensus.

### 4.1 Record types

- **AnchorRecord** — binds `UUID‑S7 ↔ AuthorityChain ↔ AK.public` and includes metadata (human label, jurisdiction tags, issuance timestamp, optional human note). Signed by AK.
    
- **RevocationRecord** — marks an AnchorRecord as revoked; includes reason code, revoker identity, and timestamp. Signed by revoking authority (AK or recognized trust authority).
    
- **CrossCertRecord** — records cross‑signatures between anchors (useful for migration and key rotation). Signed by both parties.
    
- **AuditEvent** — operator actions, emergency unbinds, dispute notes. Signed by issuer.
    
- **PolicyRecord** — domain or trust‑domain policy statements (e.g., acceptable AK algorithms, emergency procedures). Signed by trust domain authority.
    
- **IndexRecord** — optional, implementation‑specific indexing aids (not authoritative).
    

Each record includes a **previous‑hash** or equivalent pointer to preserve append‑only ordering and enable tamper detection.

## 5 Semantics and Canonical Resolution

When resolving an AuthorityChain textually, consumers follow this order:

1. **Find AnchorRecord(s)** for the AuthorityChain and UUID‑S7.
    
2. **Validate signatures** on AnchorRecord(s) against the claimed AK.public.
    
3. **Check RevocationRecords** referencing those AnchorRecords. If revoked, treat as UNVERIFIED unless a valid cross‑cert or emergency override exists.
    
4. **If multiple valid AnchorRecords exist** (conflict), prefer the one with the highest trust provenance: (a) AnchorRecord signed by a recognized trust authority and anchored earliest in ledger history; (b) AnchorRecord with explicit cross‑cert chains; (c) otherwise, require human adjudication and mark as CONFLICT.
    
5. **Expose resolution metadata** (CertStatus, LedgerStatus, provenance chain) to A‑stack consumers.
    

Implementations must make conflict states explicit; silent acceptance of conflicting anchors is forbidden.

## 6 Replication, Availability, and Partitions

- **Eventual replication:** ledger replicas converge when connectivity permits. The system tolerates long partitions (days to weeks) but must provide clear semantics for operations performed during partitions.
    
- **Local caching:** nodes may cache ledger slices relevant to their operational sphere (e.g., a ship caches anchors for its frequent contacts). Cache TTLs and freshness indicators must be present.
    
- **Write model:** writes are appended locally and propagated; the ledger must record the local origin and a monotonic local sequence to aid reconciliation.
    
- **Conflict detection:** when two conflicting AnchorRecords are appended in different partitions, reconciliation produces a conflict state; conflict resolution follows the Canonical Resolution rules in §5.
    
- **Operational guidance:** for high‑Authority nodes, prefer synchronous anchoring to multiple well‑known replicas before advertising anchor trust; for low‑Authority or opportunistic anchors, allow eventual anchoring with explicit UNVERIFIED status until ledger confirmation.
    

## 7 Privacy and Data Minimization

Ledger entries are public by design for auditability, but SolNet must balance transparency with operator privacy.

- **Minimal public footprint:** AnchorRecords SHOULD include only essential fields: UUID‑S7, AuthorityChain canonical text, AK.public fingerprint, issuance timestamp, and a short human label. Optional human notes must be redacted or encrypted if sensitive.
    
- **Selective disclosure:** implementations MAY support encrypted payloads in records accessible only to authorized auditors (e.g., via hybrid encryption to trust domain keys).
    
- **Indexing controls:** replicas may choose to index only hashed AuthorityChain values to reduce casual scraping; however, any consumer that needs full resolution must be able to obtain the cleartext via authenticated channels.
    
- **Retention policy:** ledger is append‑only, but archival strategies (cold storage, redaction pointers) are allowed for legal compliance; redaction must be auditable and recorded as an AuditEvent.
    

## 8 Revocation and Emergency Unbinds

- **Revocation semantics:** a RevocationRecord references the AnchorRecord ID and includes revoker identity, reason code, and timestamp. Revocation is effective once replicated to a quorum of replicas defined by the trust domain.
    
- **Emergency unbind:** a special RevocationRecord type that includes justification metadata and an emergency override token. Emergency unbinds must be logged as AuditEvents and require higher‑trust countersignatures where possible.
    
- **Propagation:** revocation must be visible to routing and security layers; DREs and relays must check revocation status for anchors they rely on. Cached entries must be invalidated upon revocation discovery.
    

## 9 Trust Models and Deployment Modes

The ledger spec supports multiple deployment models:

- **Permissioned federation:** trusted operators run replicas; consensus via BFT or similar. Suited for intergovernmental or corporate backbones.
    
- **Permissionless append‑only:** open participation with economic or reputation incentives; suitable for community or public registries.
    
- **Hybrid:** core permissioned replicas for high‑trust anchors and peripheral opportunistic replicas for caching.
    
- **Local ledgers:** small domains may run local ledgers for internal anchors and optionally publish summarized AnchorRecords to global ledgers.
    

Each deployment must document its trust assumptions and advertise them via PolicyRecords.

## 10 APIs and Query Semantics

Ledger implementations SHOULD expose a minimal, consistent API:

- `AppendRecord(record)` → LedgerEntryID, signed receipt.
    
- `GetRecord(LedgerEntryID)` → full record.
    
- `QueryByUUID(UUID‑S7)` → list of AnchorRecord IDs and statuses.
    
- `QueryByAuthorityChain(text)` → list of AnchorRecord IDs and statuses.
    
- `GetRevocations(AnchorRecordID)` → RevocationRecords.
    
- `Subscribe(filter)` → stream of new records matching filter (for DREs and relays).
    
- `GetProof(LedgerEntryID)` → cryptographic proof of inclusion and ordering (e.g., Merkle proof or equivalent).
    

APIs must return provenance metadata (origin replica, signed receipt, replication status) so consumers can make informed trust decisions.

## 11 Forensics, Auditing, and Disputes

- **Audit trails:** every append and every replication event must be auditable; AuditEvents record operator actions and dispute resolutions.
    
- **Dispute workflow:** when conflicts arise, ledger consumers may open a dispute by appending an AuditEvent and requesting human adjudication; dispute outcomes are recorded as AuditEvents and may include cross‑certificates or revocations.
    
- **Evidence preservation:** ledger entries and signed receipts are primary evidence; DREs and high‑Authority nodes SHOULD preserve local logs and signed receipts for at least the domain’s legal retention period.
    

## 12 Security Considerations

- **Protect AK private keys:** compromise of AK undermines anchor trust; high‑Authority nodes MUST use hardware roots.
    
- **Replica authentication:** replicas must authenticate peers and sign replication receipts to prevent spoofing.
    
- **DoS and spam:** append‑only systems are vulnerable to spam; implement rate limits, economic or reputation costs, and admission controls for high‑trust namespaces.
    
- **Tamper detection:** inclusion proofs and signed receipts enable detection of tampering or selective withholding by replicas.
    
- **Privacy leakage:** public ledgers leak metadata; use minimal public fields and optional encrypted payloads for sensitive data.
    

## 13 Example Workflows

- **Anchor creation:** operator generates AK → creates AnchorRecord → signs and appends → receives signed receipt → publishes `//info` referencing LedgerEntryID. Until replication to quorum, AnchorRecord is provisional and consumers mark it as PENDING.
    
- **Rotation:** new AK created → CrossCertRecord appended linking old AK to new AK → AnchorRecord for new AK appended → old AK marked with deprecation AuditEvent → after grace period, old AK may be revoked.
    
- **Conflict reconciliation:** two AnchorRecords for same AuthorityChain discovered → ledger marks both and creates CONFLICT state → trust domains publish PolicyRecords and AuditEvents to resolve; consumers treat both as UNVERIFIED until resolution.
    

## 14 Compliance and Interop Requirements

Implementations claiming SolNet Ledger compatibility MUST:

- support the record types and canonical resolution semantics in §4–§5;
    
- provide cryptographic inclusion proofs for entries;
    
- expose the minimal API surface in §10;
    
- document deployment trust model and replication guarantees;
    
- implement revocation semantics and emergency unbind handling.
    

## 15 Operational Guidance and Best Practices

- **High‑Authority anchors:** anchor to multiple well‑known replicas and require multi‑replica confirmation before advertising trust.
    
- **Personal devices:** avoid writing AnchorRecords for transient personal devices; prefer device assertions signed by domain AK and optional ledger registration only for long‑lived devices.
    
- **Caching:** DREs should cache relevant ledger slices and subscribe to updates; caches must include freshness metadata.
    
- **Disaster recovery:** maintain off‑site archival copies of ledger history and signed receipts.
    

## 16 Next Steps and Companion RFCs

- **RFC‑2361 (Layer Model)** will reference ledger semantics for A‑stack interactions.
    
- **RFC‑2363 (Identity Resolution)** will define how L2 consumes ledger entries and resolves conflicts.
    
- **Implementation RFCs** may specify concrete consensus and storage options for permissioned and permissionless deployments.