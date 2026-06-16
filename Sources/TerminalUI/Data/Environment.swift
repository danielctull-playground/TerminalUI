import AttributeGraph

// MARK: EnvironmentKey

public protocol EnvironmentKey {
  associatedtype Value
  static var defaultValue: Value { get }
}

// MARK: - @Environment

@propertyWrapper
public struct Environment<Value> {

  private let keyPath: KeyPath<EnvironmentValues, Value>
  @Mutable fileprivate var values: EnvironmentValues?

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    self.keyPath = keyPath
  }

  public var wrappedValue: Value {
    guard let values else { fatalError("Environment values not set.") }
    return values[keyPath: keyPath]
  }
}

extension Environment: DynamicProperty {

  func makeProperty(
    in buffer: inout DynamicPropertyBuffer,
    field: DynamicPropertyBuffer.Field,
    graph: Graph,
    properties: DynamicProperties
  ) {
    buffer.append(EnvironmentBox<Value>(), field: field)
  }
}

private struct EnvironmentBox<Value>: DynamicPropertyBox {

  func update(property: Any, graph: Graph, properties: DynamicProperties) {
    guard let environment = property as? Environment<Value> else { fatalError() }
    environment.values = graph[properties.environment]
  }
}

// MARK: - Writing

extension View {

  public func environment<Value>(
    _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
    _ value: Value
  ) -> some View {
    EnvironmentWriter(content: self, keyPath: keyPath, value: value)
  }
}

private struct EnvironmentWriter<Content: View, Value>: PrimitiveView {

  let content: Content
  let keyPath: WritableKeyPath<EnvironmentValues, Value>
  let value: Value

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let content = inputs.graph.map(view, \.content)
    let dynamicProperties = inputs.dynamicProperties

    let inputs = ViewInputs(
      graph: inputs.graph,
      canvas: inputs.canvas,
      dynamicProperties: DynamicProperties(
        subgraph: dynamicProperties.subgraph,
        environment: inputs.graph.rule { graph in
          var environment = graph[dynamicProperties.environment]
          let writer = graph[view]
          environment[keyPath: writer.keyPath] = writer.value
          return environment
        }
      )
    )

    return Content.makeView(view: content, inputs: inputs)
  }
}

// MARK: - Transforming

extension View {

  public func transformEnvironment<Value>(
      _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
      transform: @escaping (inout Value) -> Void
  ) -> some View {
    modifier(EnvironmentTransformer(keyPath: keyPath, transform: transform))
  }
}

private struct EnvironmentTransformer<Content: View, Value>: ViewModifier {

  @Environment private var value: Value
  private let keyPath: WritableKeyPath<EnvironmentValues, Value>
  private let transform: (Value) -> Value

  init(
    keyPath: WritableKeyPath<EnvironmentValues, Value>,
    transform: @escaping (inout Value) -> Void
  ) {
    _value = Environment(keyPath)
    self.keyPath = keyPath
    self.transform = { value in
      var value = value
      transform(&value)
      return value
    }
  }

  func body(content: Content) -> some View {
    content.environment(keyPath, transform(value))
  }
}

// MARK: - EnvironmentValues

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
