#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

: "${1:?Usage $0 <dir>}"
DIR="$1"

case "${DIR}" in
  "azure-roles")
    DEFINITION_TYPE="Azure Built-In Role"
    ;;
  "azure-provider-operations")
    DEFINITION_TYPE="Azure Provider Operations"
    ;;
  *)
    echo "Unknown directory: $DIR"
    exit 1
    ;;
esac

"${SCRIPT_DIR}/_process-additions.sh" "${DIR}" "${DEFINITION_TYPE}"
"${SCRIPT_DIR}/_process-removals.sh" "${DIR}" "${DEFINITION_TYPE}"
"${SCRIPT_DIR}/_process-modifications.sh" "${DIR}" "${DEFINITION_TYPE}"
