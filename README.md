# benchdiff-action

<!--- start action output --->

Runs go benchmarks on the HEAD and default branch of your pull requests and uses benchstat to
report the difference and alert you of any benchmarks with degraded performance.

See https://github.com/willabides/benchdiff for more about the underlying benchdiff tool.


## Inputs

### benchdiff_args

Arguments for the benchdiff command.

If `--base-ref` isn't present in the arguments, then `--base-ref <default branch>` will be added.

`--json` is always added because the action requires json formatted output.

`--benchstat-output=markdown` is added when no other benchstat-output value is set because the reports look best
with markdown formatting.

Consider this example:
```
--cpu=1,2 --warmup-count=1 --warmup-time=10ms --tolerance=50 --debug
```
`--cpu=1,2` is important on actions because runners have only two cores available to them.

`--warmup-count=1` and `warmup-time=10ms` cause benchdiff to do a quick warmup before starting the benchmarks.
This is important on actions because the runners appear to have a small amount of cpu burst available. If you burn
through that in the warmup, then it makes for a better cmoparison between the real runs.

`--tolerance=50` means that a benchmark isn't considered degraded unless it's delta is greater than +50%. Action
runners can have inconsistent performance within the same run. This helps mitigate a lot of false alarms.

`--debug` causes benchdiff to output raw results to stderr (among other debug data). I like having this on just
to see progress in the logs.

See https://github.com/willabides/benchdiff for all available flags.


### benchdiff_version

default: `0.5.6`

Version of the benchdiff command to use.

When a new version of this action is released, the default value will be updated to the latest version of
benchdiff that isn't a breaking change from the previous default.


### report_status

default: `true`

Whether to report the status. Any value other than "true" is interpreted as false.

I call this "status" because that's a better known term. What is actually created is a check-run.


### status_name

default: `benchdiff`

Name to use in reporting status. This is the name of the check-run that is created.


### github_token

__Required__

Token to use for reporting status.

Please use `${{ github.token }}`. If you use another token it needs to be a token for a github app installation
with permission to create a check-run.


## Outputs

### benchstat_output

Stdout from the benchdiff command.


### bench_command

Command used to run benchmarks. This is derived from the `benchdiff_args` input.


### degraded_result

Whether any of the benchmarks degraded between base and head.

### head_sha

The git revision benchstat used as head.

### base_sha

The git revision benchstat used as base.
<!--- end action output --->
