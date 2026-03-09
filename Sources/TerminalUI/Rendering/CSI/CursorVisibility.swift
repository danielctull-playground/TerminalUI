
extension CSI {
  static func cursorVisibility(_ value: CursorVisibility) -> Self {
    value.csi
  }
}

struct CursorVisibility {
  fileprivate let csi: CSI
  static let on = CursorVisibility(csi: "?25h")
  static let off = CursorVisibility(csi: "?25l")
}
