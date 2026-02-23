# Claude Code Limits & Workflow Architecture Guide

A reference document for designing multi-agent workflows in Claude Code. Explains hard limits, context mechanics, and strategies that work around these limits.

---

## 1. Hard Limits

| Parameter | Opus 4.6 | Sonnet 4.5 | Haiku 4.5 |
|:----------|:---------|:-----------|:----------|
| Context window | 200K | 200K | 200K |
| Context window (beta) | 1M | 1M | - |
| API max output | 128K | 64K | 64K |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` default | 32K | 32K | 32K |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` max | 64K | 64K | 64K |

**Subscription vs API key:** Claude Code enforces a 64K cap on `MAX_OUTPUT_TOKENS` regardless of the model's API limit. With an API key, Opus 4.6 supports 128K at the API level, but Claude Code still limits it to 64K.

**1M context window beta:** Requires usage tier 4. Supported by Opus 4.6 and Sonnet 4.5.

**Configuration:** Environment variable `CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000` or in `settings.json` under `env`.

---

## 2. How the Context Window Works

**Formula:**

```
context_window = input_tokens + output_tokens
```

**What counts toward output tokens:**

- Thinking tokens (reasoning, planning)
- Visible output (text, tool calls)
- Both components count toward `CLAUDE_CODE_MAX_OUTPUT_TOKENS`

**Key mechanism:** Thinking tokens from previous turns are automatically stripped - the Claude API does not carry them forward as input tokens. This saves context between turns.

**Consequence:** The more input tokens (system prompts, CLAUDE.md, loaded files), the less space remains for reasoning and output.

### Two Common Error Messages

1. **Output token limit exceeded:**
   ```
   API Error: Claude's response exceeded the 32000 output token maximum.
   To configure this behavior, set the CLAUDE_CODE_MAX_OUTPUT_TOKENS environment variable
   ```
   Cause: A single response exceeded `MAX_OUTPUT_TOKENS`. Solution: increase to 64K, or split the task.

2. **Context limit reached:**
   ```
   Context limit reached · /compact or /clear to continue
   ```
   Cause: Total context (input + output) reached the context window. Solution: `/compact` (compresses context) or `/clear` (clears context). Prevention: delegate to subagents.

---

## 3. Foreground vs Background Subagents

| Aspect | Foreground (default) | Background |
|:-------|:---------------------|:-----------|
| `run_in_background` | `false` | `true` |
| What is returned to the parent | The agent's entire final message | Only the path to the output file |
| Volume control | None - the entire response goes into the context | The parent reads as much as it wants via the Read tool |
| Parent blocking | Yes, waits for completion | No, the parent continues |
| Output file | None - the agent has no output file, the final message is returned directly to the parent | The entire transcript including tool calls and their outputs, not just the final message |
| Context cost for the parent | Minimal - the parent only receives the agent's final message | Potentially high - reading the output file via `Read` or `TaskOutput` pulls in the entire transcript (tool calls + outputs), which can be orders of magnitude more tokens than the final message itself |

**Recommendation:** Foreground + file-based communication is the optimal mode. The agent writes output to a file and returns only a short confirmation (~100 tokens). The parent receives minimal context and results are persisted in a file.

Background is suitable only when the parent does not need to wait for the result. Note: reading the output file via `TaskOutput` returns the entire transcript (thousands of tokens), not just the final message.

---

## 4. Architectural Constraints

### Subagents CANNOT Spawn Further Subagents

The Task tool is not available to subagents. This is an architectural constraint, not a configuration choice.

**The hierarchy is flat:** orchestrator → N subagents (max 1 level).

```
✅ Orchestrator → Agent A, Agent B, Agent C
❌ Orchestrator → Agent A → Agent A1, Agent A2
```

### Workarounds

- **Chaining from the main session:** The orchestrator runs subagents sequentially, where the output of one informs the prompt of the next
- **Skills:** Slash commands can orchestrate complex logic
- **Agent teams:** Multi-agent teams with coordination via a shared task list and messaging

---

## 5. Workflow Strategies

| # | Strategy | When to Use | Risk |
|:--|:---------|:------------|:-----|
| 0 | Direct work (single agent) | Trivial tasks (typo, 1 line). Subagent overhead exceeds the benefit | None |
| 1 | Sequential subagents | Default. Dependent tasks, shared file, unclear scope | Slow with >5 agents |
| 2 | Parallel subagents | 3+ independent tasks, no shared state | Requires consolidation |
| 3 | Splitting large outputs | Expected output > 20K tokens | Coordination between sections |
| 4 | Agent teams | Complex cross-layer coordination, long-running tasks | Highest overhead, hardest to debug |

