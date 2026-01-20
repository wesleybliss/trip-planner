#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root (script is in bin/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

usage() {
  echo "Usage: $(basename "$0")"
}

# Choose flutter binary, preferring FVM if configured
FLUTTER_BIN="flutter"
if command -v fvm >/dev/null 2>&1 && [ -f ".fvm/fvm_config.json" ]; then
  FLUTTER_BIN="fvm flutter"
fi

echo "Building Android App Bundle"

# Run the build
$FLUTTER_BIN build appbundle"

# Expected output
EXPECTED_AAB="build/app/outputs/bundle/Release/app-release.aab"

AAB_PATH=""
if [ -f "$EXPECTED_AAB" ]; then
  AAB_PATH="$EXPECTED_AAB"
else
  # Fallback search to handle AGP/Flutter output path variations
  CANDIDATES=$(find build/app/outputs/bundle -type f -name "app-release.aab" 2>/dev/null || true)

  if [ -n "$CANDIDATES" ]; then
    # Pick newest by mtime
    AAB_PATH=$(echo "$CANDIDATES" | xargs ls -t 2>/dev/null | head -n1)
  fi
fi

if [ -z "${AAB_PATH:-}" ] || [ ! -f "$AAB_PATH" ]; then
  echo "ERROR: Could not find .aab"
  echo "Expected: $EXPECTED_AAB"
  exit 1
fi

# Emit absolute path to the generated .aab
ABS_PATH="$(cd "$(dirname "$AAB_PATH")" && pwd)/$(basename "$AAB_PATH")"
echo ""
echo "AAB generated at:"
echo "$ABS_PATH"
