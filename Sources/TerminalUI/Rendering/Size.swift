import Foundation

public struct Size {
  let width: Horizontal
  let height: Vertical

  public init(width: Horizontal, height: Vertical) {
    self.width = width
    self.height = height
  }
}

extension Size {

  static var window: Size {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return Size(width: Horizontal(size.ws_col), height: Vertical(size.ws_row))
  }
}
