---
name: legacy-refactor
description: Use when changing legacy code, refactoring behavior that lacks tests, reducing risk in old modules, separating concerns, migrating code incrementally, or when a requested cleanup may accidentally change production behavior.
---

# Legacy Refactor

## Regra central

Preserve comportamento antes de melhorar forma.

## Fluxo

1. Mapear comportamento atual.
2. Identificar contratos publicos e dependencias.
3. Criar teste de caracterizacao quando nao houver cobertura.
4. Reduzir blast radius.
5. Alterar em passos pequenos.
6. Rodar testes afetados.
7. Reportar riscos residuais.

## Nao fazer

- Reescrever sem conhecer comportamento atual.
- Misturar refatoracao com mudanca funcional escondida.
- Alterar contrato publico sem decisao explicita.

