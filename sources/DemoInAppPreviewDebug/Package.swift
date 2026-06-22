// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DemoInAppPreviewDebugUI",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "DemoInAppPreviewDebugUI",
            targets: ["DemoInAppPreviewDebugUI"]
        ),
    ],
    targets: [
        .target(name: "DemoInAppPreviewDebugUI"),
    ]
)
