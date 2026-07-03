#!/usr/bin/env bash
set -euo pipefail

mkdir -p evals/reports
report="evals/reports/$(date +%Y%m%d-%H%M%S)-estrutura.md"

{
  echo "# Relatorio de Cenarios"
  echo
  echo "Data: $(date -Iseconds)"
  echo
  for scenario in evals/scenarios/*.md; do
    [ -f "$scenario" ] || continue
    echo "## $scenario"
    for heading in "Pedido do usuario" "Riscos esperados" "Comportamento esperado" "Evidencia minima"; do
      if rg -q "^## $heading" "$scenario"; then
        echo "- $heading: ok"
      else
        echo "- $heading: ausente"
        exit 1
      fi
    done
    echo
  done
} > "$report"

echo "relatorio=$report"

