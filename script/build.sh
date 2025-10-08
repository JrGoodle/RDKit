#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

script/clean
script/build-boost.sh
script/build-rdkit.sh
script/create-monoframework.sh
