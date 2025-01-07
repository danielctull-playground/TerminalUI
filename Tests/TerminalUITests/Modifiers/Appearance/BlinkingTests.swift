@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Blinking", .tags(.modifier))
struct BlinkingTests {

  @Test("Text Output", arguments: [
    (true,  "[5m" ),
    (false, "[25m"),
  ])
  func textOutput(blinking: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").blinking(blinking)
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
      expected,  // Blinking
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
