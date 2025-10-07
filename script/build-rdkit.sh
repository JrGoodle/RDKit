#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

export RDBASE
RDBASE="$(pwd)/rdkit"
BOOST_IOSX_DIR="$(pwd)/boost/boost-iosx"
BOOST_DIR="${BOOST_IOSX_DIR}/boost"
IOS_CMAKE_DIR="$(pwd)/ios-cmake"

BUILD_DIR="${RDBASE}/build"
INSTALL_DIR="${RDBASE}/stage"

build_libs() {
    local target=$1
    local cmake_platform=$2
    local build_dir="${BUILD_DIR}/${target}"
    local install_dir="${INSTALL_DIR}/${target}"

    echo ''
    echo "Generating ${target}..."
    echo ''

    mkdir -p "$build_dir"
    cd "$build_dir"

    local boost_libs="$BOOST_DIR/stage/${target}/lib"
    local boost_headers="$BOOST_IOSX_DIR/frameworks/Headers"
    local boost_cmake="$boost_libs/cmake/Boost-1.89.0"

    cmake ../.. \
        -G Xcode \
        -DCMAKE_TOOLCHAIN_FILE="${IOS_CMAKE_DIR}/ios.toolchain.cmake" \
        -DPLATFORM="${cmake_platform}" \
        -DCMAKE_PREFIX_PATH="$boost_cmake" \
        -DBoost_ROOT="$boost_libs" \
        -DBoost_NO_SYSTEM_PATHS=ON \
        -DBoost_LIBRARIES="$boost_libs" \
        -DBoost_INCLUDE_DIR="$boost_headers" \
        -DBoost_USE_STATIC_LIBS=ON \
        -DRDK_BUILD_FREETYPE_SUPPORT=OFF \
        -DRDK_BUILD_PYTHON_WRAPPERS=OFF \
        -DRDK_BUILD_COORDGEN_SUPPORT=OFF \
        -DRDK_BUILD_MAEPARSER_SUPPORT=OFF \
        -DRDK_OPTIMIZE_POPCNT=OFF \
        -DRDK_BUILD_TEST_GZIP=OFF \
        -DRDK_BUILD_FREESASA_SUPPORT=OFF \
        -DRDK_BUILD_AVALON_SUPPORT=OFF \
        -DRDK_BUILD_INCHI_SUPPORT=OFF \
        -DRDK_BUILD_YAEHMOP_SUPPORT=OFF \
        -DRDK_BUILD_XYZ2MOL_SUPPORT=OFF \
        -DRDK_BUILD_CAIRO_SUPPORT=OFF \
        -DRDK_BUILD_QT_SUPPORT=OFF \
        -DRDK_BUILD_SWIG_WRAPPERS=OFF \
        -DRDK_SWIG_STATIC=OFF \
        -DRDK_BUILD_THREADSAFE_SSS=ON \
        -DRDK_TEST_MULTITHREADED=OFF \
        -DRDK_BUILD_CFFI_LIB=OFF \
        -DRDK_BUILD_CPP_TESTS=OFF \
        -DRDK_INSTALL_INTREE=OFF \
        -DCMAKE_INSTALL_PREFIX="${install_dir}"
}

install_libs() {
    local target="$1"
    local sdk="$2"
    local destination="$3"
    local build_dir="${BUILD_DIR}/${target}"
    local install_dir="${INSTALL_DIR}/${target}"

    echo ''
    echo "Build and Install ${target}..."
    echo ''

    cd "$build_dir"
    xcodebuild -target install -configuration Release -sdk "${sdk}" -destination "${destination}"
}

# build_libs catalyst-arm64 MAC_CATALYST_ARM64
# build_libs catalyst-x86_64 MAC_CATALYST
build_libs macosx-arm64 MAC_ARM64
# build_libs macosx-x86_64 MAC
build_libs iossim-arm64 SIMULATORARM64
# build_libs iossim-x86_64 SIMULATOR64
build_libs ios-arm64 OS64
build_libs xrossim-arm64 SIMULATOR_VISIONOS
# build_libs xrossim-x86_64 SIMULATOR64_VISIONOS
build_libs xros-arm64 VISIONOS

# install_libs catalyst-arm64 macosx 'generic/platform=macOS,variant=Mac Catalyst'
# install_libs catalyst-x86_64 macosx 'generic/platform=macOS,variant=Mac Catalyst'
install_libs macosx-arm64 macosx 'generic/platform=macOS'
# install_libs macosx-x86_64 macosx 'generic/platform=macOS'
install_libs iossim-arm64 iphonesimulator 'generic/platform=iOS Simulator'
# install_libs iossim-x86_64 iphonesimulator 'generic/platform=iOS Simulator'
install_libs ios-arm64 iphoneos 'generic/platform=iOS'
install_libs xrossim-arm64 xrsimulator 'generic/platform=visionOS Simulator'
# install_libs xrossim-x86_64 xrsimulator 'generic/platform=visionOS Simulator'
install_libs xros-arm64 xros 'generic/platform=visionOS'
