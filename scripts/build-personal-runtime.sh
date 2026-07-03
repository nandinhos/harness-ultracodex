#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime="${HARNESS_PERSONAL_RUNTIME:-$project_root/.runtime/codex-nandodev}"
profile_name="nandodev-ultracode-extended"

mkdir -p "$runtime/skills"

cp "$project_root/profiles/$profile_name/AGENTS.md" "$runtime/AGENTS.md"
cp "$project_root/profiles/$profile_name/config.toml" "$runtime/$profile_name.config.toml"

# Deriva o config.toml carregado do config.toml do perfil (fonte unica de model,
# effort e MCP) e anexa o bloco de confianca do projeto. Assim, qualquer
# [mcp_servers.*] do perfil (ex.: context7 no runtime pessoal) fica na config
# base, visivel a sessoes e a `codex mcp list`/`codex doctor`.
{
  cat "$project_root/profiles/$profile_name/config.toml"
  printf '\n[projects."%s"]\ntrust_level = "trusted"\n' "$project_root"
} > "$runtime/config.toml"

for skill in "$project_root"/skills/*; do
  [ -f "$skill/SKILL.md" ] || continue
  name="$(basename "$skill")"
  mkdir -p "$runtime/skills/$name"
  cp "$skill/SKILL.md" "$runtime/skills/$name/SKILL.md"
done

# Copia os hooks para o runtime para que sejam invocaveis pelo agente (ver AGENTS.md).
mkdir -p "$runtime/hooks"
for hook in "$project_root"/hooks/*.sh; do
  [ -f "$hook" ] || continue
  cp "$hook" "$runtime/hooks/$(basename "$hook")"
  chmod +x "$runtime/hooks/$(basename "$hook")"
done

if [ -f "$HOME/.codex/auth.json" ] && [ ! -e "$runtime/auth.json" ]; then
  ln -s "$HOME/.codex/auth.json" "$runtime/auth.json"
fi

echo "runtime=$runtime"
echo "profile=$profile_name"
