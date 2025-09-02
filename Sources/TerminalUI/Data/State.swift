import AttributeGraph

@propertyWrapper
public struct State<Value> {

  let initialValue: Value

  @Mutable private var get: () -> Value = {
    fatalError("State value not set.")
  }

  @Mutable private var set: (Value) -> Void = {
    _ in fatalError("State value not set.")
  }

  public init(wrappedValue: Value) {
    initialValue = wrappedValue
  }

  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }

  public var projectedValue: Binding<Value> {
    Binding(get: get, set: set)
  }
}

extension State: DynamicProperty {

  func install(_ properties: DynamicProperties, for label: String) {
    get = { properties.state.values[label] as? Value ?? initialValue }
    set = { newValue in properties.state.values[label] = newValue }
  }
}

struct StateValues {
  fileprivate var values: [String: Any] = [:]
}
