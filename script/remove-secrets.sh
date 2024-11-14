#!/bin/bash
# Set up volumes and environment variables for when using certbot.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"

main() {
  log "Removing secrets"
  docker secret ls -q | xargs -r docker secret rm
  logfun docker secret ls

  logfun rm -rf docker-compose.secrets.yml
  unset_env_value USE_SECRETS
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
