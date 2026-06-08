/// A grouping of attributes within a ``Graph`` that share a lifetime and place
/// in the graph's structure.
package struct Subgraph: Equatable {
  let id: SubgraphID
}

/// A type-erased identifier for a subgraph in a ``Graph``.
struct SubgraphID: Hashable {
  /// The subgraph's number, unique within the graph.
  let rawValue: Int
}
