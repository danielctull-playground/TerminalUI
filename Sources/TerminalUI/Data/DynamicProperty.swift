import AttributeGraph

protocol DynamicProperty {
  func install(_ values: EnvironmentValues)
}

struct DynamicProperties {
  @Attribute var environment: EnvironmentValues
}
