@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("BackgroundColor", .tags(.viewModifier))
struct BackgroundColorTests {

  @Test("Text Output", arguments: [
    (Color.`default`, "[49m"),
    (Color.black, "[40m"),
    (Color.red, "[41m"),
    (Color.green, "[42m"),
    (Color.yellow, "[43m"),
    (Color.blue, "[44m"),
    (Color.magenta, "[45m"),
    (Color.cyan, "[46m"),
    (Color.white, "[47m"),
  ])
  func textOutput(backgroundColor: Color, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: ProposedSize(width: 1, height: 1)) {
      Text("a").backgroundColor(backgroundColor)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39m",    // ForegroundColor default
      expected,  // BackgroundColor
      "[22m",    // Bold off
      "[23m",    // Italic off
      "[24m",    // Underline off
      "[25m",    // Blinking off
      "[27m",    // Inverse off
      "[28m",    // Hidden off
      "[29m",    // Strikethrough off
      "[1;1Ha",  // Position + content
    ])
  }
}
