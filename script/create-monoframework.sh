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
    'ios-arm64'
    'iossim-arm64'
    'macosx-arm64'
    'xros-arm64'
    'xrossim-arm64'
)

for platform in "${platforms[@]}"; do
    combine_static_libs "${platform}"
done

xcodebuild -create-xcframework \
    -library "${STAGE_DIR}/macosx-arm64/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/macosx-arm64/include/rdkit" \
    -library "${STAGE_DIR}/ios-arm64/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/ios-arm64/include/rdkit" \
    -library "${STAGE_DIR}/iossim-arm64/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/iossim-arm64/include/rdkit" \
    -library "${STAGE_DIR}/xros-arm64/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/xros-arm64/include/rdkit" \
    -library "${STAGE_DIR}/xrossim-arm64/lib/libRDKit.a" \
    -headers "${STAGE_DIR}/xrossim-arm64/include/rdkit" \
    -output "$(pwd)/RDKit.xcframework"

zip -r RDKit.xcframework.zip RDKit.xcframework

echo 'Computing checksum for RDKit.xcframework.zip'
swift package compute-checksum RDKit.xcframework.zip
