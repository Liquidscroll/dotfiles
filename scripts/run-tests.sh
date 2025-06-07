#!/usr/bin/env bash

# Build and run tests inside Docker

set -euo pipefail

IMAGE_NAME="dotfiles-test"

# Build the Docker image

docker build -t "$IMAGE_NAME" .

# Run tests

docker run --rm "$IMAGE_NAME"
