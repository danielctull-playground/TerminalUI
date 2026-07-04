import AttributeGraph

protocol DynamicProperty {
  func makeProperty(
    in buffer: DynamicPropertyBuffer,
    field: Field,
    inputs: ViewInputs
  )
}

extension DynamicProperty {

  func makeProperty(
    in buffer: DynamicPropertyBuffer,
    field: Field,
    inputs: ViewInputs
  ) {
    makeProperties(
      for: self,
      in: buffer.buffer(for: field),
      inputs: inputs
    )
  }
}

func makeProperties<Target>(
  for target: Target,
  in buffer: DynamicPropertyBuffer,
  inputs: ViewInputs
) {
  let mirror = Mirror(reflecting: target)
  for child in mirror.children {
    if let property = child.value as? DynamicProperty {
      if let label = child.label {
        let field = Field(label)
        property.makeProperty(in: buffer, field: field, inputs: inputs)
      }
    }
  }
}

// MARK: - Field

struct Field: Hashable {
  private let rawValue: String
  fileprivate init(_ rawValue: String) {
    self.rawValue = rawValue
  }
}

// MARK: - DynamicPropertyBuffer

/// A view's per-instance store of dynamic-property locations.
final class DynamicPropertyBuffer {

  private unowned let graph: Graph
  private var locations: [Field: Any] = [:]

  init(graph: Graph) {
    self.graph = graph
  }

  func location<Value>(
    for field: Field,
    initialValue: Value
  ) -> StoredLocation<Value> {

    if let location = locations[field] as? StoredLocation<Value> {
      return location
    }

    let location = StoredLocation(initialValue: initialValue, graph: graph)
    locations[field] = location
    return location
  }
}

extension DynamicPropertyBuffer {
  
  /// Creates a new buffer for the given field.
  ///
  /// This allows ``DynamicProperty`` to implement
  ///
  /// - Parameter field: The field to create the buffer for.
  /// - Returns: A sub-buffer for the given field.
  fileprivate func buffer(for field: Field) -> DynamicPropertyBuffer {
    location(
      for: field,
      initialValue: DynamicPropertyBuffer(graph: graph)
    )
    .value
  }
}
