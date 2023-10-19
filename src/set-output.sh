#!/bin/bash

set -e

name="$1"
value="$2"
value="${value//'%'/'%25'}"
value="${value//$'\n'/'%0A'}"
value="${value//$'\r'/'%0D'}"
echo "${name}=${value}" >> $GITHUB_OUTPUT
