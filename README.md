<div align="center">

# gmickel claude marketplace

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin_Marketplace-blueviolet)](https://claude.ai/code)
[![Author](https://img.shields.io/badge/Author-Gordon_Mickel-orange)](https://mickel.tech)

**Workflows that actually ship.**

[Install](#install) · [Flow](#flow) · [Contributing](#contributing)

</div>

---

## Why This Exists

Most AI agent failures aren't about model capability—they're about process. Agents start coding before understanding the codebase, reinvent patterns that already exist, and forget the original plan mid-implementation.

This marketplace contains plugins that fix those problems.

## Install

```bash
/plugin marketplace add https://github.com/gmickel/gmickel-claude-marketplace
```

---

## Flow

**Two‑step workflow: plan first, work second.**

| Problem | Solution |
|---------|----------|
| Weak research | Parallel agents gather context upfront |
| Ignoring existing code | Explicit reuse of repo patterns |
| Drifting from plan | Plan re‑read between every task |
| No review discipline | Built-in Carmack-level code reviews |

```bash
/plugin install flow
```

### Quick Start

```bash
/flow:plan Add OAuth login for users
/flow:work plans/add-oauth-login.md
```

### What's Included

| Type | Count | Examples |
|------|-------|----------|
| Commands | 4 | `/flow:plan`, `/flow:work`, `/flow:plan-review`, `/flow:impl-review` |
| Agents | 5 | repo-scout, practice-scout, docs-scout, gap-analyst, quality-auditor |
| Skills | 5 | Progressive disclosure (~100 tokens at startup) |

Uses **progressive disclosure**—only name + description loaded at startup, full logic loads on-demand when triggered.

📖 **[Full documentation →](plugins/flow/README.md)** · **[Changelog →](CHANGELOG.md)**

---

## Contributing

1. Create `plugins/<name>/` with `.claude-plugin/plugin.json`
2. Add commands/agents/skills under that plugin root
3. Update `.claude-plugin/marketplace.json`
4. Validate: `jq . .claude-plugin/marketplace.json`

---

<div align="center">

Made by [Gordon Mickel](https://mickel.tech) · [gordon@mickel.tech](mailto:gordon@mickel.tech)

</div>
