#!/usr/bin/env bash
set -euo pipefail
ver="$1"   # новая версия
branch="${2:-unknown}"
date="$(date +'%Y.%m.%d %H:%M:%S')"
tmp="$(mktemp)"

{
  echo "[${ver}] - ${date} ${branch}"
  git log -n 20 --pretty=format:"- %s" | sed 's/"/\\"/g'
  echo
  echo
  cat CHANGELOG.md || true
} > "$tmp"

mv "$tmp" CHANGELOG.md
