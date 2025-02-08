
package final class Attribute<Value>: Dependant, Dependency {

  package let name: Name
  private let make: () -> Value
  private var cache: Value?
  private unowned let graph: Graph

  var dirty = false
  var dependencies: [Dependency] = []
  var dependants: [Dependant] = []

  package var value: Value {
    graph.compute(self) {
      if dirty { cache = nil }
      if let cache { return cache }
      let value = make()
      dirty = false
      cache = value
      return value
    }
  }

  init(graph: Graph, name: Name, make: @escaping () -> Value) {
    self.graph = graph
    self.name = name
    self.make = make
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
