# RFC‑2355: Personal Device Integration Guidelines

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2355.03.19_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the operational and security guidelines for **personal communication devices** operating within SolNet. These devices include:

- handheld terminals ("phones")
    
- shipboard personal consoles
    
- station public‑access comms
    
- vending‑machine temporary handsets
    
- expeditionary field tablets
    

The goal is to ensure consistent identity handling, predictable routing behavior, and secure integration across all SolNet‑participating networks, including **Earth Coalition Networks**, **Martian Congressional Republic systems**, **Tycho Station Operations Mesh**, **Ceres PublicNet**, and independent Belt operators.

---

## 2. Identity Integration

Personal devices MUST integrate with the SolNet identity chain:

```
Biomarker → Keypair → PNS Label(s) → Current NNS Address
```

### 2.1 Biomarker Authentication

Devices MUST support at least one biometric modality:

- fingerprint
    
- retinal pattern
    
- voiceprint
    
- DNA‑hash (optional, high‑security environments)
    

Biomarkers MUST NOT be transmitted across SolNet.

### 2.2 Keypair Retrieval

Upon successful biometric authentication, devices MUST retrieve or unlock the user’s keypair via:

- local secure enclave
    
- network identity vault
    
- delegated ephemeral key (for temporary devices)
    

### 2.3 PNS Registration

Devices MUST register the user’s current NNS address with the local PNS resolver.

### 2.4 Session Binding

A device session MUST bind:

- user keypair
    
- device UUID
    
- NNS address
    
- session expiration
    

---

## 3. Device Modes

### 3.1 Bound Mode

Used for personal devices.

- full identity binding
    
- PNS registration
    
- persistent preferences
    
- message synchronization
    

### 3.2 Temporary Mode

Used for public or disposable devices (e.g., vending‑machine handsets).

- ephemeral keypair OR temporary binding to user keypair
    
- strict session expiration
    
- mandatory data wipe on logout
    

### 3.3 Offline Mode

Devices MUST support offline operation:

- local message queue
    
- delayed PNS registration
    
- cached contact graph
    

---

## 4. NNS Integration

Devices MUST:

- obtain a valid NNS address from the local namespace authority
    
- maintain accurate local time (within reasonable drift)
    
- update NNS registration when moving between zones
    

Devices SHOULD:

- publish mobility hints when appropriate
    
- gracefully handle namespace changes (e.g., boarding a shuttle)
    

---

## 5. Profile Synchronization

Devices SHOULD synchronize:

- PNS label list
    
- contact graph
    
- message index
    
- preferences
    
- trust domains
    

Synchronization MUST be:

- incremental
    
- signed
    
- resumable across intermittent connectivity
    

---

## 6. Security Requirements

Devices MUST:

- verify signatures on all inbound messages
    
- sign all outbound messages
    
- isolate untrusted applications
    
- encrypt local storage
    
- wipe sensitive data on logout or session expiration
    

Devices SHOULD:

- implement rate limiting
    
- detect anomalous routing behavior
    
- warn users when operating in low‑trust networks
    

---

## 7. Device Handoff

When a user switches devices (e.g., from a ship console to a station terminal):

1. Old device MUST revoke its NNS registration.
    
2. New device MUST register its NNS address.
    
3. PNS resolvers MUST propagate the update.
    
4. Pending bundles MUST be rerouted to the new endpoint.
    

Example:

- A user leaves **Tycho Station** and boards a shuttle.
    
- Their phone registers with the shuttle’s NNS.
    
- Tycho’s PNS resolver gossips the update.
    
- Messages in transit reroute via the shuttle’s gateway.
    

---

## 8. Temporary Device Example

A traveler on **Ceres PublicNet** uses a vending‑machine handset:

1. User authenticates via fingerprint.
    
2. Device retrieves user keypair from identity vault.
    
3. Device registers temporary NNS address.
    
4. User sends and receives messages normally.
    
5. User logs out.
    
6. Device wipes all local state.
    

This ensures secure, ephemeral access without compromising identity integrity.

---

## 9. Failure Modes

Devices MUST handle:

- loss of network connectivity
    
- namespace authority unavailability
    
- identity vault timeout
    
- corrupted PNS data
    

Devices SHOULD:

- retry registration with exponential backoff
    
- fall back to cached PNS data
    
- queue outbound messages until connectivity returns
    

---

## 10. Summary

Personal devices are the primary interface between users and SolNet. To ensure secure, predictable, and interoperable communication across the solar system, devices MUST:

- bind identity correctly
    
- integrate with NNS and PNS
    
- support DTN operation
    
- enforce strong security practices
    
- behave consistently across all networks
    

These guidelines form the foundation for reliable personal communication in a distributed, delay‑tolerant, multi‑authority environment.