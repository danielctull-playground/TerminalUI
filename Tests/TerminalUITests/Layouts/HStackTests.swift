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

    #expect(screen.cells == [:])
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

    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("1"),
      Position(x: 2, y: 1): Cell("2"),
      Position(x: 3, y: 1): Cell("3"),
    ])
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

    #expect(screen.cells == [
      Position(x: 1,  y: 1): Cell(" ", background: .blue),
      Position(x: 2,  y: 1): Cell(" ", background: .blue),
      Position(x: 3,  y: 1): Cell("A"),
      Position(x: 4,  y: 1): Cell(" ", background: .yellow),
      Position(x: 5,  y: 1): Cell(" ", background: .yellow),
    ])
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

    #expect(screen.cells == [
      Position(x:  1, y: 1): Cell(" ", background: .blue),
      Position(x:  2, y: 1): Cell(" ", background: .blue),
      Position(x:  3, y: 1): Cell(" ", background: .blue),
      Position(x:  4, y: 1): Cell("A"),
      Position(x:  5, y: 1): Cell(" ", background: .yellow),
      Position(x:  6, y: 1): Cell(" ", background: .yellow),
      Position(x:  7, y: 1): Cell(" ", background: .yellow),
      Position(x:  8, y: 1): Cell("B"),
      Position(x:  9, y: 1): Cell(" ", background: .red),
      Position(x: 10, y: 1): Cell(" ", background: .red),
      Position(x: 11, y: 1): Cell(" ", background: .red),
    ])
  }

  @Test(arguments: Array<(VerticalAlignment, Int)>([
    (.top,    1),
    (.center, 2),
    (.bottom, 3),
  ]))
  func `alignment`(alignment: VerticalAlignment, y: Int) {

    let screen = TestScreen(width: 5, height: 3)

    screen.render {
      HStack(alignment: alignment) {
        Text("A")
        Color.black.frame(width: 1) // Ensures full height is used for HStack.
        Text("B")
      }
    }

    #expect(screen.cells == [
      Position(x:  2, y: y): Cell("A"),
      Position(x:  4, y: y): Cell("B"),
      Position(x:  3, y: 1): Cell(" ", background: .black),
      Position(x:  3, y: 2): Cell(" ", background: .black),
      Position(x:  3, y: 3): Cell(" ", background: .black),
    ])
  }

  @Test(arguments: Array<(Int, Int, Int, Int)>([
    (0, 4, 5, 6),
    (1, 3, 5, 7),
    (2, 2, 5, 8),
    (3, 1, 5, 9),
  ]))
  func `spacing`(spacing: Int, a: Int, b: Int, c: Int) {

    let screen = TestScreen(width: 9, height: 1)

    screen.render {
      HStack(spacing: spacing) {
        Text("A")
        Text("B")
        Text("C")
      }
    }

    #expect(screen.cells == [
      Position(x: a, y: 1): Cell("A"),
      Position(x: b, y: 1): Cell("B"),
      Position(x: c, y: 1): Cell("C"),
    ])
  }
}
