import AsyncAlgorithms
import Dispatch
import Foundation

extension EnvironmentValues {
  @Entry fileprivate(set) var windowSize = Size.zero
}

struct WindowChange {
  let size: Size
}

extension WindowChange: Event {

  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.windowSize = size
  }
}

extension WindowChange {

  static var sequence: some AsyncSequence<WindowChange, Never> {
    chain(
      CollectionOfOne(()).async, // Send initial window size
      AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH))
    )
    .map { _ in
      var winsize = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowChange(size: size)
    }
  }
}
