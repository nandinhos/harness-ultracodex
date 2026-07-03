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
3. Runtime "estendido" byte-identico ao limpo (context7 nunca habilitado; verify-runtime aprova o arquivo errado). **Fase 3.**
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

## Fase 2 — Honestar a camada avaliativa

- [ ] Reetiquetar `run-scenarios.sh` como lint de estrutura de cenarios; remover "mede o comportamento" de `docs/08` e `README`.
- [ ] Wire um runner real que injete o "Pedido do usuario" de cada cenario num agente via `delegate.sh`/`codex` e capture a resposta.
- [ ] Reescrever `score-scenario.sh` para consumir a "Evidencia minima" especifica de cada cenario e implementar a rubrica de 7 criterios, ou remove-lo e marcar a rubrica como manual.
- [ ] Alinhar `docs/cenarios/modelo.md` x cenarios x linter (headings "Nome"/"Rubrica").

## Fase 3 — Corrigir a corretude do build de runtime

- [ ] Fazer os build scripts derivarem/concatenarem o `config.toml` do perfil no `config.toml` gerado (fonte unica), emitindo `[mcp_servers.context7]` e `[profiles.*]` no arquivo que o Codex carrega.
- [ ] Mudar `verify-runtime.sh` para checar apenas `"$runtime/config.toml"`.
- [ ] Single-source do model id (`HARNESS_MODEL`) usado por build e `delegate.sh`.
- [ ] Alinhar a linguagem de capacidade em ADR 0002 / README / `docs/11` (context7 declarado vs Playwright/delegacao como scripts que consomem binarios do host).

## Fase 4 — Robustez, portabilidade e CI

- [ ] Adicionar `rg` (requerido) e `jq` a `check-tooling.sh`; degradar para `grep -E` onde viavel.
- [ ] Portar `date -Iseconds` (forma portavel) e detectar `timeout`/`gtimeout` em `delegate.sh`.
- [ ] Introduzir `shellcheck` sobre `hooks/*.sh` e `scripts/*.sh` e um workflow de CI/pre-commit minimo (contrato + validate-profile + shellcheck a cada push).
- [ ] Derivar listas de skills/scripts esperados por glob/manifesto em vez de hardcodar.

## Fase 5 — Defesa em profundidade e coerencia documental

- [ ] Expandir `.gitignore`: `id_rsa`, `id_ed25519`, `id_ecdsa`, `*.p8`, `*.jks`, `*.keystore`, `.npmrc`, `.netrc`, `.pypirc`, `.aws/`.
- [ ] Evitar symlink de `auth.json` dentro da arvore (apontar runtime para fora do repo por default) ou documentar packaging sem seguir symlinks.
- [ ] Adicionar `SECURITY.md`/`.gitignore` ao allowlist de `pre-edit-scope-check.sh` e tratar caminhos absolutos.
- [ ] Reetiquetar `profiles/ultracode-architect` como documental/nao-executavel, ou torna-lo buildavel.

## Fase 6 — Limpeza de debito tecnico (DRY, menor prioridade)

- [ ] Extrair `scripts/lib/build-runtime.sh` parametrizado; `build-clean`/`build-personal` viram wrappers curtos.
- [ ] Centralizar a regex da taxonomia de evidencia consumida por `score-scenario.sh` e `pre-finish-evidence-check.sh`.
- [ ] Remover a dupla checagem de `npx` em `check-tooling.sh` e o parametro `scope` morto em `pre-edit-scope-check.sh`.
