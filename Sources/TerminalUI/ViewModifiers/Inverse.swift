
extension View {

  public func inverse(_ isActive: Bool = true) -> some View {
    environment(\.inverse, isActive ? .on : .off)
  }
}

private struct InverseEnvironmentKey: EnvironmentKey {
  static var defaultValue: Inverse { .off }
}

extension EnvironmentValues {
  var inverse: Inverse {
    get { self[InverseEnvironmentKey.self] }
    set { self[InverseEnvironmentKey.self] = newValue }
  }
}

struct Inverse: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Inverse(sgr: 7)
  static let off = Inverse(sgr: 27)
}
