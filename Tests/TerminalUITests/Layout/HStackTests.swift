import TerminalUI
import TerminalUITesting
import Testing

@Suite("HStack", .tags(.view))
struct HStackTests {

  @Test("empty")
  func empty() {

    let canvas = TestCanvas(width: 3, height: 3)

    canvas.render {
      HStack(content: [])
    }

    #expect(canvas.pixels == [:])
  }

  @Test("single line")
  func singleLine() {

    let canvas = TestCanvas(width: 3, height: 1)

    canvas.render {
      HStack(content: [
        Text("1"),
        Text("2"),
        Text("3"),
      ])
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
      Position(x: 2, y: 1): Pixel("2"),
      Position(x: 3, y: 1): Pixel("3"),
    ])
  }

  @Test("single line")
  func singleLine2() {

    let canvas = TestCanvas(width: 5, height: 1)

    canvas.render {
      HStack(content: [
        Color.blue,
        Text("A"),
        Color.yellow,
      ])
    }

    #expect(canvas.pixels == [
      Position(x: 1,  y: 1): Pixel(" ", background: .blue),
      Position(x: 2,  y: 1): Pixel(" ", background: .blue),
      Position(x: 3,  y: 1): Pixel("A"),
      Position(x: 4,  y: 1): Pixel(" ", background: .yellow),
      Position(x: 5,  y: 1): Pixel(" ", background: .yellow),
    ])
  }

  @Test("single line")
  func singleLine3() {

    let canvas = TestCanvas(width: 11, height: 1)

    canvas.render {
      HStack(content: [
        Color.blue,
        Text("A"),
        Color.yellow,
        Text("B"),
        Color.red,
      ])
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
}
