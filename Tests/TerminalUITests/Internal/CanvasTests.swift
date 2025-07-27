@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Canvas")
struct CanvasTests {

  @Test("Drawing with default values")
  func defaultValues() {
    let canvas = TextStreamCanvas(output: .memory)
    canvas.draw(Pixel("a"), at: Position(x: 2, y: 1))
    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[22;23;24;25;27;28;29;39;49m",
      "[1;2Ha", // Position + content
    ])
  }

  @Test("Center alignment")
  func center() {
    let canvas = TestCanvas(width: 3, height: 3)
    canvas.render {
      Text("A")
    }
    #expect(canvas.pixels == [
      Position(x: 2, y: 2): Pixel("A")
    ])
  }
}
