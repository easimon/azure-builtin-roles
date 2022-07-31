#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

git diff -z --name-only --diff-filter=M "$1" \
  | xargs -0 -I'{}' echo "Modified: {}"
