---
title: RFC 2353 - L1 Relay Advertisement Protocol
type: rfc
generated: '2026-05-15'
rfc_number: 2353
status: Standards Track
revision_date: 2353.03.19
authors:
- institution: SolNet Standards Working Group
- institution: Independent Relay Operators Consortium
---

**Abstract:**

The SolNet L1 Relay Advertisement Protocol (LRAP) standardizes the format and content of relay advertisements exchanged between adjacent nodes in the SolNet network. This document specifies the RelayAdvertisement record structure, including capability masks, scheduling capacity fields, and admission policy hooks necessary for relays to effectively advertise their capabilities to neighboring nodes. By establishing a consistent and interoperable advertisement protocol, LRAP enables efficient relay discovery and selection in the SolNet delay-tolerant network.

---

### 1. Purpose

This RFC defines the SolNet L1 Relay Advertisement Protocol (LRAP), which standardizes the format for relay nodes to advertise their capabilities, load state, and admission policies across the SolNet network.

Without standardized relay advertisement, routing decisions degrade into guesswork, where connectivity is established based on incomplete or inaccurate information. Guessing has historically gone poorly; it introduces instability and wastes resources. LRAP addresses this issue by establishing a consistent format for relay advertisements, ensuring that nodes can accurately assess the capabilities and load of relays before engaging in communication.

LRAP enables efficient relay discovery and selection within SolNet, allowing for more reliable routing decisions and improved overall network performance. By standardizing relay advertisement, we prevent unnecessary errors and reduce the risk of network instability caused by miscommunication between nodes.