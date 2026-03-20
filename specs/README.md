# Specs

Each feature lives in its own subfolder:

```
specs/
  <feature-name>/
    spec.md      # acceptance criteria (written by /specify)
    plan.md      # API contract & task breakdown (written by /plan)
    tasks.md     # ordered task list (written by /tasks)
```

The workflow that populates these files:

```
/clarify → /specify → /plan → /tasks → /tdd → /implement → /review → /pr
```

Never write feature code without a `spec.md` here first.
