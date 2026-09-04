# RFC‑2357: PNS Caching & Gossip Protocol

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2357.03.19_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **PNS Caching & Gossip Protocol (PCGP)**, the distributed directory mechanism that enables identity resolution across SolNet’s heterogeneous, delay‑tolerant, multi‑authority environment.

PCGP ensures that **PNS labels**, **public keys**, and **current NNS addresses** propagate reliably across:

- **Earth Coalition Networks**
    
- **Martian Congressional Republic Relays**
    
- **Tycho Station Operations Mesh**
    
- **Ceres PublicNet**
    
- **Luna Relay Authority**
    
- **Independent Belt Operators**
    
- **Deep‑space research vessels**
    

The protocol is designed for intermittent connectivity, long delays, and partial information.

---

## 2. Data Model

Each PNS entry consists of:

```
PNS Label → Public Key → Current NNS Address
```

with metadata:

- timestamp
    
- TTL
    
- trust domain
    
- last‑seen location
    
- signature
    

### 2.1 PNS Label

Human‑readable identifier (e.g., `naomi.nagata@pns`). Labels are **not globally unique**.

### 2.2 Public Key

The authoritative identity anchor. MUST be globally unique.

### 2.3 Current NNS Address

The user’s present routable endpoint within a namespace.

---

## 3. Cache Structure

Caches MUST store:

- full PNS entries
    
- signature verification status
    
- trust domain classification
    
- expiration time
    

Caches SHOULD:

- maintain LRU eviction
    
- prioritize high‑trust entries
    
- store multiple entries for colliding labels
    

---

## 4. Gossip Protocol

### 4.1 Gossip Triggers

Nodes SHOULD gossip PNS updates when:

- a user registers a new NNS address
    
- a PNS label changes
    
- a keypair is rotated
    
- a TTL is nearing expiration
    
- a gateway comes online
    

### 4.2 Gossip Mechanism

Gossip MAY occur via:

- scheduled relay windows (e.g., **Mars L4 Relay**)
    
- opportunistic contacts (e.g., passing Belt haulers)
    
- mesh propagation (e.g., **Tycho Station Mesh**)
    
- long‑haul DTN bundles
    

### 4.3 Gossip Contents

Gossip packets MUST include:

- PNS label
    
- public key
    
- current NNS address
    
- timestamp
    
- TTL
    
- signature
    

Nodes MUST verify signatures before accepting updates.

---

## 5. TTL & Staleness

### 5.1 TTL Rules

TTL SHOULD reflect:

- user mobility
    
- namespace stability
    
- trust domain
    

Examples:

- **Ceres PublicNet**: long TTL (static population)
    
- **Tycho Station**: medium TTL (high traffic)
    
- **Belt haulers**: short TTL (high mobility)
    

### 5.2 Staleness Handling

Nodes MUST:

- mark stale entries as `UNVERIFIED`
    
- prefer fresher entries
    
- retain stale entries for fallback routing
    

Nodes SHOULD NOT delete stale entries immediately.

---

## 6. Collision Handling

PNS labels are not unique. When multiple entries exist:

- nodes MUST return all matching public keys
    
- clients MUST disambiguate using trust graph or known keys
    

Example: Two users named "Alex Kim" register on **Earth Coalition Networks** and **Tycho Station**. Resolvers return both entries; clients choose based on known public keys.

---

## 7. Trust Domains

Each PNS entry belongs to a trust domain:

- **HIGH** (Earth, Mars, Luna)
    
- **MEDIUM** (Tycho, Ganymede, Ceres)
    
- **LOW** (independent operators)
    
- **UNKNOWN** (unverified sources)
    

Nodes SHOULD:

- prefer high‑trust entries
    
- propagate medium‑trust entries
    
- isolate low‑trust entries
    
- quarantine unknown entries
    

---

## 8. Update Signing

All PNS updates MUST be signed by:

- the user’s private key, OR
    
- the namespace authority’s key (for system‑level updates)
    

Nodes MUST reject unsigned or invalidly signed updates.

---

## 9. Query Propagation

### 9.1 Local Resolution

Nodes MUST check local cache first.

### 9.2 Gossip Query

If unresolved, nodes SHOULD broadcast a query to:

- neighboring gateways
    
- known relays
    
- recent contacts
    

### 9.3 DTN Query

If still unresolved, nodes MAY send a DTN query bundle across SolNet.

---

## 10. Example Resolution Flow

A user on **Tycho Station** attempts to contact a friend believed to be on **Ceres PublicNet**.

1. Tycho device queries local PNS resolver.
    
2. Resolver returns stale entry.
    
3. Resolver gossips query to Tycho Mesh.
    
4. Mesh forwards query to a departing hauler.
    
5. Hauler contacts **Ceres L1 Relay**.
    
6. Ceres L1 returns fresh PNS entry.
    
7. Tycho resolver updates cache and returns result.
    

---

## 11. Summary

The PNS Caching & Gossip Protocol ensures:

- reliable identity resolution across SolNet
    
- resilience to intermittent connectivity
    
- graceful handling of mobility and staleness
    
- secure propagation of identity updates
    
- interoperability across diverse networks
    

PCGP is essential for maintaining a coherent, discoverable identity layer in a distributed, delay‑tolerant solar‑system‑scale network.