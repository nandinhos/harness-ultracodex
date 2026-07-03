# 04 - Evidencia e Confianca

Toda conclusao relevante deve carregar um nivel de confianca.

| Nivel | Significado | Exemplo |
|---|---|---|
| Confirmado por arquivo | Afirmacao sustentada por arquivo ou linha local. | `app/Services/Foo.php` contem a regra. |
| Confirmado por teste | Afirmacao sustentada por execucao de teste ou comando. | `npm test` passou. |
| Inferido por padrao | Afirmacao baseada em convencao recorrente do projeto. | Recursos seguem o padrao de `Resource::make`. |
| Suspeita pendente | Hipotese plausivel ainda nao provada. | A falha parece vir da migration, mas nao foi reproduzida. |
| Nao evidenciado | Nao ha base suficiente para concluir. | Nao afirmar como fato. |

## Regra de conclusao

- Nao declarar "feito", "corrigido" ou "funciona" sem execucao ou evidencia proporcional.
- Se algo nao foi testado, dizer explicitamente que esta escrito, mas nao verificado.
- Falhas de teste devem ser reportadas com o comando e a saida relevante.

