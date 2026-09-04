# Satellite/Relay Object Interaction — Design Notes

Status: early concept, not locked. Captures the "fake it, don't fly to it" object-inspection
pattern discussed 2026-09-03, grounded in the SolNet RFCs already drafted in the Obsidian vault.

## Core idea

Player never flies out to the satellite/relay. They select it (from a map, a contact list, a
mission brief) and get a **focused object view**: an illustration or lightweight 3D model of that
one platform, with clickable hotspots on physical features. Clicking a hotspot opens an
**access-terminal panel** — that's where the actual "hacking" happens, expressed as inspecting
and manipulating the SolNet records that RFC-2304/2306/2353 already define.

Two rendering tiers, not mutually exclusive:

- **2D hotspot (default/baseline):** static or lightly animated illustration, clickable regions
  (image maps / Control nodes with click areas). Cheapest to produce, cheapest to iterate on.
  Use this for most objects.
- **3D turntable (upgrade, selective):** single low-poly model, orbit camera, raycast-clickable
  parts. Reserve for hero objects / setpieces where the extra production cost is worth it.

Both tiers feed the same underlying data model, so upgrading an object from 2D to 3D later is an
art/presentation change, not a logic change.

## Anatomy of a relay object

Grounding in what's already specced (RFC-2304 Antenna Geometry, RFC-2306 Tightbeam, RFC-2353
Relay Advertisement), a typical relay/satellite object has these hotspot categories:

| Hotspot | Backing record(s) | What the panel shows |
|---|---|---|
| Antenna / dish mount | `AntennaGeometryRecord`, `AlignmentStateRecord` | pointing vector, mode (idle/acquisition/tracking/re-acquisition), angular error, confidence |
| Tightbeam terminal | `BeamProfileRecord`, `ReservationReceipt`, `AcquisitionReceipt`, `TrackingHeartbeat`, `OcclusionEvent` | beam lifecycle stage (Reservation → Acquisition → Maintenance → Occlusion → Release), last heartbeat, provenance chain |
| Relay core / router unit | `RelayAdvertisement` (RFC-2353) | capability mask, load/scheduling capacity, admission policy hints |
| Ephemeris/nav feed | `EphemerisRecord` | source, freshness, stated error bounds — this is a *trust* surface, not just a data readout |
| Power/duty panel | `PowerBudgetRecord`, `DutyCycleEvent` (RFC-2305) | power class, duty cycle state, emergency override flags |
| Access/data port | generic — this is the "plug in and get a shell" hotspot | opens the actual terminal UI (TLV/record browser, auth prompt) |

Each hotspot has a **visual state** independent of whether the player has opened it: nominal,
degraded/flickering (something's off), or flagged (mission-relevant). That gives players a
readable object at a glance before they dig in — same idea as the mechanic-sim genre's
"which part is red" scanning.

## The "repair/tamper" loop

Where this becomes a mechanic-sim rather than a document reader: instead of literally unbolting
hardware, the player is **swapping or editing records/profiles** — which the RFCs already frame
as modular (profiles/modules layered on a frozen L0/L1 substrate, see `TODOv2.md` in the vault).
Concretely:

- "Replace the part" = swap a profile (e.g. install a different `AlignmentPolicyRecord`, force a
  `BeamProfileRecord` to a different aperture/divergence spec, reissue a `ReservationReceipt`).
- "Diagnose the fault" = read the AlignmentStateRecord/AlignmentEventRecord trail and figure out
  which stage of the lifecycle broke (per RFC-2306 §3, a beam can only be in Reservation,
  Acquisition, Maintenance, Occlusion, or Release — occlusion isn't a failure state, treating it
  as one is a designed-in misdiagnosis trap).
- "Hack it" = exploit a gap the RFC itself leaves open. The RFC Companion docs in the vault
  already catalog these per-RFC as **Designer Briefs** — e.g. from `RFC 2304 Antennas Alignment
  Exploits.md`: stale/biased ephemeris feeds cause silent pointing drift; widened "temporary"
  beacons leak platform presence; single-source alignment trust means compromising one guidance
  feed controls many constrained devices. From `RFC 2303 Exploits.md`: PROVISIONAL→CONFIRMED
  promotion race windows; replay of evicted records; cross-cert chain laundering through weak
  intermediate signers.

  These are already written as **concept + observable signal + scenario hook** triples, which
  maps directly onto a puzzle format: player notices an observable signal (a stale timestamp, a
  provisional flag that never resolved, an oddly wide beacon duty cycle), and the fix/exploit is
  built from the concept the RFC already documents. This means mission content can be generated
  largely by walking the existing Designer Brief docs rather than inventing exploits from scratch.

## Visual reference

`UI Images from show.md` in the vault is a moodboard of ~23 screencaps from the show (reviewed in
full 2026-09-03). This is the visual language the terminal-panel aesthetic should draw from.
Images themselves stay in the vault (`G:\obsidian\vaults\solHacker\SolHacker\Pasted image *.png`)
— not copied into this repo. Pull `assets/raw/` mockups from there by hand when actually building
panel UI, rather than treating the vault copies as the asset source of truth.

### General patterns

- **Dense monospace data panels**: labeled numeric/hex readouts (coordinates, message IDs, drive
  telemetry), not prose — panels read as instrument clusters, not menus.
- **Color-coded by faction/context**, not by severity alone: blue-grey for UN/civilian comm log
  viewers, red for Martian/military control grids, pink/magenta for MCRN missile/weapons systems,
  green phosphor for engineering/drive diagnostics, cyan for UNN science/scanning stations. A
  given hotspot's panel color should probably follow *whose equipment it is* (operator domain /
  trust domain, which SolNet already models via RFC-2362 Trust Domains) rather than a single
  global theme.
