/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var nodes: [Node] = []
  private var currentNode: AttributeID?

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

  /// Adds a source attribute whose value can be changed later with
  /// ``setValue(of:to:)``.
  package func input<Value>(_ value: Value) -> Attribute<Value> {

    let index = nodes.count
    nodes.append(Node(value: value, update: { _ in value }))
    return Attribute(id: AttributeID(rawValue: index))
  }

  /// Changes the value of an input, invalidating every attribute computed from
  /// it.
  package func setValue<Value: Equatable>(
    of attribute: Attribute<Value>,
    to newValue: Value
  ) {

    if
      let oldValue = nodes[attribute.id.rawValue].value as? Value,
      oldValue == newValue
    {
      return
    }

    nodes[attribute.id.rawValue].value = newValue
    invalidateDependents(of: attribute.id)
  }

  /// Recursively invalidates the dependencies of the given attribute.
  private func invalidateDependents(of id: AttributeID) {
    for dependent in nodes[id.rawValue].outputs where nodes[dependent.rawValue].value != nil {
      nodes[dependent.rawValue].value = nil
      invalidateDependents(of: dependent)
    }
  }

  /// Reads the value of an attribute.
  package subscript<Value>(attribute: Attribute<Value>) -> Value {

    let index = attribute.id.rawValue

    // Whoever is updating right now depends on this attribute.
    if let dependent = currentNode {
      nodes[index].outputs.insert(dependent)
    }

    if let cached = nodes[index].value {
      return cached as! Value
    }

    let update = nodes[index].update
    let previous = currentNode
    currentNode = attribute.id
    let value = update(self)
    currentNode = previous

    nodes[index].value = value
    return value as! Value
  }
}
