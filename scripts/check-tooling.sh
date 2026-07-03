#!/usr/bin/env bash
set -euo pipefail

missing=0

check_tool() {
  local name="$1"
  local required="${2:-0}"
  if command -v "$name" >/dev/null 2>&1; then
    echo "$name=ok path=$(command -v "$name")"
  else
    echo "$name=ausente"
    if [ "$required" = "1" ]; then
      missing=1
    fi
  fi
}

# rg (ripgrep) e dependencia dura de quase todos os validadores; sem ele, eles
# falham com exit 127. Por isso e requerido.
check_tool rg 1
check_tool codex "${HARNESS_ENABLE_DELEGATION:-0}"
check_tool hermes 0
check_tool agy 0
check_tool playwright "${HARNESS_ENABLE_PLAYWRIGHT:-0}"

# npx e context7 derivam de uma unica checagem de npx (sem duplicar command -v).
if command -v npx >/dev/null 2>&1; then
  echo "npx=ok path=$(command -v npx)"
  echo "context7=disponivel-via-npx"
else
  echo "npx=ausente"
  echo "context7=ausente"
  if [ "${HARNESS_ENABLE_CONTEXT7:-0}" = "1" ]; then
    missing=1
  fi
fi

exit "$missing"
