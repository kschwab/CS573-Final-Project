#!/bin/sh

# The CS573 final project root directory
pushd $(dirname $0)/..

##############################################
# Build the CS573 Final Project Docker Image #
##############################################

# 1. Ensure that the workspace is cleaned up
find . -type d \( -name .flatpak-builder -o -name build-dir \) -exec rm -rf {} +

# 2. Run the docker build command
docker build -t cs573-final-project .

popd
