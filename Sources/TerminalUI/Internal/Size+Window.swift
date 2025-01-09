import Foundation

extension Size {

  static var window: Size {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return Size(width: InfinityInt(size.ws_col), height: InfinityInt(size.ws_row))
  }
}
