# deploy

# Quick Start

## Step 1

```bash
script/aws-install-docker.sh # only need to run once
```

## Step 2

```bash
script/run-production-server.sh DOCKER_IMAGE_IDENTIFIER
```
Replace `DOCKER_IMAGE_IDENTIFIER` with the identifier of the image you want to deploy in the format `dockerhub_username/image_name:image_tag`. For example, `johndoe/myapp:latest`.

On subsequent runs, you can omit the `DOCKER_IMAGE_IDENTIFIER` argument.

# Debugging

Get a shell inside the running container:

```bash
script/ssh-into-production-server.sh
```

# Stop the production server

```bash
docker stack rm prod
```