#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <directory> <definition-type>}"
: "${2:?Usage $0 <directory> <definition-type>}"

echo "Processing additions in $1"
readarray -t FILES < <(git ls-files --other --exclude-standard "$1")

echo "Files added: " "${FILES[@]}"
for FILE in "${FILES[@]}"; do
  "${SCRIPT_DIR}/_process-changed-file.sh" "$FILE" "$2" "added"
done
