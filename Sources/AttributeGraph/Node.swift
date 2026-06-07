
/// The storage backing an ``Attribute`` owned by the ``Graph``.
struct Node {

  /// The cached value.
  var value: Any?

  /// Allows the value to be updated or recomputed from other graph values.
  let update: (Graph) -> Any

  var inputs: [Input] = []

  /// The attributes that read this one while computing.
  var outputs: Set<AttributeID> = []

  /// Shows whether an input may have changed.
  var isDirty = false
}

struct Input {

  /// The attribute depended upon.
  let id: AttributeID

  /// The input's value at the moment it was read.
  let value: Any
}
