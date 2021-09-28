# Changelog

All notable changes to this project will be documented in this file.

## Unreleased - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v2.0.7..HEAD)

## 2.0.7 - 2021-09-28 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.6..2.0.7)

- allow complete step to pass additional args

## 2.0.6 - 2021-08-30 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.5..2.0.6)

- migrate downloader to get-boost-cli
- migrate cli installation path to tmp\_dir/boost/cli/<version>

## 2.0.5 - 2021-06-22 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.4..2.0.5)

- add `exec_full_repo` to require a full repo and not delete unmodified files on diff scans
- add `diff_scan_timeout` to optionally set diff scan expiry ( defaults to 120 )

## 2.0.4 - 2021-06-22 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.3..2.0.4)

- Remove boost-cli caching

## 2.0.3 - 2021-06-22 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.2..2.0.3)

- Adds BOOST\_TMP\_DIR environment variable for CLI installation path
- Fixes BOOST\_API\_ENDPOINT default value

## 2.0.2 - 2021-06-22 - [Github](https://github.com/peaudecastor/boost-security-scanner-github/compare/2.0.1..2.0.2)

- Migrates plugin logic into the boost-cli

## 2.0.1 - 2021-06-10 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v2.0.0..v2.0.1)

- Updates hook internals
- Add boost cli
- Add new 'action' key to support 'exec' mode and partial scans
- Add new 'exec\_command' key

## 2.0.0 - 2021-06-10 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/1.1.2..v2.0.0)

- Updates boost scanner 2.0.0 release
- Updates plugin to run as command hook
- Updates docker with --tty for colors
- Updates git fetch for base

## 1.1.2 - 2021-05-18 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v1.1.1..1.1.2)

- Detect and detach mirrored git repositories

## 1.1.1 - 2021-05-05 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v1.1.0..1.1.1)

- Update to the boost scanner 1.1 release

## 1.1.0 - 2021-03-29 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v1.0.2..1.1.0)

- Update with docker pull image
- Update with scanner image release channel

## v1.0.2 - 2021-03-18 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v1.0.1..v1.0.2)

- Add additional hook output
- Update diff scans to fetch --force base branch
- Update diff scans to unshallow current branch if needed

## v1.0.1 - 2021-03-18 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/compare/v1.0.0..v1.0.1)

- Update README with ecr login
- Update tests with image overrides
- Update hook ensuring we fetch commits from the base branch when a PR is detected

## v1.0.0 - 2021-03-16 - [Github](https://github.com/peaudecastor/boost-security-scanner-buildkite-plugin/releases/tag/v1.0.0)

### Added

- Initial release of boost-security-scanner
- Initial release of Boost CI version v1.0.0
