
# RFC‑2303 — Physical Media & Propagation

_SolNet Standards Working Group (SSWG)_  
_Status: Informational / Foundational_

## 1 Purpose

This document defines how SolNet’s physical links, relays, couriers, and assorted improvised transmission paths are expected to behave. The goal is to keep data moving—ledger entries, proofs, messages—across a network that spends most of its life partitioned, delayed, or otherwise uncooperative. Everything here exists so higher layers can make sense of what they receive, even when the underlying transport is a patchwork of high‑bandwidth fiber, narrowband radio, and the occasional storage drive taped to a bulkhead.  The goal is simple: no matter how chaotic the transport layer gets, the ledger and messages riding on top of it should remain consistent and traceable.

## 2 Scope

These rules apply to anything that moves SolNet data: radio links, optical links, point‑to‑point relays, store‑and‑forward relays, scheduled couriers (physical or logical), bridge anchors to external chains, and constrained devices. This RFC doesn’t dictate modulation schemes or hardware — trying to standardize Belter skiff radios and Martian Navy optics in one document would be a fool’s errand. Instead, it defines the metadata and behaviors required so wildly different transports can still interoperate.


## 3 Design Goals

- **Reliable eventual delivery:** Data should reach its destination once connectivity exists, even if that takes longer than anyone would prefer.
    
- **Predictable behavior under delay:** Long delays and partitions are normal. Systems must behave consistently when they occur.
    
- **Forensic traceability:** Every hop, receipt, and custody transfer should leave a trail that investigators can follow.
    
- **Resource awareness:** Constrained devices must participate without exhausting storage or power.
    
- **Interoperability:** Different transports must expose enough metadata for routing and replication to make informed decisions.
    
- **Operational transparency:** Systems must clearly indicate when data is provisional versus confirmed.
    

## 4 Model Overview and Rationale

SolNet’s propagation model is built around **store‑and‑forward relays**, **scheduled couriers**, and **opportunistic links**. Every transmitted object — ledger entry, proof, message — carries provenance and freshness metadata so receivers can judge whether it’s new, stale, or replayed.

This model exists because continuous connectivity is a luxury. Ships drift out of alignment, stations lose power, and bureaucracies forget to renew maintenance contracts. By making propagation semantics explicit, applications can treat provisional state cautiously, auditors can reconstruct timelines, and routing systems can choose between “fast,” “cheap,” and “available” with their eyes open.
## 5 Terminology

- **Replica:** A node storing authoritative ledger state.
    
- **Relay:** A node that forwards and buffers data.
    
- **Courier:** A scheduled physical or logical transport  (e.g., ship carrying storage, scheduled burst link).
    
- **Provisional:** A state indicating an entry is accepted locally but not yet fully replicated.
    
- **Confirmed:** A state indicating replication criteria have been met.
    
- **Inclusion proof:** Cryptographic evidence that a ledger entry is included in a specific ledger state.
    
- **Receipt:** A signed acknowledgment of acceptance for propagation.
    
- **Freshness metadata:** Timestamps and sequence numbers used to detect staleness.
    

## 6 Physical Media and Link Metadata

SolNet runs across a zoo of physical links. Each link must publish metadata so routing and replication can make sane decisions.

- **High‑bandwidth terrestrial links:** Low latency, high throughput, ideal for bulk replication.
	- Preferred for bulk replication and public anchoring where cost permits. Link metadata: nominal latency, bandwidth class, reliability estimate, authentication policy.
    
- **Line‑of‑sight optical/microwave:** Moderate latency and variable availability.
	- Variable availability due to pointing and weather; suitable for scheduled bursts and regional replication. Link metadata: scheduled windows, pointing constraints, outage model.
    
- **Long‑haul radio/deep‑space links:** High latency, low throughput, intermittent.   
	- Require robust store‑and‑forward, compression, and explicit custody metadata. Link metadata: expected delay distribution, duty cycle, and custody requirements.

- **Couriered storage:** Extremely high latency but high capacity.
	- Used for archival transfers, bulk ledger synchronization, and out‑of‑band proofs. Link metadata: manifest acceptance policy, custody chain requirements.
    
- **Constrained local links:** Low bandwidth and intermittent, requiring compact proofs.
	- Require compact proofs and selective synchronization. Link metadata: device class, storage limits, preferred proof formats.
    
Every link must publish latency, bandwidth class, reliability, scheduled windows, and authentication policy. Without this, routing becomes guesswork, and guesswork gets people killed — or worse, desynchronized.

