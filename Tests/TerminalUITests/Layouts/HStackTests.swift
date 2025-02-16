import TerminalUI
import TerminalUITesting
import Testing

@Suite("HStack", .tags(.view, .layout))
struct HStackTests {

  @Test("empty")
  func empty() {

    let canvas = TestCanvas(width: 3, height: 3)

    canvas.render {
      HStack { [] }
    }

    #expect(canvas.pixels == [:])
  }

  @Test("single line")
  func singleLine() {

    let canvas = TestCanvas(width: 3, height: 1)

    canvas.render {
      HStack {[
        Text("1"),
        Text("2"),
        Text("3"),
      ]}
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
      Position(x: 2, y: 1): Pixel("2"),
      Position(x: 3, y: 1): Pixel("3"),
    ])
  }

  @Test("single line 2")
  func singleLine2() {

    let canvas = TestCanvas(width: 5, height: 1)

    canvas.render {
      HStack {[
        Color.blue,
        Text("A"),
        Color.yellow,
      ]}
    }

    #expect(canvas.pixels == [
      Position(x: 1,  y: 1): Pixel(" ", background: .blue),
      Position(x: 2,  y: 1): Pixel(" ", background: .blue),
      Position(x: 3,  y: 1): Pixel("A"),
      Position(x: 4,  y: 1): Pixel(" ", background: .yellow),
      Position(x: 5,  y: 1): Pixel(" ", background: .yellow),
    ])
  }

  @Test("single line 3")
  func singleLine3() {

    let canvas = TestCanvas(width: 11, height: 1)

    canvas.render {
      HStack {[
        Color.blue,
        Text("A"),
        Color.yellow,
        Text("B"),
        Color.red,
      ]}
    }

    #expect(canvas.pixels == [
      Position(x:  1, y: 1): Pixel(" ", background: .blue),
      Position(x:  2, y: 1): Pixel(" ", background: .blue),
      Position(x:  3, y: 1): Pixel(" ", background: .blue),
      Position(x:  4, y: 1): Pixel("A"),
      Position(x:  5, y: 1): Pixel(" ", background: .yellow),
      Position(x:  6, y: 1): Pixel(" ", background: .yellow),
      Position(x:  7, y: 1): Pixel(" ", background: .yellow),
      Position(x:  8, y: 1): Pixel("B"),
      Position(x:  9, y: 1): Pixel(" ", background: .red),
      Position(x: 10, y: 1): Pixel(" ", background: .red),
      Position(x: 11, y: 1): Pixel(" ", background: .red),
    ])
  }

  @Test("alignment", arguments: Array<(VerticalAlignment, Int)>([
    (.top,    1),
    (.center, 2),
    (.bottom, 3),
  ]))
  func alignment(alignment: VerticalAlignment, y: Int) {

    let canvas = TestCanvas(width: 5, height: 3)

    canvas.render {
      HStack(alignment: alignment) {[
        Text("A"),
        Color.black.frame(width: 1), // Ensures full height is used for HStack.
        Text("B"),
      ]}
    }

    #expect(canvas.pixels == [
      Position(x:  2, y: y): Pixel("A"),
      Position(x:  4, y: y): Pixel("B"),
      Position(x:  3, y: 1): Pixel(" ", background: .black),
      Position(x:  3, y: 2): Pixel(" ", background: .black),
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

    let canvas = TestCanvas(width: 9, height: 1)

    canvas.render {
      HStack(spacing: spacing) {[
        Text("A"),
        Text("B"),
        Text("C"),
      ]}
    }

    #expect(canvas.pixels == [
      Position(x: a, y: 1): Pixel("A"),
      Position(x: b, y: 1): Pixel("B"),
      Position(x: c, y: 1): Pixel("C"),
    ])
  }
}
