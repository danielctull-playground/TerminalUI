@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Inverse", .tags(.viewModifier))
struct InverseTests {

  @Test("Text Output", arguments: [
    (true,  "[7m" ),
    (false, "[27m"),
  ])
  func textOutput(inverse: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: ProposedSize(width: 1, height: 1)) {
      Text("a").inverse(inverse)
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
      expected,  // Inverse
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
