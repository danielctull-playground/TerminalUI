import AttributeGraph

struct ViewInputs {

  let graph: Graph
  let canvas: any Canvas
  @Attribute var environment: EnvironmentValues

  init(
    canvas: any Canvas,
    environment: EnvironmentValues = EnvironmentValues()
  ) {
    graph = Graph()
    self.canvas = canvas
    _environment = graph.input("environment", environment).projectedValue
  }
}
