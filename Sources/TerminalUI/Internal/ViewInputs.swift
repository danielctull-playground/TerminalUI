import AttributeGraph

@dynamicMemberLookup
public struct ViewInputs<Node> {

  let graph: Graph
  let canvas: any Canvas
  let dynamicProperties: DynamicProperties
  @Attribute var node: Node

  var nodeAttribute: Attribute<Node> { _node }

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

  subscript<Property>(
    dynamicMember keyPath: KeyPath<Node, Property>
  ) -> ViewInputs<Property> {
    modifyNode("\(type(of: Node.self)) -> \(type(of: Property.self))") {
      node[keyPath: keyPath]
    }
  }

  func modifyNode<New>(_ name: AttributeName, compute: @escaping () -> New) -> ViewInputs<New> {
    ViewInputs<New>(
      graph: graph,
      canvas: canvas,
      dynamicProperties: dynamicProperties,
      node: graph.attribute(name, compute)
    )
  }
}
