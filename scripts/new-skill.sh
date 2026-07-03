#!/usr/bin/env bash
set -euo pipefail

name="${1:-}"

if [ -z "$name" ]; then
  echo "Uso: scripts/new-skill.sh '<nome-da-skill>'"
  exit 2
fi

if ! printf '%s' "$name" | rg -q '^[a-z0-9-]+$'; then
  echo "Nome invalido. Use apenas letras minusculas, numeros e hifens."
  exit 1
fi

dir="skills/$name"

if [ -e "$dir" ]; then
  echo "Skill ja existe: $dir"
  exit 1
fi

mkdir -p "$dir"
cat > "$dir/SKILL.md" <<EOF
---
name: $name
description: Use when ...
---

# $name

## Regra central

Descreva a disciplina principal.

## Checklist

1. Primeiro passo.
2. Segundo passo.

## Red flags

- Sinal de risco.
EOF

echo "skill criada: $dir"
echo "adicione um cenario em evals/scenarios/ antes de aceitar esta skill"

