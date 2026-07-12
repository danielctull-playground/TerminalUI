import AsyncAlgorithms
@preconcurrency import Dispatch
import Foundation

extension EnvironmentValues {
  @Entry fileprivate(set) var windowSize = Size.zero
}

struct WindowSize: Equatable {
  let size: Size
}

extension WindowSize: Event {

  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.windowSize = size
  }
}

extension WindowSize {

  static func sequence(
    fileHandle: FileHandle = .standardOutput
  ) -> some Sendable & AsyncSequence<WindowSize, Never> {

    var current: WindowSize {
      var winsize = winsize()
      let result = ioctl(fileHandle.fileDescriptor, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowSize(size: size)
    }

    return AsyncStream { continuation in

      let source = DispatchSource.makeSignalSource(signal: SIGWINCH)

      source.setEventHandler {
        continuation.yield(current)
      }

      source.setCancelHandler {
        continuation.finish()
      }

      continuation.onTermination = { _ in
        source.cancel()
      }

      // Send initial window size.
      continuation.yield(current)

      source.resume()
    }
    .removeDuplicates()
  }
}
