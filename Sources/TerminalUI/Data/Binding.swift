
@propertyWrapper
public struct Binding<Value> {

  private let get: () -> Value
  private let set: (Value) -> Void

  public init(
    get: @escaping () -> Value,
    set: @escaping (Value) -> Void
  ) {
    self.get = get
    self.set = set
  }

  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }
}

extension Binding {

  public static func constant(_ value: Value) -> Binding {
    Binding { value } set: { _ in }
  }
}
