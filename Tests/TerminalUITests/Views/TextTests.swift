@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Text", .tags(.view))
struct TextTests {

  @Test("Text displays correctly")
  func displays() {

    let canvas = TestCanvas()

    Text("Hello")._render(in: canvas)

    #expect(canvas.pixels == [
      Position(x: 1, y: 0): Pixel("H"),
      Position(x: 2, y: 0): Pixel("e"),
      Position(x: 3, y: 0): Pixel("l"),
      Position(x: 4, y: 0): Pixel("l"),
      Position(x: 5, y: 0): Pixel("o"),
    ])
  }
}
