
extension View {

  public func inverse(_ isActive: Bool = true) -> some View {
    environment(\.inverse, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var inverse = Inverse.off
}

struct Inverse: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Inverse(graphicRendition: 7)
  static let off = Inverse(graphicRendition: 27)
}
