# ADR 0004 - Guard como hook nativo do Codex (enforcement)

Status: aceito (supersede parcialmente ADR 0003)

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

O ADR 0003 tornou o guard operacional por instrucao no `AGENTS.md` (cumprimento
voluntario do agente) e registrou o gatilho: "se o Codex expuser um hook pre-exec
nativo, migrar para enforcement real". O gatilho DISPAROU — o Codex 0.142.5 tem
hooks nativos (`[[hooks.PreToolUse]]`, entrada via stdin JSON, decisao no stdout).

## Decisao

Amarrar o guard de comando destrutivo como hook nativo `PreToolUse`, mantendo a
instrucao do `AGENTS.md` como camada advisory (defesa em profundidade):

- Adaptador `hooks/codex-pretooluse-guard.sh`: le o `tool_input.command` do stdin
  (jq), chama `destructive-command-guard.sh` e, se bloqueado, imprime o JSON de
  deny (`hookSpecificOutput.permissionDecision = "deny"`).
- Wiring `[[hooks.PreToolUse]]` (matcher `^Bash$`, confirmado como o nome do shell
  tool) no `config.toml` gerado, apontando para a copia do adaptador no runtime.
  Isso reconcilia o achado da Fase 1: a copia dos hooks no runtime deixa de ser
  decorativa e passa a ser o caminho de enforcement.

## Prova ao vivo (verificado)

`codex exec` com o hook ativo: uma chamada de shell com `rm -rf` foi BLOQUEADA pelo
runtime — `error=Command blocked by PreToolUse hook: Guardrail LF ... (rm-recursivo)`
seguido de `hook: PreToolUse Blocked`. Matcher `^Bash$`, path `.tool_input.command`
e o schema de deny confirmados end-to-end.

## Hook trust (limitacao operacional documentada)

`trust_level = "trusted"` HABILITA o carregamento do hook, mas cada hook tem trust
proprio por hash sha256. Num runtime fresco o hook chega untrusted e e PULADO
(fail-open) — o enforcement so ocorre quando o hook e confiado:

- Uso interativo (`codex -p ...`): aprovar o hook uma vez (prompt); persiste.
- Automacao/CI (`codex exec`): `--dangerously-bypass-hook-trust` OU provisionar o
  registro de trust. Enquanto nao confiado, vale a camada advisory do `AGENTS.md`.

## Consequencias

- Primeira camada de enforcement real do harness (antes: so advisory).
- Duas camadas: advisory (sempre) + hook nativo (quando confiado).
- `verify-runtime.sh` confirma o hook presente/wired; nao confirma o trust (estado de runtime) — documentado.

## Gatilho para revisitar

- Se o Codex expuser um caminho scriptavel/persistente de trust de hook, provisiona-lo no build para enforcement automatico em CI.
- Se o nome do shell tool ou o schema de deny mudarem numa versao futura do Codex, reconfirmar o matcher e o JSON.
