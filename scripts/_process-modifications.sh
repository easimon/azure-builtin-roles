#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <directory> <roletype>}"
: "${2:?Usage $0 <directory> <roletype>}"

echo "Processing modifications in $1"
git diff -z --name-only --diff-filter=M "$1" \
  | xargs -t -0 -I'{}' "${SCRIPT_DIR}/_process-changed-file.sh" "{}" "$2" "modified"