Strategies can be combined (e.g., parallel checks + sequential implementation).

### Workflow Topology

Strategies are categorized by whether the workflow structure is known at design time:

**Fixed topology** (Strategies 0-3): The number of steps, dependencies, and order are known
in advance. The workflow is defined in the prompt and the orchestrator executes it mechanically.
Optimal for pipelines with deterministic structure.

**Dynamic topology** (Strategy 4): The structure forms at runtime. Tasks are created,
modified, or removed during execution. Requires runtime coordination - either via
Tasks Management (tracking) or Agent Teams (live collaboration).

**Edge case - dynamic task count:** If the number of steps in a single phase
depends on the output of a previous phase (e.g., N sections based on an outline), but
the overall phase structure is fixed → still a fixed topology. Prompt-driven orchestration
handles a dynamic count through a simple loop without the overhead of Tasks Management.

### Strategy 0: Direct Work

No subagents. The orchestrator does the work itself. For trivial tasks where the subagent overhead (context, latency) exceeds the benefit.

### Strategy 1: Sequential Subagents

```
Orchestrator:
  Agent 1 → reads document → edits → done
  Agent 2 → reads document (with edits from Agent 1) → edits → done
  ...
  Agent N → done
```

**Advantages:** No consolidation, no conflicts, debugging via `git diff`.
**Trade-off:** Slower. For 10 agents at ~60s each, that's ~10 min vs ~1-2 min in parallel.

### Strategy 2: Parallel Subagents

```
Orchestrator:
  In parallel:
    Agent 1 → results to tmp/{workflow}/01-agent1.md
    Agent 2 → results to tmp/{workflow}/02-agent2.md
    ...
  Consolidation agent → deduplication → consolidated.md
  Orchestrator presents results
```

**Consolidation is the price of speed.** Parallel agents may find the same problem or propose conflicting solutions.

**File-based communication:** Agents write results to files and return only a short confirmation. This saves the orchestrator's context.

### Strategy 3: Splitting Large Outputs

For documents > 20K output tokens. No single agent can generate an entire document at once. Heuristic: a document with more than 8-10 pages of text or 15+ code blocks will likely exceed this limit.

```
Orchestrator:
  Outline agent → outline of the entire document
  Per-section agents → each generates one section
  Assembly agent → assembles sections into the final document
```

Look for natural boundaries: sections, tasks, chapters. Generate dependent sections sequentially.

### Strategy 4: Agent Teams

For complex, long-running tasks with cross-layer coordination. Agents communicate via messaging and a shared task list.

```
TeamCreate → TaskCreate (N tasks) → Task (N agents)
  Agents: TaskList → claim → work → TaskUpdate → SendMessage
  Leader: coordinates, assigns, monitors
```

**Trade-offs:** Highest overhead (team config, messaging, task management). Use only when simpler strategies are insufficient.

#### Tasks Management vs. Agent Teams

These are two distinct concepts that differ in the level of coordination:

**Tasks Management** (TaskCreate/TaskUpdate/TaskList/TaskGet) = tracking layer.
Tasks are metadata - creating them DOES NOT spawn an agent. The orchestrator must still
manually spawn subagents and construct prompts.

- Available: main session (always), Agent Team teammates (within a team)
- NOT AVAILABLE: regular subagents (they do not have TaskCreate/TaskUpdate tools)
- Use without Agent Teams: the main session tracks its own work
  (persistent task list for multi-session projects, user-visible progress)

**Agent Teams** (TeamCreate/SendMessage) = execution layer built ON TOP OF Tasks
Management. Adds separate sessions, peer-to-peer messaging, and a shared task
pool. Teammates claim tasks from the pool on their own.

- Experimental feature: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Each teammate = separate Claude Code session = significantly higher costs
- Known limitations: no session resumption, slow shutdown, status lag

| Aspect | Prompt-driven | Tasks Management | Agent Teams |
|:-------|:-------------|:-----------------|:------------|
| Coordination | Prompt defines the procedure | Orchestrator tracks tasks | Teammates claim tasks |
| Token overhead | Minimal | ~2x orchestrator context | Highest (N separate sessions) |
| Persistence | None (prompt in memory) | Yes (~/.claude/tasks/) | Yes (team + tasks) |
| Topology | Fixed (deterministic) | Fixed and dynamic | Dynamic (emergent) |
| Dynamic task count | Loop in the orchestrator | TaskCreate at runtime (higher overhead) | Teammates create tasks |
| When to use | Most cases. Fixed pipelines | Multi-session, persistent tracking | Cross-agent negotiation, collaboration |

