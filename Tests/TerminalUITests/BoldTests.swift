@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Bold Tests", .tags(.viewModifier))
struct BoldTests {

  @Test("bold = on")
  func on() {

    let text = Text("x")
      .bold(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", bold: .on),
    ])
  }

  @Test("bold = off")
  func off() {

    let text = Text("x")
      .bold(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", bold : .off),
    ])
  }
}
