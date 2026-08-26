
struct FocusID: Equatable, Hashable {
  private let rawValue: Int
}

extension FocusID {
  nonisolated(unsafe) private static var counter = 0
  static var next: Self {
    defer { counter += 1 }
    return FocusID(rawValue: counter)
  }
}

extension FocusID: CustomStringConvertible {
  public var description: String {
    String(describing: rawValue)
  }
}

// MARK: - PreferenceKey

struct FocusIDKey: PreferenceKey {
  static let defaultValue: FocusID? = nil
  static func reduce(value: inout FocusID?, nextValue: () -> FocusID?) {
    value = nextValue()
  }
}