- **Big blocky physical-touch button grids** for top-level navigation within a panel (e.g. NAV /
  ENGINES / AIRLOCK / CARGO / OVERRIDE / SYSTEM / OPTIONS) — maps well to switching between
  hotspot record views (Alignment / Beam / Relay / Power / Ephemeris) without a generic tab bar.
- **Log/message list views** (recent/deleted/archived logs, track/target actions per row) — a
  good model for surfacing AlignmentEventRecord / OcclusionEvent / AuditEvent history per hotspot.
- Diagnostic panels mix a compact visual (constellation/drive diagram, wireframe schematic) with a
  scrolling numeric/waveform log underneath — worth mirroring for e.g. the antenna hotspot
  (pointing diagram + error log).
- **Partial/uncertain data is shown explicitly, not hidden**: a transponder readout with most
  fields reading "NO INFORMATION AVAILABLE" rather than blank or omitted rows. Maps directly to
  SolNet's own design principle of surfacing uncertainty (RFC-2304 §4: "the model is designed to
  surface uncertainty instead of hiding it") — panels should show *stale/low-confidence* as a
  visible state, not silently fall back to a default.

### Screen-type catalog (specific archetypes worth building toward)

These are the standout screen types, each a near-direct template for a hotspot panel or mechanic:

- **Comm log / message list** (recent/deleted/archived tabs, per-row track/target actions,
  "RECOVER DELETED LOG") → template for AuditEvent/log history views; deleted-log recovery is a
  ready-made forensics mini-game (RFC-2483).
- **Signal analysis** (waveform display, multi-band sliders, "SUBCARRIER DETECTED — ENHANCE
  AUDIO?") → template for a metadata/steganography investigation puzzle (ties to RFC-2308 Media
  Privacy, and the "encrypted blobs / covert channels" exploit vector in `RFC 2303 Exploits.md`).
- **Tracking/targeting view** (trajectory arc, distance/rate readouts, multiple CAM thumbnails
  with reticle overlays) → direct template for the antenna/alignment hotspot's tracking-mode view
  (AlignmentStateRecord pointing vector + confidence, RFC-2304).
