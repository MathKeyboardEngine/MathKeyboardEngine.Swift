// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MathKeyboardEngine",
    products: [ .library(name: "MathKeyboardEngine", targets: [ "MathKeyboardEngine" ]) ],
    targets: [
        .target(name: "MathKeyboardEngine"),
        .testTarget(name: "MathKeyboardEngineTests", dependencies: ["MathKeyboardEngine"])
    ]
)