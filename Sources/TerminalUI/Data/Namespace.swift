import AttributeGraph

@propertyWrapper
public struct Namespace {

  public init() {}
  
  public var wrappedValue: ID {
    ID.next
  }
}

// MARK: Namespace.ID

extension Namespace {

  public struct ID: Equatable, Hashable {
    private let rawValue: Int
  }
}

extension Namespace.ID {
  nonisolated(unsafe) private static var counter = 0
  fileprivate static var next: Self {
    defer { counter += 1 }
    return Namespace.ID(rawValue: counter)
  }
}
