import Logging
import Foundation

#if EnableOSLog
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
  ///         unless the "EnableOSLog" trait is used.
  ///
  /// - Parameter label: The label for the handler.
  /// - Returns: A log handler for TerminalUI to use.
  func logHandler(for label: String) -> any LogHandler
}

extension App {

  public func logHandler(for label: String) -> any LogHandler {
    #if EnableOSLog
    OSLogHandler(subsystem: "uk.co.danieltull.terminalui", category: label)
    #else
    SwiftLogNoOpLogHandler()
    #endif
  }
}

extension App {

  /// Instantiates and runs the app.
  ///
  /// > Note: This is marked with `@_disfavoredOverload` to allow conformance to
  ///         ArgumentParser's `AsyncParsableCommand`. In that case, its main()
  ///         function will instantiate the app and call ``App/run()`` instead
  ///         of this one.
  @_disfavoredOverload
  public static func main() async throws {
    try await Self().run()
  }
}

extension App {

  /// Runs the app in a loop until an exit event is received.
  ///
  /// > Note: This informally implements the `AsyncParsableCommand` protocol so
  ///         that the user can depend on the swift-argument-parser package and
  ///         conform their app to both TerminalUI's `App` protocol and
  ///         ArgumentParser's `AsyncParsableCommand`. In doing so, they will be
  ///         able to show a TerminalUI ``View`` with parsed launch arguments.
  public func run() async throws {

    let rawMode = RawMode()

    let logger = Logger(label: "Event", factory: logHandler)

    let renderer = Renderer(
      screen: TextOutputScreen(output: .fileHandle(.standardOutput)),
      content: body
    )

    @EventStream
    var events: some AsyncSequence<any Event, Never> {

      WindowSize.sequence()

      AsyncRead(fileHandle: .standardInput)
        .byteEvents(Exit.self, CSI.self)
        .csiEvents(Mode.Report.self)
        .keyPressEvents
    }

    for await event in events {
      logger.info("\(event)")

      if event is Exit { break }

      renderer.render(event: event)
    }

    _ = consume rawMode
  }
}
