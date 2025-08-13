import AttributeGraph

protocol DynamicProperty {
  func install(_ properties: DynamicProperties)
}

struct DynamicProperties {
  let graph: Graph
  @Attribute var environment: EnvironmentValues
}

extension DynamicProperties {

  func install<Target>(on target: Target) {
    let mirror = Mirror(reflecting: target)
    for child in mirror.children {
      if let property = child.value as? DynamicProperty {
        property.install(self)
      }
    }
  }
}
