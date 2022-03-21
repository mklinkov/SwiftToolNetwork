// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftToolNetwork",
    products: [
        .library(
            name: "SwiftToolNetwork",
            targets: ["SwiftToolNetwork"]),
    ],
    targets: [
        .target(
            name: "SwiftToolNetwork",
            dependencies: []),
        .testTarget(
            name: "SwiftToolNetworkTests",
            dependencies: ["SwiftToolNetwork"]),
    ]
)
