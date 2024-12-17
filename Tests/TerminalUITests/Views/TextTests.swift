import TerminalUI
import TerminalUITesting
import Testing

@Suite("Text", .tags(.view))
struct TextTests {

  private let canvas = TestCanvas(width: 5, height: 3)

  @Test("single line")
  func singleLine() {

    canvas.render {
      Text("Hello")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("H"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("l"),
      Position(x: 4, y: 1): Pixel("l"),
      Position(x: 5, y: 1): Pixel("o"),
    ])
  }

  @Test("two lines")
  func twoLines() {

    canvas.render {
      Text("Hi there")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("H"),
      Position(x: 2, y: 1): Pixel("i"),
      Position(x: 1, y: 2): Pixel("t"),
      Position(x: 2, y: 2): Pixel("h"),
      Position(x: 3, y: 2): Pixel("e"),
      Position(x: 4, y: 2): Pixel("r"),
      Position(x: 5, y: 2): Pixel("e"),
    ])
  }

  @Test("two lines (space is just after end)")
  func twoLines_spaceIsJustAfterEnd() {

    canvas.render {
      Text("Hello there")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("H"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("l"),
      Position(x: 4, y: 1): Pixel("l"),
      Position(x: 5, y: 1): Pixel("o"),
      Position(x: 1, y: 2): Pixel("t"),
      Position(x: 2, y: 2): Pixel("h"),
      Position(x: 3, y: 2): Pixel("e"),
      Position(x: 4, y: 2): Pixel("r"),
      Position(x: 5, y: 2): Pixel("e"),
    ])
  }
}
