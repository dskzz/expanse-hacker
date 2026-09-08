# SolNet Corpus Glossary

*Shared reference for terms used across multiple SolNet RFCs — institutions,
doctrine, world-building, and cross-cutting concepts.*

**Scope note:** this is the institutional/doctrinal/world-building glossary.
It is a different, complementary thing from `db/vocabulary.json`, which is
the narrower protocol-technical vocabulary hand-extracted from RFC-2300
(UUID-S7, LocationChain/ServiceChain grammar, the Location/Service plane
and L0/L1 layer names). Consult both — this file for "what is OPRA / what
does Exposure mean," `db/vocabulary.json` for "what does the address
grammar actually require."

**Standing rule (locked 2026-09-05):** the first time an RFC-in-progress
introduces a term that belongs here (e.g. `ServicePlane`), footnote it at
that RFC's point of first use *and* add it to this file. Per-RFC footnotes
stay local and self-contained; this file is the corpus-wide cross-reference
so later RFCs don't have to redefine the same term from scratch.

---

## Setting and Frame

**The Expanse** — A narrative universe defined by multi-faction politics,
frontier conditions, and realistic constraints on communication,
governance, and technology. Used as the tonal and structural foundation
for SolNet's institutional voices.

**SolNet** — A system-wide communication and governance architecture
spanning Inner Worlds, Belt, and frontier territories. SolNet defines
layered protocols, institutional authorities, and deterministic
communication behavior. Serves as the backbone for interplanetary
coordination, standards, and political negotiation.

**SolNet Layer Model** — A structured, multi-layer communication
architecture defining responsibilities, boundaries, and permitted
interactions between protocol layers. Designed to prevent semantic drift,
cross-layer contamination, and adaptive behavior.

## Planes

**Authority Plane** — The governance and identity layer of SolNet,
responsible for trust domains, identity resolution, routing policy, and
revocation. Includes institutions such as DIC, SPERB, and OPRA.

**Namespace Plane** — The local identity, service discovery, and session
management layer of SolNet. Handles personal identity, local ACLs, and
namespace resolution.

**Operational Plane** — The physical and data-link layer domain, including
propagation, media constraints, and deterministic relay behavior. Where
ENAG, RNC, and TSRB exert authority. *Reconciliation flag: RFC-2300 does
not currently name a third plane — it names only the Location Plane
(L-stack, legacy alias "Authority Plane") and Service Plane (S-stack,
legacy alias "Namespace Plane"), with L0/L1 described as shared physical/
data-link substrate underneath both, not a plane of its own. "Operational
Plane" as used here and in the RFC-2353 authorship map is a useful working
label for that L0/L1 substrate, but it hasn't been formally reconciled
with RFC-2300's terminology yet. Treat as provisional until that
reconciliation happens — don't assume it's a fourth co-equal plane
alongside Authority/Namespace without checking RFC-2300 first.*

## Governance and Process

**Governance** — The system of rules, authorities, and processes that
define how SolNet decisions are made, enforced, and revised. Includes
registries, councils, enforcement bureaus, and procedural bodies.

**RFC** — A structured, versioned document defining SolNet standards,
protocols, behaviors, or specifications. RFCs are authoritative and
prevent semantic drift across factions and environments.

**Prompt Bundle** — A reusable collection of prompt blocks, voices,
constraints, and glossaries used to generate SolNet documents. Equivalent
to a standards drafting toolkit.

**Doctrine** — A foundational set of principles that guide SolNet
behavior, interpretation, and decision-making. Enforced by DIC and SPERB.

**Determinism** — A core SolNet principle requiring identical inputs to
produce identical outputs across all environments. Prevents exposure,
drift, and adaptive behavior.

**Exposure** — Any leakage of internal state, operational conditions, or
contextual information through observable behavior. NEEB enforces strict
non-exposure doctrine.

**Adaptive Behavior** — Any output that changes in response to internal
state, environment, or probing. Prohibited in SolNet's operational layers.

**Revocation** — A terminal action removing trust, identity, or routing
authority from a SolNet entity. Governed by SPERB and DIC.

**Trust Domain** — A bounded region of authority defining identity,
routing, and governance relationships. Managed by Authority Plane
institutions.

