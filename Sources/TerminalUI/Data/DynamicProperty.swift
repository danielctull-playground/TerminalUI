import AttributeGraph

protocol DynamicProperty {
  func install(_ properties: DynamicProperties, for label: String)
}

struct DynamicProperties {
  let graph: Graph
  let environment: Attribute<EnvironmentValues>
  let state: Attribute<StateValues>
}

extension DynamicProperties {

  func install<Target>(on target: Target) {
    let mirror = Mirror(reflecting: target)
    for child in mirror.children {
      if let property = child.value as? DynamicProperty {
        if let label = child.label {
          property.install(self, for: label)
        }
      }
    }
  }
}
