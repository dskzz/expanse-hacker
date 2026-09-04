# RFC‑2364: SolNet Directory & Routing Endpoints (DRE Layer)

_SolNet Standards Working Group (SSWG)_  
_Status: Standards‑Track_  
_Revision Date: 2364.03.20_

---

# 1. Introduction

SolNet operates across a **moving, politically fragmented, delay‑tolerant solar system**. Ships accelerate, stations rotate, relays drift, and contact windows open and close according to orbital mechanics. No single authority governs the network, and no central registry exists for identity, routing, or namespace metadata.

To maintain coherence across this environment, SolNet defines the **Directory & Routing Endpoints (DRE Layer)** — a set of well‑known endpoints that exist at every level of the namespace hierarchy:

- **Directory** — identity, service, and namespace discovery
    
- **Router** — ephemeris‑aware routing hints and link‑state prediction
    
- **Broadcast** — namespace‑wide announcements and emergency signaling
    
- **Wildcard** — catch‑all fallback for degraded mode and administrative queries
    

These endpoints form the **spine** of SolNet’s discovery and routing architecture, bridging:

- L1 (Local Namespace Layer)
    
- L2 (Identity & Resolution)
    
- L2.5 (Jurisdiction & Policy)
    
- L4 (Mobility & Ephemeris Routing)
    

---

# 2. Motivation

SolNet must operate under conditions where:

- nodes may be isolated for hours or days
    
- identity information may be stale
    
- routing paths may be intermittent
    
- political boundaries may restrict traffic
    
- ephemeris predictions may drift
    
- namespace topologies may change dynamically
    

DRE endpoints provide:

- **predictive routing** when real‑time routing is impossible
    
- **identity lookup** when global registries are unreachable
    
- **fallback discovery** when local services fail
    
- **gossip propagation** to maintain coherence across partitions
    
- **administrative control** for namespace operators
    

Without DRE, SolNet would collapse into isolated islands of connectivity.

---

# 3. Endpoint Types

Every namespace SHOULD implement the following endpoints. Large namespaces (e.g., Medina, Tycho, UNN flagships) MUST implement all of them.

## 3.1 Directory Endpoint

### Addressing

```
<System>:Directory
<Zone>:Directory
<Node>:Directory
```

### Responsibilities

- identity lookup (L2 integration)
    
- service discovery (L1 integration)
    
- namespace metadata publication
    
- zone graph publication
    
- alias enumeration
    
- cross‑namespace referrals
    
- trust‑domain filtering
    
- degraded‑mode fallback
    

### Behavior

Directory endpoints act as the **authoritative source of truth** for a namespace. They maintain:

- a registry of all nodes
    
- a registry of all services
    
- alias bindings
    
- zone graph topology
    
- administrative metadata
    
- last‑known identity locations
    
- trust‑domain membership
    

### Example

```
UN-FLEET:AgathaKing:Directory
OPA:Ceres:Directory
IND:RedshiftHauler:Directory
```

---

## 3.2 Router Endpoint

### Addressing

```
<System>:Router
<Zone>:Router
```

### Responsibilities

- ephemeris caching
    
- contact‑window prediction
    
- link‑state gossip
    
- routing hints
    
- jurisdiction‑aware path selection
    
- degraded‑mode fallback
    
- custody preference signaling
    

### Behavior

Routers maintain:

- predicted position and velocity
    
- predicted alignment windows
    
- predicted link quality
    
- historical link performance
    
- jurisdictional constraints
    
- trust‑domain routing rules
    
- last‑known‑good paths
    

Routers exchange updates via **signed, incremental gossip**.

### Example

```
UN-FLEET:Router
UN-FLEET:AgathaKing:Router
OPA:Ceres:Router
```

---

## 3.3 Broadcast Endpoint

### Addressing

```
<System>:Broadcast
<Zone>:Broadcast
```

### Responsibilities

- emergency alerts
    
- maintenance announcements
    
- telemetry fan‑outs
    
- namespace‑wide coordination
    

Broadcast MUST bypass aliasing and resolution. Broadcast MUST function even in degraded mode.

---

## 3.4 Wildcard Endpoint

### Addressing

```
<System>:*
<Zone>:*
```

### Responsibilities

- catch‑all handler
    
- administrative fallback
    
- degraded‑mode resolution
    
- debugging and diagnostics
    

Wildcard endpoints MUST NOT impersonate Directory or Router endpoints.

---

# 4. Hierarchical Discovery

DRE endpoints exist at **every level** of the namespace hierarchy.

### Example: UN Fleet

