
extension CSI {
  static func cursorVisibility(_ value: CursorVisibility) -> Self {
    value.csi
  }
}

struct CursorVisibility {
  fileprivate let csi: CSI
  static let on = CursorVisibility(csi: CSI(marker: "?", parameters: 25, command: "h"))
  static let off = CursorVisibility(csi: CSI(marker: "?", parameters: 25, command: "l"))
}
