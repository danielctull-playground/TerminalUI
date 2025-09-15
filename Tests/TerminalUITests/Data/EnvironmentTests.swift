@testable import TerminalUI
import TerminalUIMacros
import TerminalUITesting
import Testing

@Suite("Environment")
struct EnvironmentTests {

  @Test("read outside of body: fatal")
  func readOutsideOfBody() async {
    await #expect(processExitsWith: .failure) {
      _ = TestView().value
    }
  }

  @Test("default")
  func defaultValue() {

    let canvas = TestCanvas(width: 7, height: 1)

    canvas.render {
      TestView()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("d"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("f"),
      Position(x: 4, y: 1): Pixel("a"),
      Position(x: 5, y: 1): Pixel("u"),
      Position(x: 6, y: 1): Pixel("l"),
      Position(x: 7, y: 1): Pixel("t"),
    ])
  }

  @Test("write")
  func write() {

    let canvas = TestCanvas(width: 7, height: 1)

    canvas.render {
      TestView().environment(\.value, "b")
    }

    #expect(canvas.pixels == [
      Position(x: 4, y: 1): Pixel("b"),
    ])
  }

  @Test("write body: fatal")
  func writeBody() async {
    await #expect(processExitsWith: .failure) {
      _ = TestView().environment(\.value, "b").body
    }
  }

  @Test("transform")
  func modifier() {

    let canvas = TestCanvas(width: 8, height: 1)

    canvas.render {
      TestView().transformEnvironment(\.value) { $0.append("a") }
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("d"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("f"),
      Position(x: 4, y: 1): Pixel("a"),
      Position(x: 5, y: 1): Pixel("u"),
      Position(x: 6, y: 1): Pixel("l"),
      Position(x: 7, y: 1): Pixel("t"),
      Position(x: 8, y: 1): Pixel("a"),
    ])
  }

  @Test("transform body: fatal")
  func transformBody() async {
    await #expect(processExitsWith: .failure) {
      _ = TestView().transformEnvironment(\.value) { $0.append("a") }.body
    }
  }

//  @Test(arguments: Array<(String, Int, Int, Int, Int)>([
//    ("12345", 5, 1, 5, 1),
//    ("12345", 3, 2, 3, 2),
//    ("123 456 789", 5, 4, 3, 3),
//    ("123456789", 5, 5, 5, 2),
//    ("123456", 5, 5, 5, 2),
//  ]))
//  func size(
//    input: String,
//    proposedWidth: Int,
//    proposedHeight: Int,
//    expectedWidth: Int,
//    expectedHeight: Int
//  ) throws {
//    let proposed = ProposedViewSize(width: proposedWidth, height: proposedHeight)
//    let view = TestView().environment(\.value, input)
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = view.makeView(inputs: inputs).displayItems
//    try #require(items.count == 1)
//    let size = items[0].size(for: proposed)
//    #expect(size.width == expectedWidth)
//    #expect(size.height == expectedHeight)
//  }
}

private struct TestView: View {
  @Environment(\.value) var value
  var body: some View {
    Text(value)
  }
}

private struct ValueKey: EnvironmentKey {
  static var defaultValue: String { "default" }
}

extension EnvironmentValues {
  fileprivate var value: String {
    get { self[ValueKey.self] }
    set { self[ValueKey.self] = newValue }
  }
}

import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class EnvironmentEntryTests: XCTestCase {

  func testSuccess() {
    assertMacroExpansion(
      """
      extension EnvironmentValues {
        @Entry var foo = Foo()
      }
      """,
      expandedSource: """
      extension EnvironmentValues {
        var foo {
            get {
              self[__Key_foo.self]
            }
            set {
              self[__Key_foo.self] = newValue
            }
        }

        private struct __Key_foo: EnvironmentKey {
          typealias Value = Foo
          static var defaultValue: Foo {
            Foo()
          }
        }
      }
      """,
      macros: ["Entry": EntryMacro.self]
    )
  }

  func testSubclass() {
    assertMacroExpansion(
      """
      extension EnvironmentValues {
        @Entry var foo: Foo = Bar()
      }
      """,
      expandedSource: """
      extension EnvironmentValues {
        var foo: Foo {
            get {
              self[__Key_foo.self]
            }
            set {
              self[__Key_foo.self] = newValue
            }
        }

        private struct __Key_foo: EnvironmentKey {
          typealias Value = Foo
          static var defaultValue: Foo  {
            Bar()
          }
        }
      }
      """,
      macros: ["Entry": EntryMacro.self]
    )
  }

  func testInvalidExtensionType() {
    assertMacroExpansion(
      """
      extension UnhandledType {
        @Entry var foo = Foo()
      }
      """,
      expandedSource: """
      extension UnhandledType {
        var foo = Foo()
      }
      """,
      diagnostics: [
        DiagnosticSpec(
          id: MessageID(domain: "SwiftDiagnostics", id: "Failure"),
          message: "Can only be used inside EnvironmentValues.",
          line: 2,
          column: 3
        ),
        DiagnosticSpec(
          id: MessageID(domain: "SwiftDiagnostics", id: "Failure"),
          message: "Can only be used inside EnvironmentValues.",
          line: 2,
          column: 3
        ),
      ],
      macros: ["Entry": EntryMacro.self]
    )
  }
}
