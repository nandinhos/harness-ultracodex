#!/usr/bin/env bash
set -euo pipefail

required=(
  "AGENTS.md"
  "README.md"
  "docs/00-visao.md"
  "docs/01-principios-operacionais.md"
  "docs/02-camadas-de-abstracao.md"
  "docs/03-matriz-de-risco-e-decisao.md"
  "docs/04-evidencia-e-confianca.md"
  "docs/05-refatoracao-legados.md"
  "docs/06-hooks-e-automacoes.md"
  "docs/07-skills.md"
  "docs/08-harness-avaliativo.md"
  "docs/09-manutencao-versionamento.md"
  "docs/10-investigacao-debugging.md"
  "docs/11-ferramentas-opcionais.md"
  "profiles/ultracode-architect/AGENTS.md"
  "profiles/ultracode-architect/config.md"
  "profiles/ultracode-architect-clean/AGENTS.md"
  "profiles/ultracode-architect-clean/config.toml"
  "profiles/nandodev-ultracode-extended/AGENTS.md"
  "profiles/nandodev-ultracode-extended/config.toml"
)

for path in "${required[@]}"; do
  if [ ! -f "$path" ]; then
    echo "arquivo ausente: $path"
    exit 1
  fi
done

for skill in skills/*/SKILL.md; do
  [ -f "$skill" ] || continue
  if ! sed -n '1,8p' "$skill" | rg -q '^---$'; then
    echo "frontmatter ausente: $skill"
    exit 1
  fi
  if ! rg -q '^name: [a-z0-9-]+$' "$skill"; then
    echo "name invalido: $skill"
    exit 1
  fi
  if ! rg -q '^description: Use when ' "$skill"; then
    echo "description deve iniciar com 'Use when': $skill"
    exit 1
  fi
done

for hook in hooks/*.sh scripts/*.sh; do
  [ -f "$hook" ] || continue
  bash -n "$hook"
done

echo "validacao=ok"
