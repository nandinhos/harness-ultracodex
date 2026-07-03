#!/usr/bin/env bash
set -euo pipefail

text="${*:-}"

if [ -z "$text" ]; then
  echo "Uso: hooks/pre-action-risk-check.sh '<descricao da acao>'"
  exit 2
fi

risk="baixo"

case "$(printf '%s' "$text" | tr '[:upper:]' '[:lower:]')" in
  *rm\ -rf*|*truncate*|*drop\ table*|*delete\ from*|*migration*|*producao*|*produção*|*secret*|*credential*|*credencial*)
    risk="alto"
    ;;
  *refator*|*legacy*|*legado*|*deploy*|*pagamento*|*contabil*|*contábil*|*seguranca*|*segurança*)
    risk="medio"
    ;;
esac

echo "risco=$risk"

if [ "$risk" = "alto" ]; then
  echo "acao=parar-confirmar-rollback"
  exit 1
fi

if [ "$risk" = "medio" ]; then
  echo "acao=planejar-testar"
else
  echo "acao=agir-verificar"
fi

