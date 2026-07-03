#!/usr/bin/env bash
# Fonte unica da taxonomia de evidencia, consumida por score-scenario.sh e
# pre-finish-evidence-check.sh. Manter a regex aqui evita que renomear um rotulo
# faca o scorer e o gate divergirem em silencio.

# shellcheck disable=SC2034  # consumida via `source` por outros scripts
EVIDENCE_REGEX='Confirmado por arquivo|Confirmado por teste|Inferido por padrao|Suspeita pendente|Nao evidenciado|Não evidenciado'
