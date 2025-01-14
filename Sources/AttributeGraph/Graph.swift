
package final class Graph {

  package init() {}

  package func rule<Value>(
    _ name: Attribute.Name,
    makeValue: @escaping () -> Value
  ) -> Attribute<Value> {
    Attribute(name: name, makeValue: makeValue)
  }
}
