#!/usr/bin/env bash
set -euo pipefail

report="${1:-}"

if [ -z "$report" ] || [ ! -f "$report" ]; then
  echo "Uso: hooks/pre-finish-evidence-check.sh '<arquivo-de-relatorio>'"
  exit 2
fi

# Fonte unica da taxonomia (scripts/lib). O fallback embutido garante que a copia
# do hook no runtime (onde a lib nao existe) continue funcionando.
lib="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts/lib/evidence-taxonomy.sh"
# shellcheck source=/dev/null
[ -f "$lib" ] && source "$lib"
: "${EVIDENCE_REGEX:=Confirmado por arquivo|Confirmado por teste|Inferido por padrao|Suspeita pendente|Nao evidenciado|Não evidenciado}"

if rg -q "$EVIDENCE_REGEX" "$report"; then
  echo "evidencia=declarada"
else
  echo "evidencia=ausente"
  exit 1
fi
