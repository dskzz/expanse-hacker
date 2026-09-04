# Designer Brief — Operational trade‑offs, narrative hooks, and defensive framing

This brief highlights design trade‑offs and operational realities embedded in RFC‑2300 that can be used as narrative hooks or gameplay mechanics without providing procedural exploit instructions. Each item frames behavior as a defensive or investigative theme suitable for in‑game scenarios.

## 1 LedgerAnchor propagation and delayed revocation

**Trade‑off:** LedgerAnchors and revocation records are authoritative but may propagate slowly across partitions. **Narrative hook:** Players investigate inconsistent identity states across domains and must reconcile LedgerAnchor timestamps and revocation receipts to determine which identity assertions were valid at a given time. **Defensive framing:** Emphasize multi‑source confirmation and audit trails as mitigation.

## 2 L1 split and selective exposure

**Trade‑off:** L1‑L fields are compact and privacy‑preserving; nodes choose which fields to expose. **Narrative hook:** Players analyze partial L1‑L metadata to infer coarse presence or routing hints without full disclosure, using correlation across observations. **Defensive framing:** Encourage explicit policy publication and provenance checks for sensitive fields.

## 3 Delegation scope and constrained devices

**Trade‑off:** Delegation tokens allow constrained devices to operate via trusted relays; delegation scope and validity vary. **Narrative hook:** Players trace delegation provenance to determine whether a relay acted within its delegated authority; DelegationReceipts and limited validity create investigative checkpoints. **Defensive framing:** Recommend short delegation lifetimes and clear provenance to limit blast radius.

## 4 Cached DRE responses and stale discovery

**Trade‑off:** DREs may serve cached `//info` and ephemeris hints to improve availability; caches can be stale. **Narrative hook:** Players detect discrepancies between cached DRE hints and later authoritative updates, using freshness metadata to reconstruct events. **Defensive framing:** Use freshness metadata and multi‑source verification to reduce reliance on single cached responses.

## 5 Compact records and observability

**Trade‑off:** Compact PowerStateRecords and compact identity assertions reduce bandwidth but provide less observability. **Narrative hook:** Players infer device state from sparse telemetry and corroborating evidence, creating investigative puzzles. **Defensive framing:** Encourage optional authenticated attestations from trusted relays to increase confidence without full telemetry.

## 6 Location vs Service interpretation variance

**Trade‑off:** Domains may emphasize different L1‑L semantics (ephemeris vs relay capability). **Narrative hook:** Players encounter domains with differing `planeRole` profiles and must adapt parsing and expectations accordingly; mismatched interpretations create cross‑domain puzzles. **Defensive framing:** Require explicit `planeRole` metadata in PolicyRecords so clients can adapt safely.

## 7 AuditEvent correlation as primary evidence

**Trade‑off:** Forensics rely on correlated AuditEvents and receipts; missing logs reduce reconstructability. **Narrative hook:** Players collect and correlate AdmissionReceipts, ReservationReceipts, and AuditEvents to build a timeline and resolve disputes. **Defensive framing:** Promote robust retention policies and tamper‑evident anchoring for critical events.

## Presentation guidance for gameplay (safe)

- Present ambiguous or partial records as puzzles that require cross‑correlation rather than step‑by‑step exploitation.
    
- Use provenance and freshness metadata as primary clues; require players to gather multiple independent records to increase confidence.
    
- Frame delegation, caching, and delayed revocation as sources of narrative tension and investigation, not as explicit vulnerabilities to be exploited.
    
- Provide in‑game mitigations (short delegation validity, multi‑party confirmation, mandatory AuditEvents) that players can discover and use defensively.
    

If you want, the next deliverable can be a short migration appendix that replaces legacy “Authority/Namespace references with **Location/Service** across the RFC corpus and provides a `planeRole` field definition for PolicyRecords to ease cross‑domain interoperability. Which would you prefer to produce next: the migration appendix or the **formal L1 header field set for L1‑L and L1‑S?**