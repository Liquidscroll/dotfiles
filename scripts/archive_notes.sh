#!/usr/bin/env bash
set -euo pipefail

NOTE_DIR="$HOME/.notes"
ARCHIVE_DIR="$NOTE_DIR/archives"
mkdir -p "$ARCHIVE_DIR"

# Are there any old notes?
if ! find "$NOTE_DIR" -maxdepth 1 -type f -mtime +6 -print -quit | grep -q .; then
    exit 0
fi

archive="$ARCHIVE_DIR/archive-$(date +%F).tar.gz"

# 1. cd into NOTE_DIR so the archive stores *relative* paths
# 2. feed the null-delimited list straight to tar – no shell expansion
(
  cd "$NOTE_DIR"
  find . -maxdepth 1 -type f -mtime +6 -print0 \
    | tar --null --files-from - --remove-files -czf "$archive"
)
