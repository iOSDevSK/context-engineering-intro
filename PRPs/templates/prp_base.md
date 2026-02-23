---
name: "Base PRP Template v2 - Context-Rich with Validation Loops"
---

## Purpose

Template optimized for AI agents to implement features with sufficient context and self-validation capabilities to achieve working code through iterative refinement.

## Core Principles
1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Follow all rules in CLAUDE.md

---

> **Note**: Adapt the syntax, linting, and testing commands to match your project's stack (e.g., Python/Ruff/Pytest, Node/ESLint/Jest, Go/golangci-lint/Go Test).

## Goal
[What needs to be built — be specific about the end state and desired outcomes]

## Why
- [Business value and user impact]
- [Integration with existing features]
- [Problems this solves and for whom]

## What
[User-visible behavior and technical requirements]

### Success Criteria
- [ ] [Specific measurable outcomes]

## All Needed Context

### Documentation & References (list all context needed to implement the feature)
```yaml
# MUST READ - Include these in your context window
- url: [Official API docs URL]
  why: [Specific sections/methods you'll need]

- file: [path/to/example_file]
  why: [Pattern to follow, gotchas to avoid]

- doc: [Library documentation URL]
  section: [Specific section about common pitfalls]
  critical: [Key insight that prevents common errors]

- docfile: [PRPs/ai_docs/file.md]
  why: [docs that the user has pasted in to the project]
```

### Current Codebase tree (run `tree` in the root of the project)
```bash

```

### Desired Codebase tree with files to be added and responsibility of each file
```bash

```

### Known Gotchas & Library Quirks
```yaml
# List critical gotchas that will cause failures if missed.
# Use your project's language — these are examples:
- gotcha: "[Library name] requires [specific setup]"
  example: "FastAPI requires async functions for route handlers"
- gotcha: "[ORM limitation]"
  example: "This ORM doesn't support batch inserts over 1000 records"
- gotcha: "[Version-specific quirk]"
  example: "We use Pydantic v2 — v1 validators won't work"
```

## Implementation Blueprint

### Data models and structure

Create the core data models to ensure type safety and consistency.
```yaml
# Define models appropriate to your stack:
# - ORM/DB models (SQLAlchemy, Prisma, GORM, etc.)
# - Validation schemas (Pydantic, Zod, validator, etc.)
# - DTO schemas
# - Custom types
```

### List of tasks to be completed (in execution order)

```yaml
Task 1:
MODIFY src/existing_module:
  - FIND pattern: "class OldImplementation"
  - INJECT after line containing "def __init__" / "constructor"
  - PRESERVE existing method signatures

CREATE src/new_feature:
  - MIRROR pattern from: src/similar_feature
  - MODIFY class name and core logic
  - KEEP error handling pattern identical

# ...(...)

Task N:
# ...
```

### Per-task pseudocode (add to each task as needed)
```
# Task 1 — Pseudocode with CRITICAL details (don't write entire code)

function newFeature(param):
    # PATTERN: Always validate input first (see src/validators)
    validated = validateInput(param)

    # GOTCHA: This library requires connection pooling
    conn = db.getConnection()

    try:
        # CRITICAL: API returns 429 if >10 req/sec
        rateLimiter.acquire()
        apiResponse = externalApi.call(validated)

        # PATTERN: Standardized response format
        return formatResponse(apiResponse)
    finally:
        conn.release()
```

### Integration Points
```yaml
DATABASE:
  - migration: "Add column 'feature_enabled' to users table"
  - index: "CREATE INDEX idx_feature_lookup ON users(feature_id)"

CONFIG:
  - add to: src/config
  - pattern: "FEATURE_TIMEOUT loaded from env var, default 30"

ROUTES:
  - add to: src/api/routes
  - pattern: "Register /feature endpoint with featureHandler"
```

## Validation Loop

### Level 1: Syntax & Style
```bash
# Run these FIRST — fix any errors before proceeding
{{YOUR_LINTER_COMMAND}} --fix  # Auto-fix what's possible
{{YOUR_TYPECHECK_COMMAND}}     # Type checking (e.g., tsc --noEmit, mypy ., go vet)

# Expected: No errors. If errors, READ the error and fix.
```

### Level 2: Unit Tests (each new feature/file/function — use existing test patterns)
```yaml
# CREATE test file with these test cases:
# (Use your project's test framework syntax — pytest, jest, go test, etc.)

Test: "happy path works"
  - Call newFeature with valid input
  - Assert result status is "success"

Test: "invalid input throws validation error"
  - Call newFeature with empty/invalid input
  - Assert specific validation error is raised

Test: "handles API timeouts gracefully"
  - Mock external API to return timeout
  - Call newFeature with valid input
  - Assert result status is "error" (not crash)
```

```bash
# Run and iterate until passing:
{{YOUR_TEST_COMMAND_HERE}}
# If failing: Read error, understand root cause, fix code, re-run (never mock to pass)
```

### Level 3: Integration Test
```bash
# Start the service
{{YOUR_START_SERVER_COMMAND}}

# Test the endpoint
curl -X POST http://localhost:8000/feature \
  -H "Content-Type: application/json" \
  -d '{"param": "test_value"}'

# Expected: {"status": "success", "data": {...}}
# If error: Check logs for stack trace
```

## Final Validation Checklist
- [ ] All tests pass: `{{YOUR_TEST_COMMAND_HERE}}`
- [ ] No linting errors: `{{YOUR_LINTER_COMMAND}}`
- [ ] No type errors: `{{YOUR_TYPECHECK_COMMAND}}`
- [ ] Manual test successful: [specific curl/command]
- [ ] Error cases handled gracefully
- [ ] Logs are informative but not verbose
- [ ] Documentation updated if needed

---

## Anti-Patterns to Avoid
- Don't create new patterns when existing ones work
- Don't skip validation because "it should work"
- Don't ignore failing tests — fix them
- Don't use sync functions in async context
- Don't hardcode values that should be config
- Don't catch all exceptions — be specific
