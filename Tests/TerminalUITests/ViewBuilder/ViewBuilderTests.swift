@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ViewBuilder", .tags(.modifier))
struct ViewBuilderTests {

  private var screen = TestScreen(width: 5, height: 5)

  @Test func empty() {
    screen.render {}
    #expect(screen.buffer.description == """
      .....
      .....
      .....
      .....
      .....
      """)
  }

  @Test func first() {

    screen.render {
      Text("a")
    }

    #expect(screen.buffer.description == """
      .....
      .....
      ..a..
      .....
      .....
      """)
  }

  @Test func `first body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildPartialBlock(first: Color.black)
        .body
    }
  }

  @Test func accumulated() {

    screen.render {
      Text("a")
      Text("b")
    }

    #expect(screen.buffer.description == """
      .....
      ..a..
      ..b..
      .....
      .....
      """)
  }

  @Test func `accumulated body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildPartialBlock(accumulated: Color.black, next: Color.blue)
        .body
    }
  }

  @Test(arguments: [
    (true, """
      .....
      .....
      ..a..
      .....
      .....
      """
    ),
    (false, """
      .....
      .....
      .....
      .....
      .....
      """
    ),
  ])
  func optional(value: Bool, expected: String) {

    screen.render {
      if value {
        Text("a")
      }
    }

    #expect(screen.buffer.description == expected)
  }

  @Test func `optional body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildOptional(Color.black)
        .body
    }
  }

  @Test(arguments: [
    (true, """
      .....
      .....
      ..a..
      .....
      .....
      """
    ),
    (false, """
      .....
      .....
      ..b..
      .....
      .....
      """
    ),
  ])
  func either(value: Bool, expected: String) {

    screen.render {
      if value {
        Text("a")
      } else {
        Text("b")
      }
    }

    #expect(screen.buffer.description == expected)
  }

  @Test func `either body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      let either: Either<Color, Color> = ViewBuilder.buildEither(first: Color.black)
      _ = either.body
    }
    await #expect(processExitsWith: .failure) {
      let either: Either<Color, Color> = ViewBuilder.buildEither(second: Color.black)
      _ = either.body
    }
  }

#if !os(Linux)
  // I can't find an #available flag that exists for linux machines.
  @Test func limitedAvailability() {

    screen.render {
      if #available(iOS 999, macOS 999, tvOS 999, watchOS 999, *) {
        Text("a")
      } else if #available(*) {  // <-- This causes the builder to hit
        Text("b")                //     buildLimitedAvailability.
      }
    }

    #expect(screen.buffer.description == """
      .....
      .....
      ..b..
      .....
      .....
      """)
  }
#endif

  @Test func `limited availability body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder.buildLimitedAvailability(Color.black).body
    }
  }
}
