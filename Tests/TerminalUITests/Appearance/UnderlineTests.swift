@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Underline", .tags(.modifier))
struct UnderlineTests {

  @Test func `Output: default`() {

    let screen = TextOutputScreen(output: .memory)

    screen.render(size: Size(width: 1, height: 1)) {
      Text("a").underline()
    }

    #expect(screen.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;4;25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }

  @Test(arguments: [
    (true,  "4" ),
    (false, "24"),
  ])
  func `Text Output`(underline: Bool, expected: String) {

    let screen = TextOutputScreen(output: .memory)

    screen.render(size: Size(width: 1, height: 1)) {
      Text("a").underline(underline)
    }

    #expect(screen.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;\(expected);25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }

  @Test(arguments: [
    (true,  UnderlineStyle.single, "4" ),
    (false, UnderlineStyle.single, "24"),
    (true,  UnderlineStyle.double, "21"),
    (false, UnderlineStyle.double, "24"),
  ])
  func `Text Output: style`(
    underline: Bool,
    style: UnderlineStyle,
    expected: String
  ) {

    let screen = TextOutputScreen(output: .memory)

    screen.render(size: Size(width: 1, height: 1)) {
      Text("a").underline(underline, style: style)
    }

    #expect(screen.output.controlSequences == [
      "[2J",     // Clear screen
      "[?1049h", // Alternative buffer on
      "[?25l",   // Cursor visibility off
      "[39;49;22;23;\(expected);25;27;28;29m",
      "[1;1Ha",  // Position + content
    ])
  }
}
