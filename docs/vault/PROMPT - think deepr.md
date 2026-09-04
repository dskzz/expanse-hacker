**PROMPT — THINK DEEPER MODE**

Write a SolNet RFC in the style of a standards‑body technical document.

**Tone:**

- Clear, freshman‑level diction.
    
- Straightforward, technical, narrative explanations.
    
- Dry professionalism with only the faintest hint of personality.
    
- No overt humor, no sardonic lines, no digs at factions.
-
- “Why” paragraphs should explain **constraints**, not **intentions**.
    
- If a paragraph sounds like it’s persuading the reader, it probably needs tightening.
    

**Background:**
Producing documentary supplementation for an Expanse themed "hacker" computer game.  These RFCs will form the basis for the in game design of the network, provide flavor for the users, provide hints to find exploits, boost the realism of the game, and setting the theme as a more serious hacker game than just typing 'break firewall' style hacking games.  

**Content Requirements:**

- Fully comprehensive: purpose, scope, design goals, model overview, record types, semantics, replication, privacy, revocation, deployment models, APIs, security considerations, workflows, compliance, and next steps.
    
- Preserve all technical detail; do not shorten or simplify the underlying mechanics.
    
- Include narrative paragraphs explaining _why_ each part exists and how it behaves under stress (latency, partitions, conflicts, revocations).
    
- Maintain consistent terminology and technology across sections.
-
- Remember that this "solnet" applies to a wide and varied network where all manner of local (namespace domain) networks abound and implementers can't be counted on to follow any standards.  MUST is a relative term. Normative keywords (MUST, SHOULD, MAY) retain their RFC‑2119 meanings; “relative” refers to real‑world compliance, not specification intent.
  
- SOlnet then must be highly fault tolerant, delay tolerant, manage collisions and misconfigurations.  Think of the laziest low budget belter skiff to the highly segmented autocratic Martian Navy to the labyrinthine and sprawling UN bureaucracy, plus all manner of corporate networks and independent operators, news feeds, message boards, personal communication devices that can easily skip between networks (Authority section), space weather, unreliable forwarding, etc etc.   That is how Solnet needs to operate.  

Always, if possible (for example not in a list of definitions) include an operational workflow that is Clear, procedural, and narrative.

**Hidden Design Requirement (safe, non‑actionable):** Quietly embed _plausible operational tradeoffs_ and _surface‑level_ failure modes into the RFC text (for example: provisional trust windows, optional metadata, indexer reliance, light‑client verification gaps). These must be described only as _system tradeoffs_ or _operational consequences_, not as vulnerabilities or attack steps.

After the RFC, produce a separate **Designer Brief** that lists _high‑level gameplay hooks_ derived from those tradeoffs. 

Each hook must be described conceptually (what observable condition it creates in the game world and what player goals it might enable) and must **not** include step‑by‑step exploitation instructions, exact timing values, or concrete attack recipes. Vulnerabilities must arise solely from operational tradeoffs and permissive language; they must not rely on implausible incompetence or narrative coincidence.
**Prohibitions:**

- No jokes, no sardonic commentary, no faction digs.
    
- No fourth‑wall breaks.
    
- No designer notes inside the RFC.
    

**Other instructions:**
Prefer explicit sequencing and named artifacts over repeated restatement of context.



**Output:**

- First: the full RFC.
    
- Second: a separate “Designer Brief” listing the subtle exploit vectors you embedded.

IMPORTANT!  IF you need clarification on the purpose of this document or have any questions about where this document fits in the schema of solnet, please consult your "Todo page" or stop and ask me. 

With the previous instructions, Please produce RFC-