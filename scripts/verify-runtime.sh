#!/usr/bin/env bash
set -euo pipefail

runtime="${1:-}"
mode="${2:-}"

if [ -z "$runtime" ] || [ -z "$mode" ]; then
  echo "Uso: scripts/verify-runtime.sh '<runtime>' --expect-core|--expect-extended"
  exit 2
fi

if [ ! -d "$runtime" ]; then
  echo "runtime ausente: $runtime"
  exit 1
fi

if rg -q '^\[plugins\.' "$runtime"/*.toml; then
  echo "plugins declarados no runtime"
  exit 1
fi

expected_skills=(
  "intent-router"
  "risk-gates"
  "evidence-discipline"
  "legacy-refactor"
  "adversarial-review"
  "delivery-format"
  "systematic-investigation"
  "official-docs-check"
  "visual-verification"
  "agent-orchestration"
)

for skill in "${expected_skills[@]}"; do
  if [ ! -f "$runtime/skills/$skill/SKILL.md" ]; then
    echo "skill ausente no runtime: $skill"
    exit 1
  fi
done

case "$mode" in
  --expect-core)
    if rg -q '^\[mcp_servers\.' "$runtime"/*.toml; then
      echo "mcp declarado no core limpo"
      exit 1
    fi
    ;;
  --expect-extended)
    if ! rg -q '^\[mcp_servers\.context7\]' "$runtime"/*.toml; then
      echo "context7 ausente no runtime pessoal"
      exit 1
    fi
    ;;
  *)
    echo "modo invalido: $mode"
    exit 2
    ;;
esac

echo "runtime=ok"
