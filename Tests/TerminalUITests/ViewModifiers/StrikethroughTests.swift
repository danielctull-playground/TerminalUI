@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Strikethrough", .tags(.viewModifier))
struct StrikethroughTests {

  @Test("Text Output", arguments: [
    (true,  "[9m" ),
    (false, "[29m"),
  ])
  func textOutput(strikethrough: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: ProposedSize(width: 1, height: 1)) {
      Text("a").strikethrough(strikethrough)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      "[22m",    // Bold off
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      expected,  // Strikethrough
      "[1;1Ha",  // Position + content
    ])
  }
}
