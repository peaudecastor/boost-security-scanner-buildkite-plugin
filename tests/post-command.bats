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
  export TEST_RUN=true

  DOCKER="/usr/bin/env docker"
  MKTEMP="/usr/bin/env mktemp"

  docker ()
  { # $@=args
    echo docker "${@}"
    if [ "${1}" == "create" ]; then
      echo test > /tmp/boost-scanner.cid.XXXXXX
    fi
  }

  mktemp ()
  { # $1=pattern
    touch "${1}" && echo "${@}"
  }

  export -f docker
  export -f mktemp

  docker_create=(docker create
    --cidfile "/tmp/boost-scanner.cid.XXXXXX"
    --env-file "/tmp/boost-scanner.env.XXXXXX"
    --entrypoint boost
    --rm
    "${BOOST_DOCKER_IMAGE}:latest"
    scan repo testorg/testrepo testbranch HEAD
  )
  docker_create="${docker_create[@]}"

  docker_cp=(docker cp "${PWD}/." "test:/app/mount/")
  docker_start=(docker start --attach "test")
  docker_stop=(docker stop "test")

  run ${PWD}/hooks/post-command
  assert_success

  assert_output --partial "${docker_create[@]}"
  assert_output --partial "${docker_cp[@]}"
  assert_output --partial "${docker_start[@]}"
  assert_output --partial "${docker_stop[@]}"

  unset docker
  unset mktemp

  # bats stub/mock doesnt seem to work
  # stub docker "${args[@]} : echo docker-run"
  # unstub docker
}

# vim: set ft=bash ts=2 sw=2 et :
