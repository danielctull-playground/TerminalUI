
@resultBuilder
public enum ViewBuilder {

  public static func buildPartialBlock(
    first: some View
  ) -> some View {
    first
  }

  public static func buildPartialBlock(
    accumulated: some View,
    next: some View
  ) -> some View {
    Accumulated(accumulated, next)
  }
}
