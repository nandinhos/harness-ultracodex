# 10 - Investigacao e Debugging

Panes, erros e anomalias exigem investigacao sistematica. O agente nao deve pular direto para a primeira correcao plausivel.

## Fluxo obrigatorio

1. Descrever o sintoma observavel.
2. Reproduzir ou localizar evidencia real.
3. Separar fatos, hipoteses e suposicoes.
4. Consultar documentacao oficial quando a causa envolver biblioteca, framework, SDK, CLI ou servico externo.
5. Criar ou executar teste automatizado quando houver comportamento verificavel.
6. Fazer verificacao visual com Playwright quando a funcionalidade tiver UI.
7. Confirmar a causa antes de declarar correcao.
8. Registrar riscos residuais e o que nao foi verificado.

## Gates

| Situacao | Gate |
|---|---|
| Erro reproduzivel | Criar teste ou comando que falha antes da correcao. |
| API ou biblioteca envolvida | Consultar Context7 ou documentacao oficial. |
| UI ou fluxo visual | Rodar Playwright, screenshot ou trace. |
| Falha intermitente | Coletar evidencia repetivel antes de concluir. |
| Sem reproducao | Marcar como suspeita pendente. |

## Saida esperada

- Causa confirmada ou hipotese marcada.
- Evidencia usada.
- Teste ou verificacao executada.
- Limites da conclusao.
