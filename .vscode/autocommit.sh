#!/usr/bin/env bash
# Commit and push all changes; invoked by the Run on Save extension.
# One commit per day, named by date: later saves the same day amend it.
cd "$(dirname "$0")/.." || exit 1
exec 9>.git/autocommit.lock
flock 9  # serialize rapid successive saves

today=$(date '+%Y-%m-%d')

git add -A
git diff --cached --quiet && exit 0

if [ "$(git log -1 --format=%s 2>/dev/null)" = "$today" ]; then
  git commit -q --amend --no-edit
  push_flags=(--force-with-lease)
else
  git commit -q -m "$today"
  push_flags=()
fi

if git remote get-url origin >/dev/null 2>&1; then
  git push -q -u "${push_flags[@]}" origin HEAD
fi
