/// An attribute body whose value is transformed from the value of the given
/// input attribute.
struct Map<each Input, Output>: AttributeBody {

  /// The attribute supplying the input value.
  let input: (repeat Attribute<each Input>)

  /// A transform from the input to the output value.
  let transform: (repeat each Input) -> Output

  func update(in graph: Graph) -> Output {
    transform(repeat graph[each input])
  }
}
