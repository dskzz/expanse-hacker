# **RFC‑2354: Mobility Hint Block Specification (MHB 1.0)**

_SolNet Standards Working Group (SSWG)_ _Revision Date: 2350.07.22_ _Status: Informational / Non‑Binding_

## **Abstract**

This document defines the **Mobility Hint Block (MHB)**, an optional metadata structure used by Delay‑Tolerant Network (DTN) nodes to advertise their predicted motion, orbital parameters, and routing stability.

The MHB enables more efficient routing in environments where:

- nodes move
    
- links are intermittent
    
- solar interference is common
    
- routing windows depend on orbital mechanics
    
- some nodes deliberately obscure their motion
    

MHB is not mandatory. Nodes MAY omit it, spoof it, or lie outright. This is expected behavior in the SolNet.

## **1. Introduction**

In interplanetary space, **everything moves**:

- planets
    
- moons
    
- stations
    
- relays
    
- ships
    
- drones
    
- cargo pods
    
- rockhoppers
    
- pirate skiffs
    

Traditional networking assumes fixed infrastructure. DTN routing assumes **predictable mobility**.

The Mobility Hint Block provides a standardized way for nodes to publish:

- current position
    
- current velocity
    
- orbital elements (if applicable)
    
- predictability score
    
- update interval
    

This allows routing decisions to be based on **future availability**, not present location.

## **2. Scope**

The MHB defines:

- required and optional fields
    
- predictability scoring
    
- update intervals
    
- recommended usage
    
- known failure modes
    

The MHB does **not** define:

- routing algorithms
    
- authentication
    
- orbital mechanics
    
- enforcement mechanisms
    

As with all SolNet standards, compliance is voluntary.

## **3. Mobility Hint Block Structure**

An MHB is a JSON‑like structure attached to a BAP bundle or broadcast by a node:

Code

```
{
  "vector": {
    "position": [x, y, z],
    "velocity": [vx, vy, vz]
  },
  "ephemeris": <orbital elements or null>,
  "predictability": <0.0–1.0>,
  "update_interval": <seconds>,
  "timestamp": <UTC>
}
```

### **3.1 Field Definitions**

#### **vector**

Cartesian position and velocity in a shared reference frame (commonly J2000).

#### **ephemeris**

Orbital elements for predictable movers:

- planets
    
- moons
    
- stations
    
- Lagrange relays
    
- predictable haulers
    

Ships MAY omit ephemeris if not on a stable trajectory.

#### **predictability**

A scalar from **0.0 to 1.0**:

|Score|Meaning|Examples|
|---|---|---|
|**1.0**|perfectly predictable|planets, moons, major stations|
|**0.9**|highly predictable|Lagrange relays, Tycho Station|
|**0.6–0.8**|scheduled movers|corporate haulers, UN/MCR fleets|
|**0.2–0.5**|semi‑arbitrary|Belter rockhoppers, prospectors|
|**0.0**|chaotic|pirates, smugglers, OPA cells|

#### **update_interval**

How often the node intends to refresh its MHB.

- planets: days
    
- stations: hours
    
- haulers: minutes
    
- pirates: never
    

#### **timestamp**

UTC time of last update.

## **4. Usage in Routing**

Routing algorithms MAY use MHB data to:

- predict future link availability
    
- estimate contact windows
    
- avoid chaotic nodes
    
- prefer stable relays
    
- schedule long‑TTL bundles
    
- opportunistically forward to passing ships
    

Nodes MAY ignore MHB data entirely.

### **4.1 Recommended Behaviors**

- Prefer nodes with **high predictability** for long‑distance routing.
    
- Use **ephemeris** for scheduling interplanetary transfers.
    
- Avoid nodes with **predictability < 0.3** unless necessary.
    
- Treat **predictability = 0.0** as hostile or unreliable.
    

## **5. Special Cases**

### **5.1 Planets**

Planets are mobile but perfectly predictable.

Their MHB contains:

Code

```
"ephemeris": <orbital elements>,
"predictability": 1.0,
"update_interval": 604800
```

Planets are the **anchor points** of the SolNet.

### **5.2 Orbitals (Stations, Relays, Habitats)**

Orbitals are mobile but extremely predictable.

Code

```
"predictability": 0.9–1.0
```

Station‑keeping maneuvers MAY cause minor deviations.

### **5.3 Ships (Corporate, Military)**

Ships on scheduled routes:

Code

```
"predictability": 0.6–0.8
```

Military fleets often publish sanitized vectors.

### **5.4 Belter Rockhoppers**

Semi‑arbitrary movers:

Code

```
"predictability": 0.2–0.5
```

Often stale, inaccurate, or manually updated.

### **5.5 Pirate / Smuggler Vessels**

Chaotic movers:

Code

```
"predictability": 0.0
```

Vectors are often spoofed or omitted.

## **6. Security Considerations**

The MHB provides **no**:

- authentication
    
- encryption
    
- integrity guarantees
    

Nodes MAY:

- lie
    
- spoof vectors
    
- forge ephemeris
    
- broadcast false predictability
    
- jam mobility beacons
    

Operators SHOULD NOT trust MHB data without independent verification.

## **7. Known Failure Modes**

- solar interference corrupts vector data
    
- stale ephemeris leads to missed windows
    
- pirate vessels broadcast forged positions
    
- Belter ships forget to update their MHB
    
- stations drift due to fuel shortages
    
- relay nodes go dark without warning
    

These are considered normal operational hazards.

## **8. Example MHBs**

### **8.1 Planet (Mars)**

Code

```
{
  "ephemeris": "MARS_J2000",
  "predictability": 1.0,
  "update_interval": 604800,
  "timestamp": "2350-07-22T00:00:00Z"
}
```

### **8.2 Corporate Hauler**

Code

```
{
  "vector": { "position": [...], "velocity": [...] },
  "predictability": 0.7,
  "update_interval": 600,
  "timestamp": "2350-07-22T12:44:00Z"
}
```

### **8.3 Belter Rockhopper**

Code

```
{
  "vector": { "position": [...], "velocity": [...] },
  "predictability": 0.3,
  "update_interval": 3600,
  "timestamp": "2350-07-22T11:02:00Z"
}
```

### **8.4 Pirate Skiff**

Code

```
{
  "predictability": 0.0,
  "timestamp": "2350-07-22T09:00:00Z"
}
```

## **9. Conclusion**

The Mobility Hint Block is a voluntary, lightweight mechanism for improving routing efficiency in a solar system where:

- everything moves
    
- nothing is certain
    
- some nodes lie
    
- some nodes forget
    
- some nodes explode
    

MHB 1.0 provides a common language for describing motion, predictability, and routing stability — without imposing any central authority.

It works because it has to.