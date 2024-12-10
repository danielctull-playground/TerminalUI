
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func render(in canvas: Canvas) {
    render(in: canvas, environment: EnvironmentValues())
  }

  func render(in canvas: Canvas, environment: EnvironmentValues) {

    environment.install(on: self)

    if let builtin = self as? BuiltinView {
      builtin.render(in: canvas, environment: environment)
    } else {
      body.render(in: canvas, environment: environment)
    }
  }
}
