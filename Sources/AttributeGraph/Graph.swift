/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var nodes: [Node] = []

  package init() {}
}

// MARK: - Attributes

extension Graph {

  /// Adds an attribute whose value never changes.
  ///
  /// - Parameter value: The value to insert.
  /// - Returns: The attribute handle to use for future access.
  package func constant<Value>(_ value: Value) -> Attribute<Value> {
    rule { _ in value }
  }

  /// Adds an attribute whose value is computed from other attributes.
  package func rule<Value>(
    _ update: @escaping (Graph) -> Value
  ) -> Attribute<Value> {
    let id = nodes.count
    nodes.append(Node(value: nil, update: update))
    return Attribute(id: AttributeID(rawValue: id))
  }

  /// Reads the value of an attribute.
  package subscript<Value>(attribute: Attribute<Value>) -> Value {

    let index = attribute.id.rawValue

    if let cached = nodes[index].value {
      return cached as! Value
    }

    let update = nodes[index].update
    let computed = update(self)
    nodes[index].value = computed
    return computed as! Value
  }
}
