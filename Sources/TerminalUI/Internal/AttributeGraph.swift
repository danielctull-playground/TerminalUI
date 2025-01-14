
// MARK: - AttributeGraph

package final class AttributeGraph {

  package init() {}

  package func rule<Value>(
    _ name: Node.Name,
    makeValue: @escaping () -> Value
  ) -> Node<Value> {
    Node(name: name, makeValue: makeValue)
  }
}

// MARK: - Node

extension AttributeGraph {

  package final class Node<Value>: AnyNode {

    package let name: Name
    private let makeValue: () -> Value

    package var value: Value {
      makeValue()
    }

    fileprivate init(name: Name, makeValue: @escaping () -> Value) {
      self.name = name
      self.makeValue = makeValue
    }
  }
}

// MARK: - Node.Name

extension AttributeGraph.Node {
  package typealias Name = AttributeGraph.NodeName
}

extension AttributeGraph {
  package struct NodeName: Equatable {
    private let raw: String
  }
}

extension AttributeGraph.Node.Name: ExpressibleByStringLiteral {
  package init(stringLiteral value: String) {
    self.init(raw: value)
  }
}

extension AttributeGraph.Node.Name: CustomStringConvertible {
  package var description: String { raw }
}

// MARK: - AnyNode

private protocol AnyNode {}
