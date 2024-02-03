#!/usr/bin/env bash

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

# BOOST_IOSX_DIR="$(pwd)/boost-iosx"
# BOOST_DIR="${BOOST_IOSX_DIR}/boost"
# BOOST_STAGE_DIR="$BOOST_DIR/stage"
FRAMEWORKS_DIR="$(pwd)/frameworks"
STAGE_DIR="$(pwd)/stage"

combine_static_libs() {
    local PLATFORM_NAME="$1"

    COMBINED_OUTPUT_DIR="$STAGE_DIR/$PLATFORM_NAME/lib"
    mkdir -p "$COMBINED_OUTPUT_DIR"
    libtool -static -o "$COMBINED_OUTPUT_DIR/libRDKit.a" "$BOOST_STAGE_DIR/$PLATFORM_NAME/lib/"*.a
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
    -library "$STAGE_DIR/macosx/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -library "$STAGE_DIR/catalyst/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -library "$STAGE_DIR/ios/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -library "$STAGE_DIR/iossim/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -library "$STAGE_DIR/xros/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -library "$STAGE_DIR/xrossim/lib/libRDKit.a" \
    -headers "$FRAMEWORKS_DIR/Headers" \
    -output "$(pwd)/RDKit.xcframework"

zip -r RDKit.xcframework.zip RDKit.xcframework

echo 'Computing checksum for RDKit.xcframework.zip'
swift package compute-checksum RDKit.xcframework.zip
