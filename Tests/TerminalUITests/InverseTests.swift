@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Inverse Tests", .tags(.viewModifier))
struct InverseTests {

  @Test("inverse = on")
  func on() {

    let text = Text("x")
      .inverse(true)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", inverse: .on),
    ])
  }

  @Test("inverse = off")
  func off() {

    let text = Text("x")
      .inverse(false)

    text.expect([
      Position(x: 1, y: 0): Pixel("x", inverse: .off),
    ])
  }
}
