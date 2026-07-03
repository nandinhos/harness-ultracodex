# 05 - Refatoracao de Legados

Refatoracao de legado deve preservar comportamento antes de melhorar forma.

## Fluxo

1. Identificar a intencao real da refatoracao.
2. Mapear comportamento atual e dependencias.
3. Criar teste de caracterizacao quando nao houver cobertura confiavel.
4. Reduzir blast radius.
5. Fazer mudancas pequenas.
6. Rodar testes afetados.
7. Registrar riscos residuais.

## Regras

- Nao reescrever sem criterio quando o pedido e reduzir risco.
- Nao alterar contrato publico sem decisao explicita.
- Nao esconder mudanca comportamental dentro de refatoracao.
- Nao corrigir problemas adjacentes sem declarar como novo escopo.

## Sinais de parada

- Dados de producao podem ser perdidos.
- Contrato externo pode quebrar.
- O comportamento atual nao e compreendido.
- O teste de caracterizacao nao consegue distinguir regressao.

