@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Strikethrough", .tags(.modifier))
struct StrikethroughTests {

  @Test(arguments: [
    (true,  "9" ),
    (false, "29"),
  ])
  func `Text Output`(strikethrough: Bool, expected: String) {

    let screen = TextOutputScreen(output: .memory)

    screen.render(size: Size(width: 1, height: 1)) {
      Text("a").strikethrough(strikethrough)
    }

    #expect(screen.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;24;25;27;28;\(expected)m",
      "[1;1Ha",  // Position + content
    ])
  }
}
