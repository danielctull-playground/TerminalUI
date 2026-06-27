import AttributeGraph

/// The backing for a single ``State`` property.
struct StoredLocation<Value> {

  private unowned let graph: Graph
  private let attribute: Attribute<Value>

  init(initialValue: Value, graph: Graph) {
    self.graph = graph
    attribute = graph.external(of: Value.self)
    graph.setValue(of: attribute, to: initialValue)
  }

  var value: Value {
    get { graph[attribute] }
    nonmutating set { graph.setValue(of: attribute, to: newValue) }
  }
}
