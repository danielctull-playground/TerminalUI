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
      ___
      ___
      ___
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
      _A▩B_
      __▩__
      __▩__
      """
    ),
    (.center, """
      __▩__
      _A▩B_
      __▩__
      """
    ),
    (.bottom, """
      __▩__
      __▩__
      _A▩B_
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
    (0, "___ABC___"),
    (1, "__A_B_C__"),
    (2, "_A__B__C_"),
    (3, "A___B___C"),
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
