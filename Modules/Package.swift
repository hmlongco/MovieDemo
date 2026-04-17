// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", branch: "develop"),
        .package(url: "https://github.com/hmlongco/Navigator", branch: "main"),
        .package(url: "https://github.com/hmlongco/Runes", branch: "main"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "DesignSystem",
                "Movies",
                "Profile",
                "Shared",
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "NavigatorUI", package: "Navigator"),
                .product(name: "Runes", package: "Runes"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ]
            //            resources: [.process("Resources")],
        ),
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory"),
            ]
        ),
        .target(
            name: "Movies",
            dependencies: [
                "Shared",
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "NavigatorUI", package: "Navigator"),
                .product(name: "Runes", package: "Runes"),
            ]
        ),
        .target(
            name: "Profile",
            dependencies: [
                "Shared",
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "NavigatorUI", package: "Navigator"),
                .product(name: "Runes", package: "Runes"),
           ]
        ),
        .target(
            name: "Shared",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "Runes", package: "Runes"),
            ]
        ),
        .testTarget(
            name: "ModulesTests",
            dependencies: [
                "App"
            ],
            path: "Tests"
        ),
    ]
)
