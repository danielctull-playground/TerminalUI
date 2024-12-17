import TerminalUI
import TerminalUITesting
import Testing

@Suite("Text", .tags(.view))
struct TextTests {

  private let canvas = TestCanvas(width: 5, height: 1)

  @Test("Text displays correctly")
  func displays() {

    canvas.render {
      Text("Hello")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 0): Pixel("H"),
      Position(x: 2, y: 0): Pixel("e"),
      Position(x: 3, y: 0): Pixel("l"),
      Position(x: 4, y: 0): Pixel("l"),
      Position(x: 5, y: 0): Pixel("o"),
    ])
  }
}
