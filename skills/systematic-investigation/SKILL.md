---
name: systematic-investigation
description: Use when debugging panes, errors, anomalies, regressions, flaky behavior, broken tests, incidents, unexpected UI behavior, or any failure where jumping straight to a fix could hide the real cause.
---

# Systematic Investigation

## Regra central

Investigar antes de corrigir. Sintoma parecido nao prova causa igual.

## Fluxo

1. Descrever o sintoma observavel.
2. Reproduzir ou coletar evidencia.
3. Separar fatos, hipoteses e suposicoes.
4. Identificar o menor teste ou comando que distingue a causa.
5. Corrigir apenas depois de confirmar o mecanismo.
6. Verificar com teste automatizado ou prova equivalente.

## Red flags

- "Ja vi isso antes" sem evidencia discriminante.
- Erro sumiu, mas causa nao foi confirmada.
- Fix aplicado sem teste que falharia antes.
- Hipotese reportada como fato.
