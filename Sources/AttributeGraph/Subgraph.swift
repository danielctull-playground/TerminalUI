/// A grouping of attributes within a ``Graph`` that share a lifetime and place
/// in the graph's structure.
package struct Subgraph: Equatable {
  let id: SubgraphID
}

// MARK: - SubgraphID

/// A type-erased identifier for a subgraph in a ``Graph``.
struct SubgraphID: ArenaID {
  /// The subgraph's number, unique within the graph.
  let rawValue: Int
}

// MARK: - SubgraphName

/// The debug description of a subgraph.
///
/// Note: Not to be used for identity.
package struct SubgraphName: Equatable {
  private let rawValue: String
}

extension SubgraphName: ExpressibleByStringLiteral {
  package init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }
}

extension SubgraphName: ExpressibleByStringInterpolation {}

extension SubgraphName: CustomStringConvertible {
  package var description: String { rawValue }
}

// MARK: - SubgraphNode

/// Storage backing a ``Subgraph``.
struct SubgraphNode {

  /// The subgraph that contains this one.
  let parent: SubgraphID?

  /// Subgraphs created within this one, in the order they were created.
  var children: [SubgraphID] = []

  /// The attributes owned by this subgraph.
  var attributes: [AttributeID] = []
}
