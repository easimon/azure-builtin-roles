#!/usr/bin/env bash

set -euo pipefail

: "${1:?Usage $0 <file> <definition-type> <difftype>}"
: "${2:?Usage $0 <file> <definition-type> <difftype>}"
: "${3:?Usage $0 <file> <definition-type> <difftype>}"

: "${GITHUB_REPOSITORY:=easimon/azure-builtin-roles}"
: "${TWEET_PATH:=out}"
COMMIT_BASE_URL="https://github.com/${GITHUB_REPOSITORY}/commit"

FILE="$1"
FILE_NAME="$(basename "${FILE}")"
DEFINITION_NAME="${FILE_NAME%.json}"
DEFINITION_TYPE="$2"
DIFF_TYPE="$3"

if [[ -v CI && "${CI}" == "true" ]]; then
  git config --global user.name "azure-roles-github-actions[bot]"
  git config --global user.email "azure-roles-github@noreply"
fi

git add "$FILE"
git commit -m "${DEFINITION_TYPE} ${DIFF_TYPE}: ${DEFINITION_NAME}"
git push

COMMIT_SHA="$(git rev-parse --verify HEAD)"
COMMIT_URL="${COMMIT_BASE_URL}/${COMMIT_SHA}"

# create github actions summary
if [[ -v GITHUB_STEP_SUMMARY && -n "${GITHUB_STEP_SUMMARY}" ]]; then
  SUMMARY="$(cat <<EOSUMMARY
- ${DEFINITION_TYPE} '${DEFINITION_NAME}' has been ${DIFF_TYPE} ([commit](${COMMIT_URL}))
EOSUMMARY
)"

  echo "${SUMMARY}" >> "${GITHUB_STEP_SUMMARY}"
fi

# create tweet
TWEET="$(cat <<EOTWEET
${DEFINITION_TYPE} '${DEFINITION_NAME}' has been ${DIFF_TYPE}.

${COMMIT_URL}
EOTWEET
)"

mkdir -p "${TWEET_PATH}"
echo "${TWEET}" | jq --raw-input --slurp -c . > "${TWEET_PATH}/${DEFINITION_NAME}.tweet"
