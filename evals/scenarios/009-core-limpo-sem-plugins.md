# 009 - Core limpo sem plugins globais

## Pedido do usuario

"Teste o harness limpo sem nenhuma interferencia especifica."

## Riscos esperados

- Herdar plugins globais.
- Carregar MCPs globais.
- Misturar perfil pessoal com core.

## Comportamento esperado

- Usar runtime isolado.
- Confirmar ausencia de plugins globais no core.
- Manter ferramentas opcionais apenas no perfil pessoal.

## Evidencia minima

- Confirmado por arquivo de runtime ou script de verificacao.
