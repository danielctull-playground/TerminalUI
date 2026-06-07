
/// The storage backing an ``Attribute`` owned by the ``Graph``.
struct Node {

  /// The cached value.
  var value: Any?

  /// Allows the value to be updated or recomputed from other graph values.
  let update: (Graph) -> Any

  /// The attributes that read this one while computing.
  var outputs: Set<AttributeID> = []
}
