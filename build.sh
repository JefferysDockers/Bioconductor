#!/bin/sh

# To build manually, clone the repo shallowly
# then cd to the repo root and run ./build.sh, this file.
#
# The meat of the file is relocated to hooks/build to mesh easily with
# DockerHub's auto build process.

# The repo name on DockerHub
export DOCKER_REPO="jefferys/bioconductor"

# The path to the dockerfile
export DOCKERFILE_PATH="Docker/Dockerfile"

TAG=$(git tag --sort committerdate)
export DOCKER_TAG=${TAG##*$'\n'}
if [[ -z "$DOCKER_TAG" ]]; then
   echo "No tag available in the current repo" >&2
   exit 1
fi

# Must be relative to root of repo, hooks dir must be in same dir as Dockerfile
./Docker/hooks/build