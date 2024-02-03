// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let version = "2023.9.4"
let moduleName = "RDKit"
let checksum = "a67d7da9744cac7cd6cb3c5062cbd983fda0b6af6af24d0426b9de8445bbe2d2"

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
    dependencies: [
        .package(url: "https://github.com/JrGoodle/boost", .exact("1.84.0")),
    ],
    targets: [
        .binaryTarget(
            name: moduleName,
            url: "https://github.com/JrGoodle/RDKit/releases/download/\(version)/\(moduleName).xcframework.zip",
            checksum: checksum
        )
    ]
)
