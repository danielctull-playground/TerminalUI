import TerminalUI
import Testing

@Suite("Binding")
struct BindingTests {

  @Test("wrappedValue")
  func wrappedValue() {

    var value = "old"
    let binding = Binding { value } set: { value = $0 }
    #expect(binding.wrappedValue == "old")

    value = "new"
    #expect(binding.wrappedValue == "new")

    binding.wrappedValue = "newer"
    #expect(binding.wrappedValue == "newer")
    #expect(value == "newer")
  }

  @Test("@propertyWrapper")
  func propertyWrapper() {

    struct Foo {
      @Binding var value: String
    }

    var value = "old"
    let binding = Binding { value } set: { value = $0 }
    let foo = Foo(value: binding)
    #expect(foo.value == "old")

    value = "new"
    #expect(foo.value == "new")

    binding.wrappedValue = "newer"
    #expect(foo.value == "newer")
  }

  @Test("constant")
  func constant() {
    let binding = Binding.constant("old")
    #expect(binding.wrappedValue == "old")
    binding.wrappedValue = "new"
    #expect(binding.wrappedValue == "old")
  }
}
