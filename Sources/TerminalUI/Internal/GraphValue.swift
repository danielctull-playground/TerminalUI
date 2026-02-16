import AttributeGraph

/// Typed reference to a graph node.
@dynamicMemberLookup
public struct GraphValue<Value> {
  @Attribute var value: Value

  subscript<Property>(
    dynamicMember keyPath: KeyPath<Value, Property>
  ) -> GraphValue<Property> {
    map { $0[keyPath: keyPath] }
  }
}

extension GraphValue {

  func map<New>(
    _ transform: @escaping (Value) -> New
  ) -> GraphValue<New> {
    GraphValue<New>(value: $value.map(transform))
  }
}
