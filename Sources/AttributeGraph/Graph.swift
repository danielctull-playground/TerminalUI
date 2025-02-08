
package final class Graph {

  package init() {}
  var current: Dependant?

  package func input<Value>(
    _ name: Input.Name,
    _ value: Value
  ) -> Input<Value> {
    Input(graph: self, name: name, value: value)
  }

  package func attribute<Value>(
    _ input: Input<Value>
  ) -> Attribute<Value> {
    attribute(input.name) { input.value }
  }

  package func attribute<Value>(
    _ name: Attribute.Name,
    _ make: @escaping () -> Value
  ) -> Attribute<Value> {
    Attribute(graph: self, name: name, make: make)
  }
}
