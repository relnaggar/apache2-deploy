#!/bin/bash
# Start a shell session in the container.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"
. "${SCRIPT_DIR}/lib/common.sh"

main() {
  local COMMAND="${1:-}"
  if [[ -n "${COMMAND}" ]]; then
    COMMAND=("-c" "${COMMAND}")
  fi
  
  local CONTAINER_ID=$(get_container_id)
  log "docker exec -it \"${CONTAINER_ID}\" /bin/bash ${COMMAND[@]:-}"
  docker exec -it "${CONTAINER_ID}" /bin/bash ${COMMAND[@]:-}
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
