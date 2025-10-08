#!/usr/bin/env bash

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

rm -rf \
    boost/boost-iosx/*.tar.* \
    boost/boost-iosx/boost \
    boost/boost-iosx/frameworks \
    boost/boost-iosx/scripts/Pods \
    boost/boost-iosx/scripts/Podfile.lock \
    boost/boost-iosx/scripts/ICUDep.xcworkspace
