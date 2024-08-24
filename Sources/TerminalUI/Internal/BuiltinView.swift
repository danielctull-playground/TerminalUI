
struct BuiltinView {

  private let update: (Canvas) -> Void

  init(update: @escaping (Canvas) -> Void) {
    self.update = update
  }

  func update(canvas: Canvas) {
    update(canvas)
  }
}

extension BuiltinView: View {

  var body: some View {
    fatalError("BuiltinView body should never be called.")
  }
}
