<div align="center">

# Flow

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](../../LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet)](https://claude.ai/code)
[![Commands](https://img.shields.io/badge/Commands-4-green)](commands/)
[![Agents](https://img.shields.io/badge/Agents-5-yellow)](agents/)
[![Skills](https://img.shields.io/badge/Skills-5-blue)](skills/)

**Structured Claude Code workflow: plan, work, review.**

[Install](#install) · [Why Flow](#why-flow) · [Commands](#commands) · [How It Works](#how-it-works) · [Review Commands](#review-commands)

</div>

---

## Install

```bash
/plugin marketplace add https://github.com/gmickel/gmickel-claude-marketplace
/plugin install flow
```

---

## Usage

Commands work standalone or chained. Claude understands intent and flows between them.

### Standalone

```bash
/flow:plan Add OAuth login for users
/flow:work plans/add-oauth-login.md
/flow:plan-review plans/add-oauth-login.md
/flow:impl-review
```

### Full Workflow (Plan → Review → Work → Review)

The complete flow I actually use:

```bash
/flow:plan Add OAuth login for users, then review it with /flow:plan-review and fix any issues
```

Once the plan passes review:

```bash
/flow:work plans/add-oauth-login.md, then review the implementation with /flow:impl-review and fix any issues
```

### Variations

**Plan + immediate work:**
```bash
/flow:plan Add rate limiting to API, then implement it with /flow:work
```

**Work + review loop:**
```bash
/flow:work plans/rate-limiting.md, review with /flow:impl-review, fix issues until it passes
```

**Natural language (no slash commands):**
```
Help me plan out adding OAuth login for users
```
```
Implement the plan in plans/add-oauth-login.md
```
```
Review my current branch changes
```

Claude auto-triggers the matching skill based on intent.

---

## Why Flow

Most failures come from weak planning or drifting from the plan. Flow fixes both:

| Problem | Solution |
|---------|----------|
| Weak research | Strong research up front via parallel agents |
| Ignoring existing code | Explicit reuse of existing patterns |
| Drifting from plan | Plan re‑read between tasks |
| Unclear completion | Clear Definition of Done before shipping |
| Shallow reviews | Carmack-level reviews via RepoPrompt |

---

## Commands

| Command | Description |
|---------|-------------|
| `/flow:plan` | Research + produce `plans/<slug>.md` |
| `/flow:work` | Execute a plan end‑to‑end |
| `/flow:plan-review` | Carmack-level plan review via rp-cli |
| `/flow:impl-review` | Carmack-level impl review (current branch) |

---

## How It Works

### `/flow:plan`

Turn a rough idea into a practical plan file without writing code.

**Phases:**
1. **Research** — Run three agents in parallel:
   - `repo-scout`: Find existing patterns, conventions, related code paths
   - `practice-scout`: Gather best practices and pitfalls
   - `docs-scout`: Fetch relevant framework/library docs
2. **Gap Analysis** — Run `flow-gap-analyst` to identify missing flows and edge cases
3. **Write Plan** — Create `plans/<slug>.md` with references + acceptance checks
4. **Offer Next Step** — Open plan, start work, or create issue (GitHub/Linear/Beads)

**Plan Depths:**
- **SHORT**: Bugs, small changes — just problem, acceptance checks, key context
- **STANDARD**: Most features — overview, approach, risks, acceptance, test notes, refs
- **DEEP**: Large/critical — detailed phases, alternatives, rollout/rollback, metrics

**Example:**
```bash
/flow:plan Add OAuth login for users
# Creates plans/add-oauth-login.md
```

---

### `/flow:work`

Execute a plan systematically with git setup, task tracking, and quality checks.

**Phases:**
1. **Confirm** — Read plan fully, open referenced files, ask blocking questions
2. **Setup** — Choose: current branch, new branch, or isolated worktree (via `worktree-kit`)
3. **Task List** — Convert plan to TodoWrite tasks with tests + lint steps
4. **Execute Loop** — For each task:
   - Re-read plan before starting
   - Mark task in_progress
   - Implement following existing patterns
   - Test, then mark done
5. **Quality** — Run tests, lint/format, optional `quality-auditor` for risky changes
6. **Ship** — Commit with summary, push + PR if wanted

**Definition of Done:**
- All plan steps completed or explicitly deferred
- All TodoWrite tasks done
- Tests pass
- Lint/format pass
- Docs updated if needed

**Example:**
```bash
/flow:work plans/add-oauth-login.md
```

---

## Review Commands

Carmack-level code reviews via [RepoPrompt](https://repoprompt.com)'s context builder and chat. Claude acts as coordinator, delegating the actual review to RepoPrompt's chat with full file context.

**Requires:** [RepoPrompt](https://repoprompt.com) desktop app running with rp-cli installed.

### `/flow:plan-review`

Review implementation plans before coding starts.

**Phases:**
1. **Window Selection** — Find correct RepoPrompt window via `rp-cli -e 'windows'`
2. **Parse & Read** — Read plan file, search for PRD/beads issues/architecture docs
3. **Build Context** — Call `builder` with plan goals and key modules (30s-5min)
4. **Verify Selection** — Check builder output, add plan file + supporting docs
5. **Carmack-Level Review** — Execute chat-based review covering:
   - Simplicity & minimalism (YAGNI)
   - DRY & code reuse
   - Idiomatic patterns
   - Architecture & data flow
   - Edge cases & error handling
   - Testability
   - Performance
   - Security
   - Maintainability

**Output:** Issues with severity (Critical/Major/Minor/Nitpick), location, problem, suggestion, rationale. Overall assessment: Ship / Needs Work / Major Rethink.

**Example:**
```bash
/flow:plan-review plans/add-oauth-login.md focus on security
```

---

### `/flow:impl-review`

Review implementation changes on current branch vs main/master.

**Phases:**
1. **Window Selection** — Find correct RepoPrompt window
2. **Identify Changes** — Get branch, commits, changed files, diff
3. **Gather Docs** — Search for plan, PRD, beads issue that drove the work
4. **Build Context** — Call `builder` for changed files + dependencies (30s-5min)
5. **Verify Selection** — Ensure all changed files + related code selected
6. **Carmack-Level Review** — Execute chat-based review covering:
   - Correctness (matches plan/spec?)
   - Simplicity & minimalism
   - DRY & code reuse
   - Idiomatic code & type safety
   - Architecture & coupling
   - Edge cases & error handling
   - Testability & test coverage
   - Performance (O(n²), N+1 queries)
   - Security (injection, auth gaps)
   - Maintainability

**Output:** Issues with severity, file:line location, problem, suggestion (with code), rationale. Overall assessment + top 3 improvements.

**Example:**
```bash
/flow:impl-review focus on the auth changes
```

---

## Agents

| Agent | Purpose | Used By |
|-------|---------|---------|
| `repo-scout` | Find existing patterns, conventions, related code | `/flow:plan` |
| `practice-scout` | Gather best practices and pitfalls | `/flow:plan` |
| `docs-scout` | Fetch relevant framework/library docs | `/flow:plan` |
| `flow-gap-analyst` | Identify missing flows, edge cases, requirements | `/flow:plan` |
| `quality-auditor` | Review changes for correctness, security, tests | `/flow:work` |

---

## Skills

| Skill | Purpose |
|-------|---------|
| `flow-plan` | Planning workflow logic |
| `flow-work` | Execution workflow logic |
| `flow-plan-review` | Plan review via rp-cli + chat |
| `flow-impl-review` | Impl review via rp-cli + chat |
| `worktree-kit` | Manage git worktrees for parallel work |

Skills use **progressive disclosure**: only name + description (~100 tokens) loaded at startup. Full logic loads on-demand when triggered.

**Two ways to trigger**:
1. **Explicit**: `/flow:plan add OAuth` or `/flow:work plans/oauth.md`
2. **Natural language**: "help me plan out adding OAuth" or "implement the plan in plans/oauth.md" — Claude auto-triggers the matching skill

---

## Issue Creation

From `/flow:plan`, create issues in **GitHub**, **Linear**, or **Beads**.

Auto‑detects from CLAUDE.md, repo docs, MCP servers, or plugins. Asks if unclear.

---

## Development

```bash
claude --plugin-dir ./plugins/flow
```

### Conventions

- Plan files live in `plans/`
- Prefer reuse of centralized code
- Tests and linting are part of the plan

---

<div align="center">

Made by [Gordon Mickel](https://mickel.tech) · [gordon@mickel.tech](mailto:gordon@mickel.tech)

</div>
