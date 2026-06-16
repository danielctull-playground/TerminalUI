import AttributeGraph

protocol DynamicProperty {

  func makeProperty(
    in buffer: inout DynamicPropertyBuffer,
    field: DynamicPropertyBuffer.Field,
    graph: Graph,
    properties: DynamicProperties
  )
}

// MARK: - DynamicPropertyBuffer

public struct DynamicPropertyBuffer {

  private var boxes: [Field: DynamicPropertyBox] = [:]

  init<Target>(
    graph: Graph,
    properties: DynamicProperties,
    target: Target
  ) {
    for (field, child) in Mirror(reflecting: target).children.enumerated() {
      guard let property = child.value as? DynamicProperty else { continue }
      let field = Field(rawValue: field)
      property.makeProperty(
        in: &self,
        field: field,
        graph: graph,
        properties: properties
      )
    }
  }

  mutating func append<Box: DynamicPropertyBox>(_ box: Box, field: Field) {
    boxes[field] = box
  }

  /// Updates a new struct with data in the graph when its recreated.
  func update<Target>(target: Target, graph: Graph, properties: DynamicProperties) {
    for (field, child) in Mirror(reflecting: target).children.enumerated() {
      let field = Field(rawValue: field)
      boxes[field]?.update(property: child.value, graph: graph, properties: properties)
    }
  }
}

extension DynamicPropertyBuffer {

  struct Field: Hashable {
    fileprivate let rawValue: Int
  }
}

// MARK: - DynamicPropertyBox

protocol DynamicPropertyBox {
  func update(property: Any, graph: Graph, properties: DynamicProperties)
}

// MARK: - DynamicProperties

struct DynamicProperties {
  let subgraph: Subgraph
  let environment: Attribute<EnvironmentValues>
}
