
/// A typed handle to a value held in a ``Graph``.
public struct Attribute<Value> {
  let id: AttributeID
}

// MARK: - AttributeID

/// A type-erased identifier for a node in a ``Graph``.
struct AttributeID: ArenaID {
  let rawValue: Int
}

// MARK: - AttributeMetadata

/// The debug information of an attribute.
package struct AttributeMetadata: Equatable {
  package let kind: Kind
  package let type: AType
}

extension AttributeMetadata {

  static func constant<Value>(of type: Value.Type) -> Self {
    Self(
      kind: Kind(rawValue: "Constant"),
      type: AType(rawValue: "\(type)")
    )
  }

  static func map<Value>(of type: Value.Type) -> Self {
    Self(
      kind: Kind(rawValue: "Map"),
      type: AType(rawValue: "\(type)")
    )
  }

  static func rule<Value>(of type: Value.Type) -> Self {
    Self(
      kind: Kind(rawValue: "Rule"),
      type: AType(rawValue: "\(type)")
    )
  }

  static func external<Value>(of type: Value.Type) -> Self {
    Self(
      kind: Kind(rawValue: "External"),
      type: AType(rawValue: "\(type)")
    )
  }
}

// MARK: - AttributeMetadata.Kind

extension AttributeMetadata {

  /// The kind of an attribute.
  package struct Kind: Equatable, Sendable {
    fileprivate let rawValue: String
  }
}

extension AttributeMetadata.Kind {
  package static let constant = Self(rawValue: "Constant")
  package static let external = Self(rawValue: "External")
  package static let map = Self(rawValue: "Map")
  package static let rule = Self(rawValue: "Rule")
}

extension AttributeMetadata.Kind: CustomStringConvertible {
  package var description: String { rawValue }
}

// MARK: - AttributeMetadata.AType

extension AttributeMetadata {

  /// The type of an attribute.
  package struct AType: Equatable {
    fileprivate let rawValue: String
  }
}

extension AttributeMetadata.AType: ExpressibleByStringLiteral {
  package init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }
}

extension AttributeMetadata.AType: CustomStringConvertible {
  package var description: String { rawValue }
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
