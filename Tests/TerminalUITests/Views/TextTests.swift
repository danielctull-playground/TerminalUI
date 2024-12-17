@testable import TerminalUI
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
    let proposed = Size(width: proposedWidth, height: proposedHeight)
    let size = Text(input)
      .size(proposedSize: proposed, environment: EnvironmentValues())
    let expected = Size(width: expectedWidth, height: expectedHeight)
    #expect(size == expected)
  }

  @Test(arguments: Array<(String, Horizontal, Vertical, String)>([
    ("12345", 5, 1, "12345"),
    ("12345", 3, 2, "123\n45 "),
    ("12345", 3, 1, "123"),
    ("123456", 3, 3, "123\n456\n   "),
    ("This is a string", 6, 3, "This  \nis a  \nstring"),
  ]))
  func render(
    input: String,
    width: Horizontal,
    height: Vertical,
    expected: String
  ) {

    let canvas = TestCanvas(width: width, height: height)

    canvas.render {
      Text(input)
    }

    #expect(canvas.description == expected)
  }
}
