#!/bin/bash

set -e

# Expected global environment variables
#
# $INSTALL_ONLY
# $BENCHDIFF_ARGS
# $BENCHDIFF_BIN
# $ACTION_PATH

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

if [ "$INSTALL_ONLY" != "false" ]; then
  exit 0
fi

args="$BENCHDIFF_ARGS --json-output"
# shellcheck disable=SC2016 # we don't want to expand $default_base_ref
if [[ "$args" == *'$default_base_ref'* ]]; then
  remote="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} | cut -d "/" -f 1)"
  default_branch="$(git remote show "$remote" | grep "HEAD branch" | cut -d ":" -f 2 | tr -d '[:space:]')"
  # shellcheck disable=SC2001 # let's stick with sed for now
  args="$(sed "s|\$default_base_ref|$remote/$default_branch|g" <<<"$args")"
fi

cmd="$BENCHDIFF_BIN"
output="$(xargs "$cmd" <<<"$args")"
"$ACTION_PATH/src/set-output.sh" benchstat_output "$(jq -r '.benchstat_output' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" head_sha "$(jq -r '.head_sha' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" base_sha "$(jq -r '.base_sha' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" bench_command "$(jq -r '.bench_command' <<<"$output")"
"$ACTION_PATH/src/set-output.sh" degraded_result "$(jq -r '.degraded_result' <<<"$output")"
