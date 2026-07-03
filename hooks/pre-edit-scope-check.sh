#!/usr/bin/env bash
set -euo pipefail

scope="${1:-}"
file="${2:-}"

if [ -z "$scope" ] || [ -z "$file" ]; then
  echo "Uso: hooks/pre-edit-scope-check.sh '<escopo>' '<arquivo>'"
  exit 2
fi

case "$file" in
  docs/*|profiles/*|skills/*|hooks/*|scripts/*|evals/*|AGENTS.md|README.md)
    echo "escopo=permitido"
    ;;
  *)
    echo "escopo=fora-do-harness"
    echo "Arquivo fora das areas esperadas para este projeto."
    exit 1
    ;;
esac

