
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

  func install(_ properties: DynamicProperties) {
    values = properties.environment
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
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[EnvironmentWriter] preference values") {
        Content
          .makeView(
            inputs: inputs
              .settingEnvironmentValue(inputs.node.value, for: inputs.node.keyPath)
              .map(\.content)
          )
          .preferenceValues
      },
      displayItems: inputs.graph.attribute("[EnvironmentWriter] display items") {
        Content
          .makeView(
            inputs: inputs
              .settingEnvironmentValue(inputs.node.value, for: inputs.node.keyPath)
              .map(\.content)
          )
          .displayItems
      }
    )
  }
}

extension ViewInputs {

  func settingEnvironmentValue<Value>(
    _ value: Value,
    for keyPath: WritableKeyPath<EnvironmentValues, Value>
  ) -> ViewInputs {
    ViewInputs(
      graph: graph,
      canvas: canvas,
      dynamicProperties: DynamicProperties(
        environment: graph.attribute("") {
          var environment = dynamicProperties.environment
          environment[keyPath: keyPath] = value
          return environment
        }
      ),
      node: nodeAttribute)
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
