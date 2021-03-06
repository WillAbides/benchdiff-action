#!/bin/bash

set -e

# Expected global environment variables
#
# $REPORT_STATUS
# $ACTION_PATH
# $BENCHSTAT_OUTPUT
# $DEGRADED_RESULT
# $HEAD_SHA
# $BASE_SHA
# $BENCH_COMMAND
# $GH_TOKEN
# $STATUS_NAME
# $STATUS_SHA
# $GITHUB_REPOSITORY
# $STATUS_ON_DEGRADED

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

if [ "$REPORT_STATUS" != "true" ]; then
  exit 0
fi

output_text="$BENCHSTAT_OUTPUT"
output_summary="$(cat <<EOF
## Benchdiff Results

Benchmark Command: \`$BENCH_COMMAND\`

HEAD sha: $HEAD_SHA

Base sha: $BASE_SHA

Degraded: $DEGRADED_RESULT

EOF
)"

report_sha="$STATUS_SHA"
if [ -z "$report_sha" ]; then
  report_sha="$HEAD_SHA"
fi

conclusion="success"
if [ "$DEGRADED_RESULT" = "true" ]; then
  conclusion="$STATUS_ON_DEGRADED"
fi
postdata="$(
jq -n \
--arg conclusion "$conclusion" \
--arg head_sha "$report_sha" \
--arg name "$STATUS_NAME" \
--arg output_text "$output_text" \
--arg output_summary "$output_summary" \
--arg output_title "" \
'
{
  "conclusion": $conclusion,
  "head_sha": $head_sha,
  "name": $name,
  "output": {
    "text": $output_text,
    "title": $output_title,
    "summary": $output_summary
  }
}
'
)"

echo "Posting result to https://api.github.com/repos/$GITHUB_REPOSITORY/check-runs"

curlout="$(
curl --silent -X 'POST' -d "$postdata" \
--write-out "\n%{http_code}" \
-H 'Accept: application/vnd.github.v3+json' \
-H 'Content-Type: application/json' \
-H "Authorization: token $GH_TOKEN" \
"https://api.github.com/repos/$GITHUB_REPOSITORY/check-runs"
)"

curl_body="$(sed '$d' <<< "$curlout")"
status_code="$(sed '$!d' <<< "$curlout")"

if [[ "$status_code" != "2"* ]]; then
  echo "::error ::error posting result: $status_code - $(jq -r '.message' <<< "$curl_body")"
  echo "::error ::see result below"
  echo "$output_summary"
  echo "----"
  echo "$output_text"
  exit 1
fi

jq -r .html_url <<< "$curl_body"
