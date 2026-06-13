/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var attributes = Arena<AttributeID, AttributeMetadata, AttributeNode>()
  private var currentAttribute: AttributeID?

  /// The subgraph that owns attributes created outside the scope of a specific
  /// subgraph.
  package let root: Subgraph

  private var subgraphs = Arena<SubgraphID, SubgraphName, SubgraphNode>()

  /// The subgraph new attributes are assigned to. Defaults to the root.
  private var currentSubgraph = SubgraphID(rawValue: 0)

  package init() {
    root = Subgraph(id: subgraphs.insert("root", SubgraphNode(parent: nil)))
  }
}

// MARK: - Subgraphs

extension Graph {

  package func subgraph(
    _ name: SubgraphName,
    _ body: () -> Void
  ) -> Subgraph {

    let parent = currentSubgraph
    let id = subgraphs.insert(name, SubgraphNode(parent: currentSubgraph))
    subgraphs[parent].children.append(id)

    currentSubgraph = id
    body()
    currentSubgraph = parent

    return Subgraph(id: id)
  }

  /// Removes the subgraph and its attributes from the graph.
  package func invalidate(_ subgraph: Subgraph) {
    if let parent = subgraphs[subgraph.id].parent {
      subgraphs[parent].children.removeAll { $0 == subgraph.id }
    }
    tearDown(subgraph.id)
  }

  private func tearDown(_ id: SubgraphID) {
    let subgraph = subgraphs[id]
    for child in subgraph.children {
      tearDown(child)
    }
    for attribute in subgraph.attributes {
      remove(attribute)
    }
    subgraphs.remove(id)
  }

  /// Whether the subgraph is part of the graph.
  package func contains(_ subgraph: Subgraph) -> Bool {
    subgraphs.contains(subgraph.id)
  }

  /// The subgraph that owns an attribute.
  package func subgraph<Value>(of attribute: Attribute<Value>) -> Subgraph {
    Subgraph(id: attributes[attribute.id].subgraph)
  }

  package func parent(of subgraph: Subgraph) -> Subgraph? {
    subgraphs[subgraph.id].parent.map(Subgraph.init)
  }

  package func children(of subgraph: Subgraph) -> [Subgraph] {
    subgraphs[subgraph.id].children.map(Subgraph.init)
  }
}

// MARK: - Attributes

extension Graph {

  func attribute<Body: AttributeBody>(
    metadata: AttributeMetadata,
    body: Body
  ) -> Attribute<Body.Value> {

    let node = AttributeNode(
      value: nil,
      update: body.update,
      subgraph: currentSubgraph
    )

    let id = attributes.insert(metadata, node)
    subgraphs[currentSubgraph].attributes.append(id)
    return Attribute(id: id)
  }

  /// Adds an attribute whose value never changes.
  ///
  /// - Parameter value: The value to insert.
  /// - Returns: The attribute handle to use for future access.
  package func constant<Value>(_ value: Value) -> Attribute<Value> {
    attribute(metadata: .constant(of: Value.self), body: Constant(value: value))
  }

  /// Adds an attribute whose value is computed from other attributes.
  package func rule<Value>(
    _ update: @escaping (Graph) -> Value
  ) -> Attribute<Value> {
    attribute(metadata: .rule(of: Value.self), body: Rule(compute: update))
  }

  /// Adds an attribute whose value is transformed from the value of the given
  /// input attribute.
  package func map<Input, Output>(
    _ input: Attribute<Input>,
    _ transform: @escaping (Input) -> Output
  ) -> Attribute<Output> {
    attribute(
      metadata: .map(of: Output.self),
      body: Map(input: input, transform: transform)
    )
  }
  /// Adds a source attribute whose value is supplied from outside the graph.
  ///
  /// This attribute is created with no value, it must be given one with
  /// ``setValue(of:to:)`` before it is read.
  package func external<Value>(
    of type: Value.Type
  ) -> Attribute<Value> {
    attribute(metadata: .external(of: type), body: External())
  }

  /// Changes the value of an input, invalidating every attribute computed from
  /// it.
  package func setValue<Value>(
    of attribute: Attribute<Value>,
    to newValue: Value
  ) {

    if
      let oldValue = attributes[attribute.id].value as? Value,
      isEqual(oldValue, newValue)
    {
      return
    }

    attributes[attribute.id].value = newValue
    markAsDirty(dependentsOf: attribute.id)
  }

  /// Recursively marks dependencies of the given attribute as dirty.
  private func markAsDirty(dependentsOf id: AttributeID) {
    for dependent in attributes[id].outputs where !attributes[dependent].isDirty {
      attributes[dependent].isDirty = true
      markAsDirty(dependentsOf: dependent)
    }
  }

  /// Reads the value of an attribute.
  package subscript<Value>(attribute: Attribute<Value>) -> Value {

    let value = evaluate(attribute.id)

    if let dependent = currentAttribute {
      attributes[attribute.id].outputs.insert(dependent)
      attributes[dependent].inputs.append(
        AttributeNode.Input(id: attribute.id, value: value)
      )
    }

    return value as! Value
  }

  /// Removes an attribute from the graph.
  ///
  /// This severs the link from its inputs to it and its outputs from it.
  private func remove(_ id: AttributeID) {
    
    let node = attributes[id]

    for input in node.inputs {
      attributes[input.id].outputs.remove(id)
    }

    for output in node.outputs {
      attributes[output].inputs.removeAll { $0.id == id }
    }

    attributes.remove(id)
  }

  private func evaluate(_ id: AttributeID) -> Any {

    if !attributes[id].isDirty, let cached = attributes[id].value {
      return cached
    }

    var anyInputChanged = attributes[id].value == nil
    for edge in attributes[id].inputs where !isEqual(evaluate(edge.id), edge.value) {
      anyInputChanged = true
    }
    attributes[id].isDirty = false

    guard anyInputChanged else {
      return attributes[id].value!
    }

    let update = attributes[id].update

    // Prune edges as we will recompute the current set of edges later.
    for input in attributes[id].inputs {
      attributes[input.id].outputs.remove(id)
    }

    attributes[id].inputs = []
    let previous = currentAttribute
    currentAttribute = id
    let value = update(self)
    currentAttribute = previous

    attributes[id].value = value
    return value
  }
}

// MARK: - Debugging

extension Graph {

  /// The number of attributes currently in the graph.
  package var attributeCount: Int {
    attributes.count
  }

  /// The total number of attribute dependency edges in the graph.
  package var edgeCount: Int {
    attributes.values.reduce(0) { $0 + $1.outputs.count }
  }

  package func metadata<Value>(
    for attribute: Attribute<Value>
  ) -> AttributeMetadata {
    attributes.name(of: attribute.id)
  }
}
