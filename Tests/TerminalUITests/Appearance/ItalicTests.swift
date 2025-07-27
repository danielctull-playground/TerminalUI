@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Italic", .tags(.modifier))
struct ItalicTests {

  @Test("Text Output", arguments: [
    (true,  "3" ),
    (false, "23"),
  ])
  func textOutput(italic: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").italic(italic)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;\(expected);24;25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
