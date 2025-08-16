@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("Bold", .tags(.modifier))
struct BoldTests {

  @Test("Text Output", arguments: [
    (true,  "1" ),
    (false, "22"),
  ])
  func textOutput(bold: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").bold(bold)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;\(expected);23;24;25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
