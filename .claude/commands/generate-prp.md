# Create PRP

## Feature file: $ARGUMENTS

Generate a complete PRP for general feature implementation with thorough research. Ensure context is passed to the AI agent to enable self-validation and iterative refinement. Read the feature file first to understand what needs to be created, how the examples provided help, and any other considerations.

The AI agent only gets the context you are appending to the PRP and training data. Assume the AI agent has access to the codebase and the same knowledge cutoff as you, so its important that your research findings are included or referenced in the PRP. The Agent has Websearch capabilities, so pass urls to documentation and examples.

## Research Process

1. **Codebase Analysis**
   - Search for similar features/patterns in the codebase
   - Identify files to reference in PRP
   - Note existing conventions to follow
   - Check test patterns for validation approach

2. **External Research**
   - Search for similar features/patterns online
   - Library documentation (include specific URLs)
   - Implementation examples (GitHub/StackOverflow/blogs)
   - Best practices and common pitfalls

3. **User Clarification** (if needed)
   - Specific patterns to mirror and where to find them?
   - Integration requirements and where to find them?

## PRP Generation

Read PRPs/templates/prp_base.md and use it as the structural template for the PRP:

### Critical Context to Include and pass to the AI agent as part of the PRP
- **Documentation**: URLs with specific sections
- **Code Examples**: Real snippets from codebase
- **Gotchas**: Library quirks, version issues
- **Patterns**: Existing approaches to follow

### Implementation Blueprint
- Start with pseudocode showing approach
- Reference real files for patterns
- Include error handling strategy
- list tasks to be completed to fulfill the PRP in the order they should be completed

### Validation Gates (Must be Executable) eg for python
```bash
# Syntax/Style
ruff check --fix && mypy .

# Unit Tests
uv run pytest tests/ -v

```

*** CRITICAL AFTER YOU ARE DONE RESEARCHING AND EXPLORING THE CODEBASE BEFORE YOU START WRITING THE PRP ***

*** ULTRATHINK ABOUT THE PRP AND PLAN YOUR APPROACH THEN START WRITING THE PRP ***

## Output
Save as: `PRPs/{feature-name}.md`

## Quality Checklist
- [ ] All necessary context included
- [ ] Validation gates are executable by AI
- [ ] References existing patterns
- [ ] Clear implementation path
- [ ] Error handling documented

## Signal Quality Gate (post-generation)

After writing the PRP, review it through these lenses before saving:

**Signal/Noise check:**
- Does every sentence carry unique information? Remove duplicates and filler
- Are there empty phrases ("It is important to note that...")? → state the requirement directly
- Is the same thing said multiple ways? → keep the clearest version

**Completeness check:**
- Are abstract requirements backed by concrete examples?
- Are edge cases and boundary conditions addressed?
- Are negative constraints explicit (what MUST NOT happen)?
- Is it clear what is critical (P0) vs. nice-to-have (P2)?

**Conflict check:**
- Do any requirements contradict each other?
- If yes: resolve by priority or define conditional rules

**Clarity check:**
- Could any requirement be interpreted multiple ways? → add example
- Are vague terms ("good performance", "clean code") defined with measurable criteria?

If any check fails → fix before saving. The goal is maximum information density with zero ambiguity.

Score the PRP on a scale of 1-10 (confidence level to succeed in one-pass implementation using Claude Code)

Remember: The goal is one-pass implementation success through comprehensive context.