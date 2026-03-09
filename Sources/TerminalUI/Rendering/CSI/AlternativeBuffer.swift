
extension CSI {
  static func alternativeBuffer(_ value: AlternativeBuffer) -> Self {
    value.csi
  }
}

struct AlternativeBuffer {
  fileprivate let csi: CSI
  static let on = AlternativeBuffer(csi: CSI(.questionMark, 1049, "h"))
  static let off = AlternativeBuffer(csi: CSI(.questionMark, 1049, "l"))
}
