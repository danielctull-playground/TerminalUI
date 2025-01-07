import Foundation

extension ProposedSize {

  static var window: ProposedSize {
    var size = winsize()
    _ = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size)
    return ProposedSize(width: Int(size.ws_col), height: Int(size.ws_row))
  }
}
