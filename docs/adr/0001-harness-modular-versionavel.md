# ADR 0001 - Harness modular versionavel

Status: aceito

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

O perfil precisa evoluir ao longo do tempo, combinar documentacao, skills, hooks, scripts e cenarios avaliativos, e mitigar riscos como perda de dados, regressao, falso positivo e overengineering.

## Opcoes consideradas

| Opcao | Vantagem | Custo |
|---|---|---|
| `AGENTS.md` unico | Simples de aplicar | Dificil de testar e manter. |
| Apenas skills | Reutilizavel | Pouca rastreabilidade arquitetural. |
| Harness modular versionavel | Testavel, evolutivo e organizado | Mais arquivos e disciplina de manutencao. |

## Decisao

Adotar um harness modular versionavel com documentacao ordenada, perfil aplicavel, skills, hooks, scripts e cenarios avaliativos.

## Consequencias

- Mudancas de comportamento devem atualizar docs e cenarios.
- Skills podem evoluir sem inflar o perfil base.
- Scripts e hooks automatizam verificacoes mecanicas.
- O projeto exige manutencao disciplinada para nao virar documentacao decorativa.

## Gatilho para revisitar

Revisitar se a manutencao do harness passar a exigir mais tempo que o ganho de qualidade, ou se as skills deixarem de ser acionadas por falta de clareza nos gatilhos.

