@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Inverse", .tags(.modifier))
struct InverseTests {

  private let canvas = TextStreamCanvas(output: .memory)

  @Test func on() {

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").inverse(true)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[7;22;23;24;25;28;29;39;49m",
      "[1;1Ha",  // Position + content
    ])
  }

  @Test func off() {

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").inverse(false)
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
