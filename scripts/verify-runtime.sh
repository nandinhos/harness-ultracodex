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

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Deriva skills/hooks esperados por glob do source do projeto, para a lista crescer
# sozinha quando um novo item for adicionado (evita divergencia de lista fixa).
for skill_md in "$project_root"/skills/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  name="$(basename "$(dirname "$skill_md")")"
  if [ ! -f "$runtime/skills/$name/SKILL.md" ]; then
    echo "skill ausente no runtime: $name"
    exit 1
  fi
done

for hook_src in "$project_root"/hooks/*.sh; do
  [ -f "$hook_src" ] || continue
  name="$(basename "$hook_src")"
  if [ ! -f "$runtime/hooks/$name" ]; then
    echo "hook ausente no runtime: $name"
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