---

## 6. Orthogonal Dimensions

Four independent switches, combinable with any strategy:

### A. Communication Mode

| Mode | Mechanism | When |
|:-----|:----------|:-----|
| Direct output | Agent returns the result as a text message | Short outputs (<1K tokens) |
| File-based | Agent writes to a file, returns only a path/confirmation | Anything larger, parallel workflows |

### B. Execution Mode

| Mode | Mechanism | When |
|:-----|:----------|:-----|
| Foreground | `run_in_background: false` - parent waits | Default. Returns only the final message |
| Background | `run_in_background: true` - parent continues | When the parent does not need to wait |

### C. Consolidation

| Mode | Mechanism | When |
|:-----|:----------|:-----|
| No consolidation | Orchestrator processes outputs directly | Sequential workflows, few agents |
| Consolidation agent | A separate agent deduplicates and merges | Parallel workflows with potential overlaps |

### D. Coordination Mode

| Mode | Mechanism | When |
|:-----|:----------|:-----|
| Prompt-driven | Orchestrator follows the procedure defined in the prompt | Default. Fixed topology, deterministic dependencies |
| Task-tracked | Orchestrator uses TaskCreate/TaskUpdate for tracking | Multi-session projects, dynamic scope, user-visible progress |
| Agent Teams | TeamCreate + SendMessage + shared task pool | Live collaboration, cross-agent negotiation, emergent tasks |

### Decision Matrix

| Scenario | Communication | Execution | Consolidation | Coordination |
|:---------|:-------------|:----------|:--------------|:-------------|
| 1-2 simple tasks | Direct output | Foreground | None | Prompt-driven |
| 3+ parallel checks | File-based | Foreground | Consolidation agent | Prompt-driven |
| Long background generation | File-based | Background | None | Prompt-driven |
| Massive parallel scan | File-based | Foreground | Consolidation agent | Prompt-driven |
| Multi-session refactoring | File-based | Foreground | None | Task-tracked |
| Complex cross-layer feature | File-based | Foreground | Consolidation agent | Agent Teams |

**Optimal combination for most cases:** Foreground + file-based + consolidation agent (if parallel).

---

## 7. Practical Techniques

### The Orchestrator Delegates, Does Not Work

The orchestrator never does content work. It only launches agents, monitors completion, and triggers the next phase. It does not read agent definitions or target documents - each subagent loads what it needs on its own.

### Quality Prompt for a Subagent

A subagent cannot ask for clarification - the prompt must be self-contained:

1. **Context** - what is happening, why
2. **Precise instructions** - specific steps (not vague "fix it")
3. **File paths** - absolute paths to inputs and outputs
4. **Success criteria** - what output is expected

**Subagents inherit CLAUDE.md** - there is no need to repeat project rules in every prompt.

### `subagent_type` Automatically Loads the Agent Definition

The `subagent_type` parameter in the Task tool automatically loads the corresponding `.claude/agents/{type}.md` file into the subagent. The orchestrator DOES NOT READ agent files - that would unnecessarily burden its context.

### Efficient Output Formats

YAML > JSON for structured outputs (fewer tokens for the same content). But for human-readable reports, Markdown with tables is best.

### Task Decomposition

1. Decompose the task into a dependency tree
2. Identify independent branches (parallelizable)
3. Group into phases: a phase = a group of tasks that can run in parallel
4. Between phases = sequential dependencies

### Model Tiering

- **Opus** - default for all tasks (planning, analysis, generation, checks)
- **Sonnet** - trivial tasks where Opus is not needed (simple transformations, mechanical edits)

### Common Mistakes

- **Over-parallelizing:** 10 agents for a simple task = wasted tokens. Group micro-tasks into a single agent
- **Overlapping roles:** "security expert + penetration tester + vulnerability scanner" = 3x the same work
- **Context duplication:** Do not send the full context to every agent - each one gets only what it needs
- **Missing error handling:** A subagent failure does not crash the orchestrator. It must handle the case where an agent fails or produces no output

---

## 8. Example: Parallel Checks with Consolidation

This pattern is suitable when you have N parallel subagents with non-trivial outputs, where there is a risk of duplication or contradictions between findings. Typical scenarios: parallel document checks from different perspectives, codebase analysis by multiple specialized agents, review from multiple viewpoints.

### Steps Overview

```
Orchestrator (~2K tokens of context):
  1. Auto-detection of input + preparation of tmp directory
  2. N parallel agents (foreground, file-based output)
  3. Consolidation agent (merge + deduplication → consolidated file)
  4. Presentation → selection → implementation → cleanup
```

### Orchestrator Context Management

