
extension View {

  public func underline(
    _ isActive: Bool = true,
    style: UnderlineStyle = .single
  ) -> some View {
    environment(\.underline, isActive ? style : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var underline = UnderlineStyle.off
}

public struct UnderlineStyle: Equatable, Sendable {
  let graphicRendition: GraphicRendition
  public static let single = UnderlineStyle(graphicRendition: 4)
  public static let double = UnderlineStyle(graphicRendition: 21)
  static let off = UnderlineStyle(graphicRendition: 24)
}
