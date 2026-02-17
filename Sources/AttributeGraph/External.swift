
@propertyWrapper
package final class External<Value>: Dependency {

  package let name: Name
  private unowned let graph: Graph

  var dependants: [Dependant] = []

  private var _value: Value
  package var wrappedValue: Value {
    get {
      graph.compute(self) { _value }
    }
    set {
      _value = newValue
      for dependant in dependants {
        dependant.dirty = true
      }
    }
  }

  package var projectedValue: Attribute<Value> {
    graph.attribute(name) { self.wrappedValue }
  }

  init(graph: Graph, name: Name, value: Value) {
    self.graph = graph
    self.name = name
    _value = value
  }
}

// MARK: - External.Name

extension External {
  package typealias Name = AttributeName
}
