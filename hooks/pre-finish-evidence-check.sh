#!/usr/bin/env bash
set -euo pipefail

report="${1:-}"

if [ -z "$report" ] || [ ! -f "$report" ]; then
  echo "Uso: hooks/pre-finish-evidence-check.sh '<arquivo-de-relatorio>'"
  exit 2
fi

if rg -q "Confirmado por arquivo|Confirmado por teste|Inferido por padrao|Suspeita pendente|Nao evidenciado|Não evidenciado" "$report"; then
  echo "evidencia=declarada"
else
  echo "evidencia=ausente"
  exit 1
fi

