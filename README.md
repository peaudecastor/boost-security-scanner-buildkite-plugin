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
      - ecr#v2.3.0:
          login: true
          account_ids: "706352083976"
          region: "us-east-2"
      - peaudecastor/boost-security-scanner#v1.0.2:
          api_token: 'TOKEN'
```

## Configuration

All pipeline options listed below may be configured either by specying the
`key:value` pair in the plugin configuration or by exporting environment
variables in your buildkite environment. All such environment variables should
be capitalized and prefixed with either `BOOST` or
`BUILDKITE_PLUGIN_BOOST_SECURITY_SCANNER`.

### `additional_args` (Optional, list[str])

Additional CLI args to pass to the `boost` cli.

### `api_endpoint` (Optional, string)

Overrides the API endpoint url

### `api_token` (Required, string)

The Boost Security API token secret.

**NOTE**: We recommend you not put the API token directly in your pipeline.yml
file. Intead, either expose the environment variable or refer to Builtkite's
[secrets management document](https://buildkite.com/docs/pipelines/secrets).

### `docker_create_args` (Optional, string)

Optional additional arguments to pass to `docker create` when preparing the
scanner container.

### `project_slug` (Optional, string)

Optional override for the project unique identifier. If undefined, this will
default to the relative path derived from BUILDKITE\_REPO.

### `scanner_image` (Optional, string)

Overrides the docker image url to load when performing scans

### `scanner_version` (Optional, string)

Overrides the docker image tag to load when performing scans. If undefined,
this will default to pulling the latest image from the current release channel.

## Developing

To run the tests:

```shell
make lint
make tests
```
