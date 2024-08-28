// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "TerminalUI",
  products: [
    .library(name: "TerminalUI", targets: ["TerminalUI"]),
  ],
  targets: [

    .target(
      name: "TerminalUI"
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
