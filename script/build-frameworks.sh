#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

export RDBASE
RDBASE="$(pwd)/rdkit"

echo creating frameworks...

INSTALL_DIR="${RDBASE}/stage"
FRAMEWORKS_DIR="$(pwd)/frameworks"

mkdir -p "$FRAMEWORKS_DIR"

build_xcframework() {
    local library_name=$1

    mkdir -p "${INSTALL_DIR}/macosx/lib"
	lipo -create \
        "${INSTALL_DIR}/macosx-arm64/lib/libRDKit${library_name}_static.a" \
        "${INSTALL_DIR}/macosx-x86_64/lib/libRDKit${library_name}_static.a" \
        -output "${INSTALL_DIR}/macosx/lib/libRDKit${library_name}_static.a"

    cp -R "${INSTALL_DIR}/macosx-arm64/include/" "${INSTALL_DIR}/macosx/include/"

    mkdir -p "${INSTALL_DIR}/iossim/lib"
	lipo -create \
        "${INSTALL_DIR}/iossim-arm64/lib/libRDKit${library_name}_static.a" \
        "${INSTALL_DIR}/iossim-x86_64/lib/libRDKit${library_name}_static.a" \
        -output "${INSTALL_DIR}/iossim/lib/libRDKit${library_name}_static.a"

    cp -R "${INSTALL_DIR}/iossim-arm64/include/" "${INSTALL_DIR}/iossim/include/"

    mkdir -p "${INSTALL_DIR}/xrossim/lib"
	lipo -create \
        "${INSTALL_DIR}/xrossim-arm64/lib/libRDKit${library_name}_static.a" \
        "${INSTALL_DIR}/xrossim-x86_64/lib/libRDKit${library_name}_static.a" \
        -output "${INSTALL_DIR}/xrossim/lib/libRDKit${library_name}_static.a"

    cp -R "${INSTALL_DIR}/xrossim-arm64/include/" "${INSTALL_DIR}/xrossim/include/"

    xcodebuild -create-xcframework \
        -library "${INSTALL_DIR}/macosx/lib/libRDKit${library_name}_static.a" \
        -library "${INSTALL_DIR}/ios/lib/libRDKit${library_name}_static.a" \
        -library "${INSTALL_DIR}/iossim/lib/libRDKit${library_name}_static.a" \
        -library "${INSTALL_DIR}/xros/lib/libRDKit${library_name}_static.a" \
        -library "${INSTALL_DIR}/xrossim/lib/libRDKit${library_name}_static.a" \
        -output "${FRAMEWORKS_DIR}/${library_name}.xcframework"
}

build_xcframework Abbreviations
build_xcframework Alignment
build_xcframework CIPLabeler
build_xcframework Catalogs
build_xcframework ChemReactions
build_xcframework ChemTransforms
build_xcframework ChemicalFeatures
build_xcframework DataStructs
build_xcframework Depictor
build_xcframework Deprotect
build_xcframework Descriptors
build_xcframework DistGeomHelpers
build_xcframework DistGeometry
build_xcframework EigenSolvers
build_xcframework FMCS
build_xcframework FileParsers
build_xcframework FilterCatalog
build_xcframework Fingerprints
build_xcframework ForceFieldHelpers
build_xcframework ForceField
build_xcframework FragCatalog
build_xcframework GeneralizedSubstruct
build_xcframework GenericGroups
build_xcframework GraphMol
build_xcframework InfoTheory
build_xcframework MMPA
build_xcframework MarvinParser
build_xcframework MolAlign
build_xcframework MolCatalog
build_xcframework MolChemicalFeatures
build_xcframework MolDraw2D
build_xcframework MolEnumerator
build_xcframework MolHash
build_xcframework MolInterchange
build_xcframework MolStandardize
build_xcframework MolTransforms
build_xcframework O3AAlign
build_xcframework Optimizer
build_xcframework PartialCharges
build_xcframework RDGeneral
build_xcframework RDGeometryLib
build_xcframework RDStreams
build_xcframework RGroupDecomposition
build_xcframework RascalMCES
build_xcframework ReducedGraphs
build_xcframework RingDecomposerLib
build_xcframework ScaffoldNetwork
build_xcframework ShapeHelpers
build_xcframework SimDivPickers
build_xcframework SmilesParse
build_xcframework Subgraphs
build_xcframework SubstructLibrary
build_xcframework SubstructMatch
build_xcframework TautomerQuery
build_xcframework Trajectory

cp -R "${INSTALL_DIR}/ios/include" "${FRAMEWORKS_DIR}/Headers"
