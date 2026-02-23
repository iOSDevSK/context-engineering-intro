# Optimize Prompt

## Target file: $ARGUMENTS

Optimize the prompt/document at the specified path. **Goal: Maximize signal-to-noise ratio — every word must carry information.**

## Critical Rule: Preserve Language

The optimized version MUST be in the SAME language as the original. Content is optimized, language never changes.

---

## Optimization Philosophy

### Signal vs. Noise

- **Signal** = information that helps accomplish the task (rules, constraints, context, examples, format)
- **Noise** = words with no informational value (pleasantries, empty phrases, redundancy)
- **Requirement** = an independent, testable rule/constraint/expectation (atomic unit)

### Golden Rule

**Maximize signal, minimize noise.**

- Shorter + higher ratio = excellent (removed noise)
- Longer + more signal = acceptable (added needed signal)
- Shorter + lower ratio = PROBLEM (lost signal!)
- Longer + same signal = PROBLEM (added noise!)

### Priority Hierarchy

1. **Information completeness** — All requirements MUST remain (0% loss)
2. **Noise elimination** — Every word must earn its place
3. **Signal addition** — Add examples/clarifications where needed
4. **Conflict resolution** — Identify and resolve contradictory requirements

---

## Process

### STEP 1: Signal Inventory

Read the target file. Catalog everything it contains:

- Main objectives (what the prompt achieves)
- Rules and constraints (must/must not)
- Context and edge cases
- Output expectations (format, structure)
- Priorities (critical vs. optional)
- Examples (illustrations of requirements)
- Negative constraints (what it must NOT do)

**Everything in this list MUST remain in the optimized version.**

### STEP 2: Identify Inefficiencies

**A) Noise (remove):**
- Empty phrases: "It is important to note that..." → state the requirement directly
- Redundancy: same thing said multiple ways → keep the clearest one
- Filler words: "very", "quite", "basically", "somewhat" → remove unless they change meaning

**What is NOT noise:**
- Emphasis on critical points ("NEVER", "ALWAYS", "MUST")
- Explanation of "why" behind a rule (if it increases compliance)
- Detailed specifications (format, numbers, units, limits)
- Examples (illustrations of abstract requirements)
- Negative constraints ("DO NOT", "NEVER")

**B) Missing signal (add):**
- Vague requirements → add concrete example
- Multiple interpretations possible → clarify with specifics
- Complex rules without illustration → add expected output example
- Abstract concepts without definition → define measurable criteria
- Missing edge case handling → add explicit handling

**C) Conflicts (resolve):**
- Identify contradictory requirements
- Resolve by priority (P0 > P1 > P2 > P3)
- Or define conditional rules ("Be brief for overviews. Be detailed for technical steps.")

**D) Unclear priorities (clarify):**
- Mark critical requirements as P0/CRITICAL
- Distinguish must-have from nice-to-have

### STEP 3: Optimize

For each section of the prompt:

1. **Is there unique signal?** No → remove. Yes → continue
2. **Can it be said shorter without losing meaning?** Yes → compress
3. **Is the signal unambiguous?** No → add example/clarification
4. **Is the priority clear?** No → mark P0/P1/P2/P3
5. **Does it conflict with another requirement?** Yes → flag and resolve

### STEP 4: Restructure

Optimal flow:
1. Context → Why are we doing this?
2. Main task → What exactly needs to be done?
3. Rules → How should it be done? (P0 → P3)
4. Examples → What does it look like in practice?
5. Expectations → What should the output look like?

---

## Output

### A) Analysis

**1. Signal checklist (atomic, testable):**
List every requirement found in the original with priority level [P0/P1/P2/P3].

**2. Issues found:**

For each category (noise removed, signal added, conflicts resolved, priorities clarified, structure reorganized):
- ORIGINAL: "[quote]"
- CHANGE: "[what was done and why]"
- SIGNAL LOST: NONE (verify for each change)

### B) Optimized Prompt

Write the complete optimized version to the SAME file path, preserving the original language.

Must contain:
- All requirements from the original (100% coverage)
- Noise removed (higher signal/noise ratio)
- Missing examples/clarifications added
- Clear priorities
- Resolved conflicts
- Logical structure (Context → Objective → Rules → Examples → Expectations)
- Negative constraints (what must NOT happen)
- Same language as original

### C) Verification

**Requirement mapping:**
Map every original requirement to its location in the optimized version. If ANYTHING is missing → STOP and add it.

**Edge cases:** Verify boundary conditions are covered.

**Conflicts:** Verify all contradictions are resolved.

### D) Metrics

```
                    ORIGINAL    OPTIMIZED    CHANGE
Total length:       X words     A words      ±D%
Estimated signal:   Y words     B words      ±E%
Signal/Noise ratio: Z%          C%           +F%
Requirements:       W           W            0 (MUST be 0!)
Conflicts:          K           0            -K
```

---

## Final Safety Check

Before saving:
- Is every original requirement preserved? If NO → STOP, restore
- Could output be less precise due to my changes? If YES → STOP, restore signal
- Are abstract requirements backed by examples? If NO → add examples
- Is it in the SAME language as the original? If NO → STOP, fix
- Would the original author agree with this version? If NO → STOP, align with intent

**Motto: Every word must earn its place. But one extra word is better than one important word missing.**
