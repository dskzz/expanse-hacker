Game design: plausible exploits and puzzles

- **Spoofed beacon puzzle:** players must detect a fake `ProxBeacon` that mimics a trusted console; clues are mismatched confidence metrics and missing `ProxAuditEvent`.
    
- **Relay‑delegation exploit:** a compromised relay accepts a DelegationToken and claims a transfer; players must trace DelegationReceipts and ledger anchors to prove the relay acted beyond scope.
    
- **Partial transfer ambiguity:** a ProvisionalReceipt exists but no final `ProxTransferReceipt`; players must reconstruct chunk logs and use RF/DTN traces to determine whether a file reached its destination.
    
- **Proximity proof challenge:** players must craft a proximity proof (RSSI + TOF + ultrasonic handshake) to convince a stubborn DRE to accept a transfer as legitimate.
    

## Tradeoffs and recommended defaults

- **Default posture:** ProxLink enabled on devices, **ProxID suppressed**, `requirePhysicalConfirm` for files > small threshold (e.g., 100 KB) or for any PNI‑anchored identity.
    
- **Ledger anchoring:** opt‑in only; anchoring is expensive and slow — use only for high‑value transfers or legal evidence.
    
- **Delegation:** allowed but **short validity** (seconds to minutes) and auditable.
    
- **Compact encodings:** mandatory for constrained devices; receipts must be small but include enough provenance to audit later.
    
