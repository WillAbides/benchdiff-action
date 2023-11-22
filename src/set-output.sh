#!/bin/bash

set -e

name="$1"
value="$2"
{
    echo "${name}<<EOF"
    echo "$value"
    echo 'EOF'
} >> "$GITHUB_OUTPUT"
