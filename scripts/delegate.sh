#!/usr/bin/env bash
set -euo pipefail

provider="${HARNESS_DELEGATE_PROVIDER:-codex}"
model="${HARNESS_LIGHT_MODEL:-gpt-5.4-mini}"
timeout_seconds="${HARNESS_TIMEOUT:-300}"

if [ "$#" -gt 0 ]; then
  prompt="$*"
else
  prompt="$(cat)"
fi

if [ -z "$prompt" ]; then
  echo "Uso: scripts/delegate.sh '<prompt>'"
  exit 2
fi

case "$provider" in
  codex)
    command -v codex >/dev/null 2>&1 || { echo "codex ausente"; exit 1; }
    timeout "$timeout_seconds" codex exec -m "$model" -C "$PWD" "$prompt"
    ;;
  hermes)
    command -v hermes >/dev/null 2>&1 || { echo "hermes ausente"; exit 1; }
    timeout "$timeout_seconds" hermes -z "$prompt" -m "$model"
    ;;
  agy)
    command -v agy >/dev/null 2>&1 || { echo "agy ausente"; exit 1; }
    timeout "$timeout_seconds" agy --print --model "$model" --print-timeout "${timeout_seconds}s" --prompt "$prompt"
    ;;
  *)
    echo "provider invalido: $provider"
    exit 2
    ;;
esac
