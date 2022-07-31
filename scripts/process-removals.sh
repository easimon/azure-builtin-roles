#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

git ls-files -z --deleted --exclude-standard "$1" \
  | xargs -0 -I'{}' echo "Removed:  {}"
