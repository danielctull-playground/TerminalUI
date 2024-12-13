
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func render(in canvas: Canvas, size: Size) {
    render(in: canvas, size: size, environment: EnvironmentValues())
  }

  func render(in canvas: Canvas, size: Size, environment: EnvironmentValues) {

    environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: canvas, size: size, environment: environment)
    } else {
      body.render(in: canvas, size: size, environment: environment)
    }
  }
}
