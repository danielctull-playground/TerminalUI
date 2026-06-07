/// A value type that knows how to compute an attribute's value.
protocol AttributeBody {

  associatedtype Value

  /// Computes the value, reading any input attributes from the graph.
  func update(in graph: Graph) -> Value
}