## 7 Propagation Semantics and Guarantees

Propagation rules keep the network coherent even when half of it is asleep or out of range.

- **Best‑effort delivery with eventual convergence:** The network forwards data as it can. Replicas converge once connectivity returns. Implementations must detect and reconcile divergent states — pretending partitions don’t happen won’t make them go away.
    
- **Ordered delivery for ledger replication:** Ledger replication must include ordering (previous‑hash, sequence numbers, etc.) so consumers can reconstruct append order. Non‑ledger messages may relax ordering if the application doesn’t care.
    
- **Receipts and provenance:** Every accepted record must produce a signed receipt with origin, receiving node, sequence, and timestamp. These receipts are the backbone of forensic reconstruction.
    
- **Provisional vs. confirmed:** Local appends and early receipts create provisional state. Replication criteria promote entries to confirmed. Consumers must be able to query this status.
    
- **Duplicate suppression:** Relays must detect duplicates via LedgerEntryID or content hash.
    
- **Reordering and reconciliation:** Partitioned appends will reorder. Reconciliation must produce explicit conflict states and preserve all conflicting records.
    

These rules let higher layers reason about trust even when the physical layer is behaving like a Belter skiff held together with tape and optimism.

## 8 Store‑and‑Forward Relay Behavior

Relays are the workhorses of SolNet. They buffer, forward, authenticate, and occasionally save the day.

- **Admission controls:** Relays may enforce rate limits, fees, or reputation checks.
    
- **Buffer management:** Storage is finite. Evictions must be logged as AuditEvents.
    
- **Forwarding:** Relays should forward based on link metadata and schedules. Batching and compression are allowed.
    
- **Authenticated peering:** All peers must be authenticated to prevent spoofing.
    
- **Indexing:** Relays may maintain advisory indices, but these are not authoritative.
    
- **Proof propagation:** Relays must forward inclusion proofs so constrained devices can verify without full replication.

Relays keep data moving when direct paths don’t exist — which is most of the time.

## 9 Courier and Scheduled Transfer Semantics

Couriers are SolNet’s slow but reliable backbone — the “if it absolutely has to get there eventually” option.

- **Manifests:** Couriers must carry signed manifests listing LedgerEntryIDs, sizes, and receipts.
- **Chunking:** Large transfers should be chunked with resumable semantics.    
- **Delay and ordering:** Couriered data is valid but may be stale; freshness metadata must be included.    
- **Out‑of‑band proofs:** Couriers may carry inclusion proofs or public‑chain commitments.    
- **Chain of custody:** Sensitive transfers should include custody AuditEvents.    

Couriers shine when radio is too slow, too expensive, or too jammed to be useful.

## 10 Constrained Devices and Light Clients

Constrained devices — skiffs, wrist terminals, embedded controllers — need special handling.

- **Selective sync:** They should subscribe to filtered streams, not full replication.
    
- **Compact proofs:** They must verify inclusion via compact proofs and request multiple proofs for high‑risk actions.
    
- **Provisional handling:** Provisional receipts are advisory; critical actions require confirmation.
    
- **Receipt caching:** Devices should cache receipts for offline verification.
    
- **Delegated verification:** Heavy verification may be delegated, but provenance must be recorded.
    

These rules let small devices participate without pretending they’re full replicas.

## 11 Indexing, Derived Metadata, and Query Semantics

Indices make the network usable, but they’re not authoritative.

- **Authoritative vs. derived:** authoritative records are ledger entries; indices and derived metadata are advisory. Implementations MUST clearly label derived metadata and avoid treating it as authoritative.
- **Index update semantics:** indices MAY be updated asynchronously; consumers MUST not assume immediate consistency between indices and authoritative records.
    
- **Query APIs:** replicas and relays SHOULD expose query APIs that return both authoritative records and derived index entries, with provenance metadata for each result.
    
- **Rate limiting and access control:** index queries MUST be subject to rate limits and access controls to prevent scraping and privacy leakage.

Indices help performance, but **provenance prevents accidental trust in stale or poisoned data**.

## 12 Bridge Anchoring and Public Commitments

Some deployments anchor ledger commitments to public chains.

- **Anchor commitments:** replicas MAY publish compact commitments (hashes, Merkle roots) to public chains; such commitments are additional provenance but do not replace internal replication criteria.
    
