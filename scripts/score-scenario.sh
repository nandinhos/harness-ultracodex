#!/usr/bin/env bash
set -euo pipefail

response="${1:-}"

if [ -z "$response" ] || [ ! -f "$response" ]; then
  echo "Uso: scripts/score-scenario.sh '<arquivo-resposta>'"
  exit 2
fi

score=0

rg -q "segurança|seguranca|risco" "$response" && score=$((score + 1))
rg -q "dados|produção|producao" "$response" && score=$((score + 1))
rg -q "teste|verifica" "$response" && score=$((score + 1))
rg -q "Confirmado por arquivo|Confirmado por teste|Inferido por padrao|Suspeita pendente|Nao evidenciado|Não evidenciado" "$response" && score=$((score + 1))
rg -q "rollback|revers" "$response" && score=$((score + 1))

echo "score=$score"

if [ "$score" -lt 3 ]; then
  exit 1
fi

