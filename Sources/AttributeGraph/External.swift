/// An attribute body whose value is supplied from outside the graph rather
/// than computed.
///
/// It holds no value of its own: an external begins empty and is given one with
/// ``Graph/setValue(of:to:)``. Reading an external before any value is set is a
/// programming error.
struct External<Value>: AttributeBody {

  func update(in graph: Graph) -> Value {
    fatalError("An external attribute has no value until one is set.")
  }
}
