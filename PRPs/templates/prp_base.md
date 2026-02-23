name: "Base PRP Template v2 - Context-Rich with Validation Loops"
description: |

## Purpose
Template optimized for AI agents to implement features with sufficient context and self-validation capabilities to achieve working code through iterative refinement.

## Core Principles
1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

---

> **Note**: Adapt the specific syntax, linting, and testing commands in this template to match your project's stack (e.g., Python/Ruff/Pytest, Node/ESLint/Jest, Go/golangci-lint/Go Test).

## Goal
[What needs to be built - be specific about the end state and desires]

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
  
- file: [path/to/example.py]
  why: [Pattern to follow, gotchas to avoid]
  
- doc: [Library documentation URL] 
  section: [Specific section about common pitfalls]
  critical: [Key insight that prevents common errors]

- docfile: [PRPs/ai_docs/file.md]
  why: [docs that the user has pasted in to the project]

```

### Current Codebase tree (run `tree` in the root of the project) to get an overview of the codebase
```bash

```

### Desired Codebase tree with files to be added and responsibility of file
```bash

```

### Known Gotchas of our codebase & Library Quirks
```typescript
// CRITICAL: [Library name] requires [specific setup]
// Example: FastAPI/Express requires async functions for endpoints
// Example: This ORM doesn't support batch inserts over 1000 records
// Example: We use specific versions of our library that have X quirk
```

## Implementation Blueprint

### Data models and structure

Create the core data models, we ensure type safety and consistency.
```typescript
Examples: 
 - ORM/DB models
 - Validation schemas (e.g., Pydantic, Zod)
 - DTO schemas
 - Custom types
```

### list of tasks to be completed to fulfill the PRP in the order they should be completed

```yaml
Task 1:
MODIFY src/existing_module.py:
  - FIND pattern: "class OldImplementation"
  - INJECT after line containing "def __init__"
  - PRESERVE existing method signatures

CREATE src/new_feature.py:
  - MIRROR pattern from: src/similar_feature.py
  - MODIFY class name and core logic
  - KEEP error handling pattern identical

...(...)

Task N:
...

```


### Per task pseudocode as needed added to each task
```typescript
// Task 1
// Pseudocode with CRITICAL details dont write entire code
async function newFeature(param: string): Promise<Result> {
    // PATTERN: Always validate input first (see src/validators.ts)
    const validated = validateInput(param); 
    
    // GOTCHA: This library requires connection pooling
    const conn = await db.getConnection(); 
    
    try {
        // CRITICAL: API returns 429 if >10 req/sec
        await rateLimiter.acquire();
        const apiResponse = await externalApi.call(validated);
        
        // PATTERN: Standardized response format
        return formatResponse(apiResponse); 
    } finally {
        conn.release();
    }
}
```

### Integration Points
```yaml
DATABASE:
  - migration: "Add column 'feature_enabled' to users table"
  - index: "CREATE INDEX idx_feature_lookup ON users(feature_id)"
  
CONFIG:
  - add to: src/config/index
  - pattern: "FEATURE_TIMEOUT = process.env.FEATURE_TIMEOUT || 30"
  
ROUTES:
  - add to: src/api/routes  
  - pattern: "router.register('/feature', featureHandler)"
```

## Validation Loop

### Level 1: Syntax & Style
```bash
# Run these FIRST - fix any errors before proceeding
{{YOUR_LINTER_COMMAND}} --fix  # Auto-fix what's possible
{{YOUR_TYPECHECK_COMMAND}}     # Type checking (e.g., tsc --noEmit or mypy .)

# Expected: No errors. If errors, READ the error and fix.
```

### Level 2: Unit Tests each new feature/file/function use existing test patterns
```typescript
// CREATE test file with these test cases:
test('happy path works', async () => {
    // Basic functionality works
    const result = await newFeature("valid_input");
    expect(result.status).toBe("success");
});

test('invalid input throws validation error', async () => {
    // Invalid input throws specific Error
    await expect(newFeature("")).rejects.toThrow(ValidationError);
});

test('handles API timeouts gracefully', async () => {
    // Should capture timeout and return safe fallback/error response
    mockExternalApiCall.mockRejectedValueOnce(new TimeoutError());
    const result = await newFeature("valid");
    expect(result.status).toBe("error");
});
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

## Final validation Checklist
- [ ] All tests pass: `{{YOUR_TEST_COMMAND_HERE}}`
- [ ] No linting errors: `{{YOUR_LINTER_COMMAND}}`
- [ ] No type errors: `{{YOUR_TYPECHECK_COMMAND}}`
- [ ] Manual test successful: [specific curl/command]
- [ ] Error cases handled gracefully
- [ ] Logs are informative but not verbose
- [ ] Documentation updated if needed

---

## Anti-Patterns to Avoid
- ❌ Don't create new patterns when existing ones work
- ❌ Don't skip validation because "it should work"  
- ❌ Don't ignore failing tests - fix them
- ❌ Don't use sync functions in async context
- ❌ Don't hardcode values that should be config
- ❌ Don't catch all exceptions - be specific