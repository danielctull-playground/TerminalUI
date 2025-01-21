
package final class Graph {

  package init() {}

  package func attribute<Value>(
    _ name: Attribute.Name,
    value: Value
  ) -> Attribute<Value> {
    Attribute(name: name, value: value)
  }

  package func rule<Value>(
    _ name: Rule.Name,
    _ make: @escaping () -> Value
  ) -> Rule<Value> {
    Rule(name: name, make: make)
  }
}
