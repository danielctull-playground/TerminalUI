@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Blinking", .tags(.modifier))
struct BlinkingTests {

  @Test(arguments: [
    (true,  "5" ),
    (false, "25"),
  ])
  func `Text Output`(blinking: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").blinking(blinking)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;\(expected);27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
