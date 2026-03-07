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
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH)).map { _ in
      var winsize = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowChange(size: size)
    }
  }

  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.windowSize = size
  }
}

extension AsyncStream<Void> {
  fileprivate init(_ source: any DispatchSourceProtocol) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(())
      }
      source.setCancelHandler {
        continuation.finish()
      }
      continuation.onTermination = { _ in
        source.cancel()
      }
      continuation.yield(()) // Send an initial value.
      source.resume()
    }
  }
}
