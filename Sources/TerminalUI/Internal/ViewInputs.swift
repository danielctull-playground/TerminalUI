import AttributeGraph

@dynamicMemberLookup
public struct ViewInputs<Node> {

  let graph: Graph
  let canvas: any Canvas
  @Attribute var node: Node
  @Attribute var environment: EnvironmentValues

  var nodeAttribute: Attribute<Node> { _node }
  var environmentAttribute: Attribute<EnvironmentValues> { _environment }

  init(
    node: Attribute<Node>,
    canvas: any Canvas,
    environment: EnvironmentValues = EnvironmentValues()
  ) {
    graph = Graph()
    _node = node
    self.canvas = canvas
    _environment = graph.input("environment", environment).projectedValue
  }

  init(
    graph: Graph,
    canvas: any Canvas,
    node: Attribute<Node>,
    environment: Attribute<EnvironmentValues>
  ) {
    self.graph = graph
    self.canvas = canvas
    _node = node
    _environment = environment
  }

  public subscript<Property>(
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
      node: graph.attribute(name, compute),
      environment: _environment)
  }

//  func modifyEnvironment(_ transform: @escaping (inout EnvironmentValues) -> Void) -> ViewInputs {
//
//    var env =
//
//    ViewInputs(
//      graph: graph,
//      canvas: canvas,
//      node: _node,
//      environment: _environment)
//  }
}
