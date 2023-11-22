#!/bin/bash

set -e

# Expected global environment variables
#
# $BENCHSTAT_OUTPUT
# $DEGRADED_RESULT
# $HEAD_SHA
# $BASE_SHA
# $BENCH_COMMAND

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

output_summary="$(cat <<EOF
## Benchdiff Results

**Benchmark Command:** \`$BENCH_COMMAND\`
**Head:** \`$HEAD_SHA\`
**Base:** \`$BASE_SHA\`
**Degraded**: $DEGRADED_RESULT

<details>
<summary>benchstat output</summary>

$BENCHSTAT_OUTPUT

</details>
EOF
)"

echo "$output_summary" >> "$GITHUB_STEP_SUMMARY"
