
package final class Attribute<Value>: Dependency {

  package let name: Name
  private unowned let graph: Graph

  var dependants: [Dependant] = []

  private var _value: Value
  package var value: Value {
    get {

      if let dependant = graph.current {
        dependants.append(dependant)
        dependant.dependencies.append(self)
      }

      return _value
    }
    set {
      _value = newValue
      for dependant in dependants {
        dependant.dirty = true
      }
    }
  }

  init(graph: Graph, name: Name, value: Value) {
    self.graph = graph
    self.name = name
    _value = value
  }
}

// MARK: - Attribute.Name

extension Attribute {
  package typealias Name = AttributeName
}

package struct AttributeName: Equatable {
  private let raw: String
}

extension Attribute.Name: ExpressibleByStringLiteral {
  package init(stringLiteral value: String) {
    self.init(raw: value)
  }
}

extension Attribute.Name: CustomStringConvertible {
  package var description: String { raw }
}
