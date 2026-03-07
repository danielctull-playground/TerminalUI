@testable import TerminalUI
import Testing

@Suite("WindowChange")
struct WindowChangeTests {

  @Test func initialValue() {
    #expect(EnvironmentValues().windowSize == .zero)
  }

  @Test
  func updateEnvironment() {
    let size = Size(width: .random(in: 0...1000), height: .random(in: 0...1000))
    let change = WindowChange(size: size)
    var environment = EnvironmentValues()
    change.updateEnvironment(&environment)
    #expect(environment.windowSize == size)
  }
}
