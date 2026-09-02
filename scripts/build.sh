#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-docker-pipeline-lab}"
TAG="${TAG:-latest}"
IMAGE="${IMAGE_NAME}:${TAG}"

echo "Building ${IMAGE}..."
docker build -t "${IMAGE}" .
echo "Build completed successfully."
