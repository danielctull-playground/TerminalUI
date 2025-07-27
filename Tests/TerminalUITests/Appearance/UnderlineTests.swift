@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Underline", .tags(.modifier))
struct UnderlineTests {

  @Test("Text Output", arguments: [
    (true,  "4" ),
    (false, "24"),
  ])
  func textOutput(underline: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").underline(underline)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;\(expected);25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
