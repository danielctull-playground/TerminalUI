import Foundation

public protocol App {

  /// The type of view representing the body of the app.
  associatedtype Body: View

  /// The content and behavior of the app.
  var body: Body { get }

  /// Creates an instance of the app using the body that you define for its
  /// content.
  ///
  /// Swift synthesizes a default initializer for structures that don't
  /// provide one. You typically rely on the default initializer for
  /// your app.
  init()
}

extension App {

  public static func main() {
    let app = Self()

    let canvas = TextStreamCanvas(output: .fileHandle(.standardOutput))
//    canvas.output.write(ControlSequence.clearScreen)
//    canvas.output.write(AlternativeBuffer.on.control)
//    canvas.output.write(CursorVisibility.off.control)

    canvas.render(size: .window) {
      app.body
    }

//    dispatchMain()
  }
}
