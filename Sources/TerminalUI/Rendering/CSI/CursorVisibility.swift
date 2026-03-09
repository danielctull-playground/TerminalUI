
extension CSI {
  static func cursorVisibility(_ value: CursorVisibility) -> Self {
    value.csi
  }
}

struct CursorVisibility {
  fileprivate let csi: CSI
  static let on = CursorVisibility(csi: CSI(.questionMark, 25, "h"))
  static let off = CursorVisibility(csi: CSI(.questionMark, 25, "l"))
}
