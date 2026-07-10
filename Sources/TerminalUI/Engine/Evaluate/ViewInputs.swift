import AttributeGraph

public struct ViewInputs {

  unowned let graph: Graph
  let environment: Attribute<EnvironmentValues>
  let geometry: Attribute<ViewGeometry>

  init(
    graph: Graph,
    environment: Attribute<EnvironmentValues>,
    geometry: Attribute<ViewGeometry>,
  ) {
    self.graph = graph
    self.environment = environment
    self.geometry = geometry
  }
}
