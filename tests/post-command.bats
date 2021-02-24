#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

setup () {
  export BOOST_DOCKER_IMAGE=227492184095.dkr.ecr.us-east-2.amazonaws.com/checks-runner
  export BUILDKITE_ORGANIZATION_SLUG=testorg
  export BUILDKITE_PIPELINE_SLUG=testrepo
  export BUILDKITE_BRANCH=testbranch
  export BUILDKITE_BUILD_CHECKOUT_PATH=${PWD}
}

@test "Run would execute a docker container" {
  export DRY_RUN=true
  export TMP_FILE=$(mktemp "/tmp/boost-scanner.XXXXXX")

  args=(run --rm --env-file "${TMP_FILE}")
  args+=(--volume "${PWD}:/app/mount")
  args+=(${BOOST_DOCKER_IMAGE}:latest)
  args+=(boost scan repo testorg/testrepo testbranch HEAD)

  export DRY_RUN=true
  run ${PWD}/hooks/post-command
  assert_success
  assert_output --partial "${args[@]}"

  # bats stub/mock doesnt seem to work
  # stub docker "${args[@]} : echo docker-run"
  # unstub docker
}

# vim: set ft=bash ts=2 sw=2 et :
