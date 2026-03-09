
extension CSI {
  static func alternativeBuffer(_ value: AlternativeBuffer) -> Self {
    value.csi
  }
}

struct AlternativeBuffer {
  fileprivate let csi: CSI
  static let on = AlternativeBuffer(csi: CSI(marker: .questionMark, parameters: 1049, command: "h"))
  static let off = AlternativeBuffer(csi: CSI(marker: .questionMark, parameters: 1049, command: "l"))
}
