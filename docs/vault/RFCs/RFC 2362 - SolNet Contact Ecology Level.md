# RFC‑2362: SolNet Contact Ecology & Link Types

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2362.03.20_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **SolNet Contact Ecology Layer (L0)**, the foundational layer of the SolNet Layer Model. It specifies all recognized physical link types used across the Sol system, along with their operational characteristics, constraints, and typical deployment contexts.

The Contact Ecology Layer reflects the diverse, faction‑shaped, and resource‑constrained communication environment of the SolNet era. It provides a unified taxonomy for link types without implying political, moral, or legal judgments about their operators.

---

## 2. Scope

This RFC covers:

- All officially recognized SolNet link types
    
- Operational envelopes and constraints
    
- Alignment, power, and environmental considerations
    
- Integration expectations for higher‑layer protocols
    

This RFC does **not** define routing, security, or policy behavior; those are addressed in other standards.

---

## 3. Link Type Families

SolNet link types are grouped into five families:

1. Laser‑Based Links
    
2. Radio‑Based Links
    
3. Opportunistic & Independent Links
    
4. Proprietary & Restricted Links
    
5. Exotic & Specialized Links
    

Each family is described in detail below.

---

## 4. Laser‑Based Links

Laser links provide high‑bandwidth, high‑precision communication across interplanetary distances.

### 4.1 LASER_DIRECT

- Tightbeam, high‑bandwidth
    
- Requires precise alignment
    
- Used by major hubs, military vessels, and corporate infrastructure
    

### 4.2 LASER_CHAINED

- Multi‑hop repeater chains
    
- Precomputed alignment windows
    
- Backbone for Earth–Mars–Belt communication
    

### 4.3 LASER_DEEPSPACE

- Long‑range, low‑power
    
- Used by research vessels and deep‑space missions
    

### 4.4 LASER_STEALTH

- Low‑emission, short‑range
    
- Used by vessels requiring minimal detectability
    

### 4.5 LASER_BOUNCE

- Reflective relay off mirrors or hull plates
    
- Rare and alignment‑sensitive
    

---

## 5. Radio‑Based Links

Radio links are resilient, low‑precision, and widely deployed across the Sol system.

### 5.1 RADIO_BROADCAST

- Wide‑cone, low‑bandwidth
    
- Used for public nets and emergency signaling
    

### 5.2 RADIO_DIRECT

- Point‑to‑point, moderate bandwidth
    
- Common for ship‑to‑ship communication
    

### 5.3 RADIO_MESH

- Multi‑node, self‑healing mesh
    
- Used by stations, habitats, and dense Belt clusters
    

### 5.4 RADIO_LOWPOWER

- Short‑range, minimal energy use
    
- Common in older habitats and low‑budget installations
    

### 5.5 RADIO_DEEPSPACE

- Long‑range, low‑bandwidth
    
- Used by haulers, probes, and outer‑system craft
    

---

## 6. Opportunistic & Independent Links

These links arise from proximity, private ownership, or non‑federated operation. They are essential to Belt‑region connectivity.

### 6.1 OPPORTUNISTIC_HAULER_RELAY

- Temporary relays formed by passing haulers
    
- Routing is dynamic and unpredictable
    

### 6.2 INDEPENDENT_REPEATER

- Privately owned, non‑aligned repeaters
    
- May have unique capabilities or policies
    

### 6.3 ADHOC_LINK

- Temporary link between nearby vessels or stations
    
- Used during docking, EVA operations, or emergencies
    

### 6.4 TETHERED_LINK

- Physical cable or fiber between vessels or modules
    
- Used for repairs, covert transfers, or high‑reliability local links
    

### 6.5 LEGACY_REPEATER

- Older, underpowered hardware still in service
    
- Common in long‑established Belt habitats
    

---

## 7. Proprietary & Restricted Links

These links enforce organizational, commercial, or governmental boundaries.

### 7.1 CORPORATE_PROPRIETARY

- Encrypted and authenticated
    
- Used by shipping lines, industrial operators, and research groups
    

### 7.2 MILITARY_EXCLUSIVE

- Restricted to authorized military assets
    
- Often laser‑based with strict alignment and encryption requirements
    

### 7.3 DIPLOMATIC_SECURE

- High‑security channels for diplomatic communication
    
- Prioritizes confidentiality over latency
    

### 7.4 PRIVATE_STATION_BACKBONE

- Internal station infrastructure
    
- Not accessible to public or transient networks
    

### 7.5 PRIORITY_LANE

- High‑bandwidth lanes available by contract or subscription
    
- Used by commercial and governmental clients
    

---

## 8. Exotic & Specialized Links

These links are rare but recognized within the SolNet ecosystem.

### 8.1 GRAVITY_LENS_LINK

- Uses gravitational lensing for extreme‑range laser communication
    
- Experimental and limited to specialized missions
    

### 8.2 SOLAR_REFLECTOR_LINK

- Uses solar sails or mirrors as passive reflectors
    
- Niche research applications
    

### 8.3 ICE_TUNNEL_RADIO

- Radio propagated through ice layers
    
- Used on Europa, Enceladus, and similar environments
    

---

## 9. Operational Constraints

All link types are subject to environmental and physical constraints, including:

- alignment windows
    
- occlusion by planetary bodies
    
- radiation storms
    
- power budgets
    
- antenna drift and wear
    
- thermal distortion
    

Higher‑layer protocols MUST account for these constraints when selecting paths or negotiating custody.

---

## 10. Integration With Higher Layers

The Contact Ecology Layer provides link metadata to:

- L4 (Mobility & Ephemeris) for routing decisions
    
- L3 (Transport) for fragmentation and custody negotiation
    
- L5 (Security) for domain‑based access control
    

Gateways MUST expose link capabilities and constraints to higher layers.

---

## 11. Summary

RFC‑2362 defines the complete taxonomy of SolNet link types, forming the foundation of the Contact Ecology Layer. This taxonomy reflects the diverse, faction‑shaped, and resource‑constrained communication environment of the SolNet era.

All SolNet‑compliant nodes, gateways, and relays MUST implement this taxonomy for link classification and capability reporting.