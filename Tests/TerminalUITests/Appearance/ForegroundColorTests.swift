@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ForegroundColor", .tags(.modifier))
struct ForegroundColorTests {

  @Test("Text Output", arguments: [
    (Color.`default`, "[39m"),
    (Color.black, "[30m"),
    (Color.red, "[31m"),
    (Color.green, "[32m"),
    (Color.yellow, "[33m"),
    (Color.blue, "[34m"),
    (Color.magenta, "[35m"),
    (Color.cyan, "[36m"),
    (Color.white, "[37m"),

    (Color(red: 0, green: 0, blue: 0), "[38;2;0;0;0m"),
    (Color(red: 1, green: 1, blue: 1), "[38;2;255;255;255m"),
    (Color(red: 1.0, green: 0.5, blue: 0), "[38;2;255;127;0m"),
    (Color(red: 0.8, green: 0.9, blue: 0.4), "[38;2;204;229;102m"),
    (Color(red: 0.2, green: 0.3, blue: 0.7), "[38;2;51;76;178m"),
    (Color(red: -21, green: -0.1, blue: -2), "[38;2;0;0;0m"), // Clamped
    (Color(red: 10, green: 1.1, blue: 2.1), "[38;2;255;255;255m"), // Clamped
  ])
  func textOutput(foregroundColor: Color, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").foregroundColor(foregroundColor)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      expected,  // ForegroundColor
      "[49m",    // BackgroundColor default
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
