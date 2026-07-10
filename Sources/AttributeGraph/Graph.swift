/// A graph of attributes and the values flowing between them.
package final class Graph {

  private var attributes = Arena<AttributeID, AttributeNode>()
  private var currentAttribute: AttributeID?

  /// The subgraph that owns attributes created outside the scope of a specific
  /// subgraph.
  package let root: Subgraph

  private var subgraphs = Arena<SubgraphID, SubgraphNode>()

  /// The subgraph new attributes are assigned to. Defaults to the root.
  private var currentSubgraph = SubgraphID(rawValue: 0)

  /// Shows whether the graph has work to do in its next update.
  private var needsUpdate = false

  /// The number of ``deferringSubgraphInvalidation(_:)`` scopes that are open.
  ///
  /// > Note: Passes nest, where `deferringSubgraphInvalidation` can be inside
  ///         other `deferringSubgraphInvalidation` scopes, only the outer-most
  ///         scope performs subgraph invalidation.
  private var deferringSubgraphInvalidationDepth = 0

  /// Subgraphs that were invalidated while inside a
  /// ``deferringSubgraphInvalidation(_:)`` scope.
  private var deferredInvalidatedSubgraphs: [SubgraphID] = []

  package init() {
    root = Subgraph(id: subgraphs.insert(SubgraphNode(parent: nil)))
  }
}

// MARK: - Subgraphs

extension Graph {

  package func subgraph(_ body: () -> Void) -> Subgraph {
    subgraph(body).0
  }

  package func subgraph<Result>(_ body: () -> Result) -> (Subgraph, Result) {

    let parent = currentSubgraph
    let id = subgraphs.insert(SubgraphNode(parent: parent))
    subgraphs[parent].children.append(id)

    currentSubgraph = id

    defer {
      currentSubgraph = parent
    }

    return (Subgraph(id: id), body())
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

// MARK: - Subgraph Invalidation

extension Graph {

  /// Removes the subgraph and its attributes from the graph.
  package func invalidate(_ subgraph: Subgraph) {

    guard deferringSubgraphInvalidationDepth == 0 else {

      // Sever the inputs/outputs of the invalidated subgraph's attributes.
      // Otherwise change-detection in `evaluate` will re-run a removed
      // attribute's rule against stale inputs.
      disconnectAttributes(of: subgraph.id)

      deferredInvalidatedSubgraphs.append(subgraph.id)
      return
    }

    performInvalidation(subgraph.id)
  }

  /// Runs the given closure deferring subgraph invalidations until the end.
  ///
  /// - Parameter body: The work to be actioned.
  /// - Returns: The result of the closure.
  private func deferringSubgraphInvalidation<Result>(
    _ body: () -> Result
  ) -> Result {

    deferringSubgraphInvalidationDepth += 1

    defer {

      deferringSubgraphInvalidationDepth -= 1

      if deferringSubgraphInvalidationDepth == 0 {
        let invalidatedSubgraphs = deferredInvalidatedSubgraphs
        deferredInvalidatedSubgraphs = []
        for subgraph in invalidatedSubgraphs {
          performInvalidation(subgraph)
        }
      }
    }

    return body()
  }

  private func performInvalidation(_ id: SubgraphID) {

    // An earlier teardown in the same batch may have already removed this
    // subgraph as a descendant, so re-check before touching it.
    guard subgraphs.contains(id) else { return }

    if let parent = subgraphs[id].parent {
      subgraphs[parent].children.removeAll { $0 == id }
    }

    tearDown(id)
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
  
  /// Severs the inputs and outputs of every attribute in the given subgraph.
  ///
  /// This also disconnects attributes of all the subgraph's children.
  ///
  /// - Parameter id: The subgraph whose attributes should be disconnected.
  private func disconnectAttributes(of id: SubgraphID) {

    guard subgraphs.contains(id) else { return }

    let subgraph = subgraphs[id]

    for child in subgraph.children {
      disconnectAttributes(of: child)
    }

    for attribute in subgraph.attributes {
      disconnect(attribute)
    }
  }
}

// MARK: - Attributes

extension Graph {

  func attribute<Body: AttributeBody>(_ body: Body) -> Attribute<Body.Value> {

    let node = AttributeNode(
      value: nil,
      update: body.update,
      subgraph: currentSubgraph
    )

    let id = attributes.insert(node)
    subgraphs[currentSubgraph].attributes.append(id)
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
  package func map<each Input, Output>(
    _ input: repeat Attribute<each Input>,
    transform: @escaping (repeat each Input) -> Output
  ) -> Attribute<Output> {
    attribute(Map(input: (repeat each input), transform: transform))
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
      let oldValue = attributes[attribute.id].value as? Value,
      isEqual(oldValue, newValue)
    {
      return
    }

    attributes[attribute.id].value = newValue
    markAsDirty(dependentsOf: attribute.id)
    needsUpdate = true
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
  private func remove(_ id: AttributeID) {
    disconnect(id)
    attributes.remove(id)
  }

  /// Severs an attribute from its inputs and outputs.
  ///
  /// This keeps the node in the arena while an update pass is still running.
  ///
  /// - Parameter id: The id of the attribute being removed.
  private func disconnect(_ id: AttributeID) {

    let node = attributes[id]

    for input in node.inputs {
      attributes[input.id].outputs.remove(id)
    }

    for output in node.outputs {
      attributes[output].inputs.removeAll { $0.id == id }
    }

    attributes[id].inputs = []
    attributes[id].outputs = []
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

    let value = withSubgraph(attributes[id].subgraph) {
      withAttribute(id) {
        update(self)
      }
    }

    attributes[id].value = value
    return value
  }

  private func withSubgraph<Result>(
    _ subgraph: SubgraphID,
    body: () -> Result
  ) -> Result {
    let previous = currentSubgraph
    defer { currentSubgraph = previous }
    currentSubgraph = subgraph
    return body()
  }

  private func withAttribute<Result>(
    _ attribute: AttributeID,
    body: () -> Result
  ) -> Result {
    let previous = currentAttribute
    defer { currentAttribute = previous }
    currentAttribute = attribute
    return body()
  }
}

// MARK: - Updates

extension Graph {

  /// Resolves the graph's pending work.
  /// 
  /// - Parameter body: A closure that is run if updates were resolved.
  package func withUpdate(_ body: () -> Void = {}) {
    guard needsUpdate else { return }
    needsUpdate = false
    deferringSubgraphInvalidation {
      body()
    }
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
}
