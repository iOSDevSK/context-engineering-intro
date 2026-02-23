# Direct Task Execution

## Task: $ARGUMENTS

Execute a straightforward task directly, without generating a complex PRP.
This command is perfect for minor bug fixes, textual changes, small UI adjustments, or trivial operations where the overhead of the full Context Engineering pipeline is unnecessary.

## Process

1. **Understand Request**
   - Read the task provided in `$ARGUMENTS`.
   - Ask clarifying questions only if the request is highly ambiguous.

2. **Direct Implementation**
   - Locate the relevant files in the codebase.
   - Propose and implement code changes directly.
   - For UI/UX changes, ensure consistency with the existing design system.

3. **Validation**
   - Run applicable linters or tests on the modified files.
   - Ensure the app builds without errors, if relevant.

4. **Complete**
   - Briefly summarize the changes made.

*Note: If during the execution the task is discovered to be much larger or architecturally significant than initially thought, advise the user to use `/generate-prp` with an `INITIAL.md` instead.*
