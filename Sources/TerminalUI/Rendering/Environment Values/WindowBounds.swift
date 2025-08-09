import Foundation

extension EnvironmentValues {
  var windowSize: Size  {
    get { self[WindowSizeEnvironmentKey.self] }
    set { self[WindowSizeEnvironmentKey.self] = newValue }
  }
}

private struct WindowSizeEnvironmentKey: EnvironmentKey {
  static let defaultValue = Size.zero
}

@MainActor
/// Stores the window size for when getting the window size fails.
///
/// Note: This happens on CI, so this allows the tests to pass there.
private var windowSize = Size.zero

extension Size {

  /// The size of the window of a terminal device.
  @MainActor
  package static var window: Size {
    get {
      var size = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
      guard result == EXIT_SUCCESS else { return windowSize }
      return Size(
        width: Int(size.ws_col),
        height: Int(size.ws_row)
      )
    }
    set {
      windowSize = newValue
      var size = winsize()
      size.ws_col = UInt16(newValue.width)
      size.ws_row = UInt16(newValue.height)
      _ = ioctl(STDOUT_FILENO, UInt(TIOCSWINSZ), &size)
    }
  }
}
