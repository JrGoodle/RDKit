// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let version = "2023.9.4"
let moduleName = "RDKit"
let checksum = "c6a5b631705ffe19a1abe8515e4af11001e9752aa3449fbd97dee98491d97c90"

let package = Package(
    name: moduleName,
    platforms: [
        .iOS(.v12),.macOS(.v11),.visionOS(.v1)
    ],
    products: [
        .library(
            name: moduleName,
            targets: [moduleName]
        )
    ],
    targets: [
        .binaryTarget(
            name: moduleName,
            url: "https://github.com/JrGoodle/RDKit/releases/download/\(version)/\(moduleName).xcframework.zip",
            checksum: checksum
        )
    ]
)
