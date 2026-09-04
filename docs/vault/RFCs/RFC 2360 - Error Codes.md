# RFC‑2360: SolNet Error Code Registry

_SolNet Standards Working Group (SSWG)_  
_Revision Date: 2360.03.20_  
_Status: Standards‑Track_

---

## 1. Purpose

This document defines the **canonical registry of SolNet error codes**, used across:

- Zone Gateways
    
- DTN relays
    
- PNS resolvers
    
- NNS authorities
    
- personal devices
    
- application‑layer protocols
    

The goal is to ensure consistent diagnostics, predictable retry behavior, and interoperable error handling across all SolNet‑participating networks.

---

## 2. Error Code Structure

SolNet error codes follow this format:

```
<3‑digit code>_<UPPERCASE_REASON>
```

Codes are grouped by class:

- **1xx — Informational**
    
- **2xx — Success / Acknowledgement**
    
- **3xx — Redirect / Re‑resolution**
    
- **4xx — Client / Originator Errors**
    
- **5xx — Gateway / Relay Errors**
    
- **6xx — Security / Trust Errors**
    

---

## 3. Informational Codes (1xx)

### **100_CONTINUE**

Processing will continue; no action required.

### **101_STALE_PNS_ENTRY**

Resolver is returning stale data; retry recommended.

### **102_DELAYED_DELIVERY**

Bundle accepted but delivery will be delayed due to routing constraints.

---

## 4. Success Codes (2xx)

### **200_OK**

Operation succeeded.

### **201_CUSTODY_ACCEPTED**

Relay has accepted custody of the bundle.

### **202_ROUTE_UPDATED**

Routing metadata successfully refreshed.

---

## 5. Redirect Codes (3xx)

### **300_RETRY_WITH_UPDATED_PNS**

Originator should re‑resolve destination via PNS.

### **301_FORWARD_TO_GATEWAY**

Bundle must be forwarded to a different gateway.

### **302_ALT_RELAY_AVAILABLE**

A more optimal relay is available; reroute recommended.

---

## 6. Client / Originator Errors (4xx)

### **400_BAD_UUID**

Malformed or unknown UUID.

### **401_UNAUTHORIZED_SENDER**

Sender lacks permission to transmit to this namespace.

### **402_INVALID_NNS_ADDRESS**

Local namespace address is invalid or unresolvable.

### **404_UNRESOLVED**

PNS or UUID resolution failed.

### **405_UNSUPPORTED_VERSION**

Protocol version not supported by gateway or relay.

### **410_EXPIRED_TTL**

Bundle TTL expired before delivery.

### **411_PAYLOAD_TOO_LARGE**

Payload exceeds maximum bundle size.

### **429_RATE_LIMITED**

Sender exceeded allowable transmission rate.

---

## 7. Gateway / Relay Errors (5xx)

### **500_INTERNAL_GATEWAY_ERROR**

Generic gateway failure.

### **501_NO_ROUTE_AVAILABLE**

Relay cannot determine a viable route.

### **502_CONTACT_WINDOW_CLOSED**

Relay contact window unavailable.

### **503_STORAGE_EXHAUSTED**

Relay cannot accept custody due to storage limits.

### **504_HOP_LIMIT_EXCEEDED**

Bundle exceeded maximum hop count.

### **520_GATEWAY_POLICY_BLOCK**

Transmission blocked by gateway policy.

### **521_CONGESTION_BACKPRESSURE**

Relay is congested; sender should retry later.

---

## 8. Security / Trust Errors (6xx)

### **600_INVALID_SIGNATURE**

Signature verification failed.

### **601_UNTRUSTED_DOMAIN**

Sender belongs to a low‑trust or unknown domain.

### **602_KEY_REVOKED**

Sender’s key has been revoked.

### **603_PNS_POISONING_SUSPECTED**

Resolver detected conflicting or malicious PNS data.

### **604_GATEWAY_ATTESTATION_FAILED**

Gateway failed trust‑domain attestation.

### **605_ENCRYPTION_REQUIRED**

Payload must be encrypted for this route or domain.

---

## 9. Diagnostic Bundle Format

Error responses MAY be returned as diagnostic bundles containing:

```
Error Code
Timestamp
Originating Node
Affected UUID
Optional Debug Message
Signature
```

Diagnostic bundles MUST NOT contain payload data.

---

## 10. Retry & Backoff Rules

Nodes SHOULD:

- retry 4xx errors with exponential backoff
    
- retry 5xx errors only when contact windows reopen
    
- NOT retry 6xx errors without operator intervention
    

Nodes MUST:

- log all 5xx and 6xx errors
    
- propagate diagnostic bundles to local monitoring systems
    

---

## 11. Example Error Flow

A device on **Tycho Station** attempts to contact a user on **Ceres PublicNet**.

1. Tycho resolver returns stale PNS entry → `101_STALE_PNS_ENTRY`.
    
2. Device retries with fresh PNS lookup.
    
3. Tycho Gateway forwards bundle.
    
4. Mars L4 Relay rejects due to congestion → `521_CONGESTION_BACKPRESSURE`.
    
5. Device retries after backoff.
    
6. Bundle delivered successfully.
    

---

## 12. Summary

RFC‑2360 defines the unified error code registry for SolNet. It ensures:

- consistent diagnostics
    
- predictable retry behavior
    
- interoperable error handling
    
- clear separation of client, gateway, and security failures
    

This registry is mandatory for all SolNet‑compliant nodes, gateways, and relays.