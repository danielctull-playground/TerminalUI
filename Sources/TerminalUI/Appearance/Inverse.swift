
extension View {

  public func inverse(_ isActive: Bool = true) -> some View {
    environment(\.inverse, isActive ? .on : .off)
  }
}

private struct InverseEnvironmentKey: EnvironmentKey {
  static var defaultValue: Inverse { .off }
}

extension EnvironmentValues {
  fileprivate(set) var inverse: Inverse {
    get { self[InverseEnvironmentKey.self] }
    set { self[InverseEnvironmentKey.self] = newValue }
  }
}

struct Inverse: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Inverse(graphicRendition: 7)
  static let off = Inverse(graphicRendition: 27)
}
