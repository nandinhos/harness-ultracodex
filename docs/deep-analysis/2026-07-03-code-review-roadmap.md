# Code Review de Alto Nivel — Roadmap de Execucao

Data: 2026-07-03

Origem: revisao multi-agente (6 dimensoes: seguranca, correcao, debito tecnico,
arquitetura, drift de docs, integridade transversal), com verificacao adversarial
refute-first de cada achado. 29 achados brutos, 28 verificados; varios confirmados
por teste empirico contra os proprios scripts.

Rastreio: marque `- [x]` conforme concluir. A Fase 1 foi executada nesta sessao e
esta marcada como concluida, exceto a decisao aberta de `trust_level` (do mantenedor).

## Veredito

O Harness LF e um esqueleto de disciplina bem documentado cujas garantias ainda nao
estavam ligadas ao artefato executavel. Os hooks de seguranca eram decorativos, o
guard destrutivo era trivialmente contornavel, e a camada avaliativa mede estrutura,
nao conduta. A Fase 1 ligou e endureceu os guardrails de comando destrutivo; as
fases seguintes tratam avaliacao de comportamento, correcao do build de runtime,
robustez/CI e coerencia documental.

## Achados-cabeca (referencia)

1. Hooks de seguranca decorativos — nao copiados ao runtime nem invocados. **Tratado na Fase 1.**
2. `trust_level = "trusted"` sem substituto operacional. **Mitigado na Fase 1 (instrucao do guard); confirmacao no CLI pendente.**
3. Runtime "estendido": o review diagnosticou "context7 nunca habilitado / verify-runtime aprova arquivo inerte". **Parcialmente refutado na Fase 3** — o Codex carrega o perfil via `-p` (layer de `<name>.config.toml`), entao o arquivo nao era inerte. Porem `codex mcp list`/`codex doctor` liam so a config base e nao mostravam context7 (observabilidade zero). Corrigido: context7 movido para a config base + verify-runtime comportamental. **Resolvido na Fase 3.**
4. `destructive-command-guard.sh` trivialmente contornavel. **Corrigido na Fase 1.**
5. Guard falha aberto em `git push --force`/`-f`. **Corrigido na Fase 1.**
6. Evals nao avaliam comportamento (falso verde). **Fase 2.**

---

## Fase 1 — Ligar (ou parar de prometer) os guardrails — CONCLUIDA

- [x] Endurecer `hooks/destructive-command-guard.sh`: normalizar whitespace e detectar por familia (rm recursivo, `git reset --hard`, `git clean -f`, `git push --force`/`-f`, `dd`, `mkfs`, `find -delete`, `chmod`/`chown` recursivo, `drop`/`delete from`/`truncate`), com postura falso-positivo > falso-negativo.
- [x] Propagar o matcher para `hooks/pre-action-risk-check.sh` reutilizando o guard (fonte unica; escala destrutivos para `risco=alto`).
- [x] Copiar `hooks/` para o runtime em `build-clean-runtime.sh` e `build-personal-runtime.sh`.
- [x] `verify-runtime.sh` passa a exigir a presenca dos quatro hooks no runtime.
- [x] Instruir a invocacao do guard nos `AGENTS.md` carregados (core limpo e pessoal).
- [x] `scripts/test-destructive-guard.sh` prova o bloqueio (38 bloqueios + 15 liberacoes, incluindo bypasses achados por verificacao adversarial: wrapping por aspas, `\rm`, `git -C`, truncate em SQL, dispositivos de VM), amarrado a `test-harness-contract.sh`.
- [x] Cenario `evals/scenarios/010-bloqueio-comando-destrutivo.md`.
- [x] Docs: `adr/0003-hooks-operacionais.md`, `docs/06`, `SECURITY.md`, `STATUS.md`.
- [ ] Aberto (mantenedor): confirmar no Codex CLI alvo o que `trust_level = "trusted"` desabilita e decidir manter ou restringir. Registrado em `SECURITY.md` e ADR 0003.

Evidencia: `bash scripts/test-destructive-guard.sh` e `bash scripts/test-harness-contract.sh` passam; `build-clean-runtime.sh` gera `.runtime/codex-clean/hooks/` com os quatro hooks e `verify-runtime.sh --expect-core` aprova.

---

## Fase 2 — Honestar a camada avaliativa — CONCLUIDA

- [x] `run-scenarios.sh` reetiquetado como lint estrutural; "mede o comportamento" removido de `docs/08` e `README`.
- [x] Runner comportamental opt-in `scripts/run-behavioral-scenarios.sh` (injeta o "Pedido do usuario" via `delegate.sh`, pontua a resposta; gated por `HARNESS_ENABLE_BEHAVIORAL=1`, fora da suite padrao).
- [x] `score-scenario.sh` documentado como heuristica de primeira passada; rubrica de 7 criterios marcada como avaliacao manual.
- [x] `docs/cenarios/modelo.md` alinhado ao linter (H1 = nome; 4 secoes exigidas; `Nome`/`Rubrica` removidas).

## Fase 3 — Corretude e observabilidade do build de runtime — CONCLUIDA

Descoberta empirica (codex-cli 0.142.5): `-p <name>` faz layer de `$CODEX_HOME/<name>.config.toml` sobre a config base, mas `codex mcp list`/`codex doctor` leem so a base. Logo o extended tinha context7 apenas no arquivo layered — invisivel a qualquer diagnostico. A correcao poe context7 na config base (funciona sob as duas leituras do mecanismo).

