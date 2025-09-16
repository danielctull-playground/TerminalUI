import Foundation
import TerminalUI
import TerminalUITesting
import Testing

@Suite("Mutable")
struct MutableTests {

  struct Foo {
    @Mutable var value: String
  }

  @Test func `Initial value`() {
    let a = UUID().uuidString
    let foo = Foo(value: a)
    #expect(foo.value == a)
  }

  @Test func `Change value`() {
    let a = UUID().uuidString
    let foo = Foo(value: a)
    #expect(foo.value == a)

    let b = UUID().uuidString
    foo.value = b
    #expect(foo.value == b)
  }
}
