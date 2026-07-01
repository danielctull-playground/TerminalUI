import AttributeGraph

protocol DynamicProperty {
  func install(
    _ buffer: DynamicPropertyBuffer,
    for label: String,
    inputs: ViewInputs
  )
}

extension DynamicPropertyBuffer {

  func install<Target>(on target: Target, inputs: ViewInputs) {
    let mirror = Mirror(reflecting: target)
    for child in mirror.children {
      if let property = child.value as? DynamicProperty {
        if let label = child.label {
          property.install(self, for: label, inputs: inputs)
        }
      }
    }
  }
}

// MARK: - DynamicPropertyBuffer

/// A view's per-instance store of dynamic-property locations.
final class DynamicPropertyBuffer {

  private unowned let graph: Graph
  private var locations: [String: Any] = [:]

  init(graph: Graph) {
    self.graph = graph
  }

  func location<Value>(
    for label: String,
    initialValue: Value
  ) -> StoredLocation<Value> {

    if let location = locations[label] as? StoredLocation<Value> {
      return location
    }

    let location = StoredLocation(initialValue: initialValue, graph: graph)
    locations[label] = location
    return location
  }
}

