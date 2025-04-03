import AttributeGraph

@dynamicMemberLookup
public struct ViewInputs<Node> {

  let graph: Graph
  let node: Node
  @Attribute var frame: Rect
  @Attribute var environment: EnvironmentValues

  subscript<Property>(dynamicMember keyPath: KeyPath<Node, Property>) -> ViewInputs<Property> {
    ViewInputs<Property>(
      graph: graph,
      node: node[keyPath: keyPath],
      frame: _frame,
      environment: _environment)
  }
}

extension ViewInputs {

  func map<NewNode>(_ transform: (Node) -> NewNode) -> ViewInputs<NewNode> {

    ViewInputs<NewNode>(
      graph: graph,
      node: transform(node),
      frame: _frame,
      environment: _environment)

  }
}

extension ViewInputs {
  init(
    node: Node,
    frame: Rect,
    environment: EnvironmentValues = EnvironmentValues()
  ) {
    let graph = Graph()
    self.init(
      graph: graph,
      node: node,
      frame: graph.input("frame", frame).projectedValue,
      environment: graph.input("environment", environment).projectedValue)
  }
}
