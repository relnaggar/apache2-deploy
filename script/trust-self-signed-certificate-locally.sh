#!/bin/bash
# Add the self-signed localhost SSL certificate to the trust store.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"
. "${SCRIPT_DIR}/lib/ssl.sh"
. "${SCRIPT_DIR}/lib/docker-stack.sh"

main() {
  # get the snakeoil SSL certificate
  logfun docker cp "$(get_container_id):/etc/ssl/certs/ssl-cert-snakeoil.pem" temp.pem

  # add the self-signed localhost certificates to the trust store
  logfun trust_certificate_locally temp.pem

  # cleanup
  logfun rm temp.pem
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
