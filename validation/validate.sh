#!/bin/bash
# Validation Script Template for Context Engineering
#
# Usage: Replace the placeholder commands below with your stack's actual equivalents,
# then run: chmod +x validate.sh && ./validate.sh
#
# This script exits on first failure (set -e). Each phase must pass before the next runs.

set -e

echo "=== Phase 1: Linting ==="
# Uncomment and replace with your linter:
# npm run lint                  # Node/TypeScript
# ruff check . --fix            # Python (Ruff)
# golangci-lint run             # Go
echo "SKIP: Configure your linter command above"

echo ""
echo "=== Phase 2: Type Checking ==="
# Uncomment and replace with your type checker:
# npx tsc --noEmit              # TypeScript
# mypy .                        # Python (mypy)
# go vet ./...                  # Go
echo "SKIP: Configure your type checker command above"

echo ""
echo "=== Phase 3: Unit Tests ==="
# Uncomment and replace with your test runner:
# npm test                      # Node/Jest
# pytest tests/ -v              # Python/Pytest
# go test ./...                 # Go
echo "SKIP: Configure your test runner command above"

echo ""
echo "=== Phase 4: Integration Tests (optional) ==="
# Uncomment if you have integration tests:
# pytest tests/integration/ -v  # Python
# npm run test:e2e              # Node
echo "SKIP: Configure integration tests above (optional)"

echo ""
echo "=== All configured validation gates passed ==="
