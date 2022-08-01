#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <directory> <roletype>}"
: "${2:?Usage $0 <directory> <roletype>}"

echo "Processing modifications in $1"
readarray -t FILES < <(git diff --name-only --diff-filter=M "$1")

echo "Files changed: " "${FILES[@]}"
for FILE in "${FILES[@]}"; do
  "${SCRIPT_DIR}/_process-changed-file.sh" "$FILE" "$2" "modified"
done
