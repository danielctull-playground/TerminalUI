/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var nodes: [AttributeID: AttributeNode] = [:]
  private var id = AttributeID(rawValue: 0)
  private var currentNode: AttributeID?

  /// The subgraph that owns attributes created outside the scope of a specific
  /// subgraph.
  package let root = Subgraph(id: SubgraphID(rawValue: 0))

  /// The subgraph new attributes are assigned to. Defaults to the root.
  private var currentSubgraph = SubgraphID(rawValue: 0)

  /// The number to give the next subgraph created.
  private var nextSubgraphID = SubgraphID(rawValue: 1)

  private var subgraphs: [SubgraphID: SubgraphNode]

  package init() {
    subgraphs = [root.id : SubgraphNode(parent: nil)]
  }
}

// MARK: - Subgraphs

extension Graph {

  package func subgraph(_ body: () -> Void) -> Subgraph {

    let id = nextSubgraphID
    nextSubgraphID = SubgraphID(rawValue: id.rawValue + 1)

    let parent = currentSubgraph
    subgraphs[id] = SubgraphNode(parent: parent)
    subgraphs[parent]!.children.append(id)

    currentSubgraph = id
    body()
    currentSubgraph = parent

    return Subgraph(id: id)
  }

  /// Removes the subgraph and its attributes from the graph.
  package func invalidate(_ subgraph: Subgraph) {
    if let parent = subgraphs[subgraph.id]!.parent {
      subgraphs[parent]!.children.removeAll { $0 == subgraph.id }
    }
    tearDown(subgraph.id)
  }

  private func tearDown(_ id: SubgraphID) {
    let subgraph = subgraphs[id]!
    for child in subgraph.children {
      tearDown(child)
    }
    for attribute in subgraph.attributes {
      remove(attribute)
    }
    subgraphs[id] = nil
  }

  /// Whether the subgraph is part of the graph.
  package func contains(_ subgraph: Subgraph) -> Bool {
    subgraphs[subgraph.id] != nil
  }

  /// The subgraph that owns an attribute.
  package func subgraph<Value>(of attribute: Attribute<Value>) -> Subgraph {
    Subgraph(id: nodes[attribute.id]!.subgraph)
  }

  package func parent(of subgraph: Subgraph) -> Subgraph? {
    subgraphs[subgraph.id]!.parent.map(Subgraph.init)
  }

  package func children(of subgraph: Subgraph) -> [Subgraph] {
    subgraphs[subgraph.id]!.children.map(Subgraph.init)
  }
}

// MARK: - Attributes

extension Graph {

  func attribute<Body: AttributeBody>(_ body: Body) -> Attribute<Body.Value> {
    defer { id = AttributeID(rawValue: id.rawValue + 1) }
    nodes[id] = AttributeNode(value: nil, update: body.update, subgraph: currentSubgraph)
    subgraphs[currentSubgraph]!.attributes.append(id)
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

  /// Removes an attribute from the graph.
  ///
  /// This severs the link from its inputs to it and its outputs from it.
  private func remove(_ id: AttributeID) {

    guard let node = nodes[id] else { return }

    for input in node.inputs {
      nodes[input.id]?.outputs.remove(id)
    }

    for output in node.outputs {
      nodes[output]?.inputs.removeAll { $0.id == id }
    }

    nodes[id] = nil
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

    // Prune edges as we will recompute the current set of edges later.
    for input in nodes[id]!.inputs {
      nodes[input.id]?.outputs.remove(id)
    }

    nodes[id]!.inputs = []
    let previous = currentNode
    currentNode = id
    let value = update(self)
    currentNode = previous

    nodes[id]!.value = value
    return value
  }
}

// MARK: - Debugging

extension Graph {

  /// The number of attributes currently in the graph.
  package var attributeCount: Int {
    nodes.count
  }

  /// The total number of attribute dependency edges in the graph.
  package var edgeCount: Int {
    nodes.values.reduce(0) { $0 + $1.outputs.count }
  }
}