The orchestrator MUST remain lightweight. These rules prevent context overflow:

- **DO NOT READ agent files** from `.claude/agents/` - the `subagent_type` parameter loads them into the subagent automatically
- **DO NOT READ the target document** - each subagent reads it independently
- **DO NOT USE `run_in_background`** - synchronous calls return only the agent's final message (~100 tokens), whereas `run_in_background` + `TaskOutput` returns the entire transcript (thousands of tokens)
- **DO NOT ADD agent file contents to the prompt** - the prompt contains only the path to input, the path to output, and a brief instruction

### File Management

- **`tmp/` in the project root** (create if it does not exist)
- **Timestamped subfolder:** `tmp/{workflow-name} ({YYYY-MM-DD HH.MM.SS})/` - allows repetition without collisions
- **File naming:** `NN-{agent-name}.md` (zero-padded numbers: `01-`, `02-`, ...) - the order corresponds to agents
- **Consolidated output:** `consolidated-findings.md` in the same directory (without a number - easily distinguishable)

### Subagent Prompt

The prompt contains three things and nothing else: the path to input, the path to the output file, and a brief instruction on what to do. All N Task calls MUST be in a single message (parallel execution). The return message format must be specified directly in the prompt - otherwise the agent will return a full report instead of a short summary.

### Consolidation

A separate synchronous Task call with `subagent_type: "general-purpose"`. The prompt contains the path to the tmp directory, consolidation rules, and the required output format.

**Three-level merge:**

1. **Auto-merge** - changes in different parts of the text → merge automatically
2. **Synthesis** - complementary changes (e.g., formatting + content) → create a unified version
3. **Recorded conflict** - hard-to-merge changes → DO NOT resolve automatically, but record both variants with a recommended merge

**Deduplication:** The same problem on the same line from multiple agents → keep one (prefer the more precise description).

### Robustness

- **Auto-detection of input:** argument → conversational context → glob pattern → ask the user
- **Agent failure:** inform, continue with results from the other agents
- **Zero findings:** short message "no issues found", skip consolidation
- **Idempotent:** safe to repeat (timestamped directory, no side effects)
- **Persisted outputs:** tmp files are inspectable even after the workflow ends

---

## 9. Review Checklist

When designing a new workflow, go through these points:

1. **Is a subagent even needed?** If the task does not require special tools or deep reasoning and the output is short (up to ~2K tokens) → direct work
2. **Are the tasks independent?** Yes → parallel. No → sequential
3. **Expected output >20K tokens?** → Split into sections (Strategy 3)
4. **The orchestrator does not do content work** - it only delegates, monitors, coordinates
5. **File-based output for parallel workflows** - the agent writes to a file, returns only a confirmation
6. **`subagent_type` instead of manually reading agent files**
7. **Foreground as default** - background only when the parent does not need to wait
8. **Consolidation agent for 3+ parallel agents** with potential overlap
9. **The prompt is self-contained** - context, instructions, paths, success criteria
10. **Opus as the default model** - Sonnet only for trivial tasks
11. **Coordination mode?** Fixed topology → prompt-driven (default). Multi-session
    or dynamic scope → task-tracked. Live cross-agent collaboration → Agent Teams

---

## 10. Proven Recipes

The most common combinations of strategies and dimensions. Keywords uniquely identify
the architecture - it is enough to include them in the prompt.

### Recipes Overview

| # | Recipe | Keywords | Topology |
|:--|:-------|:---------|:---------|
| A | Single agent | `direct work` | Fixed |
| B | Sequential pipeline | `sequential, file-based, foreground` | Fixed |
| C | Parallel checks | `parallel, file-based, foreground, consolidation` | Fixed |
| D | Large document generation | `outline → sections → assembly, file-based` | Fixed |
| E | Multi-phase pipeline | `parallel analysis → outline → sequential sections → assembly` | Fixed |
| F | Task-tracked pipeline | `task-tracked, file-based, foreground` | Fixed/Dynamic |
| G | Agent team | `agent-teams, shared task pool, messaging` | Dynamic |

---

### A. Single Agent

**Keywords:** `direct work`

**Prompt snippet:**
> Process [TASK] directly, without subagents.

**When:** The task does not require special tools or deep reasoning. Output up to ~2K tokens. Subagent overhead would exceed the benefit.

**Dimensions:** None - everything in a single agent.

---

### B. Sequential Pipeline

**Keywords:** `sequential, file-based, foreground`

**Prompt snippet:**
> Process [TASK] sequentially via N subagents. Foreground execution, file-based
> output to tmp/. Each agent reads the output of the previous one. The orchestrator only
> delegates - does not read files, does not do content work.

