// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "DisplaceKit",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "DisplaceKit", type: .dynamic, targets: ["DisplaceKit"]),
        .library(name: "DisplaceCommon", targets: ["DisplaceCommon"]),
        .library(name: "DisplaceApplicationSupport", targets: ["DisplaceApplicationSupport"]),
        .library(name: "DisplaceUserNotifications", targets: ["DisplaceUserNotifications"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kentzo/ShortcutRecorder", .upToNextMajor(from: "3.3.0"))
    ],
    targets: [
        .target(
            name: "DisplaceKit",
            dependencies: [
                "DisplaceCommon",
                "DisplaceApplicationSupport",
                "DisplaceUserNotifications",
            ]
        ),
        .target(
            name: "DisplaceCommon",
            dependencies: []
        ),
        .target(
            name: "DisplaceApplicationSupport",
            dependencies: [
                "DisplaceCommon",
                .product(name: "ShortcutRecorder", package: "ShortcutRecorder"),
            ]
        ),
        .target(
            name: "DisplaceUserNotifications",
            dependencies: [
                "DisplaceCommon"
            ]
        ),
    ]
)
