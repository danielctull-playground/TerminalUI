@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Hidden", .tags(.viewModifier))
struct HiddenTests {

  @Test("Text Output", arguments: [
    (true,  "[8m" ),
    (false, "[28m"),
  ])
  func textOutput(hidden: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: ProposedSize(width: 1, height: 1)) {
      Text("a").hidden(hidden)
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
      expected,  // Hidden
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
