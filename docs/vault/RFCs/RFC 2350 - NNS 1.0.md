# 📘 **RFC‑2350 — SolNet Canonical Addressing Standard**

_SolNet Standards Working Group (SSWG)_ _Status: Standards‑Track_

# **1. Purpose**

SolNet operates across a solar system defined by:

- light‑lag measured in minutes to hours
    
- solar‑weather disruptions
    
- mobile nodes (ships)
    
- competing jurisdictions
    
- untrusted intermediaries
    
- unreliable hardware
    
- pirate and independent operators
    
- military‑grade cryptography
    

This RFC defines the **canonical addressing format** for all SolNet entities, including:

- ships
    
- stations
    
- repeaters
    
- services
    
- endpoints
    
- users
    
- autonomous agents
    

This addressing model is the foundation for:

- L1 (Local Namespace Layer)
    
- L2 (Identity Resolution)
    
- L2.5 (Jurisdiction & Trust Domains)
    
- L3 (Directory & Routing Endpoints)
    
- L4 (Ephemeris Routing)
    
- L5 (Security & Permissions)
    

# **2. Design Principles**

SolNet addressing must:

- survive political fragmentation
    
- survive solar‑weather disruptions
    
- survive ship loss
    
- survive namespace inconsistency
    
- survive pirate misuse
    
- survive lazy operator behavior
    
- support unlimited depth
    
- support minimal domains
    
- support trust‑domain resolution
    
- support cryptographic identity
    
- support ledger‑based uniqueness
    
- support delay‑tolerant routing
    
- support mixed namespace structures
    

The model must be:

- simple
    
- expressive
    
- unambiguous
    
- faction‑agnostic
    
- future‑proof
    
- tolerant of chaos
    

# **3. Canonical Addressing Model**

The canonical SolNet address is:

# **AuthorityChain // NamespaceChain**

Where:

### **AuthorityChain**

Defines identity authority, trust domain, jurisdiction, and routing boundary.

### **NamespaceChain**

Defines internal namespace, zone, node, service, endpoint, or user.

### **Both chains:**

- unlimited depth
    
- `:`‑separated segments
    
- free‑form within their respective domains
    

### **The** `//` **delimiter**

Is the **only universal boundary** between identity and namespace.

# **4. AuthorityChain**

The **AuthorityChain** defines:

- who vouches for the identity
    
- which trust domain applies
    
- which routing boundary applies
    
- which Directory/Router endpoints govern the domain
    
- which cryptographic identity anchors must be validated
    

### **Structure**

Code

```
<Authority> : <Network> : <Tier> : <Unit> : <Assignment> : ...
```

### **Examples**

Code

```
UN-FLEET:AgathaKing
MCRC:ALPHAFLEET:DONNAGER
OPA:Tynan
IND:RedshiftHauler
TYCHO:Station
MEDINA:Station
```

### **Minimal Domains Allowed**

Code

```
LITTLESKIFF
BlackFlag
ScavBoat12
```

### **Rules**

- Unlimited depth
    
- May be a single segment
    
- Must be paired with cryptographic identity anchors
    
- Must define or inherit a trust domain
    

# **5. NamespaceChain**

The **NamespaceChain** defines:

- where inside the domain the entity resides
    
- what service or endpoint is being addressed
    
- the internal topology of the domain
    

### **Structure**

Code

```
<Zone> : <Node> : <Service> : <Endpoint/User> : ...
```

### **Examples**

Code

```
ENGINEERING:ENG-1:Reactor:SomeGuy
MARDET:LtLopez
Ops:Bridge:LtKhan
Nav:Lopez
Gunnery1
```

### **Empty Namespace Allowed**

Code

```
LITTLESKIFF//
```

Meaning: “the domain root.”

### **Rules**

- Unlimited depth
    
- Fully controlled by the domain operator
    
- May be flat, deep, mixed, or inconsistent
    
- Must be resolvable by L1
    
- Must not leak outside the domain
    

### **Reserved Endpoints**

For well‑known namespace endpoints (e.g., `//info`, `//contact`), **see RFC‑2364 (Directory & Routing Endpoints).**

# **6. Identity Anchors**

Every domain MUST have:

## **6.1 NetworkID — UUID‑S7 (SolNet Universal Identifier)**

A globally unique **UUID‑class identifier** (128‑bit), using a SolNet‑era extension of the UUIDv7 format.

UUID‑S7 identifiers are:

- time‑sortable
    
- cryptographically strong
    
- globally unique
    
- ledger‑friendly
    
- compatible with legacy UUID tooling
    
- suitable for trust‑domain binding
    

### **Notes**

- MUST be globally unique
    
- MUST be stable for the lifetime of the domain
    
- MUST be bound to NetworkKey via NetworkCert
    
- SHOULD be anchored in the ledger
    
- MAY use SolNet‑specific UUID extensions
    

## **6.2 NetworkKey**

A public key used to sign:

- routing metadata
    
- identity metadata
    
- namespace announcements
    
- DRE registrations
    

## **6.3 NetworkCert**

A signature binding:

Code

```
AuthorityChain → NetworkID(UUID‑S7) → NetworkKey
```

Signed by a trust‑domain authority (UN‑MIL, MCRN‑MIL, OPA‑CIVIL, etc.)

## **6.4 LedgerAnchor (optional but recommended)**

A slow, replicated, append‑only ledger storing:

- NetworkID (UUID‑S7)
    
- AuthorityChain
    
- NetworkKey
    
- trust‑domain signatures
    
- revocation entries
    

This is NOT a cryptocurrency blockchain. It is a **global uniqueness registry**.

