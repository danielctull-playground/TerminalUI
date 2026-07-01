import AttributeGraph

public struct ViewInputs {

  unowned let graph: Graph
  let canvas: any Canvas
  let environment: Attribute<EnvironmentValues>

  init(
    graph: Graph,
    canvas: any Canvas,
    environment: Attribute<EnvironmentValues>,
  ) {
    self.graph = graph
    self.canvas = canvas
    self.environment = environment
  }
}
