import AttributeGraph

public struct ViewInputs {

  let graph: Graph
  let canvas: any Canvas
  let dynamicProperties: DynamicProperties

  init(
    graph: Graph,
    canvas: any Canvas,
    dynamicProperties: DynamicProperties
  ) {
    self.graph = graph
    self.canvas = canvas
    self.dynamicProperties = dynamicProperties
  }

  func mapDynamicProperties(
    _ transform: @escaping (DynamicProperties) -> DynamicProperties
  ) -> ViewInputs {
    ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: transform(dynamicProperties)
    )
  }
}
