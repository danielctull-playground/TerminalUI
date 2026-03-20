import AsyncAlgorithms
import Dispatch
import Foundation

extension EnvironmentValues {
  @Entry fileprivate(set) var windowSize = Size.zero
}

struct WindowChange: Equatable {
  let size: Size
}

extension WindowChange: Event {

  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.windowSize = size
  }
}

extension WindowChange {

  static func sequence(
    fileHandle: FileHandle = .standardOutput
  ) -> some Sendable & AsyncSequence<WindowChange, Never> {

    chain(
      CollectionOfOne(()).async, // Send initial window size
      AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH))
    )
    .map {
      var winsize = winsize()
      let result = ioctl(fileHandle.fileDescriptor, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowChange(size: size)
    }
    .removeDuplicates()
  }
}
