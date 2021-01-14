# benchdiff-action

See https://github.com/WillAbides/benchdiff to learn about the benchdiff command that this action runs.

<!--- start action output --->

Runs go benchmarks on HEAD and a base branch and reports the resulting benchstat output.

[See an example result here](https://github.com/WillAbides/benchdiff-action/runs/1691721812).


## Inputs

### benchdiff_args

Arguments for the benchdiff command line.  This action will run the command line `benchdiff <benchdiff_args>`
after making some adjustments to the arguments (listed below).

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


### status_sha

Report status to this sha. Default is the head of your benchdiff run.

### status_on_degraded

default: `failure`

Status to report for degraded results.

Options are "success", "failure" and "neutral"


### github_token

default: `${{ github.token }}`

Authentication token to use for reporting status.

If you use a non-default token it needs to be a token for a GitHub App installation with permission to create a
check-run.


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
