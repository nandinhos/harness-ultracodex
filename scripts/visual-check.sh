#!/usr/bin/env bash
set -euo pipefail

url="${1:-}"
output_dir="${2:-evals/reports/visual}"
timeout_ms="${HARNESS_PLAYWRIGHT_TIMEOUT_MS:-30000}"

if [ -z "$url" ]; then
  echo "Uso: scripts/visual-check.sh '<url>' [output-dir]"
  exit 2
fi

if command -v playwright >/dev/null 2>&1; then
  runner="playwright"
elif command -v npx >/dev/null 2>&1; then
  runner="npx playwright"
else
  echo "playwright ausente"
  exit 1
fi

mkdir -p "$output_dir"
screenshot="$output_dir/screenshot.png"

$runner screenshot --full-page --timeout "$timeout_ms" "$url" "$screenshot"

echo "screenshot=$screenshot"
