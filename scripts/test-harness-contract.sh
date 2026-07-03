#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "docs/10-investigacao-debugging.md"
  "docs/11-ferramentas-opcionais.md"
  "docs/adr/0002-capacidades-opcionais-controladas.md"
  "profiles/ultracode-architect-clean/AGENTS.md"
  "profiles/ultracode-architect-clean/config.toml"
  "profiles/nandodev-ultracode-extended/AGENTS.md"
  "profiles/nandodev-ultracode-extended/config.toml"
  "skills/systematic-investigation/SKILL.md"
  "skills/official-docs-check/SKILL.md"
  "skills/visual-verification/SKILL.md"
  "skills/agent-orchestration/SKILL.md"
  "scripts/build-clean-runtime.sh"
  "scripts/build-personal-runtime.sh"
  "scripts/verify-runtime.sh"
  "scripts/check-tooling.sh"
  "scripts/delegate.sh"
  "scripts/visual-check.sh"
  "evals/scenarios/005-pane-debugging.md"
  "evals/scenarios/006-docs-oficiais-context7.md"
  "evals/scenarios/007-verificacao-visual-playwright.md"
  "evals/scenarios/008-delegacao-modelo-leve.md"
  "evals/scenarios/009-core-limpo-sem-plugins.md"
)

for path in "${required_files[@]}"; do
  if [ ! -f "$path" ]; then
    echo "ausente: $path"
    exit 1
  fi
done

for script in \
  scripts/build-clean-runtime.sh \
  scripts/build-personal-runtime.sh \
  scripts/verify-runtime.sh \
  scripts/check-tooling.sh \
  scripts/delegate.sh \
  scripts/visual-check.sh
do
  if [ ! -x "$script" ]; then
    echo "script nao executavel: $script"
    exit 1
  fi
  bash -n "$script"
done

for skill in \
  skills/systematic-investigation/SKILL.md \
  skills/official-docs-check/SKILL.md \
  skills/visual-verification/SKILL.md \
  skills/agent-orchestration/SKILL.md
do
  rg -q '^name: [a-z0-9-]+$' "$skill"
  rg -q '^description: Use when ' "$skill"
done

rg -q 'context7' docs/11-ferramentas-opcionais.md
rg -q 'playwright' docs/11-ferramentas-opcionais.md
rg -q 'hermes' docs/11-ferramentas-opcionais.md
rg -q 'agy' docs/11-ferramentas-opcionais.md
rg -q 'codex' docs/11-ferramentas-opcionais.md

echo "contrato=ok"
