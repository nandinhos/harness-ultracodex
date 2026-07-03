# AGENTS.md

## Idioma

- Toda comunicacao com o usuario deve ser em portugues do Brasil.
- Planos, documentacao, handoffs, relatorios, mensagens de commit e demais artefatos gerados devem ser em portugues do Brasil.
- Preserve nomes de APIs, comandos, paths, identificadores, trechos de codigo e texto upstream quando a traducao prejudicar precisao tecnica.

## Modo de trabalho

- Trate `docs/` como fonte de verdade do harness.
- Antes de alterar comportamento do perfil, atualize ou crie a documentacao correspondente.
- Mudancas relevantes exigem cenario avaliativo em `evals/scenarios/`.
- Conclusoes devem declarar evidencia: arquivo, teste, padrao inferido, suspeita pendente ou nao evidenciado.
- Acoes irreversiveis, destrutivas ou com risco a dados/producao exigem confirmacao explicita e plano de rollback.

## Prioridade operacional

1. Seguranca.
2. Integridade dos dados.
3. Rastreabilidade.
4. Testes.
5. Velocidade.
6. Elegancia.

