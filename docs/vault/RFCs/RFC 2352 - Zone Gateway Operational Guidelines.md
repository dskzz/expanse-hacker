# RFC‑2352: Zone Gateway Operational Guidelines

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2352.03.19_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the operational guidelines for **Zone Gateways**, the boundary nodes responsible for translating between **local Network Namespace Systems (NNS)** and the **SolNet Bundle Addressing Protocol (BAP)**. Zone Gateways ensure that ships, stations, orbitals, and planetary networks can interoperate while maintaining independent administrative control.

Gateways are deployed across major public networks (e.g., **Earth Coalition Networks**, **Martian Congressional Republic Relays**, **Tycho Station Operations Mesh**, **Ceres PublicNet**) as well as independent operators in the Belt.

---

## 2. Role of a Zone Gateway

A Zone Gateway is the authoritative ingress/egress point for a namespace. It performs:

- **NNS → UUID translation**
    
- **UUID → NNS translation**
    
- **BAP encapsulation and decapsulation**
    
- **Custody transfer and DTN queueing**
    
- **Mobility hint processing**
    
- **Policy enforcement**
    
- **Traffic prioritization**
    
- **Authentication and signature verification**
    

Gateways MUST be reachable via at least one predictable contact schedule.

---

## 3. Address Translation

### 3.1 NNS → UUID

Gateways MUST maintain a mapping table for all local NNS elements:

```
<System> : <Zone> : <Node> : <Device> : <Service> → UUID
```

Mappings MUST be stable for the lifetime of the namespace element.

### 3.2 UUID → NNS

Gateways MUST resolve inbound bundles to the correct local NNS address. If the UUID is unknown, the gateway SHOULD return a `404_UNRESOLVED` diagnostic bundle.

---

## 4. BAP Encapsulation

Gateways MUST encapsulate outbound payloads into BAP bundles containing:

- destination UUID
    
- source UUID
    
- custody flags
    
- mobility hints
    
- TTL
    
- payload integrity signature
    

Gateways MUST validate all inbound BAP bundles before delivery.

---

## 5. Mobility Hint Handling

Gateways SHOULD interpret mobility hints to optimize routing. Examples:

- **Earth Coalition Networks** publish predictable relay windows.
    
- **Martian Deep‑Space Relays** provide ephemeris‑based contact schedules.
    
- **Tycho Station Mesh** publishes opportunistic contact probabilities.
    
- **Independent Belt Operators** may provide only coarse mobility metadata.
    

Gateways MUST NOT discard bundles solely due to missing mobility hints.

---

## 6. Queueing & Custody Transfer

Gateways MUST implement DTN queueing with:

- priority classes (critical, operational, routine)
    
- custody transfer rules
    
- congestion backoff
    
- bundle expiration
    

Gateways SHOULD support persistent storage for long‑delay scenarios (e.g., deep‑space research vessels).

---

## 7. Security Requirements

Gateways MUST:

- verify signatures on inbound bundles
    
- sign outbound bundles
    
- authenticate local NNS nodes
    
- enforce namespace‑specific policies
    

Gateways SHOULD:

- isolate untrusted traffic
    
- rate‑limit unknown sources
    
- log anomalous routing behavior
    

---

## 8. Failure Modes & Recovery

Gateways MUST support:

- offline queueing
    
- degraded routing (fallback to minimal mobility hints)
    
- local delivery when external links are unavailable
    

Gateways SHOULD:

- broadcast status changes to neighboring gateways
    
- maintain redundant contact schedules
    

---

## 9. Example Flow

A message from **Tycho Station** to a device on **Ceres PublicNet**:

1. Tycho device sends to local NNS address.
    
2. Tycho Gateway resolves NNS → UUID.
    
3. Gateway encapsulates payload into BAP.
    
4. Bundle forwarded to Mars L4 Relay.
    
5. Mars L4 Relay forwards to Ceres L1.
    
6. Ceres Gateway unwraps bundle.
    
7. UUID → NNS mapping performed.
    
8. Message delivered to target device.
    

---

## 10. Summary

Zone Gateways are the backbone of SolNet interoperability. They:

- translate between local namespaces and global UUIDs
    
- encapsulate and route bundles across SolNet
    
- enforce routing, security, and mobility policies
    
- ensure independent networks remain reachable
    

Gateways MUST implement the guidelines in this document to ensure reliable, secure, and predictable inter‑namespace communication across the Sol system.