
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
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[PreferenceWriter] preference values") {
        Content.makeView(view: view.content, inputs: inputs).preferenceValues
          .setting(view.value.value, for: view.value.key)
      },
      displayItems: inputs.graph.attribute("[PreferenceWriter] display items") {
        Content.makeView(view: view.content, inputs: inputs).displayItems
      }
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
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[PreferenceReader] preference values") {
        let preferenceValues = Content.makeView(view: view.content, inputs: inputs).preferenceValues
        view.value.action(preferenceValues[Key.self] ?? Key.defaultValue)
        return preferenceValues
      },
      displayItems: inputs.graph.attribute("[PreferenceReader] display items") {
        Content.makeView(view: view.content, inputs: inputs).displayItems
      }
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
