@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("Hidden", .tags(.modifier))
struct HiddenTests {

  @Test("Text Output", arguments: [
    (true,  "8" ),
    (false, "28"),
  ])
  func textOutput(hidden: Bool, expected: String) {

    let canvas = TextStreamCanvas(output: .memory)

    canvas.render(size: Size(width: 1, height: 1)) {
      Text("a").hidden(hidden)
    }

    #expect(canvas.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;25;27;\(expected);29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
