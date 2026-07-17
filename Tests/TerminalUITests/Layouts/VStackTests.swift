@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("VStack", .tags(.view, .layout))
struct VStackTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = VStack {}.body
    }
  }

  @Test func `empty`() {

    let screen = TestScreen(width: 3, height: 3)

    screen.render {
      VStack {}
    }

    #expect(screen.buffer.description == """
      ...
      ...
      ...
      """)
  }

  @Test func `single column`() {

    let screen = TestScreen(width: 1, height: 3)

    screen.render {
      VStack {
        Text("1")
        Text("2")
        Text("3")
      }
    }

    #expect(screen.buffer.description == """
      1
      2
      3
      """)
  }

  @Test func `single column 2`() {

    let screen = TestScreen(width: 1, height: 5)

    screen.render {
      VStack {
        Color.blue
        Text("A")
        Color.yellow
      }
    }

    #expect(screen.buffer.description == """
      ▨
      ▨
      A
      ▥
      ▥
      """)
  }

  @Test func `single coloumn 3`() {

    let screen = TestScreen(width: 1, height: 11)

    screen.render {
      VStack {
        Color.blue
        Text("A")
        Color.yellow
        Text("B")
        Color.red
      }
    }

    #expect(screen.buffer.description == """
      ▨
      ▨
      ▨
      A
      ▥
      ▥
      ▥
      B
      ▧
      ▧
      ▧
      """)
  }

  @Test(arguments: Array<(HorizontalAlignment, String)>([
    (.leading,  """
      ...
      A..
      ▩▩▩
      B..
      ...
      """
    ),
    (.center,  """
      ...
      .A.
      ▩▩▩
      .B.
      ...
      """
    ),
    (.trailing, """
      ...
      ..A
      ▩▩▩
      ..B
      ...
      """
    ),
  ]))
  func `alignment`(alignment: HorizontalAlignment, expected: String) {

    let screen = TestScreen(width: 3, height: 5)

    screen.render {
      VStack(alignment: alignment) {
        Text("A")
        Color.black.frame(height: 1) // Ensures full width is used for HStack.
        Text("B")
      }
    }

    #expect(screen.buffer.description == expected)
  }

  @Test(arguments: Array<(Int, String)>([
    (0, """
      .
      .
      .
      A
      B
      C
      .
      .
      .
      """
    ),
    (1, """
      .
      .
      A
      .
      B
      .
      C
      .
      .
      """
    ),
    (2, """
      .
      A
      .
      .
      B
      .
      .
      C
      .
      """
    ),
    (3, """
      A
      .
      .
      .
      B
      .
      .
      .
      C
      """
    ),
  ]))
  func `spacing`(spacing: Int, expected: String) {

    let screen = TestScreen(width: 1, height: 9)

    screen.render {
      VStack(spacing: spacing) {
        Text("A")
        Text("B")
        Text("C")
      }
    }

    #expect(screen.buffer.description == expected)
  }
}
