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
      ___
      ___
      ___
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
      ___
      A__
      ▩▩▩
      B__
      ___
      """
    ),
    (.center,  """
      ___
      _A_
      ▩▩▩
      _B_
      ___
      """
    ),
    (.trailing, """
      ___
      __A
      ▩▩▩
      __B
      ___
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
      _
      _
      _
      A
      B
      C
      _
      _
      _
      """
    ),
    (1, """
      _
      _
      A
      _
      B
      _
      C
      _
      _
      """
    ),
    (2, """
      _
      A
      _
      _
      B
      _
      _
      C
      _
      """
    ),
    (3, """
      A
      _
      _
      _
      B
      _
      _
      _
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
