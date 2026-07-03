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

expected_hooks=(
  "destructive-command-guard.sh"
  "pre-action-risk-check.sh"
  "pre-edit-scope-check.sh"
  "pre-finish-evidence-check.sh"
)

for hook in "${expected_hooks[@]}"; do
  if [ ! -f "$runtime/hooks/$hook" ]; then
    echo "hook ausente no runtime: $hook"
    exit 1
  fi
done

runtime_abs="$(cd "$runtime" && pwd)"

# Checagem comportamental: pergunta ao proprio codex quais MCP servers ele enxerga
# nesse runtime. Retorna 2 se codex nao estiver disponivel (cai no fallback estrutural).
mcp_lists_context7() {
  command -v codex >/dev/null 2>&1 || return 2
  CODEX_HOME="$runtime_abs" codex mcp list 2>/dev/null | rg -q '(^|[[:space:]])context7([[:space:]]|$)'
}

case "$mode" in
  --expect-core)
    if mcp_lists_context7; then
      echo "core limpo nao deveria expor context7"
      exit 1
    fi
    if rg -q '^\[mcp_servers\.' "$runtime/config.toml"; then
      echo "mcp declarado no core limpo"
      exit 1
    fi
    ;;
  --expect-extended)
    if command -v codex >/dev/null 2>&1; then
      if ! mcp_lists_context7; then
        echo "context7 nao visivel via codex mcp list no runtime pessoal"
        exit 1
      fi
    elif ! rg -q '^\[mcp_servers\.context7\]' "$runtime/config.toml"; then
      echo "context7 ausente na config base do runtime pessoal"
      exit 1
    fi
    ;;
  *)
    echo "modo invalido: $mode"
    exit 2
    ;;
esac

echo "runtime=ok"
