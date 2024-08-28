@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Underline Tests", .tags(.viewModifier))
struct UnderlineTests {

  @Test("underline = on")
  func on() {

    let text = Text("x")
      .underline(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", underline: .on),
    ])
  }

  @Test("underline = off")
  func off() {

    let text = Text("x")
      .underline(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", underline: .off),
    ])
  }
}
