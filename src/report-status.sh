#!/bin/bash

set -e

# Expected global environment variables
#
# $INSTALL_ONLY
# $REPORT_STATUS
# $ACTION_PATH
# $BENCHSTAT_OUTPUT
# $DEGRADED_RESULT
# $HEAD_SHA
# $GH_TOKEN
# $STATUS_NAME
# $GITHUB_REPOSITORY

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

if [ "$INSTALL_ONLY" != "false" ]; then
  exit 0
fi

if [ "$REPORT_STATUS" != "true" ]; then
  exit 0
fi

output_summary="

$BENCHSTAT_OUTPUT

"

conclusion="success"
if [ "$DEGRADED_RESULT" = "true" ]; then
  conclusion="failure"
fi
postdata="$(
jq -n \
--arg conclusion "$conclusion" \
--arg head_sha "$HEAD_SHA" \
--arg name "$STATUS_NAME" \
--arg output_summary "$output_summary" \
--arg output_title "" \
'
{
  "conclusion": $conclusion,
  "head_sha": $head_sha,
  "name": $name,
  "output": {
    "summary": $output_summary,
    "title": $output_title
  }
}
'
)"

curl --silent -X 'POST' -d "$postdata" \
-H 'Accept: application/vnd.github.v3+json' \
-H 'Content-Type: application/json' \
-H "Authorization: token ${{ inputs.github_token }}" \
"https://api.github.com/repos/$GITHUB_REPOSITORY/check-runs"
