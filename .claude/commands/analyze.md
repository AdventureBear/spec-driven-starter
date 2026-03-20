Analyze spec, plan, and tasks for inconsistencies: $ARGUMENTS

Read-only — no files are modified.

---

## Steps

### 1. Locate artifacts

Find in `.claude/specs/<name>/`:
- `spec.md` (required)
- `plan.md` (if exists)
- `tasks.md` (if exists)

If spec.md is missing, stop and tell the user to run `/specify` first.

### 2. Build inventory

Extract:
- All functional requirements (FR-001, FR-002, etc.)
- All acceptance criteria checkboxes
- All user stories
- All tasks and their implied requirements
- Any architecture decisions from plan.md

### 3. Run detection passes

| Check | What to Find |
|-------|-------------|
| **Spec–Plan contradictions** | Plan decisions that override spec constraints or use prohibited patterns from CLAUDE.md |
| **CLAUDE.md violations** | Plan or tasks referencing prohibited components, immutable models, or banned patterns |
| **Coverage gaps** | Requirements with no corresponding task; tasks with no corresponding requirement |
| **Missing test tasks** | Any code task without a paired test task |
| **Duplicate requirements** | Near-identical FRs or acceptance criteria |
| **Conflicts** | Two requirements that can't both be satisfied |
| **Ambiguity** | Vague terms without metrics: "fast", "scalable", "user-friendly", "robust" |
| **Scope creep in tasks** | Tasks that implement more than what the spec asks for |

### 4. Output report

```markdown
## Analysis: <Feature Name>

**Artifacts reviewed**: spec.md, plan.md, tasks.md
**Issues found**: X blocking, X warnings, X suggestions

### Blocking Issues
Must be resolved before implementation.
- [Spec §X / Plan §Y] Description. Fix: recommendation.

### Warnings
Should be addressed but won't necessarily break things.
- Description.

### Suggestions
Optional improvements.
- Description.

### Coverage Matrix
| FR | Has Task | Has Test Task | Has AC |
|----|----------|---------------|--------|
| FR-001 | ✅ | ✅ | ✅ |
| FR-002 | ✅ | ❌ | ✅ |

### Verdict
READY TO IMPLEMENT / NEEDS WORK — summary.
```
