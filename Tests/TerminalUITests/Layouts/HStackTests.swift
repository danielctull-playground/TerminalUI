@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("HStack", .tags(.view, .layout))
struct HStackTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = HStack {}.body
    }
  }

  @Test func `empty`() {

    let screen = TestScreen(width: 3, height: 3)

    screen.render {
      HStack {}
    }

    #expect(screen.buffer.description == """
      ...
      ...
      ...
      """)
  }

  @Test func `single line`() {

    let screen = TestScreen(width: 3, height: 1)

    screen.render {
      HStack {
        Text("1")
        Text("2")
        Text("3")
      }
    }

    #expect(screen.buffer.description == """
      123
      """)
  }

  @Test func `single line 2`() {

    let screen = TestScreen(width: 5, height: 1)

    screen.render {
      HStack {
        Color.blue
        Text("A")
        Color.yellow
      }
    }

    #expect(screen.buffer.description == """
      ▨▨A▥▥
      """)
  }

  @Test func `single line 3`() {

    let screen = TestScreen(width: 11, height: 1)

    screen.render {
      HStack {
        Color.blue
        Text("A")
        Color.yellow
        Text("B")
        Color.red
      }
    }


    #expect(screen.buffer.description == """
      ▨▨▨A▥▥▥B▧▧▧
      """)
  }

  @Test(arguments: Array<(VerticalAlignment, String)>([
    (.top, """
      .A▩B.
      ..▩..
      ..▩..
      """
    ),
    (.center, """
      ..▩..
      .A▩B.
      ..▩..
      """
    ),
    (.bottom, """
      ..▩..
      ..▩..
      .A▩B.
      """
    ),
  ]))
  func `alignment`(alignment: VerticalAlignment, expected: String) {

    let screen = TestScreen(width: 5, height: 3)

    screen.render {
      HStack(alignment: alignment) {
        Text("A")
        Color.black.frame(width: 1) // Ensures full height is used for HStack.
        Text("B")
      }
    }

    #expect(screen.buffer.description == expected)
  }

  @Test(arguments: Array<(Int, String)>([
    (0, "...ABC..."),
    (1, "..A.B.C.."),
    (2, ".A..B..C."),
    (3, "A...B...C"),
  ]))
  func `spacing`(spacing: Int, expected: String) {

    let screen = TestScreen(width: 9, height: 1)

    screen.render {
      HStack(spacing: spacing) {
        Text("A")
        Text("B")
        Text("C")
      }
    }

    #expect(screen.buffer.description == expected)
  }
}
