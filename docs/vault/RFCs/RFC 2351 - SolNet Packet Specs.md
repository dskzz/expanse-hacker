# RFC‑2351: SolNet Packet Architecture & Header Specification

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2351.03.19_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **canonical packet structure** used across SolNet, including:

- the SolNet layered model (NNS → UUID → BAP → DTN)
    
- packet headers at each layer
    
- encapsulation and decapsulation rules
    
- how packets traverse namespace boundaries
    
- security and signature requirements
    

This RFC establishes the **wire format** for all SolNet communication.

---

## 2. SolNet Layer Model

SolNet uses a four‑layer architecture inspired by OSI but adapted for DTN and federated namespaces.

|Layer|Name|Purpose|
|---|---|---|
|**L1**|Local Namespace Layer (NNS)|Local addressing, device/service routing|
|**L2**|Identity & Resolution Layer (UUID + PNS)|Global identity, trust, and resolution|
|**L3**|Inter‑Namespace Transport Layer (BAP)|Bundle headers, custody, TTL, integrity|
|**L4**|Routing & Mobility Layer (DTN)|Ephemeris, mobility hints, routing windows|

Each layer adds its own header. Gateways strip/add layers as packets cross namespace boundaries.

---

## 3. Packet Structure Overview

A SolNet packet is a nested structure:

```
[ Physical Frame ]
    [ NNS Header ]
        [ UUID Header ]
            [ BAP Bundle Header ]
                [ Payload ]
```

Only the **UUID + BAP** layers travel across SolNet. NNS headers are local.

---

## 4. NNS Header (Local Namespace Layer)

The NNS header is used only within a namespace.

### 4.1 Fields

```
Namespace Authority ID
Zone ID
Node ID
Device ID
Service ID
Local Timestamp
Local Signature (optional)
```

### 4.2 Behavior

- MUST be added by the originating device.
    
- MUST be removed by the Zone Gateway before forwarding.
    
- MUST be re‑added by the destination gateway.
    

### 4.3 Example

```
TYC-STATION : OPS_RING : NODE_44 : DEVICE_991 : COMMS
```

---

## 5. UUID Header (Identity & Resolution Layer)

The UUID header is the first globally meaningful layer.

### 5.1 Fields

```
Source UUID
Destination UUID
Public Key Signature
Trust Domain
PNS Resolution Timestamp
```

### 5.2 Behavior

- MUST be preserved end‑to‑end.
    
- MUST be verified by gateways.
    
- MUST NOT be modified except by the originating device.
    

---

## 6. BAP Bundle Header (Inter‑Namespace Transport Layer)

The BAP header defines the DTN bundle.

### 6.1 Fields

```
Bundle Version
Custody Flag
TTL
Hop Count
Payload Length
Payload Integrity Hash
Mobility Hint Block (optional)
Routing Window Block (optional)
Congestion Signal Block (optional)
```

### 6.2 Custody

- Custody MUST be explicitly accepted.
    
- Custody MUST be released on delivery or TTL expiration.
    

### 6.3 Hop Count

Gateways MUST increment hop count.

---

## 7. Mobility & Routing Metadata (DTN Layer)

Optional blocks used by relays and gateways.

### 7.1 Ephemeris Block

Predictable orbital or positional data.

### 7.2 Contact Probability Block

Used by:

- **Tycho Station Mesh**
    
- **Independent Belt Operators**
    
- **Deep‑space research vessels**
    

### 7.3 Relay Preference Block

Indicates preferred relays (e.g., **Mars L4 Relay**).

### 7.4 Congestion Signal Block

Indicates upstream congestion.

---

## 8. Encapsulation Rules

### 8.1 Inside a Namespace

```
NNS → UUID → BAP → Payload
```

### 8.2 Leaving a Namespace

Gateway strips NNS header.

### 8.3 Crossing SolNet

Only UUID + BAP travel.

### 8.4 Entering a New Namespace

Destination gateway adds new NNS header.

---

## 9. Example Packet Walkthrough

A message from **Tycho Station** to **Ceres PublicNet**.

### Step 1 — Device Construction

Tycho device builds:

```
NNS + UUID + BAP + Payload
```

### Step 2 — Tycho Gateway

- strips NNS
    
- verifies UUID signature
    
- forwards UUID+BAP
    

### Step 3 — Mars L4 Relay

- increments hop count
    
- adds mobility metadata
    
- forwards toward Ceres
    

### Step 4 — Ceres L1 Relay

- decapsulates into local NNS
    
- delivers to destination device
    

---

## 10. Security Requirements

Nodes MUST:

- verify UUID signatures
    
- verify BAP integrity hashes
    
- reject unsigned bundles
    
- classify trust domains
    

Nodes SHOULD:

- encrypt payloads
    
- isolate low‑trust traffic
    
- log anomalous routing behavior
    

---

## 11. Error Codes

```
400_BAD_UUID
404_UNRESOLVED
410_EXPIRED_TTL
451_CUSTODY_REFUSED
503_NO_ROUTE_AVAILABLE
```

---

## 12. Summary

RFC‑2351 defines the **canonical packet format** for SolNet. It establishes:

- the SolNet layered model
    
- header structures at each layer
    
- encapsulation rules
    
- routing metadata blocks
    
- security and trust requirements
    

This RFC forms the foundation for all inter‑namespace communication across the Sol system