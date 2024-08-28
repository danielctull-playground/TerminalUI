@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Italic Tests", .tags(.viewModifier))
struct ItalicTests {

  @Test("italic = on")
  func on() {

    let text = Text("x")
      .italic(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", italic: .on),
    ])
  }

  @Test("italic = off")
  func off() {

    let text = Text("x")
      .italic(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", italic: .off),
    ])
  }
}
