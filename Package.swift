// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "TerminalUI",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
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
