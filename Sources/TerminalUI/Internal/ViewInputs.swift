import AttributeGraph

public struct ViewInputs {

  unowned let graph: Graph
  let environment: Attribute<EnvironmentValues>

  init(
    graph: Graph,
    environment: Attribute<EnvironmentValues>,
  ) {
    self.graph = graph
    self.environment = environment
  }
}