- **Reorg handling:** consumers MUST account for public chain reorg windows; bridge operators SHOULD publish reorg alerts and maintain cross‑signatures to reduce ambiguity.
    
- **Bridge receipts:** bridges MUST provide signed receipts linking internal LedgerEntryIDs to public commitments and include timestamps and origin metadata.
    
- **Delay and finality:** public chain finality semantics differ; systems MUST treat public anchoring as supplementary evidence and define how it affects CONFIRMED status.
    
Bridges add global tamper evidence but bring their own timing headaches.
    

## 13 Freshness, Replay Protection, and Monotonicity

Freshness metadata helps detect stale or replayed data — once it’s anchored by confirmation.
- **Monotonic sequence numbers:** originators and replicas MUST include monotonic sequence numbers or timestamps to aid replay detection.
    
- **Freshness windows:** implementations SHOULD define freshness windows for receipts and proofs; consumers MAY reject receipts older than policy thresholds unless revalidated.
    
- **Replay handling:** relays and replicas MUST detect and log replayed records; replayed records MUST not silently overwrite newer authoritative state.
    
- **Canonicalization:** canonical forms for records MUST be defined so identical content yields identical LedgerEntryIDs and hashes.
    
These measures keep old data from sneaking back into circulation.
    

## 14 Security Considerations

Propagation security relies on layered defenses.
- **Authenticated transport and peering:** all relay and replica peering MUST use authenticated channels and signed receipts to prevent spoofing.
    
- **Admission controls:** relays SHOULD implement rate limits, reputation checks, or economic costs to mitigate spam and DoS.
    
- **Encrypted payloads and metadata:** sensitive payloads SHOULD be encrypted; routing metadata SHOULD be minimized.
    
- **Proof diversity:** constrained clients and critical services SHOULD require multiple independent proofs for high‑impact decisions to reduce single‑point deception.
    
- **Chain of custody and audit:** manifests, receipts, and custody records MUST be preserved to support dispute resolution.
Security depends on receipts, provenance, and not trusting any single source too much.

## 15 Operational Workflows

### ## 15.1 Ledger replication via scheduled bursts

Ledger replication starts when an originator appends an **AnchorRecord** to its local ledger. The originator immediately receives a **local receipt**, which is the system’s way of saying “yes, you wrote something, and no, we’re not promising anyone else has seen it yet.” This local append is the beginning of **PROVISIONAL** state.

Once the record exists locally, the originator forwards it to a nearby relay. “Nearby” is relative — sometimes it’s a fiber hop, sometimes it’s a microwave link across a station hull, and sometimes it’s a Belter skiff whose antenna alignment depends on whether the pilot remembered to tighten the bolts. The relay authenticates the sender, verifies the record, and issues a **relay acceptance receipt**. This receipt proves the relay took custody of the record and is now responsible for forwarding it.

The relay then places the record into its outbound queue for the next **scheduled burst** toward core replicas. These bursts are timed windows where the relay fires off buffered data across higher‑bandwidth or higher‑reliability links. Operators like to pretend these windows are predictable; in practice, they slip whenever someone forgets to maintain a dish, a Martian power grid throttles non‑military traffic, or a solar storm decides to ruin everyone’s day.

When the burst finally goes out, core replicas receive the record. Each replica verifies the signatures, checks the ordering constraints (previous‑hash, sequence numbers, or whatever the domain uses), and appends the entry to its authoritative ledger. After doing so, each replica issues a **replication receipt**, which flows back toward the originator through whatever relays happen to be awake and aligned.

Once the originator collects enough replication receipts to satisfy its domain’s **replication criteria** — quorum, cross‑signatures, or public‑chain inclusion — the entry transitions from **PROVISIONAL** to **CONFIRMED**. At that point, higher‑level systems can treat the entry as canonical, and operators can stop worrying about whether the record is floating around in some relay’s backlog.

**Metadata produced:**

- Local origin receipt
    
- Relay acceptance receipt
    
- Core replication receipts
    
- Inclusion proof (once replicas generate it)
    

## 15.2 Couriered bulk synchronization

Bulk synchronization is the fallback for when radio bandwidth is too scarce, too expensive, or too unreliable to move large volumes of data. This happens more often than anyone admits — especially in outer‑belt operations where “bandwidth planning” means hoping the antenna doesn’t ice over.

A node preparing for courier transfer assembles a **signed manifest** listing all LedgerEntryIDs being transported, along with their sizes and provenance receipts. This manifest is the receiving node’s lifeline; without it, there’s no way to verify whether the courier delivered the correct data or swapped a storage brick with something they found in a salvage yard.

