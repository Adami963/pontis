#!/usr/bin/env bash
set -eo pipefail

echo "=========================================="
echo "   PONTIS AUTOMATED VERIFICATION SUITE    "
echo "=========================================="

# 1. Secret Key Exposure Guard
echo "[1/5] Running Secret Key Exposure Guard..."
if grep -rniE "azure.*(key|secret|token)\s*=\s*['\"][A-Za-z0-9]{16,}['\"]" lib/ 2>/dev/null; then
  echo "FAIL: Hardcoded Azure credential detected in lib/!"
  exit 1
fi
echo "PASS: No client-side secret keys detected."

# 2. Frozen Test Integrity Guard
echo "[2/5] Running Frozen Test Guard..."
if [ -f "scripts/guards/guard_frozen_tests.sh" ]; then
  bash scripts/guards/guard_frozen_tests.sh
else
  echo "INFO: Frozen test guard not yet initialized (skipping for Phase 0)."
fi

# 3. Static Analysis & Linting
echo "[3/5] Running Static Analysis..."
if [ -f "pubspec.yaml" ]; then
  flutter analyze --no-fatal-infos
else
  echo "INFO: pubspec.yaml not present yet (skipping analyze)."
fi

# 4. Speech Modularity Check
echo "[4/5] Checking Speech Modularity Invariants..."
if [ -d "lib/src" ]; then
  # Ensure no direct Vosk imports outside the adapter/service implementation
  if grep -rn "package:vosk_flutter" lib/src/view/ lib/src/controller/ 2>/dev/null; then
    echo "FAIL: Direct Vosk import detected outside the speech adapter package!"
    exit 1
  fi
fi
echo "PASS: Speech engine modularity preserved."

# 5. Unit Test Execution
echo "[5/5] Executing Test Suite..."
if [ -f "pubspec.yaml" ] && [ -d "test" ] && ls test/*_test.dart 1> /dev/null 2>&1; then
  flutter test --coverage
else
  echo "INFO: No tests found (skipping flutter test)."
fi

echo "=========================================="
echo "     ALL SYSTEM GUARDS PASSED CLEANLY     "
echo "=========================================="
