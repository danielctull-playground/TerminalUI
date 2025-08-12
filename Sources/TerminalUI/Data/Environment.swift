
public protocol EnvironmentKey {
  associatedtype Value
  static var defaultValue: Value { get }
}

// MARK: - Environment Property Wrapper

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

  func install(_ values: EnvironmentValues) {
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

// MARK: - Environment Writer

extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentWriter(content: self, keyPath: keyPath, value: value)
  }
}

private struct EnvironmentWriter<Content: View, Value>: View {

  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {

    let environment = inputs.graph.attribute("[EnvironmentWriter]") {
      let keyPath = inputs.node.keyPath
      let value = inputs.node.value
      var environment = inputs.dynamicProperties.environment
      environment[keyPath: keyPath] = value
      return environment
    }

    let inputs = ViewInputs(
      graph: inputs.graph,
      canvas: inputs.canvas,
      dynamicProperties: DynamicProperties(environment: environment),
      node: inputs.nodeAttribute.content)

    return Content.makeView(inputs: inputs)
  }
}

// MARK: - Environment Values

public struct EnvironmentValues {

  private var values: [ObjectIdentifier: Any] = [:]

  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue }
    set { values[ObjectIdentifier(key)] = newValue }
  }
}
