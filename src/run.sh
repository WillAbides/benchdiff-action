#!/bin/bash

set -e

# Expected global environment variables
#
# $BENCHDIFF_ARGS
# $BENCHDIFF_DIR
# $ACTION_PATH

get_default_branch() {
  local remote default_branch
  remote="$(git rev-parse --abbrev-ref --symbolic-full-name "@{u}" | cut -d "/" -f 1)"
  default_branch="$(git remote show "$remote" | grep "HEAD branch" | cut -d ":" -f 2 | tr -d '[:space:]')"
  echo "$remote/$default_branch"
}

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

args="$BENCHDIFF_ARGS --json"

if [[ "$args" != *"--benchstat-output"* ]]; then
  args="--benchstat-output markdown $args"
fi

if [[ "$args" != *"--base-ref"* ]]; then
  args="--base-ref $(get_default_branch) $args"
fi

if [[ "$args" == *"\$default_base_ref"* ]]; then
  args="${args//\$default_base_ref/$(get_default_branch)}"
fi

cmd="$BENCHDIFF_DIR/benchdiff"
output="$(xargs "$cmd" <<<"$args")"
"$ACTION_PATH/src/set-output.sh" benchstat_output "$(jq -r '.benchstat_output' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" head_sha "$(jq -r '.head_sha' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" base_sha "$(jq -r '.base_sha' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" bench_command "$(jq -r '.bench_command' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" degraded_result "$(jq -r '.degraded_result' <<<"$output")"
