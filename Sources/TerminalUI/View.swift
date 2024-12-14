
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func _render(in canvas: Canvas) {
    _render(in: canvas, environment: EnvironmentValues())
  }

  func _render(in canvas: Canvas, environment: EnvironmentValues) {

    environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: canvas, environment: environment)
    } else {
      body._render(in: canvas, environment: environment)
    }
  }
}
