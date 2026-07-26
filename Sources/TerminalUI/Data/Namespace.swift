import AttributeGraph

@propertyWrapper
@MainActor
public struct Namespace {

  @Mutable private var location: StoredLocation<ID>!

  public init() {}
  
  public var wrappedValue: ID {
    location.value
  }
}

extension Namespace: @MainActor DynamicProperty {

  public func makeProperty(
    in buffer: DynamicPropertyBuffer,
    field: Field,
    inputs: ViewInputs
  ) {
    location = buffer.location(
      for: field,
      initialValue: ID.next
    )
  }
}

// MARK: Namespace.ID

extension Namespace {

  @MainActor
  public struct ID: Equatable, Hashable {
    private let rawValue: Int
  }
}

extension Namespace.ID {
  private static var counter = 0
  fileprivate static var next: Self {
    defer { counter += 1 }
    return Namespace.ID(rawValue: counter)
  }
}

extension Namespace.ID: @MainActor CustomStringConvertible {
  public var description: String {
    String(describing: rawValue)
  }
}