The courier — physical or logical — transports the storage medium to its destination. Physical couriers range from corporate transports with redundant shielding to independent Belter pilots who swear their ship “only leaks a little.” Logical couriers are scheduled burst windows or high‑latency deep‑space relays that behave like physical couriers in everything but name.

Upon arrival, the receiving node verifies the manifest signatures, checks the receipts, and imports the entries into its local ledger. Each imported entry generates an **import receipt**, confirming that the destination has accepted and appended the data. This is the moment when the receiving node’s ledger finally catches up with whatever the originator was doing weeks or months earlier.

To maintain a trustworthy chain of custody, the destination publishes an **AuditEvent** documenting the import, including any custody transfers that occurred along the way. This is especially important when the courier route crosses multiple jurisdictions or when the courier is a freelancer with a reputation for “creative routing.”

**Metadata produced:**

- Signed manifest
    
- Per‑chunk receipts (for resumable transfers)
    
- Import receipts
    
- Custody‑related AuditEvents
    

## 15.3 Light‑client verification for constrained devices

Constrained devices — skiffs, wrist terminals, embedded controllers — rarely have the storage or compute to act as full replicas. They live on intermittent power, unreliable links, and whatever bandwidth they can scavenge from nearby relays. When they need to verify a ledger entry, they request **compact inclusion proofs** from at least two independent relays. This redundancy is essential; trusting a single relay is how you end up with a skiff that thinks it owns docking rights it never actually had.

The device verifies the proofs locally, checks the attached receipts, and evaluates the **freshness metadata** to ensure it isn’t being fed stale or replayed state. Freshness metadata is advisory until confirmed, but it still helps the device avoid obviously outdated information — especially when the relay providing it is running on a battery that’s older than the pilot.

For any action with real consequences — financial transfers, access control changes, or anything that might get someone spaced — the device must obtain additional confirmation from a trusted **Directory & Routing Endpoint (DRE)** or equivalent authority. This extra step ensures that even if one relay is compromised or misconfigured, the device won’t act on bad data.

**Metadata produced:**

- Compact inclusion proofs
    
- Relay receipts
    
- Freshness timestamps

## 16 Privacy and Data Minimization

- Only propagate metadata needed for routing and verification; avoid human labels or sensitive fields in public propagation unless encrypted. 
- Provide authenticated channels for sensitive data.    
- Use hashed indices to reduce casual scraping.
    
Privacy is always a balancing act against auditability.
    

## 17 Compliance Requirements

Implementations must:

- Publish link metadata and schedules.    
- Produce signed receipts.    
- Support inclusion proof propagation.    
- Implement monotonic sequence numbers.    
- Document admission controls and replication criteria.    

These requirements keep the network predictable across wildly different transports.
    

## 18 Forensics and Dispute Resolution

- Receipts and manifests must be preserved.    
- Relays and couriers must log significant actions.    
- Disputes must be recorded as AuditEvents and may require revalidation or human adjudication.
    
Forensics depend on consistent provenance and custody records.

## 19 Next Steps

- RFC‑2361: Layer Model integration.    
- RFC‑2304: Relay and Courier Operations.    
- RFC‑2363: Identity Resolution.    
- Implementation guides for manifests, chunking, and compact proofs.

## 20 Operator Checklist (Non‑Normative)

- Publish link metadata.    
- Define replication criteria.    
- Enforce admission controls.    
- Preserve receipts and custody logs.    
- Require multiple proofs for high‑impact actions.
## Appendix: How freshness metadata becomes trustworthy

Freshness metadata—timestamps, sequence numbers, monotonic counters—serves two purposes:
- It lets a receiver _estimate_ whether a record is new, stale, or replayed.    
- It gives auditors a timeline to reconstruct propagation.

But none of those fields are inherently reliable. A device can lie about its clock, forge a timestamp, or replay an old sequence number. SolNet handles this by requiring that freshness metadata be **validated indirectly**, through the ledger’s confirmation process.
- A record with “fresh” timestamps but **no confirmation** is still provisional and may be rejected later.
    
- A record with “old” timestamps but **confirmed** status is authoritative and cannot be ignored.
    
- Attackers can manipulate freshness metadata, but they cannot forge confirmation without compromising replicas or trust authorities.
    
- Light clients must cross‑check proofs because they cannot validate freshness metadata on their own.