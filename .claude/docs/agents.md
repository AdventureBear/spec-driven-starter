# Claude Agent Reference

This project uses specialized sub-agents to handle distinct phases of the workflow.
They are invoked automatically by slash commands — you rarely need to call them directly.

---

## `planner`
**Invoked by:** `/plan`

Reads `PROJECT_SPEC.md` and a feature spec, then produces:
- A file-by-file implementation blueprint
- Schema and migration plan
- API contract (routes, inputs, outputs)
- Testing strategy

Does **not** write code.

---

## `specifier`
**Invoked by:** `/specify`, `/clarify`

Converts a feature idea into a formal spec with:
- User story
- Testable acceptance criteria
- Explicit out-of-scope items
- Open questions to resolve before building

---

## `implementer`
**Invoked by:** `/implement`

Executes tasks from `tasks.md` sequentially. For each task:
1. Writes the code
2. Writes the corresponding test
3. Runs the test suite
4. Checks off the task
5. Pauses for human review before the next task

Aborts if tests fail — does not skip forward.

---

## `reviewer`
**Invoked by:** `/review`

Audits changed files against:
- Spec acceptance criteria
- `CLAUDE.md` project constraints
- TypeScript strict mode compliance
- Security best practices (no raw SQL, no unvalidated inputs)
- Test coverage gaps

Returns: APPROVED or CHANGES REQUESTED + findings.

---

## `analyzer`
**Invoked by:** `/analyze`

Investigates a bug or unexpected behavior:
1. Reads relevant source files, tests, and logs
2. Hypothesizes root cause(s)
3. Proposes the minimal fix
4. Does NOT make changes — hands off to implementer

---

## Agent constraints (all agents)

- Never modify files outside the current feature branch
- Never push without explicit `/pr` command
- Never delete data without confirmation
- Always run tests before marking a task complete
- Always prefer editing existing files over creating new ones
