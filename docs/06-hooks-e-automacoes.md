# 06 - Hooks e Automacoes

Hooks servem para alertar ou bloquear antes de erros recorrentes.

| Hook | Objetivo |
|---|---|
| `pre-action-risk-check.sh` | Classificar risco antes de agir; escala para alto quando o guard bloquearia. |
| `pre-edit-scope-check.sh` | Alertar sobre edicoes fora do escopo do harness. |
| `pre-finish-evidence-check.sh` | Impedir conclusao sem evidencia declarada num relatorio. |
| `destructive-command-guard.sh` | Bloquear comandos destrutivos sem confirmacao. |

## Como os hooks sao aplicados

Os hooks sao copiados para o runtime pelos build scripts (`build-clean-runtime.sh`
e `build-personal-runtime.sh`) e `verify-runtime.sh` exige sua presenca. Eles nao
sao enforcement de kernel: os `AGENTS.md` carregados instruem o agente a rodar
`hooks/destructive-command-guard.sh '<comando>'` antes de qualquer comando
destrutivo e a honrar `bloqueado=sim` parando para confirmacao e rollback.

Como o agente e lancado com `-C "$PWD"` na raiz do projeto, o guard efetivamente
executado e o `hooks/` do proprio repositorio. A copia em `$runtime/hooks/` garante
parity e self-containment do runtime (e permite a `verify-runtime.sh` confirmar que
o build esta completo); ela nao e, por si so, o caminho de enforcement.

O guard normaliza whitespace e detecta destrutividade por familia (rm recursivo,
`git reset --hard`, `git clean -f`, `git push --force`/`-f`, `dd`, `mkfs`,
`find -delete`, `chmod`/`chown` recursivo, `drop`/`delete from`/`truncate`),
preferindo falso-positivo a falso-negativo. Seu comportamento e provado por
`scripts/test-destructive-guard.sh`, amarrado ao contrato do harness.

Decisao registrada em `adr/0003-hooks-operacionais.md`.

## Principio

Automatize o que for mecanico. Use skill quando o problema exigir julgamento.
