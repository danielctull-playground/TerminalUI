
public struct EmptyView: Builtin, View {

  public init() {}

  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size? {
    nil
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
  }
}
