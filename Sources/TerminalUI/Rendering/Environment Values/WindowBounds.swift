import Foundation

extension EnvironmentValues {
  var windowBounds: Rect  {
    get { self[WindowBoundsEnvironmentKey.self] }
    set { self[WindowBoundsEnvironmentKey.self] = newValue }
  }
}

private struct WindowBoundsEnvironmentKey: EnvironmentKey {
  static var defaultValue: Rect { Rect(origin: .origin, size: .zero) }
}

extension Size {

  /// The size of the window of a terminal device.
  static var window: Size {
    get {
      var size = winsize()
      _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
      return Size(
        width: Int(size.ws_col),
        height: Int(size.ws_row)
      )
    }
    set {
      var size = winsize()
      size.ws_col = UInt16(newValue.width)
      size.ws_row = UInt16(newValue.height)
      _ = ioctl(STDOUT_FILENO, UInt(TIOCSWINSZ), &size)
    }
  }
}
