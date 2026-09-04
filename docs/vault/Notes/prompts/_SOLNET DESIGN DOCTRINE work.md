- SolNet enforces **legibility, not fairness**.
    
- Parsing is deterministic; **interpretation is political**.
    
- Extensibility is abundant; **trust is weighted**.
    
- Ledger anchoring is **optional, meaningful, and costly**.
    
- Authority hardens toward the center; **ambiguity increases outward**.
    
- The substrate is boring; **policy and memory create behavior**.
    
- AI may influence preference and confidence, **never syntax or safety**.
#### Namespaces are abundant

- **Abundant TLVs** reduce bottlenecks and let the ecosystem sprawl.
    
- **Namespacing** prevents accidental collisions from becoming existential.
    

#### Preference is not in parsing—it’s in policy

- **Parsing rule:** unknown TLVs are skipped (interop).
    
- **Policy rule:** which TLVs are _trusted_, _acted on_, _forwarded_, _cached_, _charged for_, or _prioritized_ depends on **trust domain policy**.

## Design doctrine

### Purpose

A short, enforceable constitution for design decisions—so every RFC, subsystem, and edge-case ruling can be traced back to a few non-negotiables.

### Scope

- **Applies to:** All SolNet standards, implementations, simulations, and in-universe operator behavior.
    
- **Does not apply to:** Pure lore that doesn’t constrain mechanics; one-off set dressing.
    

## Core axioms

1. **Reality-first simulation**
    
    - Systems behave like engineered networks under stress—latency, loss, misconfig, politics, and scarcity are first-class forces.
        
2. **Layered contracts**
    
    - Every layer has a crisp contract: inputs, outputs, failure modes, and what it refuses to promise.
        
3. **Failure is a feature**
    
    - Degradation paths are designed, not accidental—partial service, stale reads, split-brain, and operator error are expected.
        
4. **Adversarial by default**
    
    - Pirates, lazy operators, compromised nodes, and “works on my station” configs are normal—not edge cases.
        
5. **Faction pressure is protocol pressure**
    
    - Governance, incentives, and enforcement mechanisms are part of the spec surface area.
        
6. **Minimal assumptions, maximal interoperability**
    
    - Specs assume the least about hardware, trust, time sync, and connectivity—compatibility beats elegance.
        

## Design priorities

- **P0: Determinism of contracts** — same inputs, same outcomes (or same declared nondeterminism).
    
- **P1: Observability** — everything important is measurable, loggable, and attributable.
    
- **P2: Operability** — humans can run it badly and it still fails predictably.
    
- **P3: Extensibility** — new factions, link types, and constraints slot in without rewriting the universe.
    
- **P4: Fun through constraints** — vulnerabilities and tradeoffs create gameplay, not arbitrary chaos.
    

## Decision rules

- **If realism conflicts with playability:** keep realism, then add _tools_ (workarounds, black markets, hacks, policy) that make it playable.
    
- **If simplicity conflicts with robustness:** choose robustness, but document the “happy path” as a profile.
    
- **If a feature can’t be observed:** it doesn’t exist (or it must declare how it becomes observable).
    
- **If a layer leaks responsibilities upward:** either formalize the leak as an interface or move the responsibility down.
    

## TLV keys: abundant and namespaced, but politically routed
#### Namespaces are abundant

- **Abundant TLVs** reduce bottlenecks and let the ecosystem sprawl.
    
- **Namespacing** prevents accidental collisions from becoming existential.
    

#### Preference is not in parsing—it’s in policy

- **Parsing rule:** unknown TLVs are skipped (interop).
    
- **Policy rule:** which TLVs are _trusted_, _acted on_, _forwarded_, _cached_, _charged for_, or _prioritized_ depends on **trust domain policy**.

## Collision rules: determinism first, politics second
### Deterministic decoding always

- **Rule:** A TLV is identified by **(namespace, key)**, not key alone.
    
- **Rule:** If a node can’t interpret the namespace, it **skips** the TLV.
    

### Political acceptance is a separate layer

- **Rule:** A node may decode a TLV but still treat it as:
    
    - **ignored**, **informational**, **actionable**, or **forbidden** based on **TrustDomainPolicy** (this is where Earth/Mars/OPA behavior lives).

## Required spec sections for every RFC

- **Contract:** What it guarantees and what it explicitly does not.
    
- **Threat model:** Who breaks it and why.
    
- **Failure modes:** What happens when it goes wrong—by category.
    
- **Operational profile:** Minimal viable deployment + “rich” deployment.
    
- **Interoperability:** Versioning, negotiation, downgrade behavior.
    
- **Abuse cases:** How it gets exploited and what mitigations exist.
    
- **Telemetry:** What must be logged/metric’d and where attribution lands.
    

## Canonical tradeoffs

- **Trust vs reach**
    
- **Consistency vs availability**
    
- **Latency vs verification**
    
- **Central coordination vs local autonomy**
    
- **Security vs salvageability**
    
- **Spec purity vs faction reality**
    


## Anchoring cost and delay: yes, model it—at least procedurally

When I asked whether to model anchoring cost/delay/friction, you asked:

> “Do you mean in the game… giving groups/systems values?”

Yes—and I think your lean is the right one: **model it or procedurally generate it**.

### Why it matters

If you don’t model it, anchoring becomes a handwave and players/operators won’t feel the tradeoffs.

If you do model it, you get emergent behavior:

- “We can anchor this… but it’ll take 6 hours and three bribes.”
    
- “Mars will anchor fast for Martian certs, slow-roll Earth certs.”
    
- “OPA relay will anchor if you pay, but the receipt is ‘soft’ unless cross-signed.”
    
## AI in routing: the rule is “auditable outcomes,” not “no AI”

Your “if AI is involved in routing…” is where paranoia and realism can coexist cleanly.

My opinion:

- AI can route.
    
- AI can optimize.
    
- AI can even enforce policy.
    

But the network must demand:

- **Receipts for consequential actions** (admission, reservation, preemption, drops).
    
- **Reconstructability** (forensics can replay “why did this happen?”).
    
- **Policy provenance** (which trust domain policy caused the decision).
    

So the doctrine becomes: **automation is allowed; unaccountable automation is not.**

That also gives you delicious gameplay:

- “The relay says the AI dropped you for congestion.”
    
- “Prove it—show me the admission receipts and policy pointer.”
    
- “Oops, the policy pointer resolves to a forged DRE record.”
### Minimal workable model

You don’t need a full economy sim. You need a few knobs per trust domain / region / relay:

- **Time cost:** expected delay distribution (minutes → days).
    
- **Energy cost:** power budget impact (especially for small nodes).
    
- **Political friction:** probability of refusal / throttling / extra requirements.
    
- **Monetary cost:** fees, tariffs, “expedite” bribes.
    
- **Assurance level:** how persuasive the anchor is outside the domain.
    

Procedural generation can fill these per station/relay/faction, then you “zoom in” when gameplay demands it.


## Obsidian-ready frontmatter

yaml

```
type: doctrine
system: SolNet
status: canonical
version: 0.1
owner: D
last_updated: 2026-03-27
tags: [solnet, doctrine, standards, rfc, design]
```