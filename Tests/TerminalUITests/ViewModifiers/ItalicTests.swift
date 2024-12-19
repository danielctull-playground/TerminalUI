@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Italic", .tags(.viewModifier))
struct ItalicTests {

  @Test("Text Output", arguments: [
    (true,  "[3m" ),
    (false, "[23m"),
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
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[22m",    // Bold off
      expected,  // Italic
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
