// swift-tools-version: 6.2

import CompilerPluginSupport
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
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "602.0.0"),
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
