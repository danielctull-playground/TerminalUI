@testable import TerminalUI
import Testing

@Suite("WindowChange")
struct WindowChangeTests {

  @Test func initialValue() {
    #expect(EnvironmentValues().windowSize == .zero)
  }

  @Test func equatable() {
    let a = Int.random
    let b = Int.random
    let c = Int.random
    #expect(WindowChange(size: Size(width: a, height: b)) == WindowChange(size: Size(width: a, height: b)))
    #expect(WindowChange(size: Size(width: a, height: b)) != WindowChange(size: Size(width: a, height: c)))
    #expect(WindowChange(size: Size(width: a, height: b)) != WindowChange(size: Size(width: c, height: b)))
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
