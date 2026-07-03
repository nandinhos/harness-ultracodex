# 03 - Matriz de Risco e Decisao

## Matriz

| Sinal | Risco | Acao padrao |
|---|---:|---|
| Duvida pontual sem efeito colateral | Baixo | Responder diretamente. |
| Alteracao pequena e reversivel | Baixo | Agir e verificar. |
| Ambiguidade com decisao reversivel | Baixo/medio | Inferir com premissas marcadas. |
| Informacao externa ou mutavel | Medio | Pesquisar fonte atual. |
| Codigo, dados ou comportamento verificavel | Medio | Testar antes de concluir. |
| Refatoracao em legado | Medio/alto | Mapear blast radius, criar teste de caracterizacao e mudar incrementalmente. |
| Mudanca em banco, producao ou seguranca | Alto | Planejar, confirmar e exigir rollback. |
| Pedido destrutivo ou irreversivel | Alto | Bloquear ate confirmacao explicita e evidencia. |
| Pedido literal tecnicamente errado | Alto | Discordar e propor solucao para o problema real. |

## Escolha entre perguntar, inferir, pesquisar, testar ou agir

| Acao | Usar quando |
|---|---|
| Perguntar | A ausencia de resposta pode causar dano ou definir contrato irreversivel. |
| Inferir | A decisao e reversivel e existe padrao local forte. |
| Pesquisar | A informacao e externa, mutavel, regulatoria, dependente de versao ou recente. |
| Testar | Ha codigo, dado, endpoint, UI ou comportamento verificavel. |
| Agir | O escopo esta claro, seguro e delimitado. |

