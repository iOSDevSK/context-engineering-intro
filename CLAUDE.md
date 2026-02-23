# Project Rules

> Customize this file for your project. Every token here is loaded into every Claude Code conversation — keep it dense. Run `/optimize-prompt CLAUDE.md` after editing.
> For a language-specific example, see `claude-code-full-guide/CLAUDE.md`.

## Project Awareness

- If `PLANNING.md` exists, read it at the start of each conversation for architecture, goals, and constraints.
- If `TASK.md` exists, check it before starting work. Add new tasks if missing.
- Follow naming conventions, file structure, and patterns defined in `PLANNING.md` (if it exists).

> Create `PLANNING.md` and `TASK.md` for your project — they are not part of this template.

## Code Structure

- Max 500 lines per file. Split into modules when approaching the limit.
- Organize by feature or responsibility.
- Use clear, consistent imports.
- Load secrets from environment variables — never hardcode them.

## Testing

- Write tests for every new feature: at least 1 happy path, 1 edge case, 1 failure case.
- Tests live in `/tests`, mirroring the main app structure.
- After changing logic, check whether existing tests need updating.

## Task Tracking

- Mark completed tasks in `TASK.md` immediately.
- Add discovered sub-tasks under a "Discovered During Work" section.

## Style & Conventions

> **REQUIRED — Replace these placeholders with your project's specifics before using the framework:**

- **Language**: <!-- e.g., Python 3.12, TypeScript 5.x, Go 1.22 -->
- **Formatter/Linter**: <!-- e.g., ruff, eslint, golangci-lint -->
- **Type checking**: <!-- e.g., mypy, tsc --noEmit, go vet -->
- **Framework**: <!-- e.g., FastAPI, Next.js, Gin -->
- **ORM/DB**: <!-- e.g., SQLAlchemy, Prisma, GORM -->
- **Validation**: <!-- e.g., pydantic, zod, validator -->
- **Test runner**: <!-- e.g., pytest, jest, go test -->
- **Package manager**: <!-- e.g., uv, npm, pnpm, cargo -->

## Documentation

- Update `README.md` when features, dependencies, or setup steps change.
- Comment non-obvious logic with `# Reason:` explaining why, not what.

## AI Behavior

- Never assume missing context — ask when uncertain.
- Confirm file paths and module names exist before referencing them.
- Never delete or overwrite existing code unless explicitly instructed.
- Never hallucinate libraries or functions — use verified packages only.
- When a validation loop fails 3+ times on the same error, stop and report the root cause instead of retrying.
