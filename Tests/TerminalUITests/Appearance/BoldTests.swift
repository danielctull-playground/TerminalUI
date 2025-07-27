@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Bold", .tags(.modifier))
struct BoldTests {

  private let canvas = TextStreamCanvas(output: .memory)

  @Test func on() {

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").bold(true)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[1;23;24;25;27;28;29;39;49m",
      "[1;1Ha",  // Position + content
    ])
  }

  @Test func off() {

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").bold(false)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[22;23;24;25;27;28;29;39;49m",
      "[1;1Ha",  // Position + content
    ])
  }
}
