import AttributeGraph

@propertyWrapper
public struct State<Value> {

  let initialValue: Value

  @Mutable private var location: StoredLocation<Value>!

  public init(wrappedValue: Value) {
    initialValue = wrappedValue
  }

  public var wrappedValue: Value {
    get { location.value }
    nonmutating set { location.value = newValue }
  }

  public var projectedValue: Binding<Value> {
    Binding(get: { location.value }, set: { location.value = $0 })
  }
}

extension State: DynamicProperty {

  func install(
    _ buffer: DynamicPropertyBuffer,
    field: Field,
    inputs: ViewInputs
  ) {
    location = buffer.location(
      for: field,
      initialValue: initialValue
    )
  }
}
