
@dynamicMemberLookup
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

  public var projectedValue: Binding<Value> {
    self
  }

  public subscript<Subject>(
    dynamicMember keyPath: WritableKeyPath<Value, Subject>
  ) -> Binding<Subject> {
    Binding<Subject> {
      wrappedValue[keyPath: keyPath]
    } set: {
      wrappedValue[keyPath: keyPath] = $0
    }
  }
}

extension Binding {

  public static func constant(_ value: Value) -> Binding {
    Binding { value } set: { _ in }
  }
}
