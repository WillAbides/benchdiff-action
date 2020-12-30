#!/bin/bash

set -e

# Expected global environment variables
#
# $BENCHDIFF_DIR
# $BENCHDIFF_VERSION

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

set_output() {
  value="$2"
  value="${value//'%'/'%25'}"
  value="${value//$'\n'/'%0A'}"
  value="${value//$'\r'/'%0D'}"
  echo "::set-output name=$1::$value"
}

mkdir -p "$BENCHDIFF_DIR"
cd "$BENCHDIFF_DIR"
tarfile="benchdiff_${BENCHDIFF_VERSION}_linux_amd64.tar.gz"
url="https://github.com/WillAbides/benchdiff/releases/download/v${BENCHDIFF_VERSION}/${tarfile}"
curl --silent -OL "$url"
tar -xzf "$tarfile" benchdiff
rm "$tarfile"
set_output "benchdiff_bin" "$BENCHDIFF_DIR/benchdiff"
