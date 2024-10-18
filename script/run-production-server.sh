#!/bin/bash
# 
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"

usage() {
  echo "usage: ${SCRIPT_NAME} [DOCKER_IMAGE_IDENTIFIER]"
}

# Function to get the value of a variable from the .env file
get_env_value() {
  grep "^export $1=" .env | cut -d '=' -f2
}

parse_args() {
  # optional arguments
  DOCKER_IMAGE_IDENTIFIER="${1:-}"

  if [[ "${DOCKER_IMAGE_IDENTIFIER}" == "-h" || \
    "${DOCKER_IMAGE_IDENTIFIER}" == "--help" || \
    "$#" -gt 1 ]]; then
    usage
    exit 0
  fi  

  # defaults
  if [[ -z "${DOCKER_IMAGE_IDENTIFIER}" ]]; then
    set +e
      DOCKER_IMAGE_IDENTIFIER=$(get_env_value DOCKER_IMAGE_IDENTIFIER)
    set -e
    if [[ -z "${DOCKER_IMAGE_IDENTIFIER}" ]]; then
      err "Error: DOCKER_IMAGE_IDENTIFIER not found in .env or parameter."
      usage
      exit 1
    fi
  fi
}

main() {
  parse_args "$@"

  # print to confirm
  log "Production docker image set to: ${DOCKER_IMAGE_IDENTIFIER}"

  # remember the image identifier for next time
  echo "export DOCKER_IMAGE_IDENTIFIER=${DOCKER_IMAGE_IDENTIFIER}" > .env

  # export for docker swarm configuration in the docker-compose file
  export DOCKER_IMAGE_IDENTIFIER 

  # pull the image
  logfun docker pull "${DOCKER_IMAGE_IDENTIFIER}"

  # put Docker in Swarm mode if not already
  if docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "^active$"; then
    log "Docker is in Swarm mode"
  else
    logfun docker swarm init
  fi

  # deploy the stack
  logfun docker stack deploy -c docker-compose.prod.yml prod
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
