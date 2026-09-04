# **RFC‑2359: Bundle Addressing Protocol (BAP 1.0)** 

_SolNet Standards Working Group (SSWG)_ _Revision Date: 2350.06.01_ _Status: Informational / Non‑Binding_

## **Abstract**

This document describes the **Bundle Addressing Protocol (BAP)**, the de‑facto method for addressing, forwarding, and routing **Delay‑Tolerant Network (DTN)** bundles across the Sol System.

BAP is not a real‑time protocol. It is not a streaming protocol. It is not a guarantee of delivery.

It is a **best‑effort, store‑and‑forward, opportunistic routing system** designed for a solar system where:

- light‑speed delays are unavoidable
    
- nodes move
    
- links fail
    
- solar weather interferes
    
- politics interfere more
    

BAP is the glue that holds the SolNet together.

## **1. Introduction**

Traditional packet‑switched networking (e.g., the pre‑expansion Internet) assumed:

- low latency
    
- stable links
    
- continuous connectivity
    

None of these assumptions hold in interplanetary space.

BAP was developed to address the realities of:

- multi‑minute to multi‑hour delays
    
- intermittent connectivity
    
- mobile nodes (ships, drones, stations)
    
- solar interference
    
- factional routing policies
    
- opportunistic relays
    

BAP is the addressing layer that sits beneath the **Network Namespace Specification (NNS)** and above the physical comms layer.

## **2. Goals of BAP**

BAP is designed to:

- identify endpoints using NNS addresses
    
- allow bundles to be forwarded hop‑by‑hop
    
- tolerate long delays
    
- tolerate node mobility
    
- allow routing decisions to be local
    
- allow routing policies to be political
    
- allow bundles to survive partial outages
    
- allow operators to inspect, modify, or inject bundles
    

BAP is intentionally simple. Complexity belongs in routing policies, not the protocol.

## **3. Bundle Structure**

A BAP bundle consists of:

Code

```
{
  "id": <UUID>,
  "source": <NNS Address>,
  "destination": <NNS Address>,
  "priority": <0–9>,
  "ttl": <seconds>,
  "chunks": <count>,
  "routing_hints": [<string>],
  "metadata": { ... },
  "payload": <opaque binary>
}
```

### **3.1 Notes**

- Bundles may be fragmented into chunks.
    
- Chunks may arrive out of order.
    
- Chunks may arrive via different paths.
    
- Bundles may be reassembled at any node with sufficient authority.
    
- Bundles may be inspected, modified, or forged by nodes with access.
    

This is a feature, not a bug.

## **4. Addressing**

BAP uses **full NNS addresses** for source and destination.

Example:

Code

```
UN-MILSEC-3 : EARTH : LUNA_L1 : RELAY_02 : COMMS
```

Nodes MAY shorten addresses when operating within a known zone.

Example:

Code

```
RELAY_02:COMMS
```

This is discouraged but common in Belter systems.

## **5. Routing**

BAP does not define a routing algorithm. Routing is **local** and **opportunistic**.

Nodes make forwarding decisions based on:

- known neighbors
    
- predicted link availability
    
- solar weather forecasts
    
- factional routing policies
    
- bandwidth constraints
    
- political considerations
    
- bribes (unofficial)
    

### **5.1 Routing Hints**

Bundles MAY include routing hints.

Examples:

- `"prefer:MCR"`
    
- `"avoid:UN"`
    
- `"via:OUTER_BELT"`
    
- `"window:SOLAR_MINIMUM"`
    

Nodes MAY ignore hints. Pirate networks often spoof them.

## **6. Reliability**

BAP is **best effort**.

Bundles may be:

- delayed
    
- duplicated
    
- dropped
    
- corrupted
    
- intercepted
    
- modified
    
- forged
    

Operators SHOULD NOT assume integrity unless additional security layers are used.

## **7. Security Considerations**

BAP provides **no**:

- encryption
    
- authentication
    
- integrity checking
    
- non‑repudiation
    

Security MUST be implemented at:

- the payload layer
    
- the service layer
    
- the physical layer
    
- or not at all (common in Belter systems)
    

Independent networks (`IND-*`) SHOULD NOT be trusted.

## **8. Operational Considerations**

### **8.1 Solar Weather**

Solar interference affects:

- link reliability
    
- bandwidth
    
- latency
    
- routing availability
    

Nodes SHOULD maintain solar weather forecasts. Belter nodes often do not.

### **8.2 Node Mobility**

Ships and drones move. Routing tables SHOULD be dynamic. Belter routing tables are often static and wrong.

### **8.3 Store‑and‑Forward**

Nodes MUST buffer bundles until:

- a link becomes available
    
- TTL expires
    
- the operator deletes them
    
- the node is destroyed
    

Buffer overflow is a common failure mode.

## **9. Example Bundle**

Code

```
{
  "id": "pkt_abc123",
  "source": "COMM-NEWS-CORE : CERES : BROADCAST_RING : NODE_44 : FEED",
  "destination": "UN-GOVOPS-1 : EARTH : GEO_SYNCH : RELAY_01 : COMMS",
  "priority": 2,
  "ttl": 86400,
  "chunks": 12,
  "routing_hints": ["avoid:MCR", "prefer:INNER_SYSTEM"],
  "metadata": {
    "timestamp": "2350-06-01T12:44:00Z",
    "content_type": "news_feed"
  },
  "payload": "<binary>"
}
```

## **10. Conclusion**

BAP 1.0 is the addressing and forwarding backbone of the SolNet.

It is:

- simple
    
- robust
    
- tolerant of chaos
    
- politically agnostic
    
- technically indifferent
    
- widely adopted
    
- widely abused
    

It works because it has to.

## **Appendix A: Common Routing Policies**

### **UN**

- prefer stable relays
    
- avoid pirate networks
    
- prioritize government traffic
    

### **MCR**

- strict hierarchy
    
- predictable paths
    
- high security
    

### **Belter Stations**

- whatever works today
    
- whatever worked yesterday
    
- whatever someone forgot to disable
    

### **Pirate Networks**

- onion‑routed
    
- spoofed
    
- opportunistic
    
- unreliable
    
- extremely useful
    

## **Appendix B: Known Failure Modes**

- solar flare wipes out half the Belt
    
- relay misalignment
    
- buffer overflow
    
- routing loop
    
- political embargo
    
- sabotage
    
- firmware older than the station itself
    

# ✔ **RFC‑2351 (BAP 1.0) is complete.**

If you want, I can continue with: