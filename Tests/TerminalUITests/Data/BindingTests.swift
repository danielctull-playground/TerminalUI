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

  @Test("projectedValue")
  func projectedValue() {

    var value = "old"
    let original = Binding { value } set: { value = $0 }
    let projected = original.projectedValue
    #expect(projected.wrappedValue == "old")

    projected.wrappedValue = "new"
    #expect(projected.wrappedValue == "new")
    #expect(original.wrappedValue == "new")
    #expect(value == "new")
  }

  @Test("init(projectedValue:)")
  func initProjectedValue() {

    var value = "old"
    let original = Binding { value } set: { value = $0 }
    let projected = Binding(projectedValue: original)
    #expect(projected.wrappedValue == "old")

    projected.wrappedValue = "new"
    #expect(projected.wrappedValue == "new")
    #expect(original.wrappedValue == "new")
    #expect(value == "new")
  }

  @Test("constant")
  func constant() {
    let binding = Binding.constant("old")
    #expect(binding.wrappedValue == "old")
    binding.wrappedValue = "new"
    #expect(binding.wrappedValue == "old")
  }

  @Test("@dynamicMemberLookup")
  func dynamicMemberLookup() {

    struct Foo: Equatable {
      var value: String
    }

    var foo = Foo(value: "old")
    let fooBinding = Binding { foo } set: { foo = $0 }
    let valueBinding = fooBinding.value
    #expect(valueBinding.wrappedValue == "old")

    valueBinding.wrappedValue = "new"
    #expect(valueBinding.wrappedValue == "new")
    #expect(fooBinding.wrappedValue == Foo(value: "new"))
    #expect(foo == Foo(value: "new"))
  }
}
