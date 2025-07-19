
public protocol View: BuiltinView {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  public static func _makeView(_ inputs: ViewInputs<Self>) -> ViewOutputs {
//    inputs.environment.install(on: self)
    return Body._makeView(inputs.body)
  }
}

//extension View {
//  package func _size(for proposal: ProposedViewSize) -> Size {
//    _size(for: proposal, environment: EnvironmentValues())
//  }
//
//  package func _size(
//    for proposal: ProposedViewSize,
//    environment: EnvironmentValues
//  ) -> Size {
//
//    environment.install(on: self)
//
//    if let builtin = self as? any Builtin {
//      return builtin.size(for: proposal, environment: environment)
//    } else {
//      return body._size(for: proposal, environment: environment)
//    }
//  }
//
//  func _render(in bounds: Rect, canvas: any Canvas) {
//    _render(in: bounds, canvas: canvas, environment: EnvironmentValues())
//  }
//
//  package func _render(in bounds: Rect, canvas: any Canvas, environment: EnvironmentValues) {
//
//    environment.install(on: self)
//
//    if let builtin = self as? any Builtin {
//      builtin.render(in: bounds, canvas: canvas, environment: environment)
//    } else {
//      body._render(in: bounds, canvas: canvas, environment: environment)
//    }
//  }
//}