```
UN-FLEET:Directory
UN-FLEET:Router
UN-FLEET:Broadcast

UN-FLEET:AgathaKing:Directory
UN-FLEET:AgathaKing:Router
UN-FLEET:AgathaKing:Ops:Directory
UN-FLEET:AgathaKing:Ops:Bridge:Directory
```

Queries MAY be directed at any level. Routers and directories MAY refer queries upward or downward.

---

# 5. Identity Lookup

Directory endpoints MUST support:

- identity → location
    
- identity → endpoint
    
- identity → trust domain
    
- identity → last‑known zone
    
- identity → last‑known service
    

### Example Query

```
Find: Adm Souter
```

### Example Response

```
Identity: Adm Souter
Location: UN-FLEET:AgathaKing:Ops:Bridge
LastSeen: 2364.03.20T12:44Z
Confidence: 0.92
TrustDomain: UN-MIL-HIGH
```

---

# 6. Ephemeris Caching

Routers MUST maintain:

- predicted position
    
- predicted velocity
    
- predicted alignment windows
    
- predicted link quality
    
- prediction error bounds
    

Caches MUST include:

- timestamp
    
- prediction horizon
    
- decay rate
    

Routers MUST degrade stale ephemeris using:

- time‑based TTL
    
- motion‑based error growth
    
- jurisdictional overrides
    

---

# 7. Contact‑Window Prediction

Routers MUST compute:

- next contact window
    
- window duration
    
- expected bandwidth
    
- expected latency
    
- custody preference
    

Routers MAY use:

- orbital models
    
- historical link performance
    
- peer gossip
    
- jurisdictional constraints
    

---

# 8. Identity Caching

Routers and directories MUST cache:

- last‑known location
    
- last‑known zone
    
- last‑known endpoint
    
- last‑known trust domain
    

Caches MUST include TTLs. Routers MUST gossip identity updates.

---

# 9. Gossip Propagation

Routers MUST exchange:

- ephemeris deltas
    
- identity deltas
    
- link‑state changes
    
- zone availability
    
- trust‑domain changes
    
- emergency overrides
    

Gossip MUST be:

- incremental
    
- compressed
    
- signed
    
- rate‑limited
    
- jurisdiction‑aware
    

Gossip MUST function opportunistically across intermittent links.

---

# 10. Wildcard Resolution

Wildcard endpoints MAY:

- forward queries
    
- provide fallback responses
    
- return administrative metadata
    
- assist in degraded mode
    

Wildcard endpoints MUST NOT:

- impersonate Directory
    
- impersonate Router
    
- override explicit bindings
    

---

# 11. Degraded Mode Behavior

If **Router** fails:

- nodes use cached ephemeris
    
- Directory handles limited routing
    
- wildcard handles fallback
    
- broadcasts remain functional
    

If **Directory** fails:

- nodes use cached identity
    
- Router handles limited identity lookup
    
- wildcard handles fallback
    

If **both** fail:

- namespace enters “dark mode”
    
- only L1 resolution works
    
- DTN bundles queue until contact resumes
    
- broadcasts MUST still function
    

---

# 12. Administrative Controls

Namespaces MUST support:

- alias creation/deletion
    
- zone creation/deletion
    
- node reassignment
    
- service override
    
- route override
    
- cache flush
    
- forced gossip
    
- emergency lockdown
    
- registry inspection
    

Administrative actions MUST be logged.

---

# 13. Security Considerations

DRE endpoints MUST:

- sign gossip updates
    
- validate signatures on received gossip
    
- reject spoofed Directory entries
    
- reject poisoned ephemeris
    
- enforce trust‑domain boundaries
    
- prevent wildcard escalation attacks
    

Authorization is handled by L5, but DRE MUST provide:

- caller zone
    
- caller node
    
- caller trust domain
    
- caller identity
    

---

# 14. Examples

## UNN Fleet Example

```
UN-FLEET:Directory
UN-FLEET:Router
UN-FLEET:Broadcast

UN-FLEET:AgathaKing:Directory
UN-FLEET:AgathaKing:Router
UN-FLEET:AgathaKing:Ops:Directory
```

## Belt Station Example

```
OPA:Ceres:Directory
OPA:Ceres:Router
OPA:Ceres:Broadcast
```

## Independent Hauler Example

```
IND:RedshiftHauler:Directory
IND:RedshiftHauler:Router
```

---

# 15. Compliance

A namespace implementation is compliant with RFC‑2364 if it:

- implements Directory, Router, Broadcast, and Wildcard endpoints
    
- maintains ephemeris and identity caches
    
- participates in gossip
    
- supports degraded mode
    
- enforces signature validation
    
- exposes caller context to L5
    
- logs administrative actions
    

---

# End of RFC‑2364