- **Systems-alert schematic** (wireframe diagrams of ship subsystems — comm antenna, airlock —
  side by side with life-support gauges and a button grid, under a "SYSTEMS ALERT: CRITICAL
  SYSTEMS SUMMARY" banner) → near-literal template for the whole object-with-hotspots screen: one
  parent view, wireframe callouts per subsystem, gauges for the ones currently in trouble.
  Reinforces that hotspots should be visually distinguished as wireframe/schematic overlays on the
  object, not just invisible click zones.
- **External comms / hail panel** (DISTANCE, RX LEVEL, RX RELATIVE, FREQUENCY sliders; video feed;
  HAIL / ANSWER / RECORD / SEND / IGNORE / END buttons) → template for the tightbeam/session hotspot
  (RFC-2392 Session layer) — link-quality metadata literally framed as the chrome around a call.
- **Identity dossier / ID popup** (holographic card, photo, name, status, small linked-photo
  gallery, category icon column) and **transponder identification overlay** ("TRANSPONDER
  IDENTIFIED: MCRN DONNAGER") → template for IdentityRecord/NetworkCert display (RFC-2361) and for
  the "assemble a dossier from scraped indices" exploit vector (`RFC 2303 Exploits.md` #9).
- **Transponder/vessel-ID editing panel** ("Upper Transponder Modules": editable vessel name,
  service number, Epstein drive ID, beam frequencies — shown transitioning from one ship's
  identity toward another's, e.g. "TACHI..." being overwritten toward "ROCINANTE") → **this is
  the misidentification exploit from RFC-2306 §6.1 rendered as an actual editable panel.** Strong
  candidate for a literal spoofing mini-game: player edits transponder fields to impersonate a
  different vessel class/registry.
- **Directory/global search tool** ("SYSTEM SEARCH", File/System/Browse/Upload/Download/View/
  Master/Info/Help menu, searching a person by name across "local group / system local / full
  system") → template for a DRE/namespace search tool (RFC-2363), also usable as the
  dossier-assembly surveillance tool itself.
- **Hangar/security terminal with admin-login log** ("ALERT: HANGAR BAY", MISSILE STATUS /
  DIAGNOSTIC / SYSTEM TEST / DOOR STATUS / HANGAR BAY CAMS / SYSTEM LOGS buttons, camera feed
  inset, scrolling `// admin login: SUCCESS` / `// admin login: fail` / `// admin login: fail`
  log) → **direct template for the access/data-port hotspot**, including a visible brute-force/
  login-attempt log as its own diegetic element.
- **"DIAGNOSTIC EXPLOIT RUNNING" console** (fake decompiled pseudocode — `BOOL __cdecl
  sub_10001430(...)` — running alongside a "MISSILE LAUNCH ADMIN — SCANNING LAUNCH CODES" targeting
  view, paired with dialogue "someone's trying to access the missile controls") → **the single
  most direct in-fiction depiction of what this game's "hacking" screen should look like**: a
  live-scanning/exploit-in-progress side panel next to the system it's attacking. Worth using
  nearly verbatim as the visual template for an active-exploit state (as opposed to the passive
  inspection panels most other hotspots default to).
- **"SILENT RUNNING MODE" / stealth panel** (RX RELATIVE, E FIELD, RX LEVEL, receiver-strength
  waveform, "RADIO SILENCE" banner) → template for a stealth/low-emission mode toggle, ties to the
  StealthHint v1 module noted in `TODOv2.md`, to RFC-2308 media exposure policy, and to the "wide
  beacon leaks presence" exploit vector in `RFC 2304 Antennas Alignment Exploits.md`.
- **Science/scanning station** ("U.N.N. THOMAS PRINCE OBSERVATION DECK": transponder ID/status
  list for multiple contacts, a multi-band spectrum scanner — Gamma/X-ray/Ultraviolet/Visible/
  Infrared/Microwave — with a scan-progress bar and "SPECTRUM SCAN: NO ABNORMAL READINGS FOUND")
  → template for a DRE directory listing (multiple relay/transponder entries with live status)
  combined with a scan-for-anomalies mini-game.
- **Personal/social device UI** (dating-app-style profile screen: "NO REAL NAMES, ALL IDENTITIES
  ENCRYPTED, DISCRETION GUARANTEED", vitals/self-summary panels, "PAY 2 UNLOCK") → tonal reference
  for personal-device/PNI screens (RFC-2394/2395) if the game ever surfaces personal-namespace UI
  rather than just infrastructure — worth keeping in mind as a contrast to the utilitarian
  engineering panels, not something to build toward yet.
- **Wrist-terminal / handheld device** (translucent glass slab, etched circuit-trace graphics,
  small status icons) → physical-object reference for what a constrained/personal device (RFC-2395)
  looks like as an art object, separate from its panel content.

## Terminal panel flow (rough)

1. Click hotspot → camera/illustration focuses on that feature (crossfade or simple pan/zoom).
2. Panel slides in showing the *current* record state for that hotspot, rendered in a
   diegetic terminal aesthetic (this is the "hacking" visual layer).
3. If the record looks nominal, panel is mostly read-only (flavor/context).
4. If something's off (mission-relevant or player-triggered), panel exposes the fields that
   matter for that fault: e.g. for occlusion-misdiagnosed-as-failure, show the
   AlignmentEventRecord sequence and let the player correctly classify/act instead of just
   "restarting" it.
5. Some actions require an access/auth step first (the data-port hotspot) — ties into RFC-2301
   crypto primitives / provenance chain checks. This is where "unlocking" happens before deeper
   panels become editable.

## Open questions

- How much of the actual TLV/CBOR wire format should be player-visible vs. abstracted into a
  friendlier record view? (Leaning: friendlier view by default, raw wire view as an advanced/
  endgame tool — mirrors real packet-inspection tools having both a decoded and hex view.)
- Does every object type get all six hotspot categories, or is the set data-driven per object
  (a cheap Belter relay might only expose 2-3 of these, per RFC-2395 constrained-device framing)?
- Fault authoring pipeline: **decided 2026-09-03** — hand-author scenarios directly off the
  Designer Brief docs for now. Revisit procedural generation (RFC-2482 Mission and Scenario
  Generator API) once enough hand-authored scenarios exist to see the actual shape of the
  problem — i.e. wait for a "narrative singularity" where the pattern across missions is clear
  enough to generalize, rather than guessing the generator's schema up front.

## Related RFCs to keep close while building this

- RFC-2304 (Antenna Geometry and Alignment) — pointing/alignment state model
- RFC-2306 (Tightbeam Laser Subprofile) — beam lifecycle, record semantics, exploit brief
- RFC-2353 (L1 Relay Advertisement Protocol) — relay capability/load model
- RFC-2305 (Power and Duty Cycle Constraints) — power panel
- RFC-2482 (Mission and Scenario Generator API) — potential scenario-authoring pipeline
- RFC Companion `/RFC Companion/*.md` — per-RFC exploit vectors, already gameplay-annotated
