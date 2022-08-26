#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OPERATIONS_DIR="$1"
SUBSCRIPTION_ID="$(az account show -ojson | jq -rc .id)"

mkdir -p "${OPERATIONS_DIR}"
find "${OPERATIONS_DIR}" -type f -name '*.json' -delete

readarray -t PROVIDERS < <(az provider operation list -ojson | jq -rc '.[].name')

echo "Updating ${OPERATIONS_DIR}."

i=0
max_parallel=16
for PROVIDER in "${PROVIDERS[@]}"; do
  echo "  Updating ${PROVIDER}."
  # concurrency issue: sometimes the list of available providers changes
  # between 'operations list' and 'operation show'. let's silently treat
  # 'listed' providers vanishing before 'show' as deleted.
  (az provider operation show -ojson --namespace "${PROVIDER}" \
    > "${OPERATIONS_DIR}/${PROVIDER}.json" \
    || rm -f "${OPERATIONS_DIR}/${PROVIDER}.json") &
  ((i+=1))
  if [[ "$i" -ge "$max_parallel" ]]; then
    i=0
    wait
  fi
done

wait

echo "Reformatting ${OPERATIONS_DIR}."
find "${OPERATIONS_DIR}" -type f -name '*.json' -exec "${SCRIPT_DIR}/_reformat.sh" {} \;
