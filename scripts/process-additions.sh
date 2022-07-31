#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

git ls-files -z --other --exclude-standard "$1" \
  | xargs -0 -I'{}' echo "Added:    {}"
