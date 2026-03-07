@preconcurrency import Dispatch
import Foundation

extension EnvironmentValues {
  @Entry fileprivate(set) var windowSize = Size.zero
}

struct WindowChange {
  let size: Size
}

extension WindowChange: Event {

  static var sequence: some AsyncSequence<WindowChange, any Error> & Sendable {
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH)) {
      var winsize = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowChange(size: size)
    }
    .map(\.self)
  }

  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.windowSize = size
  }
}

extension AsyncStream {
  fileprivate init(
    _ source: any DispatchSourceProtocol,
    _ make: @escaping () -> Element
  ) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(make())
      }
      source.setCancelHandler {
        continuation.finish()
      }
      continuation.onTermination = { _ in
        source.cancel()
      }
      continuation.yield(make()) // Send an initial value.
      source.resume()
    }
  }
}
