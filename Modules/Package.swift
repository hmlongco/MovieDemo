// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "App", targets: ["App"]),
        .library(name: "MoviesApp", targets: ["MoviesApp"]),
        .library(name: "ProfileApp", targets: ["ProfileApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", branch: "main"),
        .package(url: "https://github.com/hmlongco/Navigator", branch: "main"),
        .package(url: "https://github.com/hmlongco/Runes", branch: "main"),
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
            ]
            //            resources: [.process("Resources")],
        ),
        .target(
            name: "MoviesApp",
            dependencies: [
                "DesignSystem",
                "Movies",
                "Shared",
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "NavigatorUI", package: "Navigator"),
                .product(name: "Runes", package: "Runes"),
            ]
            //            resources: [.process("Resources")],
        ),
        .target(
            name: "ProfileApp",
            dependencies: [
                "DesignSystem",
                "Profile",
                "Shared",
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "NavigatorUI", package: "Navigator"),
                .product(name: "Runes", package: "Runes"),
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
                "App",
                .product(name: "FactoryTesting", package: "Factory"),
            ],
            path: "Tests"
        ),
    ]
)
