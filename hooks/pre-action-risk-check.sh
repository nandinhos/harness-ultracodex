#!/usr/bin/env bash
set -euo pipefail

text="${*:-}"

if [ -z "$text" ]; then
  echo "Uso: hooks/pre-action-risk-check.sh '<descricao da acao>'"
  exit 2
fi

guard="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/destructive-command-guard.sh"
lower="$(printf '%s' "$text" | tr '[:upper:]' '[:lower:]')"

risk="baixo"

# Reutiliza o guard de comandos destrutivos: se ele bloquearia, o risco e alto.
# Mantem uma unica fonte de verdade para a deteccao de destrutividade.
if [ -x "$guard" ] && ! bash "$guard" "$text" >/dev/null 2>&1; then
  risk="alto"
fi

# Sinais semanticos de alto risco que nao aparecem como comando explicito.
case "$lower" in
  *migration*|*producao*|*produção*|*secret*|*credential*|*credencial*|*truncate*|*drop\ table*|*delete\ from*)
    risk="alto"
    ;;
esac

# Sinais de risco medio (so aplicam se ainda nao for alto).
if [ "$risk" != "alto" ]; then
  case "$lower" in
    *refator*|*legacy*|*legado*|*deploy*|*pagamento*|*contabil*|*contábil*|*seguranca*|*segurança*)
      risk="medio"
      ;;
  esac
fi

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
