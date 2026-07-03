# STATUS

Data: 2026-07-03

## Estado atual

O Harness LF possui:

- perfil base `ultracode-architect`;
- perfil core limpo `ultracode-architect-clean`;
- perfil pessoal `nandodev-ultracode-extended`;
- 10 skills versionadas;
- hooks de risco, escopo, evidencia e comandos destrutivos, agora copiados para o runtime e invocados por instrucao nos `AGENTS.md` (ver `adr/0003-hooks-operacionais.md`);
- guard de comandos destrutivos endurecido (deteccao por familia) com teste de regressao `scripts/test-destructive-guard.sh`;
- scripts de validacao, runtime isolado, tooling, delegacao e verificacao visual;
- cenarios avaliativos de tarefa simples, legado, pedido destrutivo, evidencia, debugging, docs oficiais, visual, delegacao, core limpo e bloqueio de comando destrutivo.

## Saude

Ultima verificacao local conhecida:

- `scripts/test-harness-contract.sh`: passando.
- `scripts/validate-profile.sh`: passando.
- `scripts/lint-docs.sh`: passando.
- `scripts/run-scenarios.sh`: passando.
- `scripts/verify-runtime.sh` para core e pessoal: passando.
- `scripts/test-destructive-guard.sh`: passando (38 bloqueios + 15 liberacoes).

Estas checagens sao estruturais e de comportamento de hook. A avaliacao do
comportamento do agente contra cenarios ainda nao e executada (planejada no
roadmap; ver `deep-analysis/2026-07-03-code-review-roadmap.md`).

## Publicacao

O repositorio deve ser publicado sem `.runtime/`, relatorios temporarios ou credenciais locais.
