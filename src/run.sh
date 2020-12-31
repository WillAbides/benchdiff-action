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

set_output() {
  value="$2"
  value="${value//'%'/'%25'}"
  value="${value//$'\n'/'%0A'}"
  value="${value//$'\r'/'%0D'}"
  echo "::set-output name=$1::$value"
}

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
set_output benchstat_output "$(jq -r '.benchstat_output' <<<"$output")"
set_output head_sha "$(jq -r '.head_sha' <<<"$output")"
set_output base_sha "$(jq -r '.base_sha' <<<"$output")"
set_output bench_command "$(jq -r '.bench_command' <<<"$output")"
set_output degraded_result "$(jq -r '.degraded_result' <<<"$output")"
