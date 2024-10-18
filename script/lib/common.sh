get_container_id() {
  local CONTAINER_ID=$(docker ps --filter "name=app" --format "{{.ID}}")
  echo "${CONTAINER_ID}"
}