#!/bin/bash
# Generate a shell script to run the build.
set -e
# Load the base image
{base_loader}
context={context}
# Setup a tmpdir context
tmpdir=$(mktemp -d)
if [[ ! -z $context ]]; then
    tar -xf $context -C "$tmpdir"
fi
# Template out the FROM line.
cat {dockerfile} | sed "s|FROM.*|FROM {base_name}|g" > "$tmpdir"/Dockerfile
# Perform the build in the context
docker build -t {tag} "$tmpdir"
# Copy out the rootfs.
docker save {tag} > {output}