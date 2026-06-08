/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var nodes: [AttributeID: Node] = [:]
  private var id = AttributeID(rawValue: 0)
  private var currentNode: AttributeID?

  package init() {}
}

// MARK: - Attributes

extension Graph {

  func attribute<Body: AttributeBody>(_ body: Body) -> Attribute<Body.Value> {
    defer { id = AttributeID(rawValue: id.rawValue + 1) }
    nodes[id] = Node(value: nil, update: body.update)
    return Attribute(id: id)
  }

  /// Adds an attribute whose value never changes.
  ///
  /// - Parameter value: The value to insert.
  /// - Returns: The attribute handle to use for future access.
  package func constant<Value>(_ value: Value) -> Attribute<Value> {
    attribute(Constant(value: value))
  }

  /// Adds an attribute whose value is computed from other attributes.
  package func rule<Value>(
    _ update: @escaping (Graph) -> Value
  ) -> Attribute<Value> {
    attribute(Rule(compute: update))
  }

  /// Adds an attribute whose value is transformed from the value of the given
  /// input attribute.
  package func map<Input, Output>(
    _ input: Attribute<Input>,
    _ transform: @escaping (Input) -> Output
  ) -> Attribute<Output> {
    attribute(Map(input: input, transform: transform))
  }
  /// Adds a source attribute whose value is supplied from outside the graph.
  ///
  /// This attribute is created with no value, it must be given one with
  /// ``setValue(of:to:)`` before it is read.
  package func external<Value>(of type: Value.Type) -> Attribute<Value> {
    attribute(External())
  }

  /// Changes the value of an input, invalidating every attribute computed from
  /// it.
  package func setValue<Value>(
    of attribute: Attribute<Value>,
    to newValue: Value
  ) {

    if
      let oldValue = nodes[attribute.id]!.value as? Value,
      isEqual(oldValue, newValue)
    {
      return
    }

    nodes[attribute.id]!.value = newValue
    markAsDirty(dependentsOf: attribute.id)
  }

  /// Recursively marks dependencies of the given attribute as dirty.
  private func markAsDirty(dependentsOf id: AttributeID) {
    for dependent in nodes[id]!.outputs where !nodes[dependent]!.isDirty {
      nodes[dependent]!.isDirty = true
      markAsDirty(dependentsOf: dependent)
    }
  }

  /// Reads the value of an attribute.
  package subscript<Value>(attribute: Attribute<Value>) -> Value {

    let value = evaluate(attribute.id)

    if let dependent = currentNode {
      nodes[attribute.id]!.outputs.insert(dependent)
      nodes[dependent]!.inputs.append(Input(id: attribute.id, value: value))
    }

    return value as! Value
  }

  private func evaluate(_ id: AttributeID) -> Any {

    if !nodes[id]!.isDirty, let cached = nodes[id]!.value {
      return cached
    }

    var anyInputChanged = nodes[id]!.value == nil
    for edge in nodes[id]!.inputs where !isEqual(evaluate(edge.id), edge.value) {
      anyInputChanged = true
    }
    nodes[id]!.isDirty = false

    guard anyInputChanged else {
      return nodes[id]!.value!
    }

    let update = nodes[id]!.update
    nodes[id]!.inputs = []
    let previous = currentNode
    currentNode = id
    let value = update(self)
    currentNode = previous

    nodes[id]!.value = value
    return value
  }
}
