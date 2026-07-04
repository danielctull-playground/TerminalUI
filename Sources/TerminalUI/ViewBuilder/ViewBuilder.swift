
@resultBuilder
public enum ViewBuilder {

  public static func buildBlock() -> some View {
    EmptyView()
  }

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

extension ViewBuilder {

  public static func buildOptional<Content: View>(
    _ optional: Content?
  ) -> Content? {
    optional
  }

  public static func buildEither<First: View, Second: View>(
    first: First
  ) -> ConditionalContent<First, Second> {
    ConditionalContent(first)
  }

  public static func buildEither<First: View, Second: View>(
    second: Second
  ) -> ConditionalContent<First, Second> {
    ConditionalContent(second)
  }

  public static func buildLimitedAvailability(
    _ content: some View
  ) -> some View {
    content
  }
}
