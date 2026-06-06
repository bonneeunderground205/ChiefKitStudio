// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ChiefKitStudio",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ChiefKitStudio", targets: ["ChiefKitStudio"])
    ],
    targets: [
        .executableTarget(
            name: "ChiefKitStudio",
            path: "Sources/ChiefKitStudio",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
