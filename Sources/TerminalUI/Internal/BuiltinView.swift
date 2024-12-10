
struct BuiltinView {

  private let render: (Canvas, EnvironmentValues) -> Void

  init(render: @escaping (Canvas, EnvironmentValues) -> Void) {
    self.render = render
  }

  func render(in canvas: Canvas, environment: EnvironmentValues) {
    render(canvas, environment)
  }
}

extension BuiltinView: View {

  var body: Never {
    fatalError("BuiltinView body should never be called.")
  }
}
