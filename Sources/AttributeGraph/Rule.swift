
package final class Rule<Value>: Dependant, Dependency {

  package let name: Name
  private let make: () -> Value
  private var cache: Value?
  private unowned let graph: Graph

  var dirty = false
  var dependencies: [Dependency] = []
  var dependants: [Dependant] = []

  package var value: Value {

    if let dependant = graph.current {
      dependants.append(dependant)
      dependant.dependencies.append(self)
    }

    let previous = graph.current
    defer { graph.current = previous }
    graph.current = self

    if dirty { cache = nil }
    if let cache { return cache }
    let value = make()
    dirty = false
    cache = value
    return value
  }

  init(graph: Graph, name: Name, make: @escaping () -> Value) {
    self.graph = graph
    self.name = name
    self.make = make
  }
}

// MARK: - Rule.Name

extension Rule {
  package typealias Name = RuleName
}

package struct RuleName: Equatable {
  private let raw: String
}

extension Rule.Name: ExpressibleByStringLiteral {
  package init(stringLiteral value: String) {
    self.init(raw: value)
  }
}

extension Rule.Name: CustomStringConvertible {
  package var description: String { raw }
}
