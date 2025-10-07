#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

pushd boost
script/update
script/build-boost.sh
