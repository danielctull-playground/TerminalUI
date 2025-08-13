import AttributeGraph

public struct ViewInputs<Node> {

  let graph: Graph
  let canvas: any Canvas
  let dynamicProperties: DynamicProperties
  @Attribute var node: Node

  init(
    graph: Graph,
    canvas: any Canvas,
    dynamicProperties: DynamicProperties,
    node: Attribute<Node>
  ) {
    self.graph = graph
    self.canvas = canvas
    self.dynamicProperties = dynamicProperties
    _node = node
  }

  func map<New>(_ transform: @escaping (Node) -> New) -> ViewInputs<New> {
    ViewInputs<New>(
      graph: graph,
      canvas: canvas,
      dynamicProperties: dynamicProperties,
      node: graph.attribute("[map] \(Node.self) -> \(New.self)") {
        transform(node)
      }
    )
  }

  func mapDynamicProperties(
    _ transform: @escaping (DynamicProperties) -> DynamicProperties
  ) -> ViewInputs {
    ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: transform(dynamicProperties),
      node: _node
    )
  }
}
