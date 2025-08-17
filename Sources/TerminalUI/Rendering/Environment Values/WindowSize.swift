import Foundation

extension EnvironmentValues {
  fileprivate(set) var windowSize: Size  {
    get { self[WindowSizeEnvironmentKey.self] }
    set { self[WindowSizeEnvironmentKey.self] = newValue }
  }
}

private struct WindowSizeEnvironmentKey: EnvironmentKey {
  static let defaultValue = Size.zero
}

extension ExternalEnvironment {

  /// Define a value for the window size environment.
  ///
  /// Note: This should be used for testing at different window sizes.
  ///
  /// - Parameter size: The size to use for the window.
  /// - Returns: An external environment definition.
  package static func windowSize(_ size: Size) -> ExternalEnvironment {
    ExternalEnvironment { $0.windowSize = size }
  }

  /// The window size using TIOCGWINSZ.
  static var windowSize: ExternalEnvironment {
    ExternalEnvironment {
      var size = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
      guard result == EXIT_SUCCESS else { return }
      $0.windowSize = Size(
        width: Int(size.ws_col),
        height: Int(size.ws_row)
      )
    }
  }
}
