#!/usr/bin/env bash
set -euo pipefail

# Judge/critico robusto: avalia um artefato (resposta/plano/relatorio) pelos 7
# criterios da rubrica de qualidade e devolve uma CONTRAPARTE ADVERSARIAL para
# melhora-lo. Delega a um modelo robusto via hermes (default MiniMax).
#
# Acionar em tarefas de MAIOR ESFORCO/DIFICULDADE (ver skills/judge e a skill
# adversarial-review). Nao roda no fluxo comum — e uma escalada deliberada.
#
#   scripts/judge.sh '<arquivo-do-artefato>' ['<contexto/pedido>']
#
# Config: HARNESS_JUDGE_PROVIDER (default hermes), HARNESS_JUDGE_MODEL (default
# MiniMax-M3; ajuste para o id exato do seu hermes via `hermes model`).

artefato="${1:-}"
if [ -z "$artefato" ] || [ ! -f "$artefato" ]; then
  echo "Uso: scripts/judge.sh '<arquivo-do-artefato>' ['<contexto>']"
  exit 2
fi
contexto="${2:-}"

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rubrica="$(cat "$project_root/docs/rubricas/qualidade.md" 2>/dev/null || true)"

prompt="Voce e um JUIZ tecnico rigoroso e adversarial. Avalie o ARTEFATO usando a
RUBRICA de 7 criterios (0-3 cada; media minima 2 para aceitar). Responda em portugues:

1. Nota 0-3 por criterio (Seguranca, Integridade dos dados, Evidencia, Escopo, Inferencia, Testes, Discordancia) com 1 linha de justificativa.
2. Media e veredito (aceitar / revisar).
3. CONTRAPARTE ADVERSARIAL: os pontos mais fracos, o que esta errado ou faltando, e como melhorar — analise profunda, sem elogio vazio.

## RUBRICA
${rubrica}

## CONTEXTO
${contexto}

## ARTEFATO
$(cat "$artefato")"

HARNESS_DELEGATE_PROVIDER="${HARNESS_JUDGE_PROVIDER:-hermes}" \
HARNESS_LIGHT_MODEL="${HARNESS_JUDGE_MODEL:-MiniMax-M3}" \
  bash "$project_root/scripts/delegate.sh" "$prompt"
