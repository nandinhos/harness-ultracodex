#!/usr/bin/env bash
set -euo pipefail

provider="${HARNESS_DELEGATE_PROVIDER:-codex}"
model="${HARNESS_LIGHT_MODEL:-}"   # vazio = usar o modelo default do provider
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

# Detecta um wrapper de timeout portavel: `timeout` (GNU) ou `gtimeout` (coreutils
# no macOS via Homebrew). Sem nenhum, executa sem limite e avisa, em vez de falhar.
if command -v timeout >/dev/null 2>&1; then
  timeout_cmd=(timeout "$timeout_seconds")
elif command -v gtimeout >/dev/null 2>&1; then
  timeout_cmd=(gtimeout "$timeout_seconds")
else
  echo "aviso: timeout/gtimeout ausente; executando sem limite de tempo" >&2
  timeout_cmd=()
fi

run() {
  if [ "${#timeout_cmd[@]}" -gt 0 ]; then
    "${timeout_cmd[@]}" "$@"
  else
    "$@"
  fi
}

case "$provider" in
  codex)
    command -v codex >/dev/null 2>&1 || { echo "codex ausente"; exit 1; }
    run codex exec -m "${model:-gpt-5.4-mini}" -C "$PWD" "$prompt"
    ;;
  hermes)
    command -v hermes >/dev/null 2>&1 || { echo "hermes ausente"; exit 1; }
    # Sem -m, o hermes usa seu modelo default configurado (ex.: MiniMax-M3).
    if [ -n "$model" ]; then
      run hermes -z "$prompt" -m "$model"
    else
      run hermes -z "$prompt"
    fi
    ;;
  agy)
    command -v agy >/dev/null 2>&1 || { echo "agy ausente"; exit 1; }
    if [ -n "$model" ]; then
      run agy --print --model "$model" --print-timeout "${timeout_seconds}s" --prompt "$prompt"
    else
      run agy --print --print-timeout "${timeout_seconds}s" --prompt "$prompt"
    fi
    ;;
  *)
    echo "provider invalido: $provider"
    exit 2
    ;;
esac
