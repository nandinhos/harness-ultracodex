#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime="${HARNESS_PERSONAL_RUNTIME:-$project_root/.runtime/codex-nandodev}"
profile_name="nandodev-ultracode-extended"

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

if [ -f "$HOME/.codex/auth.json" ] && [ ! -e "$runtime/auth.json" ]; then
  ln -s "$HOME/.codex/auth.json" "$runtime/auth.json"
fi

echo "runtime=$runtime"
echo "profile=$profile_name"
