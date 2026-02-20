import Foundation

public protocol App {

  /// The type of view representing the body of the app.
  associatedtype Body: View

  /// The content and behavior of the app.
  @ViewBuilder
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
  @MainActor
  public static func main() async {
    let renderer = Renderer(
      canvas: TextStreamCanvas(output: .fileHandle(.standardOutput)),
      environment: .windowSize,
      content: Self().body
    )

    do {
      for try await event in foo() {
        print(event)
        renderer.render()
      }
    } catch {
      exit(1)
    }
  }
}
