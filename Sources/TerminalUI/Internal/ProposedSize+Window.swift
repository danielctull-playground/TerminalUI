import Foundation

extension ProposedSize {

  static var window: ProposedSize {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return ProposedSize(width: Horizontal(size.ws_col), height: Vertical(size.ws_row))
  }
}
