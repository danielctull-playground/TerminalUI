
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func _makeView() -> ViewOutputs {
    _makeView(inputs: ViewInputs(environment: EnvironmentValues()))
  }

  func _makeView(inputs: ViewInputs) -> ViewOutputs {

    inputs.environment.install(on: self)

    if let builtin = self as? any Builtin {
      return builtin.makeView(inputs: inputs)
    } else {
      return body._makeView(inputs: inputs)
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