- [x] Build scripts derivam o `config.toml` base do `config.toml` do perfil (fonte unica de model/effort/MCP) e anexam `[projects.*]`. context7 passa a viver na config base do extended.
- [x] `verify-runtime.sh` comportamental: pergunta ao `codex mcp list` se context7 esta visivel (fallback estrutural na config base quando `codex` ausente). Teste negativo: extended verificado como `--expect-core` falha.
- [x] Model single-sourced do `config.toml` do perfil (o heredoc que hardcodava `gpt-5.5` foi removido).
- [x] `docs/11` alinhado (context7 = MCP declarado no runtime; Playwright/`hermes`/`agy`/`codex` = CLIs do host via `command -v`).

Acceptance (verificado): `CODEX_HOME=extended codex mcp list` mostra context7 e `doctor` reporta `MCP servers 1`; `CODEX_HOME=clean` mostra 0.

Aberto (mantenedor, nao-bloqueante): confirmar num teste de sessao real (`codex -p nandodev-ultracode-extended`) que o layering tambem carrega context7. A config base ja garante isso independente da resposta.

## Fase 4 — Robustez, portabilidade e CI — CONCLUIDA

- [x] `rg` requerido em `check-tooling.sh` (dep dura de ~8 scripts); dupla checagem de `npx` removida.
- [x] `date -Iseconds` portado e `timeout`/`gtimeout` detectados em `delegate.sh`.
- [x] CI em `.github/workflows/ci.yml`: `shellcheck` + contrato + validate-profile + lint-docs + cenarios + guard + build/verify a cada push.
- [x] `verify-runtime.sh` deriva skills/hooks esperados por glob do source (lista cresce sozinha).

## Fase 5 — Defesa em profundidade e coerencia documental — CONCLUIDA

- [x] `.gitignore` expandido (`id_rsa`, `id_ed25519`, `id_ecdsa`, `*.p8`, `*.jks`, `*.keystore`, `.npmrc`, `.netrc`, `.pypirc`, `.aws/`).
- [x] Caveat de symlink de `auth.json` documentado em `SECURITY.md` e `docs/12` (via git ja protegida pelo `.gitignore`; opcao de apontar runtime para fora do repo fica registrada mas nao adotada por quebrar a auth do default in-tree).
- [x] `pre-edit-scope-check.sh` com `SECURITY.md`/`.gitignore`/`.github` na allowlist e tratamento de caminho absoluto.
- [x] `profiles/ultracode-architect` reetiquetado como documental/nao-buildavel em README e STATUS.

## Fase 6 — Limpeza de debito tecnico (DRY) — CONCLUIDA

- [x] `scripts/lib/build-runtime.sh` extraido; `build-clean`/`build-personal` viram wrappers de ~6 linhas.
- [x] Regex da taxonomia de evidencia centralizada em `scripts/lib/evidence-taxonomy.sh` (consumida por `score-scenario.sh` e `pre-finish-evidence-check.sh`, com fallback para a copia do hook no runtime).
- [x] Dupla checagem de `npx` removida (na Fase 4) e parametro `scope` morto eliminado de `pre-edit-scope-check.sh`.

---

## Pendencias pos-fase (investigadas com o `codex` real, v0.142.5)

- [x] **Model IDs sao reais.** `codex debug models` lista `gpt-5.5`, `gpt-5.4` e `gpt-5.4-mini` — os IDs hardcoded resolvem. Caveat de "verificar model IDs" fechado.
- [x] **`actions/checkout` bumpado para `@v6`** (Node 24; existem v4..v7, v7 e a mais recente).
- [x] **`trust_level = "trusted"` documentado (mecanismo mal-diagnosticado pelo review #2).** Fonte do Codex: `trusted` HABILITA carregamento de config/hooks/exec-policies project-local (nao e afrouxamento). Separado: `approval_policy`/`sandbox_mode` nao sao definidos pelo harness -> rodam nos defaults do Codex (item de hardening registrado em `SECURITY.md`).
- [x] **context7 em sessao (`-p`):** ja resolvido pela correcao de config base da Fase 3 (`codex mcp list`/`doctor` provam o carregamento). Um teste de sessao `-p` ao vivo so re-confirmaria — baixo valor marginal.
- [x] **Runner comportamental ponta-a-ponta provado:** `delegate.sh` -> `codex exec` (gpt-5.4-mini) -> resposta real -> `score-scenario` = 4 (exit 0). A cadeia que o runner compoe esta verificada.

## Camadas novas — ADR 0004/0005/0006 (EXECUTADO)

- **ADR 0004 — enforcement nativo:** `destructive-command-guard` amarrado como hook
  `PreToolUse` do Codex (adaptador `codex-pretooluse-guard.sh`, matcher `^Bash$`, deny
  JSON). **Provado ao vivo**: `codex exec` teve um `rm -rf` BLOQUEADO pelo runtime
  (`Command blocked by PreToolUse hook`). Trust do hook exige aprovacao unica
  (interativa, persiste) ou `--dangerously-bypass-hook-trust` em CI; a camada advisory
  do `AGENTS.md` permanece como defesa em profundidade.
- **ADR 0005 — politica de banco:** reset bloqueado; banco de teste obrigatorio; banco
  original so com dupla confirmacao (`HARNESS_DB_TARGET`+`HARNESS_DB_CONFIRM`, deteccao
  por env/nome + `HARNESS_TEST_DB`). Coberto por `test-destructive-guard.sh`.
- **ADR 0006 — judge delegado:** `scripts/judge.sh` (hermes+MiniMax, `HARNESS_JUDGE_MODEL`
  configuravel) para tarefas de alto esforco — rubrica 7-criterios + contraparte. Skill `judge`.
- **Hardening:** `approval_policy=on-request`; sandbox `read-only` (core) / `workspace-write` (pessoal).
- **jq** requerido (adaptador + judge). Descartados: #6 (model single-source), #7 (sweep).
