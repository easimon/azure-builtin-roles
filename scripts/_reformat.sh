#!/usr/bin/env bash

set -euo pipefail

mv "$1" "$1.tmp" \
  && jq --sort-keys < "$1.tmp" > "$1" \
  && rm "$1.tmp"
