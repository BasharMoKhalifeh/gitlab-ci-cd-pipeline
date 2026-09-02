#!/usr/bin/env bash
set -euo pipefail

: "${DEPLOY_HOST:?DEPLOY_HOST is required}"
: "${DEPLOY_USER:?DEPLOY_USER is required}"
: "${IMAGE:?IMAGE is required}"

CONTAINER_NAME="${CONTAINER_NAME:-docker-pipeline-lab}"
PORT="${PORT:-8080}"

ssh "${DEPLOY_USER}@${DEPLOY_HOST}" "docker pull '${IMAGE}'"
ssh "${DEPLOY_USER}@${DEPLOY_HOST}" "docker rm -f '${CONTAINER_NAME}' 2>/dev/null || true"
ssh "${DEPLOY_USER}@${DEPLOY_HOST}" "docker run -d --restart unless-stopped --name '${CONTAINER_NAME}' -p '${PORT}:8080' '${IMAGE}'"

echo "Deployment completed on ${DEPLOY_HOST}."
