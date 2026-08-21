import AttributeGraph

@propertyWrapper
public struct FocusState<Value: Hashable>: DynamicProperty {

  @State private var value: Value
  @State private var ids: [Value: FocusID] = [:]
  private let unfocusedValue: Value

  private init(_ unfocusedValue: Value) {
    self.unfocusedValue = unfocusedValue
    value = unfocusedValue
  }

  public init() where Value == Bool {
    self.init(false)
  }

  public init<T: Hashable>() where Value == T? {
    self.init(nil)
  }

  public var wrappedValue: Value {
    get { value }
    nonmutating set { value = newValue }
  }

  public var projectedValue: Binding {
    Binding(unfocusedValue: unfocusedValue, value: $value, ids: $ids)
  }
}

extension FocusState {

  public struct Binding {
    let unfocusedValue: Value
    let value: TerminalUI.Binding<Value>
    let ids: TerminalUI.Binding<[Value: FocusID]>
  }
}
