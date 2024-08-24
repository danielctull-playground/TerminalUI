import Foundation

protocol App {

  func draw(in canvas: inout Canvas)

  /// Creates an instance of the app using the body that you define for its
  /// content.
  ///
  /// Swift synthesizes a default initializer for structures that don't
  /// provide one. You typically rely on the default initializer for
  /// your app.
  init()
}

extension App {

  static func main() {
    let app = Self()
    app.run()
    dispatchMain()
  }

  private func run() {
    var stdout = Output.standard

    stdout.write(ControlSequence.clearScreen)
    stdout.write(AlternativeBuffer.on.control)
    stdout.write(CursorVisibility.off.control)

    var canvas = Canvas(size: .window)
    canvas.clear()
    draw(in: &canvas)
  }
}
