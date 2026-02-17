
package final class Graph {

  package init() {}
  private var current: Dependant?

  private func setupDependency(_ dependency: any Dependency) {
    if let dependant = current {
      dependency.dependants.append(dependant)
      dependant.dependencies.append(dependency)
    }
  }

  func compute<Value>(
    _ attribute: Attribute<Value>,
    compute: () -> Value
  ) -> Value {

    setupDependency(attribute)

    let previous = current
    defer { current = previous }
    current = attribute

    return compute()
  }

  func compute<Value>(
    _ external: External<Value>,
    compute: () -> Value
  ) -> Value {
    setupDependency(external)
    return compute()
  }

  package func external<Value>(
    _ name: External.Name,
    _ value: Value
  ) -> External<Value> {
    External(graph: self, name: name, value: value)
  }

  package func attribute<Value>(
    _ name: Attribute.Name,
    _ make: @escaping () -> Value
  ) -> Attribute<Value> {
    Attribute(graph: self, name: name, make: make)
  }
}
