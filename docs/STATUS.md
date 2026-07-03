# STATUS

Data: 2026-07-03

## Estado atual

O Harness LF possui:

- perfil base documental `ultracode-architect` (referencia, nao-buildavel);
- perfil core limpo `ultracode-architect-clean`;
- perfil pessoal `nandodev-ultracode-extended`;
- 11 skills versionadas (inclui `judge`);
- guard de comando destrutivo com DUAS camadas: advisory (`AGENTS.md`) e enforcement nativo (hook `PreToolUse` do Codex, ver `adr/0004-guard-hook-nativo.md`), provado ao vivo;
- guardrail de banco: reset bloqueado; banco de teste obrigatorio; original so com dupla confirmacao (ver `adr/0005-politica-de-banco.md`);
- judge robusto delegado (hermes+MiniMax) para tarefas de alto esforco (`scripts/judge.sh`, ver `adr/0006-judge-delegado.md`);
- hardening: `approval_policy = on-request`; sandbox `read-only` (core) / `workspace-write` (pessoal);
- scripts de validacao, runtime isolado, tooling, delegacao e verificacao visual;
- cenarios avaliativos de tarefa simples, legado, pedido destrutivo, evidencia, debugging, docs oficiais, visual, delegacao, core limpo e bloqueio de comando destrutivo.

## Saude

Ultima verificacao local conhecida:

- `scripts/test-harness-contract.sh`: passando.
- `scripts/validate-profile.sh`: passando.
- `scripts/lint-docs.sh`: passando.
- `scripts/run-scenarios.sh`: passando.
- `scripts/verify-runtime.sh` para core e pessoal: passando.
- `scripts/test-destructive-guard.sh`: passando (48 bloqueios + 15 liberacoes, incl. banco).
- CI (`.github/workflows/ci.yml`): roda a suite completa + `shellcheck` a cada push.

Estas checagens sao estruturais e de comportamento de hook. A avaliacao do
comportamento do agente contra cenarios e opt-in via
`scripts/run-behavioral-scenarios.sh` (exige modelo/credencial;
`HARNESS_ENABLE_BEHAVIORAL=1`) e nao entra na suite de saude padrao.

## Publicacao

O repositorio deve ser publicado sem `.runtime/`, relatorios temporarios ou credenciais locais.
