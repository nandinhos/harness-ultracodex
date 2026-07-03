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

# Banco de dados.
[[ "$n" =~ drop\ (table|database) ]] && block "sql-drop"
[[ "$n" =~ delete\ from ]] && block "sql-delete"
[[ "$n" =~ (^|[\ /])truncate ]] && block "truncate"

echo "bloqueado=nao"
