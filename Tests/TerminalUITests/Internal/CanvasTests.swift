@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Canvas Tests")
struct CanvasTests {

  @Test("Drawing with default values")
  func defaultValues() {
    let stream = TestStream()
    let canvas = Canvas(stream)
    canvas.draw(Pixel("a"), at: Position(x: 2, y: 1))
    let controls = stream.output.split(separator: "\u{1b}")
    #expect(controls == [
      "[1;2H", // Position
      "[39m",  // ForegroundColor
      "[49m",  // BackgroundColor
      "[22m",  // Bold
      "[23m",  // Italic
      "[24m",  // Underline
      "[25m",  // Blinking
      "[27m",  // Inverse
      "[28m",  // Hidden
      "[29ma", // Strikethrough & content
    ])
  }
}
