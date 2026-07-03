# STATUS

Data: 2026-07-03

## Estado atual

O Harness LF possui:

- perfil base documental `ultracode-architect` (referencia, nao-buildavel);
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
- CI (`.github/workflows/ci.yml`): roda a suite completa + `shellcheck` a cada push.

Estas checagens sao estruturais e de comportamento de hook. A avaliacao do
comportamento do agente contra cenarios e opt-in via
`scripts/run-behavioral-scenarios.sh` (exige modelo/credencial;
`HARNESS_ENABLE_BEHAVIORAL=1`) e nao entra na suite de saude padrao.

## Publicacao

O repositorio deve ser publicado sem `.runtime/`, relatorios temporarios ou credenciais locais.
