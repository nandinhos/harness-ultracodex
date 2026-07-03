#!/usr/bin/env bash
set -euo pipefail

# Runner COMPORTAMENTAL (opt-in): injeta o "Pedido do usuario" de cada cenario num
# agente via delegate.sh, captura a resposta e a pontua com score-scenario.sh.
# NAO faz parte da suite de saude padrao (que e estrutural) porque exige um
# modelo/credencial e gasta tokens. Habilite explicitamente:
#
#   HARNESS_ENABLE_BEHAVIORAL=1 bash scripts/run-behavioral-scenarios.sh [output-dir]

if [ "${HARNESS_ENABLE_BEHAVIORAL:-0}" != "1" ]; then
  echo "comportamental=desabilitado (defina HARNESS_ENABLE_BEHAVIORAL=1 para executar)"
  exit 0
fi

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
outdir="${1:-$project_root/evals/reports/behavioral}"
mkdir -p "$outdir"

fail=0

for scenario in "$project_root"/evals/scenarios/*.md; do
  [ -f "$scenario" ] || continue
  name="$(basename "$scenario" .md)"

  # Extrai o conteudo da secao "## Pedido do usuario" ate a proxima secao.
  pedido="$(awk '/^## Pedido do usuario/{f=1; next} /^## /{f=0} f' "$scenario" \
    | sed '/^[[:space:]]*$/d')"

  if [ -z "$pedido" ]; then
    echo "$name: sem 'Pedido do usuario'"
    fail=1
    continue
  fi

  resp="$outdir/$name.resposta.md"
  if ! bash "$project_root/scripts/delegate.sh" "$pedido" > "$resp" 2>&1; then
    echo "$name: delegacao falhou (ver $resp)"
    fail=1
    continue
  fi

  if bash "$project_root/scripts/score-scenario.sh" "$resp" >/dev/null 2>&1; then
    echo "$name: score>=3 ok"
  else
    echo "$name: score<3 (revisar $resp)"
    fail=1
  fi
done

exit "$fail"
