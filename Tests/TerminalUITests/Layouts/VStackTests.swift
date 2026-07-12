import TerminalUI
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

    let canvas = TestCanvas(width: 3, height: 3)

    canvas.render {
      VStack {}
    }

    #expect(canvas.cells == [:])
  }

  @Test func `single column`() {

    let canvas = TestCanvas(width: 1, height: 3)

    canvas.render {
      VStack {
        Text("1")
        Text("2")
        Text("3")
      }
    }

    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("1"),
      Position(x: 1, y: 2): Cell("2"),
      Position(x: 1, y: 3): Cell("3"),
    ])
  }

  @Test func `single column 2`() {

    let canvas = TestCanvas(width: 1, height: 5)

    canvas.render {
      VStack {
        Color.blue
        Text("A")
        Color.yellow
      }
    }

    #expect(canvas.cells == [
      Position(x: 1,  y: 1): Cell(" ", background: .blue),
      Position(x: 1,  y: 2): Cell(" ", background: .blue),
      Position(x: 1,  y: 3): Cell("A"),
      Position(x: 1,  y: 4): Cell(" ", background: .yellow),
      Position(x: 1,  y: 5): Cell(" ", background: .yellow),
    ])
  }

  @Test func `single coloumn 3`() {

    let canvas = TestCanvas(width: 1, height: 11)

    canvas.render {
      VStack {
        Color.blue
        Text("A")
        Color.yellow
        Text("B")
        Color.red
      }
    }

    #expect(canvas.cells == [
      Position(x: 1, y:  1): Cell(" ", background: .blue),
      Position(x: 1, y:  2): Cell(" ", background: .blue),
      Position(x: 1, y:  3): Cell(" ", background: .blue),
      Position(x: 1, y:  4): Cell("A"),
      Position(x: 1, y:  5): Cell(" ", background: .yellow),
      Position(x: 1, y:  6): Cell(" ", background: .yellow),
      Position(x: 1, y:  7): Cell(" ", background: .yellow),
      Position(x: 1, y:  8): Cell("B"),
      Position(x: 1, y:  9): Cell(" ", background: .red),
      Position(x: 1, y: 10): Cell(" ", background: .red),
      Position(x: 1, y: 11): Cell(" ", background: .red),
    ])
  }

  @Test(arguments: Array<(HorizontalAlignment, Int)>([
    (.leading,  1),
    (.center,   2),
    (.trailing, 3),
  ]))
  func `alignment`(alignment: HorizontalAlignment, x: Int) {

    let canvas = TestCanvas(width: 3, height: 5)

    canvas.render {
      VStack(alignment: alignment) {
        Text("A")
        Color.black.frame(height: 1) // Ensures full width is used for HStack.
        Text("B")
      }
    }

    #expect(canvas.cells == [
      Position(x:  x, y: 2): Cell("A"),
      Position(x:  x, y: 4): Cell("B"),
      Position(x:  1, y: 3): Cell(" ", background: .black),
      Position(x:  2, y: 3): Cell(" ", background: .black),
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

    let canvas = TestCanvas(width: 1, height: 9)

    canvas.render {
      VStack(spacing: spacing) {
        Text("A")
        Text("B")
        Text("C")
      }
    }

    #expect(canvas.cells == [
      Position(x: 1, y: a): Cell("A"),
      Position(x: 1, y: b): Cell("B"),
      Position(x: 1, y: c): Cell("C"),
    ])
  }
}
