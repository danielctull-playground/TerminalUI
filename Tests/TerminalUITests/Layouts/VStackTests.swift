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

    #expect(canvas.pixels == [:])
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

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
      Position(x: 1, y: 2): Pixel("2"),
      Position(x: 1, y: 3): Pixel("3"),
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

    #expect(canvas.pixels == [
      Position(x: 1,  y: 1): Pixel(" ", background: .blue),
      Position(x: 1,  y: 2): Pixel(" ", background: .blue),
      Position(x: 1,  y: 3): Pixel("A"),
      Position(x: 1,  y: 4): Pixel(" ", background: .yellow),
      Position(x: 1,  y: 5): Pixel(" ", background: .yellow),
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

    #expect(canvas.pixels == [
      Position(x: 1, y:  1): Pixel(" ", background: .blue),
      Position(x: 1, y:  2): Pixel(" ", background: .blue),
      Position(x: 1, y:  3): Pixel(" ", background: .blue),
      Position(x: 1, y:  4): Pixel("A"),
      Position(x: 1, y:  5): Pixel(" ", background: .yellow),
      Position(x: 1, y:  6): Pixel(" ", background: .yellow),
      Position(x: 1, y:  7): Pixel(" ", background: .yellow),
      Position(x: 1, y:  8): Pixel("B"),
      Position(x: 1, y:  9): Pixel(" ", background: .red),
      Position(x: 1, y: 10): Pixel(" ", background: .red),
      Position(x: 1, y: 11): Pixel(" ", background: .red),
    ])
  }

  @Test("alignment", arguments: Array<(HorizontalAlignment, Int)>([
    (.leading,  1),
    (.center,   2),
    (.trailing, 3),
  ]))
  func alignment(alignment: HorizontalAlignment, x: Int) {

    let canvas = TestCanvas(width: 3, height: 5)

    canvas.render {
      VStack(alignment: alignment) {
        Text("A")
        Color.black.frame(height: 1) // Ensures full width is used for HStack.
        Text("B")
      }
    }

    #expect(canvas.pixels == [
      Position(x:  x, y: 2): Pixel("A"),
      Position(x:  x, y: 4): Pixel("B"),
      Position(x:  1, y: 3): Pixel(" ", background: .black),
      Position(x:  2, y: 3): Pixel(" ", background: .black),
      Position(x:  3, y: 3): Pixel(" ", background: .black),
    ])
  }

  @Test("spacing", arguments: Array<(Int, Int, Int, Int)>([
    (0, 4, 5, 6),
    (1, 3, 5, 7),
    (2, 2, 5, 8),
    (3, 1, 5, 9),
  ]))
  func spacing(spacing: Int, a: Int, b: Int, c: Int) {

    let canvas = TestCanvas(width: 1, height: 9)

    canvas.render {
      VStack(spacing: spacing) {
        Text("A")
        Text("B")
        Text("C")
      }
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: a): Pixel("A"),
      Position(x: 1, y: b): Pixel("B"),
      Position(x: 1, y: c): Pixel("C"),
    ])
  }
}
