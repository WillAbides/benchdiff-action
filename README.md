
foo bar baz
<!--- start action output --->

Runs go benchmarks on the HEAD and default branch of your pull requests and uses benchstat to
report the difference and alert you of any benchmarks with degraded performance.

See https://github.com/willabides/benchdiff for more about the underlying benchdiff tool.


## Inputs

### benchdiff_args

default: `--base-ref=$default_base_ref`

Arguments for the benchdiff command.
All instances of $default_base_ref will be replaced with this repo's default branch.

See https://github.com/willabides/benchdiff for usage


### benchdiff_version

default: `0.5.6`

Version of benchdiff to use (exclude "v" from the front of the release name)

### install_only

default: `false`

Whether to stop after installing. Any value other than "false" is interpreted as true.

### report_status

default: `true`

Whether to report the status. Any value other than "true" is interpreted as false.

### status_name

default: `benchdiff`

Name to use in reporting status.

### github_token

__Required__

Token to use for reporting status.

### benchdiff_dir

default: `${{ runner.temp }}/benchdiff`

Where benchdiff will be installed

## Outputs

### bench_command

command used to run benchmarks

### benchstat_output

output from benchstat

### degraded_result

whether any part of the results is degraded

### head_sha

git revision benchstat used as head

### base_sha

git revision benchstat used as base

### benchdiff_bin

path to the benchdiff executable
<!--- end action output --->
