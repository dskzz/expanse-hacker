# RFC‑2350: SolNet Foundational Architecture (Revised Edition)

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2350.03.19 (Updated 2357.03.19)_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **foundational architecture of SolNet**, incorporating updates from RFC‑2351 through RFC‑2357. It establishes the core conceptual model used by all subsequent standards:

- Network Namespace System (NNS)
    
- Universal Identifiers (UUIDs)
    
- Bundle Addressing Protocol (BAP)
    
- Zone Gateways
    
- Personal Naming Service (PNS)
    
- Delay‑Tolerant Networking (DTN) routing
    
- Trust domains and mobility metadata
    

This revision supersedes earlier drafts to ensure consistency across the standards corpus.

---

## 2. Architectural Overview

SolNet is a **federated, delay‑tolerant, multi‑authority network** spanning the Sol system. It connects:

- **Earth Coalition Networks**
    
- **Martian Congressional Republic Relays**
    
- **Tycho Station Operations Mesh**
    
- **Ceres PublicNet**
    
- **Luna Relay Authority**
    
- **Ganymede AgriNet**
    
- **Independent Belt Operators**
    
- **Deep‑space research vessels**
    

SolNet does **not** impose central governance. Instead, it defines interoperable layers that allow autonomous networks to communicate.

---

## 3. Core Components

### 3.1 Network Namespace System (NNS)

Each network defines its own hierarchical namespace:

```
<System> : <Zone> : <Node> : <Device> : <Service>
```

Examples:

- `TYC-STATION : OPS_RING : NODE_44 : DEVICE_991 : COMMS`
    
- `CERES-PUBLICNET : DOCK_A : TERMINAL_12 : USER_004`
    

NNS is **local** and **not globally unique**.

### 3.2 Universal Identifiers (UUIDs)

Every NNS element maps to a UUID. UUIDs are:

- globally unique
    
- stable for the lifetime of the element
    
- used for inter‑namespace routing
    

### 3.3 Bundle Addressing Protocol (BAP)

The inter‑namespace transport layer. BAP bundles contain:

- source UUID
    
- destination UUID
    
- custody flags
    
- mobility hints
    
- TTL
    
- payload signature
    

### 3.4 Zone Gateways

Defined in RFC‑2352. Gateways:

- translate NNS ↔ UUID
    
- encapsulate/decapsulate BAP bundles
    
- enforce routing and security policy
    
- publish mobility metadata
    
- serve as ingress/egress for namespaces
    

### 3.5 Personal Naming Service (PNS)

Defined in RFC‑2357. PNS maps:

```
PNS Label → Public Key → Current NNS Address
```

PNS is distributed via gossip and caching.

### 3.6 DTN Routing Layer

Defined in RFC‑2354. Routing uses:

- ephemeris
    
- mobility hints
    
- custody transfer
    
- opportunistic forwarding
    
- routing windows
    

---

## 4. Layered Model

SolNet follows a **four‑layer architecture**:

### **Layer 1 — Local Namespace Layer (NNS)**

Human‑readable, local addressing.

### **Layer 2 — Identity & Resolution Layer (PNS + UUID)**

Maps people and devices to routable identifiers.

### **Layer 3 — Inter‑Namespace Transport Layer (BAP)**

Encapsulates payloads for DTN routing.

### **Layer 4 — Routing & Mobility Layer (DTN)**

Moves bundles across the solar system.

---

## 5. Example End‑to‑End Flow

A user on **Tycho Station** sends a message to a friend on **Ceres PublicNet**.

### Step 1 — Identity Resolution

Tycho device resolves:

```
friend.name@pns → Public Key → CERES-PUBLICNET : DOCK_A : DEVICE_991
```

### Step 2 — NNS → UUID

Tycho Gateway maps the NNS address to a UUID.

### Step 3 — BAP Encapsulation

Gateway wraps payload into a BAP bundle.

### Step 4 — DTN Routing

Likely path:

- Tycho → Mars L4 Relay
    
- Mars L4 → Ceres L1 Relay
    
- Ceres L1 → Ceres PublicNet
    

### Step 5 — UUID → NNS

Ceres Gateway unwraps and delivers to the local NNS address.

---

## 6. Trust Domains

SolNet recognizes four trust levels:

- **HIGH** — Earth, Mars, Luna
    
- **MEDIUM** — Tycho, Ganymede, Ceres
    
- **LOW** — independent operators
    
- **UNKNOWN** — unverified sources
    

Trust domains influence:

- routing preference
    
- PNS propagation
    
- signature validation requirements
    

---

## 7. Mobility Metadata

Nodes SHOULD publish mobility hints:

- predictable ephemeris (Earth–Mars relays)
    
- semi‑predictable schedules (Tycho shuttles)
    
- opportunistic contacts (Belt haulers)
    
- static positions (Ceres PublicNet)
    

Mobility metadata improves routing efficiency.

---

## 8. Security Model

SolNet security is based on:

- public‑key signatures
    
- gateway authentication
    
- PNS update signing
    
- bundle integrity verification
    
- trust‑domain classification
    

Gateways MUST reject unsigned or invalid bundles.

---

## 9. Design Principles

SolNet is built on:

- **Federation** — independent networks retain autonomy.
    
- **Resilience** — DTN routing tolerates outages and delays.
    
- **Discoverability** — PNS ensures identity resolution.
    
- **Interoperability** — gateways translate between namespaces.
    
- **Security** — signatures and trust domains protect the network.
    

---

## 10. Summary

This revised RFC‑2350 defines the unified architectural model for SolNet. It incorporates the standards and clarifications introduced in RFC‑2351 through RFC‑2357, ensuring:

- consistent terminology
    
- aligned responsibilities across layers
    
- coherent routing and identity behavior
    
- compatibility across all SolNet participants
    

This document serves as the authoritative foundation for all future SolNet standards.