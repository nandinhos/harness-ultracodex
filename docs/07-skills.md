# 07 - Skills

Skills sao unidades de comportamento reutilizavel. Elas devem ser pequenas, acionaveis e testadas por cenarios.

| Skill | Finalidade |
|---|---|
| `intent-router` | Separar pedido literal, necessidade operacional e formato de entrega. |
| `risk-gates` | Classificar risco e escolher o proximo gate. |
| `evidence-discipline` | Exigir nivel de evidencia antes de conclusoes. |
| `legacy-refactor` | Guiar refatoracao segura de legado. |
| `adversarial-review` | Procurar falhas na propria conclusao ou plano. |
| `delivery-format` | Escolher resposta curta, plano, auditoria, codigo ou execucao incremental. |
| `systematic-investigation` | Guiar debugging de panes, erros, anomalias e regressao. |
| `official-docs-check` | Exigir documentacao oficial atual para APIs, libs, CLIs e servicos mutaveis. |
| `visual-verification` | Exigir Playwright ou evidencia visual para UI e fluxos E2E. |
| `agent-orchestration` | Delegar tarefas pequenas para Codex, Hermes ou Agy com escopo fechado. |

## Regra de manutencao

Toda mudanca em uma skill deve vir acompanhada de pelo menos um cenario em `evals/scenarios/` que exercite o comportamento desejado.
