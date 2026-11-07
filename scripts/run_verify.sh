#!/usr/bin/env bash
set -eo pipefail

echo "=========================================================="
echo "    PONTIS AUTOMATED VERIFICATION & QUALITY GATE          "
echo "=========================================================="

# 1. Secret Key Exposure Guard (SRS §3.1.4, §3.5.1, §4.4)
echo "[1/6] Running Secret Key Exposure Guard..."
if grep -rnE "(azure|speech).*(key|secret|token)\s*=\s*['\"][A-Za-z0-9]{16,}['\"]" lib/ 2>/dev/null; then
  echo "FAIL: Hardcoded Azure credential detected in lib/!"
  echo "Violation of SRS §3.1.4 & §4.4: Keys must reside exclusively in Supabase Edge Functions."
  exit 1
fi
echo "PASS: Zero client-side credentials detected."

# 2. Speech Engine Modularity Guard (SRS §3.2.3, §3.5.1, §4.4)
echo "[2/6] Running Speech Recognition Modularity Guard..."
if grep -rn "package:vosk_flutter" lib/src/view/ lib/src/controller/ lib/src/model/ 2>/dev/null; then
  echo "FAIL: Direct Vosk import detected outside the speech adapter service!"
  echo "Violation of SRS §3.5.1: Speech engine must sit behind SpeechRecognitionEngine interface."
  exit 1
fi
echo "PASS: Speech engine interface decoupling verified."

# 3. Frozen Test Integrity Guard
echo "[3/6] Running Frozen Test Suite Guard..."
if [ -f "scripts/guards/guard_frozen_tests.sh" ]; then
  bash scripts/guards/guard_frozen_tests.sh
else
  echo "INFO: Frozen test manifest not yet initialized (skipping for early setup)."
fi

# 4. Dart Formatting & Static Analysis
echo "[4/6] Running Static Analyzer & Linters..."
dart format --output=none --set-exit-if-changed lib/ test/
flutter analyze --no-fatal-infos

# 5. Architecture Package Boundary Guard
echo "[5/6] Checking MVC Package Boundaries..."
# Model must NEVER depend on View or Controller
if grep -rnE "import\s+['\"].*(view|controller)/" lib/src/model/ 2>/dev/null; then
  echo "FAIL: Architectural Violation! lib/src/model/ imports View or Controller classes."
  exit 1
fi
echo "PASS: MVC package isolation strictly preserved."

# 6. Execute Unit Tests & Code Coverage
echo "[6/6] Running Test Suite..."
if ls test/*_test.dart 1> /dev/null 2>&1 || ls test/**/*_test.dart 1> /dev/null 2>&1; then
  flutter test --coverage
else
  echo "INFO: No unit tests declared yet."
fi

echo "=========================================================="
echo "    ALL SYSTEM GUARDS & VERIFICATIONS PASSED CLEANLY      "
echo "=========================================================="
