#!/bin/bash

set -euo pipefail

: ${latest:="$(ls -1d [1-2].* | sort --version-sort -r | head -n 1)"}
: ${CI_REGISTRY_IMAGE:="blitznote/golang"}

cd "${latest}"
ln -f ../prepare-workspace.bash
# First run gets us the most recent version but with tools made by the previous one.
docker build --rm -t "${CI_REGISTRY_IMAGE}:latest" .
# Second run builds any tools using it.
docker build --rm -t "${CI_REGISTRY_IMAGE}:latest" .
cd ..

docker tag "${CI_REGISTRY_IMAGE}:latest" \
  "${CI_REGISTRY_IMAGE}:${latest}"
docker tag "${CI_REGISTRY_IMAGE}:latest" \
  "${CI_REGISTRY_IMAGE}:$(docker inspect "${CI_REGISTRY_IMAGE}:latest" | jq -r '.[0].Config.Labels["org.label-schema.version"]')" \
  || true

for V in $(ls -1d [1-2].* | sort --version-sort -r); do
  if [[ "${V}" == "${latest}" ]]; then continue; fi

  cd "${V}"
  ln -f ../prepare-workspace.bash
  docker build --rm -t "${CI_REGISTRY_IMAGE}:${V}" .
  docker tag "${CI_REGISTRY_IMAGE}:${V}" \
    "${CI_REGISTRY_IMAGE}:$(docker inspect "${CI_REGISTRY_IMAGE}:${V}" | jq -r '.[0].Config.Labels["org.label-schema.version"]')" \
    || true
  cd ..
done

exit 0
