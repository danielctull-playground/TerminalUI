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
      Position(x: 1, y: 2): Pixel("H"),
      Position(x: 2, y: 2): Pixel("e"),
      Position(x: 3, y: 2): Pixel("l"),
      Position(x: 4, y: 2): Pixel("l"),
      Position(x: 5, y: 2): Pixel("o"),
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

  @Test(arguments: Array<(String, Horizontal, Vertical, Horizontal, Vertical)>([
    ("12345", 5, 1, 5, 1),
    ("12345", 3, 2, 3, 2),
    ("123 456 789", 5, 4, 3, 3),
    ("123456789", 5, 5, 5, 2),
    ("123456", 5, 5, 5, 2),
  ]))
  func size(
    input: String,
    proposedWidth: Horizontal,
    proposedHeight: Vertical,
    expectedWidth: Horizontal,
    expectedHeight: Vertical
  ) {
    let proposed = ProposedSize(width: proposedWidth, height: proposedHeight)
    let size = Text(input)._size(for: proposed)
    #expect(size?.width == expectedWidth)
    #expect(size?.height == expectedHeight)
  }
}
