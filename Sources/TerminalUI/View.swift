
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {
  
  func _size(for proposal: ProposedViewSize, canvas: any Canvas) -> Size {
    let inputs = ViewInputs(canvas: canvas, environment: EnvironmentValues())
    return _size(for: proposal, inputs: inputs)
  }

  func _size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {

    inputs.environment.install(on: self)

    if let builtin = self as? any Builtin {
      return builtin.size(for: proposal, inputs: inputs)
    } else {
      return body._size(for: proposal, inputs: inputs)
    }
  }

  func _render(in bounds: Rect, canvas: any Canvas) {
    _render(in: bounds, inputs: ViewInputs(canvas: canvas, environment: EnvironmentValues()))
  }

  func _render(in bounds: Rect, inputs: ViewInputs) {

    inputs.environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: bounds, inputs: inputs)
    } else {
      body._render(in: bounds, inputs: inputs)
    }
  }
}
