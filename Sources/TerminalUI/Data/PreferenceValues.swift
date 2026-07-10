import AttributeGraph

public protocol PreferenceKey {
  associatedtype Value
  static var defaultValue: Value { get }
  static func reduce(value: inout Value, nextValue: () -> Value)
}

// MARK: - PreferenceWriter

extension View {

  public func preference<Key: PreferenceKey>(
      key: Key.Type,
      value: Key.Value
  ) -> some View {
    PreferenceWriter(content: self, key: key, value: value)
  }
}

private struct PreferenceWriter<Content: View, Key: PreferenceKey>: PrimitiveView {

  let content: Content
  let key: Key.Type
  let value: Key.Value

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let content = Content.makeView(
      view: inputs.graph.map(view) { $0.content },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        graph[content.preferenceValues]
          .setting(graph[view].value, for: graph[view].key)
      },
      layoutProxies: content.layoutProxies,
      displayList: content.displayList
    )
  }
}

// MARK: - PreferenceReader

extension View {

  public func onPreferenceChange<Key: PreferenceKey>(
      _ key: Key.Type,
      perform action: @escaping (Key.Value) -> Void
  ) -> some View where Key.Value: Equatable {
    PreferenceReader(content: self, key: key, action: action)
  }
}

private struct PreferenceReader<
  Content: View,
  Key: PreferenceKey
>: PrimitiveView where Key.Value: Equatable {

  let content: Content
  let key: Key.Type
  let action: (Key.Value) -> Void

  public static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    let content = Content.makeView(
      view: inputs.graph.map(view) { $0.content },
      inputs: inputs
    )
    return ViewOutputs(
      preferenceValues: inputs.graph.rule { graph in
        let preferenceValues = graph[content.preferenceValues]
        graph[view].action(preferenceValues[Key.self] ?? Key.defaultValue)
        return preferenceValues
      },
      layoutProxies: content.layoutProxies,
      displayList: content.displayList
    )
  }
}

// MARK: - Preference Values

struct PreferenceValues {
  private var values: (any PreferenceKey.Type) -> Any?
  init(values: @escaping (any PreferenceKey.Type) -> Any?) {
    self.values = values
  }
}

extension PreferenceValues {

  static var empty: PreferenceValues { PreferenceValues { _ in nil } }

  subscript<Key: PreferenceKey>(key: Key.Type) -> Key.Value? {
    values(key) as? Key.Value
  }

  fileprivate func setting<Key: PreferenceKey>(
    _ value: Key.Value,
    for key: Key.Type
  ) -> PreferenceValues {
    PreferenceValues { identifier in
      if identifier == key { return value }
      return values(identifier)
    }
  }
}

extension PreferenceValues {
  init(lhs: PreferenceValues, rhs: PreferenceValues) {
    // Calling on PreferenceKey will un-erase it and its generic Value.
    self.init { $0.value(lhs: lhs, rhs: rhs) }
  }
}

extension PreferenceKey {
  fileprivate static func value(
    lhs: PreferenceValues,
    rhs: PreferenceValues
  ) -> Value {
    switch (lhs[self], rhs[self]) {
    case (.none, .none): return defaultValue
    case (.none, .some(let rhs)): return rhs
    case (.some(let lhs), .none): return lhs
    case (.some(var lhs), .some(let rhs)):
      reduce(value: &lhs) { rhs }
      return lhs
    }
  }
}
