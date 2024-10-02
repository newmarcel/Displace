// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "DisplaceKit",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "DisplaceKit", type: .dynamic, targets: ["DisplaceKit"]),
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
                "DisplaceApplicationSupport",
                "DisplaceUserNotifications",
            ]
        ),
        .target(
            name: "DisplaceApplicationSupport",
            dependencies: [
                .product(name: "ShortcutRecorder", package: "ShortcutRecorder"),
            ]
        ),
        .target(
            name: "DisplaceUserNotifications",
            dependencies: []
        ),
    ]
)
