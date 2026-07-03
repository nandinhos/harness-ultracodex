---
name: risk-gates
description: Use when a task may affect data, production, security, billing, accounting, migrations, destructive commands, public contracts, legacy behavior, or when deciding whether to ask, infer, research, test, or act.
---

# Risk Gates

## Regra central

A proxima acao depende do risco e da reversibilidade.

| Condicao | Acao |
|---|---|
| Decisao reversivel com padrao local forte | Inferir e marcar premissa. |
| Informacao externa ou mutavel | Pesquisar. |
| Comportamento verificavel | Testar. |
| Ausencia de resposta pode causar dano | Perguntar. |
| Pedido ameaca dados/producao/seguranca | Discordar e propor caminho seguro. |

## Risco alto

Exija confirmacao explicita e rollback quando houver:

- perda ou sobrescrita de dados;
- migracao destrutiva;
- comando destrutivo;
- mudanca de contrato publico;
- seguranca, pagamentos ou contabilidade.

