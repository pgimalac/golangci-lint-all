# golangci-lint-all
Wrapper script around `golangci-lint` to run on multiple platforms in parallel and have a unified output.

The script relies on the fact that each lint takes a single line and is always the same when reported on different platforms (which allows simply filtering duplicate lines to avoid duplicate warnings).

The wrapper can be used directly in an IDE since the output will be the same as `golangci-lint`.
For example on VSCode it can be set as an `Alternate Tools` in the `Go` extension.

The time it takes to run is basically as long as the time of the time on the longest of each platform.

# How to use
## Arguments
Arguments provided to the script are transfered as is to `golangci-lint`.

If not argument is provided, the default argument is just `run`.

Some arguments are added by the script when not provided by the user:
- `out-format` will be `colored-line-number`. Other meaningful values can be `line-number`, `github-actions` or `tab`, as they all print each lint on a single line, otherwise the final output would not be clear.
- `print-issued-lines` will be false, similarly so that each lint takes a single line and the final output is unified.
- `allow-parallel-runners` to enable running several instances of `golangci-lint` in parallel.

## Platforms
The list of platforms to run on can be provided using the `PLATFORMS` environment variable.

It should be a space-separated list of platforms, where each platform is an operating system and
an architecture, separated by a slash.

The possible platforms are the ones supported by Go, which can be seen using the command
`go tool dist list`.

If the `PLATFORMS` variable isn't defined or is empty, the following platforms will be used by default:
- `linux/amd64`
- `linux/arm64`
- `darwin/amd64`
- `darwin/arm64`
- `windows/amd64`
- `windows/386`

## Example
```sh
PLATFORMS="linux/amd64 linux/arm64 linux/386" golangci-lint-all run -c .golangci.yml --out-format=tab
```

## Caveats
In case of error from `golangci-lint` (eg. parsing / compiling) the output might not be clear.
