#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <directory>}"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROLES_DIR="$1"
SUBSCRIPTION_ID="$(az account show -ojson | jq -rc .id)"

mkdir -p "${ROLES_DIR}"
find "${ROLES_DIR}" -type f -name '*.json' -delete

echo "Updating ${OPERATIONS_DIR}."
az role definition list -ojson \
  | jq -cr 'map(select(.roleType == "BuiltInRole")) | keys[] as $k | "\(.[$k].roleName | split("/")|join("_"))\t\(.[$k])"' \
  | sed "s|/subscriptions/${SUBSCRIPTION_ID}||g" \
  | awk -F\\t "{ file=\"${ROLES_DIR}/\"\$1\".json\"; print \$2 > file; close(file); }"

echo "Reformatting ${OPERATIONS_DIR}."
find "${ROLES_DIR}" -type f -name '*.json' -exec "${SCRIPT_DIR}/_reformat.sh" {} \;
