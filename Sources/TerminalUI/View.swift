
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func _size(for proposal: ProposedViewSize) -> Size {
    _size(for: proposal, inputs: ViewInputs(environment: EnvironmentValues()))
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

  func _render(in canvas: any Canvas, size: Size) {
    _render(in: canvas, size: size, inputs: ViewInputs(environment: EnvironmentValues()))
  }

  func _render(in canvas: any Canvas, size: Size, inputs: ViewInputs) {

    inputs.environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: canvas, size: size, inputs: inputs)
    } else {
      body._render(in: canvas, size: size, inputs: inputs)
    }
  }
}
