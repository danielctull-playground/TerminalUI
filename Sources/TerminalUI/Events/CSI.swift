
/// Control Sequence Introducer
struct CSI: Equatable, Sendable {
  fileprivate let raw: String
  fileprivate init(_ raw: String) {
    self.raw = raw
  }
}

extension CSI: ExpressibleByStringLiteral {
  init(stringLiteral raw: String) {
    self.init(raw)
  }
}

extension CSI: ExpressibleByStringInterpolation {}

// MARK: - Output

extension TextOutputStream {

  mutating func write(_ csi: CSI) {
    write("\u{1b}[\(csi.raw)")
  }
}
