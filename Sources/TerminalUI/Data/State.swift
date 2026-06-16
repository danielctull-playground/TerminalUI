import AttributeGraph

@propertyWrapper
public struct State<Value> {

  let initialValue: Value

  @Mutable fileprivate var get: () -> Value = {
    fatalError("State value not set.")
  }

  @Mutable fileprivate var set: (Value) -> Void = {
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

  func makeProperty(
    in buffer: inout DynamicPropertyBuffer,
    field: DynamicPropertyBuffer.Field,
    graph: Graph,
    properties: DynamicProperties
  ) {
    let attribute = graph.external(of: Value.self)
    graph.setValue(of: attribute, to: initialValue)
    buffer.append(StateBox<Value>(attribute: attribute), field: field)
  }
}

private struct StateBox<Value>: DynamicPropertyBox {

  let attribute: Attribute<Value>

  func update(property: Any, graph: Graph, properties: DynamicProperties) {
    guard let state = property as? State<Value> else { fatalError() }
    state.set = { [unowned graph] newValue in
      graph.setValue(of: attribute, to: newValue)
    }
    state.get = { [unowned graph] in
      graph[attribute]
    }
  }
}
