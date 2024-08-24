
struct BuiltinView {

  private let update: (Canvas, EnvironmentValues) -> Void

  init(update: @escaping (Canvas, EnvironmentValues) -> Void) {
    self.update = update
  }

  init(update: @escaping (Canvas) -> Void) {
    self.update = { canvas, _ in update(canvas) }
  }

  func update(canvas: Canvas, environment: EnvironmentValues) {
    update(canvas, environment)
  }
}

extension BuiltinView: View {

  var body: Never {
    fatalError("BuiltinView body should never be called.")
  }
}
