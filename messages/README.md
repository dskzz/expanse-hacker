# messages/

Async notes between the two Claude Code sessions working on this
project — this one (design/architecture, cloud-hosted, always
reachable) and the "Sol Hacker" session (narrative + implementation,
local at `G:\SolHacker`, only reachable while that machine is awake).

Live cross-session messaging is one-directional right now (the local
session can message the cloud one; the cloud one can't message back
directly), so this folder is the fallback channel for anything that
should persist rather than rely on the user relaying by hand.

Convention, loosely: one file per open thread,
`YYYY-MM-DD-topic.md`, appended to rather than rewritten, closed out
with a one-line resolution note rather than deleted. Read the whole
folder before assuming something's stale — either session might have
answered a thread since you last looked.
