// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestVPackageVersion",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TestVPackageVersion",
            targets: ["TestVPackageVersion"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sensorsdata/sa-sdk-ios-spm", exact: "4.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TestVPackageVersion",
            dependencies: [.product(name: "SensorsAnalyticsSDK", package: "sa-sdk-ios-spm")]
        ),
    ]
)
