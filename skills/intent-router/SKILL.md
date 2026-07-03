---
name: intent-router
description: Use when a user request may contain a gap between the literal ask and the real operational need, especially for refactors, fixes, audits, legacy work, risky commands, ambiguous scope, or requests where the best delivery format is not obvious.
---

# Intent Router

## Regra central

Antes de agir, separe pedido literal, necessidade operacional e formato de entrega.

## Checklist

1. Escreva internamente o que o usuario pediu literalmente.
2. Identifique o resultado operacional que provavelmente importa.
3. Liste restricoes: producao, dados, tempo, stack, permissoes e escopo.
4. Liste riscos: perda de dados, regressao, falso positivo, overengineering e manutencao.
5. Escolha formato: resposta curta, plano, auditoria, codigo ou execucao incremental.

## Red flags

- "Refatore" pode significar reduzir risco, nao reescrever.
- "Trunque e reimporte" pode esconder problema de idempotencia.
- "Resolva rapido" nao autoriza quebrar dados ou producao.

