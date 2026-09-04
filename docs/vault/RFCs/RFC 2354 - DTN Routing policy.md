# RFC‑2354: DTN Routing Policy Recommendations

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2354.03.19_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines recommended routing policies for **Delay‑Tolerant Networking (DTN)** within SolNet. These guidelines apply to all networks participating in inter‑namespace communication, including:

- **Earth Coalition Networks**
    
- **Martian Congressional Republic Relays**
    
- **Tycho Station Operations Mesh**
    
- **Ceres PublicNet**
    
- **Luna Relay Authority**
    
- **Independent Belt Operators**
    
- **Deep‑space research vessels**
    

The goal is to ensure predictable, efficient, and resilient routing across a heterogeneous, intermittently connected solar‑system‑scale network.

---

## 2. Routing Model

SolNet routing is based on:

- **Bundle Addressing Protocol (BAP)**
    
- **custody transfer**
    
- **store‑and‑forward relays**
    
- **mobility hints and ephemeris**
    
- **opportunistic contacts**
    
- **predictive routing windows**
    

Routing decisions MUST be made using available metadata without assuming continuous connectivity.

---

## 3. Mobility Hints

### 3.1 Types of Mobility Metadata

Nodes SHOULD publish one or more of the following:

- **Predictable Ephemeris** (e.g., Earth–Mars relay orbits)
    
- **Semi‑Predictable Schedules** (e.g., Tycho cargo shuttles)
    
- **Opportunistic Contact Probabilities** (e.g., Belt haulers)
    
- **Static Position** (e.g., Ceres PublicNet)
    

### 3.2 Usage

Routing engines SHOULD:

- prioritize predictable contacts
    
- use probabilistic scoring for opportunistic contacts
    
- avoid routing loops by tracking recent hops
    
- degrade gracefully when metadata is missing
    

---

## 4. Custody Transfer

### 4.1 Requirements

Nodes MUST support custody transfer for bundles with the `CUSTODY_REQUESTED` flag.

### 4.2 Policies

- Custody SHOULD be accepted only when sufficient storage is available.
    
- Custody MUST NOT be accepted for bundles with invalid signatures.
    
- Custody MAY be refused during congestion.
    

### 4.3 Release

Custody MUST be released when:

- bundle is successfully forwarded
    
- TTL expires
    
- operator manually purges the queue (with logging)
    

---

## 5. Routing Windows

Nodes SHOULD maintain routing windows based on:

- predicted contact times
    
- signal‑to‑noise expectations
    
- power availability
    
- antenna alignment
    

Example:

- **Mars L4 Relay** publishes a 12‑minute window every 2 hours.
    
- **Tycho Station Mesh** publishes rolling 5‑minute windows.
    
- **Independent Belt Operators** may publish windows only when power is stable.
    

---

## 6. Opportunistic Forwarding

Nodes MAY forward bundles opportunistically when:

- a new contact becomes available
    
- the contact has a higher predicted delivery probability
    
- the bundle is nearing TTL expiration
    

Nodes SHOULD avoid:

- flooding the network
    
- forwarding to low‑trust or unknown nodes
    

---

## 7. Congestion Control

Nodes SHOULD implement:

- queue prioritization (critical > operational > routine)
    
- backpressure signaling
    
- bundle dropping based on TTL and priority
    
- storage reservation for critical traffic
    

Nodes MUST NOT:

- drop custody bundles without releasing custody
    
- modify bundle payloads
    

---

## 8. Multi‑Hop Relay Behavior

Nodes SHOULD:

- track recent hops to avoid loops
    
- maintain hop‑count metadata
    
- prefer relays with higher reliability scores
    

Nodes MAY:

- use historical delivery statistics
    
- apply operator‑defined routing policies
    

---

## 9. Example Routing Scenario

A bundle originating on **Earth Coalition Networks** is destined for a device on **Ceres PublicNet**.

### Step 1 — Earth → Luna Relay Authority

Earth gateway forwards to Luna based on predictable ephemeris.

### Step 2 — Luna → Mars L4 Relay

Luna forwards during a scheduled high‑bandwidth window.

### Step 3 — Mars L4 → Tycho Station Mesh

Mars L4 selects Tycho due to higher delivery probability.

### Step 4 — Tycho → Ceres L1 Relay

Tycho forwards opportunistically when a Ceres‑bound hauler docks.

### Step 5 — Ceres L1 → Ceres PublicNet

Ceres L1 unwraps and delivers to the local NNS.

---

## 10. Summary

These routing policies ensure:

- predictable delivery across long delays
    
- efficient use of limited contact windows
    
- resilience to outages and mobility
    
- interoperability across diverse networks
    

All SolNet participants SHOULD implement these recommendations to maintain a robust, scalable, and cooperative interplanetary communication fabric.