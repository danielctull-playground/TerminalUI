
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  package func _size(for proposal: ProposedSize) -> Size {
    _size(for: proposal, environment: EnvironmentValues())
  }

  package func _size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {

    environment.install(on: self)

    if let builtin = self as? any Builtin {
      return builtin.size(for: proposal, environment: environment)
    } else {
      return body._size(for: proposal, environment: environment)
    }
  }

  package func _render(in canvas: any Canvas, size: Size) {
    _render(in: canvas, size: size, environment: EnvironmentValues())
  }

  package func _render(in canvas: any Canvas, size: Size, environment: EnvironmentValues) {

    environment.install(on: self)

    if let builtin = self as? any Builtin {
      builtin.render(in: canvas, size: size, environment: environment)
    } else {
      body._render(in: canvas, size: size, environment: environment)
    }
  }
}
