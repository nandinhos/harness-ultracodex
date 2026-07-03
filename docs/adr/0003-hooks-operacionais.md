# ADR 0003 - Tornar os hooks de seguranca operacionais

Status: aceito (estendido por ADR 0004 — enforcement nativo; a camada advisory permanece como defesa em profundidade)

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

Um code review de alto nivel constatou que os quatro hooks de seguranca
(`destructive-command-guard`, `pre-action-risk-check`, `pre-edit-scope-check`,
`pre-finish-evidence-check`) eram decorativos: os build scripts nunca copiavam
`hooks/` para o runtime, nenhum `config.toml` ou `AGENTS.md` carregado os
referenciava, e o guard existente liberava `dd`, `mkfs`, `find -delete`,
`git clean -fdx`, `git push --force` e variacoes triviais de `rm`. A proposta de
valor central do harness — guardrails de risco — era aspiracional, nao operacional.

## Opcoes consideradas

| Opcao | Vantagem | Custo |
|---|---|---|
| Manter hooks como utilitario documental | Nenhuma mudanca de codigo | Guardrails seguem aspiracionais; a doc promete bloqueio que nao ocorre. |
| Amarrar via mecanismo nativo do Codex | Enforcement automatico | Depende de recurso do CLI ainda nao confirmado; acopla ao provider. |
| Hooks no runtime + instrucao verificavel no `AGENTS.md` + guard endurecido com teste | Operacional, provider-agnostico e testavel | Depende de o agente honrar a instrucao; nao e enforcement de kernel. |

## Decisao

Adotar a terceira opcao:

- Os build scripts copiam `hooks/` para o runtime; `verify-runtime.sh` exige a presenca dos quatro hooks.
- Os `AGENTS.md` carregados (core limpo e pessoal) instruem rodar `hooks/destructive-command-guard.sh` antes de qualquer comando destrutivo e honrar `bloqueado=sim`.
- O guard foi endurecido: normaliza whitespace e detecta destrutividade por familia (rm recursivo, `git reset --hard`, `git clean -f`, `git push --force`/`-f`, `dd`, `mkfs`, `find -delete`, `chmod`/`chown` recursivo, `drop`/`delete from`/`truncate`), preferindo falso-positivo a falso-negativo.
- `scripts/test-destructive-guard.sh` prova o comportamento com bateria de bloqueios e liberacoes, amarrada a `scripts/test-harness-contract.sh`.

## Consequencias

- Os hooks deixam de ser apenas syntax-checked: passam a ser presentes no runtime, invocados por instrucao e cobertos por teste de comportamento.
- `trust_level = "trusted"` permanece por ora, mas passa a ser decisao explicita e documentada em `SECURITY.md`. A instrucao do guard e o substituto operacional enquanto `trusted` suprimir a aprovacao nativa do Codex.
- A camada avaliativa ainda mede estrutura, nao conduta do agente contra cenarios; isso e tratado numa fase seguinte do roadmap.

## Gatilho para revisitar

- Se o Codex CLI expuser um hook pre-exec nativo, migrar a amarracao para ele (enforcement real) e reduzir a dependencia da instrucao textual.
- Se auditoria mostrar o agente ignorando a instrucao do guard, reavaliar `trust_level = "trusted"` ou adotar enforcement externo.

> Atualizacao (2026-07-03): o primeiro gatilho DISPAROU. O Codex 0.142.5 expoe hooks
> nativos (`[[hooks.PreToolUse]]` no `config.toml`, entrada via stdin JSON, decisao
> `deny` no stdout; hooks tem trust por hash de conteudo, e `trust_level = "trusted"`
> habilita o carregamento de hooks project-local). A migracao do guard para
> enforcement nativo real esta proposta em ADR 0004 (pendente de decisao e de prova
> ponta-a-ponta com um comando destrutivo negado ao vivo).
