#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <directory> <definition-type>}"
: "${2:?Usage $0 <directory> <definition-type>}"

git ls-files -z --other --exclude-standard "$1" \
  | xargs -0 -I'{}' "${SCRIPT_DIR}/_process-changed-file.sh" "{}" "$2" "added"
