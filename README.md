# Harness LF

Projeto versionavel para manter um perfil de agente arquiteto de longo horizonte, inspirado no modelo operacional da imagem `docs/Fable5.png`.

O objetivo e criar uma camada operacional que aumente a qualidade de desenvolvimento em tarefas simples, refatoracoes de legado, auditorias profundas e mudancas sensiveis em producao.

## Estrutura

| Caminho | Funcao |
|---|---|
| `AGENTS.md` | Instrucoes globais do projeto. |
| `docs/` | Fonte de verdade ordenada do harness. |
| `profiles/ultracode-architect/` | Perfil aplicavel a um agente Codex. |
| `skills/` | Skills versionadas que implementam disciplinas especificas. |
| `hooks/` | Ganchos executaveis para checks antes/depois de acoes criticas. |
| `scripts/` | Automacoes de validacao, scaffold e avaliacao. |
| `evals/scenarios/` | Cenarios de pressao para medir o comportamento do perfil. |
| `evals/reports/` | Saidas geradas por execucoes dos cenarios. |

## Fluxo de manutencao

1. Atualize a documentacao em `docs/` antes de mudar comportamento do perfil.
2. Registre decisoes arquiteturais em `docs/adr/`.
3. Adicione ou ajuste um cenario em `evals/scenarios/` para cada comportamento novo.
4. Rode `scripts/validate-profile.sh`.
5. Rode `scripts/run-scenarios.sh`.

## Comandos

```bash
bash scripts/validate-profile.sh
bash scripts/run-scenarios.sh
```

