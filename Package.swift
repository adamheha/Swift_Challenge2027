// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "BloomMind",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "BloomMind", targets: ["BloomMind"])
    ],
    targets: [
        .executableTarget(
            name: "BloomMind"
        ),
        .testTarget(
            name: "BloomMindTests",
            dependencies: ["BloomMind"]
        )
    ]
)
