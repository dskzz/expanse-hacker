# RFC‑2353: Independent Network Best Practices

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2353.03.19_  
_Status: Informational / Advisory_

---

## 1. Purpose

This document provides **best‑practice recommendations** for operators of **independent, non‑federated, or minimally aligned networks** within the SolNet ecosystem. These networks include:

- privately administered Belt mesh deployments
    
- autonomous shipboard networks
    
- small‑station public nets
    
- research vessel networks
    
- temporary expeditionary networks
    
- commercial or industrial subnetworks (e.g., Ganymede AgriNet)
    

The goal is to ensure **maximum interoperability** with major coalition networks (e.g., **Earth Coalition Networks**, **Martian Congressional Republic Relays**, **Tycho Station Operations Mesh**) while preserving full administrative independence.

---

## 2. Scope

This RFC applies to any network that:

- does **not** participate in a major SolNet administrative authority
    
- maintains its own internal NNS structure
    
- operates one or more Zone Gateways
    
- wishes to remain reachable and discoverable across SolNet
    

This RFC is **non‑binding** but strongly recommended.

---

## 3. Namespace Design

### 3.1 Prefixing

Independent networks SHOULD use a clear, unambiguous prefix such as:

- `IND-<NAME>`
    
- `OPS-<VESSEL>`
    
- `OUTPOST-<ID>`
    

Examples:

- `IND-CALICOHAULER`
    
- `OPS-KUIPERRESEARCH`
    
- `OUTPOST-47-BELT`
    

### 3.2 Stability

Namespace elements SHOULD remain stable for the lifetime of the system. Renaming SHOULD be avoided unless operationally necessary.

### 3.3 Collision Avoidance

Operators SHOULD check for known namespace collisions via:

- public SolNet registries
    
- PNS gossip caches
    
- neighboring gateway announcements
    

---

## 4. Gateway Requirements

Independent networks MUST operate at least one **Zone Gateway** implementing:

- NNS ↔ UUID translation
    
- BAP encapsulation
    
- custody transfer
    
- mobility hint publication
    
- signature verification
    

Gateways SHOULD:

- maintain predictable contact schedules
    
- publish ephemeris when applicable
    
- support opportunistic forwarding
    

---

## 5. Mobility Metadata

Independent operators SHOULD publish mobility hints appropriate to their movement profile.

Examples:

- **Ice haulers**: predictable long‑haul trajectories
    
- **Survey vessels**: semi‑predictable arcs with periodic station stops
    
- **Small Belt stations**: static position with intermittent power cycles
    
- **Research craft**: deep‑space drift with scheduled telemetry windows
    

Mobility metadata improves routing efficiency across SolNet.

---

## 6. PNS Participation

Independent networks SHOULD:

- run a local PNS resolver
    
- gossip PNS updates to neighboring networks
    
- accept inbound PNS queries
    
- maintain TTL and staleness rules
    

Participation ensures that users remain discoverable even when disconnected from major hubs.

---

## 7. Routing Hygiene

Independent operators SHOULD:

- avoid excessive rebroadcasting
    
- implement congestion backoff
    
- respect TTLs
    
- avoid forwarding bundles with invalid signatures
    
- maintain accurate local clocks (within reasonable drift)
    

Operators MUST NOT:

- modify bundle payloads
    
- forge mobility hints
    
- impersonate other namespaces
    

---

## 8. Security Practices

Independent networks SHOULD:

- sign all outbound bundles
    
- verify all inbound signatures
    
- isolate untrusted traffic
    
- maintain secure key storage
    
- rotate gateway credentials periodically
    

Operators MAY:

- implement additional local encryption layers
    
- restrict inbound traffic to known authorities
    

---

## 9. Example Deployment

A small independent Belt station (`OUTPOST-47-BELT`) implements:

- a single Zone Gateway with limited storage
    
- predictable contact windows with **Ceres PublicNet**
    
- opportunistic forwarding to passing haulers
    
- a lightweight PNS resolver
    
- namespace prefix `OUTPOST-47-BELT` for all internal nodes
    

This configuration ensures:

- discoverability across SolNet
    
- reliable message delivery despite intermittent connectivity
    
- minimal administrative overhead
    

---

## 10. Summary

Independent networks are a vital part of SolNet’s diversity and resilience. By following the best practices in this document, operators can:

- maintain full autonomy
    
- remain interoperable with major networks
    
- ensure reliable routing
    
- avoid namespace collisions
    
- contribute to the overall health of SolNet
    

These guidelines are strongly recommended for all non‑federated or minimally aligned operators throughout the Sol system.