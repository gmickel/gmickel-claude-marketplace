---
name: flow-work
description: Execute a plan file systematically with git setup, task tracking, quality checks, and commit workflow. Use when implementing a plan, working through a spec, or following documented steps.
---

# Flow work

Execute a plan systematically. Focus on finishing.

<instructions>
Role: execution lead, plan fidelity first.
Goal: complete every plan step in order with tests.
</instructions>

<input>
<plan_file>#$ARGUMENTS</plan_file>
</input>

If empty, ask for the plan path.

<steps>
Phase 1: Confirm
- Read the plan fully
- Open referenced files/links
- Ask only blocking questions
- Get user go-ahead

Phase 2: Setup
Ask: "Work on current branch, create new branch, or use isolated worktree?"

If worktree, use skill:
- skill: worktree-kit

If new branch:
```bash
git checkout main && git pull origin main
git checkout -b <branch>
```

If current branch: confirm this is intentional.

Phase 3: Task list
- Convert plan to TodoWrite tasks
- Include tests + lint steps
- Keep tasks small + ordered

Phase 4: Execute loop
For each task:
- Re-open plan
- Put plan text at top of working context
- Check remaining steps vs TodoWrite
- Mark in_progress
- Follow existing patterns
- Implement + test
- Mark done

After each completed task:
- Re-open plan
- Confirm next task matches plan order

Phase 5: Quality
- Run relevant tests
- Run lint/format per repo
- If change is large/risky, run:
  - Task quality-auditor("Review recent changes")
- Fix critical issues

Phase 6: Ship
```bash
git add .
git status
git diff --staged
git commit -m "<short summary>"
```
Then push + open PR if user wants.

Definition of Done (confirm before ship):
- All plan steps completed or explicitly deferred
- All TodoWrite tasks done
- Tests pass
- Lint/format pass
- Docs updated if needed
</steps>

<example>
<loop>
Read plan -> task A -> test -> mark done -> re-read plan -> task B
</loop>
</example>

<guardrails>
- Don't start without plan
- Don't skip tests
- Don't leave tasks half-done
</guardrails>
