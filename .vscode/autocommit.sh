#!/usr/bin/env bash
# Commit and push all changes; invoked by the Run on Save extension.
cd "$(dirname "$0")/.." || exit 1
exec 9>.git/autocommit.lock
flock 9  # serialize rapid successive saves

git add -A
git diff --cached --quiet && exit 0
git commit -q -m "Auto-commit: ${1:-save} ($(date '+%Y-%m-%d %H:%M:%S'))"

if git remote get-url origin >/dev/null 2>&1; then
  git push -q -u origin HEAD
fi
