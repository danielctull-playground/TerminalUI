// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "TerminalUI",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
    .watchOS(.v11),
    .tvOS(.v18),
  ],
  products: [
    .library(name: "TerminalUI", targets: ["TerminalUI"]),
    .library(name: "TerminalUITesting", targets: ["TerminalUITesting"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.1.0"),
    .package(url: "https://github.com/apple/swift-syntax.git", from: "602.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
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
        "TerminalUIMacros",
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
        .product(name: "Logging", package: "swift-log"),
      ]
    ),

    .macro(
      name: "TerminalUIMacros",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
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
        "TerminalUIMacros",
        "TerminalUITesting",
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),

    .executableTarget(
      name: "TerminalUI Demo",
      dependencies: ["TerminalUI"]
    ),
  ]
)
