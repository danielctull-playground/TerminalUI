
package final class Graph {

  package init() {}
  var current: Dependant?

  package func input<Value>(
    _ name: Input.Name,
    _ value: Value
  ) -> Input<Value> {
    Input(graph: self, name: name, value: value)
  }

  package func rule<Value>(
    _ name: Rule.Name,
    _ make: @escaping () -> Value
  ) -> Rule<Value> {
    Rule(graph: self, name: name, make: make)
  }
}
