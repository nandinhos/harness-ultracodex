#!/usr/bin/env bash
# Lib compartilhada: monta um runtime Codex isolado a partir de um perfil.
# Uso: `source` este arquivo e chame `build_runtime <profile_name> <runtime_dir>`.
# Nao deve ser executado diretamente.

build_runtime() {
  local profile_name="$1"
  local runtime="$2"
  local project_root
  project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

  local profile_dir="$project_root/profiles/$profile_name"

  mkdir -p "$runtime/skills"

  cp "$profile_dir/AGENTS.md" "$runtime/AGENTS.md"
  cp "$profile_dir/config.toml" "$runtime/$profile_name.config.toml"

  # Deriva o config.toml carregado do config.toml do perfil (fonte unica de model,
  # effort e MCP) e anexa o bloco de confianca do projeto. Assim, qualquer
  # [mcp_servers.*] do perfil (ex.: context7) fica na config base, visivel a
  # sessoes e a `codex mcp list`/`codex doctor`.
  {
    cat "$profile_dir/config.toml"
    printf '\n[projects."%s"]\ntrust_level = "trusted"\n' "$project_root"
  } > "$runtime/config.toml"

  local skill name hook
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
    name="$(basename "$hook")"
    cp "$hook" "$runtime/hooks/$name"
    chmod +x "$runtime/hooks/$name"
  done

  # Autenticacao: symlink para o auth.json do Codex do host. O runtime default fica
  # sob .runtime/ (gitignored), entao a via git esta protegida. NAO empacote o
  # runtime seguindo symlinks (evite tar -h, cp -rL, rsync -L) — ver SECURITY.md.
  if [ -f "$HOME/.codex/auth.json" ] && [ ! -e "$runtime/auth.json" ]; then
    ln -s "$HOME/.codex/auth.json" "$runtime/auth.json"
  fi

  echo "runtime=$runtime"
  echo "profile=$profile_name"
}
