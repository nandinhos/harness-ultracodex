#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime="${HARNESS_CLEAN_RUNTIME:-$project_root/.runtime/codex-clean}"
profile_name="ultracode-architect-clean"

mkdir -p "$runtime/skills"

cp "$project_root/profiles/$profile_name/AGENTS.md" "$runtime/AGENTS.md"
cp "$project_root/profiles/$profile_name/config.toml" "$runtime/$profile_name.config.toml"

cat > "$runtime/config.toml" <<EOF
model = "gpt-5.5"
model_reasoning_effort = "high"
service_tier = "default"

[projects."$project_root"]
trust_level = "trusted"
EOF

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
