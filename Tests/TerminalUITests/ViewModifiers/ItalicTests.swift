@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Italic", .tags(.viewModifier))
struct ItalicTests {

  @Test("on")
  func on() {

    let text = Text("x")
      .italic(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", italic: .on),
    ])
  }

  @Test("off")
  func off() {

    let text = Text("x")
      .italic(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", italic: .off),
    ])
  }
}
