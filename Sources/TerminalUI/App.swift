import Logging
import Foundation

#if ENABLE_OSLOG
import OSLogging
#endif

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

  /// Provide an instance of `LogHandler` to use for logging TerminalUI events.
  ///
  /// TerminalUI **does not** invoke `LoggingSystem.bootstrap`, it creates
  /// `Logger` instances directly using `Logger.init(label:factory:)`.
  ///
  /// > Note: There is a default implementation that returns a no-op handler,
  ///         unless the oslog trait is passed.
  ///
  /// - Parameter label: The label for the handler.
  /// - Returns: A log handler for TerminalUI to use.
  func logHandler(for label: String) -> any LogHandler
}

extension App {

  public func logHandler(for label: String) -> any LogHandler {
    #if ENABLE_OSLOG
    OSLogHandler(subsystem: "uk.co.danieltull.terminalui", category: label)
    #else
    SwiftLogNoOpLogHandler()
    #endif
  }
}

extension App {

  public static func main() async {

    let app = Self()
    let rawMode = RawMode()

    let logger = Logger(label: "Event", factory: app.logHandler)

    let renderer = Renderer(
      canvas: TextStreamCanvas(output: .fileHandle(.standardOutput)),
      content: app.body
    )

    @EventStream
    var events: some AsyncSequence<any Event, Never> {

      WindowChange.sequence

      Exit.sequence

      StandardInput()
        .parsing(CSI.self)
    }

    for await event in events {
      logger.info("\(event)")
      renderer.render(event: event)
    }

    _ = consume rawMode
  }
}
