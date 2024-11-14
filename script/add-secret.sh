#!/bin/bash
# Add a secret to Docker and setup docker-compose.secrets.yml file to use it.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"

main() {
  if [[ -z "$(get_env_value USE_SECRETS)" ]]; then
    log "USE_SECRETS=true >> .env"
    echo "export USE_SECRETS=true" >> .env
  fi

  logfun docker secret ls

  read -p "Enter secret name: " secretName

  log "Creating secret ${secretName}, please enter the secret value followed by"
  log "a newline and then Ctrl+D: "
  docker secret create "${secretName}" - < /dev/stdin

  if [[ ! -f docker-compose.secrets.yml ]]; then
    log "Creating docker-compose.secrets.yml"
    cat <<EOF > docker-compose.secrets.yml
services:
  app:
    secrets:
      - ${secretName}
secrets:
  ${secretName}:
    external: true
EOF
  else
    log "Checking if secret ${secretName} is already in docker-compose.secrets.yml"
    if grep -q "${secretName}" docker-compose.secrets.yml; then
      log "Secret ${secretName} already in docker-compose.secrets.yml"
    else
      log "Adding secret ${secretName} to app service in docker-compose.secrets.yml"
      if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (BSD sed)
        sed -i '' "/^    secrets:/a\\
      - ${secretName}
" docker-compose.secrets.yml
      else
        # Linux (GNU sed)
        sed -i "/^    secrets:/a\\      - ${secretName}
" docker-compose.secrets.yml
      fi
      log "Appending to docker-compose.secrets.yml"
      cat <<EOF >> docker-compose.secrets.yml
  ${secretName}:
    external: true
EOF
    fi
  fi

  logfun docker secret ls
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
