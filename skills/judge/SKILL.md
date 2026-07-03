---
name: judge
description: Use when uma tarefa de alto esforco ou dificuldade precisa de um juiz robusto e contraparte adversarial antes de concluir.
---

# judge

## Regra central

Em tarefas de maior esforco/dificuldade (risco alto, decisao arquitetural, plano
complexo, mudanca sensivel), acione um juiz robusto para avaliar o artefato pelos
7 criterios da rubrica e produzir uma contraparte adversarial que melhore a
resposta. Nao e o fluxo comum — e uma escalada deliberada. Integra com a skill
`adversarial-review`.

## Checklist

1. Gere o artefato (resposta, plano ou relatorio) num arquivo.
2. Rode `scripts/judge.sh '<arquivo>' '<contexto/pedido>'`.
3. Leia as notas por criterio e a contraparte; incorpore as criticas antes de concluir.
4. Se a media for menor que 2, revise e rejulgue.

## Red flags

- Concluir uma tarefa dificil sem contraparte independente.
- Media abaixo de 2 ignorada.
- Elogio vazio do juiz aceito como aprovacao.
