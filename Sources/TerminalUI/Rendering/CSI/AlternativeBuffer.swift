
extension CSI {
  static func alternativeBuffer(_ value: AlternativeBuffer) -> Self {
    value.csi
  }
}

struct AlternativeBuffer {
  fileprivate let csi: CSI
  static let on = AlternativeBuffer(csi: "?1049h")
  static let off = AlternativeBuffer(csi: "?1049l")
}
