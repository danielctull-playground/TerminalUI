import Foundation

extension Size {

  static var window: Size {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return Size(width: Int(size.ws_col), height: Int(size.ws_row))
  }
}