**When:** Dependent steps where each step builds on the output of the previous one.
Order matters. Example: sequential generation of document sections.

**Dimensions:** Communication=file-based, Execution=foreground, Consolidation=none,
Coordination=prompt-driven.

---

### C. Parallel Checks + Consolidation

**Keywords:** `parallel, file-based, foreground, consolidation`

**Prompt snippet:**
> Launch N parallel agents for [TASK]. Foreground execution, file-based
> output to tmp/. All Task calls in a single message (parallel execution).
> Then a consolidation agent: deduplication + merge of results into a single file.
> The orchestrator only delegates.

**When:** 3+ independent checks/analyses of the same input from different perspectives.
Results may overlap → consolidation deduplicates. Example: parallel
document quality checks (grammar, formatting, style).

**Dimensions:** Communication=file-based, Execution=foreground, Consolidation=yes,
Coordination=prompt-driven.

---

### D. Large Document Generation

**Keywords:** `outline → sections → assembly, file-based`

**Prompt snippet:**
> Generate [DOCUMENT] via a pipeline: 1) outline agent creates the outline,
> 2) per-section agents generate individual sections (sequentially, each reads
> the previous section), 3) assembly agent assembles sections into the final document.
> Foreground, file-based, the orchestrator only delegates.

**When:** Expected output > 20K tokens. No single agent can generate
the entire document at once. Look for natural boundaries: sections, chapters, tasks.

**Dimensions:** Communication=file-based, Execution=foreground, Consolidation=none
(assembly instead of consolidation), Coordination=prompt-driven.

---

### E. Multi-Phase Pipeline

**Keywords:** `parallel analysis → outline → sequential sections → assembly`

**Prompt snippet:**
> Process [TASK] via a multi-phase pipeline:
> Phase 0: parallel analysis (N agents simultaneously)
> Phase 1: outline agent (reads outputs of phase 0)
> Phase 2: per-section agents (sequentially, each reads the previous section)
> Phase 3: assembly agent (assembles all sections)
> Foreground, file-based, the orchestrator only delegates - does not read files.

**When:** Complex generation where analysis is needed before creation, large
output split into sections. Combines parallelization (phase 0) with sequential
processing (phase 2). Example: generating homework from a lesson.

**Dimensions:** Communication=file-based, Execution=foreground, Consolidation=none,
Coordination=prompt-driven.

---

### F. Task-Tracked Pipeline

**Keywords:** `task-tracked, file-based, foreground`

**Prompt snippet:**
> Process [TASK] with task tracking. Create tasks via TaskCreate for each step.
> Run subagents foreground, file-based output. After completion, update
> task status via TaskUpdate. Task list persistent in ~/.claude/tasks/.

**When:** Work across multiple sessions (e.g., multi-day refactoring).
Need for persistent progress tracking or user-visible ongoing status.
Same orchestration as prompt-driven, but with a tracking layer on top.

**Dimensions:** Communication=file-based, Execution=foreground,
Consolidation=as needed, Coordination=task-tracked.

**Warning:** Token overhead ~2x compared to prompt-driven. Use only when
persistence or progress visibility is a real need.

---

### G. Agent Team

**Keywords:** `agent-teams, shared task pool, messaging`

**Prompt snippet:**
> Create a team via TeamCreate for [TASK]. Create tasks (TaskCreate) and launch
> teammates (Task with team_name). Teammates claim tasks from the shared
> pool, communicate via SendMessage, coordinate with each other.

**When:** Dynamic scope (tasks arise at runtime), cross-agent negotiation,
live collaboration between agents. Example: implementing a feature where frontend
and backend agents must coordinate on the API contract.

**Dimensions:** Communication=file-based, Execution=foreground,
Consolidation=as needed, Coordination=agent-teams.

**Warning:** Highest overhead (N separate sessions). Experimental
feature. Use only when simpler recipes are insufficient.

---

## 11. References

### Official Documentation

- [Models overview](https://docs.anthropic.com/en/docs/about-claude/models) - context windows, max output
- [Context windows](https://docs.anthropic.com/en/docs/build-with-claude/context-windows) - context mechanics
- [Extended thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking) - thinking tokens
- [Claude Code sub-agents](https://docs.anthropic.com/en/docs/claude-code/sub-agents) - subagent API
- [Claude Code settings](https://docs.anthropic.com/en/docs/claude-code/settings) - MAX_OUTPUT_TOKENS

### Verification of Technical Details

- [GitHub issue #4182](https://github.com/anthropics/claude-code/issues/4182) - confirmation: subagents do not have the Task tool
