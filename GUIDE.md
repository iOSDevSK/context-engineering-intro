# Context Engineering Framework — Practical Guide

A concise, actionable guide to using this framework. For background theory, see [README.md](./README.md). For Claude Code tips, see [claude-code-full-guide/](./claude-code-full-guide/README.md). For multi-agent workflow design, see [Workflow Architecture Guide](./claude-code-full-guide/workflow-architecture-guide.md).

---

## What You Write vs. What AI Generates

| You write (once) | Purpose | You write (per feature) | AI generates |
|---|---|---|---|
| `CLAUDE.md` | Project rules, conventions, style | `INITIAL.md` | `PRPs/*.md` (implementation plan) |
| `.claude/commands/*.md` | Reusable slash commands | | Code, tests, docs |
| `.claude/agents/*.md` | Subagent definitions | | |

---

## Setup (One-Time)

### 1. Copy the framework into your project

```
your-project/
├── CLAUDE.md                       # Edit: your project rules
├── INITIAL.md                      # Edit: per feature
├── PRPs/
│   └── templates/
│       └── prp_base.md             # PRP template (keep as-is or customize)
└── .claude/
    ├── commands/
    │   ├── generate-prp.md         # /generate-prp command
    │   ├── execute-prp.md          # /execute-prp command
    │   └── optimize-prompt.md      # /optimize-prompt command
    └── agents/                     # Optional: add subagents here
```

### 2. Write your CLAUDE.md

This file is loaded into **every** Claude Code conversation. Define:

- **Language/framework** — what stack you use
- **Code conventions** — naming, file size limits, module organization
- **Testing rules** — framework, coverage target, test patterns
- **Style** — formatting, linting, type hints
- **Security** — no hardcoded secrets, input validation

Keep it dense. Every token here costs context in every session. Run `/optimize-prompt CLAUDE.md` after writing it.

See `claude-code-full-guide/CLAUDE.md` for a Python-specific example.

### 3. Add examples (optional but powerful)

Place code examples in `examples/`. AI performs significantly better when it can see patterns to follow — existing code from your project, similar implementations, test patterns.

---

## Workflow (Per Feature)

### Step 1: Write INITIAL.md

Describe what you want. Four sections:

```markdown
## FEATURE
What to build. Be specific — not "build an API" but "build a REST API
with JWT auth, user CRUD endpoints, and rate limiting using FastAPI."

## EXAMPLES
Code to follow. Files in your project, GitHub repos, snippets.
- Similar endpoint: src/api/users.py
- Auth pattern: examples/auth-flow.py

## DOCUMENTATION
URLs the AI needs to read.
- FastAPI docs: https://fastapi.tiangolo.com/
- JWT library: https://pyjwt.readthedocs.io/

## OTHER CONSIDERATIONS
What AI will miss without being told.
- We use Pydantic v2 (not v1)
- Rate limit: 100 req/min per user
- Database migrations via Alembic
```

See `INITIAL_EXAMPLE.md` for a complete real-world example.

### Step 2: Generate PRP

```
/generate-prp INITIAL.md
```

This will:
1. Read your feature request
2. Analyze your codebase for patterns
3. Research documentation
4. Generate a comprehensive PRP in `PRPs/your-feature.md`
5. Review the PRP for noise, missing context, and conflicts (manual quality checklist)
6. Score confidence 1-10

### Step 3: Review the PRP

Before executing, check:
- Are success criteria realistic and measurable?
- Is all needed context included (docs, examples, gotchas)?
- Are validation commands correct for your project?
- Does the implementation blueprint make sense?

Optional: `/optimize-prompt PRPs/your-feature.md` to tighten it.

### Step 4: Execute

```
/execute-prp PRPs/your-feature.md
```

AI will:
1. Read all context from the PRP
2. Plan the implementation
3. Write code step by step
4. Run validation (lint, tests)
5. Fix failures and re-run until passing
6. Verify all success criteria are met

---

## Commands Reference

