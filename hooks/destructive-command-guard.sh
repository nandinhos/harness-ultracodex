#!/usr/bin/env bash
set -euo pipefail

command_text="${*:-}"

if [ -z "$command_text" ]; then
  echo "Uso: hooks/destructive-command-guard.sh '<comando>'"
  exit 2
fi

normalized="$(printf '%s' "$command_text" | tr '[:upper:]' '[:lower:]')"

case "$normalized" in
  *rm\ -rf*|*git\ reset\ --hard*|*drop\ table*|*truncate*|*delete\ from*|*force*push*)
    echo "bloqueado=sim"
    echo "motivo=comando destrutivo exige confirmacao explicita e rollback"
    exit 1
    ;;
  *)
    echo "bloqueado=nao"
    ;;
esac

