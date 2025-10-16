#!/usr/bin/env bash
set -euo pipefail
FILE="VERSION"
cur=$(cat "$FILE" | tr -d '[:space:]')
IFS='.' read -r MAJOR MINOR PATCH <<< "$cur"

branch="${GITHUB_HEAD_REF:-${GITHUB_REF_NAME:-}}"

type="patch"
if [[ "$branch" == feature/* ]]; then
  type="minor"
elif [[ "$branch" == hotfix/* ]]; then
  type="patch"
fi

if [[ "$type" == "minor" ]]; then
  MINOR=$((MINOR+1)); PATCH=0
else
  PATCH=$((PATCH+1))
fi

new="$MAJOR.$MINOR.$PATCH"
echo "$new" > "$FILE"
echo "old=$cur" >> $GITHUB_OUTPUT
echo "new=$new" >> $GITHUB_OUTPUT
echo "type=$type" >> $GITHUB_OUTPUT
