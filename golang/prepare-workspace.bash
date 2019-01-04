#!/bin/bash

set -euo pipefail

if [[ "${PWD}" != "/" ]] && [[ -d "/workspace" ]] && [[ "${PWD}" != "/workspace"* ]]; then
  # Google Cloud Builder uses /workspace
  D="${PWD}"
  cd ..
  rmdir "${D}"
  ln -s "/workspace" "${D}"
  cd "${D}"
fi

if (( ${#@} > 0 )) && [[ -x "$(command -v "$1" 2>&1)" ]]; then
  exec "$@"
fi
exec /bin/bash "$@"
