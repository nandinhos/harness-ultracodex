---
name: visual-verification
description: Use when a task changes UI, layout, frontend behavior, browser interaction, screenshots, visual regressions, E2E flows, accessibility-visible states, or anything that must be inspected in a browser.
---

# Visual Verification

## Regra central

UI nao esta verificada ate ser vista ou testada em navegador.

## Ferramenta

Use Playwright quando disponivel para:

- teste E2E;
- screenshot;
- trace;
- verificacao visual de fluxo;
- evidencia de regressao visual.

## Minimo aceitavel

- Mudanca visual simples: screenshot ou inspecao Playwright.
- Fluxo interativo: teste E2E ou trace.
- Falha visual: evidencia antes e depois quando possivel.

## Red flags

- "Compilou" usado como prova visual.
- Nenhum viewport relevante verificado.
- Screenshot ausente em mudanca de layout.
