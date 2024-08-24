
extension View {

  public func bold(_ isActive: Bool = true) -> some View {
    environment(\.bold, isActive ? .on : .off)
  }
}

private struct BoldEnvironmentKey: EnvironmentKey {
  static var defaultValue: Bold { .off }
}

extension EnvironmentValues {
  var bold: Bold {
    get { self[BoldEnvironmentKey.self] }
    set { self[BoldEnvironmentKey.self] = newValue }
  }
}

struct Bold: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Bold(sgr: 1)
  static let off = Bold(sgr: 22)
}
