# RFC‑2361: SolNet Layer Model (SLM) — Expanse Edition

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2361.03.20_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **canonical SolNet Layer Model (SLM)**, the architectural framework that governs all communication across the Sol system. Unlike classical OSI‑style models, SLM incorporates:

- the physical realities of interplanetary communication,
    
- the political boundaries of the Expanse universe,
    
- the uneven technological landscape across factions,
    
- legacy compatibility constraints,
    
- opportunistic and improvised Belt‑style networking.
    

This RFC establishes the **seven‑layer model** used by all SolNet standards.

---

## 2. Layer Overview

The SolNet Layer Model consists of the following layers:

1. **L0 — Contact Ecology Layer**
    
2. **L1 — Local Namespace Layer (NNS)**
    
3. **L2 — Identity & Resolution Layer**
    
4. **L2.5 — Jurisdiction & Policy Boundary Layer**
    
5. **L3 — Inter‑Namespace Transport Layer (BAP)**
    
6. **L4 — Mobility & Ephemeris Layer (DTN Routing)**
    
7. **L5 — Session & Security Layer**
    
8. **L6 — Application Layer**
    

Each layer is described in detail below.

---

## 3. L0 — Contact Ecology Layer

_“How bits actually cross the void.”_

This layer defines the physical and operational characteristics of SolNet links. It reflects the diverse, faction‑controlled, and often improvised communication infrastructure of the Sol system.

### 3.1 Link Types

The following link types are recognized:

#### **Laser‑Based Links**

- **LASER_DIRECT** — High‑bandwidth, tightbeam, requires precise alignment.
    
- **LASER_CHAINED** — Multi‑hop repeater chains (MCRN, UNN, corporate).
    
- **LASER_DEEPSPACE** — Long‑range, low‑power, used by research vessels.
    
- **LASER_STEALTH** — Low‑emission, military‑grade, limited range.
    

#### **Radio‑Based Links**

- **RADIO_BROADCAST** — Wide‑cone, resilient, low bandwidth.
    
- **RADIO_DIRECT** — Point‑to‑point, moderate bandwidth.
    
- **RADIO_MESH** — Station and shipboard mesh networks.
    
- **RADIO_LOWPOWER** — Used by Ceres PublicNet and older Belt systems.
    

#### **Opportunistic & Improvised Links**

- **OPPORTUNISTIC_HAULER_RELAY** — Belter ships acting as temporary relays.
    
- **PIRATE_REPEATER** — Black‑market Belt repeaters; unpredictable behavior.
    
- **ADHOC_LINK** — Improvised or temporary links between nearby craft.
    

#### **Proprietary & Restricted Links**

- **CORPORATE_PROPRIETARY** — Closed, authenticated, encrypted.
    
- **MILITARY_EXCLUSIVE** — MCRN/UNN‑only channels.
    
- **DIPLOMATIC_SECURE** — UN diplomatic channels.
    

### 3.2 Operational Constraints

- alignment windows
    
- occlusion by planetary bodies
    
- radiation storms
    
- power budgets
    
- antenna wear and drift
    

---

## 4. L1 — Local Namespace Layer (NNS)

_“Inside the station, inside the ship, inside the zone.”_

This layer defines addressing and routing within a local domain.

### 4.1 Examples

- Tycho Station Ops Ring
    
- Ceres PublicNet
    
- Martian naval vessels
    
- Belt hauler internal nets
    

### 4.2 Characteristics

- autonomous
    
- heterogeneous
    
- often legacy‑laden
    
- may include proprietary extensions
    

---

## 5. L2 — Identity & Resolution Layer

_“Who are you, and where are you really?”_

This layer includes:

- UUIDs
    
- PNS (Personal Naming Service)
    
- trust domains
    
- identity signatures
    

### 5.1 Factional Behavior

- Martian identities are rigid and strongly verified.
    
- UN identities are bureaucratic and slow to update.
    
- Belters often maintain multiple identities.
    
- Corporate identities may be proprietary.
    

---

## 6. L2.5 — Jurisdiction & Policy Boundary Layer

_“Whose rules apply to this packet?”_

This layer governs political, military, and corporate boundaries.

### 6.1 Jurisdiction Domains

- **MCRN**
    
- **UNN**
    
- **OPA / Belt**
    
- **Commercial**
    
- **Independent**
    
- **Black‑market**
    

### 6.2 Policy Enforcement Examples

- MCRN relays reject OPA traffic.
    
- UN relays require bureaucratic authentication.
    
- Corporate relays accept only signed commercial packets.
    
- Belt repeaters accept anything but may drop packets.
    
- Pirate relays accept everything but may tamper.
    

---

## 7. L3 — Inter‑Namespace Transport Layer (BAP)

_“The bundle is the unit of truth.”_

This layer defines:

- bundle structure
    
- custody transfer
    
- TTL
    
- hop count
    
- integrity verification
    

### 7.1 Factional Variants

- Martians use strict custody rules.
    
- UN uses verbose metadata.
    
- Belters minimize TTL to conserve power.
    
- Corporate nets use proprietary extensions.
    

---

## 8. L4 — Mobility & Ephemeris Layer (DTN Routing)

_“Where is everything, and when will it be there?”_

This layer handles:

- orbital ephemeris
    
- contact windows
    
- alignment constraints
    
- hauler schedules
    
- relay reliability
    
- opportunistic routing
    

### 8.1 Examples

- Mars L4 Relay as inner‑system backbone.
    
- Belt haulers forming shifting meshes.
    
- Ceres L1 Relay congestion.
    
- Deep‑space research vessels with sparse ephemeris.
    

---

## 9. L5 — Session & Security Layer

_“Who can talk to whom, and under what conditions?”_

This layer includes:

- encryption domains
    
- key hierarchies
    
- gateway attestation
    
- domain‑based access control
    
- session negotiation
    
- replay protection
    

### 9.1 Encryption Domains

- **MIL‑HIGH** (MCRN, UNN elite units)
    
- **MIL‑MEDIUM** (UNN general fleet)
    
- **CIV‑COMMERCIAL** (corporate nets)
    
- **CIV‑PUBLIC** (Ceres PublicNet)
    
- **INDEPENDENT** (Belt operators)
    

---

## 10. L6 — Application Layer

_“What people actually use.”_

This layer defines:

- messaging protocols
    
- file transfer
    
- telemetry
    
- presence
    
- service discovery
    
- command/control
    

### 10.1 Examples

- ship telemetry feeds
    
- station control systems
    
- Belter barter‑market apps
    
- Martian military command channels
    
- UN diplomatic messaging
    

---

## 11. Summary

The SolNet Layer Model (SLM) defines the **canonical seven‑layer architecture** for all SolNet communication. It incorporates:

- the physics of interplanetary communication,
    
- the political boundaries of the Expanse universe,
    
- the uneven technological landscape across factions,
    
- legacy compatibility constraints,
    
- opportunistic Belt networking.
    

This RFC serves as the foundational reference for all future SolNet standards.