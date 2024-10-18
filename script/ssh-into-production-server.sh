#!/bin/bash
# Start a shell session in the container or run a command in the container.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"
. "${SCRIPT_DIR}/lib/docker-stack.sh"

main() {
  local command="${1:-}"
  if [[ -n "${command}" ]]; then
    command=("-c" "${command}")
  fi
  
  local container_id=$(get_container_id)
  log "docker exec -it \"${container_id}\" /bin/bash ${command[@]:-}"
  docker exec -it "${container_id}" /bin/bash ${command[@]:-}
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
