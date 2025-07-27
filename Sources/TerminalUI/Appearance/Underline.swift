
extension View {

  public func underline(
    _ isActive: Bool = true,
    style: UnderlineStyle = .single
  ) -> some View {
    environment(\.underline, isActive ? style : .off)
  }
}

private struct UnderlineEnvironmentKey: EnvironmentKey {
  static var defaultValue: UnderlineStyle { .off }
}

extension EnvironmentValues {
  fileprivate(set) var underline: UnderlineStyle {
    get { self[UnderlineEnvironmentKey.self] }
    set { self[UnderlineEnvironmentKey.self] = newValue }
  }
}

public struct UnderlineStyle: Equatable, Sendable {
  let graphicRendition: GraphicRendition
  public static let single = UnderlineStyle(graphicRendition: 4)
  public static let double = UnderlineStyle(graphicRendition: 21)
  static let off = UnderlineStyle(graphicRendition: 24)
}
