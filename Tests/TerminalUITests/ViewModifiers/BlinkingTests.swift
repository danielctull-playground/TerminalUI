import TerminalUI
import TerminalUITesting
import Testing

@Suite("Blinking", .tags(.viewModifier))
struct BlinkingTests {

  @Test("Text Output", arguments: [
    (true,  "[5m" ),
    (false, "[25m"),
  ])
  func textOutput(blinking: Bool, expected: String) {

    let app = TestApp {
      Text("a").blinking(blinking)
    }

    let stream = TestStream()
    app.run(stream: stream)

    #expect(stream.controlSequences == [
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