**Authority Domain** — A jurisdictional boundary defining what an
institution controls within SolNet. Prevents overlap and doctrinal
conflict.

**Authority** (bare, as in "set by Authority policy") — Distinct from
Authority Plane (the layer, above) and Authority Domain (the
jurisdictional boundary, above): "the Authority" is the policy-setting
body whose determinations — a canonical interval, a hop-limit ceiling,
an admission policy — bind relay behavior within a deployment, without
those determinations being published as protocol constants in the RFC
that defines the field they govern (RFC-2353 §6 and §1.6 both handle
T_adv and H_max this way). Which specific institution or process
actually constitutes "the Authority" in a given trust domain is a Trust
Domain / RFC-2362 question — no individual RFC resolves it, and none is
expected to.

**Invariance Doctrine** — The SolNet-wide principle that observable
protocol behavior MUST NOT vary based on unstated internal conditions —
who's asking, what state a relay is actually in, what an implementer
would prefer to reveal under different circumstances. Enforced
primarily by DIC. A document satisfies it by holding behavior constant
field-by-field and structurally, not by any single compliance
statement (see RFC-2353 §1.4 and §11 for a worked example: the
doctrine applied to a Layer-1 advertisement mechanism section by
section, then affirmed once as a whole rather than repeated for each
section).

## Technical / Registry Concepts

**Registry** — The canonical source of truth for identifiers, TLV codes,
and structured elements. Managed by CBR.

**TLV** — A structured encoding format consisting of Type, Length, and
Value fields. Used throughout SolNet for canonical, deterministic
encoding.

**Mask** — A structured bitfield encoding capabilities or classes. Must be
registry-aligned and deterministic.

**Relay** — A communication node operating under deterministic
constraints, responsible for forwarding frames without adaptive behavior.
Relay behavior is governed by RNC, NEEB, and TSRB.

**DTN (Delay/Disruption-Tolerant Networking)** — The networking paradigm
underlying SolNet's Layer-1 design: store-and-forward behavior for links
with long, variable, or unpredictable delay (light-lag across
interplanetary distances, intermittent line-of-sight, spin-shift
occlusion), rather than an assumption of persistent, low-latency
connectivity. A relay "in a DTN partition" has, at least temporarily, no
path to forward traffic over — RAP's own propagation model (RFC-2353
§1.6) and its capability mask's DTN-Aware bit (§3.1) both treat this as
a normal, expected operating condition, not a failure state.

**Canonical Interval** — A fixed, Authority-set emission period a given
periodic signal MUST hold to regardless of load or operational state,
used across SolNet to keep a signal's own timing from becoming a side
channel. RFC-2353 §6 is the worked example: its canonical interval is
denoted T_adv, and — consistent with the Authority entry above — is
never published as a numeric protocol constant, only referenced as a
per-deployment policy parameter.

## Belt / Environmental

**Spin-Shift** — A rotating station or habitat's own spin periodically
carrying a relay's antenna or terminal out of alignment, interrupting
line-of-sight or beam-aimed communication (tightbeam especially) for
part of every rotation. A normal, cyclical operating condition for
spin-gravity Belt infrastructure, not a fault. RFC-2353 §8 treats a
relay's re-advertisement after a spin-shift gap the same as any other
DTN-partition recovery — one early advertisement allowed, then back to
the canonical interval like everyone else.

## Political Geography

**Faction** — A political, economic, or cultural group with its own
goals, governance, and operational doctrine. SolNet institutions often
mediate between factions.

**Inner Worlds** — Centralized political bodies with strong governance,
stable infrastructure, and formal standards processes. Often contrasted
with Belt pragmatism.

**Belt** — A frontier region defined by resource scarcity, decentralized
authority, and pragmatic operational culture. Influences OPRA's tone and
doctrine.

**Outer Worlds** — Peripheral territories with limited oversight and
emergent political identities. Often rely heavily on SolNet for
coordination.

**Frontier Conditions** — Operational environments characterized by
scarcity, risk, degraded infrastructure, and limited oversight. Shape the
tone and behavior of OPRA and Belt institutions.

**Operational Culture** — The shared behaviors, norms, and decision-making
patterns of a faction or institution. OPRA, Belt groups, and Inner Worlds
each have distinct cultures.
