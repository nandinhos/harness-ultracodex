#!/usr/bin/env bash
set -euo pipefail

# Teste de regressao que PROVA o comportamento do destructive-command-guard:
# a bateria "deve bloquear" precisa retornar exit 1; a bateria "deve permitir"
# precisa retornar exit 0. Falha o build se qualquer caso divergir.

guard="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/hooks/destructive-command-guard.sh"

fail=0

must_block=(
  "rm -rf /data"
  "rm  -rf /data"
  "rm -fr /data"
  "rm --recursive --force /data"
  "rm -r -f /data"
  "rm -f -r /data"
  "sudo rm -rf --no-preserve-root /"
  "RM -RF /data"
  "/bin/rm -rf x"
  "/sbin/mkfs.ext4 /dev/sda"
  "/bin/dd if=/dev/zero of=/dev/sda"
  "git push origin +main"
  "bash -c \"rm -rf /home/user/x\""
  "ssh host \"rm -rf /home/user/x\""
  "\\rm -rf /home/user/projeto"
  "a=1;rm -rf /home/user/y"
  "git -C /repo reset --hard HEAD~3"
  "git -c http.sslVerify=false push --force origin main"
  "git -C /repo clean -fdx"
  "psql -c \"truncate table logs\""
  "echo \"truncate table x\" | psql"
  "cat /dev/zero > /dev/vda"
  "git reset --hard HEAD~3"
  "git clean -fdx"
  "git push --force"
  "git push -f origin main"
  "git push --force-with-lease origin main"
  "dd if=/dev/zero of=/dev/sda"
  "mkfs.ext4 /dev/sdb1"
  "find . -name '*.log' -delete"
  "find . -type f -exec rm {} +"
  "chmod -R 777 /"
  "chown -R root /etc"
  "shred -u secret.key"
  "DROP TABLE users;"
  "DROP DATABASE app;"
  "DELETE FROM orders;"
  "TRUNCATE TABLE sessions;"
)

must_allow=(
  "rm -i note.txt"
  "rm note.txt"
  "rm -f cache.tmp"
  "ls -la"
  "git status"
  "git push origin main"
  "git push --set-upstream origin feature"
  "chmod 644 config.yml"
  "chmod 755 my-report.sh"
  "find . -name '*.log'"
  "grep -r pattern src/"
  "cp -r src dest"
  "docker rm -f container"
  "git commit -m \"force push discussion\""
  "git push --set-upstream origin feature"
)

for cmd in "${must_block[@]}"; do
  if bash "$guard" "$cmd" >/dev/null 2>&1; then
    echo "FALHA: deveria BLOQUEAR mas liberou -> $cmd"
    fail=1
  fi
done

for cmd in "${must_allow[@]}"; do
  if ! bash "$guard" "$cmd" >/dev/null 2>&1; then
    echo "FALHA: deveria PERMITIR mas bloqueou -> $cmd"
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "guard=falhou"
  exit 1
fi

echo "guard=ok (${#must_block[@]} bloqueios + ${#must_allow[@]} liberacoes)"
