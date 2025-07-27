
extension View {

  public func bold(_ isActive: Bool = true) -> some View {
    environment(\.bold, isActive ? .on : .off)
  }
}

private struct BoldEnvironmentKey: EnvironmentKey {
  static var defaultValue: Bold { .off }
}

extension EnvironmentValues {
  fileprivate(set) var bold: Bold {
    get { self[BoldEnvironmentKey.self] }
    set { self[BoldEnvironmentKey.self] = newValue }
  }
}

struct Bold: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Bold(graphicRendition: 1)
  static let off = Bold(graphicRendition: 22)
}
