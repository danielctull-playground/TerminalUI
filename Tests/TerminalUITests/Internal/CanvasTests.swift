@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Canvas Tests")
struct CanvasTests {

  @Test("Drawing with default values")
  func defaultValues() {
    let canvas = TextStreamCanvas(output: .memory)
    canvas.draw(Pixel("a"), at: Position(x: 2, y: 1))
    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
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

  @Test("translateBy(x:y:)")
  func translateBy() {
    let canvas = TestCanvas(width: 10, height: 10)
    let modified = canvas.translateBy(x: -1, y: -1)
    modified.draw(Pixel("a"), at: Position(x: 2, y: 1))
    #expect(canvas.pixels == [
      Position(x: 1, y: 0): Pixel("a")
    ])
  }

  @Test("buffered()")
  func buffered() {
    let canvas = TestCanvas(width: 10, height: 10)
    let changes = canvas.changes()
    let buffered = changes.buffered()

    let position = Position(x: 2, y: 1)
    let pixel = Pixel("a")

    buffered.draw(pixel, at: position)
    #expect(canvas.pixels == [position: pixel])
    #expect(changes.changes == [Change(position: position, pixel: pixel)])

    buffered.draw(pixel, at: position)
    #expect(canvas.pixels == [position: pixel])
    #expect(changes.changes == [Change(position: position, pixel: pixel)])
  }
}
