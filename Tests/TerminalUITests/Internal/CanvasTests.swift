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
      "[39m",  // ForegroundColor default
      "[49m",  // BackgroundColor default
      "[22m",  // Bold off
      "[23m",  // Italic off
      "[24m",  // Underline off
      "[25m",  // Blinking off
      "[27m",  // Inverse off
      "[28m",  // Hidden off
      "[29m", // Strikethrough off
      "[1;2Ha", // Position + content
    ])
  }
}
