// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let version = "2023.9.4"
let moduleName = "RDKit"
let checksum = ""

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