| Command | What it does | When to use |
|---|---|---|
| `/generate-prp INITIAL.md` | Creates a PRP from your feature request | Start of every feature |
| `/execute-prp PRPs/feature.md` | Implements code from a PRP | After reviewing the PRP |
| `/optimize-prompt path/to/file.md` | Maximizes signal-to-noise ratio | On CLAUDE.md, agents, commands, PRPs |
| `/direct-task "task desc"` | Direct task implementation without PRP overhead | For minor fixes, typos, or small UI tweaks |
| `/cleanup-tmp` | Deletes execution trace files from `tmp/` | When the workspace gets cluttered with agent artifacts |

---

## Subagents (Optional)

Define specialized agents in `.claude/agents/`. Each agent gets its own context window with focused expertise.

**Example: `.claude/agents/validation-gates.md`**
```markdown
---
name: validation-gates
description: "Test runner. Proactively runs tests after code changes."
tools: Bash, Read, Grep, Glob
---

Run all tests. If any fail, read the error, fix the code, re-run.
Never mark a task complete with failing tests.
```

**Example: `.claude/agents/documentation-manager.md`**
```markdown
---
name: documentation-manager
description: "Docs updater. Proactively updates documentation when code changes."
tools: Read, Write, Edit, Grep, Glob
---

When code changes, update relevant documentation: README, API docs,
inline comments. Ensure docs match the current implementation.
```

Key rules:
- One specialty per agent
- Only give tools the agent needs
- Use "Proactively" in description for automatic invocation
- Agents receive a single prompt — make it self-contained

---

## Prompt Optimization

The `/optimize-prompt` command analyzes any file and:

1. **Removes noise** — empty phrases, redundancy, filler words
2. **Adds missing signal** — examples for vague requirements, edge case handling, negative constraints
3. **Resolves conflicts** — contradictory requirements get prioritized or made conditional
4. **Clarifies priorities** — marks critical (P0) vs. nice-to-have (P2)
5. **Verifies completeness** — maps every original requirement to the optimized version

**Where to apply it (by ROI):**

| Target | ROI | Why |
|---|---|---|
| `CLAUDE.md` | Highest | Loaded in every conversation — savings compound |
| Agent definitions | High | Agents get limited context — precision matters |
| Slash commands | High | Clearer instructions = better command execution |
| Generated PRPs | Medium | Already structured, but may have verbosity from generation |
| `INITIAL.md` | Low | User-written, meant to be descriptive and free-form |

---

## Multi-Agent Workflows

For complex tasks, see the [Workflow Architecture Guide](./claude-code-full-guide/workflow-architecture-guide.md). Quick summary:

| Strategy | When | Example |
|---|---|---|
| **Direct work** | Trivial tasks, <2K token output | Fix a typo, add one function |
| **Sequential subagents** | Dependent steps, shared files | Migrate DB then update API |
| **Parallel subagents** | 3+ independent tasks | Check grammar + style + accuracy simultaneously |
| **Split large outputs** | Expected output >20K tokens | Generate a 30-page document in sections |
| **Agent teams** | Cross-agent coordination needed | Frontend + backend agents negotiating API contract |

Key constraints:
- Subagents cannot spawn subagents (flat hierarchy only)
- Context window: 200K tokens (input + output combined)
- Max output per response: 64K tokens
- Use foreground + file-based communication as default

---

## Quick Checklist

Starting a new feature:

- [ ] `CLAUDE.md` exists with project rules
- [ ] `INITIAL.md` written with FEATURE, EXAMPLES, DOCUMENTATION, OTHER CONSIDERATIONS
- [ ] Examples in `examples/` if available
- [ ] Run `/generate-prp INITIAL.md`
- [ ] Review the generated PRP
- [ ] Run `/execute-prp PRPs/feature.md`
- [ ] Verify all tests pass and success criteria met

Maintaining the framework:

- [ ] Run `/optimize-prompt CLAUDE.md` after major changes
- [ ] Update `CLAUDE.md` when conventions evolve
- [ ] Add new agent definitions as needed
- [ ] Keep examples up to date with current patterns
