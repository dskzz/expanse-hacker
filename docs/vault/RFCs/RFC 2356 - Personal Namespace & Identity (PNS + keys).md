# RFC‑2356: Personal Namespace & Identity (PNS + Keys)

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2356.03.19_  
_Status: Informational / Non‑Binding_

---

## 1. Overview

This document defines the identity architecture for personal communication devices operating within the SolNet / SSNS ecosystem. It specifies how **biomarkers**, **cryptographic keys**, **Personal Namespace Service (PNS) labels**, and **local Network Namespace System (NNS) addresses** interoperate to provide a coherent, mobile, and secure identity model across ships, stations, orbitals, and planetary networks.

Identity in SolNet is anchored by a **long‑lived cryptographic keypair**, not by device hardware or human‑readable names. Devices—including disposable vending‑machine handsets—act as temporary hosts for a user’s identity, which is retrieved and bound at login via biomarker authentication.

---

## 2. Identity Chain

SolNet identity is defined by the following chain:

**Biomarker → Keypair → PNS Label(s) → Current NNS Address → BAP Routing**

### 2.1 Biomarker

A biomarker is any unique, user‑specific physical signature (fingerprint, retinal pattern, DNA hash, etc.). Biomarkers are used to retrieve or unlock the user’s cryptographic identity.

### 2.2 Keypair

The keypair is the **true identity anchor**. It consists of:

- **Public Key**: globally visible, used for routing and verification.
    
- **Private Key**: stored securely in the network’s identity vault or derived via biometric‑bound key material.
    

The keypair persists across:

- device changes
    
- name changes
    
- faction changes
    
- loss or destruction of hardware
    

### 2.3 PNS Label(s)

PNS labels are human‑meaningful identifiers (e.g., `naomi.nagata@pns`). They are **not globally unique** and may collide. Labels map to the user’s public key.

Users may:

- change labels (e.g., name changes)
    
- add aliases
    
- remove old labels
    

### 2.4 NNS Address

The NNS address is the user’s **current routable endpoint**, assigned by the system they are physically connected to. Example:

```
IND-ROCI-OPS : ROCINANTE : HAB_RING : DEVICE_442 : USER_COMMS
```

NNS addresses are ephemeral and change as the user moves.

### 2.5 BAP Routing

The Bundle Addressing Protocol (BAP) uses the mapping:

```
Public Key → Current NNS Address
```

to deliver messages across SolNet.

---

## 3. Device Binding

### 3.1 Login Procedure

When a user authenticates to a device (personal handset, ship terminal, vending‑machine comm):

1. Device captures biomarker.
    
2. Identity service resolves: `biomarker → public key (+ private key or delegated key)`.
    
3. Device retrieves user profile (PNS labels, preferences, contact graph).
    
4. Device registers: `public key → current NNS address`.
    
5. Local PNS Resolver caches and gossips the mapping.
    

### 3.2 Logout / Expiry

When the session ends:

- Device wipes local state.
    
- Mapping expires or is revoked.
    
- Identity persists in the network.
    

---

## 4. Disposable Devices

### 4.1 Anonymous Mode

Disposable devices may generate their own temporary keypair. No PNS label is used. Suitable for:

- anonymous communication
    
- pirate operations
    
- temporary field work
    

### 4.2 Bound Mode

User authenticates with biomarker; device temporarily hosts the user’s keypair. Device registers the user’s NNS address and behaves like a normal handset.

---

## 5. PNS Resolution

### 5.1 Mapping Structure

PNS caches store:

```
PNS Label → Public Key → Current NNS Address
```

with metadata:

- timestamp
    
- confidence score
    
- trust domain
    
- last‑seen location
    

### 5.2 Collision Handling

PNS labels are not unique. Resolvers return all matches. Disambiguation uses:

- cryptographic key
    
- relationship graph
    
- trust domain
    
- freshness of mapping
    

### 5.3 Query Propagation

PNS queries propagate through SolNet as BAP bundles. Nodes respond if they have:

- cached entries
    
- recent sightings
    
- local registrations
    
- gossip packets
    

---

## 6. Gossip & Caching

Every system (ship, station, relay, planet) runs a **PNS Resolver** that:

- caches mappings
    
- gossips updates opportunistically
    
- responds to PNS queries
    
- expires stale entries
    

This ensures eventual consistency in a DTN environment.

---

## 7. Name Changes

When a user changes their name:

- PNS label changes
    
- keypair remains the same
    
- biomarker still maps to the same key
    
- contacts who have the key still recognize the user
    

This supports:

- legal name changes
    
- factional identity shifts
    
- personal rebranding
    

---

## 8. Security Considerations

- Keys must be protected by biometric‑bound derivation or secure vaults.
    
- PNS labels are not secure identifiers.
    
- PNS caches may be poisoned; trust domains mitigate this.
    
- Disposable devices must wipe key material on logout.
    
- Gossip propagation is unauthenticated unless signed.
    

---

## 9. Summary

RFC‑2356 defines a unified identity model for SolNet:

- **Biomarker** authenticates the user.
    
- **Keypair** anchors identity.
    
- **PNS labels** provide human‑readable handles.
    
- **NNS addresses** provide routable endpoints.
    
- **PNS Resolvers** bind global identity to local presence.
    

This architecture supports:

- roaming across ships, stations, and planets
    
- disposable devices
    
- name changes
    
- decentralized operation
    
- DTN‑friendly caching and gossip
    

Identity is portable, secure, and independent of hardware—exactly what a fractured solar system requires.