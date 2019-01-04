#!/bin/bash

: ${latest:="$1"}
: ${CI_REGISTRY_IMAGE:="blitznote/golang"}

set -euo pipefail

# A dummy image which is used to compile any "gotools".
build_gotools() {
  pushd .
  mkdir -p "latest"
  cd $_

  ln -f ../prepare-workspace.bash
  <../Dockerfile >Dockerfile sed -e "/GOLANG_VERSION=/s@[0-9]*\.[0-9]*[^\"']*@${latest}@"
  # This deletes the first stage, the one starting with "FROM blitznote/golang:latest as gotools",
  #   because I don't want to fetch any Golang images from any registry as none might exist or might be untrustworthy.
  sed -i \
    -e '/^FROM [^ ]*$/{h;};1,/^FROM/g;/^COPY --from/d' \
    Dockerfile

  docker build --rm -t "$(<../Dockerfile head -n 1 | cut -d ' ' -f 2)" .

  popd
}

build_one_version() {
  local VER="$1"
  pushd .
  mkdir -p "${VER}"
  cd $_

  ln -f ../prepare-workspace.bash
  <../Dockerfile >Dockerfile sed -e "/GOLANG_VERSION=/s@[0-9]*\.[0-9]*[^\"']*@${VER}@"

  docker build --rm -t "${CI_REGISTRY_IMAGE}:${VER}" .
  if [[ "${VER}" != *"alpha"* ]] && [[ "${VER}" != *"beta"* ]] && [[ "${VER}" != *"rc"* ]]; then
    docker tag "${CI_REGISTRY_IMAGE}:${VER}" "${CI_REGISTRY_IMAGE}:${VER%.*}"
  fi
  # This will overwrite any preliminary 'latest' image created above.
  if [[ "${VER}" == "$(printf "${latest}" | cut -d '.' -f -2)"* ]]; then
    docker tag "${CI_REGISTRY_IMAGE}:${VER}" "${CI_REGISTRY_IMAGE}:latest"
    docker tag "${CI_REGISTRY_IMAGE}:${VER}" "${CI_REGISTRY_IMAGE}:${VER%%.*}" # Yes, promote even a beta to '1'.
  fi

  popd
}

if (( ${#@} <= 0 )); then
  >&2 printf "Usage: $0 ver=latest ver…\n"
fi

build_gotools
for V; do
  build_one_version "$V"
done

exit 0