# **7. Collision Handling**

AuthorityChain collisions are expected and safe.

Two domains with identical text strings are **not the same domain** unless all identity anchors match.

### **Resolution Order**

1. **NetworkCert + LedgerAnchor** → canonical, authoritative identity
    
2. **NetworkCert only** → trusted but not globally anchored
    
3. **LedgerAnchor only** → globally unique but not trusted
    
4. **Self‑asserted** → UNVERIFIED (lowest trust)
    

### **Outcome**

A pirate spoofing:

Code

```
MCRC:ALPHAFLEET:DONNAGER//
```

Without the correct NetworkCert becomes:

Code

```
MCRC:ALPHAFLEET:DONNAGER//  (UNVERIFIED)
```

And is treated as a completely different domain.

# **8. Left‑Hand vs Right‑Hand Resolution**

The two halves of a SolNet address resolve in **fundamentally different ways**.

## **8.1 AuthorityChain (Left‑Hand Side)**

**Global Resolution** Handled by L2 and L2.5.

**Propagation Direction** Outward — identity must be recognized across the solar system.

**Carries Location Metadata** Yes. Because:

- ships move
    
- repeaters drift
    
- ephemeris changes
    
- solar weather affects routing
    
- trust domains have jurisdictional boundaries
    

**Identity Anchors Required** NetworkID(UUID‑S7), NetworkKey, NetworkCert, LedgerAnchor.

**Used By** L2, L2.5, L3, L4, L5.

## **8.2 NamespaceChain (Right‑Hand Side)**

**Local Resolution** Handled entirely by L1.

**Propagation Direction** Inward — namespace is defined by the domain itself.

**Carries Location Metadata** No. It is not used for inter‑domain routing.

**Identity Anchors Required** None.

**Used By** L1 only.

# **9. Why AuthorityChain Carries Ephemeris & Routing Metadata**

Because SolNet is a delay‑tolerant, mobile, solar‑weather‑sensitive network.

AuthorityChain must carry:

- ephemeris hints
    
- routing policy
    
- trust‑domain metadata
    
- jurisdictional boundaries
    
- ledger anchors
    
- signature chains
    

This enables:

- interplanetary routing
    
- trust‑domain enforcement
    
- packet provenance
    
- collision avoidance
    
- ship‑as‑router behavior
    

# **10. Why NamespaceChain Does Not**

NamespaceChain is:

- local
    
- internal
    
- domain‑defined
    
- not used for routing
    
- not used for trust
    
- not used for ephemeris
    
- not used for identity
    

It is simply a **local path** inside the domain.

# **11. Full Canonical Form**

### **Unlimited canonical form**

Code

```
<AuthorityChain> // <NamespaceChain>
```

### **Recommended 5‑level variant**

Code

```
<Network>:<Domain> // <Zone>:<Node>:<Service>
```

### **Extended 6‑level variant**

Code

```
<Network>:<Domain> // <Zone>:<Node>:<Service>:<Endpoint/User>
```

### **PNI (Personal Namespace Identifier)**

Code

```
<Identity>@<AuthorityChain>
```

### **Ultra‑shorthand (local domain)**

Code

```
<Identity>
```

# **12. Examples**

### **Martian deep structure**

Code

```
MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG-1:Reactor:SomeGuy
```

### **Mixed internal structures**

Code

```
MCRC:ALPHAFLEET:DONNAGER//ENGINEERING:ENG-1:Reactor:SomeGuy
MCRC:ALPHAFLEET:DONNAGER//MARDET:LtLopez
```

### **OPA flat**

Code

```
OPA:Tynan//Gunnery1
OPA:Tynan//Reactor
```

### **UN semi‑structured**

Code

```
UN-FLEET:AgathaKing//Ops:Bridge:LtKhan
```

### **Independent minimal**

Code

```
IND:RedshiftHauler//Nav:Lopez
```

### **Pirate minimal domain**

Code

```
BlackFlag//
```

# **13. Parsing Rules**

- `//` MUST appear exactly once
    
- `:` separates segments
    
- case‑sensitive
    
- preserve order
    
- collapse duplicate delimiters
    
- trim whitespace
    

# **14. Resolution Rules**

### **AuthorityChain**

Resolved globally using:

- NetworkID(UUID‑S7)
    
- NetworkKey
    
- NetworkCert
    
- LedgerAnchor
    
- TrustDomain
    

### **NamespaceChain**

Resolved locally by L1.

### **Cross‑domain resolution**

Handled by L2.5 and L4.

# **15. Security Considerations**

- AuthorityChain MUST be cryptographically bound to NetworkID(UUID‑S7)
    
- NamespaceChain MUST NOT be trusted for identity
    
- `//` boundary MUST be enforced
    
- spoofed AuthorityChains MUST be rejected
    
- unanchored domains MUST be treated as UNVERIFIED
    
- trust domains MUST be validated
    
- LedgerAnchor MUST be checked when available
    

# **16. Compliance**

A SolNet implementation is compliant with RFC‑2350 if it:

- supports AuthorityChain // NamespaceChain
    
- supports unlimited depth
    
- supports empty NamespaceChain
    
- supports PNI
    
- supports NetworkID(UUID‑S7), NetworkKey, NetworkCert
    
- supports LedgerAnchor
    
- enforces collision‑handling rules
    
- enforces the `//` boundary
    
- integrates with L1, L2, L2.5, L3, L4, and L5
    

# **17. References**

- RFC‑2363 — Identity Resolution (L2)
    
- RFC‑2364 — Directory & Routing Endpoints (DRE Layer)