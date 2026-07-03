#!/usr/bin/env bash
set -euo pipefail

# Adaptador PreToolUse: ponte entre o protocolo de hook nativo do Codex e o
# destructive-command-guard puro. O Codex escreve o tool_input como JSON no stdin;
# se o comando for destrutivo, imprimimos no stdout o JSON de deny do Codex.
# Registrado no config.toml via [[hooks.PreToolUse]] (ver scripts/lib/build-runtime.sh).

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
input="$(cat)"

# Debug opcional: quando HARNESS_HOOK_DEBUG aponta para um arquivo, registra o JSON
# de entrada real (para descobrir tool_name / estrutura durante a verificacao).
if [ -n "${HARNESS_HOOK_DEBUG:-}" ]; then
  printf '%s\n' "$input" >> "$HARNESS_HOOK_DEBUG" 2>/dev/null || true
fi

# Extrai a string de comando shell do tool_input (cobre command string ou array).
cmd="$(printf '%s' "$input" | jq -r '
  (.tool_input.command // .tool_input.cmd // .tool_input.script // .command // empty)
  | if type == "array" then join(" ") else tostring end
' 2>/dev/null || true)"

# Sem comando (tool nao-shell) -> nada a checar, permite.
[ -z "$cmd" ] && exit 0

out="$(bash "$dir/destructive-command-guard.sh" "$cmd" 2>/dev/null || true)"

if printf '%s' "$out" | grep -q '^bloqueado=sim'; then
  familia="$(printf '%s' "$out" | sed -n 's/^familia=//p' | head -1)"
  reason="Guardrail LF bloqueou comando destrutivo (${familia:-destrutivo}). Exige confirmacao explicita e plano de rollback."
  # JSON minimo — o schema do Codex e estrito (deny_unknown_fields).
  jq -cn --arg r "$reason" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
fi

exit 0
