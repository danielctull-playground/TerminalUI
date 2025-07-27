@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("BackgroundColor", .tags(.modifier))
struct BackgroundColorTests {

  @Test("Text Output", arguments: [
    (Color.`default`, "49"),
    (Color.black, "40"),
    (Color.red, "41"),
    (Color.green, "42"),
    (Color.yellow, "43"),
    (Color.blue, "44"),
    (Color.magenta, "45"),
    (Color.cyan, "46"),
    (Color.white, "47"),
  ])
  func textOutput(backgroundColor: Color, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").backgroundColor(backgroundColor)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[22;23;24;25;27;28;29;39;\(expected)m",
      "[1;1Ha",  // Position + content
    ])
  }
}
