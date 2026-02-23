# Context Engineering Template

A template for Context Engineering — the discipline of providing AI coding assistants with the right context to implement features end to end.

> **Context Engineering is 10x better than prompt engineering and 100x better than vibe coding.**
> **This framework is fine-tuned to be a 10/10, out-of-the-box solution specifically designed for Claude Code.**

> **New here?** Start with the [Practical Guide](./GUIDE.md) for the full workflow.

## Quick Start

```bash
# 1. Clone this template
git clone https://github.com/coleam00/Context-Engineering-Intro.git
cd Context-Engineering-Intro

# 2. Edit CLAUDE.md with your project rules

# 3. Add code examples to examples/ (recommended)

# 4. Edit INITIAL.md with your feature requirements

# 5. Generate a PRP (Product Requirements Prompt)
/generate-prp INITIAL.md

# 6. Execute the PRP
/execute-prp PRPs/your-feature-name.md
```

## Core Workflow

```
CLAUDE.md (rules) + INITIAL.md (feature) + examples/
                        │
                  /generate-prp
                        │
                  PRPs/feature.md
                        │
                  /execute-prp
                        │
                  Working code + tests
```

See the [Practical Guide](./GUIDE.md) for detailed step-by-step instructions.

## Template Structure

```
context-engineering-intro/
├── .claude/
│   ├── commands/
│   │   ├── generate-prp.md    # Generates PRPs with post-generation quality review
│   │   ├── execute-prp.md     # Executes PRPs to implement features
│   │   └── optimize-prompt.md # Optimizes any file for signal-to-noise ratio
│   └── settings.local.json    # Claude Code permissions
├── claude-code-full-guide/
│   ├── README.md              # 10-tip guide to Claude Code
│   ├── workflow-architecture-guide.md  # Limits, context mechanics & multi-agent strategies
│   ├── CLAUDE.md              # Python-specific project rules example
│   ├── .claude/
│   │   ├── commands/          # Slash commands (primer, fix-github-issue, parallel)
│   │   └── agents/            # Subagent definitions (docs manager, validation gates)
│   └── install_claude_code_windows.md  # Windows WSL installation guide
├── PRPs/
│   ├── templates/
│   │   └── prp_base.md       # Base template for PRPs
│   └── EXAMPLE_multi_agent_prp.md  # Example of a complete PRP
├── examples/                  # Your code examples — add your own (see examples/README.md)
├── use-cases/                 # Specialized templates (Pydantic AI, MCP servers, agent factory)
├── validation/                # Validation utilities
├── CLAUDE.md                 # Global rules for AI assistant (language-agnostic template)
├── INITIAL.md               # Template for feature requests
├── GUIDE.md                 # Practical guide — how to use the framework
├── INITIAL_EXAMPLE.md       # Example feature request
└── README.md                # This file
```

This template doesn't focus on RAG and tools with context engineering because I have a LOT more in store for that soon. ;)

## What is Context Engineering?

**Prompt Engineering** is about clever wording — like giving someone a sticky note.

**Context Engineering** is a complete system — documentation, examples, rules, patterns, and validation loops — like writing a full screenplay.

Why it matters:
1. **Reduces AI failures** — most agent failures are context failures, not model failures
2. **Ensures consistency** — AI follows your project patterns
3. **Enables complex features** — multi-step implementations succeed with proper context
4. **Self-correcting** — validation loops let AI fix its own mistakes

## Commands

| Command | Purpose |
|---|---|
| `/generate-prp INITIAL.md` | Research codebase + create implementation blueprint |
| `/execute-prp PRPs/feature.md` | Implement code from a PRP with validation loops |
| `/optimize-prompt path/to/file.md` | Maximize signal-to-noise ratio of any file |
| `/direct-task "task desc"` | Bypass PRP for simple tasks like UI fixes or typos |
| `/cleanup-tmp` | Securely clean up `tmp/` folders from sub-agent runs |

Commands are defined in `.claude/commands/`. The `$ARGUMENTS` variable receives what you pass after the command name.

## Key Concepts

**PRP (Product Requirements Prompt)** — A comprehensive implementation blueprint that includes context, documentation, code patterns, step-by-step tasks, and executable validation gates. Similar to a PRD but crafted specifically for AI agents. See `PRPs/EXAMPLE_multi_agent_prp.md`.

**INITIAL.md** — Your feature request. Four sections: FEATURE, EXAMPLES, DOCUMENTATION, OTHER CONSIDERATIONS. See `INITIAL_EXAMPLE.md`.

**CLAUDE.md** — Project-wide rules loaded into every conversation. Keep it dense — every token costs context. The template provides a language-agnostic starting point; see `claude-code-full-guide/CLAUDE.md` for a Python-specific example.

**examples/** — Code from your project that AI should mimic. More examples = better output. See `examples/README.md` for guidance.

## Best Practices

1. **Be explicit in INITIAL.md** — don't assume AI knows your preferences
2. **Provide examples** — real code patterns from your project
3. **Use validation gates** — PRPs include executable tests that AI must pass
4. **Leverage documentation** — include URLs with specific sections
5. **Keep CLAUDE.md dense** — run `/optimize-prompt CLAUDE.md` after editing
6. **Review generated PRPs** — check context completeness before executing

## Resources

- [Practical Guide](./GUIDE.md) — step-by-step workflow, commands, subagents, multi-agent strategies
- [Claude Code Full Guide](./claude-code-full-guide/README.md) — 10 tips for effective Claude Code usage
- [Workflow Architecture Guide](./claude-code-full-guide/workflow-architecture-guide.md) — limits, context mechanics, multi-agent patterns
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)
