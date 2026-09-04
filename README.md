# expanse-hacker

Design and implementation of an Expanse-like hacking game set on a
libertarian, unregulated, delay-tolerant "SolNet" — a network of
networks of networks, with vulnerabilities baked into a corpus of
fake-but-plausible RFCs rather than into a scan/exploit toolkit.

Not a "fake Kali" pentest-keyword simulator: the game rewards actually
understanding the systems it's built from, both software (protocols,
as specified by the RFCs) and physical (relays, buffers, splices —
belter-technician tools, not just a keyboard).

Architecture is deliberately split into three independently
replaceable pieces — engine, content, UI. See
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the current plan
(planning stage — no engine code yet), and
[`docs/lore/os-lineages.md`](docs/lore/os-lineages.md) for the
in-universe history and OS-fork worldbuilding behind it.
