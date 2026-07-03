# ADR 0006 - Judge delegado para tarefas de alto esforco

Status: aceito

Data: 2026-07-03

Owner: mantenedor do harness

## Contexto

A rubrica de qualidade (7 criterios) era avaliacao manual; `score-scenario.sh` e
apenas heuristica. Tarefas de maior esforco/dificuldade se beneficiam de um juiz
robusto independente que avalie e produza contraparte adversarial — sem virar
teatro (keyword) nem custo em toda tarefa.

## Opcoes consideradas

| Opcao | Vantagem | Custo |
|---|---|---|
| Scorer por keyword | Barato, offline | Baixo sinal; teatro de precisao. |
| LLM-judge no modelo principal | Sem nova dependencia | Custo em toda tarefa; sem contraparte externa. |
| Judge delegado a modelo robusto (hermes+MiniMax), gated a alto esforco | Julgamento real + contraparte; custo so quando importa | Depende do hermes e de um id de modelo configurado. |

## Decisao

`scripts/judge.sh`: monta um prompt com a rubrica de 7 criterios pedindo notas 0-3,
media, veredito e CONTRAPARTE ADVERSARIAL, e delega via `delegate.sh` com
`HARNESS_JUDGE_PROVIDER` (default `hermes`) e `HARNESS_JUDGE_MODEL` (default
`MiniMax-M3`, ajustavel ao id exato do hermes). Acionado deliberadamente em tarefas
de alto esforco (skill `judge`, integra com `adversarial-review`); nao roda no fluxo
comum.

## Consequencias

- Escalada de qualidade real (juiz robusto + contraparte) sem custo por tarefa.
- Modelo/provider parametrizados: o id do MiniMax deve casar com o hermes do usuario.
- O valor depende do gate acionar so no que importa (por isso limitado a alto esforco).

## Gatilho para revisitar

- Se o judge for acionado em excesso (custo), endurecer o gate.
- Se o id/rota do MiniMax no hermes mudar, atualizar `HARNESS_JUDGE_MODEL`/docs.
