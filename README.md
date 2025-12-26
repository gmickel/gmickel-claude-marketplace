# gmickel claude marketplace

Claude Code plugin marketplace by Gordon Mickel. Built for focused, high‑signal workflows.

## Install marketplace

```bash
/plugin marketplace add https://github.com/gmickel/gmickel-claude-marketplace
```

## Available plugins

### flow
Two‑step workflow: plan first, work second.

Install:
```bash
/plugin install flow
```

Docs:
- `plugins/flow/README.md`

## Add a plugin

1) Create `plugins/<name>/` with `.claude-plugin/plugin.json`
2) Add commands/agents/skills under that plugin root
3) Update `.claude-plugin/marketplace.json`
4) Validate:
```bash
jq . .claude-plugin/marketplace.json
jq . plugins/<name>/.claude-plugin/plugin.json
```

## Author

Gordon Mickel (gordon@mickel.tech)
