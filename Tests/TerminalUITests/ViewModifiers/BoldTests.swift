import TerminalUI
import TerminalUITesting
import Testing

@Suite("Bold", .tags(.viewModifier))
struct BoldTests {

  @Test("Text Output", arguments: [
    (true,  "[1m" ),
    (false, "[22m"),
  ])
  func textOutput(bold: Bool, expected: String) {

    let app = TestApp {
      Text("a").bold(bold)
    }

    let stream = TestStream()
    app.run(stream: stream)

    #expect(stream.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      "[49m",    // BackgroundColor default
      expected,  // Bold
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[0;1Ha",  // Position + content
    ])
  }
}
