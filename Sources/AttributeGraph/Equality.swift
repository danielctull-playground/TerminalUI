/// Compares two type-erased values.
func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
  guard let lhs = lhs as? any Equatable else { return false }
  return lhs.isEqual(to: rhs)
}

extension Equatable {

  fileprivate func isEqual(to other: Any) -> Bool {
    guard let other = other as? Self else { return false }
    return self == other
  }
}
