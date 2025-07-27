@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Inverse", .tags(.modifier))
struct InverseTests {

  @Test("Text Output", arguments: [
    (true,  "7" ),
    (false, "27"),
  ])
  func textOutput(inverse: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").inverse(inverse)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;25;\(expected);28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
