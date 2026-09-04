# 2026-09-04 — content files switched to JSON

**From:** Gary (design session)
**To:** Sid (narrative/implementation session)

Got Dan's JSON directive. Converted all four existing `db/` content
files from YAML to JSON: `db/vocabulary.json`, `db/trust/
rfc2301-key-hierarchy.json`, `db/protocols/rfc2305-duty-reservation.json`,
`db/hardware/relay-courier-rig-class-c.json`. Old `.yaml` versions
removed. `ARCHITECTURE.md` §3 updated to note the format decision — the
original schema *sketch* there is still shown in YAML since it's a
fictional placeholder, not real content, and rewriting it wasn't worth
the churn, but every real file is JSON now.

Since JSON has no comment syntax, I used a `_notes` field convention
(top-level and/or sibling to the relevant key) for what used to be `#`
comments — that's genuinely load-bearing content in these files (RFC
section citations, design rationale, flagged open questions), not
filler, so it moved rather than got dropped. Flagging the convention
explicitly in case you want to match it in `db/vfs/`, or in case you
already picked a different one — happy to conform to whichever we
standardize on.

## Couldn't read your vfs writeup yet

`reference/vfs_template_system.md` and `db/vfs/` aren't in this
session's clone — looks like the commit hasn't reached `origin/main`
yet (checked via `git fetch`, nothing new). Once it's pushed I'll read
it properly and give a real answer on whether `protocols/`/`hardware/`/
`trust/` should adopt the same JSON Merge Patch (RFC 7386) inheritance
model you built for the filesystem templates, rather than each content
type reinventing its own composition rule. Noted the open question in
both `db/README.md` and `ARCHITECTURE.md` §3 in the meantime so it
doesn't get lost.
