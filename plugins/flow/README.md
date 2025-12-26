# Flow

Two‑step Claude Code workflow: plan first, work second.

## Why

Most failures come from weak planning or drifting from the plan. Flow fixes both:
- Strong research up front
- Explicit plan reuse of existing code
- Plan re‑read between tasks

## What you get

Commands:
- `/flow:plan` -> produce `plans/<slug>.md`
- `/flow:work` -> execute a plan end‑to‑end

Agents:
- repo-scout (find existing patterns)
- practice-scout (best practices)
- docs-scout (official docs)
- flow-gap-analyst (missing flows/edge cases)
- quality-auditor (optional risk scan)

Skills:
- worktree-kit (safe parallel workspaces)

## Install

Marketplace:
```
/plugin marketplace add https://github.com/gmickel/gmickel-claude-marketplace
/plugin install flow
```

Local dev:
```
claude --plugin-dir ./plugins/flow
```

## Usage

Plan:
```
/flow:plan Add OAuth login for users
```

Work:
```
/flow:work plans/add-oauth-login.md
```

## Works well with RepoPrompt reviews

If you use [gmickel/claude-code-config](https://github.com/gmickel/claude-code-config), chain Flow with RepoPrompt review commands:
```bash
/flow:plan Add OAuth login for users then review the plan using /rp-plan-review and implement fixes until the reviewer is happy
```
```bash
/flow:work plans/add-oauth-login.md then review the implementation using /rp-impl-review and implement fixes until the reviewer is happy
```
RepoPrompt commands are `/rp-plan-review` and `/rp-impl-review`, powered by `rp-cli`.

## How it works

Plan:
1) Run three research agents in parallel
2) Run a flow gap check
3) Write a plan with references + acceptance checks
4) Offer next step (open, work, create issue)

Work:
1) Confirm plan + clarify blockers
2) Setup branch or worktree
3) Turn plan into TodoWrite tasks
4) Execute task loop with plan re‑read
5) Test + optional audit
6) Ship

## Issue creation

From `/flow:plan`, you can create issues in GitHub/Linear/Beads.
The command auto‑detects from CLAUDE.md, repo docs, MCP servers, or plugins.
If unclear, it will ask for the right tool/command.

## Conventions

- Plan files live in `plans/`
- Prefer reuse of centralized code
- Tests and linting are part of the plan

## Author

Gordon Mickel (gordon@mickel.tech)
