@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Underline", .tags(.modifier))
struct UnderlineTests {

  @Test("Text Output", arguments: [
    (true,  "[4m" ),
    (false, "[24m"),
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
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[22m",    // Bold off
      "[23m",    // Italic off
      expected,  // Underline
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
