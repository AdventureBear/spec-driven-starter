Remove a worktree by running `./scripts/wt-rm`.

If `$ARGUMENTS` is only a number (e.g. `3`), find the matching spec folder using `ls -d specs/$ARGUMENTS-* specs/0$ARGUMENTS-*` (try both with and without zero-padding) and use the full folder name. If no match is found, ask the user for the correct name — do not guess. Otherwise (full name provided), run the command immediately — do NOT verify or search first.

```
./scripts/wt-rm $ARGUMENTS
```
