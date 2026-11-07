# Pontis Agentic Operating Manual & Decision Log

## 1. Team Operating Principles
This document governs collaboration between the 3 student engineers and Cursor Agent. Generated code is never authoritative; the SRS, the human-ratified domain contract (`pontis_contract.dart`), and frozen unit tests are authoritative.

## 2. Permitted Cursor Actions & Human Review Gates

### Safe Auto-Approval (No Human Review Needed)
- Creating intermediate files in scratch or test directories during a RED packet.
- Formatting code using `dart format .`.
- Executing read-only commands: `flutter analyze`, `dart doc`, `git status`, `git diff`.
- Running test suites: `flutter test`.

### Mandatory Human Review Gates (Agent Must Pause & Await Approval)
- Any modification to `docs/srs/` or `.cursorrules`.
- Ratification of the domain contract `lib/src/contract/pontis_contract.dart`.
- Transition from RED phase to GREEN phase (human reviews that tests faithfully represent the SRS).
- Any database schema migration or Supabase RLS policy definition.
- Committing code to the `main` or release branches.

## 3. Escalation Rules
If Cursor Agent encounters any of the following, it must halt execution and emit an **ESCALATION REPORT**:
1. **SRS Ambiguity:** A requirement has multiple plausible interpretations.
2. **Architectural Conflict:** A requested feature requires Model to reference Controller/View.
3. **Test Inconsistency:** A test cannot pass without changing an existing frozen contract.
4. **Credential Exposure:** A requested integration attempts to place secret keys in client code.

Format of Escalation Report:

    ESCALATION REPORT
    - Trigger:
    - Problem Description:
    - Proposed Solutions: Option A: / Option B:
    - Awaiting Human Instruction.

## 4. Decision Log
All architectural decisions and contract ratifications are appended below with date, author, and rationale.

| Date | Decision ID | Summary | Author | Status |
| :--- | :--- | :--- | :--- | :--- |
| 2026-11-06 | DEC-001 | Adopt Linux-native Flutter tarball & Bash for development environment | Team | Approved |
| 2026-11-06 | DEC-002 | Establish strict RED/GREEN session isolation and frozen test guard | Team | Approved |
