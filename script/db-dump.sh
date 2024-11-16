#!/bin/bash
# Dump the database folder to the local filesystem.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"
. "${SCRIPT_DIR}/lib/docker-stack.sh"

main() {
  timestamp=$(date +%Y%m%d%H%M%S)
  logfun docker cp "$(get_container_id):/var/db" "db-${timestamp}"
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
