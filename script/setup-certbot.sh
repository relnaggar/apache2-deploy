#!/bin/bash
# 
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"
. "${SCRIPT_DIR}/lib/common.sh"

main() {
  # create directories for bind mounting
  if [[ ! -d ".ssl" ]]; then
    log "Creating ssl directory"
    mkdir .ssl
  fi
  if [[ ! -d ".ssl/letsencrypt" ]]; then
    log "Creating letsencrypt directory"
    mkdir .ssl/letsencrypt
  fi
  if [[ ! -d ".ssl/apache-sites-available" ]]; then
    # copy apache sites-available files from production server
    log "Copying apache sites-available files from production server"
    logfun docker cp "$(get_container_id):/etc/apache2/sites-available" .ssl/apache-sites-available
  fi

  # set certbot config env variable
  if [[ -z "$(get_env_value USE_CERTBOT)" ]]; then
    log "Setting USE_CERTBOT in .env"
    echo "export USE_CERTBOT=true" >> .env
  fi

  # restart the production server
  log "Restarting the production server"
  script/run-production-server.sh
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
