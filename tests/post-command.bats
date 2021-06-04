#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

setup () {
  export BOOST_SCANNER_IMAGE=706352083976.dkr.ecr.us-east-2.amazonaws.com/scanner
  export BOOST_SCANNER_VERSION=test
  export BUILDKITE_BRANCH=master
  export BUILDKITE_BUILD_CHECKOUT_PATH=${PWD}
  export BUILDKITE_COMMIT=commit
  export BUILDKITE_ORGANIZATION_SLUG=org
  export BUILDKITE_PIPELINE_DEFAULT_BRANCH=master
  export BUILDKITE_PIPELINE_SLUG=repo
  export BUILDKITE_REPO="https://github.com/org/repo.git"
}

setup.stubs ()
{
  docker ()
  { # $@=args
    echo docker "${@}"
    if [ "${1}" == "create" ]; then
      echo test > /tmp/boost-scanner.cid.XXXXXX
    fi
  }

  git ()
  { # $@=args
    echo git "${@}"
  }

  mktemp ()
  { # $1=-T, $2=pattern
    touch "/tmp/${2}" && echo "/tmp/${2}"
  }

  export -f docker
  export -f git
  export -f mktemp
}

@test "Would run full scan" {
  setup.stubs

  docker_pull=(docker pull "${BOOST_SCANNER_IMAGE}:${BOOST_SCANNER_VERSION}")
  docker_create=(docker create
    --cidfile "/tmp/boost-scanner.cid.XXXXXX"
    --env-file "/tmp/boost-scanner.env.XXXXXX"
    --entrypoint boost
    --rm
    "${BOOST_SCANNER_IMAGE}:${BOOST_SCANNER_VERSION}"
    scan ci commit
  )
  docker_create="${docker_create[@]}"

  docker_cp=(docker cp "${PWD}/." "test:/app/mount/")
  docker_start=(docker start --attach "test")
  docker_stop=(docker stop "test")

  run ${PWD}/hooks/post-command
  assert_success

  assert_output --partial "${docker_pull[@]}"
  assert_output --partial "${docker_create[@]}"
  assert_output --partial "${docker_cp[@]}"
  assert_output --partial "${docker_start[@]}"
  assert_output --partial "${docker_stop[@]}"

  unset docker git mktemp
}

@test "Would run diff scan" {
  export BUILDKITE_PULL_REQUEST_BASE_BRANCH=other
  export BUILDKITE_PULL_REQUEST=000

  setup.stubs

  docker_pull=(docker pull "${BOOST_SCANNER_IMAGE}:${BOOST_SCANNER_VERSION}")
  docker_create=(docker create
    --cidfile "/tmp/boost-scanner.cid.XXXXXX"
    --env-file "/tmp/boost-scanner.env.XXXXXX"
    --entrypoint boost
    --rm
    "${BOOST_SCANNER_IMAGE}:${BOOST_SCANNER_VERSION}"
    scan ci
    "commit..${BUILDKITE_PULL_REQUEST_BASE_BRANCH}"
  )
  docker_create="${docker_create[@]}"

  docker_cp=(docker cp "${PWD}/." "test:/app/mount/")
  docker_start=(docker start --attach "test")
  docker_stop=(docker stop "test")
  git_fetch=(git fetch origin
    "${BUILDKITE_PULL_REQUEST_BASE_BRANCH}:${BUILDKITE_PULL_REQUEST_BASE_BRANCH}"
  )

  run ${PWD}/hooks/post-command
  assert_success

  assert_output --partial "${docker_pull[@]}"
  assert_output --partial "${docker_create[@]}"
  assert_output --partial "${docker_cp[@]}"
  assert_output --partial "${docker_start[@]}"
  assert_output --partial "${git_fetch[@]}"
  assert_output --partial "${docker_stop[@]}"

  unset docker git mktemp
  unset BUILDKITE_PULL_REQUEST_BASE_BRANCH
}
# vim: set ft=bash ts=2 sw=2 et :
