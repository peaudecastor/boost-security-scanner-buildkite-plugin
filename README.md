# Boost Security Scanner BuildKite Plugin

Executes the Boost Security Scanner cli tool to scan repositories for
vulnerabilities and uploads results to the Boost API. This plugin
runs as a post-command hook.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: YOUR BUILD COMMAND HERE
    plugins:
      - peaudecastor/boost-security-scanner#v0.1.0:
          api_token: 'TOKEN'
```

## Configuration

### `additional_args` (Optional, list[str])

Additional CLI args to pass to the `boost` cli.

### `api_endpoint` (Optional, string)

Overrides the API endpoint url

### `api_token` (Required, string)

The Boost Security API token

### `diff_scan` (Optional, boolean, default=true)

Indicates that the scanner should perform a scan only of the files having
changed between two commits. During execution time, the plugin will attempt
to locate the commit at the HEAD of either `BUILDKITE_PULL_REQUEST_BASE_BRANCH`
or `BUILDKITE_PIPELINE_DEFAULT_BRANCH`.

### `scanner_version` (Optional, string)

Overrides the docker image to load when performing scans

### `org_name` (Optional, string)

Overrides the Organization slug when uploading reports to Boost Security.
This will default to the Organization slug defined in BuildKite.

### `repo_name` (Optional, string)

Overrides the Repository slug when uploading reports to Boost Security.
This will default to the Repository slug defined in BuildKite.

## Developing

To run the tests:

```shell
make lint
make tests
```
