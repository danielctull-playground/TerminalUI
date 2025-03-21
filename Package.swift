// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "TerminalUI",
  products: [
    .library(name: "TerminalUI", targets: ["TerminalUI"]),
    .library(name: "TerminalUITesting", targets: ["TerminalUITesting"]),
  ],
  targets: [

    .target(
      name: "AttributeGraph"
    ),

    .testTarget(
      name: "AttributeGraphTests",
      dependencies: ["AttributeGraph"]
    ),

    .target(
      name: "TerminalUI",
      dependencies: [
        "AttributeGraph",
      ]
    ),

    .target(
      name: "TerminalUITesting",
      dependencies: ["TerminalUI"]
    ),

    .testTarget(
      name: "TerminalUITests",
      dependencies: [
        "TerminalUI",
        "TerminalUITesting",
      ]
    ),

    .executableTarget(
      name: "TerminalUI Demo",
      dependencies: ["TerminalUI"]
    ),
  ]
)
