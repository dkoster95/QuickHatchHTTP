// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickHatchHTTP",
    platforms: [.iOS(.v15),
                .watchOS(.v7),
                .macOS(.v12),
                .tvOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "QuickHatchHTTP",
            targets: ["QuickHatchHTTP"]),
        .library(
            name: "QuickHatchHTTPMocks",
            targets: ["QuickHatchHTTPMocks"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "QuickHatchHTTP",
            path: "Sources/"),
        .target(name: "QuickHatchHTTPMocks",
                dependencies: ["QuickHatchHTTP"],
                path: "Tests/Mocks"),
        .testTarget(
            name: "QuickHatchHTTPTests",
            dependencies: ["QuickHatchHTTP", "QuickHatchHTTPMocks"],
            path: "Tests/TestCases",
            resources: [
                .process("Resources") // Processes all resources within the 'Resources' folder
            ]
        ),
    ]
)
