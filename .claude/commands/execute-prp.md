# Execute PRP

Implement a feature using the PRP file.

## PRP File: $ARGUMENTS

## Execution Process

1. **Load PRP**
   - Read the specified PRP file completely
   - Understand all context, requirements, and success criteria
   - Follow all instructions in the PRP and extend the research if needed
   - Ensure you have all needed context to implement the PRP fully
   - Do more web searches and codebase exploration as needed

2. **Plan before coding**
   - Map every PRP task to specific files and functions you will create or modify.
   - Identify dependencies between tasks — which must complete before others can start.
   - For each task, locate the codebase pattern it should follow.
   - If any task is unclear or missing context, research the codebase and documentation before proceeding.

3. **Execute the plan**
   - Implement tasks in the order defined by the PRP
   - Follow existing codebase patterns for each new file/function
   - After completing each task, run a quick validation before moving to the next

4. **Validate**
   - Run each validation command from the PRP's Validation Loop section
   - Fix any failures — read the error, identify root cause, fix code
   - Re-run until all validation gates pass

5. **Error recovery** (if validation fails 3+ times on the same issue)
   - Stop and diagnose: is the PRP missing context or is there a deeper issue?
   - Re-read the PRP's Known Gotchas section for clues
   - If the root cause is outside the PRP scope, document it and report to the user
   - Do NOT loop endlessly — 3 attempts max per specific error

6. **Complete**
   - Re-read the PRP to verify every requirement and success criteria is met
   - Run the final validation suite one last time
   - Report: what was implemented, what tests pass, any open items
