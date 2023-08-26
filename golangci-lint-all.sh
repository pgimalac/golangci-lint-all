#!/bin/bash

# Run golangci-lint on some platforms in parallel and filter out the output to have each
# lint warning shown only once.
#
# The platforms to run on can be provided with the 'PLATFORMS' environment variable,
# separated by a space character, from the list of platforms supported by Go:
# $ go tool dist list
#
# Example use of the script:
# $ PLATFORMS="linux/amd64 linux/arm64 linux/386" golangci-lint-all run

set -eu

CMD=golangci-lint

# by default just use "run" arg
ARGS=${*:-run}

# print file:number:column
if [[ "$*" != *"--out-format"* ]];
then
    ARGS="$ARGS --out-format=colored-line-number"
fi

# do not print the line containing the error
if [[ "$*" != *"--print-issued-lines"* ]];
then
    ARGS="$ARGS --print-issued-lines=false"
fi

# do not return an error when issues are found
if [[ "$*" != *"--issues-exit-code"* ]];
then
    ARGS="$ARGS --issues-exit-code=0"
fi

# the platforms to use if PLATFORM is not set
DEFAULT_PLATFORMS=(
    "linux/amd64"
    "linux/arm64"
    "darwin/amd64"
    "darwin/arm64"
    "windows/amd64"
    "windows/386"
)
PLATFORMS=${PLATFORMS:-${DEFAULT_PLATFORMS[@]}}

# -d ' ' is the line delimiter
# -C '/' is the column separator
# -k is to keep stdout ordered
# --trim lr to remove whitespaces before and after input
parallel -d ' ' -C '/' -k --trim lr "env GOOS={1} GOARCH={2} $CMD" "$ARGS" --allow-parallel-runners <<< "$PLATFORMS" | sort -u
