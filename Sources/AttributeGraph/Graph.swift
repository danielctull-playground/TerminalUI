
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
    _ input: Input<Value>,
    compute: () -> Value
  ) -> Value {
    setupDependency(input)
    return compute()
  }

  package func input<Value>(
    _ name: Input.Name,
    _ value: Value
  ) -> Input<Value> {
    Input(graph: self, name: name, value: value)
  }

  package func attribute<Value>(
    _ input: Input<Value>
  ) -> Attribute<Value> {
    attribute(input.name) { input.value }
  }

  package func attribute<Value>(
    _ name: Attribute.Name,
    _ make: @escaping () -> Value
  ) -> Attribute<Value> {
    Attribute(graph: self, name: name, make: make)
  }
}
