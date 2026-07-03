#!/usr/bin/env bash
set -euo pipefail

# Lint ESTRUTURAL de cenarios: confere que cada cenario declara as secoes exigidas.
# NAO executa o agente e NAO mede comportamento. Para avaliacao de conduta use o
# runner opt-in scripts/run-behavioral-scenarios.sh.

mkdir -p evals/reports
report="evals/reports/$(date +%Y%m%d-%H%M%S)-estrutura.md"

{
  echo "# Relatorio Estrutural de Cenarios"
  echo
  echo "Data: $(date +%Y-%m-%dT%H:%M:%S%z)"
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

