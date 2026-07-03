#!/usr/bin/env bash
set -euo pipefail

expected=(
  "docs/00-visao.md"
  "docs/01-principios-operacionais.md"
  "docs/02-camadas-de-abstracao.md"
  "docs/03-matriz-de-risco-e-decisao.md"
  "docs/04-evidencia-e-confianca.md"
  "docs/05-refatoracao-legados.md"
  "docs/06-hooks-e-automacoes.md"
  "docs/07-skills.md"
  "docs/08-harness-avaliativo.md"
  "docs/09-manutencao-versionamento.md"
)

for path in "${expected[@]}"; do
  if [ ! -f "$path" ]; then
    echo "doc ausente: $path"
    exit 1
  fi
done

if rg -n "TBD|TODO|A definir" docs profiles skills; then
  echo "placeholders encontrados"
  exit 1
fi

echo "docs=ok"

