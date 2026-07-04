# 06 - Hooks e Automacoes

Hooks servem para alertar ou bloquear antes de erros recorrentes.

| Hook | Objetivo |
|---|---|
| `pre-action-risk-check.sh` | Classificar risco antes de agir; escala para alto quando o guard bloquearia. |
| `pre-edit-scope-check.sh` | Alertar sobre edicoes fora do escopo do harness. |
| `pre-finish-evidence-check.sh` | Impedir conclusao sem evidencia declarada num relatorio. |
| `destructive-command-guard.sh` | Bloquear comandos destrutivos (incl. banco: reset, e banco original sem dupla confirmacao). |
| `codex-pretooluse-guard.sh` | Adaptador PreToolUse: aplica o guard como enforcement nativo do Codex. |

## Como os hooks sao aplicados (duas camadas)

1. **Advisory (sempre ativa).** Os `AGENTS.md` carregados instruem o agente a rodar
   `hooks/destructive-command-guard.sh '<comando>'` antes de comandos destrutivos e a
   honrar `bloqueado=sim`. Cumprimento voluntario do agente.
2. **Enforcement nativo (quando o hook e confiado).** O `config.toml` gerado registra
   `[[hooks.PreToolUse]]` (matcher `^Bash$`) apontando para
   `hooks/codex-pretooluse-guard.sh` (adaptador copiado no runtime). O Codex chama o
   adaptador antes de cada comando shell; se destrutivo, ele retorna `deny` e o Codex
   BLOQUEIA o comando. Ver `adr/0004-guard-hook-nativo.md`.

Trust: o hook chega untrusted num runtime fresco e e pulado ate ser confiado
(aprovacao interativa unica, que persiste; ou `--dangerously-bypass-hook-trust` em
automacao). Enquanto nao confiado, vale a camada advisory. `verify-runtime.sh`
confirma o hook wired, nao o trust (estado de runtime).

O guard tambem cobre a politica de banco (reset bloqueado; banco de teste
obrigatorio; original so com dupla confirmacao) — ver `adr/0005-politica-de-banco.md`.

O enforcement nativo tem deteccao de drift: `scripts/test-native-hook-enforcement.sh`
(opt-in, exige codex) roda sessoes reais e falha se o hook deixar de bloquear.

O guard normaliza whitespace e detecta destrutividade por familia (rm recursivo,
`git reset --hard`, `git clean -f`, `git push --force`/`-f`, `dd`, `mkfs`,
`find -delete`, `chmod`/`chown` recursivo, `drop`/`delete from`/`truncate`),
preferindo falso-positivo a falso-negativo. Seu comportamento e provado por
`scripts/test-destructive-guard.sh`, amarrado ao contrato do harness.

Decisao registrada em `adr/0003-hooks-operacionais.md`.

## Principio

Automatize o que for mecanico. Use skill quando o problema exigir julgamento.
