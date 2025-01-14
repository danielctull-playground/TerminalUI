
package final class Graph {

  package init() {}

  package func attribute<Value>(
    _ name: Attribute.Name,
    value: Value
  ) -> Attribute<Value> {
    Attribute(name: name, value: value)
  }
}
