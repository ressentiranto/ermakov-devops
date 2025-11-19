#!/usr/bin/env bash
set -e

BRANCH_TYPE="$1"
PR_TITLE="$2"
PR_NUMBER="$3"

VERSION_FILE="version.txt"
CHANGELOG_FILE="changelog.md"

echo "Branch type: ${BRANCH_TYPE}"
echo "PR title: ${PR_TITLE}"
echo "PR number: ${PR_NUMBER}"

if [ ! -f "$VERSION_FILE" ]; then
  echo "version.txt not found"
  exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
  echo "changelog.md not found"
  exit 1
fi

OLD_VERSION=$(cat "$VERSION_FILE")
echo "Old version: ${OLD_VERSION}"

IFS='.' read -r MAJOR MINOR PATCH <<< "$OLD_VERSION"

if [ "$BRANCH_TYPE" = "feature" ]; then
  MINOR=$((MINOR + 1))
  PATCH=0
elif [ "$BRANCH_TYPE" = "hotfix" ]; then
  PATCH=$((PATCH + 1))
else
  echo "Unknown branch type: ${BRANCH_TYPE}"
  exit 1
fi

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "New version: ${NEW_VERSION}"

echo "$NEW_VERSION" > "$VERSION_FILE"

DATE_STR=$(date +"%Y.%m.%d %H:%M:%S")

ENTRY_HEADER="${NEW_VERSION} - ${DATE_STR} ${BRANCH_TYPE} PR#${PR_NUMBER}"
ENTRY_TEXT="- ${PR_TITLE}"

{
  echo "$ENTRY_HEADER"
  echo "$ENTRY_TEXT"
  echo
  cat "$CHANGELOG_FILE"
} > changelog.tmp

mv changelog.tmp "$CHANGELOG_FILE"

if [ -n "$GITHUB_OUTPUT" ]; then
  echo "old_version=${OLD_VERSION}" >> "$GITHUB_OUTPUT"
  echo "new_version=${NEW_VERSION}" >> "$GITHUB_OUTPUT"
fi
