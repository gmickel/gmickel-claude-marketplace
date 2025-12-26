#!/usr/bin/env bash
set -euo pipefail

# Bump versions in marketplace and/or plugin manifests
# Usage: ./scripts/bump.sh <patch|minor|major> [marketplace|flow|all]

BUMP_TYPE="${1:-}"
TARGET="${2:-all}"

MARKETPLACE=".claude-plugin/marketplace.json"
PLUGIN="plugins/flow/.claude-plugin/plugin.json"

bump_semver() {
  local version="$1"
  local type="$2"
  local major minor patch
  IFS='.' read -r major minor patch <<< "$version"

  case "$type" in
    major) echo "$((major + 1)).0.0" ;;
    minor) echo "$major.$((minor + 1)).0" ;;
    patch) echo "$major.$minor.$((patch + 1))" ;;
    *) echo "$version" ;;
  esac
}

if [[ -z "$BUMP_TYPE" ]] || [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo "Usage: $0 <patch|minor|major> [marketplace|flow|all]"
  echo "  marketplace - bump marketplace version only"
  echo "  flow        - bump flow plugin version (both files)"
  echo "  all         - bump all versions (default)"
  exit 1
fi

if [[ "$TARGET" == "marketplace" || "$TARGET" == "all" ]]; then
  OLD=$(jq -r '.metadata.version' "$MARKETPLACE")
  NEW=$(bump_semver "$OLD" "$BUMP_TYPE")
  jq --arg v "$NEW" '.metadata.version = $v' "$MARKETPLACE" > tmp.json && mv tmp.json "$MARKETPLACE"
  echo "marketplace: $OLD -> $NEW"
fi

if [[ "$TARGET" == "flow" || "$TARGET" == "all" ]]; then
  OLD=$(jq -r '.version' "$PLUGIN")
  NEW=$(bump_semver "$OLD" "$BUMP_TYPE")

  # Update plugin.json
  jq --arg v "$NEW" '.version = $v' "$PLUGIN" > tmp.json && mv tmp.json "$PLUGIN"

  # Update marketplace.json plugins[0].version
  jq --arg v "$NEW" '.plugins[0].version = $v' "$MARKETPLACE" > tmp.json && mv tmp.json "$MARKETPLACE"

  echo "flow: $OLD -> $NEW"
fi

echo "done"
