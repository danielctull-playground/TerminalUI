
struct BuiltinView {

  private let render: (Canvas, EnvironmentValues) -> Void

  init(render: @escaping (Canvas, EnvironmentValues) -> Void) {
    self.render = render
  }

  init(render: @escaping (Canvas) -> Void) {
    self.render = { canvas, _ in render(canvas) }
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
