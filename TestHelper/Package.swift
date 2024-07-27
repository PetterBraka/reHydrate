// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestHelper",
    products: [.library(name: "TestHelper", targets: ["TestHelper"])],
    targets: [.target(name: "TestHelper", path: "Sources")]
)
