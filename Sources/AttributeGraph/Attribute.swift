
/// A typed handle to a value held in a ``Graph``.
public struct Attribute<Value> {
  let id: AttributeID
}

// MARK: - AttributeID

/// A type-erased identifier for a node in a ``Graph``.
struct AttributeID: ArenaID {
  let rawValue: Int
}

// MARK: - AttributeNode

/// The storage backing an ``Attribute`` owned by the ``Graph``.
struct AttributeNode {

  /// The cached value.
  var value: Any?

  /// Allows the value to be updated or recomputed from other graph values.
  let update: (Graph) -> Any

  /// The subgraph that owns this node.
  ///
  /// When the subgraph is torn down, this node is removed.
  let subgraph: SubgraphID

  var inputs: [Input] = []

  /// The attributes that read this one while computing.
  var outputs: Set<AttributeID> = []

  /// Shows whether an input may have changed.
  var isDirty = false
}

extension AttributeNode {

  struct Input {

    /// The attribute depended upon.
    let id: AttributeID

    /// The input's value at the moment it was read.
    let value: Any
  }
}
