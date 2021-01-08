#!/bin/bash

set -e

# Expected global environment variables
#
# $BENCHDIFF_DIR
# $BENCHDIFF_VERSION
# $ACTION_PATH

if [ "$(uname -s)" != "Linux" ]; then
  echo This action only runs on Linux
  exit 1
fi

version="$BENCHDIFF_VERSION"
if [[ "$version" == "v"* ]]; then
  version="${version:1}"
fi

mkdir -p "$BENCHDIFF_DIR"
cd "$BENCHDIFF_DIR"
tarfile="benchdiff_${version}_linux_amd64.tar.gz"
url="https://github.com/WillAbides/benchdiff/releases/download/v${version}/${tarfile}"
curl --silent -OL "$url"
tar -xzf "$tarfile" benchdiff
rm "$tarfile"
