# CLAUDE.md

You operate in two modes: 
1. Implementation Workflow as you build and validate features
2. Publish Workflow once the user asks to publish

You implement features using a strict TDD loop with GitHub tracking.
Always work through the steps below in order. Never skip steps when implementing.

## Agents

| Agent | Role |
|---|---|
| `github-agent` | Issues, branches, commits, PRs |
| `make-agent` | Writes failing tests (RED) |
| `test-agent` | Runs tests, reports pass/fail, regresssion, coverage |
| `docs-agent` | Documentation, examples, README, CHANGELOG. Owns doc/, example/, README.md, CHANGELOG.md. |
| `benchmark-agent` | Performance benchmarks. Owns benchmark/. Read-only on lib/. |
| `publish-agent` | Publish package to pub.dev. Validates quality gates, runs dry-run, and publishes. |

---

## Implementation Workflow

### 1. Sync
Use `github-agent` to sync local `main` with the remote so the new branch starts from the latest merged code.

### 2. Issue Setup
Use `github-agent` to:
- Accept an issue number **or** create a new issue with a task checklist
- Print the issue URL and confirm the checklist before continuing

Checklist template:
```
- [ ] Branch created
- [ ] Failing test written (RED)
- [ ] Tests confirmed failing
- [ ] Implementation written (GREEN)
- [ ] All tests passing
- [ ] PR created
```

### 3. Branch
Use `github-agent` to create a branch named `feat/issue-<N>-<slug>` from `main`.
Check off *Branch created* on the issue.

### 4. RED — Write a failing test
Use `make-agent` to write the **minimal** failing test for the feature.
Then use `test-agent` to confirm the test fails.
- If the test accidentally passes, loop back to `make-agent` to tighten it.
- Use `github-agent` to check off *Failing test written* and *Tests confirmed failing*.

### 5. GREEN — Make it pass
Use `make-agent` to write the **minimal** implementation that makes the test pass.
Then use `test-agent` to confirm:
- The new test passes
- No existing tests regress
If any test is red, return to `make-agent` to fix without breaking others.
Use `github-agent` to check off *Implementation written*.

### 6. Full test suite
Use `test-agent` to run the complete suite.
- All green → continue.
- Any red → fix with `make-agent`, re-run, repeat.
Use `github-agent` to check off *All tests passing*.

### 7. Commit & PR
Use `github-agent` to:
- Commit all changes with message: `feat: <short description> (closes #<N>)`
- Push the branch
- Open a PR referencing the issue
- Check off *PR created*

### 8. Pause
Report the PR URL and stop.
Wait for the user to supply the next issue number or description.

---
## Publish Workflow

1. Use the `publish-agent` to follow steps and ask to orchestrate any fixes. 
2. Upon completion update version to prepare for next release

---

## Rules
- Never push to `main` directly.
- Keep commits atomic — one logical change per commit.
- If any agent returns an error, surface it and ask the user before retrying.
- Do not mark a checkbox complete until the step is verified.
- avoid calling commands directly, use the scripts in ./scripts to avoid needing `$()` `&2>1` `>` `|` `tr`  `&&` `||`
- always call scripts with relative paths eg. ./scripts/dart_fix.sh instead of /Users/proj/scripts/dart_fix.sh
