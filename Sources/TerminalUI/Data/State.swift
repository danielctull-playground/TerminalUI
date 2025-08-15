
@propertyWrapper
public struct State<Value> {

  private let value: Value

  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }

  public var wrappedValue: Value { value }
}
