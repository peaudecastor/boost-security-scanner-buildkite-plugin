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

### `docker_create_args` (Optional, string)

Optional additional arguments to pass to `docker create` when preparing the
scanner container.

### `project_slug` (Optional, string)

Optional override for the project unique identifier. If undefined, this will
default to the relative path derived from BUILDKITE\_REPO.

### `scanner_image` (Optional, string)

Overrides the docker image url to load when performing scans

### `scanner_version` (Optional, string)

Overrides the docker image tag to load when performing scans

## Developing

To run the tests:

```shell
make lint
make tests
```
