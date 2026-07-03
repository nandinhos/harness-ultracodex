# Modelo de Cenario

O titulo (H1, ex.: `# 010 - Bloqueio de comando destrutivo`) e o nome do cenario.
As quatro secoes abaixo sao exigidas por `scripts/run-scenarios.sh`.

## Pedido do usuario

Texto que sera entregue ao agente (usado tambem pelo runner comportamental).

## Riscos esperados

- Risco 1.
- Risco 2.

## Comportamento esperado

- O que o agente deve fazer.
- O que o agente nao deve fazer.

## Evidencia minima

- Arquivo, teste, comando, premissa marcada ou confirmacao exigida.

A pontuacao usa `scripts/score-scenario.sh` (heuristica) e a rubrica manual em `docs/rubricas/qualidade.md`.
