import AttributeGraph

@propertyWrapper
public struct State<Value> {

  let initial: Value
  private var value: Input<Value>?

  public init(wrappedValue: Value) {
    initial = wrappedValue
  }

  public var wrappedValue: Value {
    get {
      guard let value else { fatalError("State value not set.") }
      return value.wrappedValue
    }
    nonmutating set {
      guard let value else { fatalError("State value not set.") }
      value.wrappedValue = newValue
    }
  }
}

extension State: DynamicProperty {

  func install(_ properties: DynamicProperties) {

  }
}

struct StateValues {

  private var values: [ObjectIdentifier: Any] = [:]

  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue }
    set { values[ObjectIdentifier(key)] = newValue }
  }
}
