#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OPERATIONS_DIR="$1"
SUBSCRIPTION_ID="$(az account show -ojson | jq -rc .id)"

mkdir -p "${OPERATIONS_DIR}"
find "${OPERATIONS_DIR}" -type f -name '*.json' -delete

readarray -t PROVIDERS < <(az provider operation list -ojson | jq -rc '.[].name')

for PROVIDER in "${PROVIDERS[@]}"; do
  az provider operation show -ojson --namespace "${PROVIDER}" \
    > "${OPERATIONS_DIR}/${PROVIDER}.json"
done

find "${OPERATIONS_DIR}" -type f -name '*.json' -exec "${SCRIPT_DIR}/_reformat.sh" {} \;
