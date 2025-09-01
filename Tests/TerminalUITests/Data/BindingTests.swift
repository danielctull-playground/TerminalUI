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
}
