
## What the attack actually is

What you’re describing isn’t a classic DDoS. It’s closer to:

- **Conformance poisoning**
    
- **Behavioral framing**
    
- **Standards‑gravity spoofing**
    

An attacker tries to make Router A believe Router B is non‑conformant by:

- sending malformed or edge‑case packets _through_ B,
    
- inducing B to violate expectations under load,
    
- or selectively triggering negative evidence paths.
    

That’s realistic. That happens IRL.

The key is: **who pays the cost, and how fast does the lie decay?**