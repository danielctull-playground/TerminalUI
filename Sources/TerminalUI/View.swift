
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func _render(in canvas: any Canvas, size: Size) {
    _render(in: canvas, size: size, environment: EnvironmentValues())
  }

  func _render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {

    environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: canvas, size: size, environment: environment)
    } else {
      body._render(in: canvas, size: size, environment: environment)
    }
  }
}
