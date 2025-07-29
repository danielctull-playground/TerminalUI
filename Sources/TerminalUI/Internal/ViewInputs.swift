import AttributeGraph

@dynamicMemberLookup
struct ViewInputs<Value> {

  let graph: Graph
  let canvas: any Canvas
  @Attribute var value: Value
  @Attribute var environment: EnvironmentValues

  init(
    value: Attribute<Value>,
    canvas: any Canvas,
    environment: EnvironmentValues = EnvironmentValues()
  ) {
    graph = Graph()
    _value = value
    self.canvas = canvas
    _environment = graph.input("environment", environment).projectedValue
  }

  public subscript<Property>(
    dynamicMember keyPath: KeyPath<Value, Property>
  ) -> ViewInputs<Property> {
    ViewInputs<Property>(
      value: _value[dynamicMember: keyPath],
      canvas: canvas,
      environment: environment)
  }
}
