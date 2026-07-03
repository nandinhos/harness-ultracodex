#!/usr/bin/env bash
set -euo pipefail

file="${1:-}"

if [ -z "$file" ]; then
  echo "Uso: hooks/pre-edit-scope-check.sh '<arquivo>'"
  exit 2
fi

# Trata caminho absoluto como repo-relativo removendo o prefixo do project root.
project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rel="${file#"$project_root"/}"

case "$rel" in
  docs/*|profiles/*|skills/*|hooks/*|scripts/*|evals/*|.github/*|AGENTS.md|README.md|SECURITY.md|.gitignore)
    echo "escopo=permitido"
    ;;
  *)
    echo "escopo=fora-do-harness"
    echo "Arquivo fora das areas esperadas para este projeto."
    exit 1
    ;;
esac
