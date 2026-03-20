Identify and resolve ambiguities in the spec: $ARGUMENTS

Read-only analysis first — no files are modified until you have answers.

---

## Steps

### 1. Locate spec

Find `.claude/specs/<name>/spec.md`. If `$ARGUMENTS` is a number only (e.g. `07`), use `ls .claude/specs/$ARGUMENTS-*` to find the folder. If not found, ask the user.

### 2. Move GitHub issues to In Progress

If the spec has a `GitHub Issues:` field, move them to "In Progress" on the project board.
(See `.claude/commands/tasks.md` for the `gh` commands — UPDATE project IDs first.)

### 3. Scan for ambiguities

Read the spec and flag issues across these categories:

| Category | What to Check |
|----------|---------------|
| **Acceptance criteria** | Are they testable and measurable? (Not "works correctly" — instead "returns 200 with X") |
| **Edge cases** | Empty state, null values, max/min bounds, concurrent edits |
| **Error states** | What happens when the API fails? When input is invalid? When the user lacks permission? |
| **Role/permissions** | Which roles can do what? Any role gaps in the user stories? |
| **Data ownership** | Who creates this record? Who can edit/delete it? |
| **Integration points** | Any external services or APIs? What happens if they're down? |
| **UI states** | Loading, empty, error states mentioned for any UI? |
| **Scope creep** | Anything in the requirements that looks like it belongs in a future spec? |

### 4. Present questions

Output a numbered list of questions. For each:
- Quote the ambiguous text from the spec
- Explain why it's ambiguous
- Offer 2–3 suggested resolutions

**Wait for user answers before modifying anything.**

### 5. Update spec

After receiving answers, update `.claude/specs/<name>/spec.md`:
- Replace vague text with precise text
- Add `[CLARIFIED: <answer>]` markers next to updated sections
- Add resolved edge cases to Acceptance Criteria
- Update Out of Scope if any scope clarifications were made

Output a summary of every change made.
