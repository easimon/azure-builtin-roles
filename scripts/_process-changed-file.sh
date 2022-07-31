#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <file> <roletype> <difftype>}"
: "${2:?Usage $0 <file> <roletype> <difftype>}"
: "${3:?Usage $0 <file> <roletype> <difftype>}"

: "${GITHUB_REPOSITORY:=easimon/azure-builtin-roles}"
COMMIT_BASE_URL="https://github.com/${GITHUB_REPOSITORY}/commit"

FILE="$1"
FILE_NAME="$(basename "${FILE}")"
ROLE_NAME="${FILE_NAME%.json}"
ROLE_TYPE="$2"
DIFF_TYPE="$3"

if [[ -v CI && "${CI}" == "true" ]]; then
  git config --global user.name "azure-roles-github-actions[bot]"
  git config --global user.email "azure-roles-github@noreply"
fi

git add "$FILE"
git commit -m "${ROLE_TYPE} ${DIFF_TYPE}: ${ROLE_NAME}"
git push

COMMIT_SHA="$(git rev-parse --verify HEAD)"
COMMIT_URL="${COMMIT_BASE_URL}/${COMMIT_SHA}"

# create github actions summary
if [[ -v GITHUB_STEP_SUMMARY && -n "${GITHUB_STEP_SUMMARY}" ]]; then
  SUMMARY="$(cat <<EOSUMMARY
- ${ROLE_TYPE} '${ROLE_NAME}' has been ${DIFF_TYPE} ([commit](${COMMIT_URL}))
EOSUMMARY
)"

  echo "${SUMMARY}" >> "${GITHUB_STEP_SUMMARY}"
fi

# create tweet
TWEET="$(cat <<EOTWEET
${ROLE_TYPE} '${ROLE_NAME}' has been ${DIFF_TYPE}.

${COMMIT_URL}
EOTWEET
)"

## TODO: actually create tweet
echo "=== TWEET ==="
echo "${TWEET}"
echo "=== TWEND ==="
