# RFC‑2357: Inter‑Namespace Gateway Protocol (INGP)

_SolNet Standards Working Group (SSWG)_ _Revision Date: 2357.03.19_ _Status: Informational / Non‑Binding_

---

## 1. Overview

This document defines the **Inter‑Namespace Gateway Protocol (INGP)**, the mechanism by which independent Network Namespace Systems (NNS) communicate across SolNet. INGP provides:

- translation between **local NNS addresses** and **global UUIDs**
    
- encapsulation of traffic into **Bundle Addressing Protocol (BAP)** envelopes
    
- routing across **multiple autonomous namespaces**
    
- delivery into the destination namespace
    

Namespaces remain fully independent—politically, administratively, and technically—while still interoperating through a universal addressing substrate.

---

## 2. Architectural Model

SolNet is a **federated, delay‑tolerant network** composed of many independent namespaces:

- ships
    
- stations
    
- orbitals
    
- planetary networks
    
- corporate fleets
    
- Belter mesh nets
    
- pirate networks
    

Each namespace uses its own NNS structure internally. INGP enables communication _between_ these namespaces.

---

## 3. Core Concepts

### 3.1 NNS (Local Namespace)

Human‑readable, hierarchical addressing used inside a system. Example:

```
IND-ROCI-OPS : ROCINANTE : HAB_RING : DEVICE_442 : USER_COMMS
```

### 3.2 UUID (Universal Identifier)

Every NNS element (System, Zone, Node, Service) resolves to a **UUID**. UUIDs are globally unique and serve as the universal addressing substrate.

### 3.3 BAP (Bundle Addressing Protocol)

The inter‑namespace transport layer. BAP bundles carry:

- source UUID
    
- destination UUID
    
- payload
    
- mobility hints
    
- TTL
    

### 3.4 Gateways

Each namespace exposes one or more **Gateways** that:

- translate NNS → UUID
    
- encapsulate traffic into BAP bundles
    
- forward bundles across SolNet
    
- unwrap bundles and deliver to local NNS nodes
    

Gateways are analogous to border routers.

---

## 4. INGP Flow

### 4.1 Outbound

1. Local device sends to an NNS address.
    
2. Gateway resolves NNS → UUID.
    
3. Gateway wraps payload in a BAP bundle.
    
4. Bundle is forwarded across SolNet.
    

### 4.2 Inbound

1. Gateway receives a BAP bundle.
    
2. Gateway unwraps bundle.
    
3. Gateway resolves UUID → NNS.
    
4. Payload is delivered to the local node.
    

---

## 5. Diagram: NNS ↔ UUID ↔ BAP Flow

[NNS] → [Gateway] → [BAP/SolNet] → [Gateway] → [NNS]

---

## 6. Routing Example Across Four Namespaces

This example demonstrates a message traveling from a ship to a station, then to a relay, then to a planetary network, and finally to a personal device.

### 6.1 Scenario

Naomi (on the **Rocinante**) sends a message to Holden, currently on **Ceres Station**.

### 6.2 Steps

#### **Step 1 — Local Namespace (Rocinante)**

Naomi’s device resolves Holden’s identity:

```
holden.james@pns → HoldenPublicKey → CERES-PUBLICNET : CERES : DOCK_RING_A : DEVICE_991
```

Gateway resolves NNS → UUID.

#### **Step 2 — Inter‑Namespace Hop 1 (Rocinante → Tycho Relay)**

Rocinante gateway encapsulates the message in a BAP bundle and forwards it to the nearest predictable relay.

#### **Step 3 — Inter‑Namespace Hop 2 (Tycho Relay → Ceres L1 Relay)**

Tycho Relay uses mobility hints and ephemeris to forward the bundle toward Ceres.

#### **Step 4 — Inter‑Namespace Hop 3 (Ceres L1 Relay → Ceres Station)**

Ceres L1 Relay unwraps and rewraps the bundle as needed, forwarding it to the Ceres Station gateway.

#### **Step 5 — Local Namespace (Ceres Station)**

Ceres gateway unwraps the bundle and resolves UUID → NNS:

```
CERES-PUBLICNET : CERES : DOCK_RING_A : DEVICE_991
```

Message is delivered to Holden’s current device.

---

## 7. Security Considerations

- Gateways must validate UUID signatures.
    
- BAP bundles may be spoofed; trust domains mitigate this.
    
- Namespace authorities may apply filtering or rate‑limiting.
    
- Mobility hints may be forged by hostile actors.
    

---

## 8. Summary

INGP provides the glue that binds SolNet’s independent namespaces into a coherent interplanetary network. By combining:

- local NNS addressing,
    
- universal UUIDs,
    
- BAP transport,
    
- and gateway translation,
    

SolNet achieves interoperability without centralization, enabling communication across ships, stations, orbitals, and planetary networks.