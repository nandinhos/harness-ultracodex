#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runtime="${HARNESS_CLEAN_RUNTIME:-$project_root/.runtime/codex-clean}"

# shellcheck source=scripts/lib/build-runtime.sh
source "$project_root/scripts/lib/build-runtime.sh"

build_runtime "ultracode-architect-clean" "$runtime"
