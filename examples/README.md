# Examples

This folder is **intentionally empty** — populate it with code from your own project.

> **Why no mock examples?** Generic mock examples (e.g., a simple `agent.py`) provide zero value when the AI tries to match *your* architecture. The AI performs significantly better when it can see *your* real patterns to follow. The more relevant examples you provide, the better the generated code will match your project's conventions.

## What to Add

**Code patterns** — files that show how your project organizes modules, handles imports, defines classes/functions.

**Test patterns** — a representative test file showing your assertion style, mocking approach, and fixture setup.

**Integration patterns** — API clients, database connections, authentication flows, or similar code the AI should mimic.

## How to Reference Examples

In your `INITIAL.md`, point to specific files:

```markdown
## EXAMPLES
- API pattern: examples/api-client.py
- Test pattern: examples/test_users.py
- Auth flow: examples/auth-middleware.ts
```

The `/generate-prp` command will include these references in the PRP so the executing agent follows your patterns.

## Suggested Structure

```
examples/
├── README.md           # This file
├── api-client.py       # How you build API clients
├── data-model.py       # How you define data models
└── tests/
    ├── test_example.py # Test conventions
    └── conftest.py     # Shared fixtures
```

Adapt the structure and file types to your stack.
