
@propertyWrapper
public struct Environment<Value> {

  private let keyPath: KeyPath<EnvironmentValues, Value>
  @Box private var values: EnvironmentValues?

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    self.keyPath = keyPath
  }

  public var wrappedValue: Value {
    guard let values else { fatalError("Environment values not set.") }
    return values[keyPath: keyPath]
  }
}

@propertyWrapper
private final class Box<Value> {
  var wrappedValue: Value
  init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
}

private protocol DynamicProperty {
  func install(_ values: EnvironmentValues)
}

extension Environment: DynamicProperty {

  fileprivate func install(_ values: EnvironmentValues) {
    self.values = values
  }
}

extension EnvironmentValues {

  func install<Target>(on target: Target) {
    let mirror = Mirror(reflecting: target)
    for child in mirror.children {
      if let property = child.value as? DynamicProperty {
        property.install(self)
      }
    }
  }
}
