import Foundation
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Mutable")
struct MutableTests {

  struct Foo {
    @Mutable var value: String
  }

  @Test("Initial value")
  func initialValue() {
    let a = UUID().uuidString
    let foo = Foo(value: a)
    #expect(foo.value == a)
  }

  @Test("Change value")
  func changeValue() {
    let a = UUID().uuidString
    let foo = Foo(value: a)
    #expect(foo.value == a)

    let b = UUID().uuidString
    foo.value = b
    #expect(foo.value == b)
  }
}
