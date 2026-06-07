/// An attribute body that computes its value from other attributes.
struct Rule<Value>: AttributeBody {

  let compute: (Graph) -> Value

  func update(in graph: Graph) -> Value {
    compute(graph)
  }
}
