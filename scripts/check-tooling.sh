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

check_tool codex "${HARNESS_ENABLE_DELEGATION:-0}"
check_tool hermes 0
check_tool agy 0
check_tool playwright "${HARNESS_ENABLE_PLAYWRIGHT:-0}"
check_tool npx "${HARNESS_ENABLE_CONTEXT7:-0}"

if command -v npx >/dev/null 2>&1; then
  echo "context7=disponivel-via-npx"
else
  echo "context7=ausente"
fi

exit "$missing"
