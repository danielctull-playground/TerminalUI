
/// A typed handle to a value held in a ``Graph``.
public struct Attribute<Value> {
  let id: AttributeID
}

// MARK: - AttributeID

/// A type-erased identifier for a node in a ``Graph``.
struct AttributeID {
  let rawValue: Int
}
