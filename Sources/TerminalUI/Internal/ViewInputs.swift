import AttributeGraph

public struct ViewInputs {

  unowned let graph: Graph
  let canvas: any Canvas
  let environment: Attribute<EnvironmentValues>
  let dynamicProperties: DynamicProperties

  init(
    graph: Graph,
    canvas: any Canvas,
    environment: Attribute<EnvironmentValues>,
    dynamicProperties: DynamicProperties
  ) {
    self.graph = graph
    self.canvas = canvas
    self.environment = environment
    self.dynamicProperties = dynamicProperties
  }

  func mapDynamicProperties(
    _ transform: @escaping (DynamicProperties) -> DynamicProperties
  ) -> ViewInputs {
    ViewInputs(
      graph: graph,
      canvas: canvas,
      environment: environment,
      dynamicProperties: transform(dynamicProperties)
    )
  }
}
