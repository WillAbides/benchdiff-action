#!/bin/bash

set -e

name="$1"
value="$2"
echo "${name}=${value}" >> "$GITHUB_OUTPUT"
