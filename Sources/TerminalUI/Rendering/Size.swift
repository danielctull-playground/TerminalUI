import Foundation

struct Size {
  let width: Horizontal
  let height: Vertical
}

extension Size {

  static var window: Size {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return Size(width: Horizontal(size.ws_col), height: Vertical(size.ws_row))
  }
}
