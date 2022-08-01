#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <directory> <definition-type>}"
: "${2:?Usage $0 <directory> <definition-type>}"

echo "Processing additions in $1"
git ls-files -z --other --exclude-standard "$1" \
  | xargs -t -0 -I'{}' "${SCRIPT_DIR}/_process-changed-file.sh" "{}" "$2" "added"
