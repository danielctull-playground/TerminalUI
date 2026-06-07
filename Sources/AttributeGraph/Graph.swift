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
    let id = nodes.count
    nodes.append(Node(value: value))
    return Attribute(id: AttributeID(rawValue: id))
  }

  /// Reads the value of an attribute.
  package subscript<Value>(attribute: Attribute<Value>) -> Value {
    nodes[attribute.id.rawValue].value as! Value
  }
}
