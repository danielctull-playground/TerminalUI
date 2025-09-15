
extension View {

  public func blinking(_ isActive: Bool = true) -> some View {
    environment(\.blinking, isActive ? .on : .off)
  }
}

extension EnvironmentValues {
  @Entry fileprivate(set) var blinking = Blinking.off
}

struct Blinking: Equatable {
  let graphicRendition: GraphicRendition
  static let on = Blinking(graphicRendition: 5)
  static let off = Blinking(graphicRendition: 25)
}
