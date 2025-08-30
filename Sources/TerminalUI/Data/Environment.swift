
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
              .mapDynamicProperties {
                $0.modifyEnvironment {
                  $0[keyPath: inputs.node.keyPath] = inputs.node.value
                }
              }
              .mapNode(\.content)
          )
          .preferenceValues
      },
      displayItems: inputs.graph.attribute("[EnvironmentWriter] display items") {
        Content
          .makeView(
            inputs: inputs
              .mapDynamicProperties {
                $0.modifyEnvironment {
                  $0[keyPath: inputs.node.keyPath] = inputs.node.value
                }
              }
              .mapNode(\.content)
          )
          .displayItems
      }
    )
  }
}


extension DynamicProperties {

  fileprivate func modifyEnvironment(
    _ transform: @escaping (inout EnvironmentValues) -> Void
  ) -> DynamicProperties {
    DynamicProperties(
      graph: graph,
      environment: graph.attribute("[modify env]") {
        var environment = self.environment
        transform(&environment)
        return environment
      }
    )
  }
}

// MARK: - Environment Values

public struct EnvironmentValues {

  private var values: [AnyEnvironmentPropertyKey: Any] = [:]

  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[EnvironmentPropertyKey(key)] as? Key.Value ?? Key.defaultValue }
    set { values[EnvironmentPropertyKey(key)] = newValue }
  }
}

private final class EnvironmentPropertyKey<Key>: AnyEnvironmentPropertyKey {
  init(_ type: Key.Type) {
    super.init(id: ObjectIdentifier(type))
  }
}

private class AnyEnvironmentPropertyKey {
  private let id: ObjectIdentifier
  init(id: ObjectIdentifier) {
    self.id = id
  }
}

extension AnyEnvironmentPropertyKey: Equatable {
  static func == (
    lhs: AnyEnvironmentPropertyKey,
    rhs: AnyEnvironmentPropertyKey
  ) -> Bool {
    lhs.id == rhs.id
  }
}

extension AnyEnvironmentPropertyKey: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
