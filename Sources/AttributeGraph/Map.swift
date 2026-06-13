/// An attribute body whose value is transformed from the value of the given
/// input attribute.
struct Map<Input, Output>: AttributeBody {

  /// The attribute supplying the input value.
  let input: Attribute<Input>

  /// A transform from the input to the output value.
  let transform: (Input) -> Output

  func update(in graph: Graph) -> Output {
    transform(graph[input])
  }
}
