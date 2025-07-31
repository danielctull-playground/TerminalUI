
@propertyWrapper
public struct Environment<Value> {

  private let keyPath: KeyPath<EnvironmentValues, Value>
  @Mutable private var values: EnvironmentValues?

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    self.keyPath = keyPath
  }

  public var wrappedValue: Value {
    guard let values else { fatalError("Environment values not set.") }
    return values[keyPath: keyPath]
  }
}

extension Environment: DynamicProperty {

  func install(_ properties: DynamicProperties) {
    values = properties.environment
  }
}
