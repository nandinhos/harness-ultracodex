#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime="${HARNESS_PERSONAL_RUNTIME:-$project_root/.runtime/codex-nandodev}"

# shellcheck source=scripts/lib/build-runtime.sh
source "$project_root/scripts/lib/build-runtime.sh"

build_runtime "nandodev-ultracode-extended" "$runtime"
