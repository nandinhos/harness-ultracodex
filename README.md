# Harness LF

Projeto versionavel para manter um perfil de agente arquiteto de longo horizonte, inspirado no modelo operacional da imagem `docs/Fable5.png`.

O objetivo e criar uma camada operacional que aumente a qualidade de desenvolvimento em tarefas simples, refatoracoes de legado, auditorias profundas e mudancas sensiveis em producao.

## Inicio rapido

Perfil core limpo, sem plugins globais:

```bash
bash scripts/build-clean-runtime.sh
CODEX_HOME="$PWD/.runtime/codex-clean" codex -p ultracode-architect-clean -C "$PWD"
```

Perfil pessoal estendido, com Context7, Playwright e delegacao opcional:

```bash
bash scripts/build-personal-runtime.sh
CODEX_HOME="$PWD/.runtime/codex-nandodev" codex -p nandodev-ultracode-extended -C "$PWD"
```

Verificacao de isolamento:

```bash
CODEX_HOME="$PWD/.runtime/codex-clean" codex plugin list
bash scripts/verify-runtime.sh .runtime/codex-clean --expect-core
```

## Estrutura

| Caminho | Funcao |
|---|---|
| `AGENTS.md` | Instrucoes globais do projeto. |
| `docs/` | Fonte de verdade ordenada do harness. |
| `profiles/ultracode-architect/` | Perfil aplicavel a um agente Codex. |
| `profiles/ultracode-architect-clean/` | Perfil core para runtime isolado sem plugins globais. |
| `profiles/nandodev-ultracode-extended/` | Perfil pessoal com Context7, Playwright e delegacao opcional. |
| `skills/` | Skills versionadas que implementam disciplinas especificas. |
| `hooks/` | Ganchos executaveis para checks antes/depois de acoes criticas. |
| `scripts/` | Automacoes de validacao, scaffold e avaliacao. |
| `evals/scenarios/` | Cenarios de pressao. Lint estrutural por `run-scenarios.sh`; avaliacao comportamental opt-in por `run-behavioral-scenarios.sh`. |
| `evals/reports/` | Saidas geradas por execucoes dos cenarios. |

## Garantias de seguranca

- `.runtime/` fica fora do Git e pode conter symlink local para autenticacao.
- Relatorios gerados em `evals/reports/*.md` sao ignorados por padrao.
- Arquivos `.env`, chaves e bancos SQLite locais sao ignorados.
- O core limpo nao instala nem habilita plugins globais.

## Fluxo de manutencao

1. Atualize a documentacao em `docs/` antes de mudar comportamento do perfil.
2. Registre decisoes arquiteturais em `docs/adr/`.
3. Adicione ou ajuste um cenario em `evals/scenarios/` para cada comportamento novo.
4. Rode `scripts/validate-profile.sh`.
5. Rode `scripts/run-scenarios.sh`.

## Comandos

```bash
bash scripts/validate-profile.sh
bash scripts/test-harness-contract.sh
bash scripts/run-scenarios.sh
bash scripts/build-clean-runtime.sh
bash scripts/build-personal-runtime.sh
```

## Documentacao

Comece por `docs/README.md`. O estado atual fica em `docs/STATUS.md`, as decisoes em `docs/adr/` e a politica de publicacao segura em `docs/12-publicacao-segura.md`.
