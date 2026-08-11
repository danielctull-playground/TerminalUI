import AttributeGraph

extension View {

  public func onChange<Value: Equatable>(
    of value: Value,
    initial: Bool = false,
    _ action: @escaping (Value, Value) -> Void
  ) -> some View {
    OnChange(
      content: self,
      value: value,
      initial: initial,
      action: action
    )
  }

  public func onChange<Value: Equatable>(
    of value: Value,
    initial: Bool = false,
    _ action: @escaping () -> Void
  ) -> some View {
    OnChange(
      content: self,
      value: value,
      initial: initial,
      action: { _, _ in action() }
    )
  }
}

private struct OnChange<Content: View, Value: Equatable>: PrimitiveView {

  enum Observation {
    case uninitialized
    case value(Value)
  }

  let content: Content
  let value: Value
  let initial: Bool
  let action: (Value, Value) -> Void

  static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let observation = inputs.graph.external(of: Observation.self)
    inputs.graph.setValue(of: observation, to: .uninitialized)

    let content = Content.makeView(
      view: inputs.graph.rule { graph in

        let view = graph[view]
        let new = view.value

        switch graph[observation] {
        case .uninitialized:
          graph.setValue(of: observation, to: .value(new))
          if view.initial { view.action(new, new) }

        case .value(let old) where old != new:
          graph.setValue(of: observation, to: .value(new))
          view.action(old, new)

        case .value:
          break
        }

        return view.content
      },
      inputs: inputs
    )
    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      layoutProxies: content.layoutProxies,
      displayList: content.displayList
    )
  }
}
