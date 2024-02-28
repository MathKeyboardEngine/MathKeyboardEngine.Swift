// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "MyExecutable",
  dependencies: [
    .package(url: "https://github.com/MathKeyboardEngine/MathKeyboardEngine.Swift", from: "1.0.0-beta.2"),
  ],
  targets: [
    .executableTarget(
      name: "MyExecutable",
      dependencies: [
        .product(name: "MathKeyboardEngine", package: "MathKeyboardEngine.Swift"),
      ]),
    .testTarget(
      name: "MyExecutableTests",
      dependencies: ["MyExecutable"]),
  ]
)
