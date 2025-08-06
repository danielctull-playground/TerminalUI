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

extension Rect {
  
  /// The bounds of the window of a terminal device.
  static var window: Rect {
    get {
      var size = winsize()
      _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
      return Rect(
        x: Int(size.ws_xpixel),
        y: Int(size.ws_ypixel),
        width: Int(size.ws_col),
        height: Int(size.ws_row)
      )
    }
    set {
      var size = winsize(
        ws_row: UInt16(newValue.size.height),
        ws_col: UInt16(newValue.size.width),
        ws_xpixel: UInt16(newValue.origin.x),
        ws_ypixel: UInt16(newValue.origin.y)
      )
      _ = ioctl(STDOUT_FILENO, UInt(TIOCSWINSZ), &size)
    }
  }
}
