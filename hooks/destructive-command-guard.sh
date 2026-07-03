#!/usr/bin/env bash
set -euo pipefail

command_text="${*:-}"

if [ -z "$command_text" ]; then
  echo "Uso: hooks/destructive-command-guard.sh '<comando>'"
  exit 2
fi

# Normalizacao: minusculas + neutralizacao de metacaracteres de shell que embrulham
# ou encadeiam comandos (aspas, escape, separadores, subshell). Trata-os como
# separadores de token para que "bash -c \"rm -rf x\"", "\\rm -rf", "a=1;rm -rf" e
# "ssh host \"rm -rf x\"" nao driblem a deteccao. Por fim colapsa espacos e faz
# padding nas bordas. Preserva -, /, =, +, *, > (semanticos para as regras).
raw="$(printf '%s' "$command_text" | tr '[:upper:]' '[:lower:]')"
for ch in '"' "'" $'\\' '`' ';' '&' '|' '(' ')' '{' '}'; do
  raw="${raw//"$ch"/ }"
done
n=" $(printf '%s' "$raw" | tr -s '[:space:]' ' ') "

# Regex em variaveis, referenciadas sem aspas em [[ =~ ]], para evitar que
# metacaracteres (>, *, +) sejam interpretados pelo shell. A ancora (^|[ /])
# reconhece o comando no inicio, apos espaco ou com caminho (ex.: "/bin/rm").
re_recursive=' -[a-z]*r[a-z]* | --recursive '
re_force=' -[a-z]*f[a-z]* '
re_pushplus=' \+[a-z]'
re_amplo=' / | /$| \*|--no-preserve-root'
re_overwrite_dev='> */dev/(sd|nvme|vd|xvd|hd|mmcblk|disk|loop)'
re_mv_devnull='(^|[ /])mv .*/dev/null'

block() {
  echo "bloqueado=sim"
  echo "motivo=comando destrutivo exige confirmacao explicita e rollback"
  echo "familia=$1"
  exit 1
}

# Postura: preferir falso-positivo (pedir confirmacao) a falso-negativo (liberar
# um comando perigoso). Recursao/forca sao detectadas em qualquer ordem de flags.

# rm recursivo — a recursao e a parte perigosa; -f num arquivo unico nao bloqueia.
if [[ "$n" =~ (^|[\ /])rm\  ]] && [[ "$n" =~ $re_recursive ]]; then
  block "rm-recursivo"
fi

# rm forcado apontando para raiz, wildcard amplo ou --no-preserve-root.
if [[ "$n" =~ (^|[\ /])rm\ .*-[a-z]*f ]] && [[ "$n" =~ $re_amplo ]]; then
  block "rm-forcado-amplo"
fi

# git que reescreve/destroi historico ou arvore de trabalho. As regras toleram
# opcoes globais entre "git" e o subcomando (ex.: "git -C /repo reset --hard").
if [[ "$n" =~ (^|[\ /])git(\ +[^\ ]+)*\ +reset\  ]] && [[ "$n" =~ --hard ]]; then
  block "git-reset-hard"
fi
if [[ "$n" =~ (^|[\ /])git(\ +[^\ ]+)*\ +clean\  ]] && [[ "$n" =~ -[a-z]*[fdx](\ |$) ]]; then
  block "git-clean"
fi
if [[ "$n" =~ (^|[\ /])git(\ +[^\ ]+)*\ +push\  ]] \
   && { [[ "$n" =~ --force ]] || [[ "$n" =~ $re_force ]] || [[ "$n" =~ $re_pushplus ]]; }; then
  block "git-push-force"
fi

# Filesystem / dispositivos de bloco.
[[ "$n" =~ (^|[\ /])dd\ .*of= ]] && block "dd"
[[ "$n" =~ (^|[\ /])mkfs ]] && block "mkfs"
[[ "$n" =~ (^|[\ /])shred\  ]] && block "shred"
[[ "$n" =~ find\ .*-delete ]] && block "find-delete"
[[ "$n" =~ find\ .*-exec\ rm ]] && block "find-exec-rm"
[[ "$n" =~ $re_overwrite_dev ]] && block "overwrite-device"
[[ "$n" =~ $re_mv_devnull ]] && block "mv-dev-null"

# chmod/chown recursivo (pode quebrar permissoes de todo um sistema).
if [[ "$n" =~ (^|[\ /])(chmod|chown)\  ]] && [[ "$n" =~ $re_recursive ]]; then
  block "perm-recursivo"
fi

# --- Seguranca de banco de dados (ADR 0005) ---

# Regra A: RESET de banco = bloqueio absoluto (nunca liberado, nem com confirmacao).
[[ "$n" =~ migrate:fresh|migrate:reset|migrate:refresh|db:wipe|db:reset|db:drop ]] && block "db-reset"
[[ "$n" =~ prisma\ migrate\ reset|--force-reset|sequelize\ .*db:drop ]] && block "db-reset"
[[ "$n" =~ manage\.py\ (flush|reset_db) ]] && block "db-reset"
[[ "$n" =~ (^|[\ /])dropdb|dropdatabase\( ]] && block "db-reset"

# Regra B/C: operacao que MUTA um banco NAO-teste exige dupla confirmacao explicita.
db_mut='artisan\ .*migrate|artisan\ .*db:seed|(rails|rake)\ .*db:(migrate|seed)|prisma\ (migrate|db\ push)|sequelize\ .*db:(migrate|seed)|manage\.py\ (migrate|loaddata)|flyway\ .*migrate|liquibase\ .*update|(psql|mysql|mongosh)\ .*(insert|update|delete|alter|drop|create|truncate)'
if [[ "$n" =~ $db_mut ]]; then
  alvo_teste=0
  # Marcador de ambiente/nome (test/testing em env ou no proprio comando).
  case " ${APP_ENV:-} ${DB_CONNECTION:-} ${NODE_ENV:-} ${RAILS_ENV:-} ${DB_DATABASE:-} " in
    *test*) alvo_teste=1 ;;
  esac
  [[ "$n" =~ test ]] && alvo_teste=1
  # Allowlist explicita HARNESS_TEST_DB (nomes separados por espaco).
  if [ -n "${HARNESS_TEST_DB:-}" ]; then
    for _tdb in ${HARNESS_TEST_DB}; do
      _tdb_low="$(printf '%s' "$_tdb" | tr '[:upper:]' '[:lower:]')"
      [ -n "$_tdb_low" ] && [[ "$n" == *"$_tdb_low"* ]] && alvo_teste=1
    done
  fi
  if [ "$alvo_teste" -ne 1 ]; then
    _esperado="${HARNESS_DB_CONFIRM_PHRASE:-CONFIRMO-OPERACAO-NO-BANCO-ORIGINAL}"
    if ! { [ "${HARNESS_DB_TARGET:-}" = "original" ] && [ "${HARNESS_DB_CONFIRM:-}" = "$_esperado" ]; }; then
      block "db-original-sem-dupla-confirmacao"
    fi
  fi
fi

# SQL destrutivo cru.
[[ "$n" =~ drop\ (table|database|schema) ]] && block "sql-drop"
[[ "$n" =~ delete\ from ]] && block "sql-delete"
[[ "$n" =~ (^|[\ /])truncate ]] && block "truncate"

echo "bloqueado=nao"
