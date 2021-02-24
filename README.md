# Boost Security Scanner BuildKite Plugin

Executes the Boost Security Scanner cli tool to scan repositories for
vulnerabilities and uploads results to the Boost API.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ls
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
docker-compose run --rm lint
docker-compose run --rm tests
```
