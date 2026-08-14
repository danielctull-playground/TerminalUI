@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Hidden", .tags(.modifier))
struct HiddenTests {

  @Test(arguments: [
    (true,  "."),
    (false, "a"),
  ])
  func `Text Output`(hidden: Bool, expected: String) {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      Text("a").hidden(hidden)
    }

    #expect(screen.buffer.description == expected)
  }
}
