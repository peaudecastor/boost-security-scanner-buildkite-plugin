#!/bin/bash

set -e
set -o pipefail
set -u

declare VAR_PREFIX=BUILDKITE_PLUGIN_BOOST_SECURITY_SCANNER

export BOOST_TMP_DIR=${BOOST_TMP_DIR:-${WORKSPACE_TMP:-${TMPDIR:-/tmp}}}
export BOOST_TMP_DIR_FOR_STEP=${BOOST_TMP_DIR}/${BUILDKITE_STEP_ID}
export BOOST_BIN=${BOOST_BIN:-${BOOST_TMP_DIR_FOR_STEP}/boost.sh}
export BOOST_CLI=${BOOST_CLI:-${BOOST_TMP_DIR_FOR_STEP}/boost-cli}
export BOOST_EXE=${BOOST_EXE:-${BOOST_CLI}/boost.dist/boost}
export BOOST_ENV=${BOOST_ENV:-${BOOST_TMP_DIR_FOR_STEP}/boost.env}

config.get ()
{ # $1=key, [$2=default]
  declare _varname=${VAR_PREFIX}_${1}
  declare value=${!_varname:-}
  echo ${value:-${2:-}}
}

log.info ()
{ # $@=message
  printf "$(date +'%H:%m:%S') [\033[34m%s\033[0m] %s\n" "INFO" "${*}";
}

log.error ()
{ # $@=message
  printf "$(date +'%H:%m:%S') [\033[31m%s\033[0m] %s\n" "ERROR" "${*}";
}

init.config ()
{
  log.info "initializing configuration"

  export BOOST_API_ENDPOINT=${BOOST_API_ENDPOINT:-$(config.get "API_ENDPOINT" "https://api.boostsecurity.io")}
  export BOOST_API_TOKEN=${BOOST_API_TOKEN:-$(config.get "API_TOKEN")}

  export BOOST_SCANNER_IMAGE=${BOOST_SCANNER_IMAGE:-$(config.get "SCANNER_IMAGE")}
  export BOOST_SCANNER_VERSION=${BOOST_SCANNER_VERSION:-$(config.get "SCANNER_VERSION")}

  export BOOST_CLI_ARGUMENTS=${BOOST_CLI_ARGUMENTS:-$(config.get "ADDITIONAL_ARGS")}
  export BOOST_CLI_VERSION=${BOOST_CLI_VERSION:-$(config.get "CLI_VERSION" "2.0")}

  export BOOST_CLI_URL=${BOOST_CLI_URL:-${BOOST_API_ENDPOINT/api/assets}}
         BOOST_CLI_URL=${BOOST_CLI_URL%*/}

  if [ -d /lib/apk ]; then
    BOOST_CLI_URL+="/boost/linux/alpine/amd64/${BOOST_CLI_VERSION}/boost.sh"
  else
    BOOST_CLI_URL+="/boost/linux/glibc/amd64/${BOOST_CLI_VERSION}/boost.sh"
  fi

  export BOOST_DIFF_SCAN_TIMEOUT=$(config.get "DIFF_SCAN_TIMEOUT")
  export BOOST_EXEC_COMMAND=$(config.get "EXEC_COMMAND")
  export BOOST_EXEC_FULL_REPO=$(config.get "EXEC_FULL_REPO")
  export BOOST_GIT_PROJECT=$(config.get "PROJECT_SLUG")

  export DOCKER_CREATE_ARGS=$(config.get "DOCKER_CREATE_ARGS")
}

init.cli ()
{
  log.info "installing cli to ${BOOST_BIN}"
  mkdir -p "${BOOST_TMP_DIR_FOR_STEP}"
  curl --silent --output "${BOOST_BIN}" "${BOOST_CLI_URL}"
  chmod 755 "${BOOST_BIN}"

  if ! "${BOOST_BIN}" version; then
    log.error "failed downloading cli from ${BOOST_CLI_URL}"
    exit 1
  fi
}

main.complete ()
{
  init.config
  init.cli

  ${BOOST_EXE} scan complete
  ! test -f "${BOOST_BIN:-}" || rm "${BOOST_BIN}"
  ! test -f "${BOOST_ENV:-}" || rm "${BOOST_ENV}"
}

main.exec ()
{
  init.config
  init.cli

  if [ -z "${BOOST_EXEC_COMMAND:-}" ]; then
    log.error "the 'exec_command' option must be defined when in exec mode"
    exit 1
  fi

  exec ${BOOST_EXE} scan exec ${BOOST_CLI_ARGUMENTS:-} --command "${BOOST_EXEC_COMMAND}"
}

main.scan ()
{
  init.config
  init.cli

  if [ -n "${BOOST_EXEC_COMMAND:-}" ]; then
    log.error "the 'exec_command' option must only be defined in exec mode"
    exit 1
  fi

  exec ${BOOST_EXE} scan run ${BOOST_CLI_ARGUMENTS:-}
}
