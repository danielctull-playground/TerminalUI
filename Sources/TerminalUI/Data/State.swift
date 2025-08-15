
@propertyWrapper
public struct State<Value> {

  @Mutable private var value: Value

  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }

  public var wrappedValue: Value {
    get { value }
    nonmutating set { value = newValue }
  }
}
