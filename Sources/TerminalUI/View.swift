
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func update(canvas: Canvas) {
    update(canvas: canvas, environment: EnvironmentValues())
  }

  func update(canvas: Canvas, environment: EnvironmentValues) {

    if let builtin = self as? BuiltinView {
      builtin.update(canvas: canvas)
    } else {
      body.update(canvas: canvas, environment: environment)
    }
  }
}
