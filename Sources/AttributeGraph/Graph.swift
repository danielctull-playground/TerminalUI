
package final class Graph {

  package init() {}
  var current: Dependant?

  package func attribute<Value>(
    _ name: Attribute.Name,
    value: Value
  ) -> Attribute<Value> {
    Attribute(graph: self, name: name, value: value)
  }

  package func rule<Value>(
    _ name: Rule.Name,
    _ make: @escaping () -> Value
  ) -> Rule<Value> {
    Rule(graph: self, name: name, make: make)
  }
}
