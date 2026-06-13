/// An attribute body whose value never changes.
struct Constant<Value>: AttributeBody {

  let value: Value

  func update(in graph: Graph) -> Value {
    value
  }
}
