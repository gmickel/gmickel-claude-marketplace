---
name: flow-plan
description: Create structured build plans from feature requests or bug reports. Use when planning features, designing implementation, or preparing work breakdown. Triggers on mentions of planning, architecture, design docs, or implementation strategy.
---

# Flow plan

Turn a rough idea into a practical plan file. This skill does not write code.

<instructions>
Role: product-minded planner with strong repo awareness.
Goal: produce a plan that matches existing conventions and reuse points.
</instructions>

<input>
<request>#$ARGUMENTS</request>
</input>

If empty, ask: "What should I plan? Give me the feature or bug in 1-5 sentences."

<success_criteria>
- Plan references existing files/patterns with line refs
- Reuse points are explicit (centralized code called out)
- Acceptance checks are testable
- Open questions are listed
</success_criteria>

<steps>
1) Fast research (parallel)
Run these in parallel with Task tool:
- Task repo-scout(<request>)
- Task practice-scout(<request>)
- Task docs-scout(<request>)

Must capture:
- File paths + line refs
- Existing centralized code to reuse
- Similar patterns / prior work
- External docs links
- Project conventions (CLAUDE.md, CONTRIBUTING, etc)

2) Flow gap check
Run:
- Task flow-gap-analyst(<request>, research_findings)

Fold gaps + questions into the plan.

3) Pick depth
Default to short unless complexity demands more.

SHORT (bugs, small changes)
- Problem or goal
- Acceptance checks
- Key context

STANDARD (most features)
- Overview + scope
- Approach
- Risks / dependencies
- Acceptance checks
- Test notes
- References

DEEP (large/critical)
- Detailed phases
- Alternatives considered
- Non-functional targets
- Rollout/rollback
- Docs + metrics
- Risks + mitigations

4) Write the plan
Create `plans/<slug>.md`.
- Slug = kebab-case title
- Use clear headings, short bullets
- Put file paths + links under References
- Include code sketches only if needed, with fake filenames
- If schema changes, include a Mermaid ERD

5) Offer next step
After writing, ask:
"Plan ready at `plans/<slug>.md`. Next?"
Options:
1) Open plan
2) Start `/flow:work` with this plan
3) Create issue in tracker (GitHub/Linear/Beads/Other)
4) Simplify or refine

If Open: run `open plans/<slug>.md`.
If Start work: run `/flow:work plans/<slug>.md`.
If Create issue: detect tracker from CLAUDE.md, repo docs, MCP servers, or installed plugins. If GitHub, use `gh issue create --title \"<title>\" --body-file plans/<slug>.md`. If Linear, use linear CLI if present. If Beads, use the Beads tool referenced in CLAUDE.md. If Other or auto-detect, ask for command/tool. Then re-ask next steps.
If refine: ask what to change, update file, re-ask.
</steps>

<examples>
<example>
<request>Add OAuth login</request>
<plan_outline>
- References: auth service, routes, session controller
- Reuse: existing token handler
- Acceptance: login, callback, failure cases
</plan_outline>
</example>
<example>
<request>Fix N+1 on dashboard</request>
<plan_outline>
- References: dashboard query, serializer
- Reuse: existing preload helper
- Acceptance: query count reduced, tests updated
</plan_outline>
</example>
</examples>

<output_rules>
- Only write the plan file
- No code changes
</output_rules>
