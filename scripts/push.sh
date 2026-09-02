#!/usr/bin/env bash
set -euo pipefail

: "${REGISTRY_URL:?REGISTRY_URL is required}"
: "${REGISTRY_USER:?REGISTRY_USER is required}"
: "${REGISTRY_PASSWORD:?REGISTRY_PASSWORD is required}"

IMAGE_NAME="${IMAGE_NAME:-docker-pipeline-lab}"
TAG="${TAG:-latest}"
LOCAL_IMAGE="${IMAGE_NAME}:${TAG}"
REMOTE_IMAGE="${REGISTRY_URL}/${IMAGE_NAME}:${TAG}"

echo "Logging in to ${REGISTRY_URL}..."
printf '%s' "${REGISTRY_PASSWORD}" | docker login "${REGISTRY_URL}" -u "${REGISTRY_USER}" --password-stdin

docker tag "${LOCAL_IMAGE}" "${REMOTE_IMAGE}"
docker push "${REMOTE_IMAGE}"

echo "Pushed ${REMOTE_IMAGE}"
