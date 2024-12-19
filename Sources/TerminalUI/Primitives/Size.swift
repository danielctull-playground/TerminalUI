import Foundation

package struct Size {

  package let width: Horizontal
  package let height: Vertical

  package init(width: Horizontal, height: Vertical) {
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

extension Size {

  /// Creates a size filling the entire proposed amount of space.
  ///
  /// - Parameter proposedSize: The proposed amount of space.
  init(_ proposedSize: ProposedSize) {
    self.init(width: proposedSize.width, height: proposedSize.height)
  }
}
