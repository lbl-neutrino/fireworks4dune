#!/usr/bin/env bash
set -euo pipefail

# Script to look up the container/image ID hash from Shifter
# based on the image name and pull it if not found.

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <image_name>" >&2
    echo "Example: $0 docker:fermilab/fnal-wn-sl7:latest" >&2
    exit 1
fi

IMAGE_NAME="$1"

# Check if the image is already present
if shifterimg lookup "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Image already present: $IMAGE_NAME"
else
    echo "Image not found locally, pulling: $IMAGE_NAME"
    shifterimg pull "$IMAGE_NAME"
fi

# Look up the image digest/id (re-check after pull, or if it was already there)
IMG_HASH=$(shifterimg lookup "$IMAGE_NAME")

if [[ -z "$IMG_HASH" ]]; then
    echo "Error: could not resolve image digest for $IMAGE_NAME" >&2
    exit 1
fi

# Print as the last line for output redirection
echo "$IMG_HASH"
