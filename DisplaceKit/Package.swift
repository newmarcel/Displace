// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DisplaceKit",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "DisplaceKit", type: .dynamic, targets: ["DisplaceKit"]),
    ],
    dependencies: [
        .package(
            name: "ShortcutRecorder",
            url: "https://github.com/Kentzo/ShortcutRecorder",
            .upToNextMajor(from: "3.3.0")
        )
    ],
    targets: [
        .target(name: "DisplaceKit", dependencies: ["ShortcutRecorder"]),
    ]
)
