# Cleanup Temporary Workspace

## Path: $ARGUMENTS

Cleans up intermediate outputs and generated files in the `tmp/` directory created by background sub-agents and parallel workflows.

## Process

1. **Locate Temporary Files**
   - Look for the `tmp/` directory in the root of the project.
   - Identify old timestamped sub-folders (`tmp/{workflow-name} ({YYYY-MM-DD HH.MM.SS})/`).

2. **Summary and Confirmation**
   - Provide a brief summary of the folders/files that will be deleted.
   - If `$ARGUMENTS` is `--force` or `all`, proceed directly.
   - Otherwise, ask the user for confirmation before deleting.

3. **Cleanup execution**
   - Delete the identified temporary folders and files using appropriate bash commands.
   - Leave `tmp/` directory itself intact as an empty placeholder for future operations.

4. **Status**
   - Confirm successful deletion to the user.
