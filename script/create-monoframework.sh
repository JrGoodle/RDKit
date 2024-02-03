#!/usr/bin/env bash

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

RDBASE="$(pwd)/rdkit"
STAGE_DIR="${RDBASE}/stage"

combine_static_libs() {
    local PLATFORM_NAME="$1"

    libtool -static -o "$STAGE_DIR/$PLATFORM_NAME/lib/libRDKit.a" "$STAGE_DIR/$PLATFORM_NAME/lib/"*.a
}

platforms=(
    # 'catalyst'
    'ios'
    'iossim'
    'macosx'
    'xros'
    'xrossim'
)

for platform in "${platforms[@]}"; do
    combine_static_libs "${platform}"
done

xcodebuild -create-xcframework \
    -library "${STAGE_DIR}/macosx/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/macosx/include" \
    -library "${STAGE_DIR}/ios/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/ios/include" \
    -library "${STAGE_DIR}/iossim/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/iossim/include" \
    -library "${STAGE_DIR}/xros/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/xros/include" \
    -library "${STAGE_DIR}/xrossim/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/xrossim/include" \
    -output "$(pwd)/RDKit.xcframework"

zip -r RDKit.xcframework.zip RDKit.xcframework

echo 'Computing checksum for RDKit.xcframework.zip'
swift package compute-checksum RDKit.xcframework.zip
