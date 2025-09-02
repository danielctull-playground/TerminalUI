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

  @Test("Identifiable")
  func identifiable() {

    struct Foo: Equatable, Identifiable {
      var id: String
    }

    var value = Foo(id: "old")
    let binding = Binding { value } set: { value = $0 }
    #expect(binding.id == "old")

    value = Foo(id: "new")
    #expect(binding.id == "new")

    binding.wrappedValue = Foo(id: "newer")
    #expect(binding.id == "newer")
  }

  @Test("Collection")
  func collection() {

    var value = ["0", "1", "2"]
    let binding = Binding { value } set: { value = $0 }

    for index in binding.indices {
      binding[index].wrappedValue += "a"
    }
    #expect(value == ["0a", "1a", "2a"])

    var index = binding.startIndex
    while index < binding.endIndex {
      binding[index].wrappedValue += "b"
      binding.formIndex(after: &index)
    }
    #expect(value == ["0ab", "1ab", "2ab"])

    index = binding.startIndex
    while index < binding.endIndex {
      binding[index].wrappedValue += "c"
      index = binding.index(after: index)
    }
    #expect(value == ["0abc", "1abc", "2abc"])
  }

  @Test("BidirectionalCollection")
  func bidirectionalCollection() {

    var value = ["0", "1", "2"]
    let binding = Binding { value } set: { value = $0 }

    var index = binding.endIndex
    while index > binding.startIndex {
      binding.formIndex(before: &index)
      binding[index].wrappedValue += "a"
    }
    #expect(value == ["0a", "1a", "2a"])

    index = binding.endIndex
    while index > binding.startIndex {
      index = binding.index(before: index)
      binding[index].wrappedValue += "b"
    }
    #expect(value == ["0ab", "1ab", "2ab"])
  }

  @Test("init (to optional value)")
  func toOptional() {

    var value = "old"
    let binding = Binding { value } set: { value = $0 }
    let optional = Binding<String?>(binding)

    optional.wrappedValue = "new"
    #expect(optional.wrappedValue == "new")
    #expect(binding.wrappedValue == "new")
    #expect(value == "new")

    optional.wrappedValue = nil
    #expect(optional.wrappedValue == "new")
    #expect(binding.wrappedValue == "new")
    #expect(value == "new")
  }

  @Test("init (from optional value)")
  func fromOptional() throws {

    var value: String? = "old"
    let optional = Binding { value } set: { value = $0 }
    let binding = try #require(Binding(optional))
    #expect(binding.wrappedValue == "old")

    value = "new"
    #expect(binding.wrappedValue == "new")

    binding.wrappedValue = "newer"
    #expect(value == "newer")
  }

  @Test("init (from optional value) - fails when nil")
  func fromOptional_failure_nil() {
    var value: String?
    let optional = Binding { value } set: { value = $0 }
    #expect(Binding(optional) == nil)
  }

  @Test("init (from optional value) - fatal error on read of nil")
  func fromOptional_fatal_nil() async {
    await #expect(processExitsWith: .failure) {
      var value: String? = "old"
      let optional = Binding { value } set: { value = $0 }
      let binding = try #require(Binding(optional))
      value = nil
      _ = binding.wrappedValue
    }
  }
}
